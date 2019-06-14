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

average_file_size()
{
  \ls -l | awk 'BEGIN {max = 0} {sum += $5; n++; if ($5>max) max=$5;} END {print n " files"; print sum/n/1024 " kB"; print "Largest " max/1024 " kB";}'
}
