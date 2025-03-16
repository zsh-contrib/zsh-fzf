#!/usr/bin/env zsh

# plugin configuration
source "${0:A:h}/config.zsh"

# plugin widgets
source "${0:A:h}/widgets/open.zsh"
source "${0:A:h}/widgets/tmux.zsh"
source "${0:A:h}/widgets/zoxide.zsh"

if [[ -o interactive ]]; then
  # Create the zle widgets
  zle -N tmux_fzf_switch
  zle -N tmux_fzf_session

  # Bind the zle widgets
  bindkey '^[s' tmux_fzf_switch
  bindkey '^[p' tmux_fzf_session
fi
