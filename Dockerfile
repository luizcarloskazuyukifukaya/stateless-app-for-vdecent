FROM python:3.12-slim

WORKDIR /app

# Install wget for healthchecks
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .
COPY static ./static

ENV PORT=80
EXPOSE 80

CMD ["python", "main.py"]
