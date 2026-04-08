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
                    BRANCH = env.BRANCH_NAME.tokenize('/').last()
                    echo "🚀 Running on branch: ${BRANCH}"
                }
            }
        }

        stage('Build Image') {
            steps {
                sh "chmod +x Script/build.sh"
                sh "./Script/build.sh ${IMAGE_NAME} ${TAG}"
            }
        }

        stage('Verify Image') {
            steps {
                sh "docker images | grep ${IMAGE_NAME}"
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('', 'docker-cred') {

                        if (BRANCH == 'dev') {

                            echo "✅ DEV branch detected"

                            sh """
                            docker tag ${IMAGE_NAME}:${TAG} ${DEV_REPO}:dev-${TAG}
                            docker tag ${IMAGE_NAME}:${TAG} ${DEV_REPO}:latest-dev
                            docker push ${DEV_REPO}:dev-${TAG}
                            docker push ${DEV_REPO}:latest-dev
                            """

                        } else if (BRANCH == 'master' || BRANCH == 'main') {

                            echo "✅ PROD branch detected"

                            sh """
                            docker tag ${IMAGE_NAME}:${TAG} ${PROD_REPO}:prod-${TAG}
                            docker tag ${IMAGE_NAME}:${TAG} ${PROD_REPO}:latest
                            docker push ${PROD_REPO}:prod-${TAG}
                            docker push ${PROD_REPO}:latest
                            """

                        } else {
                            echo "⚠️ Skipping push for branch: ${BRANCH}"
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

                if (BRANCH == 'dev') {

                    def image = "${DEV_REPO}:latest-dev"
                    def port = "3001"

                    echo "🚀 Deploying DEV environment"
                    echo "Image=${image}, Port=${port}"

                    sh """
                        set -x
                        export DOCKER_USER=${DOCKER_USER}
                        export DOCKER_PASS=${DOCKER_PASS}
                        ./Script/deploy.sh '${image}' '${port}'
                    """

                } else if (BRANCH == 'master' || BRANCH == 'main') {

                    def image = "${PROD_REPO}:latest"
                    def port = "3000"

                    echo "🚀 Deploying PROD environment"
                    echo "Image=${image}, Port=${port}"

                    sh """
                        set -x
                        export DOCKER_USER=${DOCKER_USER}
                        export DOCKER_PASS=${DOCKER_PASS}
                        ./Script/deploy.sh '${image}' '${port}'
                    """

                } else {
                    echo "⚠️ Skipping deploy for branch: ${BRANCH}"
                }
            }
        }
    }
}

    post {
        success {
            echo "✅ Build Successful for ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ Build Failed for ${env.BRANCH_NAME}"
        }
    }
}
