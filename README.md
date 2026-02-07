# zsh-fzf

A Zsh plugin for [fzf](https://github.com/junegunn/fzf) integration with Catppuccin and Rose Pine theming and enhanced key bindings.

## Features

- Catppuccin and Rose Pine color themes (latte, frappe, macchiato, mocha, rose-pine, rose-pine-moon, rose-pine-dawn)
- Enhanced key bindings for file/directory selection
- Minimal, clean visual style

## Requirements

- [fzf](https://github.com/junegunn/fzf) - Command-line fuzzy finder
- [vifm](https://vifm.info/) or [yazi](https://yazi-rs.github.io/) (optional, for enhanced file management)

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

Themes are organized in the `themes/` directory with each theme in its own file. See [themes/README.md](themes/README.md) for more details on creating custom themes.

### File Browser/Manager Configuration

The plugin automatically detects and configures a file browser/manager for the `Alt+Enter` binding:

1. **vifm** - If installed, used as the default browser
2. **yazi** - If vifm is not available, yazi is used
3. **vim** - Final fallback if neither file manager is installed

You can override the auto-detection by setting `FZF_BROWSER` before loading the plugin:

```zsh
export FZF_BROWSER="your-preferred-browser"
```

### Text Editor Configuration

The plugin automatically detects and configures a text editor:

1. **nvim** - If installed, used as the default editor
2. **vim** - Fallback if nvim is not available

You can override the auto-detection by setting `FZF_EDITOR` before loading the plugin:

```zsh
export FZF_EDITOR="your-preferred-editor"
```

#### Available Themes

| Theme                  | Description                             |
| ---------------------- | --------------------------------------- |
| `catppuccin-latte`     | Light theme with warm tones             |
| `catppuccin-frappe`    | Dark theme with soft contrast           |
| `catppuccin-macchiato` | Dark theme with medium contrast         |
| `catppuccin-mocha`     | Dark theme with deep contrast (default) |
| `rose-pine`            | Dark theme with warm, muted colors      |
| `rose-pine-dawn`       | Light theme with warm, natural colors   |
| `rose-pine-moon`       | Dark theme with cool, muted colors      |

### Environment Variables

| Variable           | Default            | Description                                      |
| ------------------ | ------------------ | ------------------------------------------------ |
| `FZF_THEME`        | `catppuccin-mocha` | Color theme                                      |
| `FZF_OPENER`       | `open` / `xdg-open`| System default file opener (auto-detected)       |
| `FZF_BROWSER`      | `vifm` / `yazi` / `vim` | File browser/manager (auto-detected with fallback) |
| `FZF_EDITOR`       | `nvim` / `vim`     | Text editor (auto-detected with fallback)        |
| `FZF_DEFAULT_OPTS` | (complex)          | Base fzf styling options                         |
| `FZF_CTRL_T_OPTS`  | (complex)          | File finder options                              |
| `FZF_ALT_C_OPTS`   | (complex)          | Directory finder options                         |

## API Reference

### Global Key Bindings

#### File Picker (Ctrl+T)

| Key         | Action                                          |
| ----------- | ----------------------------------------------- |
| `Alt+Enter` | Open in text editor (nvim/vim)                  |
| `Ctrl+O`    | Open with system default application            |

#### Directory Picker (Alt+C)

| Key         | Action                                          |
| ----------- | ----------------------------------------------- |
| `Alt+Enter` | Open in file browser (vifm/yazi/vim)            |
| `Ctrl+O`    | Open with system default application            |

## Directory Structure

```
zsh-fzf/
├── zsh-fzf.plugin.zsh    # Plugin configuration and theme loader
├── themes/               # Theme definitions
│   ├── README.md         # Theme documentation
│   └── *.zsh             # Individual theme files
├── README.md
└── LICENSE
```

## License

MIT License - see [LICENSE](./LICENSE) for details.
