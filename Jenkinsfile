pipeline {
    agent any

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