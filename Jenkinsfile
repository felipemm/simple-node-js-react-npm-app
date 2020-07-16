def dockerRemote = [:]
dockerRemote.name = 'docker'
dockerRemote.host = 'srv-newserv-docker'
dockerRemote.allowAnyHosts = true

pipeline {

    agent { docker { image 'node:6-alpine' } }

    environment {
        CONTAINER_NAME = "simple-node-js-react-npm-app"
        CONTAINER_EXTERNAL_PORT = 18170
        CONTAINER_PORT = 3000
        REGISTRY_HOST = "dev.logicinfo.com"
        REGISTRY_IMAGE_ID = "${REGISTRY_HOST}/${CONTAINER_NAME}"
        REGISTRY_URL = "https://${REGISTRY_HOST}"
        REGISTRY_CREDENTIAL_ID = "adm-jenkins-nexus"
        NEXUS_CREDENTIAL_ID = "adm-jenkins-docker-srv"
        DOCKER_RUN_EXTRA_ARGS = "--network=postgres-network"
    }



    options {
        skipStagesAfterUnstable()
    }
    
    triggers {
        gitlab(
            triggerOnPush: true,
            triggerOnMergeRequest: true,
            branchFilterType: "NameBasedFilter",
            includeBranchesSpec: "master",
            secretToken: "e44ee0dd187f821346a44d388045814b"
        )
    }

    stages {
        stage('Build App') { 
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build REGISTRY_IMAGE_ID // + ":$BUILD_NUMBER"
                }
            }
        }

        stage('Upload Docker Image to Nexus') {
            steps{
                script {
                    docker.withRegistry( REGISTRY_URL , REGISTRY_CREDENTIAL_ID ) {
                        dockerImage.push()
                    }
                }
            }
        }
        
        
        stage('Deploy Container into Docker Host') {
            steps {
                script{
                    withCredentials([sshUserPrivateKey(credentialsId: NEXUS_CREDENTIAL_ID, keyFileVariable: 'dockerHostKeyfile', passphraseVariable: 'dockerHostPassphrase', usernameVariable: 'dockerHostUsername')]) {
                        dockerRemote.user = dockerHostUsername
                        dockerRemote.identityFile = dockerHostKeyfile
                        dockerRemote.passphrase = dockerHostPassphrase
                        
                        sshCommand remote: dockerRemote, failOnError: false, command: "docker stop ${CONTAINER_NAME}"
                        sshCommand remote: dockerRemote, failOnError: false, command: "docker rm ${CONTAINER_NAME}"
                        sshCommand remote: dockerRemote, failOnError: true, command: "docker pull ${REGISTRY_IMAGE_ID}"
                        sshCommand remote: dockerRemote, failOnError: true, command: "docker run --name ${CONTAINER_NAME} ${DOCKER_RUN_EXTRA_ARGS} -p ${CONTAINER_EXTERNAL_PORT}:${CONTAINER_PORT} -d ${REGISTRY_IMAGE_ID}"
                    }
                }
            }
        }
    }
}