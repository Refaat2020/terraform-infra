pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {

        stage('Clone Repo') {
            steps {
                git credentialsId: 'github-creds',
                    url: 'https://github.com/Refaat2020/terraform-infra'
            }
        }

        stage('Terraform Init (network)') {
            steps {
                dir('environments/dev/network') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply (network)') {
            steps {
                dir('environments/dev/network') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Terraform Init (compute)') {
            steps {
                dir('environments/dev/compute') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply (compute)') {
            steps {
                dir('environments/dev/compute') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Terraform Init (dns)') {
            steps {
                dir('environments/dev/dns') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply (dns)') {
            steps {
                dir('environments/dev/dns') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}