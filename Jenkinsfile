pipeline {
  agent { label 'jenkins-gradle' }
  environment {
    ORG = 'kennyhoang2208'
    APP_NAME = 'spring-testing'
    CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
  }
  stages {
    stage('CI Build and push snapshot') {
      when {
        branch 'PR-*'
      }
      environment {
        PREVIEW_VERSION = "0.0.0-SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER"
        PREVIEW_NAMESPACE = "$APP_NAME-$BRANCH_NAME".toLowerCase()
        HELM_RELEASE = "$PREVIEW_NAMESPACE".toLowerCase()
      }
      steps {
        container('gradle') {
          sh "gradle clean build"

          // build docker images
          sh "export VERSION=$PREVIEW_VERSION && skaffold build -f skaffold.yaml"
          sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:$PREVIEW_VERSION"
          dir('./charts/preview') {
            sh "make preview"
            sh "jx preview --app $APP_NAME --dir ../.."
          }
        }
      }
    }

    stage('Integration Test') {
      when {
        branch 'PR-*'
      }
      steps {
        container('gradle') {
          sh "echo 'Running integration tests ....'"
          sh "gradle integrationTest"
        }
      }
    }

    stage('Build Preview Image') {
      when {
        branch 'master'
      }
      steps {
        container('gradle') {

          // Build the preview version for the service
          // This is useful to other services can use this as a dependency
          sh "sh build-preview-version.sh"
        }
      }
    }

    stage('Release Preview Helm Chart') {
      when {
        branch 'master'
      }
      steps {
        container('gradle') {
          dir('./charts/spring-testing') {
            // Release a latest version
            // This is to make other services easier to use this as their dependencies
            sh "echo '0.1.0-preview' > VERSION"
            sh "jx step changelog --version v\$(cat ../../VERSION)"

            // release the helm chart
            sh "jx step helm release"
          }
        }
      }
    }

    stage('Build Release') {
      when {
        branch 'master'
      }
      steps {
        container('gradle') {

          // ensure we're not on a detached head
          sh "git checkout master"
          sh "git config --global credential.helper store"
          sh "jx step git credentials"

          // so we can retrieve the version in later steps
          sh "echo \$(jx-release-version) > VERSION"
          sh "jx step tag --version \$(cat VERSION)"
          sh "gradle clean build"
          sh "export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml"
          sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)"
        }
      }
    }
    stage('Promote to Environments') {
      when {
        branch 'master'
      }
      steps {
        container('gradle') {
          dir('./charts/spring-testing') {
            sh "jx step changelog --version v\$(cat ../../VERSION)"

            // release the helm chart
            sh "jx step helm release"

            // promote through all 'Auto' promotion Environments
            sh "jx promote -b --all-auto --timeout 1h --version \$(cat ../../VERSION)"
          }
        }
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
