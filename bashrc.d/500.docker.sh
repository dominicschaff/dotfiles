#!/usr/bin/env bash

if ! hash docker 2>/dev/null; then
  return
fi


docker_clean()
{
  docker_stop_all
  docker system prune
  docker container prune
  docker image prune -a
  docker volume prune
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
