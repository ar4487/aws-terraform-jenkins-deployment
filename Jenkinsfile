pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ar4487/aws-terraform-jenkins-deployment'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        terraform init -backend-config="bucket=terraform-backend-bucket-s3-state" \
                        -backend-config="key=terraform-state-lock" \
                        -backend-config="region=us-east-1"

                        terraform plan
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Deploy App') {
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
