pipeline {
    agent any
    enviornment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    stages {
        stage('checkout code') {
            steps {
                git branch: 'main', url: 'https://github.com/ar4487/aws-terraform-jenkins-deployment'
            }
        }
        stage('Terraform init') {
            steps {
                sh '''
                terraform init -backend-config="bucket=my-tf-state-bucket" \
                               -backend-config="key=terraform.tfstate" \
                               -backend-config="region=us-east-1"
                '''
            }
        }
        stage('terraform plan') {
            steps {
               sh 'terraform plan -out=tfplan'
            }
        }
        stage('terrafform apply') {
            steps {
                sh 'terraform apply'
            }
        }
        stage('deploy app'){
            steps {
                echo 'App deployment script will run here later'
            }
        }
    }
    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}