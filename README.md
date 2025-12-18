# zsh-fzf

A Zsh plugin for [fzf](https://github.com/junegunn/fzf) integration with Catppuccin theming and enhanced key bindings.

## Features

- Catppuccin color themes (latte, frappe, macchiato, mocha)
- Enhanced key bindings for file/directory selection
- Zoxide integration for smart directory jumping
- Minimal, clean visual style

## Requirements

- [fzf](https://github.com/junegunn/fzf) - Command-line fuzzy finder
- [zoxide](https://github.com/ajeetdsouza/zoxide) - Smarter cd command (optional, for `j` function)
- [vifm](https://vifm.info/) - File manager (optional, for `Alt+Enter` binding)

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

## Configuration

### Theme Selection

Set `FZF_THEME` before loading the plugin:

```zsh
export FZF_THEME="catppuccin-mocha"  # default
```

#### Available Themes

| Theme | Description |
|-------|-------------|
| `catppuccin-latte` | Light theme with warm tones |
| `catppuccin-frappe` | Dark theme with soft contrast |
| `catppuccin-macchiato` | Dark theme with medium contrast |
| `catppuccin-mocha` | Dark theme with deep contrast (default) |

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `FZF_THEME` | `catppuccin-mocha` | Color theme |
| `FZF_DEFAULT_OPTS` | (complex) | Base fzf styling options |
| `FZF_CTRL_T_OPTS` | (complex) | File finder options |
| `FZF_ALT_C_OPTS` | (complex) | Directory finder options |

## API Reference

### Functions

#### `j` - Directory Jump

Interactive directory jumping using zoxide with fzf interface.

```zsh
j [query]
```

**Arguments:**

| Argument | Required | Description |
|----------|----------|-------------|
| `query` | No | Initial search query to filter directories |

**Key Bindings:**

| Key | Action |
|-----|--------|
| `Enter` | Change to selected directory |
| `Alt+Enter` | Open directory in vifm |
| `Alt+O` | Open with system default |

**Example:**

```zsh
# Interactive selection
j

# Filter by query
j projects
```

### Global Key Bindings

These bindings are active in fzf's `Ctrl+T` and `Alt+C` modes:

| Key | Action |
|-----|--------|
| `Alt+Enter` | Open selection in vifm |
| `Alt+O` | Open with system default application |

## Directory Structure

```
zsh-fzf/
├── zsh-fzf.plugin.zsh    # Main entry point
├── zsh-fzf.config.zsh    # Theme and option configuration
├── widget/
│   └── zoxide.zsh        # j() function implementation
├── README.md
└── LICENSE
```

## License

MIT License - see [LICENSE](./LICENSE) for details.
