pipeline {
  agent any
    
    environment {
        APP_REPO_URL   = 'https://github.com/emreyardimci/t-demoapp.git'
        APP_REPO_BRANCH= 'main'
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-17.0.1.0.12-2.el8_5.x86_64'
        PATH = "${JAVA_HOME}/bin:${env.PATH}"
      }

    stages {
        stage('Checkout (Pipeline Repo)') {
            steps { checkout scm }
        }
    }

       stage('Checkout & Build (Java App Repo)') {
      steps {
        dir('app') {
          git url: "${APP_REPO_URL}", branch: "${APP_REPO_BRANCH}" 
        }
      }
    }
}