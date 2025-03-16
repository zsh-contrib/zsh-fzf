#!/usr/bin/env zsh

# plugin.zsh
source "${0:A:h}/widgets/tmux.zsh"

# Create a ZLE widget from the tmux_fzf_switch function defined in tmux_fzf.sh.
zle -N tmux_fzf_switch

# Bind the widget to Ctrl+p.
bindkey '^[p' tmux_fzf_switch
