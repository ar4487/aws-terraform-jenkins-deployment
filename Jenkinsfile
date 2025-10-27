pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        REGION                = 'ap-south-1'
        EC2_USER              = 'ubuntu' // or ec2-user, depending on your AMI
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ar4487/aws-terraform-jenkins-deployment'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                terraform plan -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                terraform apply -auto-approve tfplan
                '''
            }
        }

        stage('Deploy App') {
            steps {
                script {
                    // Extract EC2 public IP from Terraform output
                    def ec2_ip = sh(script: "terraform output -raw ec2_public_ip", returnStdout: true).trim()
                    
                    echo "Connecting to EC2: ${ec2_ip}"

                    // Use the SSH credential stored in Jenkins
                    sshagent(['ec2-ssh-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${ec2_ip} 'sudo apt update -y && sudo apt install -y nginx'
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${ec2_ip} 'sudo systemctl enable nginx && sudo systemctl start nginx'
                        """
                    }
                }
            }
        }
    }
}
