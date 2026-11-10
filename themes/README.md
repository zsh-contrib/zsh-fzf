# FZF Themes

This directory contains color themes for the zsh-fzf plugin. Each theme is a self-contained zsh script that defines fzf color options.

## Available Themes

### Catppuccin Themes

Catppuccin is a community-driven pastel theme that aims to be the middle ground between low and high contrast themes.

| Theme | File | Description |
|-------|------|-------------|
| `catppuccin-latte` | [catppuccin-latte.zsh](./catppuccin-latte.zsh) | Light theme with warm tones |
| `catppuccin-frappe` | [catppuccin-frappe.zsh](./catppuccin-frappe.zsh) | Dark theme with soft contrast |
| `catppuccin-macchiato` | [catppuccin-macchiato.zsh](./catppuccin-macchiato.zsh) | Dark theme with medium contrast |
| `catppuccin-mocha` | [catppuccin-mocha.zsh](./catppuccin-mocha.zsh) | Dark theme with deep contrast (default) |

**Source:** [Catppuccin](https://github.com/catppuccin/catppuccin)

### Rose Pine Themes

Rosé Pine is an all-natural pine, faux fur, a bit of soho vibes for the classy minimalist.

| Theme | File | Description |
|-------|------|-------------|
| `rose-pine` | [rose-pine.zsh](./rose-pine.zsh) | Dark theme with warm, muted colors |
| `rose-pine-dawn` | [rose-pine-dawn.zsh](./rose-pine-dawn.zsh) | Light theme with warm, natural colors |
| `rose-pine-moon` | [rose-pine-moon.zsh](./rose-pine-moon.zsh) | Dark theme with cool, muted colors |

**Source:** [Rose Pine](https://github.com/rose-pine/fzf)

## Usage

Themes are automatically loaded by the plugin based on the `FZF_THEME` environment variable. Set your preferred theme before loading the plugin:

```zsh
# In your .zshrc, before loading the plugin
export FZF_THEME="catppuccin-mocha"  # default

# Or use a Rose Pine theme
export FZF_THEME="rose-pine"
```

## Theme Structure

Each theme file follows a consistent structure:

```zsh
#!/usr/bin/env zsh
# Theme Name - Description
# Source URL

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --color=bg+:#...,bg:#...,spinner:#...,hl:#... \
  --color=fg:#...,header:#...,info:#...,pointer:#... \
  --color=marker:#...,fg+:#...,prompt:#...,hl+:#... \
  --color=selected-bg:#... \
  --color=border:#...,label:#..."
```

### Color Keys

All themes define colors for the following fzf UI elements:

| Key | Description |
|-----|-------------|
| `bg` | Background color |
| `bg+` | Background color for current line |
| `fg` | Foreground color (text) |
| `fg+` | Foreground color for current line |
| `hl` | Highlight color for matching text |
| `hl+` | Highlight color for matching text on current line |
| `selected-bg` | Background color for selected items |
| `border` | Border color |
| `header` | Header text color |
| `info` | Info line color |
| `marker` | Marker color (for multi-select) |
| `pointer` | Pointer/cursor color |
| `prompt` | Prompt color |
| `spinner` | Loading spinner color |
| `label` | Label text color |

## Creating Custom Themes

Keep your theme outside the plugin directory so it survives plugin updates.

1. **Create a theme file** anywhere you like:
   ```bash
   mkdir -p ~/.config/fzf/themes
   touch ~/.config/fzf/themes/my-theme.zsh
   ```

2. **Add the theme content** following the structure above:
   ```zsh
   #!/usr/bin/env zsh
   # My Custom Theme - Description

   export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
     --color=bg+:#...,bg:#...,spinner:#...,hl:#... \
     --color=fg:#...,header:#...,info:#...,pointer:#... \
     --color=marker:#...,fg+:#...,prompt:#...,hl+:#... \
     --color=selected-bg:#... \
     --color=border:#...,label:#..."
   ```

3. **Use your theme** by setting an absolute path before loading the plugin:
   ```zsh
   export FZF_THEME="$HOME/.config/fzf/themes/my-theme.zsh"

   # With auto detection (tmux/macOS), set the dark/light variants instead:
   export FZF_THEME_DARK="$HOME/.config/fzf/themes/my-theme.zsh"
   export FZF_THEME_LIGHT="catppuccin-latte"
   ```

   Use `$HOME` instead of `~` so the path expands. To contribute a theme to the plugin itself, add it to this directory instead and use its bare name.

### Tips for Theme Creation

- **Test your colors**: Use `fzf --preview 'cat {}'` to preview your theme
- **Ensure contrast**: Make sure selected items are clearly visible
- **Be consistent**: Follow the established pattern for easier maintenance
- **Document your theme**: Add a comment with the theme name and source
- **Use hex colors**: Always use 6-digit hex colors (e.g., `#1e1e2e`)

## Variable Scope

Theme files append color options to the `FZF_DEFAULT_OPTS` variable that is set in the plugin file. This means:

- Base fzf options (layout, prompt, etc.) are defined in `zsh-fzf.plugin.zsh`
- Theme files only add `--color=...` options
- Themes are sourced after base config, so `$FZF_DEFAULT_OPTS` is already set

## Troubleshooting

**Theme not loading?**
- For a bundled theme, check that `FZF_THEME` matches a filename in this directory (without `.zsh`)
- For a custom theme, check that `FZF_THEME` is an absolute path to an existing file; a warning is printed if it is missing
- With auto detection (tmux or macOS), `FZF_THEME_DARK` / `FZF_THEME_LIGHT` override `FZF_THEME`; set `ZSH_FZF_AUTO_THEME=false` to turn detection off
- Check for syntax errors in the theme file

**Colors look wrong?**
- Make sure you're using 6-digit hex colors
- Test the theme with `fzf` to see actual colors
- Check terminal color support (`echo $TERM`)

**"unknown theme" warning?**
- The name doesn't match a file in this directory; run `fzf-themes-list` to see what's available
- Check the `FZF_THEME` variable: `echo $FZF_THEME`
- fzf keeps its default colors until a valid theme is loaded

## Contributing

To contribute a new theme:

1. Create a theme file following the structure above
2. Test it thoroughly with various fzf operations
3. Add documentation to this README
4. Submit a pull request

Popular theme bases you might want to port:
- [Tokyo Night](https://github.com/folke/tokyonight.nvim)
- [Dracula](https://draculatheme.com/)
- [Gruvbox](https://github.com/morhetz/gruvbox)
- [Nord](https://www.nordtheme.com/)
- [Solarized](https://ethanschoonover.com/solarized/)
