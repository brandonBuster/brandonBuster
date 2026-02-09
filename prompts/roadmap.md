## 10) Implementation Strategy (Phased)

### Phase 0 – Scaffold
- Create monorepo structure
- Initialize Next.js and FastAPI apps
- Add Dockerfile for API
- Implement basic contact form flow

### Phase 1 – Cloud foundation
- Terraform: RG, ACR, Container Apps, Key Vault, App Insights
- Deploy API container

### Phase 2 – Edge and gateway
- Add APIM
- Add Front Door + WAF
- Configure routing and custom domain

### Phase 3 – CI/CD
- GitHub Actions for PR and main
- Environment promotion and approvals

### Phase 4 – Polish
- Portfolio content
- Architecture writeup
- Performance, SEO, and observability tuning