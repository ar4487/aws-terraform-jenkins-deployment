pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select Terraform action to perform'
        )
    }

    environment {
        TF_VAR_region = 'us-east-1'
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Init') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init -input=false'
            }
        }

        stage('Validate') {
            steps {
                echo 'Validating Terraform configuration...'
                sh 'terraform validate'
            }
        }

        stage('Plan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                echo 'Planning Terraform changes...'
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                echo 'Applying Terraform changes...'
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Destroy Plan') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                echo 'Creating destroy plan...'
                sh 'terraform plan -destroy -out=tfplan-destroy'
            }
        }

        stage('Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                echo 'Destroying resources...'
                sh 'terraform apply -auto-approve tfplan-destroy'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            sh 'rm -f tfplan tfplan-destroy || true'
        }
        success {
            echo "✅ Terraform ${params.ACTION} completed successfully!"
        }
        failure {
            echo "❌ Terraform ${params.ACTION} failed!"
        }
    }
}
