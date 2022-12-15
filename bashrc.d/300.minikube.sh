#!/usr/bin/env bash

if ! hash minikube 2>/dev/null; then
  return
fi

alias m='minikube'
alias ms='minikube start --mount=true --mount-string=$HOME/Development/shared_storage/:/host_data/; minikube addons enable ingress'

alias mk_docker='eval $(minikube docker-env)'

eval "$(minikube completion bash)"

