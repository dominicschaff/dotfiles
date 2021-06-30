#!/usr/bin/env bash

if ! hash bc 2>/dev/null; then
  return
fi

calc()
{
  echo "scale=3; $*" | bc
}
