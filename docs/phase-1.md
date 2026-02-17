# Phase 1 – Cloud foundation

Phase 1 establishes Azure core infrastructure and deploys the API container. It is tied to **roadmap.md** Phase 1 and **requirements.md** Sections 3 (Security, Reliability), 4 (Compute, Secrets, Observability), and 5 (Terraform).

---

## Traceability

| Source | Reference |
|--------|-----------|
| **roadmap.md** | Phase 1: Terraform (RG, ACR, Container Apps, Key Vault, App Insights); Deploy API container |
| **requirements.md** Section 3 | Security: Key Vault, Managed Identity; Reliability: logging, alerts, dev/prod |
| **requirements.md** Section 4 | Compute: Container Apps, ACR; Secrets: Key Vault, managed identity; Observability: App Insights, Log Analytics, Alerts |
| **requirements.md** Section 5 | Terraform: remote state, env isolation, naming; provision RG, Container Apps, Key Vault, App Insights, Log Analytics, Alerts |
  
*Static hosting, Front Door, APIM, DNS are Phase 2.*

---

## Implementation Checklist

Use this checklist to implement or verify Phase 1. Each item is traceable to the sources above.

### 1. Terraform structure and state

- [X] **1.1** `infra/envs/dev/` and `infra/envs/prod/` exist with environment-specific config  
  _→ requirements Section 5_
- [X] **1.2** Remote state in Azure Storage **or** local state with bootstrap steps documented (see infra/README.md); state key per environment when remote (e.g. `dev.terraform.tfstate`, `prod.terraform.tfstate`)  
  _→ requirements Section 5_
- [X] **1.3** Naming conventions use prefix/environment (e.g. `bb-dev-rg`, `bb-prod-rg`)  
  _→ requirements Section 5_

### 2. Resource group and ACR

- [X ] **2.1** Terraform provisions resource group(s) per environment  
  _→ requirements Section 5_
- [X] **2.2** Azure Container Registry (ACR) provisioned; API image can be pushed  
  _→ requirements Sections 4, 6 (Artifact registry)_

### 3. Key Vault and identity

- [X] **3.1** Key Vault provisioned per environment  
  _→ requirements Sections 3, 4_
- [ ] **3.2** Access via managed identity only (no static keys in Terraform for app access)  
  _→ requirements Sections 3, 4_  
  **How to confirm:** (1) In Terraform, the Container App has no env vars or secrets that pass a Key Vault key, connection string, or client secret to the container. (2) Key Vault access is granted only via `azurerm_key_vault_access_policy` using the API’s **user-assigned identity** `principal_id` (and optionally Terraform’s `object_id` for bootstrap)—no static keys. (3) At runtime the app uses managed identity (e.g. `DefaultAzureCredential`) to obtain tokens for Key Vault; no secret is stored in config.
- [ ] **3.3** Container App has managed identity assigned  
  _→ requirements Section 4_

### 4. Observability

- [ ] **4.1** Log Analytics workspace provisioned  
  _→ requirements Sections 3, 4, 5_
- [ ] **4.2** Application Insights provisioned and linked to Log Analytics (and Container App)  
  _→ requirements Sections 3, 4, 5_
- [ ] **4.3** Alerts provisioned (e.g. availability, error threshold)  
  _→ requirements Sections 3, 5_

### 5. Container Apps

- [ ] **5.1** Container Apps Environment provisioned  
  _→ requirements Section 4_
- [ ] **5.2** Container App (API) provisioned; image from ACR; autoscaling enabled  
  _→ requirements Section 4_
- [ ] **5.3** API container runs and responds (e.g. GET /docs or health)  
  _→ roadmap: Deploy API container_

### 6. Deploy API container

- [ ] **6.1** Build API image and push to ACR (manual or script; CI/CD is Phase 3)  
  _→ roadmap_
- [ ] **6.2** Container App uses the image; FQDN or default URL is documented  
  _→ roadmap_

### 7. Documentation and commits

- [ ] **7.1** Deploy steps (build, push, Terraform apply) documented in README or docs  
  _→ requirements Section 8_
- [ ] **7.2** Each file change committed in its own git commit  
  _→ requirements Section 3 (Maintainability)_

---

## Definition of Done (Phase 1)

Phase 1 is **complete** only when all of the following are true.

### Measurable acceptance criteria

1. **Terraform**  
   - `infra/envs/dev` and `infra/envs/prod` have Terraform that runs without errors (`terraform init`, `terraform validate`, `terraform plan`).  
   - Remote state is configured, **or** local state is used with bootstrap steps documented (infra/README.md).  
   - Naming is environment-specific.

2. **Resources provisioned (dev at minimum)**  
   - Resource group, ACR, Key Vault, Log Analytics workspace, Application Insights, Container Apps Environment, Container App (API) exist in Azure for dev.  
   - Container App has managed identity; Key Vault access is via managed identity only.

3. **API running in Azure**  
   - API image is built and pushed to ACR.  
   - Container App runs the image and responds (e.g. 200 on a health or /docs endpoint).

4. **Observability**  
   - Application Insights and Log Analytics are provisioned; at least one alert is defined (e.g. failure or availability).

5. **Docs and process**  
   - Steps to deploy the API (build, push, apply) are documented.  
   - Commits follow the rule: one commit per file change (per NFR).

### Marking Phase 1 complete in roadmap.md

- Only when the above criteria are satisfied, mark **Phase 1 – Cloud foundation** as complete in `roadmap.md`.  
- Do not change the scope or wording of Phase 0, 2, 3, or 4.

---

## TODOs / Open questions

- **Remote state bootstrap:** Creating the Azure Storage Account and container for Terraform state is often done once (bootstrap). Add a short doc or script if needed; otherwise document manual steps.
- **SendGrid / secrets:** Phase 1 can provision Key Vault and grant the Container App access; populating secrets (e.g. SendGrid key) can be manual or a separate small task.
- **Static site:** Frontend static hosting is Phase 2; Phase 1 focuses on API in Container Apps.
