#!/bin/bash

echo "===== AUTO SYSTEM START ====="
echo "Current Directory: $(pwd)"

apt-get update && apt-get install -y unzip

# Extract zips
echo "Extracting zips..."
unzip -o mainepisode.zip
unzip -o post.zip

# Fix folder structure (bahut important)
if [ -d "mainepisode/mainepisode" ]; then
    mv mainepisode/mainepisode/* mainepisode/ 2>/dev/null
fi
if [ -d "smilepost/smilepost" ]; then
    mv smilepost/smilepost/* smilepost/ 2>/dev/null
fi
if [ -d "post/smilepost" ]; then
    mv post/smilepost/* smilepost/ 2>/dev/null
fi

# Python setup
python -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install pyrogram tgcrypto motor python-dotenv

# Install bot requirements
cd mainepisode && [ -f requirements.txt ] && pip install -r requirements.txt && cd ..
cd smilepost && [ -f requirements.txt ] && pip install -r requirements.txt && cd ..

# Debug: Show files
echo "=== Files in mainepisode ==="
ls -la mainepisode/

echo "=== Files in smilepost ==="
ls -la smilepost/

# Start Bots
echo "Starting Main Episode Bot..."
cd mainepisode
if [ -f "main.py" ]; then
    python main.py &
    echo "✅ Main bot (main.py) started"
else
    echo "❌ main.py not found!"
fi
cd ..

echo "Starting Smilepost Bot..."
cd smilepost
if [ -f "bot.py" ]; then
    python bot.py &
    echo "✅ Smilepost bot (bot.py) started"
else
    echo "❌ bot.py not found!"
fi
cd ..

echo "Keep-Alive Server Starting on port $PORT..."
python -c '
import http.server
import socketserver
import os, time
PORT = int(os.getenv("PORT", 10000))
print(f"Keep-alive server running on port {PORT}")
Handler = http.server.SimpleHTTPRequestHandler
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    httpd.serve_forever()
'
