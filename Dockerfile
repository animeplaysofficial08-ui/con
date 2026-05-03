FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 user
USER user
WORKDIR /home/user

COPY --chown=user:user . /home/user/

RUN chmod +x /home/user/start.sh

EXPOSE 10000

ENTRYPOINT ["/home/user/start.sh"]
