pipeline {

    agent any

    environment {
        ENV = "dev"
        APP_NAME = "raas-db"
        EXTERNAL_PORT = 5556
        CONTAINER_PORT = 5432
        DOCKER_VOLUME = "${APP_NAME}-data-${ENV}"
        DOCKER_VOLUME_MOUNTPOINT="${DOCKER_VOLUME}:/var/lib/postgresql/data"
        DOCKER_RUN_EXTRA_ARGS = "--memory 2g --name ${APP_NAME}-${ENV} --publish ${EXTERNAL_PORT}:${CONTAINER_PORT} --volume ${DOCKER_VOLUME_MOUNTPOINT} --restart always -h ${APP_NAME}-${ENV} -e 'POSTGRES_PASSWORD=Logic123'"

        DOCKER_REMOTE_SERVER = 'tcp://srv-newserv-docker:2375'
        CONTAINER_NAME = "${APP_NAME}"
        REGISTRY_HOST = "dev.logicinfo.com"
        REGISTRY_IMAGE_ID = "${REGISTRY_HOST}/${CONTAINER_NAME}"
        REGISTRY_URL = "https://${REGISTRY_HOST}"
        REGISTRY_CREDENTIAL_ID = "adm-jenkins-nexus"
        NEXUS_CREDENTIAL_ID = "adm-jenkins-docker-srv"
    }

    options {
        skipStagesAfterUnstable()
    }
    
    stages {
        stage('Test') {
            steps{
                sh 'echo ${env.GIT_BRANCH}'
            }
        }

        //stage('Build App') { 
        //    agent { docker { image 'node' } }
        //    steps {
        //        sh 'npm run build'
        //    }
        //}
        //
        //stage('Build Docker Image') {
        //    agent any
        //    steps {
        //        script {
        //            dockerImage = docker.build REGISTRY_IMAGE_ID // + ":$BUILD_NUMBER"
        //        }
        //    }
        //}        
        //
        //stage('Deploy Container') {
        //    agent any
        //    steps {
        //        sh 'docker ps -fname=${APP_NAME} -q | xargs --no-run-if-empty docker container stop'
        //        sh 'docker container ls -a -fname=${APP_NAME} -q | xargs -r docker container rm'
        //        sh 'docker run --name ${APP_NAME} '
        //    } 
        //}        
    }
}
