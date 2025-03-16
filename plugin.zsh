#!/usr/bin/env zsh

# plugin configuration
source "${0:A:h}/config.zsh"

# plugin widgets
source "${0:A:h}/widgets/open.zsh"
source "${0:A:h}/widgets/tmux.zsh"
source "${0:A:h}/widgets/zoxide.zsh"

# Create a ZLE widget from the tmux_fzf_switch function defined in tmux_fzf.sh.
zle -N tmux_fzf_switch

# Bind the widget to Ctrl+p.
bindkey '^[p' tmux_fzf_switch
