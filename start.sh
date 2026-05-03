#!/bin/bash

echo "===== AUTO SYSTEM START ====="
echo "Current Directory: $(pwd)"

# Install system dependencies
apt-get update && apt-get install -y unzip gcc python3-dev

# Setup venv
python -m venv venv
source venv/bin/activate
pip install --upgrade pip

# Install libraries
echo "Installing Pyrogram + dependencies..."
pip install pyrogram tgcrypto motor python-dotenv

# Extract zips
echo "Extracting zips..."
unzip -o mainepisode.zip
unzip -o post.zip

# Fix directory structure (important!)
mv mainepisode/* ./ 2>/dev/null || true
mv smilepost/* ./ 2>/dev/null || true
mv post/* ./ 2>/dev/null || true

# Start First Bot
echo "Starting Main Episode Bot..."
cd mainepisode 2>/dev/null || cd . 
if [ -f "requirements.txt" ]; then pip install -r requirements.txt; fi
if [ -f "main.py" ]; then
    python main.py &
else
    echo "❌ main.py not found!"
fi

# Start Second Bot
echo "Starting Smilepost Bot..."
cd ../smilepost 2>/dev/null || cd . 
if [ -f "requirements.txt" ]; then pip install -r requirements.txt; fi
if [ -f "bot.py" ]; then
    python bot.py &
else
    echo "❌ bot.py not found!"
fi

echo "✅ Bots launched!"

# Keep alive
echo "Starting Keep-Alive Server on port 10000..."
python -c '
import http.server
import socketserver
import os
PORT = int(os.getenv("PORT", 10000))
Handler = http.server.SimpleHTTPRequestHandler
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Keep-alive server running on port {PORT}")
    httpd.serve_forever()
'
