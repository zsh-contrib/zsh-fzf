#!/usr/bin/env zsh

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


# Directory picker options
FZF_ALT_C_OPTS_ITEMS=(
  --footer="'󰥨 Directories · ${FZF_CWD:-$PWD}'"
  --bind="'alt-enter:become(vifm {}),ctrl-o:become(open {})'"
)
# Set FZF_ALT_C_OPTS by joining the items with spaces
export FZF_ALT_C_OPTS="${(j: :)FZF_ALT_C_OPTS_ITEMS}"

if command -v fd &>/dev/null; then
  # Set FZF_CTRL_T_COMMAND to use fd for directory searching
  export FZF_ALT_C_COMMAND="fd -t d"
fi

# Set FZF_DEFAULT_OPTS by joining the items with spaces
export FZF_DEFAULT_OPTS="${(j: :)FZF_DEFAULT_OPTS_ITEMS}"

# File picker options
FZF_CTRL_T_OPTS_ITEMS=(
  --footer="'󰱼 Files · ${FZF_CWD:-$PWD}'"
  --bind="'alt-enter:become(vifm {}),ctrl-o:become(open {})'"
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
