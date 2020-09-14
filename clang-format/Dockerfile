FROM debian:buster
LABEL maintainer "Toshiki Teramura <toshiki.teramura@gmail.com>"

RUN apt-get update && apt-get install -y \
    git clang-format \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY check-format.sh /usr/bin

ENTRYPOINT /usr/bin/check-format.sh
