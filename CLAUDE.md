# Neovim Flake Configuration Repository

This repository contains a Neovim configuration managed as a Nix flake, providing a reproducible and declarative Neovim setup.

## Repository Structure

### Root Level
- `flake.nix` - Main flake configuration with inputs, outputs, and system definitions
- `flake.lock` - Lockfile for reproducible builds
- `justfile` - Task runner configuration for common operations
- `stylua.toml` - Lua formatting configuration
- `README.md` - Project documentation with language support matrix
- `cheatsheet.md` - Keybinding and usage reference

### Core Directories

#### `/polar/` - Main Configuration
The heart of the Neovim configuration:
- `default.nix` - Nix package definition for the polar configuration
- `lua/polar/` - Lua configuration modules
  - `init.lua` - Main entry point that loads all configuration
  - `lazy.lua` - Plugin loader using lz.n
  - `config/` - Core configuration modules
    - `options.lua` - Vim options and settings
    - `keymaps.lua` - Key mappings
    - `autocmds.lua` - Auto commands
    - `icons.lua` - Icon definitions
  - `plugins/` - Plugin configurations
    - `ai.lua` - AI-related plugins
    - `coding.lua` - Coding utilities
    - `completion.lua` - Completion setup
    - `dap.lua` - Debug adapter protocol
    - `editor.lua` - Editor enhancements
    - `git-worktree.lua` - Git worktree management
    - `treesitter.lua` - Syntax highlighting
    - `ui.lua` - UI components
    - And many more specialized plugin configs
  - `lsp/` - Language Server Protocol configurations
    - `init.lua` - LSP setup and initialization
  - `utils/` - Utility functions
    - `format.lua` - Code formatting utilities
    - `lsp.lua` - LSP helper functions
  - `core/ui/` - UI components
    - `statuscolumn.lua` - Status column configuration
    - `winbar.lua` - Window bar setup
- `lsp/` - Language-specific LSP configurations
  - `beancount.lua`, `clangd.lua`, `lua_ls.lua`, etc.
- `ftplugin/` - Filetype-specific configurations
- `after/ftplugin/` - Additional filetype configurations
- `doc/` - Documentation files

#### `/pkgs/` - Nix Package Definitions
- `default.nix` - Package exports
- `config.nix` - Main Neovim configuration with plugins, LSPs, and runtime dependencies
- `docgen.nix` - Documentation generation
- `blink-cmp/` - Custom completion plugin package

#### `/npins-*` - Pinned Dependencies
- `npins/` - General pinned sources
- `npins-plugins/` - Pinned Neovim plugins
- `npins-ts-grammars/` - Pinned Tree-sitter grammars

#### `/checks/` - CI/Testing
- `default.nix` - Pre-commit hooks and validation

#### `/scripts/` - Utility Scripts
- `gendocs.lua` - Documentation generation
- `minimal_init.vim` - Minimal configuration for testing

#### `/tests/` - Test Projects
Contains sample projects for testing language support:
- `conan/` - C++ project with Conan
- `netbeans-test/` - Java NetBeans project

## Language Support

The configuration supports multiple languages with varying levels of integration:

| Language  | LSP | Treesitter | Formatter | Lint | Debug | Test |
|-----------|-----|------------|-----------|------|-------|------|
| Beancount | ✓   | ✓          | -         | -    | -     | -    |
| C++       | ✓   | ✓          | ✓         | ✓    | -     | -    |
| Java      | ✓   | ✓          | ✓         | -    | ✓     | -    |
| Lua       | ✓   | ✓          | ✓         | ✓    | -     | -    |
| Nix       | ✓   | ✓          | ✓         | ✓    | -     | -    |
| Python    | ✓   | ✓          | ✓         | ✓    | ✓     | -    |
| Rust      | ✓   | ✓          | ✓         | ✓    | -     | -    |
| TypeScript| ✓   | ✓          | ✓         | -    | -     | -    |

## Key Features

- **Nix Flake**: Reproducible builds with pinned dependencies
- **Plugin Management**: Uses lz.n for lazy loading
- **Language Support**: Comprehensive LSP, formatting, and linting
- **Development Shell**: Includes development tools and pre-commit hooks
- **Custom Plugins**: Includes custom blink-cmp completion plugin
- **Multi-platform**: Supports Linux and macOS (x86_64 and aarch64)

## Development

The repository includes a development shell (`nix develop`) with:
- Pre-commit hooks for code quality
- Development version of Neovim
- Just for task running
- MCP Hub and Task Master AI integration

## Architecture

The configuration follows a modular architecture:
1. **Nix Layer**: Manages dependencies and builds
2. **Lua Layer**: Handles runtime configuration
3. **Plugin Layer**: Modular plugin configurations
4. **LSP Layer**: Language-specific configurations

This structure enables easy maintenance, testing, and customization while maintaining reproducibility through Nix.