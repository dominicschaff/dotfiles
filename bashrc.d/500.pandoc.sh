#!/usr/bin/env bash

if ! hash pandoc 2>/dev/null; then
  return
fi

pc()
{
  pandoc -s --standalone --toc -f markdown --highlight-style zenburn --template ~/.dotfiles/pandoc/template.html -t html "$1" | sed 's/<table/<table class=\"table\"/' > "${1%.*}.html"
}

pc_print()
{
  pandoc -s --standalone --toc -f markdown --highlight-style haddock --template ~/.dotfiles/pandoc/template.html -t html "$1" | sed 's/<table/<table class=\"table\"/' > "${1%.*}.html"
}

html_to_md()
{
  curl "$1" | pandoc --from html --to markdown_strict
}
