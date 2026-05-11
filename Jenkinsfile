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

        stage('Debug Workspace') {
            steps {
                sh '''
                    echo "=== WORKSPACE INFO ==="
                    pwd
                    ls -la
                    echo "=== FIND POM ==="
                    find . -name pom.xml
                '''
            }
        }

        stage('Build') {
            steps {
                echo 'Compiling Spring Boot app'
                sh """
                    docker run --rm \
                    -v \$WORKSPACE:/workspace \
                    -v \$HOME/.m2:/root/.m2 \
                    -w /workspace \
                    ${MAVEN_IMAGE} mvn clean compile
                """
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests'
                sh """
                    docker run --rm \
                    -v \$WORKSPACE:/workspace \
                    -v \$HOME/.m2:/root/.m2 \
                    -w /workspace \
                    ${MAVEN_IMAGE} mvn test
                """
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging JAR'
                sh """
                    docker run --rm \
                    -v \$WORKSPACE:/workspace \
                    -v \$HOME/.m2:/root/.m2 \
                    -w /workspace \
                    ${MAVEN_IMAGE} mvn package -DskipTests
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'
                sh """
                    docker --version
                    docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Deploy to Nexus (Maven)') {
            steps {
                echo 'Deploying JAR to Nexus'
                sh """
                    docker run --rm \
                    -v \$WORKSPACE:/workspace \
                    -v \$HOME/.m2:/root/.m2 \
                    -w /workspace \
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