# dotmk
:muscle: Preconfigured .mk files to improve your productivity

## Warning

This code is currently not stable, please creates issues and tell me what you want to improve, this is what this repository is looking for, thank you :heart:

## Installation

### In your home directory

```bash
git clone git@github.com:dotmk/dotmk ~/.mk
```

### With submodules

```bash
git submodule add git@github.com:dotmk/dotmk .mk
```

## Usage

* First you should add a Makefile in root directory

Exemple: `echo include .mk/brew.mk >> Makefile`

* Then, you can use `make [command]`

## Configuration

### SpaceVim

For spacevim, instead of using .SpaceVim.d/init.toml to make your custom config use .SpaceVim.d/custom.toml,
    dotmk will merge everything in .SpaceVim.d/init.toml and override default config with your custom one.
Also, if you use spacevim.mk in project, dotmk will merge your home configuration with the project one.
