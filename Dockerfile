FROM ollama/ollama:latest
EXPOSE 8000
COPY . /app
WORKDIR /app
RUN apt-get update && apt-get install -y python3-pip
RUN pip3 install fastapi uvicorn requests
ENV OLLAMA_HOST=0.0.0.0
ENV PYTHONUNBUFFERED=1
CMD sh -c "ollama serve & \
           sleep 8 && \
           ollama pull llama3.1:8b && \
           uvicorn main:app --host 0.0.0.0 --port 8000"
