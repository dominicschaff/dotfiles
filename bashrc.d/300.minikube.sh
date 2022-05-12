#!/usr/bin/env bash

if ! hash minikube 2>/dev/null; then
  return
fi

alias m='minikube'
alias ms='minikube start --mount=true --mount-string=/home/merlin/Development/ska_storage/:/host_data/'

eval "$(minikube completion bash)"

