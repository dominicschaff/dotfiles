#!/usr/bin/env bash

# the following has been taken from
# <https://misc.flogisoft.com/bash/tip_colors_and_formatting>
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

if [[ -n "$SHORT" ]]; then
  TIME_ONLY=1
  LOG_SHORT=1
fi

if [[ -z "$TIME_ONLY" ]]; then
  LOG_DATE="%Y-%m-%d %T"
else
  LOG_DATE="%T"
fi

################################################################################
# This section sets up the logging functions
# log_time() -> Log with no type set
# log_ok() -> Log OKAY type
# log_fail() -> Log failure type
# log_debug() -> Log debug type
# log_info() -> Log info type
# log_warn() -> Log warning type
# log_error() -> Log error type
# log_end() -> Log special end type
################################################################################
if [[ -z "$LOG_SHORT" ]]; then
  __log_to_error() { echo -e "[$(date +"$LOG_DATE")]: $*" >&2; }
  log_time() { __log_to_error "$*"; }
  log_debug() { __log_to_error "${CLR_MAGENTA}[D]$ALL_CLEAR $*"; }
  log_ok() { __log_to_error "${CLR_GREEN}[P]$ALL_CLEAR $*"; }
  log_fail() { __log_to_error "${CLR_RED}[F]$ALL_CLEAR $*"; }
  log_info() { __log_to_error "${CLR_CYAN}[I]$ALL_CLEAR $*"; }
  log_error() { __log_to_error "${CLR_RED}[E]$ALL_CLEAR $*"; }
  log_warn() { __log_to_error "${CLR_YELLOW}[W]$ALL_CLEAR $*"; }
  log_end() { __log_to_error "${CLR_MAGENTA}[--]$ALL_CLEAR $*"; }
  log_yes() { __log_to_error "${CLR_GREEN✔}$ALL_CLEAR"; }
  log_no() { __log_to_error "${CLR_RED✕}$ALL_CLEAR"; }
else
  __log_to_error() {
    clr="$1"
    shift 1
    echo -e "$clr$(date +"$LOG_DATE") : $ALL_CLEAR$*" >&2
  }
  __log_to_error_all_colour() {
    clr="$1"
    shift 1
    echo -e "$clr$(date +"$LOG_DATE") : $*$ALL_CLEAR" >&2
  }
  log_time()  { __log_to_error "$CLR_DEFAULT" "$*"; }
  log_debug() { __log_to_error "$CLR_MAGENTA" "$*"; }
  log_ok()    { __log_to_error "$CLR_GREEN" "$*"; }
  log_fail()  { __log_to_error "$CLR_RED" "$*"; }
  log_info()  { __log_to_error "$CLR_CYAN" "$*"; }
  log_error() { __log_to_error "$CLR_RED" "$*"; }
  log_warn()  { __log_to_error "$CLR_YELLOW" "$*"; }
  log_end()   { __log_to_error "$CLR_MAGENTA" "$*"; }
  log_yes()   { __log_to_error_all_colour "$CLR_GREEN" "✔"; }
  log_no()   { __log_to_error_all_colour "$CLR_RED" "✕"; }
fi
log_progress_start() { echo -en "[$(date +"$LOG_DATE")]: $* " >&2; }
log_progress() { echo -e "." >&2; }
log_progress_end() { echo -e "$ALL_CLEAR" >&2; }

################################################################################
# Log script execution time
################################################################################
log_end_time() { log_end "Script took $SECONDS seconds to run [$(seconds_to_time $SECONDS)]"; }

################################################################################
# Log a line of the size of the terminal
################################################################################
log_line() { printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' - >&2; }

################################################################################
# Create a header bar, with supplied text centered
################################################################################
log_header()
{
  [[ -z "$LOG_SHORT" ]] && log_line || :
  log_center "-" "$(date +"$LOG_DATE") : $@"
  [[ -z "$LOG_SHORT" ]] && log_line || :
}

################################################################################
# Create centered text, arguments has to be in order: [symbol] [colour] "text"
################################################################################
log_center()
{
  clr="$CLR_CYAN"
  sym=" "
  if [[ $# -eq 1 ]]; then
    text="$1"
  elif [[ $# -eq 2 ]]; then
    sym="$1"
    text="$2"
  elif [[ $# -eq 3 ]]; then
    sym="$1"
    clr="$2"
    text="$3"
  else
    log_error "Incorrect usage of log_center"
    exit 1
  fi

  chrlen=${#text}
  cl=${COLUMNS:-$(tput cols)}
  si=$((cl - chrlen - 2))
  dl=$((si/2))
  dr=$((dl + si%2))
  tl="$(printf '%*s' "$dl" '' | tr ' ' "$sym")"
  tr="$(printf '%*s' "$dr" '' | tr ' ' "$sym")"
  echo -e "$tl $clr$text$ALL_CLEAR $tr" >&2
}

################################################################################
# Convert seconds to time
################################################################################
seconds_to_time()
{
  date -ud "@$1" +'%H:%M:%S'
}

################################################################################
# Create a JSON log line, passed data will be in the .data
################################################################################
json_log()
{
  jq -cn \
    --arg date "$(date +"%F %T")" \
    --arg data "$@" \
    '{
      "date": $date,
      "data": $data
    }'
}

################################################################################
# Check if a list of files exist, exit on error
################################################################################
check_file_exists()
{
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      log_error "File does not exist: $f"
      exit 1
    fi
  done
}

################################################################################
# Check if a list of directories exist, exit on error
################################################################################
check_dir_exists()
{
  for f in "$@"; do
    if [[ ! -d "$f" ]]; then
      log_error "Directory does not exist: $f"
      exit 1
    fi
  done
}

################################################################################
# Check if a list of programs exist, exit on error
################################################################################
check_program_exists()
{
  for f in "$@"; do
    if ! hash $f 2>/dev/null; then
      log_error "Program $f does not exist"
      exit 1
    fi
  done
}

################################################################################
# Check if a variable is empty, exit on error
################################################################################
check_not_empty()
{
  if [[ -z "$1" ]]; then
    log_error "Data Missing"
    exit 1
  fi
}

################################################################################
# Check if a variable is null or None, exit on error
################################################################################
check_not_null()
{
  if [[ "$1" == "null" ]] || [[ "$1" == "None" ]]; then
    log_error "Data Missing"
    exit 1
  fi
}

################################################################################
# Return the age of the given file
################################################################################
file_age()
{
  FILE_CREATED_TIME=$(date -r "$1" +%s)
  TIME_NOW=$(date +%s)
  echo "$((TIME_NOW - FILE_CREATED_TIME))"
}

################################################################################
# Check if the given file is older than the given age
# returns 0 on older, 1 on newer
################################################################################
check_age()
{
  if [[ ! -f "$1" ]]; then
    return 0
  elif [[ $(file_age $1) -gt $2 ]]; then
    return 0
  else
    log_warn "Ignoring - file not old enough yet ($1)"
    return 1
  fi
}

################################################################################
# Return the amount of logical cores this machine has
################################################################################
core_count()
{
  case "$(uname)" in
    Darwin) sysctl -n hw.ncpu ;;
    *) cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l ;;
  esac
}

################################################################################
# Returns yesterdays date
################################################################################
yesterday()
{
  date -d'yesterday' +%Y-%m-%d
}

################################################################################
# Wait for the amount of background jobs is less than given amount
################################################################################
wait_for_jobs()
{
  while [[ $(jobs -p | wc -l) -ge ${1:-10} ]]; do
    sleep 1
  done
}

################################################################################
# On macOs say the given seconds as time
################################################################################
say_time()
{
  check_program_exists say
  s=$1

  m=$((s/60))
  s=$((s%60))
  ts=""
  tm=""

  if [[ $s -gt 0 ]]; then
    if [[ $s -eq 1 ]]; then
      ts="$s second"
    else
      ts="$s seconds"
    fi
  fi

  if [[ $m -gt 0 ]]; then
    if [[ $m -eq 1 ]]; then
      tm="$m minute"
    else
      tm="$m minutes"
    fi
  fi

  shift 1

  say -v Alex "$@ $tm $ts"
}

################################################################################
# On macOs send a notification
################################################################################
notify()
{
  check_program_exists osascript
  osascript -e "display notification \"$2\" with title \"$1\"";
}

if [[ -z "$DISABLE_END" ]]; then
  trap log_end_time EXIT
fi

################################################################################
# Append trap to current list of traps for EXIT
################################################################################
append_exit_trap()
{
  previous="$(trap -p EXIT | cut -d"'" -f2)"
  if [[ -z "$previous" ]]; then
    trap "$1" EXIT
  else
    trap "$1;$previous" EXIT
  fi
}

################################################################################
# Get the start date of a quarter.
# Sample:
# date_quarter_start -> uses current date
# date_quarter_start <YEARqQUARTER> -> e.g. 2018q2
# date_quarter_start <YEAR> <QUARTER> -> e.q. 2018 2
################################################################################
date_quarter_start()
{
  year=""
  quarter=""
  if [[ $# -eq 0 ]]; then
    year="$(date +%Y)"
    quarter="$(date +%q)"
  elif [[ $# -eq 1 ]]; then
    if echo "$1" | grep -iq "q"; then
      year="$(echo "$1" | cut -d'q' -f1)"
      quarter="$(echo "$1" | cut -d'q' -f2)"
    else
      year="$(date +%Y)"
      quarter="$1"
    fi
  elif [[ $# -eq 2 ]]; then
    year="$1"
    quarter="$2"
  else
    log_error "date_quarter_start: has wrong format: $@"
    exit 1
  fi

  check_not_empty "$year"
  check_not_empty "$quarter"

  case "$quarter" in
    1 ) echo "$year-01-01" ;;
    2 ) echo "$year-04-01" ;;
    3 ) echo "$year-07-01" ;;
    4 ) echo "$year-10-01" ;;
    * )
      log_error "date_quarter_start: Invalid argument: $quarter"
      exit 1
    ;;
  esac
}

################################################################################
# Get the end date of a quarter.
# Sample:
# date_quarter_end -> uses current date
# date_quarter_end <YEARqQUARTER> -> e.g. 2018q2
# date_quarter_end <YEAR> <QUARTER> -> e.q. 2018 2
################################################################################
date_quarter_end()
{
  year=""
  quarter=""
  if [[ $# -eq 0 ]]; then
    year="$(date +%Y)"
    quarter="$(date +%q)"
  elif [[ $# -eq 1 ]]; then
    if echo "$1" | grep -iq "q"; then
      year="$(echo "$1" | cut -d'q' -f1)"
      quarter="$(echo "$1" | cut -d'q' -f2)"
    else
      year="$(date +%Y)"
      quarter="$1"
    fi
  elif [[ $# -eq 2 ]]; then
    year="$1"
    quarter="$2"
  else
    log_error "date_quarter_end: has wrong format: $@"
    exit 1
  fi

  check_not_empty "$year"
  check_not_empty "$quarter"

  case "$quarter" in
    1 ) echo "$year-03-31" ;;
    2 ) echo "$year-06-30" ;;
    3 ) echo "$year-09-30" ;;
    4 ) echo "$year-12-31" ;;
    * )
      log_error "date_quarter_end: Invalid argument: $quarter"
      exit 1
    ;;
  esac
}

################################################################################
# Gets the quarter number for a date
# Sample:
# date_quarter -> uses current date
# date_quarter <date string> -> e.g. "2018-10-01"
################################################################################
date_quarter()
{
  if [[ $# -eq 0 ]]; then
    date +%q
  else
    date -d "$1" +%q
  fi
}

################################################################################
# Converts arguments to stdin. Else just redirects stdin
################################################################################
param_to_stdin()
{
  if [ -t 0 ]; then
    for f in "$@"; do
      echo "$f"
    done
  else
    cat -
  fi
}

################################################################################
# Strips anything that's not numeric out of stream
################################################################################
clean_numeric()
{
  sed 's/[^0-9]*//g'
}

################################################################################
# Strips anything that's not alphanumeric out of stream
################################################################################
clean_text()
{
  sed 's/[^0-9A-Z]*//g'
}

################################################################################
# Strips anything that's not considered characters for a date/time string
################################################################################
clean_date()
{
  sed 's/[^0-9 -:]*//g'
}

################################################################################
# Converts lowercase to uppercase
################################################################################
upper()
{
  tr '[:lower:]' '[:upper:]'
}

################################################################################
# Remove space characters, and then deletes empty lines
################################################################################
delete_empty()
{
  sed 's/[[:blank:]]//g' | sed '/^$/d'
}

run_help()
{
  if [[ "$2" == '-h' ]]; then
    sed -n '/^###/ s///p' "$1"
    exit
  fi
}

