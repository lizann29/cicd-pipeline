@Library('JenkinsTesLib') _

pipeline {
    agent any
    tools {
        nodejs 'node'
    }
    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:${env.PATH}"
        PORT = "${env.BRANCH_NAME == 'main' ? '3000' : '3001'}"
        IMAGE_NAME = "${env.BRANCH_NAME == 'main' ? 'nodemain' : 'nodedev'}"
        CONTAINER_NAME = "${env.BRANCH_NAME == 'main' ? 'nodemain-container' : 'nodedev-container'}"
        DOCKERHUB_REPO = "lizann29/cicd-pipeline"
    }
    stages {
        stage('Checkout') {
            steps { checkoutRepo() }
        }
        stage('Build') {
            steps { buildApp() }
        }
        stage('Test') {
            steps { testApp() }
        }
        stage('Build Docker Image') {
            steps { buildDockerImage(env.IMAGE_NAME, env.PORT) }
        }
        stage('Push to Docker Hub') {
            steps { pushToDockerHub(env.IMAGE_NAME, env.DOCKERHUB_REPO, env.BRANCH_NAME, 'dockerhub-creds') }
        }
        stage('Deploy') {
            steps { deployApp(env.CONTAINER_NAME, env.IMAGE_NAME, env.PORT) }
        }
        stage('Trigger Deploy Pipeline') {
            steps { triggerDeployPipeline(env.BRANCH_NAME) }
        }
    }
}
