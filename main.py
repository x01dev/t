from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware   # NEW
from pydantic import BaseModel
import requests, os

app = FastAPI()

# ------------- CORS: allow every origin -------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],        # or ["https://en.wikipedia.org"] for stricter
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# ------------- end CORS -------------

OLLAMA = "http://localhost:11434"

class Query(BaseModel):
    prompt: str
    model: str = "llama3.1:8b"

@app.post("/answer")
def answer(q: Query):
    r = requests.post(f"{OLLAMA}/api/generate",
                      json={"model": q.model, "prompt": q.prompt, "stream": False},
                      timeout=60)
    r.raise_for_status()
    return {"answer": r.json()["response"]}
