#!bin/bash
docker pull jenkins/jenkins
docker build .
docker run -p 8085:8080 --name=jenkinsasdasd jenkins/jenkins
