#!/bin/bash

echo "===== AUTO SYSTEM START ====="

WORK_DIR="/home/user"
PROJECT_DIR="/home/user/con"

########################################
# SYSTEM INSTALL
########################################

sudo apt update
sudo apt install -y git unzip python3 python3-pip python3-venv

########################################
# WORK DIR
########################################

cd $WORK_DIR

########################################
# VENV (NO CHANGE)
########################################

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate

sudo chown -R user:user $WORK_DIR/venv

python -m pip install --upgrade pip setuptools wheel

########################################
# PYTHON LIBS (FIRST BOT)
########################################

pip install pyrogram tgcrypto motor

########################################
# CLONE PROJECT
########################################

if [ ! -d "$PROJECT_DIR" ]; then
    git clone https://github.com/Demoaccount010/con.git
fi

cd $PROJECT_DIR

########################################
# FIRST BOT (NO CHANGE)
########################################

unzip -o mainepisode.zip

cd mainepisode

echo "Starting main episode bot..."

python main.py &

cd ..

########################################
# SECOND BOT ADD (NEW PART)
########################################

echo "Setting up second bot..."

unzip -o post.zip

cd smilepost

pip install -r requirements.txt

echo "Starting smilepost bot..."

python bot.py &

cd ..

########################################
# WEB TERMINAL
########################################

echo "Opening ttyd terminal..."

ttyd -p 7860 bash
