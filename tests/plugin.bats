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
