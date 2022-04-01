#!groovy
pipeline {
    agent any
    options { skipDefaultCheckout true }
    environment {
        DOCKERHUB_CREDENTIALS=credentials('Faban')
        DOCKER_IMAGE = 'fernandoaban/test-devops'
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
              sh 'echo $DOCKERHUB_CREDENTIALS_USR | docker login -u $DOCKERHUB_CREDENTIALS_PSW --password-stdin'
            }
        }

        stage('Deploy to PR') {
            environment {
                DOCKER_IMAGE = 'fernandoaban/test-devops'
            }
            steps {
                script {
                    def customImage = docker.build("${DOCKER_IMAGE}", " -f Dockerfile .")
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
