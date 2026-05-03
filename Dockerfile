FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    unzip \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app/

RUN chmod +x start.sh

EXPOSE 10000

CMD ["./start.sh"]
