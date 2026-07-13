# Dotfiles

Personal shell and application configuration for macOS workstations and Debian
servers. The primary shell setup is fast, framework-free Zsh; the old Oh My
Zsh configuration remains available for compatibility.

## Overview

| Setup | Platforms | Description |
| --- | --- | --- |
| `zsh` | macOS, Debian | Primary setup. Pure Zsh with all interactive features enabled. |
| `omz` | macOS, Debian | Legacy Oh My Zsh setup with `basic` and `full` modes. |
| `bash` | macOS, Debian | Bash profiles and aliases. |

The repository also contains Git and Vim configuration, macOS defaults,
terminal themes, Sublime Text settings, SSH configuration, and administration
scripts under `tools/`.

## Zsh features

The pure-Zsh setup provides:

- a two-line prompt with rich Git status: branch, staged, changed, deleted,
  untracked, stashed, ahead, and behind information;
- shared history, European timestamps, and substring search with the arrow
  keys;
- cached, case-insensitive completion with menu selection, plus Rustup and
  dynamic Mix task completion;
- command autosuggestions and syntax highlighting, deferred until after the
  first prompt;
- `ccat` and `cless` source highlighting through Pygments or Chroma;
- `als` for browsing aliases and Escape-Escape for toggling `sudo`;
- virtual-environment discovery and deferred pyenv, jenv, asdf, and SSH-agent
  initialization;
- local extensions through `~/.zsh/local.sh`.

The macOS configuration additionally includes:

- Finder, Terminal, iTerm2, Hyper, Ghostty, Xcode, Quick Look, VNC, and
  `.DS_Store` helpers;
- Apple Music and Spotify command-line controls;
- project, GitHub, download, network, and university-directory shortcuts;
- Homebrew, OpenSSL, Go, Java, Python, Rust, LLVM, AMPL, and compiler paths.

The Debian configuration includes server-directory shortcuts, GNU colored
`ls`, network helpers, and a visually distinct host prompt.

## First installation

You need Zsh and Git. macOS already ships Zsh; installing the Xcode Command
Line Tools provides Git if it is not present:

```sh
xcode-select --install
```

Clone only this repository yourself, then run its installer:

```sh
git clone git@github.com:semklauke/dotfiles.git ~/Documents/Projects/dotfiles
cd ~/Documents/Projects/dotfiles
./install.sh zsh macos
exec zsh
```

The installer automatically clones all additional plugin repositories. You do
not need to clone them manually.

For Debian:

```sh
./install.sh zsh debian
```

To install into a different home directory, pass it as the third argument:

```sh
./install.sh zsh macos /path/to/home
```

## External Zsh tools

On the first pure-Zsh installation, `install.sh` creates `~/.zsh/plugins` and
performs shallow clones of:

| Repository | Purpose |
| --- | --- |
| [`romkatv/zsh-defer`](https://github.com/romkatv/zsh-defer) | Loads slower integrations after the first prompt. |
| [`zsh-users/zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) | Suggests commands from history. |
| [`zsh-users/zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting) | Highlights the current command line. |
| [`zsh-users/zsh-history-substring-search`](https://github.com/zsh-users/zsh-history-substring-search) | Searches for history entries containing the typed text. |
| [`hnarayanan/shpotify`](https://github.com/hnarayanan/shpotify) | Provides `spotify` on macOS. |

On later installer runs, these checkouts are updated with `git pull
--ff-only`. A missing network connection or a locally diverged plugin checkout
causes the installation to stop rather than silently replacing plugin files.

## Music and Spotify

These are three separate integrations:

- `music` and the deprecated-compatible `itunes` alias are a lightweight local
  replacement for the corresponding Oh My Zsh macOS-plugin feature. The code
  lives in `zsh/lib/macos.zsh`, calls macOS `osascript` only when invoked, and
  controls Music.app directly. Examples: `music play`, `music next`, `music
  vol 50`, `music status`, and `music shuffle toggle`.
- `spotify` is a small wrapper around the `hnarayanan/shpotify` checkout that
  the installer places in `~/.zsh/plugins/shpotify`. The Spotify desktop app is
  required. Searching and playing music by name additionally requires Spotify
  API credentials in `~/.shpotify.cfg`; see the [upstream shpotify
  README](https://github.com/hnarayanan/shpotify#connecting-to-spotifys-api) for
  its `CLIENT_ID` and `CLIENT_SECRET` setup. Shpotify is also the upstream tool
  from which Oh My Zsh's Spotify helper is derived.
- `spotify-cli` forwards arguments to `spicetify`. Spicetify is optional and is
  not installed by this repository.

Example Spotify commands:

```sh
spotify play
spotify play artist "Artist Name"
spotify next
spotify status
spotify vol up
```

## Installer behavior

The general form is:

```text
./install.sh <shell> <system> [interactive_mode] [homefolder]
```

- `<shell>` is `zsh`, `omz`, or `bash`.
- `<system>` is `macos` or `debian`.
- `interactive_mode` is only relevant to the legacy `omz` setup and accepts
  `basic` or `full`.
- For pure Zsh, a third argument is treated as the destination home. For OMZ
  and Bash, the destination home is the fourth argument.

Pure Zsh installs `.zshrc` and `.zshenv` into the destination home. Modules,
completions, plugin checkouts, and the completion cache live under `~/.zsh`.

Reinstallation is designed to be safe and idempotent:

- identical files are reported as `Up to date`;
- files matching an older committed repository version are updated silently;
- legacy installer-generated interactive-mode lines are recognized during an
  OMZ-to-pure-Zsh migration;
- genuine local changes produce a neighboring `.diff` file before managed
  shell files are overwritten;
- local `.gitconfig` and `.vimrc` changes are kept instead of overwritten.

## Legacy Oh My Zsh

The old setup is still available, but requires an existing
`~/.oh-my-zsh/custom` directory:

```sh
./install.sh omz macos full
./install.sh omz debian basic
```

New installations should normally use `zsh`.
