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

          // # Ensure we're not on a detached head
          sh "git checkout master"
          sh "git config --global credential.helper store"
          sh "jx step git credentials"

          // Check if the latest existed. Delete it before creating a new one
          // Fetch new tags for checking tag existed
          sh "git fetch --tags --all --prune -f"
          sh "echo '0.1.0-SNAPSHOT' > VERSION"
          // sh "echo \$(jx-release-version -same-release) > VERSION"
          sh "sh cleanup-preview-tag.sh"

          // jx step tag will format `0.1.0-SNAPSHOT` to `v0.1.0-SNAPSHOT`
          sh "jx step tag --version \$(cat VERSION)"

          // Build and push the latest image
          sh "gradle clean build"
          sh "export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml"
          sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)"

        }
      }
    }

    stage('Release Preview Helm Chart') {
      when {
        branch 'master'
      }
      environment {
        TILLER_NAMESPACE = "kube-system"
      }
      steps {
        container('gradle') {
          dir('./charts/spring-testing') {
            // Release a latest version
            // This is to make other services easier to use this as their dependencies
            sh "echo '0.1.0-SNAPSHOT' > VERSION"
            sh "jx step changelog --version v0.1.0-SNAPSHOT"

            // Delete the snapshot chart before releasing a new one
            sh "jx step helm delete $APP_NAME-0.1.0-SNAPSHOT"
            sh "curl -X 'DELETE' http://jenkins-x-chartmuseum:8080/api/charts/$APP_NAME/0.1.0-SNAPSHOT"

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
