#!/usr/bin/env bash

if ! hash python3 2>/dev/null; then
  return
fi

# copied from https://github.com/pypa/pip/issues/7883
# 1-May-2020: Fix for Keyring error with pip. Hopefully new pip will fix it
# soon https://github.com/pypa/pip/issues/7883
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

pip3_install()
{
  python3 -m pip install --user --upgrade -r $DOTFILES/requirements.txt
}

py_clean()
{
  for f in "$@"; do
    isort --profile black -w 99 "$f"
    black --line-length 99 "$f"
  done
}
