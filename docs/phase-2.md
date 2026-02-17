# Phase 2 – Edge and gateway

Phase 2 adds Azure Front Door, WAF, custom domain routing, and (optionally) APIM and static frontend hosting. It is tied to **roadmap.md** Phase 2 and **requirements.md** Sections 3 (Security: WAF), 4 (Edge, API Gateway, DNS), and 5 (Terraform).

---

## Traceability

| Source | Reference |
|--------|-----------|
| **roadmap.md** | Phase 2: Add APIM; Add Front Door + WAF; Configure routing and custom domain |
| **requirements.md** Section 3 | Security: Edge protection via WAF; HTTPS everywhere |
| **requirements.md** Section 4 | Edge: Azure Front Door Premium, WAF, routing `/` → frontend, `/api/*` → API; APIM: throttling, rate limits; DNS: Azure DNS, Front Door–managed TLS |
| **requirements.md** Section 5 | Terraform: Front Door, WAF, APIM, static hosting, DNS records |

---

## Implementation Checklist

Use this checklist to implement or verify Phase 2. Order is suggested; dependencies noted.

### 1. Front Door and WAF

- [ ] **1.1** Front Door profile (Standard or Premium) provisioned in prod  
  _→ requirements Section 4 (Edge)_
- [ ] **1.2** WAF policy attached to Front Door (managed ruleset, e.g. Microsoft_DefaultRuleSet)  
  _→ requirements Section 3 (WAF)_
- [ ] **1.3** Front Door endpoint hostname documented (e.g. `*.azurefd.net`) for DNS  
  _→ requirements Section 4 (DNS)_

### 2. Origins and routing

- [ ] **2.1** Origin group and origin pointing at Container App (API) FQDN  
  _→ requirements Section 4 (routing)_
- [ ] **2.2** Route(s) configured: e.g. `/api/*` → API origin; default or `/` → frontend (when static site exists)  
  _→ requirements Section 4_
- [ ] **2.3** Caching behavior set (e.g. disable cache for `/api/*`)  
  _→ requirements Section 4_

### 3. Custom domain and TLS

- [ ] **3.1** Custom domains (e.g. `brandonbuster.com`, `www.brandonbuster.com`) added to Front Door  
  _→ requirements Section 4 (DNS)_
- [ ] **3.2** TLS/HTTPS: Front Door–managed certificate or custom certificate; HTTPS redirect enabled  
  _→ requirements Section 3 (HTTPS everywhere)_
- [ ] **3.3** DNS: www CNAME and apex (A/ALIAS or CNAME flattening) point to Front Door  
  _→ requirements Section 4 (DNS); update infra/envs/prod/dns.tf_

### 4. API Management (APIM) – optional for initial Phase 2

- [ ] **4.1** APIM instance provisioned (consumption or dedicated)  
  _→ roadmap; requirements Section 4_
- [ ] **4.2** API defined in APIM with backend = Container App (or Front Door)  
  _→ requirements Section 4 (throttling, rate limits)_
- [ ] **4.3** Front Door route `/api/*` → APIM (instead of direct to Container App) if using APIM  
  _→ requirements Section 4_

### 5. Static frontend (optional for initial Phase 2)

- [ ] **5.1** Static Web App or Storage static site provisioned for Next.js build  
  _→ requirements Section 4 (Frontend hosting)_
- [ ] **5.2** Front Door route `/` (and non-/api paths) → static origin  
  _→ requirements Section 4_

### 6. Documentation and verification

- [ ] **6.1** Phase 2 steps (Front Door, DNS, custom domain) documented in README or docs  
  _→ requirements Section 5_
- [ ] **6.2** `https://brandonbuster.com` and `https://www.brandonbuster.com` resolve and reach the app (or appropriate backend)  
  _→ Definition of Done_

---

## Definition of Done (Phase 2)

Phase 2 is **complete** when the following are true (minimal: Front Door + WAF + custom domain + routing to API).

### Measurable acceptance criteria

1. **Front Door and WAF**  
   - Front Door profile exists; WAF policy attached with at least one managed ruleset.  
   - Front Door endpoint hostname is known and used in DNS.

2. **Routing**  
   - At least one route sends traffic to the API (Container App or via APIM).  
   - `/api/*` (or equivalent) reaches the FastAPI app; HTTPS works.

3. **Custom domain and DNS**  
   - `brandonbuster.com` and `www.brandonbuster.com` are added to Front Door.  
   - DNS (www CNAME and apex) points to Front Door.  
   - HTTPS is enforced (Front Door–managed or custom cert).

4. **Verification**  
   - `https://www.brandonbuster.com` (and optionally `https://brandonbuster.com`) returns the expected response (e.g. API or frontend).

APIM and static frontend can be added in Phase 2 or deferred; the above criteria do not require them.

### Marking Phase 2 complete in roadmap.md

- When the above criteria are satisfied, mark **Phase 2 – Edge and gateway** as complete in `prompts/roadmap.md`.

---

## TODOs / Open questions

- **Front Door SKU:** Requirements specify Premium for WAF; Standard supports WAF in some regions. Choose Premium for full WAF and custom domain features.
- **Apex record:** Azure DNS supports CNAME-like behavior for apex via ALIAS or CNAME flattening; Front Door docs describe the recommended record type for apex.
- **APIM vs direct:** Phase 2 can route Front Door → Container App directly, then add APIM in front of the API in a follow-up step.
