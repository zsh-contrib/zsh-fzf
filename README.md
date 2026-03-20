# zsh-fzf

fzf for Zsh — Catppuccin and Rose Pine theming with enhanced key bindings.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

`zsh-fzf` configures [fzf](https://github.com/junegunn/fzf) with beautiful Catppuccin and Rose Pine color themes, adds file and directory picker key bindings, and wires up your preferred editor and file manager — so fuzzy finding feels native from day one.

## Requirements

- [fzf](https://github.com/junegunn/fzf) (`fzf`)
- [vifm](https://vifm.info/) or [yazi](https://yazi-rs.github.io/) (`vifm` / `yazi`) — optional, for `Alt+Enter` directory binding

**macOS (Homebrew):**

```bash
brew install fzf
```

**Nix:**

```bash
nix profile install nixpkgs#fzf
```

## Installation

### Using zinit

```zsh
zinit load zsh-contrib/zsh-fzf
```

### Using sheldon

```toml
[plugins.zsh-fzf]
github = "zsh-contrib/zsh-fzf"
```

### Manual

```zsh
git clone https://github.com/zsh-contrib/zsh-fzf.git ~/.zsh/plugins/zsh-fzf
source ~/.zsh/plugins/zsh-fzf/zsh-fzf.plugin.zsh
```

## Key Bindings

### File Picker (`Ctrl+T`)

| Key | Action |
|-----|--------|
| `Alt+Enter` | Open in text editor (nvim/vim) |
| `Ctrl+O` | Open with system default application |

### Directory Picker (`Alt+C`)

| Key | Action |
|-----|--------|
| `Alt+Enter` | Open in file browser (vifm/yazi/vim) |
| `Ctrl+O` | Open with system default application |

## Themes

| Theme | Description |
|-------|-------------|
| `catppuccin-latte` | Light theme with warm tones |
| `catppuccin-frappe` | Dark theme with soft contrast |
| `catppuccin-macchiato` | Dark theme with medium contrast |
| `catppuccin-mocha` | Dark theme with deep contrast (default) |
| `rose-pine` | Dark theme with warm, muted colors |
| `rose-pine-dawn` | Light theme with warm, natural colors |
| `rose-pine-moon` | Dark theme with cool, muted colors |

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `FZF_THEME` | `catppuccin-mocha` | Color theme |
| `FZF_OPENER` | `open` / `xdg-open` | System default file opener (auto-detected) |
| `FZF_BROWSER` | `vifm` / `yazi` / `vim` | File browser/manager (auto-detected) |
| `FZF_EDITOR` | `nvim` / `vim` | Text editor (auto-detected) |
| `FZF_DEFAULT_OPTS` | (complex) | Base fzf styling options |
| `FZF_CTRL_T_OPTS` | (complex) | File finder options |
| `FZF_ALT_C_OPTS` | (complex) | Directory finder options |

Set `FZF_THEME` before loading the plugin:

```zsh
export FZF_THEME="catppuccin-mocha"  # default
```

Override the file browser or editor auto-detection:

```zsh
export FZF_BROWSER="yazi"
export FZF_EDITOR="nvim"
```

Custom themes live in the `themes/` directory — see [themes/README.md](themes/README.md) for details.

## The zsh-contrib Ecosystem

| Repo | What it provides |
|------|-----------------|
| [zsh-aws](https://github.com/zsh-contrib/zsh-aws) | AWS credential management with aws-vault and tmux |
| [zsh-eza](https://github.com/zsh-contrib/zsh-eza) | eza with Catppuccin and Rose Pine theming |
| **zsh-fzf** ← you are here | fzf with Catppuccin and Rose Pine theming |
| [zsh-op](https://github.com/zsh-contrib/zsh-op) | 1Password CLI with secure caching and SSH key management |
| [zsh-tmux](https://github.com/zsh-contrib/zsh-tmux) | Automatic tmux window title management |
| [zsh-vivid](https://github.com/zsh-contrib/zsh-vivid) | vivid LS_COLORS generation with theme support |

## License

[MIT](LICENSE) — Copyright (c) 2025 zsh-contrib

<!-- markdownlint-disable-file MD013 -->
