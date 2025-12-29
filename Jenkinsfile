pipeline {
  agent any

  environment {
    // Artifactory base URL (UI URL ile aynı olabilir)
    JFROG_URL = 'https://artifactory.company.com'

    // Docker registry host ve repo adı (örnek)
    DOCKER_REGISTRY = 'artifactory.company.com'
    DOCKER_REPO     = 'docker-local'

    IMAGE_NAME = 'simple-java-app'
    // Tag için build numarası + git kısaltma
    IMAGE_TAG  = "${BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build (Maven)') {
      steps {
        sh 'mvn -B -DskipTests=false clean test package'
      }
    }

    stage('Docker Build') {
      steps {
        sh """
          docker build -t ${DOCKER_REGISTRY}/${DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG} .
          docker image ls | head -n 20
        """
      }
    }

    stage('Docker Push to Artifactory') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'jfrog-creds', usernameVariable: 'JF_USER', passwordVariable: 'JF_PASS')]) {
          sh """
            echo "${JF_PASS}" | docker login ${DOCKER_REGISTRY} -u "${JF_USER}" --password-stdin
            docker push ${DOCKER_REGISTRY}/${DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
            docker logout ${DOCKER_REGISTRY} || true
          """
        }
      }
    }

    // Opsiyonel: jar'ı Maven repo'ya deploy etmek isterseniz açın
    /*
    stage('Publish Maven Artifact (Optional)') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'jfrog-creds', usernameVariable: 'JF_USER', passwordVariable: 'JF_PASS')]) {
          sh '''
            jfrog config add art --url="$JFROG_URL" --user="$JF_USER" --password="$JF_PASS" --interactive=false || true
            jfrog rt mvn "clean deploy -DskipTests=true" \
              --build-name="simple-java-app" --build-number="$BUILD_NUMBER"
            jfrog rt bp "simple-java-app" "$BUILD_NUMBER"
          '''
        }
      }
    }
    */
  }

  post {
    always {
      sh 'docker system prune -f || true'
    }
  }
}
