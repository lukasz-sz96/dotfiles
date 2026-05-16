# dotfiles

Personal chezmoi dotfiles for CachyOS/Arch and Bluefin/Atomic systems with Niri + Noctalia.

## Install

CachyOS/Arch:

```bash
chezmoi init --apply lukasz-sz96/dotfiles
```

Bluefin:

```bash
chezmoi init --apply --branch bluefin lukasz-sz96/dotfiles
```

From the custom Bluefin image:

```bash
ujust apply-dotfiles
```

## Package Split

- `packages/image.txt`: packages that belong in the custom bootc image.
- `packages/brew.txt`: user-space CLI and development tools for Homebrew.
- `packages/flatpak.txt`: GUI apps for Flatpak.
- `packages/arch/pacman.txt`: Arch repository packages.
- `packages/arch/aur.txt`: AUR packages.

On Bluefin, dotfiles do not run `dnf`, `rpm-ostree`, `bootc`, `pacman`, `paru`, `yay`, or `makepkg`. Arch-only scripts are guarded with `/etc/os-release` checks.

## Optional Scripts

Install Vite+:

```bash
CHEZMOI_INSTALL_VITE_PLUS=true chezmoi apply
```

Create extra users from `users/extra-users.txt` on Arch/CachyOS:

```bash
CHEZMOI_CREATE_EXTRA_USERS=true chezmoi apply
```

Both are skipped by default.

## Daily Use

```bash
chezmoi diff
chezmoi apply
chezmoi cd
```

Bluefin verification:

```bash
scripts/check-bluefin.sh
```
