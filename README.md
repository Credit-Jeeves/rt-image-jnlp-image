This repo is for building the image that builds images
I.e. this container is run by the other image builder repo's

NOTE: This image uses itself to build itself

Update JNLP image to latest

  make image_update

--------
Make image from Dockerfile:

  make image_build

--------
Publish image to ECR

  make publish

--------
Run container locally (need jnlp args, currently not implemented)

  make myrun

