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

        stage('Print Branch Info') {
            steps {
                echo "Running on branch: ${env.BRANCH_NAME}"
            }
        }

        stage('Build Image') {
            steps {
                sh "chmod +x Script/build.sh"
                sh  sh "./Script/build.sh ${IMAGE_NAME} ${TAG}"
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-creds') {

                        if (env.BRANCH_NAME == 'dev') {

                            echo "DEV branch detected"

                            sh """
                            docker tag ${IMAGE_NAME}:${TAG} ${DEV_REPO}:dev-${TAG}
                            docker tag ${IMAGE_NAME}:${TAG} ${DEV_REPO}:latest-dev
                            docker push ${DEV_REPO}:dev-${TAG}
                            docker push ${DEV_REPO}:latest-dev
                            """

                        } else if (env.BRANCH_NAME == 'master') {

                            echo "MASTER branch detected"

                            sh """
                            docker tag ${IMAGE_NAME}:${TAG} ${PROD_REPO}:prod-${TAG}
                            docker tag ${IMAGE_NAME}:${TAG} ${PROD_REPO}:latest
                            docker push ${PROD_REPO}:prod-${TAG}
                            docker push ${PROD_REPO}:latest
                            """
                        } else {
                            echo "Skipping push: Not dev or master branch"
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sh "chmod +x deploy.sh"

                script {
                    if (env.BRANCH_NAME == 'dev') {

                        echo "Deploying DEV environment"
                        sh "./Script//deploy.sh ${DEV_REPO}:latest-dev 3001"

                    } else if (env.BRANCH_NAME == 'master') {

                        echo "Deploying PROD environment"
                        sh "./Script/deploy.sh ${PROD_REPO}:latest 3000"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Build Successful for ${env.BRANCH_NAME}"
        }
        failure {
            echo "Build Failed for ${env.BRANCH_NAME}"
        }
    }
}