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
            steps {
                echo 'Compiling Spring Boot app'
                sh """
                    docker run --rm \
                    -v \$PWD:/app \
                    -v \$HOME/.m2:/root/.m2 \
                    -w /app \
                    ${MAVEN_IMAGE} mvn clean compile
                """
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests'
                sh """
                    docker run --rm \
                    -v \$PWD:/app \
                    -v \$HOME/.m2:/root/.m2 \
                    -w /app \
                    ${MAVEN_IMAGE} mvn test
                """
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging JAR'
                sh """
                    docker run --rm \
                    -v \$PWD:/app \
                    -v \$HOME/.m2:/root/.m2 \
                    -w /app \
                    ${MAVEN_IMAGE} mvn package -DskipTests
                """
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
                sh """
                    docker run --rm \
                    -v \$PWD:/app \
                    -v \$HOME/.m2:/root/.m2 \
                    -w /app \
                    ${MAVEN_IMAGE} mvn deploy -DskipTests
                """
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