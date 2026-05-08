pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code from SCM'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Compiling the Spring Boot application'
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests'
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging the application into JAR'
                sh 'mvn package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'
                sh 'docker build -t springboot-hello .'
            }
        }

        stage('Deploy to Nexus') {
            steps {
                echo 'Deploying snapshot to local Nexus'
                sh 'mvn deploy -DskipTests'
            }
        }
    }

    post {
        always {
            echo 'Archiving test results and JAR file'
            junit 'target/surefire-reports/*.xml'
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
    }
}
