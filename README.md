# Dot Files

My private bash/zsh/dotfiles toolset for my **macOS** machines and **debian linux** servers.

* bash
* zsh
* sublime text 3 packages
* vim
* ssh config
* git config 
* tools
* terminal theme macos

## Install

The default Zsh setup is framework-free and enables the complete interactive
configuration on both platforms:

```sh
./install.sh zsh macos
./install.sh zsh debian
```

The legacy Oh My Zsh setup remains available as `omz`; its third argument is
the legacy `basic` or `full` mode:

```sh
./install.sh omz macos full
```

Pass a destination home as the third argument for `zsh`, or as the fourth
argument for `omz` and `bash`.
