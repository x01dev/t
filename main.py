from fastapi import FastAPI
from pydantic import BaseModel
import requests, os

app = FastAPI()

OLLAMA = "http://localhost:11434"   # Ollama runs inside the same container

class Query(BaseModel):
    prompt: str
    model : str = "llama3.1:8b"     # 8b = small enough for free 512 MB RAM

@app.post("/answer")
def answer(q: Query):
    r = requests.post(f"{OLLAMA}/api/generate",
                      json={"model": q.model,
                            "prompt": q.prompt,
                            "stream": False},
                      timeout=60)
    r.raise_for_status()
    return {"answer": r.json()["response"]}
