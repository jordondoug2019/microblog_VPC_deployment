pipeline {
  agent any
    stages {
        stage ('Build') {
            steps {
                sh '''#!/bin/bash
                sudo apt update
                sudo apt install -y python3.9 python3-pip python3.9-venv python3-flask
                python3.9 -m venv venv
                source venv/bin/activate
                pip install pip --upgrade
                pip install -r requirements.txt
                pip install gunicorn pymysql cryptography 
                export FLASK_APP=microblog.py
                flask translate compile
                flask db upgrade
                '''
            }
        }
        stage ('Test') {
            steps {
                sh '''#!/bin/bash
                source venv/bin/activate
                py.test ./tests/unit/ --verbose --junit-xml test-reports/results.xml
                '''
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
      stage ('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
      stage ('Deploy') {
            steps {
                sh '''#!/bin/bash
                scp -i  ~/.ssh/authorized_keys -o StrictHostKeyChecking=no  /var/lib/jenkins/workspace/workload_4_main/scripts/setup.sh ubuntu@10.0.3.30:/home/ubuntu/scripts/setup.sh

                scp -i  ~/.ssh/authorized_keys  -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/workload_4_main/scripts/start_app.sh ubuntu@10.0.3.30::/home/ubuntu/scripts/start_app.sh
                ssh -i "~/.ssh/authorized_keys" ubuntu@10.0.3.30 
                source /home/ubuntu/setup.sh
                '''
            }
        }
    }
}
