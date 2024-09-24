pipeline {
  agent any
    stages {
        stage ('Build') {
            steps {
                sh '''#!/bin/bash
              sudo apt install python3-pip
              sudo apt install python3-flask
               python3.9 -m venv venv
            source venv/bin/activate
              pip install -r requirements.txt
              pip install gunicorn pymysql cryptography
              FLASK_APP=microblog.py
              flask translate compile
              flask db upgrade
              gunicorn -b :80 -w 4 microblog:app --daemon
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
                ssh -i "workload4KeyPair.pem" ubuntu@ec2-98-81-128-213.compute-1.amazonaws.com
                source start_app.sh
                '''
            }
        }
    }
}
