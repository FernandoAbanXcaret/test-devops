#!groovy
pipeline {
    agent any
    options { skipDefaultCheckout true }
    environment {
        NAMEJOB = "test-devops"
        DOCKERHUB_CREDENTIALS=credentials('Faban')
        IMAGE = "test-devops:latest"   
        CONTAINER_IMAGE = "node:12"
        PORT_CONTAINER = "3000"
        HELM_CHART_NAME = "xervigas"
        NODE_ENV = "production"
    }
    stages {
        stage('Checkout'){
            steps {
                checkout scm
            }
        }
        stage('build'){
            steps {
               sh 'docker build -t fernandoaban/test-devops:lastest'
            }
        }
        stage('login'){
            steps {
              sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Deploy to PR') {
            environment {
                DOCKER_IMAGE = 'fernandoaban/test-devops'
            }
            steps {
                script {
                    def customImage = docker.build("${IMAGE}", " -f Dockerfile .")
                    docker.withRegistry('', 'Faban') {
                        customImage.push("${BUILD_NUMBER}")
                    }
                }
            }
        }
        stage('Deploy to Production'){
            agent {
                label 'master'
            }
            when {
                branch 'main'
            }
            steps {
                script {
                    def customImage = docker.build("${DOCKER_IMAGE}", " -f Dockerfile .")
                    docker.withRegistry('', 'dockerHub') {
                        customImage.push("${BUILD_NUMBER}")
                        customImage.push('latest')
                    }
                }
            }
        }
    }
}
