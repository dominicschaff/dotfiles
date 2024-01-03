#!/usr/bin/env bash

fetch_markdown()
{
  curl --data "read=1" --data "u=$1" "http://fuckyeahmarkdown.com/go/"
}

colours_all_styles()
{
  for x in 0 1 4 5 7 8; do
    for i in `seq 30 37`; do
      for a in `seq 40 47`; do
        echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
      done
      echo
    done
  done
  echo ""
}

colours_all_numbered()
{
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done
}

get_tweets()
{
  curl -s "https://twitrss.me/twitter_user_to_rss/?user=$1" | xq '.rss.channel.item[]' | jq -c .
}

get_random_tweet()
{
  get_tweets $1 | sort -R | head -n1 | jq -r '.title'
}