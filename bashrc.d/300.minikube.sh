#!/usr/bin/env bash

if ! hash minikube 2>/dev/null; then
  return
fi

alias m='minikube'
alias ms='minikube start'

