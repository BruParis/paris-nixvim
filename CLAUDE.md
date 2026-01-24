# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Nix-based Neovim configuration (forked from kickstart-nix.nvim). All plugins and dependencies are managed declaratively through Nix flakes, with Lua used for runtime configuration.

## Build & Development Commands

```bash
# Build the Neovim package
nix build .#nvim

# Run Neovim directly from the flake
nix run .#nvim

# Enter dev shell (provides lua-language-server, nil, stylua, luacheck)
nix develop
# or via direnv (automatic with .envrc):
direnv allow

# Format Lua files
stylua .

# Lint Lua files
luacheck .
```

There is no test suite. Changes are validated by building (`nix build`) and running the editor.

## Architecture

### Nix Layer (nix/)

- **`flake.nix`** — Defines inputs (nixpkgs 25.05, flake-utils, gen-luarc), dev shell, and the nvim package output.
- **`nix/neovim-overlay.nix`** — Declares all plugins (from nixpkgs vimPlugins), runtime dependencies (LSP servers, formatters, debuggers), and the Python environment (pylsp + plugins). This is where you add/remove plugins.
- **`nix/mkNeovim.nix`** — Builder function that assembles the Neovim derivation: manages runtimepath, plugin loading order, and generates the bootstrap init.lua.

### Neovim Configuration Layer (nvim/)

- **`nvim/init.lua`** — Global options, colorscheme, diagnostics. Loaded first.
- **`nvim/plugin/*.lua`** — Auto-loaded plugin configurations (completion, telescope, treesitter, git tools, etc.). Sourced after init.lua.
- **`nvim/ftplugin/*.lua`** — Filetype-specific LSP client initialization. Each file starts the appropriate language server (e.g., `python.lua` starts pylsp, `rust.lua` starts rust-analyzer).
- **`nvim/lua/user/lsp.lua`** — Shared LSP capabilities module used by all ftplugin files.

### Initialization Order

1. `vim.loader.enable()`
2. Prepend `nvim/lua/` to runtimepath
3. Source `nvim/init.lua`
4. Auto-source all `nvim/plugin/*.lua` files
5. Filetype-specific `nvim/ftplugin/*.lua` on buffer open

### Adding a New Plugin

1. Add the plugin to `nix/neovim-overlay.nix` in the appropriate list (start plugins load eagerly, opt plugins load lazily)
2. If the plugin needs runtime dependencies (LSP servers, CLI tools), add them to `extraPackages` in the same file
3. Create `nvim/plugin/<name>.lua` for its configuration
4. Rebuild with `nix build .#nvim`

### Adding a New Language

1. Add the LSP server to `extraPackages` in `nix/neovim-overlay.nix`
2. Create `nvim/ftplugin/<filetype>.lua` that calls `vim.lsp.start()` with the server config
3. Use `require('user.lsp').make_client_capabilities()` for capabilities

## Code Style

- Lua: 2-space indentation, single quotes, Unix line endings (enforced by `.stylua.toml`)
- Nix: Follow existing formatting patterns in the flake files
