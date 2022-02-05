#!/usr/bin/env bash

if ! hash rsync 2>/dev/null; then
  return
fi

sync_pull()
{
  rsync -hvPa --size-only --delete --stats $1 ./
}

sync_push()
{
  rsync -hvPa --size-only --delete --stats $1 $2
}

