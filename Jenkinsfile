pipeline {
  agent any

  environment {
    APP_REPO_URL   = 'https://github.com/emreyardimci/t-demoapp.git'
    APP_REPO_BRANCH= 'main'
    
    IMAGE_NAME = 't-demoapp'
    IMAGE_TAG  = "${BUILD_NUMBER}"


    DOCKER_REGISTRY  = 'trialml6ikw.jfrog.io'
    DOCKER_REPO      = 'quasys-docker-demo'
    #JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-17.0.1.0.12-2.el8_5.x86_64'
    #PATH = "${JAVA_HOME}/bin:${env.PATH}"
  }

  stages {
    // Bu repo: pipeline/infrastructure repo (Jenkinsfile + Dockerfile vs.)
    stage('Checkout (Pipeline Repo)') {
      steps { checkout scm }
    }

    // Başka repo: Java uygulaması
    stage('Checkout & Build (Java App Repo)') {
      steps {
        dir('app') {
          git url: "${APP_REPO_URL}", branch: "${APP_REPO_BRANCH}" 
          sh """
                mvn -B \
                -DskipTests=false \
                -DaltDeploymentRepository=quasys-maven-demo::default::https://trialml6ikw.jfrog.io/artifactory/quasys-maven-demo \
                clean test deploy
                """
        }
      }
    }

    stage('podman Build') {
      steps {
        sh "sudo podman build -t ${DOCKER_REGISTRY}/${DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG} ."
      }
    }

    stage('podman Push to Artifactory') {
      steps {
        sh "sudo podman push ${DOCKER_REGISTRY}/${DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG}"
      }
    }
  }

  post {
    always {
      sh 'podman system prune -f || true'
    }
  }
}
