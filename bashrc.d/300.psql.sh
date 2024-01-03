#!/usr/bin/env bash

if ! hash psql 2>/dev/null; then
  return
fi


psql_csv()
{
  psql service=$1 -c "\copy ($2) to stdout csv header;"
}
