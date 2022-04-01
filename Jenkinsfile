#!groovy
pipeline {
    agent any
    options { skipDefaultCheckout true }
    stages {
        stage('Checkout'){
            steps {
                checkout scm
            }
        }
        stage('Deploy to PR') {
            environment {
                DOCKER_IMAGE = 'fernandoaban/test-devops'
            }
            steps {
                script {
                    def customImage = docker.build("${DOCKER_IMAGE}", " -f Dockerfile .")
                    docker.withRegistry('', 'dockerHub') {
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
                    }
                }
            }
        }
    }
}
