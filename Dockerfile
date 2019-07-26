FROM ubuntu as base

RUN apt-get update
RUN apt-get install -y wget
WORKDIR /temp

#INSTALL GO
RUN wget https://dl.google.com/go/go1.12.linux-amd64.tar.gz
RUN tar -xvf go1.12.linux-amd64.tar.gz
RUN ls go1.12.linux-amd64.tar.gz
RUN mv go /usr/local
ENV GOROOT=/usr/local/go
ENV HOME=/root
ENV GOPATH=$HOME/go
ENV PATH=$HOME/go/bin:/usr/local/go/bin:$PATH

#INSTALL GIT
RUN apt-get install -y git

#INSTALL nodejs
RUN wget https://nodejs.org/dist/v10.16.0/node-v10.16.0-linux-x64.tar.gz
RUN tar -xvf node-v10.16.0-linux-x64.tar.gz
RUN mkdir -p /usr/local/lib/nodejs
RUN mv node-v10.16.0-linux-x64 /usr/local/lib/nodejs
ENV PATH=/usr/local/lib/nodejs/node-v10.16.0-linux-x64/bin:$PATH

#INSTALL make
RUN apt-get install -y build-essential

#INSTALL yarn
RUN npm install --global yarn

#INSTALL SQLite
WORKDIR /temp
RUN apt-get install -y libpcre3-dev libsqlite3-dev pkg-config musl-tools

#INSTALL NGINX
RUN apt-get install -y nginx

#clean up
WORKDIR /temp
RUN rm -rf ./*

WORKDIR $HOME/sourcegraph

#INSTALL DOCKER
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN apt-get install -y docker-ce docker-ce-cli containerd.io


COPY ./code $HOME/sourcegraph

#remove windows end lines
RUN apt-get install -y dos2unix
RUN find . -name *.sh -exec dos2unix {} \;

WORKDIR $HOME/sourcegraph/dev

RUN ./install.sh

ENTRYPOINT [ "/bin/bash","launch.sh" ]


