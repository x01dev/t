# ---- 1. use Ubuntu base that already has python3 ----
FROM ubuntu:22.04

# ---- 2. install Ollama + Python in one layer ----
RUN apt-get update && \
    apt-get install -y curl python3 python3-pip && \
    curl -fsSL https://ollama.com/install.sh | sh && \
    rm -rf /var/lib/apt/lists/*

# ---- 3. python deps ----
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# ---- 4. app code ----
COPY . /app
WORKDIR /app

# ---- 5. expose & start ----
EXPOSE 8000
CMD ["sh", "-c", "ollama serve & \
                  sleep 10 && \
                  ollama pull llama3.1:8b && \
                  uvicorn main:app --host 0.0.0.0 --port 8000"]
