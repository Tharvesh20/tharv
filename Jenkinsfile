pipeline {
    agent any

    environment {
        IMAGE_NAME = 'tharvesh20/flask-docker-app1'
        AWS_REGION = 'eu-east-1'
    }

    stages {

        stage('Clone Repository') {
            steps {
                git 'https://github.com/Tharvesh20/tharv.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %IMAGE_NAME% ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat """
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                bat "docker push %IMAGE_NAME%"
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    bat 'terraform --version'
                    bat 'terraform init'
                }
            }
        }

    
        stage('Terraform Init and Apply') {
            steps {
                dir('terraform') {
                    withCredentials([usernamePassword(credentialsId: 'aws-jenkins-user', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        bat 'terraform init'
                        bat 'terraform apply -auto-approve'
                    }
                }
            }
        }
    
        stage('Deployment Verification') {
            steps {
                echo "Waiting for EC2 instance to initialize..."
                sleep time: 90, unit: 'SECONDS'
                echo "🚀 Deployed! Access your Flask app at: http://<EC2-PUBLIC-IP>:8000"
            }
        }
    }
}