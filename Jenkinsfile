pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ENV = 'dev'
    }

    stages {

        stage('Network') {
            steps {
                dir("environments/${ENV}/network") {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Compute') {
            steps {
                dir("environments/${ENV}/compute") {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('DNS') {
            steps {
                dir("environments/${ENV}/dns") {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}