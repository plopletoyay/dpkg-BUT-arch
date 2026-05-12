# `dpkg-BUT-arch`

A fake Debian-style `apt` wrapper for Arch-based Linux distributions.

Official repository:

[https://github.com/plopletoyay/dpkg-BUT-arch](https://github.com/plopletoyay/dpkg-BUT-arch)

This project imitates Debian/Ubuntu package-management commands while actually using Arch Linux tools underneath such as `pacman` and `yay`.

# `apt` Wrapper for Arch-based Systems

> **Not recommended to use `apt` as your main package manager.**
>
> If you are a beginner, it is better to learn and switch between **`pacman`** and **`yay`** first so you understand how Arch package management works.

## Important Warning

Use `apt` with care.
Some commands can be very destructive. For example, `sudo apt purge` maps to a much stronger removal action similar in spirit to `sudo pacman -Rcns`.

This wrapper is made to **simulate familiar Debian/Ubuntu-style `apt` commands** on Arch-based systems. It is not the real `apt`. It is simply a **command alias / command-name wrapper** that lets you type `apt`, `yay`, or `pacman` in a more familiar way.

## What this project does

This project provides an `apt` wrapper that translates common `apt` commands into equivalent Arch-style actions.
It is designed for learning, convenience, and experimentation.

The wrapper can work with:

* `pacman`
* `yay`
* AUR-related package lookups

## Command behavior overview

### `apt install`

`apt install` will search and install packages from both:

* the official `pacman` repositories
* AUR-related package sources handled through `yay`

This means the wrapper tries to make installation feel more like `apt`, while still using Arch package ecosystems underneath.

### `apt remove`

`apt remove` will look for the target program in both:

* AUR packages
* `pacman` packages

It is intended to provide a more unified removal experience across both package sources.

### `apt purge`

`apt purge` is the most aggressive removal form.
It should be used carefully because it is designed to remove the package and related leftover data more deeply than a normal remove operation.

### `apt help` / `apt --help`

After installation, you can use:

```bash
apt
apt help
apt --help
```

to see available options and command usage.

## Available commands

This wrapper mainly translates Debian-style `apt` commands into Arch Linux `pacman` / `yay` commands.

| apt command              | Equivalent command                        |
| ------------------------ | ----------------------------------------- |
| `apt update`             | `pacman -Sy`                              |
| `apt upgrade`            | `pacman -Su`                              |
| `apt full-upgrade`       | `yay -Syu` or `pacman -Syu`               |
| `apt dist-upgrade`       | `yay -Syu` or `pacman -Syu`               |
| `apt install <pkg>`      | `pacman -S <pkg>` or `yay -S <pkg>`       |
| `apt remove <pkg>`       | `pacman -R <pkg>` or `yay -R <pkg>`       |
| `apt purge <pkg>`        | `pacman -Rcns <pkg>` or `yay -Rcns <pkg>` |
| `apt autoremove`         | `pacman -Rs $(pacman -Qdtq)`              |
| `apt search <pkg>`       | `yay -Ss <pkg>` or `pacman -Ss <pkg>`     |
| `apt show <pkg>`         | `pacman -Si <pkg>` or `yay -Si <pkg>`     |
| `apt list --installed`   | `pacman -Q`                               |
| `apt list --upgradeable` | `yay -Qu` or `pacman -Qu`                 |
| `apt clean`              | `pacman -Sc`                              |
| `apt autoclean`          | `pacman -Sc`                              |
| `apt depends <pkg>`      | `pacman -Qi <pkg>`                        |
| `apt rdepends <pkg>`     | `pacman -Qi <pkg>`                        |
| `apt download <pkg>`     | `pacman -Sw <pkg>`                        |
| `apt edit-sources`       | `nano /etc/pacman.d/mirrorlist`           |
| `apt source <pkg>`       | Suggests `asp export <pkg>` or `abs`      |

## Notes about package handling

### `apt install`

The wrapper first checks official `pacman` repositories.
If the package does not exist there, it tries installing through `yay` using the AUR.

This means `apt install` can use:

* official Arch repositories
* AUR packages

---

### `apt remove`

The wrapper also checks both:

* official packages
* AUR packages

before removing the target package.

---

### `apt purge`

This command is powerful and should be used carefully.

It maps to:

```bash
pacman -Rcns
```

which can remove:

* packages
* configs
* dependencies
* orphaned related packages

---

### Unknown commands

If the wrapper does not recognize a command, it forwards the arguments directly into:

```bash
pacman
```

## Configuration

After installation, additional customization can be done in:

```bash
/usr/local/bin/apt
```

This is the wrapper file itself.
You can edit it to change behavior, adjust mappings, or tailor command handling.

### Important note about the config

The configuration does **not** explain every setting in detail.
There is no built-in explanation showing which line does what, so if you want to customize it manually, you must inspect the wrapper code directly.

If you install manually, you must copy the code from the source file yourself.

## Installation methods

### 1) Install automatically

Clone the repository:

```bash
git clone https://github.com/plopletoyay/dpkg-BUT-arch.git
cd dpkg-BUT-arch
```

Then install the wrapper using the provided method from the repository.

Depending on your setup, this may involve copying the wrapper into:

```bash
/usr/local/bin/apt
```

and making it executable.

Example:

```bash
sudo chmod +x /usr/local/bin/apt
```

### 2) Install manually

If you prefer manual installation, copy the code from the source file and place it in the wrapper path yourself.

Basic idea:

1. Open the source file.
2. Copy the code.
3. Save it as `/usr/local/bin/apt`.
4. Make it executable.

Example:

```bash
sudo nano /usr/local/bin/apt
sudo chmod +x /usr/local/bin/apt
```

## After installation

When installation is finished, use one of these commands:

```bash
apt
apt help
apt --help
```

That will show the wrapper usage and available options.

## Design goal

This project is only meant to **rename and imitate package manager commands**.
It is not a replacement for learning real Arch package management.
It simply gives a familiar interface for users who are used to Debian-style commands.

It can be used with:

* `apt`
* `yay`
* `pacman`

## Recommended usage

* Learn `pacman` first
* Use `yay` for AUR packages
* Use this wrapper only as a convenience layer
* Be careful with destructive commands like `purge`

## Notes

* This wrapper is for convenience and learning.
* Some commands may behave differently from real Debian `apt`.
* Always check what a command will do before confirming it.
* Use at your own risk.

---

## Command Reference

> Paste your full command list here later, and I will turn it into a complete polished README section with explanations for every command.
