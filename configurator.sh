#!/usr/bin/env bash
# https://github.com/B14ckP4nd4

  # source
  #. ~/.bash_profile


# ==================================================
# ================= UPDATE SERVER ==================
# ==================================================

  echo 'assumeyes=1' >> /etc/yum.conf \
  && sudo yum --disablerepo=\* --enablerepo=base,updates update

# ==================================================
# ================= Default PATHs ==================
# ==================================================

  #installed path
  if [ ! -d "$installed_path" ]; then
    mkdir -p "$installed_path"
  fi

  #container path
  if [ ! -d "$containers_path" ]; then
    sudo mkdir "$containers_path"
  fi

 #volumes path
  if [ ! -d "$volumes_path" ]; then
    mkdir -p "$volumes_path"
  fi

  #temp path
  if [ ! -d "$temp_path" ]; then
    mkdir -p "$temp_path"
  fi

# ==================================================
# ============== Install Dependencies ==============
# ==================================================


  #install epel-release
  if [[ ! -f "$installed_path/epel-release" ]]; then
      yum install epel-release \
      && yum update
      touch "$installed_path/epel-release"
  fi

  #install Development Tools
  if [[ ! -f "$installed_path/development-tools" ]]; then
      yum group install "Development Tools"
      touch "$installed_path/development-tools"
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


# ==================================================
# ============= Network Configuration ==============
# ==================================================

docker network ls | grep $docker_base_network > /dev/null || docker create network $docker_base_network


# ==================================================
# =================== Containers ===================
# ==================================================

  # build and run squid container
    # remove old repo
    rm -rf $squid_path
    # get new repo
    git clone $squid_repo $squid_path
    # set permitions for run
    chmod +x "$squid_path/build.sh"
    # hit it up
    .$squid_path/build.sh


