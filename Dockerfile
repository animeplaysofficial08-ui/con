FROM python:3.12-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create user (optional but safe)
RUN useradd -m -u 1000 user
USER user
WORKDIR /home/user

# Copy all files from repo
COPY --chown=user:user . /home/user/

# Make start script executable
RUN chmod +x /home/user/start.sh

# Expose port for Render
EXPOSE 10000

# Start the script
ENTRYPOINT ["/home/user/start.sh"]
