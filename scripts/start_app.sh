#!/bin/bash
if [ ! -d "/home/ubuntu/microblog_VPC_deployment" ]; then
    git clone https://github.com/jordondoug2019/microblog_VPC_deployment.git /home/ubuntu/microblog_VPC_deployment
else
    cd /home/ubuntu/microblog_VPC_deployment 
    git pull origin main
fi
cd microblog_VPC_deployment
sudo apt install -y python3-pip 
sudo apt install -y python3-flask
pip install -r requirements.txt
pip install gunicorn pymysql cryptography
FLASK_APP=microblog.py
flask translate compile
flask db upgrade
gunicorn -b :80 -w 4 microblog:app --daemon
