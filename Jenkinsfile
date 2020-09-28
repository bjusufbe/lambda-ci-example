def COLOR_MAP = [
  'SUCCESS': 'good', 
  'FAILURE': 'danger',
  'UNSTABLE': 'warning'
]

pipeline {
  agent {
    label 'ci_test_environment_node'
  }
  stages {
    stage('Build project and create deployment package') {
      steps {
        script {
          sh "chmod +x ./deploy/create_deployment_package.sh"
          env.RESULT = sh(script:'./deploy/create_deployment_package.sh -d ${DEPLOYMENT_PACKAGE_PATH} -n ${DEPLOYMENT_PACKAGE_NAME}', returnStdout: true).trim()
          if (env.RESULT.contains("Deployment package has been created successfully!")) {
            sh 'exit 0'
          } else {
            sh 'exit 1'
          }
        }
      }
    }
    stage('Update lambda function') {
      steps {
        script {
          sh "chmod +x ./deploy/create_update_lambda_function.sh"
          env.RESULT = sh(script:'./deploy/create_update_lambda_function.sh -f ${FUNCTION_NAME} -d ${DEPLOYMENT_PACKAGE_PATH}/${DEPLOYMENT_PACKAGE_NAME} -r ${REGION} -a ${ROLE_ARN} -h ${HANDLER_NAME} -m ${MODE}', returnStdout: true).trim()
          if (env.RESULT.contains("AWS lambda function ${FUNCTION_NAME} has been created/updated successfully!")) {
            sh 'exit 0'
          } else {
            sh 'exit 1'
          }
        }
      }
    }
    stage('Invoke lambda function') {
      steps {
        script {
          sh "chmod +x ./deploy/invoke_lambda_function.sh"
          env.RESULT = sh(script:'./deploy/invoke_lambda_function.sh -f ${FUNCTION_NAME} -r ${REGION} -p ${PAYLOAD}', returnStdout: true).trim()
          if (env.RESULT.contains("AWS lambda function ${FUNCTION_NAME} has been executed successfully!")) {
            sh 'exit 0'
          } else {
            sh 'exit 1'
          }
        }
      }
    }
  }
  post {
    always {
      slackSend channel: '#jenkins-notifications',
      color: COLOR_MAP[currentBuild.currentResult],
      message: """*${currentBuild.currentResult}:* 
      Job *${env.JOB_NAME}* with build number: *${env.BUILD_NUMBER}* is completed.
      More info at: ${env.BUILD_URL}"""
    }
  }
}
