#!/usr/bin/env zsh

# Main function that uses fzf to select a directory and manages the tmux session.
fzf_open() {
  if [ -f "$1" ]; then
  	nvim "$1" </dev/tty >/dev/tty 2>&1
  else
  	vifm "$1"
  fi
}
