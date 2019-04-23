#!/usr/bin/env bash

col_max()
{
  awk 'BEGIN {max = 0} {if ($1>max) max=$1} END {print max}'
}

col_avg()
{
  awk '{ sum += $1 } END { if (NR > 0) print sum / NR; }'
}

col_sum()
{
  awk '{ sum += $1 } END { print sum }'
}

wc_pretty()
{
  wc -l "$@" | awk '{printf(fmt,$1,$2)}' fmt="%'15.0f %s\n"
}