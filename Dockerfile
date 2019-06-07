# Dockerfile for building images, uses jnlp slave
FROM jenkins/jnlp-slave

USER root

RUN apt-get update -y
RUN apt-get install -y vim
RUN apt-get install -y gcc
RUN apt-get install -y make
RUN apt-get install -y cmake

RUN apt-get --yes --force-yes install unzip
RUN apt-get -y install awscli

# Install AWS CLI
#RUN apt-get -y install awscli
RUN apt-get -y install python3-pip
#RUN pip3 install awscli --upgrade --user
RUN pip3 install awscli --upgrade

RUN apt-get update && \
apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
apt-get update && \
apt-get -y install docker-ce
RUN apt-get install -y docker-ce
RUN groupmod -g 497 docker
RUN usermod -a -G docker jenkins

RUN chown -R jenkins:jenkins /home/jenkins

USER jenkins


