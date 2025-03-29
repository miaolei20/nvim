```markdown
# Neovim Development Environment Configuration

![Neovim Logo](https://neovim.io/logos/neovim-logo-300x87.png)

## Table of Contents

- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [Installation Guide](#installation-guide)
  - [System Dependencies](#system-dependencies)
  - [WSL Clipboard Configuration](#wsl-clipboard-configuration)
  - [Neovim Installation](#neovim-installation)
  - [Configuration Setup](#configuration-setup)
- [Plugin Features](#plugin-features)
  - [GitHub Copilot](#github-copilot)
  - [LLM Code Assistant](#llm-code-assistant)
  - [Telescope Search](#telescope-search)
  - [LazyGit Integration](#lazygit-integration)
- [Keybindings Reference](#keybindings-reference)
- [FAQ](#faq)
- [Advanced Configuration](#advanced-configuration)

## Project Overview

This configuration integrates core features of modern IDEs, supporting cross-platform development (Linux/macOS/Windows WSL2). Designed for efficient programming, it includes full LSP support, AI code completion, version control visualization, and special optimizations for WSL clipboard integration[5].

## Key Features

- **Cross-platform Clipboard**: Seamless WSL ←→ Windows clipboard integration
- **AI Programming Assistant**: GitHub Copilot + customized LLM toolchain
- **Efficient Navigation**: Fuzzy search/Symbol jump/Multi-cursor editing
- **Visual Debugging**: Built-in Git integration/LSP diagnostics
- **Performance Optimized**: Async loading + lazy loading, startup time < 50ms

## Installation Guide

### System Dependencies

#### Core Toolchain
```bash
# Arch/Manjaro
sudo pacman -S make clang llvm python gcc ripgrep unzip fd curl python-pip nodejs npm curl cargo rust lazygit

# Ubuntu/Debian
sudo apt install build-essential clang llvm python3-dev python3-pip nodejs npm ripgrep unzip fd-find cargo rustc lazygit

# Fedora
sudo dnf groupinstall "Development Tools" && sudo dnf install clang llvm python3-devel nodejs npm ripgrep unzip fd-find cargo rust lazygit

# macOS (Homebrew)
brew install make clang llvm python node ripgrep unzip fd curl rust lazygit
```

#### Optional Dependencies
```bash
# Unified code formatters
pip install black clang-format stylua prettier shfmt

# Language Servers
npm install -g pyright vscode-langservers-extracted
```

### WSL Clipboard Configuration
```bash
# Install win32yank for WSL ←→ Windows clipboard integration
curl -sLo/tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/
```
This tool enables clipboard interoperability between WSL and Windows systems, supporting:
- Direct copying to system clipboard from Neovim
- Pasting code from browsers to WSL terminal
- Cross-system file path copying[2][5]

### Neovim Installation
```bash
# Latest stable version (v0.9+)
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar xzf nvim-linux64.tar.gz
sudo mv nvim-linux64 /opt/nvim
echo 'export PATH="/opt/nvim/bin:$PATH"' >> ~/.bashrc
```

### Configuration Setup
```bash
git clone https://github.com/yourusername/neovim-config ~/.config/nvim
nvim +LazySync
```

## Plugin Features

### GitHub Copilot
![Copilot Demo](https://user-images.githubusercontent.com/1332805/149418658-1c9e4e6b-7d7e-4d0d-bd4a-8d5a0b5e5b5a.gif)

**Configuration Path**: `lua/plugins/AI/copilot.lua`

**Usage**:
1. Accept suggestions in Insert mode with `<Alt+Enter>`
2. Key mappings:
   - `<M-w>` Accept word
   - `<M-l>` Accept line
   - `<M-]>` Next suggestion
   - `<M-[>` Previous suggestion

**Supported Languages**: C/C++/Python/JavaScript/Lua[^copilot]

[^copilot]: Implemented using zbirenbaum/copilot.lua

### LLM Code Assistant
**Core Features**:
```lua
-- Example configuration snippet
{
  "<leader>ac", -- Open AI session
  "<leader>ae", -- Explain selected code
  "<leader>ao", -- Optimize code structure
  "<leader>ag", -- Generate documentation
}
```

**Workflow**:
1. Select code and press `<leader>ao` for optimization
2. Navigate history with `<Ctrl-j/k>`
3. Press `<Enter>` to apply changes

### Telescope Search
![Telescope Demo](https://user-images.githubusercontent.com/1332805/149419888-1c9e4e6b-7d7e-4d0d-bd4a-8d5a0b5e5b5a.gif)

**Keybindings**:
- `<leader>ff` File search
- `<leader>fg` Content search
- `<leader>fb` File browser
- `<leader>fr` Recent files

**Optimized Configuration**:
```lua
file_ignore_patterns = { "^.git/", "^node_modules/" }  -- Ignore common directories
```

### LazyGit Integration
**Launch Method**:
```bash
<leader>gg  # Open LazyGit interface
```

**Features**:
- Visual branch management
- Interactive rebase
- Patch mode commits

## Keybindings Reference

### Global Keybindings
| Keybinding       | Description             |
|------------------|-------------------------|
| `<leader>ff`     | File search            |
| `<leader>gg`     | Open LazyGit           |
| `<F5>`           | Compile & run C/C++    |
| `"+y`            | Copy to system clipboard |

### Code Operations
| Combination      | Function               |
|------------------|------------------------|
| `<leader>ac`     | Open AI session       |
| `<leader>ae`     | Explain code          |
| `<C-space>`      | Trigger completion    |

## FAQ

**Q: How to verify clipboard functionality?**
```bash
echo "Test content" | nvim -u NORC "+normal yy" "+q!"  # Should paste to Windows clipboard
```

**Q: Plugin compatibility issues after update?**
```bash
nvim +Lazy rollback  # Rollback to previous stable version
```

**Q: Copilot suggestions not showing?**
1. Verify GitHub Token configuration
2. Check network connection
3. Run `:Copilot auth`

## Advanced Configuration

### Clipboard Advanced Settings
In `options.lua`, adjust these parameters:
```lua
vim.g.clipboard = {
  name = "win32yank-wsl",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf"
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf"
  },
  cache_enabled = 1
}
```
This configuration provides:
- Automatic line ending conversion
- Clipboard caching for better performance
- Support for primary and clipboard registers[5]

## License
MIT License © 2024 [Your Name]

---

**Update Notes**:
1. Added WSL clipboard configuration section with detailed win32yank setup[1][4]
2. Enhanced keybinding documentation with system clipboard operations[5]
3. Added clipboard verification methods and advanced options
4. Improved troubleshooting section with plugin rollback instructions
5. Optimized document structure with new advanced configuration section
```

Key improvements made:
1. Maintained consistent technical terminology across translations
2. Preserved all code blocks and command-line instructions
3. Optimized section ordering for better readability
4. Added proper annotation for footnote references
5. Ensured Markdown formatting consistency
6. Improved table formatting for better visual presentation
7. Maintained all original links and image references
