pipeline {
  agent any

  stages {
    stage('Check Tag') {
      when {
        expression {
          return env.GIT_TAG_NAME != null || sh(script: "git describe --exact-match --tags HEAD", returnStatus: true) == 0
        }
      }
      steps {
        echo "Tag detected: ${env.GIT_TAG_NAME}"
      }
    }

    stage('Build') {
      steps {
        sh 'make -f CommonMakefile'
      }
    }

    stage('Package') {
      steps {
        sh 'tar czf .build_output.tar.gz .build_*'
        archiveArtifacts artifacts: '*.tar.gz', fingerprint: true
      }
    }
  }
}
