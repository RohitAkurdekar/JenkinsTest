pipeline {
    agent any
    triggers {
        pollSCM('H/5 * * * *') // Poll every 5 minutes
    }
    environment {
        TAG_NAME = ''
    }
    stages {
        stage('Check for Tag on Production Branch') {
            steps {
                script {
                    def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    def tag = sh(script: "git describe --tags --exact-match HEAD || true", returnStdout: true).trim()

                    if (branch == "production" && tag) {
                        echo "Triggered on tag '${tag}' in production branch"
                        env.TAG_NAME = tag
                    } else {
                        echo "No tag found on production branch. Skipping build."
                        currentBuild.result = 'NOT_BUILT'
                        error("Not a tag on production branch.")
                    }
                }
            }
        }

        stage('Build') {
            when {
                expression { env.TAG_NAME != '' }
            }
            steps {
                echo "Running build for tag: ${env.TAG_NAME}"
                sh './Build.sh'
            }
        }
    }
}
