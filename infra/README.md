# Infrastructure (Terraform)

Phase 1 layout: **envs/dev** and **envs/prod** each provision RG, ACR, Key Vault, Log Analytics, Application Insights, Container Apps Environment, API Container App, and alerts. See **docs/phase-1.md** for the checklist and Definition of Done.

## Prerequisites

- Azure CLI (`az`) logged in: `az login`
- Terraform >= 1.5
- (Optional) Docker for building and pushing the API image

## Remote state (bootstrap, one-time)

Requirements §5: state in Azure Storage, one key per environment.

1. Create a resource group and storage account for state (e.g. `bb-tfstate-rg`, `bbtfstate`).
2. Create a container in that account, e.g. `tfstate`.
3. In **envs/dev/backend.tf** and **envs/prod/backend.tf**, uncomment the `backend "azurerm"` block and set `resource_group_name`, `storage_account_name`, `container_name`. Use key `dev.terraform.tfstate` and `prod.terraform.tfstate` respectively.
4. Run `terraform init -backend-config=...` if you use a `.tfvars` for backend.

Until then, Terraform uses local state (fine for trying things out; not for team/production).

## Apply (dev)

```bash
cd infra/envs/dev
terraform init
terraform plan
terraform apply
```

To use the **API image from this repo** (instead of the default placeholder):

1. Build and push the API image to the dev ACR (see [Deploy API container](#deploy-api-container) below).
2. Re-apply with overrides:
   ```bash
   terraform apply -var="container_app_api_image=<acr>.azurecr.io/api:latest" -var="container_app_api_port=8000"
   ```
   Or set in **envs/dev/dev.tfvars** and run `terraform apply -var-file=dev.tfvars`.

## Deploy API container (Phase 1)

After `terraform apply` for dev:

1. **Login to ACR**
   ```bash
   az acr login --name <acr_name>
   ```
   `<acr_name>` is in Terraform output `acr_name` (e.g. `bbdevacr`).

2. **Build and push**
   From repo root:
   ```bash
   docker build -t <acr_login_server>/api:latest ./apps/api
   docker push <acr_login_server>/api:latest
   ```
   `<acr_login_server>` is Terraform output `acr_login_server` (e.g. `bbdevacr.azurecr.io`).

3. **Update Container App to use the new image**
   ```bash
   cd infra/envs/dev
   terraform apply -var="container_app_api_image=<acr_login_server>/api:latest" -var="container_app_api_port=8000"
   ```

4. **Verify**
   Open `https://<container_app_api_fqdn>` (from Terraform output). You should see the FastAPI app (e.g. `/docs`).

CI/CD (GitHub Actions) will automate build/push and apply in Phase 3.

## Prod

Same as dev; use **envs/prod** and ensure you have separate state (different backend key). Prefer manual approval before `terraform apply` in prod (Phase 3 will add a gate).

## Modules (Phase 2+)

Requirements §5 recommends **modules/** (frontdoor_waf, static_site, apim, container_app_api, key_vault, observability, dns). Phase 1 inlines resources in **envs/dev** and **envs/prod** for simplicity. Refactor into shared modules when adding Front Door, APIM, and static site.
