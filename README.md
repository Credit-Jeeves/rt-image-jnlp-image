This repo is for the building the image that builds images
I.e. this container is run by the other image repo's, to build the images

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

