## 10) Implementation Strategy (Phased)

### Phase 0 – Scaffold
- Create monorepo structure
- Initialize Next.js and FastAPI apps
- Add Dockerfile for API
- Implement basic contact form flow
- **Done when:** All acceptance criteria in [docs/step-0.md § Definition of Done](../docs/step-0.md#definition-of-done-step-0) are met. Do not mark Phase 0 complete until then.

### Phase 1 – Cloud foundation
- Terraform: RG, ACR, Container Apps, Key Vault, App Insights
- Deploy API container
- **Done when:** All acceptance criteria in [docs/phase-1.md § Definition of Done](../docs/phase-1.md#definition-of-done-phase-1) are met. Do not mark Phase 1 complete until then.

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