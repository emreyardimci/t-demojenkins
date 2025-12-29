pipeline {
  agent any

  environment {
    APP_REPO_URL   = 'https://github.com/emreyardimci/t-demoapp.git'
    APP_REPO_BRANCH= 'main'
    
    JFROG_URL        = 'https://artifactory.company.com'
    DOCKER_REGISTRY  = 'artifactory.company.com'
    DOCKER_REPO      = 'docker-local'
    IMAGE_NAME = 'simple-java-app'
    IMAGE_TAG  = "${BUILD_NUMBER}"
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
          java -version
          sh 'mvn -B -DskipTests=false clean test package'
        }
      }
    }

    stage('podman Build') {
      steps {
        sh """
          podman build \
            --build-arg JAR_FILE=app/target/*.jar \
            -t ${DOCKER_REGISTRY}/${DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG} .
          podman image ls | head -n 20
        """
      }
    }

    stage('podman Push to Artifactory') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'jfrog-creds', usernameVariable: 'JF_USER', passwordVariable: 'JF_PASS')]) {
          sh """
            echo "${JF_PASS}" | podman login ${DOCKER_REGISTRY} -u "${JF_USER}" --password-stdin
            podman push ${DOCKER_REGISTRY}/${DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
            podman logout ${DOCKER_REGISTRY} || true
          """
        }
      }
    }
  }

  post {
    always {
      sh 'podman system prune -f || true'
    }
  }
}
