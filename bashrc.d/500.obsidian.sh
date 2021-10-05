#!/usr/bin/env bash

today()
{
  open "obsidian://open?vault=VaultNotes&file=Daily/$(date +%Y-%m-%d.md)" >/dev/null 2>&1
}
