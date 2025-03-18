## Table of Contents
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Usage](#usage)
- [Keybindings](#keybindings)
- [Plugins](#plugins)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)

## Installation

### Ubuntu
1. **Install Neovim**:
   ```bash
   sudo apt update
   sudo apt install neovim
   ```

2. **Install Python3 and pip**:
   ```bash
   sudo apt install python3 python3-pip
   ```

3. **Install pynvim**:
   ```bash
   pip3 install pynvim
   ```

4. **Clone this repository**:
   ```bash
   git clone https://github.com/your-username/your-repo.git ~/.config/nvim
   ```

### Arch Linux
1. **Install Neovim**:
   ```bash
   sudo pacman -S neovim
   ```

2. **Install Python3 and pip**:
   ```bash
   sudo pacman -S python python-pip
   ```

3. **Install pynvim**:
   ```bash
   pip install pynvim
   ```

4. **Clone this repository**:
   ```bash
   git clone https://github.com/miaolei20/nvim ~/.config/nvim
   ```
5. **Total**
6. ```bash
   sudo pacman -S make clang llvm python gcc ripgrep unzip fd curl python-pip nodejs npm curl cargo rust lazygit
   curl -sLo/tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip  
   unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe  
   chmod +x /tmp/win32yank.exe  
   sudo mv /tmp/win32yank.exe /usr/local/bin/
   ```
## Dependencies

### Required Packages
- **Git**: For version control and plugin management.
- **Node.js**: Required for some LSP servers like `tsserver`.
- **Rust**: Required for `rust-analyzer`.
- **Cargo**: Rust's package manager.
- **Clang**: For C/C++ development.
- **Python**: For Python development and some plugins.
- **win32yank**: copy and paste

### Optional Packages
- **ripgrep**: For faster searching with Telescope.
- **fd**: For faster file finding with Telescope.
- **lazygit**: For Git integration.

## Usage

### Basic Commands
- **Open Neovim**: Simply run `nvim` in your terminal.
- **Install Plugins**: Open Neovim and run `:Lazy install` to install all plugins.
- **Update Plugins**: Run `:Lazy update` to update all plugins.

### Keybindings

#### General
- `<leader>`: Space key (default leader key).
- `<C-l>`: Switch to the right window.
- `<C-h>`: Switch to the left window.
- `<C-j>`: Switch to the window below.
- `<C-k>`: Switch to the window above.
- `<leader>vv`: Vertical split.
- `<leader>ss`: Horizontal split.

#### LSP
- `gd`: Peek definition.
- `gr`: Find references.
- `K`: Show documentation.
- `<leader>rn`: Rename symbol.
- `<leader>lf`: Format buffer.

#### Telescope
- `<leader>ff`: Find files.
- `<leader>fg`: Live grep.
- `<leader>fs`: Frecency files.
- `<leader>fe`: File browser.
- `<leader>fu`: Undo history.
- `<leader>fp`: Lazy plugins.

#### Git
- `<leader>gg`: Open Lazygit.

#### Debugging
- `<F5>`: Compile and run the current C/C++ file.

## Plugins

### Core Plugins
- **Lazy.nvim**: Plugin manager.
- **nvim-lspconfig**: LSP configuration.
- **mason.nvim**: LSP and DAP installer.
- **telescope.nvim**: Fuzzy finder.
- **nvim-treesitter**: Syntax highlighting.
- **lualine.nvim**: Status line.
- **nvim-tree.lua**: File explorer.

### Additional Plugins
- **copilot.lua**: GitHub Copilot integration.
- **gitsigns.nvim**: Git status in the gutter.
- **undotree**: Visualize undo history.
- **which-key.nvim**: Keybinding helper.
- **nvim-autopairs**: Auto-pair brackets.
- **nvim-cmp**: Auto-completion.
- **nvim-comment**: Commenting support.

## Customization

### Themes
The configuration uses the **onedark** theme by default. You can change the theme by modifying the `onedark.lua` file in the `plugins/UI` directory.

### Keybindings
You can customize keybindings in the `keymaps.lua` file located in the `config` directory.

### Plugins
To add or remove plugins, edit the `init.lua` file in the `plugins` directory. Each plugin is managed by **Lazy.nvim**, so you can easily add or remove plugins as needed.

## Troubleshooting

### Plugin Installation Issues
If you encounter issues with plugin installation, ensure that you have all the required dependencies installed. You can also try running `:Lazy clean` to remove any corrupted plugin installations and then `:Lazy install` to reinstall them.

### LSP Issues
If LSP servers are not working correctly, ensure that the required language servers are installed. You can check the status of LSP servers by running `:LspInfo`.

### Performance Issues
If you experience performance issues, try disabling some plugins or reducing the number of active LSP servers. You can also enable **impatient.nvim** to improve startup time.

## Contributing
Contributions are welcome! Please feel free to submit issues or pull requests to improve this configuration.

---
