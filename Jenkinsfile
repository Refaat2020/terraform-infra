pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest'
            args '--entrypoint=""'
        }
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
        
        TF_VAR_container_name = 'dev-nginx'
        TF_VAR_external_port  = '9090'
    }

    stages {
        stage('Init') {
            steps {
                sh 'cd environments/dev && terraform init'
            }
        }

        stage('Plan') {
            steps {
                sh 'cd environments/dev && terraform plan'
            }
        }

        stage('Apply') {
            steps {
                sh 'cd environments/dev && terraform apply -auto-approve'
            }
        }
    }
}