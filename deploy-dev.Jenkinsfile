@Library('JenkinsTesLib') _

pipeline {
    agent any
    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:${env.PATH}"
        DOCKERHUB_REPO = "lizann29/cicd-pipeline"
    }
    stages {
        stage('Pull and Deploy') {
            steps { deployFromDockerHub(env.DOCKERHUB_REPO, 'dev', 'nodedev-container', '3001') }
        }
    }
}
