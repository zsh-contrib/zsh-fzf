#!/usr/bin/env zsh

# Determine system default opener
if [[ -z "$FZF_OPENER" ]]; then
  if [[ "$OSTYPE" == darwin* ]]; then
    FZF_OPENER="open"
  else
    FZF_OPENER="xdg-open"
  fi
fi


# FZF current working directory
export FZF_CWD="${FZF_CWD:-$PWD}"

# Default fzf options
FZF_DEFAULT_OPTS_ITEMS=(
  --ansi
  --height="100%"
  --layout="reverse-list"
  --gutter=""
  --prompt="'󰥭 '"
  --style="minimal"
  --highlight-line
  --color="footer:red"
  --footer-border="sharp"
  --input-border="sharp"
)

# Default browser for fzf (file managers)
if [[ -z "$FZF_BROWSER" ]]; then
  if command -v vifm &>/dev/null; then
    FZF_BROWSER="vifm"
  elif command -v yazi &>/dev/null; then
    FZF_BROWSER="yazi"
  else
    FZF_BROWSER="vim"
  fi
fi

# Directory picker options
FZF_ALT_C_OPTS_ITEMS=(
  --footer="'󰥨 Directories · $FZF_CWD'"
  --bind="'ctrl-o:become($FZF_OPENER {})'"
  --bind="'alt-enter:become($FZF_BROWSER {})'"
)

# Set FZF_ALT_C_OPTS by joining the items with spaces
export FZF_ALT_C_OPTS="${(j: :)FZF_ALT_C_OPTS_ITEMS}"

if command -v fd &>/dev/null; then
  # Set FZF_CTRL_T_COMMAND to use fd for directory searching
  export FZF_ALT_C_COMMAND="fd -t d"
fi

# Set FZF_DEFAULT_OPTS by joining the items with spaces
export FZF_DEFAULT_OPTS="${(j: :)FZF_DEFAULT_OPTS_ITEMS}"

# Default editor for fzf
if [[ -z "$FZF_EDITOR" ]]; then
  if command -v nvim &>/dev/null; then
    FZF_EDITOR="nvim"
  else
    FZF_EDITOR="vim"
  fi
fi


# File picker options
FZF_CTRL_T_OPTS_ITEMS=(
  --footer="'󰱼 Files · $FZF_CWD'"
  --bind="'ctrl-o:become($FZF_OPENER {})'"
  --bind="'alt-enter:become($FZF_EDITOR {})'"
)

# Set FZF_CTRL_T_OPTS by joining the items with spaces
export FZF_CTRL_T_OPTS="${(j: :)FZF_CTRL_T_OPTS_ITEMS}"

if command -v fd &>/dev/null; then
  # Set FZF_CTRL_T_COMMAND to use fd for file searching
  export FZF_CTRL_T_COMMAND="fd -t f"
fi

# Theme configuration
export FZF_THEME="${FZF_THEME:-catppuccin-mocha}"
export FZF_THEME_DARK="${FZF_THEME_DARK:-catppuccin-mocha}"
export FZF_THEME_LIGHT="${FZF_THEME_LIGHT:-catppuccin-latte}"

if [[ -n "$TMUX" ]]; then
  TMUX_CLIENT_THEME="$(tmux display -p "#{client_theme}")"

  if [[ "$TMUX_CLIENT_THEME" == "light" ]]; then
    export FZF_THEME="$FZF_THEME_LIGHT"
  else
    export FZF_THEME="$FZF_THEME_DARK"
  fi
fi

export FZF_THEME_DIR="${0:A:h}/themes"
# Load theme file
if [[ -f "$FZF_THEME_DIR/$FZF_THEME.zsh" ]]; then
  source "$FZF_THEME_DIR/$FZF_THEME.zsh"
fi
