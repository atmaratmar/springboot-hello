pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        IMAGE_NAME = "springboot-hello"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Compiling Spring Boot app'
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests'
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging JAR'
                sh 'mvn package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'

                sh '''
                    docker --version
                    docker build -t springboot-hello:latest .
                '''
            }
        }

        stage('Deploy to Nexus') {
            steps {
                echo 'Deploying artifact to Nexus'
                sh 'mvn deploy -DskipTests'
            }
        }
    }

    post {
        success {
            echo 'BUILD SUCCESS ✔'
        }

        failure {
            echo 'BUILD FAILED ❌'
        }

        always {
            cleanWs()
        }
    }
}