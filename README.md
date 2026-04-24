# dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/), built for CachyOS with Niri and Noctalia shell.


## Install

On a fresh CachyOS system with Niri template:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply lukasz-sz96/dotfiles
```

If `chezmoi` is already installed:

```sh
chezmoi init --apply lukasz-sz96/dotfiles
```

## Package Lists

Packages are split by source:

- `packages/pacman.txt` contains packages from configured pacman repositories.
- `packages/aur.txt` contains AUR packages installed through `paru`.


## Bootstrap Behavior

The install scripts run through chezmoi:

- `run_once_before_00-bootstrap-cachy.sh.tmpl` installs base tools and enables wheel sudo.
- `run_onchange_before_10-install-pacman-packages.sh.tmpl` installs packages from `packages/pacman.txt`.
- `run_once_before_20-install-paru.sh.tmpl` installs `paru` if it is missing.
- `run_onchange_before_30-install-aur-packages.sh.tmpl` installs packages from `packages/aur.txt`.
- `run_once_after_80-create-extra-users.sh.tmpl` creates users listed in `users/extra-users.txt`.

Review the scripts before applying on a new machine.

## Daily Use

```sh
chezmoi diff
chezmoi apply
chezmoi cd
```

After editing package lists, rerun:

```sh
chezmoi apply
```
