pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: jenkins-kaniko
spec:
  serviceAccountName: jenkins-sa
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:v1.16.0-debug
    command:
    - sleep
    args:
    - 99d
  - name: git
    image: alpine/git
    command:
    - sleep
    args:
    - 99d
"""
    }
  }

  environment {
    ECR_REGISTRY = "673982153424.dkr.ecr.eu-central-1.amazonaws.com"
    IMAGE_NAME = "django-app"
    IMAGE_TAG = "latest"
    CONTEXT_DIR = "django-app"
    DOCKERFILE = "django-app/Dockerfile"
    COMMIT_MESSAGE = "Update image tag via CI"
    BRANCH = "lesson-8-9"
    FILE_TO_UPDATE = "lesson-8-9/charts/django-app/values.yaml"
  }

  stages {
    stage('Build & Push Docker Image') {
      steps {
        container('kaniko') {
          sh '''
/kaniko/executor \
  --context `pwd`/$CONTEXT_DIR \
  --dockerfile `pwd`/$DOCKERFILE \
  --destination=$ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG \
  --cache=true \
  --insecure \
  --skip-tls-verify
'''
        }
      }
    }

    stage('Update Helm Chart in Git') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
          container('git') {
            sh '''
git config --global user.email "jenkins-bot@local"
git config --global user.name "jenkins-bot"
git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/mazurkevych30/microservice-project.git
cd microservice-project
git checkout ${BRANCH}
sed -i "s/tag: .*/tag: ${IMAGE_TAG}/" ${FILE_TO_UPDATE}
git add ${FILE_TO_UPDATE}
git commit -m "${COMMIT_MESSAGE}"
git push origin ${BRANCH}
'''
          }
        }
      }
    }
  }
}
