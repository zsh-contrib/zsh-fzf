#!/usr/bin/env zsh

export FZF_THEME_DIR="${0:A:h}/themes"
export FZF_DEFAULT_OPTS="--style=minimal --highlight-line --prompt='󰥭 ' --gutter='' --header-border=sharp --input-border=sharp"
# open file or directory as you wish
export FZF_CTRL_T_OPTS="--bind 'alt-enter:become(vifm {}),ctrl-o:become(open {})' --header='  Finder'"
export FZF_ALT_C_OPTS="--bind 'alt-enter:become(vifm {}),ctrl-o:become(open {})' --header='  Directories'"

FZF_THEME="${FZF_THEME:-catppuccin-mocha}"
# Load theme file
if [[ -f "$FZF_THEME_DIR/$FZF_THEME.zsh" ]]; then
  source "$FZF_THEME_DIR/$FZF_THEME.zsh"
fi
