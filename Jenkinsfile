pipeline {
    agent {
        label 'image-worker'
    }
    stages {
        stage('Build Image') {
            steps {
                sh 'make image_build'
            }
        }
        stage('Publish Image') {
            steps {
                sh 'make region=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed "s/[a-z]$//"` publish'
            }
        }
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
            sh 'docker image list'
        }
        failure {
            echo 'This will run only if failed'
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
        changed {
            echo 'This will run only if the state of the Pipeline has changed'
            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
}
