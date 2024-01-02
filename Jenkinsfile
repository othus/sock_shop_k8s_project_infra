pipeline {
    agent any
    tools {
        terraform 'terraform'
    }

    stage {
        stage('Initialise Terraform') {
            steps {
                sh 'terraform init'
            }
        }
    }
    stage {
        stage('Terraform format') {
            steps {
                sh 'terraform fmt'
            }
        }
    }
    stage {
        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
    }
    stage {
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
    }
    stage ('Prompt for apply or destroy approval'){
      steps {
        timeout(activity: true, time: 5) {
          input message: 'Needs approval to apply or destroy', submitter: 'admin'
        }
      }
    }
    stage {
        stage('Terraform Apply or Destroy action') {
            steps {
                sh 'terraform ${action} -auto-approve'
            }
        }
    }
}