pipeline {
    agent any

    environment {
        TAG_NAME = ''
        BRANCH_NAME = 'production' // Used for checking the base branch of the tag
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "${env.GIT_BRANCH}"]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/RohitAkurdekar/JenkinsTest.git'  // or actual remote if applicable
                    ]]
                ])
            }
        }

        stage('Validate Tag on Production') {
            steps {
                script {
                    // Extract tag name from GIT_BRANCH (refs/tags/v1.2.3 -> v1.2.3)
                    TAG_NAME = env.GIT_BRANCH.replaceFirst(/^refs\/tags\//, "")
                    echo "Detected tag: ${TAG_NAME}"

                    // Check if the tag is on production branch
                    def baseBranch = sh(
                        script: "git merge-base --all ${TAG_NAME} origin/production > /dev/null && echo true || echo false",
                        returnStdout: true
                    ).trim()

                    if (baseBranch != "true") {
                        echo "Tag ${TAG_NAME} is not based on production branch."
                        currentBuild.result = 'NOT_BUILT'
                        error("Tag is not on production.")
                    }

                    echo "Tag ${TAG_NAME} is valid and on production branch."
                }
            }
        }

        stage('Build for Tag') {
            steps {
                echo "Building for tag: ${TAG_NAME}"
                sh './Build.sh'
            }
        }
    }
}