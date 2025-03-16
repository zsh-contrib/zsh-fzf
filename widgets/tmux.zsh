#!/usr/bin/env zsh

# This script is adapted from ThePrimeagen's tmux-sessionizer:
# https://github.com/ThePrimeagen/tmux-sessionizer
#
# Provides functions for managing tmux sessions with fzf.

# Switch to a given tmux session.
tmux_switch_to() {
  tmux switch-client -t "$1"
}

# Check if a tmux session exists.
tmux_has_session() {
  tmux list-sessions 2>/dev/null | grep -q "^$1:"
}

# Create a new tmux session.
tmux_new_session() {
  tmux new-session -ds "$1" -c "$2"
}

# Derive a session name from a directory path.
tmux_session_name() {
  local PROJECT WORKSPACE

  PROJECT=$(basename "$1")
  WORKSPACE=$(basename "$(dirname "$1")")

  echo "${WORKSPACE}/${PROJECT}" | tr . _
}

fzf_tmux_explore() {
  local SESSION_DIR_PATH SESSION_NAME

  if [[ $# -eq 1 ]]; then
    SESSION_DIR_PATH=$1
  else
    SESSION_DIR_PATH=$(find ~/go/src/github.com -mindepth 2 -maxdepth 2 -type d | fzf --header='  Projects')
  fi

  # Exit silently if no directory was selected.
  if [[ -z "$SESSION_DIR_PATH" ]]; then
    return 0
  fi

  SESSION_NAME=$(tmux_session_name "$SESSION_DIR_PATH")

  if ! tmux_has_session "$SESSION_NAME"; then
    tmux_new_session "$SESSION_NAME" "$SESSION_DIR_PATH"
  fi

  tmux_switch_to "$SESSION_NAME"

  # Refresh the prompt (useful when called as a ZLE widget).
  zle reset-prompt
}

fzf_tmux_session() {
  local SESSION_NAME

  # List sessions, extract their names, and use fzf to select one.
  SESSION_NAME=$(tmux ls | cut -d: -f1 | fzf --header=' Session' --bind='alt-x:execute(tmux kill-session -t {})+reload(tmux ls | cut -d: -f1),space:jump,jump:accept')

  # If a session is selected, switch to it.
  if [[ -n $SESSION_NAME ]]; then
    tmux_switch_to "$SESSION_NAME"
  fi

  # Refresh the prompt (useful when called as a ZLE widget).
  zle reset-prompt
}
