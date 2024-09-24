#!/bin/bash 

ssh -i "~/.ssh/workload4KeyPair.pem" ubuntu@10.0.27.118
source start_app.sh