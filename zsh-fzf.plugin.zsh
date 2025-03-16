#!/usr/bin/env zsh

# plugin configuration
source "${0:A:h}/config.zsh"

# plugin widgets
source "${0:A:h}/widgets/tmux.zsh"
source "${0:A:h}/widgets/zoxide.zsh"

# Create the zle widgets
zle -N fzf_open
zle -N fzf_tmux_explore
zle -N fzf_tmux_session

# Bind keys to the zle widgets
bindkey '^[p' fzf_tmux_explore
bindkey '^[s' fzf_tmux_session
