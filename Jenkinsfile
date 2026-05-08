pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        IMAGE_NAME = "springboot-hello"
        MAVEN_IMAGE = "maven:3.9.6-eclipse-temurin-17"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub'
                checkout scm
            }
        }

        stage('Build') {
            agent {
                docker {
                    image "${MAVEN_IMAGE}"
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                echo 'Compiling Spring Boot app'
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            agent {
                docker {
                    image "${MAVEN_IMAGE}"
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                echo 'Running tests'
                sh 'mvn test'
            }
        }

        stage('Package') {
            agent {
                docker {
                    image "${MAVEN_IMAGE}"
                    args '-v /root/.m2:/root/.m2'
                }
            }
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
                    docker build -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Deploy to Nexus') {
            agent {
                docker {
                    image "${MAVEN_IMAGE}"
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                echo 'Deploying artifact to Nexus'

                sh '''
                    mvn deploy -DskipTests
                '''
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
            echo 'Cleaning workspace'
            cleanWs()
        }
    }
}