# dotmk
:muscle: Fasten your development setup to focus on release

## Warning

This code is currently not stable, please creates issues and tell me what you want to improve, or make pull request directly, this is what this repository is looking for, thank you :heart:

## Installation

### In your home directory

```bash
git clone git@github.com:dotmk/dotmk ~/.mk
```

### With subtree

```bash
git remote add dotmk https://github.com/dotmk/dotmk
git subtree add --squash -P .mk dotmk master
```

### With submodules

```bash
git submodule add git@github.com:dotmk/dotmk .mk
```

## Usage

* First you should add a Makefile in root directory

Example: `echo include .mk/brew.mk >> Makefile`

* Then, you can use `make [command]`

### Install

`make install` or `make install.$PACKAGE_NAME` permit you to install every included package or a specific one.

### Trash

`make trash` or `make trash.$PACKAGE_NAME` permit you to uninstall and clean all included package or a specific one.
