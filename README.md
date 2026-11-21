# dot_files

### Setup

```
bash setup_machine.sh
```

This works on macOS (brew), Debian/Ubuntu, Fedora, Amazon Linux/CentOS and Arch. It is safe to re-run: the second run
won't change your rc files and just updates the installed tools to their latest versions.

- The shared configs below are symlinked into `$HOME`. If a real file is already there, it's backed up to `<file>.bak.<timestamp>` first.
- `~/.bashrc` and `~/.zshrc` are never replaced, since they hold machine-specific things (API keys, local paths). The script only appends a single `source ~/.common{bash,zsh}rc` line if it isn't already there.
- Machine-specific git settings go in `~/.gitconfig.local` (untracked), which `.gitconfig` includes.

Use `SKIP_INSTALL=1 bash setup_machine.sh` to only link files without installing anything.

`bootstrap.sh` just runs `setup_machine.sh`. It exists because dev containers / Codespaces / Cursor automatically run a
`bootstrap.sh` from your dotfiles repo.

### Meaning of each dotfile

**.commonrc:** Common rc configs that will always be sourced, no matter the shell.

**.commonbashrc:** Common rc configs for bash. Sources `.commonrc`.

**.commonzshrc:** Common rc configs for zsh. Sources `.commonrc`.

**.gitrc:** git aliases and helpers (sourced by `.commonrc`).

### JetBrains / IdeaVim

`.ideavimrc` is linked by the setup script. You may need to restart the IDE.

### Adding packages to Amazon Linux when they're NOT available in the package manager

Build the package from source (e.g. with `cargo build`), put the binary in `binaries/amazon-ec2-linux-2023/`, and add a
symlink for it into `~/.local/bin` in the `centos` branch of `setup_machine.sh`.
