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
  --bind="'ctrl-o:execute-silent($FZF_OPENER {})'"
  --bind="'alt-enter:execute($FZF_BROWSER {})'"
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
  --bind="'ctrl-o:execute-silent($FZF_OPENER {})'"
  --bind="'alt-enter:execute($FZF_EDITOR {})'"
)

# Set FZF_CTRL_T_OPTS by joining the items with spaces
export FZF_CTRL_T_OPTS="${(j: :)FZF_CTRL_T_OPTS_ITEMS}"

if command -v fd &>/dev/null; then
  # Set FZF_CTRL_T_COMMAND to use fd for file searching
  export FZF_CTRL_T_COMMAND="fd -t f"
fi

# Theme configuration
: ${ZSH_FZF_AUTO_THEME:=true}
: ${ZSH_FZF_THEME_MODE:=auto}  # auto, light, dark, or theme name

# An FZF_THEME you set yourself is "pinned": it wins over macOS appearance
# detection (tmux detection still applies). A value merely inherited from a
# parent shell's plugin load is not pinned, so nested shells keep following
# the system appearance.
typeset -g _zsh_fzf_pinned=0
if [[ -n "$FZF_THEME" && "$FZF_THEME" != "$_ZSH_FZF_APPLIED_THEME" ]]; then
  _zsh_fzf_pinned=1
fi

export FZF_THEME="${FZF_THEME:-catppuccin-mocha}"
export FZF_THEME_DARK="${FZF_THEME_DARK:-catppuccin-mocha}"
export FZF_THEME_LIGHT="${FZF_THEME_LIGHT:-catppuccin-latte}"
export FZF_THEME_DIR="${0:A:h}/themes"

# Theme files append --color options to FZF_DEFAULT_OPTS, so keep the base
# options around to rebuild from when switching themes.
typeset -g _zsh_fzf_base_opts="$FZF_DEFAULT_OPTS"

# Print the theme file for a theme name or absolute path
_zsh_fzf_theme_file() {
  local theme="$1"

  if [[ "$theme" == /* ]]; then
    print -r -- "$theme"
  else
    print -r -- "$FZF_THEME_DIR/${theme}.zsh"
  fi
}

# Print "light" or "dark" from the tmux client or macOS appearance.
# Prints nothing when no signal is available.
#
# Arguments:
#   $1 - (optional) "no-macos" to skip the macOS appearance check
_zsh_fzf_detect_mode() {
  if [[ -n "$TMUX" ]] && (( $+commands[tmux] )); then
    local client_theme
    client_theme="$(tmux display -p "#{client_theme}" 2>/dev/null)"
    if [[ "$client_theme" == (light|dark) ]]; then
      print -r -- "$client_theme"
      return
    fi
  fi

  if [[ "$1" != "no-macos" && "$OSTYPE" == darwin* ]] && (( $+commands[defaults] )); then
    # AppleInterfaceStyle exists only in dark mode
    if defaults read -g AppleInterfaceStyle &>/dev/null; then
      print dark
    else
      print light
    fi
  fi
}

# Print the theme to use, honouring ZSH_FZF_THEME_MODE and ZSH_FZF_AUTO_THEME
_zsh_fzf_resolve_theme() {
  case "$ZSH_FZF_THEME_MODE" in
    light) print -r -- "$FZF_THEME_LIGHT" ;;
    dark)  print -r -- "$FZF_THEME_DARK" ;;
    auto)
      local mode=""
      if [[ "$ZSH_FZF_AUTO_THEME" == "true" ]]; then
        # A pinned FZF_THEME wins over macOS appearance, but not over tmux
        if (( _zsh_fzf_pinned )); then
          mode="$(_zsh_fzf_detect_mode no-macos)"
        else
          mode="$(_zsh_fzf_detect_mode)"
        fi
      fi
      case "$mode" in
        light) print -r -- "$FZF_THEME_LIGHT" ;;
        dark)  print -r -- "$FZF_THEME_DARK" ;;
        *)     print -r -- "$FZF_THEME" ;;
      esac
      ;;
    *) print -r -- "$ZSH_FZF_THEME_MODE" ;;  # explicit theme name
  esac
}

# Share the active theme with the tmux server. Popups started by tmux
# (run-shell, display-popup) get the environment of the server, not of the
# shell, so without this they keep the theme that the first shell had before
# tmux existed, when only the macOS appearance was known.
_zsh_fzf_sync_tmux() {
  [[ -n "$TMUX" ]] && (( $+commands[tmux] )) || return 0
  tmux set-environment -g FZF_THEME "$FZF_THEME" &>/dev/null
  tmux set-environment -g FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS" &>/dev/null
  return 0
}

# Activate a theme (name or absolute path) for the current shell: reset
# FZF_DEFAULT_OPTS to the base options, then source the theme file, then
# share the result with tmux. Warns if the theme file doesn't exist.
_zsh_fzf_apply_theme() {
  local theme="$1"
  local file
  file="$(_zsh_fzf_theme_file "$theme")"

  export FZF_THEME="$theme"
  export FZF_DEFAULT_OPTS="$_zsh_fzf_base_opts"

  if [[ -f "$file" ]]; then
    source "$file"
  elif [[ "$theme" == /* ]]; then
    print "zsh-fzf: custom theme file not found: $file" >&2
  else
    print "zsh-fzf: unknown theme '$theme' (run fzf-themes-list)" >&2
  fi

  _zsh_fzf_sync_tmux
}

# List bundled themes, marking the active one
fzf-themes-list() {
  local file name
  for file in "$FZF_THEME_DIR"/*.zsh(.N); do
    name="${file:t:r}"
    if [[ "$name" == "$FZF_THEME" ]]; then
      print "* $name"
    else
      print "  $name"
    fi
  done
}

# Switch theme in the current shell. With no argument, print the active theme.
fzf-theme() {
  if (( $# == 0 )); then
    print -r -- "$FZF_THEME"
    return 0
  fi

  local theme="$1"
  local file
  file="$(_zsh_fzf_theme_file "$theme")"

  if [[ ! -f "$file" ]]; then
    print "fzf-theme: theme file not found for '$theme' (looked for $file)" >&2
    print "Run fzf-themes-list to see available themes." >&2
    return 1
  fi

  _zsh_fzf_apply_theme "$theme"
}

# FZF_THEME is either a bundled theme name or an absolute path to a custom
# theme file (a zsh script that appends --color options to FZF_DEFAULT_OPTS).
_zsh_fzf_apply_theme "$(_zsh_fzf_resolve_theme)"

# Remember what was auto-applied so child shells can tell it from a pin
if (( ! _zsh_fzf_pinned )); then
  export _ZSH_FZF_APPLIED_THEME="$FZF_THEME"
fi
