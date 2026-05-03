#!/bin/bash

echo "===== AUTO SYSTEM START ====="
echo "Current Directory: $(pwd)"

# ========================= SYSTEM SETUP =========================
echo "Installing system packages..."
apt-get update && apt-get install -y unzip git curl

# ========================= WORKING DIRECTORY =========================
mkdir -p /home/user/con
cd /home/user

# ========================= VENV SETUP =========================
echo "Setting up Python Virtual Environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip setuptools wheel

# ========================= PYTHON LIBRARIES =========================
echo "Installing Python libraries..."
pip install pyrogram tgcrypto motor python-dotenv

# ========================= CLONE / COPY PROJECT =========================
echo "Setting up project..."
cd /home/user/con

# If zip files are in repo
if [ -f "../mainepisode.zip" ]; then
    echo "Extracting mainepisode.zip..."
    unzip -o ../mainepisode.zip -d mainepisode
else
    echo "Warning: mainepisode.zip not found!"
fi

if [ -f "../smilepost.zip" ] || [ -f "../post.zip" ]; then
    echo "Extracting smilepost/post.zip..."
    unzip -o ../smilepost.zip -d smilepost 2>/dev/null || unzip -o ../post.zip -d smilepost
fi

# ========================= FIRST BOT (mainepisode) =========================
echo "Starting Main Episode Bot..."
cd /home/user/con/mainepisode
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi
python main.py &
MAIN_BOT_PID=$!
echo "Main bot started with PID: $MAIN_BOT_PID"
cd ..

# ========================= SECOND BOT (smilepost) =========================
echo "Starting Smilepost Bot..."
cd /home/user/con/smilepost
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi
python bot.py &
SMILE_BOT_PID=$!
echo "Smilepost bot started with PID: $SMILE_BOT_PID"
cd ..

echo "✅ Both bots launched successfully!"

# ========================= KEEP ALIVE FOR RENDER =========================
echo "Starting Keep-Alive Server on port 10000..."
python3 -c '
import http.server
import socketserver
import os
PORT = int(os.getenv("PORT", 10000))
Handler = http.server.SimpleHTTPRequestHandler
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Keep-alive server running on http://0.0.0.0:{PORT}")
    httpd.serve_forever()
'
