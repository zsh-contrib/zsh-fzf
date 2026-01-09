#!/usr/bin/env zsh

# Default fzf options
FZF_DEFAULT_OPTS_ITEMS=(
  --gutter="''"
  --prompt="'󰥭 '"
  --style=minimal
  --highlight-line
  --header-border=sharp
  --input-border=sharp
)
# Set FZF_DEFAULT_OPTS by joining the items with spaces
export FZF_DEFAULT_OPTS="${(j: :)FZF_DEFAULT_OPTS_ITEMS}"

# File picker options
FZF_CTRL_T_OPTS_ITEMS=(
  --header="'󰱼 Files'"
  --bind="'alt-enter:become(vifm {}),ctrl-o:become(open {})'"
)
# Set FZF_CTRL_T_OPTS by joining the items with spaces
export FZF_CTRL_T_OPTS="${(j: :)FZF_CTRL_T_OPTS_ITEMS}"

# Directory picker options
FZF_ALT_C_OPTS_ITEMS=(
  --header="'󰥨 Directories'"
  --bind="'alt-enter:become(vifm {}),ctrl-o:become(open {})'"
)
# Set FZF_ALT_C_OPTS by joining the items with spaces
export FZF_ALT_C_OPTS="${(j: :)FZF_ALT_C_OPTS_ITEMS}"

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
