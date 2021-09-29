#!/usr/bin/env bash

if ! hash terraform 2>/dev/null; then
  echo "No terraform"
  return
fi

alias tf='terraform fmt --recursive'
alias ti='terraform init -backend=false'
alias tv='terraform validate'


