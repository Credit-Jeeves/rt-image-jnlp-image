# Dockerfile for building images, uses jnlp slave
FROM jenkins/jnlp-slave

USER root

RUN apt-get update -y
RUN apt-get install -y vim
RUN apt-get install -y gcc
RUN apt-get install -y make
RUN apt-get install -y cmake
RUN apt-get install -y wget

RUN apt-get -y install zip
RUN apt-get --yes --force-yes install unzip
RUN apt-get -y install awscli

# Install AWS CLI
#RUN apt-get -y install awscli
RUN apt-get -y install python3-pip
#RUN pip3 install awscli --upgrade --user
RUN pip3 install awscli --upgrade

# Install AWS ECS CLI
RUN curl -Lo /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
RUN chmod +x /usr/local/bin/ecs-cli
RUN ln -s /usr/local/bin/ecs-cli /usr/bin/ecs-cli

# Install docker in container, so we can run docker build when building images
RUN apt-get update && \
apt-get -y install apt-transport-https \
    ca-certificates \
    lsb-release \
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

# Install docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
RUN chmod +x /usr/bin/docker-compose

# Change docker group id in container to match docker group id on ecs instance
# So /var/run/docker.sock works properly in container
RUN groupmod -g 497 docker

# Install php 7.x, not sure why I need this anymore
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN lsb_release -a
RUN apt-get update
RUN apt-get install -y php7.2 php7.2-cli php7.2-common
RUN apt-get install -y php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-intl php7.2-mysql php7.2-xml php7.2-zip php7.2-bz2
RUN php -v

# Add jenkins user to group docker, so jenkins user can run docker commands
RUN usermod -a -G docker jenkins

RUN chown -R jenkins:jenkins /home/jenkins

USER jenkins


