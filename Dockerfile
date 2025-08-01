# Dockerfile

FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install -y build-essential cmake g++ git curl zip unzip && \
    apt-get clean

RUN mkdir -p /data
VOLUME ["/data"]

USER jenkins
