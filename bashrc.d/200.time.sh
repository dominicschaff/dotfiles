#!/usr/bin/env bash

convertTime()
{
  date -d @$(echo $1) +"%Y-%m-%d %T"
}

convertMilli()
{
  convertTime $(echo $1 | rev | cut -c 4- | rev)
}

last_monday()
{
  date -d'last week last monday' +%Y-%m-%d
}

last_sunday()
{
  date -d'last sunday' +%Y-%m-%d
}