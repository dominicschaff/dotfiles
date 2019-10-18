#!/usr/bin/env bash

if ! hash awk 2>/dev/null; then
  return
fi

col_max()
{
  awk 'BEGIN {max = -1000000000} {if ($1>max) max=$1} END {print max}'
}

col_min()
{
  awk 'BEGIN {min = 1000000000} {if ($1<min) min=$1} END {print min}'
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
  \ls -l | file_size_stats
}

file_size_stats()
{
  cat - | awk 'BEGIN {sum=0; max = 0} {sum += $5; n++; if ($5>max) max=$5;} END {print n " files"; print "Total " sum/1024 " kB"; print "Average " sum/n/1024 " kB"; print "Largest " max/1024 " kB";}'
}
