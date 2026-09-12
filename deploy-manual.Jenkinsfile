@Library('JenkinsTesLib') _

pipeline {
    agent any
    parameters {
        choice(name: 'BRANCH', choices: ['main', 'dev'], description: 'Select branch to deploy')
    }
    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:${env.PATH}"
        PORT = "${params.BRANCH == 'main' ? '3000' : '3001'}"
        IMAGE_NAME = "${params.BRANCH == 'main' ? 'nodemain' : 'nodedev'}"
        CONTAINER_NAME = "${params.BRANCH == 'main' ? 'nodemain-container' : 'nodedev-container'}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: "${params.BRANCH}", url: 'https://github.com/lizann29/cicd-pipeline.git'
            }
        }
        stage('Deploy') {
            steps { deployApp(env.CONTAINER_NAME, env.IMAGE_NAME, env.PORT) }
        }
    }
}
