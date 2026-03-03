# rsync.nvim - Agent Documentation

## Project Overview

**rsync.nvim** is a minimal Neovim plugin written in Lua that automatically syncs local project files to remote servers using rsync. It is inspired by [coffebar/transfer.nvim](https://github.com/coffebar/transfer.nvim) but provides a simpler, more focused feature set.

The primary use case is for developers who write code locally but need to test it on remote virtual machines or servers. The plugin detects the git repository root and syncs the entire project on file save.

**Status**: Work in progress 🔧

## Technology Stack

- **Language**: Lua (Neovim plugin API)
- **External Dependencies**:
  - `rsync` - File synchronization tool
  - `ssh` - For remote connections
  - `git` - For repository root detection
- **Code Formatter**: StyLua

## Project Structure

```
.
├── lua/transfer/           # Main plugin source code
│   ├── init.lua            # Entry point, exports setup function
│   ├── config.lua          # Default configuration and options
│   ├── commands.lua        # User commands (:TransferInit, :TransferToggle, etc.)
│   └── transfer.lua        # Core rsync logic and command building
├── .nvim/
│   └── deployment.lua      # Example deployment configuration file
├── .stylua.toml            # StyLua formatter configuration
├── README.md               # Human-readable project documentation
└── todo.md                 # Development task list (in Chinese)
```

## Module Breakdown

### `lua/transfer/init.lua`
Main entry point. Exports the `setup()` function which initializes configuration and commands.

### `lua/transfer/config.lua`
Configuration management module. Defines default options including the deployment config template.

### `lua/transfer/commands.lua`
Implements all user-facing commands:
- `:TransferInit` - Creates `.nvim/deployment.lua` config file from template
- `:TransferToggle` - Enable/disable auto-sync
- `:TransferShow` - Display the rsync command that would be executed

Also sets up the `BufWritePost` autocmd that triggers synchronization when files are saved.

### `lua/transfer/transfer.lua`
Core synchronization logic:
- `build_rsync_cmd()` - Constructs rsync command with proper flags
- `sync_dir()` - Executes rsync asynchronously using `vim.fn.jobstart()`

## Configuration

### Plugin Configuration
Set in your Neovim config when calling `require("transfer").setup(opts)`:

```lua
{
  config_template = [[
return {
  ip = "10.0.1.0",
  user = "root",
  location = "/root",
  ignore_git = false,
}
]],
}
```

### Per-Project Deployment Configuration
Stored in `.nvim/deployment.lua` at project root:

```lua
return {
  port = "50644",      -- Optional: SSH port (default: 22)
  ip = "localhost",    -- Required: Remote host IP or hostname
  user = "root",       -- Required: SSH username
  location = "/root",  -- Required: Remote destination path
  ignore_git = false,  -- Optional: Exclude .git/ directory
}
```

## Code Style Guidelines

The project uses [StyLua](https://github.com/JohnnyMorganz/StyLua) for formatting.

Configuration (`.stylua.toml`):
- Column width: 120
- Line endings: Unix
- Indent: 2 spaces
- Quote style: AutoPreferDouble

### Formatting Command
```bash
stylua lua/
```

## Build and Test

This is a pure Lua plugin with no build step required. For testing:

1. Load the plugin in Neovim
2. Run `:TransferInit` to create a deployment config
3. Edit `.nvim/deployment.lua` with your remote server details
4. Run `:TransferToggle` to enable auto-sync
5. Save a file and verify it syncs to the remote server

## Key Features

1. **Git Root Detection**: Automatically detects git repository root to sync the entire project
2. **Gitignore Support**: Uses rsync's `--filter='dir-merge,- .gitignore'` to respect `.gitignore` rules
3. **Async Execution**: Non-blocking rsync execution using `vim.fn.jobstart()`
4. **Toggle Control**: Enable/disable synchronization on demand
5. **Custom SSH Port**: Support for non-standard SSH ports
6. **Visual Feedback**: Notifications for sync status and errors

## Development Notes

- The plugin uses `vim.loop.cwd()` to determine current working directory
- Configuration is loaded lazily on first toggle/command
- The rsync command format: `rsync -avzh --filter='dir-merge,- .gitignore' [options] <source> <destination>`
- Error output from rsync is captured and displayed via `vim.notify()`

## Known Limitations / TODO

From `todo.md`:
1. Consider making `--exclude=.git/` and `--delete` flags configurable options
2. Add status line integration to show rsync state
3. Consider changing trigger event from `BufWritePost` to focus change
4. Clock skew issues with rsync timestamps may cause "make: warning: Clock skew detected"

## Similar Projects

- [coffebar/transfer.nvim](https://github.com/coffebar/transfer.nvim) - Full-featured alternative
- [KenN7/vim-arsync](https://github.com/KenN7/vim-arsync) - Vim rsync plugin
- [OscarCreator/rsync.nvim](https://github.com/OscarCreator/rsync.nvim) - Another rsync plugin

## Resources

- [rsync manual](https://download.samba.org/pub/rsync/rsync.1)
- [rsync with different SSH ports](https://stackoverflow.com/questions/4549945/is-it-possible-to-specify-a-different-ssh-port-when-using-rsync)
