#!/usr/bin/env bats

# Tests for zsh-fzf plugin
#
# Requires bats-core: https://github.com/bats-core/bats-core
# Run: bats tests/plugin.bats

export PLUGIN_DIR
PLUGIN_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"

setup() {
  if ! command -v fzf &>/dev/null; then
    skip "fzf is not installed"
  fi

  # Keep tests independent of the host: no tmux, no appearance detection.
  # Detection tests opt back in explicitly.
  unset TMUX FZF_THEME _ZSH_FZF_APPLIED_THEME
  export ZSH_FZF_AUTO_THEME=false
}

# ---------------------------------------------------------------------------
# Plugin loading
# ---------------------------------------------------------------------------

@test "plugin loads without error" {
  run zsh -c 'source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"'
  [[ "$status" -eq 0 ]]
}

# ---------------------------------------------------------------------------
# FZF_DEFAULT_OPTS
# ---------------------------------------------------------------------------

@test "FZF_DEFAULT_OPTS is set after loading" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    [[ -n "$FZF_DEFAULT_OPTS" ]] && echo "set" || echo "unset"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == "set" ]]
}

@test "FZF_DEFAULT_OPTS contains --ansi" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_DEFAULT_OPTS"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"--ansi"* ]]
}

@test "FZF_DEFAULT_OPTS contains --layout" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_DEFAULT_OPTS"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"--layout"* ]]
}

@test "FZF_DEFAULT_OPTS contains --height" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_DEFAULT_OPTS"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"--height"* ]]
}

# ---------------------------------------------------------------------------
# FZF_CTRL_T_OPTS
# ---------------------------------------------------------------------------

@test "FZF_CTRL_T_OPTS is set after loading" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    [[ -n "$FZF_CTRL_T_OPTS" ]] && echo "set" || echo "unset"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == "set" ]]
}

@test "FZF_CTRL_T_OPTS contains ctrl-o binding" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_CTRL_T_OPTS"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"ctrl-o"* ]]
}

@test "FZF_CTRL_T_OPTS contains alt-enter binding" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_CTRL_T_OPTS"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"alt-enter"* ]]
}

# ---------------------------------------------------------------------------
# FZF_ALT_C_OPTS
# ---------------------------------------------------------------------------

@test "FZF_ALT_C_OPTS is set after loading" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    [[ -n "$FZF_ALT_C_OPTS" ]] && echo "set" || echo "unset"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == "set" ]]
}

@test "FZF_ALT_C_OPTS contains ctrl-o binding" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_ALT_C_OPTS"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"ctrl-o"* ]]
}

@test "FZF_ALT_C_OPTS contains alt-enter binding" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_ALT_C_OPTS"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"alt-enter"* ]]
}

# ---------------------------------------------------------------------------
# Theme
# ---------------------------------------------------------------------------

@test "FZF_THEME defaults to catppuccin-mocha" {
  run zsh -c '
    unset FZF_THEME
    unset TMUX
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_THEME"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == "catppuccin-mocha" ]]
}

@test "pre-set FZF_THEME is preserved when not in tmux" {
  run zsh -c '
    export FZF_THEME="rose-pine"
    unset TMUX
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_THEME"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == "rose-pine" ]]
}

@test "FZF_THEME_DIR points to themes directory" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_THEME_DIR"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"/themes"* ]]
  [[ -d "$output" ]]
}

@test "all bundled theme files exist" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    themes=(catppuccin-latte catppuccin-frappe catppuccin-macchiato catppuccin-mocha
            rose-pine rose-pine-dawn rose-pine-moon)
    for t in "${themes[@]}"; do
      [[ -f "$FZF_THEME_DIR/$t.zsh" ]] || { echo "missing: $t"; exit 1; }
    done
    echo "all present"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == "all present" ]]
}

@test "theme file is sourced and contributes to FZF_DEFAULT_OPTS" {
  run zsh -c '
    export FZF_THEME="catppuccin-mocha"
    unset TMUX
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    # Theme files append --color options
    echo "$FZF_DEFAULT_OPTS"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"--color"* ]]
}

@test "FZF_THEME absolute path is sourced as a custom theme" {
  local dir
  dir="$(mktemp -d)"
  printf 'export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg:#123456"\n' > "$dir/my-theme.zsh"
  run zsh -c '
    export FZF_THEME="$1"
    unset TMUX
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_DEFAULT_OPTS"
  ' _ "$dir/my-theme.zsh"
  rm -rf "$dir"
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"--color=bg:#123456"* ]]
}

@test "FZF_THEME absolute path to a missing file warns" {
  run zsh -c '
    export FZF_THEME="/nonexistent/theme.zsh"
    unset TMUX
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
  '
  [[ "$output" == *"custom theme file not found"* ]]
}

@test "FZF_THEME_DARK absolute path is used under tmux dark mode" {
  local dir bin
  dir="$(mktemp -d)"
  bin="$(mktemp -d)"
  printf 'export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg:#abcdef"\n' > "$dir/dark.zsh"
  printf '#!/bin/sh\necho dark\n' > "$bin/tmux"
  chmod +x "$bin/tmux"
  run env TMUX=fake ZSH_FZF_AUTO_THEME=true PATH="$bin:$PATH" FZF_THEME_DARK="$dir/dark.zsh" zsh -c '
    unset FZF_THEME
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_DEFAULT_OPTS"
  '
  rm -rf "$dir" "$bin"
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"--color=bg:#abcdef"* ]]
}

# -- Theme mode and auto detection ------------------------------------------

# Create a fake executable in a temp bin dir; echoes the dir. Usage: _fake name body
_fake() {
  local bin="${FAKE_BIN:-$(mktemp -d)}"
  printf '#!/bin/sh\n%s\n' "$2" > "$bin/$1"
  chmod +x "$bin/$1"
  echo "$bin"
}

@test "unknown bundled theme name warns" {
  run zsh -c '
    export FZF_THEME="catppucin-mocha"
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
  '
  [[ "$output" == *"unknown theme 'catppucin-mocha'"* ]]
}

@test "ZSH_FZF_THEME_MODE=light selects FZF_THEME_LIGHT" {
  run env ZSH_FZF_THEME_MODE=light zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  [[ "$output" == "catppuccin-latte" ]]
}

@test "ZSH_FZF_THEME_MODE=dark selects FZF_THEME_DARK" {
  run env ZSH_FZF_THEME_MODE=dark FZF_THEME_DARK=rose-pine zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  [[ "$output" == "rose-pine" ]]
}

@test "ZSH_FZF_THEME_MODE accepts a theme name" {
  run env ZSH_FZF_THEME_MODE=rose-pine-moon zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  [[ "$output" == "rose-pine-moon" ]]
}

@test "auto detection: tmux light client selects FZF_THEME_LIGHT" {
  local bin; bin="$(_fake tmux 'echo light')"
  run env TMUX=fake ZSH_FZF_AUTO_THEME=true PATH="$bin:$PATH" zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  rm -rf "$bin"
  [[ "$output" == "catppuccin-latte" ]]
}

@test "auto detection: ZSH_FZF_AUTO_THEME=false ignores tmux client theme" {
  local bin; bin="$(_fake tmux 'echo light')"
  run env TMUX=fake ZSH_FZF_AUTO_THEME=false PATH="$bin:$PATH" zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  rm -rf "$bin"
  [[ "$output" == "catppuccin-mocha" ]]
}

@test "auto detection: empty tmux client_theme falls through instead of forcing dark" {
  local bin; bin="$(_fake tmux 'echo')"
  run env TMUX=fake ZSH_FZF_AUTO_THEME=true FZF_THEME=rose-pine PATH="$bin:$PATH" zsh -c '
    OSTYPE=linux-gnu
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  rm -rf "$bin"
  [[ "$output" == "rose-pine" ]]
}

@test "auto detection: macOS dark appearance selects FZF_THEME_DARK" {
  local bin; bin="$(_fake defaults 'echo Dark')"
  run env ZSH_FZF_AUTO_THEME=true PATH="$bin:$PATH" zsh -c '
    OSTYPE=darwin24.0
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  rm -rf "$bin"
  [[ "$output" == "catppuccin-mocha" ]]
}

@test "auto detection: macOS light appearance selects FZF_THEME_LIGHT" {
  local bin; bin="$(_fake defaults 'exit 1')"
  run env ZSH_FZF_AUTO_THEME=true PATH="$bin:$PATH" zsh -c '
    OSTYPE=darwin24.0
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  rm -rf "$bin"
  [[ "$output" == "catppuccin-latte" ]]
}

@test "auto detection: pinned FZF_THEME wins over macOS appearance" {
  local bin; bin="$(_fake defaults 'echo Dark')"
  run env ZSH_FZF_AUTO_THEME=true FZF_THEME=rose-pine-dawn PATH="$bin:$PATH" zsh -c '
    OSTYPE=darwin24.0
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  rm -rf "$bin"
  [[ "$output" == "rose-pine-dawn" ]]
}

@test "auto detection: pinned FZF_THEME is still overridden by tmux" {
  local bin; bin="$(_fake tmux 'echo light')"
  run env TMUX=fake ZSH_FZF_AUTO_THEME=true FZF_THEME=rose-pine PATH="$bin:$PATH" zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  rm -rf "$bin"
  [[ "$output" == "catppuccin-latte" ]]
}

@test "auto detection: theme inherited from a parent shell is not pinned" {
  local bin; bin="$(_fake defaults 'exit 1')"
  run env ZSH_FZF_AUTO_THEME=true FZF_THEME=catppuccin-mocha \
    _ZSH_FZF_APPLIED_THEME=catppuccin-mocha PATH="$bin:$PATH" zsh -c '
    OSTYPE=darwin24.0
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  rm -rf "$bin"
  [[ "$output" == "catppuccin-latte" ]]
}

@test "auto detection: a pin survives into a nested shell" {
  local bin; bin="$(_fake defaults 'exit 1')"
  run env ZSH_FZF_AUTO_THEME=true FZF_THEME=rose-pine PATH="$bin:$PATH" zsh -c '
    OSTYPE=darwin24.0
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    zsh -c "OSTYPE=darwin24.0; source \"\$PLUGIN_DIR/zsh-fzf.plugin.zsh\"; echo \$FZF_THEME"'
  rm -rf "$bin"
  [[ "$output" == "rose-pine" ]]
}

@test "auto detection: auto-applied theme follows appearance in a nested shell" {
  local bin; bin="$(_fake defaults 'echo Dark')"
  run env ZSH_FZF_AUTO_THEME=true PATH="$bin:$PATH" zsh -c '
    OSTYPE=darwin24.0
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    printf "#!/bin/sh\nexit 1\n" > "'"$bin"'/defaults"
    zsh -c "OSTYPE=darwin24.0; source \"\$PLUGIN_DIR/zsh-fzf.plugin.zsh\"; echo \$FZF_THEME"'
  rm -rf "$bin"
  [[ "$output" == "catppuccin-latte" ]]
}

@test "auto detection: no signal falls back to FZF_THEME" {
  run env ZSH_FZF_AUTO_THEME=true FZF_THEME=rose-pine zsh -c '
    OSTYPE=linux-gnu
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; echo "$FZF_THEME"'
  [[ "$output" == "rose-pine" ]]
}

# -- fzf-theme / fzf-themes-list ----------------------------------------------

@test "fzf-theme switches theme without stacking colors" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    fzf-theme rose-pine-dawn
    echo "$FZF_THEME"
    echo "$FZF_DEFAULT_OPTS"'
  [[ "$status" -eq 0 ]]
  [[ "${lines[0]}" == "rose-pine-dawn" ]]
  # rose-pine-dawn background, and no leftover mocha background
  [[ "${lines[1]}" == *"bg:#faf4ed"* ]]
  [[ "${lines[1]}" != *"bg:#1e1e2e"* ]]
}

@test "fzf-theme twice does not duplicate --color options" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    fzf-theme rose-pine
    fzf-theme rose-pine
    print -r -- "$FZF_DEFAULT_OPTS" | grep -o -- "--color=bg+" | wc -l'
  [[ "$(echo "$output" | tr -d " ")" == "1" ]]
}

@test "fzf-theme accepts a custom theme file" {
  local dir; dir="$(mktemp -d)"
  printf 'export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg:#123456"\n' > "$dir/t.zsh"
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    fzf-theme "$1"
    echo "$FZF_DEFAULT_OPTS"' _ "$dir/t.zsh"
  rm -rf "$dir"
  [[ "$output" == *"--color=bg:#123456"* ]]
}

@test "fzf-theme with unknown theme fails and keeps current theme" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    fzf-theme nope 2>&1
    rc=$?
    echo "rc=$rc theme=$FZF_THEME"'
  [[ "$output" == *"theme file not found for 'nope'"* ]]
  [[ "$output" == *"rc=1 theme=catppuccin-mocha"* ]]
}

@test "fzf-theme with no argument prints the active theme" {
  run zsh -c 'source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; fzf-theme'
  [[ "$output" == "catppuccin-mocha" ]]
}

@test "fzf-themes-list lists bundled themes and marks the active one" {
  run zsh -c 'source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"; fzf-themes-list'
  [[ "$status" -eq 0 ]]
  [[ "${#lines[@]}" -eq 7 ]]
  [[ "$output" == *"* catppuccin-mocha"* ]]
  [[ "$output" == *"  rose-pine-dawn"* ]]
}

# ---------------------------------------------------------------------------
# FZF_OPENER auto-detection
# ---------------------------------------------------------------------------

@test "FZF_OPENER is set after loading" {
  run zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    [[ -n "$FZF_OPENER" ]] && echo "set" || echo "unset"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == "set" ]]
}

@test "pre-set FZF_OPENER is preserved" {
  run zsh -c '
    export FZF_OPENER="my-opener"
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"
    echo "$FZF_OPENER"
  '
  [[ "$status" -eq 0 ]]
  [[ "$output" == "my-opener" ]]
}

@test "inside tmux the theme is shared with the tmux server environment" {
  local log; log="$(mktemp)"
  local bin; bin="$(_fake tmux 'if [ "$1" = display ]; then echo dark; else echo "$@" >> "$TMUX_LOG"; fi')"
  run env TMUX=fake TMUX_LOG="$log" ZSH_FZF_AUTO_THEME=true PATH="$bin:$PATH" zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"'
  local out; out="$(cat "$log")"
  rm -rf "$bin" "$log"
  [[ "$out" == *"set-environment -g FZF_THEME catppuccin-mocha"* ]]
  [[ "$out" == *"set-environment -g FZF_DEFAULT_OPTS"* ]]
}

@test "outside tmux nothing is shared with tmux" {
  local log; log="$(mktemp)"
  local bin; bin="$(_fake tmux 'echo "$@" >> "$TMUX_LOG"')"
  run env TMUX_LOG="$log" PATH="$bin:$PATH" zsh -c '
    source "$PLUGIN_DIR/zsh-fzf.plugin.zsh"'
  local out; out="$(cat "$log")"
  rm -rf "$bin" "$log"
  [[ -z "$out" ]]
}
