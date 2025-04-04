pipeline {
    agent any
    environment {
        AZURE_CREDENTIALS_ID = 'jenkins-pipeline-sp'
        RESOURCE_GROUP = 'example-resources'
        APP_SERVICE_NAME = 'example-app-service123'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/Bhavika6940/WebApiJenkin'
            }
        }

        stage('Build') {
            steps {
                bat 'dotnet restore'
                bat 'dotnet build --configuration Release'
                bat 'dotnet publish -c Release -o ./publish'
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat "az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID"
                    bat "powershell Compress-Archive -Path ./publish/* -DestinationPath ./publish.zip -Force"
                    bat "az webapp deploy --resource-group $RESOURCE_GROUP --name $APP_SERVICE_NAME --src-path ./publish.zip --type zip"
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
