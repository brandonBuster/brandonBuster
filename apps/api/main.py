"""
FastAPI backend – contact API.
Requirements §2 (Contact), §4 (Backend). Step 0: validation only; email delivery is Phase 1+.
"""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr

app = FastAPI(title="BrandonBuster API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ContactPayload(BaseModel):
    name: str
    email: EmailStr
    message: str


@app.get("/")
def root():
    return {"service": "api", "docs": "/docs"}


@app.post("/api/contact")
def contact(payload: ContactPayload):
    # TODO: Phase 1+ – SendGrid email delivery; no secrets in repo (requirements §3, §4).
    # For Step 0 we only validate and return success.
    return {"ok": True, "message": "Received (email delivery not yet implemented)"}
