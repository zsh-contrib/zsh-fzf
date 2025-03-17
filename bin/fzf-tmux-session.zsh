#!/usr/bin/env zsh
#
# Switch to a given tmux session.
tmux_switch_to() {
  tmux switch-client -t "$1"
}

fzf_tmux_session() {
  local SESSION_NAME

  # List sessions, extract their names, and use fzf to select one.
  SESSION_NAME=$(tmux ls | cut -d: -f1 | fzf --header=' Session' --bind='alt-x:execute(tmux kill-session -t {})+reload(tmux ls | cut -d: -f1),space:jump,jump:accept')

  # If a session is selected, switch to it.
  if [[ -n $SESSION_NAME ]]; then
    tmux_switch_to "$SESSION_NAME"
  fi
}

fzf_tmux_session
