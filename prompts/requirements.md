# BrandonBuster.com – Requirements & Delivery Strategy

## 1) Objectives

### Primary goals
- Build a **static brochure-ware personal site** that doubles as a **featured engineering artifact** demonstrating:
  - Cloud architecture fundamentals (edge, security, observability, IaC, CI/CD, multi-env promotion)
  - Production-grade engineering habits (testing, linting, deployments, least privilege, documentation)

### Non-goals (initial release)
- No complex auth, user accounts, payments, or dynamic content system required.
- No heavy data store required (contact submissions can go to email/CRM directly).

---

## 2) Functional Requirements

### Site pages (required)
1. **Homepage**
   - Value proposition / positioning (Platform, Data, Infrastructure leadership)
   - Highlight metrics, domains, and credibility signals
   - CTAs: Portfolio, Contact, Resume

2. **About**
   - Leadership narrative and background
   - Skills and domain focus (platform engineering, data platforms, reliability, compliance)
   - Optional: operating principles or leadership philosophy

3. **Portfolio**
   - Card/grid layout of projects
   - Each item includes: title, summary, tags, links (repo, demo, writeup)
   - One featured item must document **this site’s architecture and tradeoffs**

4. **Contact**
   - Contact form: name, email, message
   - Spam mitigation and rate limiting
   - Submission delivered to email and optionally CRM

### Optional but recommended
- Dedicated **Architecture** page or portfolio entry containing:
  - High-level architecture diagram
  - Component breakdown
  - Security and observability posture
  - Cost notes and tradeoffs

---

## 3) Non-Functional Requirements

### Performance / SEO
- Server-side rendering or static pre-rendering for SEO
- Clean URLs (`/about`, `/portfolio`, `/contact`)
- Optimized images, fast TTFB, accessible markup

### Security
- HTTPS everywhere
- No secrets in source control
- Azure Key Vault for secret storage
- Managed Identity for service access
- GitHub Actions authenticated via OIDC (no static credentials)
- Edge protection via WAF

### Reliability / Operations
- Centralized logging and tracing
  - Application Insights for backend
  - Log Analytics workspace
- Alerts for availability and error thresholds
- Separate environments: **dev** and **prod** (stage optional)

### Maintainability
- Terraform-based infrastructure
- Automated formatting and validation in CI
- Clear documentation for local dev and deployment
- Every file change should get its own git commit

---

## 4) Technical Architecture Requirements (Azure)

### Frontend
- **Next.js (React)** for SEO, routing, and performance
- Content managed via Markdown/MDX in-repo (initially)
- Hosting options:
  - Preferred: **Azure Static Web Apps**
  - Alternative: Azure Storage Static Website

### Backend (Python)
- **FastAPI** application
- Initial endpoint:
  - `POST /api/contact`
- Responsibilities:
  - Input validation
  - Rate limiting (enforced primarily at gateway/edge)
  - Email delivery (SendGrid)
  - Optional CRM forwarding (HubSpot)

### Edge / Networking
- **Azure Front Door Premium**
- **WAF policy** applied globally
- Routing rules:
  - `/` → frontend
  - `/api/*` → API gateway

### API Gateway
- **Azure API Management (APIM)**
- Responsibilities:
  - Throttling and rate limits
  - Request/response normalization
  - Request size limits

### Compute
- **Azure Container Apps** hosting FastAPI container
- Autoscaling enabled
- Managed identity assigned

### Secrets and Identity
- **Azure Key Vault** for API keys and tokens
- Access via managed identity only

### Observability
- Application Insights integrated with FastAPI
- Log Analytics workspace
- Alerts provisioned via Terraform

### DNS
- **Azure DNS** for domain management
- Front Door-managed TLS certificates

---

## 5) Infrastructure as Code (Terraform)

### Terraform baseline
- Remote state in Azure Storage Account
- State isolation per environment (dev/prod)
- Environment-specific naming conventions

### Recommended Terraform structure
```
infra/
  envs/
    dev/
    prod/
  modules/
    frontdoor_waf/
    static_site/
    apim/
    container_app_api/
    key_vault/
    observability/
    dns/
```

### Terraform must provision
- Resource groups
- Static hosting
- Front Door + WAF
- API Management
- Container Apps environment and app
- Key Vault and access policies
- Application Insights and Log Analytics
- Alerts
- DNS records

---

## 6) CI/CD Requirements (GitHub Actions)

### Authentication
- Use GitHub OIDC to authenticate to Azure
- No long-lived secrets

### Pull Request pipeline
- Frontend: install, lint, test, build
- Backend: lint, test, container build validation
- Terraform: fmt, validate, plan
- Post Terraform plan summary to PR

### Main branch pipeline
- Automatic deploy to **dev**
- Manual approval gate for **prod**
- Terraform apply per environment
- Frontend and API deployment

### Artifact registry
- **Azure Container Registry (ACR)** for backend images

---

## 7) Repository Structure (Monorepo)

```
/apps/web      # Next.js frontend
/apps/api      # FastAPI backend
/infra         # Terraform
/docs          # Architecture docs, diagrams, ADRs
/.github       # CI/CD workflows
```

---

## 8) Local Development

### Frontend
- Run with `npm run dev`

### Backend
- Run with `uvicorn main:app --reload`

### Environment configuration
- `.env.local` files for local dev (gitignored)
- `.env.example` committed

---

## 9) Definition of Done (V1)

- All required pages implemented
- Contact form functional in dev and prod
- Front Door routes frontend and API correctly
- WAF enabled
- Observability and alerts active
- Terraform fully provisions dev and prod
- CI/CD pipelines operational
- Architecture documentation committed