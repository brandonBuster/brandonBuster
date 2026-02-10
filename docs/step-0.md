# Step 0 – Scaffold (Phase 0)

Step 0 establishes the monorepo and runnable frontend/backend with a basic contact form flow. It is directly tied to **roadmap.md** Phase 0 and **requirements.md** §§ 2 (Contact), 7 (Repository Structure), and 8 (Local Development).

---

## Traceability

| Source | Reference |
|--------|-----------|
| **roadmap.md** | Phase 0 – Scaffold: monorepo structure, Next.js + FastAPI init, API Dockerfile, basic contact form flow |
| **requirements.md §2** | Contact: form (name, email, message); API `POST /api/contact`; validation |
| **requirements.md §7** | Monorepo: `/apps/web`, `/apps/api`, `/infra`, `/docs`, `/.github` |
| **requirements.md §8** | Frontend: `npm run dev`; Backend: `uvicorn main:app --reload`; `.env.example` committed, `.env.local` gitignored |

---

## Implementation Checklist

Use this checklist to implement or verify Step 0. Each item is traceable to the sources above.

### 1. Monorepo structure

- [x] **1.1** Root folders exist: `apps/web`, `apps/api`, `infra`, `docs`, `.github`  
  _→ requirements.md §7_

### 2. Frontend (Next.js)

- [x] **2.1** Next.js app under `apps/web` with `package.json`, runnable via `npm run dev`  
  _→ roadmap Phase 0; requirements §8_
- [x] **2.2** Clean URLs supported (e.g. `/contact`)  
  _→ requirements §3 (SEO)_
- [x] **2.3** Contact page with form fields: name, email, message  
  _→ requirements §2 (Contact)_
- [x] **2.4** Form submits to API (`POST /api/contact`); target URL configurable via env (e.g. `NEXT_PUBLIC_API_URL`)  
  _→ requirements §2, §8_
- [x] **2.5** `.env.example` in `apps/web` committed; `.env.local` in `.gitignore`  
  _→ requirements §8_

### 3. Backend (FastAPI)

- [x] **3.1** FastAPI app under `apps/api` with `POST /api/contact`  
  _→ roadmap Phase 0; requirements §2, §4 (Backend)_
- [x] **3.2** Request body validated (name, email, message); appropriate status codes (e.g. 200, 422)  
  _→ requirements §4 (Input validation)_
- [x] **3.3** Runnable locally with `uvicorn main:app --reload`  
  _→ requirements §8_
- [x] **3.4** `.env.example` in `apps/api` committed; `.env.local` (or equivalent) gitignored  
  _→ requirements §8_
- [x] **3.5** TODO or stub for email delivery (SendGrid); no secrets in repo  
  _→ requirements §2, §3 (Security)_

### 4. API container

- [x] **4.1** Dockerfile for the API present (e.g. under `apps/api/`)  
  _→ roadmap Phase 0_
- [x] **4.2** Image builds successfully (`docker build` in API directory)  
  _→ prerequisite for Phase 1_

### 5. Infra and CI placeholders (minimal)

- [x] **5.1** `infra/` has placeholder structure or README (e.g. `envs/dev`, `envs/prod`, `modules/` or note that Terraform is Phase 1)  
  _→ requirements §5 (Terraform structure); no full Terraform in Step 0_
- [x] **5.2** `.github/workflows/` exists or is documented as Phase 3  
  _→ requirements §6, §7; CI/CD is Phase 3_

### 6. Documentation

- [x] **6.1** This file (`docs/step-0.md`) exists and checklist is traceable to requirements and roadmap  
  _→ deliverable_
- [x] **6.2** Brief local dev instructions (how to run web + api) in README or `docs/`  
  _→ requirements §8 (Clear documentation for local dev)_

---

## Definition of Done (Step 0)

Step 0 is **complete** only when all of the following are true. Use these to gate marking Phase 0 complete in `roadmap.md`.

### Measurable acceptance criteria

1. **Monorepo**  
   All of these exist: `apps/web`, `apps/api`, `infra`, `docs`, `.github` (or equivalent placeholder).

2. **Frontend runs**  
   From repo root (or `apps/web`), `npm install` and `npm run dev` succeed and the app is reachable (e.g. http://localhost:3000).

3. **Backend runs**  
   From `apps/api`, `uvicorn main:app --reload` (or equivalent) succeeds and `GET /docs` (or health) is reachable (e.g. http://localhost:8000).

4. **Contact form flow**  
   - Contact page loads with name, email, and message fields.  
   - Submitting the form sends a `POST` request to `/api/contact` (or configured API base URL) with JSON `{ "name", "email", "message" }`.  
   - API returns 200 for valid payloads and 4xx for invalid (e.g. 422 validation error).  
   - No requirement yet for actual email delivery (can be stub/TODO).

5. **API container**  
   `docker build` for the API (from `apps/api` or path specified in Dockerfile) completes without error.

6. **Env and secrets**  
   `.env.example` is committed for web and api; no secrets in source; `.env.local` (or equivalent) is in `.gitignore`.

7. **Docs**  
   `docs/step-0.md` exists with this checklist and Definition of Done; README or docs describe how to run frontend and backend locally.

### Marking Phase 0 complete in roadmap.md

- Only when the above criteria are satisfied, mark **Phase 0 – Scaffold** as complete in `roadmap.md` (e.g. checkbox or “Done”).
- Do not change the scope or wording of Phase 1–4.

---

## TODOs / Open questions

- **Email delivery:** SendGrid integration is out of scope for Step 0; implement in a later phase. Use stub or TODO in `POST /api/contact`.
- **Rate limiting / spam:** Requirements §2 call for spam mitigation and rate limiting; these are better handled at edge/APIM (Phase 2). Step 0 only needs validation and a working request/response flow.
- **Terraform:** No Terraform in Step 0; Phase 1 provisions cloud resources. Infra folder can be empty or contain a short README pointing to Phase 1.
- **CI/CD:** No workflows required for Step 0; Phase 3 adds GitHub Actions.
