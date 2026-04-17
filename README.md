# Dotfiles

This is a collection of my dotfiles that I use across systems.

## Installation

To install, run the following command.

```shell
# Install dependencies for Fedora
$ sudo dnf install git stow neovim tmux
# For MacOS
$ brew install git stow neovim font-sauce-code-pro-nerd-font tmux

# Run install script
$ ./install.sh
```

## Uninstall

To remove the dotfiles:

```bash
./uninst.sh
```

This will:
- Remove `/usr/local/bin/get-user-shell.sh`
- Clean `source ~/.shellrc.sh` from `.bashrc` and `.zshrc`  
- Delete all symlinks in your home directory

