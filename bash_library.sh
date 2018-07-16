#!/usr/bin/env bash

# the following has been taken from <https://misc.flogisoft.com/bash/tip_colors_and_formatting>
ALL_CLEAR='\e[0m'

CLR_RED='\e[31m'
CLR_GREEN='\e[32m'
CLR_YELLOW='\e[33m'
CLR_BLUE='\e[34m'
CLR_MAGENTA='\e[35m'
CLR_CYAN='\e[36m'
CLR_DEFAULT='\e[39m'
CLR_WHITE='\e[97m'
CLR_LIGHT_GRAY='\e[37m'
CLR_DARK_GRAY='\e[90m'
CLR_LIGHT_RED='\e[91m'
CLR_LIGHT_GREEN='\e[92m'
CLR_LIGHT_YELLOW='\e[93m'
CLR_LIGHT_BLUE='\e[94m'
CLR_LIGHT_MAGENTA='\e[95m'
CLR_LIGHT_CYAN='\e[96m'

STYLE_BOLD='\e[1m'
STYLE_DIM='\e[2m'
STYLE_UNDERLINE='\e[4m'
STYLE_BLINK='\e[5m'
STYLE_INVERSE='\e[7m'

LOG_DATE="%Y-%m-%d %T"

log_time()
{
  echo "$(date +"$LOG_DATE") [INFO] $@"
}

log_none()
{
  echo "$(date +"$LOG_DATE") [INFO] $@" >&2
}

log_debug()
{
  echo "$(date +"$LOG_DATE") [DEBUG] $@" >&2
}

log_ok()
{
  echo -e "$(date +"$LOG_DATE") $CLR_GREEN[OKAY]$ALL_CLEAR $@" >&2
}

log_fail()
{
  echo -e "$(date +"$LOG_DATE") $CLR_RED[FAIL]$ALL_CLEAR $@" >&2
}

log_info()
{
  echo -e "$(date +"$LOG_DATE") $CLR_CYAN[INFO]$ALL_CLEAR $@" >&2
}

log_error()
{
  echo -e "$(date +"$LOG_DATE") $CLR_RED[ERROR]$ALL_CLEAR $@" >&2
}

log_warn()
{
  echo -e "$(date +"$LOG_DATE") $CLR_YELLOW[WARN]$ALL_CLEAR $@" >&2
}

log_end()
{
  echo -e "$(date +"$LOG_DATE") $CLR_MAGENTA[END]$ALL_CLEAR $@" >&2
}

seconds_to_time()
{
  date -ud "@$1" +'%H:%M:%S'
}

log_end_time()
{
  log_end "Script took $SECONDS seconds to run [$(seconds_to_time $SECONDS)]"
}

json_log()
{
  jq -cn \
    --arg date "$(date +"%F %H:%M:%S")" \
    --arg data "$1" \
    '{
      "date": $date,
      "data": $data
    }'
}

check_file_exists()
{
  for f in "$@"; do
    if [ ! -f "$f" ]; then
      log_error "File does not exist: $f"
      exit 1
    fi
  done
}

check_not_empty()
{
  if [ -z "$1" ]; then
    log_error "Data Missing"
    exit 1
  fi
}

check_not_null()
{
  if [[ "$1" == "null" ]]; then
    log_error "Data Missing"
    exit 1
  fi
}

check_program_exists()
{
  if ! hash $1 2>/dev/null; then
    log_error "Program $1 does not exist"
    exit 1
  fi
}

last_week()
{
  date -d"last week $1" +%Y-%m-%d
}

file_age()
{
  FILE_CREATED_TIME=`date -r "$1" +%s`
  TIME_NOW=`date +%s`
  echo "$((TIME_NOW - FILE_CREATED_TIME))"
}