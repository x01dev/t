FROM ollama/ollama:latest

# 1. install Python + pip (missing in base image)
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# 2. copy app code
COPY . /app
WORKDIR /app

# 3. install Python deps
RUN pip3 install --no-cache-dir fastapi uvicorn requests

# 4. expose port
EXPOSE 8000

# 5. start both services
CMD ["sh", "-c", "ollama serve & \
                  sleep 8 && \
                  ollama pull llama3.1:8b && \
                  uvicorn main:app --host 0.0.0.0 --port 8000"]
