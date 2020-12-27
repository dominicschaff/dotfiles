#!/usr/bin/env bash

if ! hash docker 2>/dev/null; then
  return
fi


docker_clean()
{
    docker_stop_all;
    docker rm --force $(docker ps -a -q);
    docker rmi --force $(docker images -q)
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
