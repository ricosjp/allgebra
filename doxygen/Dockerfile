FROM ubuntu:20.04
LABEL maintainer "Toshiki Teramura <toshiki.teramura@gmail.com>"

# workaround for tzdata
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git doxygen graphviz \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
