pipeline {
    agent any

    environment {
        GIT_TAG = ''
    }

    stages {
        stage('Detect Tag and Base Branch') {
            steps {
                script {
                    // Get tag name
                    def ref = sh(script: "git describe --tags --exact-match HEAD || true", returnStdout: true).trim()

                    if (!ref) {
                        echo "Not a tag. Exiting."
                        currentBuild.result = 'NOT_BUILT'
                        error("Build not triggered by a Git tag.")
                    }

                    GIT_TAG = ref
                    echo "Detected Git tag: ${GIT_TAG}"

                    // Fetch full origin refs (ensure we have production)
                    sh "git remote set-url origin https://github.com/RohitAkurdekar/JenkinsTest.git"
                    sh "git fetch origin production"

                    // Check if tag commit is reachable from production
                    def isBased = sh(
                        script: "git merge-base --is-ancestor ${GIT_TAG} origin/production && echo yes || echo no",
                        returnStdout: true
                    ).trim()

                    if (isBased != 'yes') {
                        echo "Tag ${GIT_TAG} is NOT based on production branch."
                        currentBuild.result = 'NOT_BUILT'
                        error("Tag is not from production.")
                    }

                    echo "Tag ${GIT_TAG} is based on production branch."
                }
            }
        }

        stage('Build') {
            steps {
                echo "Running build for tag: ${GIT_TAG}"
                sh './source/Build.sh'
            }
        }
    }
}
