pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    def mvnHome = tool 'Maven'
                    sh "${mvnHome}/bin/mvn clean package -DskipTests"
                }
            }
        }
        stage('Docker Build and Push') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        def customImage = docker.build("your-docker-hub-username/hello-world-app:${env.BUILD_NUMBER}")
                        customImage.push()
                        customImage.push('latest')
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    def kubeConfig = credentials('kube-config')
                    kubeConfig.withCredentials([file(credentialsId: 'kube-config', variable: 'KUBECONFIG')]) {
                        sh "kubectl apply -f deployment.yaml"
                        sh "kubectl apply -f service.yaml"
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline succeeded! Application deployed.'
        }
    }
}

