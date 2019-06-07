all: myrun

# This makefile contains some convenience commands for deploying and publishing.

# For example, to build and run the docker container locally, just run:
# $ make

# or to publish the :latest version to the specified registry as :1.0.0, run:
# $ make publish version=1.0.0

region ?= us-east-1
#aws_profile = rtdevelopment
name = jnlp-image
image_name = jenkins/jnlp-slave
registry = 874727002155.dkr.ecr.us-east-1.amazonaws.com/rt-jenkins/master
version ?= latest

ecr_login:
	$(call blue, "Login to AWS ECR...")
#	eval `aws --profile ${aws_profile} ecr get-login --no-include-email`
	eval `aws ecr --region ${region} get-login --no-include-email`

binary:
	$(call blue, "Building binary ready for containerisation...")
	docker run --rm -it -v "${GOPATH}":/gopath -v "$(CURDIR)":/app -e "GOPATH=/gopath" -w /app golang:1.7 sh -c 'CGO_ENABLED=0 go build -a --installsuffix cgo --ldflags="-s" -o app'

image: binary
	$(call blue, "Building docker image from container...")
	docker build -t ${name}:${version} .
	$(MAKE) clean

image_build:
	$(call blue, "Building docker image from Dockerfile...")
	docker build -t ${name}:${version} .
	$(MAKE) clean

run: image
	$(call blue, "Running Docker image locally...")
	docker run -i -t --rm -p 80:80 ${name}:${version} 

myrun:
	$(call blue, "Running Docker image locally...")
	docker run -i -t --rm -p 3000:3000 ${name}:${version} 

publish: ecr_login
	$(call blue, "Publishing Docker image to registry...")
	docker tag ${name}:latest ${registry}/${name}:${version}
	docker push ${registry}/${name}:${version} 

image_update:  
	$(call blue, "Updating JNLP Docker image to latest...")
	docker pull ${image_name}:latest

clean: 
	@echo "cleaning nothing"

define blue
#	@tput setaf 6
	@echo $1
#	@tput sgr0
endef
