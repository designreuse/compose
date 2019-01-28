#!/usr/bin/env bash

# set -f;export BACKUP_CRON="0 4 * * *";set +f
# set -f;export BACKUP_CRON="*/10 * * * *";set +f

export SECRET_PATH=/run/secrets
export PEM_PATH=$SECRET_PATH/certificates/usc

export SITE=swarm
export DOMAIN_NAME=$SITE.usc.edu

export HOME_PATH=$1
if [ "$HOME_PATH" = "" ]; then
    export HOME_PATH=$HOME
fi

export CODE_PATH=$HOME_PATH/workspace
export GITHUB_PATH=$CODE_PATH/github
export USC_PATH=$CODE_PATH/usc
export USC_DEV_PATH=$GITHUB_PATH/uscdev
export COMPOSE_PATH=$USC_DEV_PATH/compose
export DEVOPS_PATH=$USC_DEV_PATH/devops-example

set -f

docker stack deploy --compose-file $COMPOSE_PATH/docker-proxy/docker-compose.yml docker-proxy
docker stack deploy --compose-file $COMPOSE_PATH/proxy/docker-compose.yml proxy
sleep 10

docker stack deploy --compose-file $COMPOSE_PATH/visualizer/docker-compose.yml visualizer
docker stack deploy --compose-file $COMPOSE_PATH/portainer/docker-compose.yml portainer
docker stack deploy --compose-file $COMPOSE_PATH/filebrowser/docker-compose.yml filebrowser

docker stack deploy --compose-file $COMPOSE_PATH/monitor/docker-compose.yml monitor

docker stack deploy --compose-file $COMPOSE_PATH/logging/docker-compose.yml logging

docker stack deploy --compose-file $COMPOSE_PATH/selenium/docker-compose.yml selenium
# docker stack deploy --compose-file $COMPOSE_PATH/guacamole/guacamole-mysql-initdb/docker-compose.yml guacamole-setup
# shutdown setup program (or change to use remote db)
docker stack deploy --compose-file $COMPOSE_PATH/guacamole/docker-compose.yml guacamole

docker stack deploy --compose-file $COMPOSE_PATH/sonarqube/docker-compose.yml sonarqube
docker stack deploy --compose-file $COMPOSE_PATH/security/clair/docker-compose.yml clair

docker stack deploy --compose-file $COMPOSE_PATH/jenkins/docker-compose.yml jenkins
#docker stack deploy --compose-file $COMPOSE_PATH/jenkins-swarm-agent/docker-compose.yml jenkins-swarm-agent
docker stack deploy --compose-file $COMPOSE_PATH/nexus/docker-compose.yml nexus

docker stack deploy --compose-file $COMPOSE_PATH/wordpress/docker-compose.yml wordpress
docker stack deploy --compose-file $COMPOSE_PATH/windows/docker-compose.yml windows
docker stack deploy --compose-file $COMPOSE_PATH/hello-dual/docker-compose.yml hello-dual

docker stack deploy --compose-file $DEVOPS_PATH/docker-compose.yml devops-example
docker stack deploy --compose-file $COMPOSE_PATH/wordpress/wordpress-selenium-test/docker-compose.yml wordpress-test

set +f