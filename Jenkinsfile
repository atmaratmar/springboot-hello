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
                checkout scm
            }
        }

        stage('Debug Workspace') {
            steps {
                sh '''
                    echo "WORKSPACE INFO:"
                    echo $WORKSPACE
                    pwd
                    ls -la
                    find . -name pom.xml
                '''
            }
        }

        stage('Build') {
            steps {
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
                sh """
                    docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Deploy to Nexus') {
            steps {
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