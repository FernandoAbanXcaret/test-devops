#!groovy
pipeline {
    agent any
    options { skipDefaultCheckout true }
    environment {
        DOCKER_IMAGE = 'fernandoaban/test-devops'
        DOCKERHUB_CREDENTIALS = credentials('faban-dockerhub')
    }
    stages {
        stage('Checkout'){
            steps {
                checkout scm
            }
        }
        stage('build'){
            steps {
               sh 'docker build -t fernandoaban/test-devops:lastest .'
            }
        }
        stage('login'){
            steps {
              sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Deploy to PR'){ 
            when {
                expression { env.CHANGE_ID ==~ /.*/ }
            }
            steps {
               sh 'docker push fernandoaban/test-devops:lastest'
            }
        }
        stage('Deploy to Production'){
            when {
                branch 'main'
            }
            steps {
               sh 'docker push fernandoaban/test-devops:lastest'
            }
        }
        
    }
    post {
        always {
           
            cleanWs()
            dir("${env.WORKSPACE}@tmp") {
                deleteDir()
            }
            dir("${env.WORKSPACE}@script") {
                deleteDir()
            }
            dir("${env.WORKSPACE}@script@temp") {
                deleteDir()
            }
            sh 'docker logout'
        }
}
