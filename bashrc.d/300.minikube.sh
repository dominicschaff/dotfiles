#!/usr/bin/env bash

if ! hash minikube 2>/dev/null; then
  return
fi

export MINIKUBE_IN_STYLE=false

alias mk_docker='eval $(minikube docker-env)'

eval "$(minikube completion bash)"

