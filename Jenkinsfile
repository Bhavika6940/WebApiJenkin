pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Bhavika6940/WebApiJenkin', branch: 'master'
        }
    }

    stage('Terraform Init') {
        steps {
            bat 'terraform init'
         }
    }

    stage('Terraform Plan') {
        steps {
            bat '''
                terraform plan ^
                  -var client_id=%ARM_CLIENT_ID% ^
                  -var client_secret=%ARM_CLIENT_SECRET% ^
                  -var tenant_id=%ARM_TENANT_ID% ^
                  -var subscription_id=%ARM_SUBSCRIPTION_ID%
                '''
        }
    }

    stage('Terraform Apply') {
        steps {
            bat '''
                terraform apply -auto-approve ^
                -var client_id=%ARM_CLIENT_ID% ^
                -var client_secret=%ARM_CLIENT_SECRET% ^
                -var tenant_id=%ARM_TENANT_ID% ^
                -var subscription_id=%ARM_SUBSCRIPTION_ID%
            '''
        }
    }
    stage('Build .NET App') {
        steps {
            dir('WebApiJenkins') { // Adjust to your .NET project folder
                bat 'dotnet publish WebApiJenkins.csproj -c Release -o publish'

            }
        }
    }

    stage('Deploy to Azure') {
        steps {
            withCredentials([
                string(credentialsId: 'AZURE_CLIENT_ID', variable: 'AZURE_CLIENT_ID'),
                string(credentialsId: 'AZURE_CLIENT_SECRET', variable: 'AZURE_CLIENT_SECRET'),
                string(credentialsId: 'AZURE_TENANT_ID', variable: 'AZURE_TENANT_ID')
            ]) {
                bat '''
                    az login --service-principal ^
                    --username %AZURE_CLIENT_ID% ^
                    --password %AZURE_CLIENT_SECRET% ^
                    --tenant %AZURE_TENANT_ID%

                    powershell Compress-Archive -Path WebApiJenkins\\publish\\* -DestinationPath publish.zip -Force

                    az webapp deploy --resource-group jenkins-bhavika-rg --name jenkins-bhavika-app123 --src-path publish.zip --type zip
                '''
            }
        }
    }
}
}
