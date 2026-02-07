# zsh-fzf

A Zsh plugin for [fzf](https://github.com/junegunn/fzf) integration with Catppuccin and Rose Pine theming and enhanced key bindings.

## Features

- Catppuccin and Rose Pine color themes (latte, frappe, macchiato, mocha, rose-pine, rose-pine-moon, rose-pine-dawn)
- Enhanced key bindings for file/directory selection
- Minimal, clean visual style

## Requirements

- [fzf](https://github.com/junegunn/fzf) - Command-line fuzzy finder
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

Themes are organized in the `themes/` directory with each theme in its own file. See [themes/README.md](themes/README.md) for more details on creating custom themes.

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

| Variable           | Default            | Description              |
| ------------------ | ------------------ | ------------------------ |
| `FZF_THEME`        | `catppuccin-mocha` | Color theme              |
| `FZF_DEFAULT_OPTS` | (complex)          | Base fzf styling options |
| `FZF_CTRL_T_OPTS`  | (complex)          | File finder options      |
| `FZF_ALT_C_OPTS`   | (complex)          | Directory finder options |

## API Reference

### Global Key Bindings

These bindings are active in fzf's `Ctrl+T` and `Alt+C` modes:

| Key         | Action                               |
| ----------- | ------------------------------------ |
| `Alt+Enter` | Open selection in vifm               |
| `Ctrl+O`    | Open with system default application |

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
