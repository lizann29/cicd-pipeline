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
            steps {
                checkout scm
            }
        }
        stage('Lint Dockerfile') {
            steps {
                sh 'docker run --rm -i hadolint/hadolint < Dockerfile'
            }
        }
        stage('Build') {
            agent {
                docker {
                    image 'node:16'
                    reuseNode true
                }
            }
            steps {
                sh 'chmod +x scripts/build.sh'
                sh 'export HOME=/tmp && npm_config_cache=/tmp/.npm-cache ./scripts/build.sh'
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'node:16'
                    reuseNode true
                }
            }
            steps {
                sh 'chmod +x scripts/test.sh'
                sh 'export HOME=/tmp && npm_config_cache=/tmp/.npm-cache ./scripts/test.sh'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build --build-arg PORT=${PORT} -t ${IMAGE_NAME}:v1.0 ."
            }
        }
        stage('Scan Image with Trivy') {
            steps {
                sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --exit-code 0 --severity HIGH,CRITICAL ${IMAGE_NAME}:v1.0"
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker tag ${IMAGE_NAME}:v1.0 ${DOCKERHUB_REPO}:${env.BRANCH_NAME}"
                    sh "docker push ${DOCKERHUB_REPO}:${env.BRANCH_NAME}"
                }
            }
        }
        stage('Deploy') {
            steps {
                sh "docker rm -f ${CONTAINER_NAME} || true"
                sh "docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} ${IMAGE_NAME}:v1.0"
            }
        }
        stage('Trigger Deploy Pipeline') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        build job: 'Deploy_to_main', wait: false
                    } else if (env.BRANCH_NAME == 'dev') {
                        build job: 'Deploy_to_dev', wait: false
                    }
                }
            }
        }
    }
}
