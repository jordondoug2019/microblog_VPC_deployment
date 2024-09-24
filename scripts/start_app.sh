#!/bin/bash

git clone https://github.com/jordondoug2019/microblog_VPC_deployment.git
sudo apt install python3-pip
sudo apt install python3-flask
sudo apt install gunicorn
pip install -r requirements.txt
pip install gunicorn pymysql cryptography
FLASK_APP=microblog.py
flask translate compile
flask db upgrade
gunicorn -b :80 -w 4 microblog:app --daemon
