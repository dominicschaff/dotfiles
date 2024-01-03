#!/usr/bin/env bash

if ! hash terraform 2>/dev/null; then
  return
fi

complete -C terraform terraform

alias tf='terraform fmt --recursive'
alias ti='terraform init -backend=false'
alias tv='terraform validate'
alias t_verbose='export TF_LOG=true'
alias t_verbose_off='unset TF_LOG'


