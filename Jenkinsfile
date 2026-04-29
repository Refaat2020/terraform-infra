pipeline {
    agent any

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'staging', 'prod'],
            description: 'Select environment'
        )
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_PLUGIN_CACHE_DIR = "/var/lib/jenkins/.terraform.d/plugin-cache"
    }

    stages {

        // ---------------- NETWORK ----------------
        stage('Network Plan') {
            steps {
                dir("environments/${params.ENV}/network") {
                    sh 'terraform init'
                    sh 'terraform plan -var-file=terraform.tfvars -out=tfplan'
                }
            }
        }

        stage('Network Approval') {
            when {
                expression { params.ENV == 'prod' }
            }
            steps {
                input message: "Apply NETWORK to PROD?"
            }
        }

        stage('Network Apply') {
            steps {
                dir("environments/${params.ENV}/network") {
                    sh 'terraform apply tfplan'
                }
            }
        }

        // ---------------- COMPUTE ----------------
        stage('Compute Plan') {
            steps {
                dir("environments/${params.ENV}/compute") {
                    sh 'terraform init'
                    sh 'terraform plan -var-file=terraform.tfvars -out=tfplan'
                }
            }
        }

        stage('Compute Approval') {
            when {
                expression { params.ENV == 'prod' }
            }
            steps {
                input message: "Apply COMPUTE to PROD?"
            }
        }

        stage('Compute Apply') {
            steps {
                dir("environments/${params.ENV}/compute") {
                    sh 'terraform apply tfplan'
                }
            }
        }

        // ---------------- DNS ----------------
        stage('DNS Plan') {
            steps {
                dir("environments/${params.ENV}/dns") {
                    sh 'terraform init'
                    sh 'terraform plan -var-file=terraform.tfvars -out=tfplan'
                }
            }
        }

        stage('DNS Approval') {
            when {
                expression { params.ENV == 'prod' }
            }
            steps {
                input message: "Apply DNS to PROD?"
            }
        }

        stage('DNS Apply') {
            steps {
                dir("environments/${params.ENV}/dns") {
                    sh 'terraform apply tfplan'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}