#!/usr/bin/env bash

if ! hash cpupower 2>/dev/null; then
  return
fi

cpu_governer()
{
  cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | sort -u
}

cpu_powersave()
{
  sudo cpupower frequency-set -g powersave
}

cpu_performance()
{
  sudo cpupower frequency-set -g performance
}

cpu_info()
{
  cpupower frequency-info
}
