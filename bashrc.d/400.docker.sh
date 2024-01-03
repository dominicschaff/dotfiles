#!/usr/bin/env bash

if ! hash docker 2>/dev/null; then
  return
fi


docker_clean()
{
  docker_stop_all
  docker system prune --all --force
  docker container prune --force
  docker image prune --all --force
  docker volume prune --force
  docker network prune --force
}

docker_stop_all()
{
    docker kill $(docker ps -q)
}

docker_start()
{
  sudo systemctl restart docker
}

docker_stop_service()
{
  sudo systemctl stop docker
}


alias lzd='lazydocker'

update_lazydocker()
{
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
}

