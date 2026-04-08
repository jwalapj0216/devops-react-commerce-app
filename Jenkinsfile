pipeline {
    agent any

    options {
        disableConcurrentBuilds()
    }

    environment {
        IMAGE_NAME = "ecommerce-app"
        DEV_REPO = "jwalapj02/devops-build-dev"
        PROD_REPO = "jwalapj02/devops-build-prod"
        TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Detect Branch') {
            steps {
                script {
                    env.BRANCH = env.BRANCH_NAME.tokenize('/').last()
                    echo "🚀 Running on branch: ${env.BRANCH}"
                }
            }
        }

        stage('Build Image') {
            steps {
                sh """
                chmod +x Script/build.sh
                ./Script/build.sh ${IMAGE_NAME} ${TAG}
                """
            }
        }

        stage('Verify Image') {
            steps {
                sh "docker images | grep ${IMAGE_NAME} || true"
            }
        }

        stage('Push Image') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-cred',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {

                        if (env.BRANCH == 'dev') {

                            sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                            docker tag ${IMAGE_NAME}:${TAG} ${DEV_REPO}:latest-dev
                            docker push ${DEV_REPO}:latest-dev
                            """

                        } else if (env.BRANCH == 'master' || env.BRANCH == 'main') {

                            sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                            docker tag ${IMAGE_NAME}:${TAG} ${PROD_REPO}:latest
                            docker push ${PROD_REPO}:latest
                            """
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sh "chmod +x Script/deploy.sh"

                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-cred',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {

                        if (env.BRANCH == 'dev') {

                            sh """
                            export DOCKER_USER=$DOCKER_USER
                            export DOCKER_PASS=$DOCKER_PASS
                            ./Script/deploy.sh "${DEV_REPO}:latest-dev" "3001"
                            """

                        } else if (env.BRANCH == 'master' || env.BRANCH == 'main') {

                            sh """
                            export DOCKER_USER=$DOCKER_USER
                            export DOCKER_PASS=$DOCKER_PASS
                            ./Script/deploy.sh "${PROD_REPO}:latest" "3000"
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build Successful"
        }
        failure {
            echo "❌ Build Failed"
        }
    }
}
