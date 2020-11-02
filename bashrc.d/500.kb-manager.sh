#!/usr/bin/env bash

if ! hash kb 2>/dev/null; then
  return
fi

alias kbl="kb list"
alias kbe="kb edit"
alias kba="kb add"
alias kbv="kb view"
alias kbd="kb delete --id"
alias kbg="kb grep"
alias kbt="kb list --tags"

