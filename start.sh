#!/bin/bash

echo "===== AUTO SYSTEM START ====="
echo "Current Path: $(pwd)"

# Update and install basic tools
sudo apt-get update && sudo apt-get install -y unzip curl

# Setup directories
mkdir -p mainepisode smilepost
cd /home/user

# ========================= VENV =========================
echo "Creating Virtual Environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip

# Install base libraries
pip install pyrogram tgcrypto motor python-dotenv

# ========================= EXTRACT ZIPS =========================
echo "Extracting mainepisode.zip..."
unzip -o mainepisode.zip -d mainepisode

echo "Extracting post.zip..."
unzip -o post.zip -d smilepost

# ========================= FIRST BOT =========================
echo "Starting Main Episode Bot..."
cd mainepisode
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi
python main.py &
echo "Main bot started..."

cd ..

# ========================= SECOND BOT =========================
echo "Starting Smilepost Bot..."
cd smilepost
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi
python bot.py &
echo "Smilepost bot started..."

cd ..

echo "✅ Both Bots Started Successfully!"

# Keep Render happy (Port Binding)
echo "Starting Keep-Alive Server..."
python3 -c '
import http.server
import socketserver
import os
PORT = int(os.getenv("PORT", 10000))
Handler = http.server.SimpleHTTPRequestHandler
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Server running on port {PORT}")
    httpd.serve_forever()
'
