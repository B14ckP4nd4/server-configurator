#!/usr/bin/env bash
# https://github.com/B14ckP4nd4

base="/var/cwn"

# update Server
  echo 'assumeyes=1' >> /etc/yum.conf \
  && sudo yum --disablerepo=\* --enablerepo=base,updates update

#install epel-release

  if [[ ! -f "$base/install/epel-release" ]]; then
      yum install epel-release \
      && yum update
  fi

#install Development Tools

  if [[ ! -f "$base/install/development-tools" ]]; then
      yum group install "Development Tools"
  fi