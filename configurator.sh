#!/usr/bin/env bash
# https://github.com/B14ckP4nd4

# update Server
  echo 'assumeyes=1' >> /etc/yum.conf \
  && sudo yum --disablerepo=\* --enablerepo=base,updates update

#install epel-release

  if [[ ! -f "$BASE_PATH/install/epel-release" ]]; then
      yum install epel-release \
      && yum update
      touch "$BASE_PATH/install/epel-release"
  fi

#install Development Tools

  if [[ ! -f "$BASE_PATH/install/development-tools" ]]; then
      yum group install "Development Tools"
      touch "$BASE_PATH/install/development-tools"
  fi

# install docker

  if [ ! -x "$(command -v docker)" ]; then
    sudo yum install -y yum-utils \
     device-mapper-persistent-data \
     lvm2

    sudo yum-config-manager \
      --add-repo \
      https://download.docker.com/linux/centos/docker-ce.repo

    sudo yum install docker-ce docker-ce-cli containerd.io

    # start Docker
    sudo systemctl start docker && sudo systemctl enable docker
  fi

# create needed folders

  if [ ! -d "$BASE_PATH/containers" ]; then
    sudo mkdir "$BASE_PATH/containers"
  fi