#!/usr/bin/env bash

if ! hash wget 2>/dev/null; then
  return
fi

mirror()
{
  wget \
    --mirror \
    --recursive \
    --convert-links \
    --adjust-extension \
    --page-requisites \
    --no-parent \
    --quiet \
    --show-progress \
    "$1"
}