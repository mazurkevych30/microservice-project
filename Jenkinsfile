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
      imagePullPolicy: Always
      command:
        - sleep
      args:
        - 99d
"""
    }
  }

  environment {
    ECR_REGISTRY = "673982153424.dkr.ecr.eu-central-1.amazonaws.com"
    IMAGE_NAME   = "django-app"
    IMAGE_TAG    = "latest"
    CONTEXT_DIR  = "django-app"
    DOCKERFILE   = "django-app/Dockerfile"
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
  }
}
