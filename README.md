# BrandonBuster.com

Static brochure site + API. See **requirements.md** and **roadmap.md** in `/prompts`. Step 0: **docs/step-0.md**. Phase 1: **docs/phase-1.md**.

## Local development (Step 0)

### Backend (FastAPI)

```bash
cd apps/api
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
```

API: http://localhost:8000 — docs: http://localhost:8000/docs

### Frontend (Next.js)

```bash
cd apps/web
npm install
npm run dev
```

Web: http://localhost:3000. Contact form at `/contact` posts to the API (set `NEXT_PUBLIC_API_URL` in `.env.local` if the API is not on port 8000).

### API container (optional)

```bash
cd apps/api
docker build -t brandonbuster-api .
docker run -p 8000:8000 brandonbuster-api
```

## Phase 1 – Deploy API to Azure

Terraform in **infra/envs/dev** (and **prod**) provisions RG, ACR, Key Vault, App Insights, and Container Apps. To build, push, and run the API in Azure, see **infra/README.md** (bootstrap, apply, deploy API container).
