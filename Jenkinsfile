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

        stage('Debug Branch Info') {
            steps {
                echo "Running on branch: ${env.BRANCH_NAME}"
                sh 'echo "---- ENV ----" && env | sort'
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
                sh "docker images | grep ${IMAGE_NAME} || true"
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('', 'docker-cred') {

                        if (env.BRANCH_NAME?.contains('dev')) {

                            echo "✅ DEV branch detected"

                            sh """
                            docker tag ${IMAGE_NAME}:${TAG} ${DEV_REPO}:dev-${TAG}
                            docker tag ${IMAGE_NAME}:${TAG} ${DEV_REPO}:latest-dev
                            docker push ${DEV_REPO}:dev-${TAG}
                            docker push ${DEV_REPO}:latest-dev
                            """

                        } else if (env.BRANCH_NAME?.contains('master') || env.BRANCH_NAME?.contains('main')) {

                            echo "✅ PROD branch detected"

                            sh """
                            docker tag ${IMAGE_NAME}:${TAG} ${PROD_REPO}:prod-${TAG}
                            docker tag ${IMAGE_NAME}:${TAG} ${PROD_REPO}:latest
                            docker push ${PROD_REPO}:prod-${TAG}
                            docker push ${PROD_REPO}:latest
                            """

                        } else {
                            echo "⚠️ Skipping push: Not dev/master/main branch (${env.BRANCH_NAME})"
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
    
                    if (env.BRANCH_NAME.contains('master') || env.BRANCH_NAME.contains('main')) {
    
                        echo "🚀 Deploying PROD environment"
                        sh "./Script/deploy.sh ${PROD_REPO}:latest 3000"
    
                    } else if (env.BRANCH_NAME.contains('dev')) {
    
                        echo "🚀 Deploying DEV environment"
                        sh "./Script/deploy.sh ${DEV_REPO}:latest-dev 3001"
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
