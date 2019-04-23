#!/usr/bin/env bash

ACCURACY=10
INITIAL=10
STR_INTERMEDIATE="Lines ~ %'${ACCURACY}d"
STR_FINAL="Lines = %'${ACCURACY}d"

gcc -x c - -o ~/bin/lines <<EOF
#include <stdio.h>
#include <stdlib.h>
#include <locale.h>

int main(int argc, char**argv)
{
  int ch;
  int lines = 0;
  int each = ${INITIAL};
  setlocale(LC_NUMERIC, "");
  if (argc == 2) {
    each = atoi(argv[1]);
  }
  if (each < 0) {
    each = each * -1;
  }
  if (each > 0) {
    fprintf(stderr, "\r${STR_INTERMEDIATE}", 0);
    while((ch = getchar()) > 0) {
      putchar(ch);
      if (each && lines % each == 0) fprintf(stderr, "\r${STR_INTERMEDIATE}", lines);
      if (ch == '\n') lines++;
    }
  } else {
    fprintf(stderr, "\rCounting...");
    while((ch = getchar()) > 0) {
      putchar(ch);
      if (ch == '\n') lines++;
    }
  }

  fprintf(stderr, "\r${STR_FINAL}\n", lines);
}
EOF