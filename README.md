# make-everythings
:muscle: Preconfigured .mk files to improve your productivity

## Installation

### With submodules

```bash
git submodule add git@github.com:gponsinet/make-everythings .mk
```

## Usage

* First you should add a Makefile in root directory

Exemple: `echo include .mk/brew.mk >> Makefile`

* Then, you can use `make [command]`


### Brew

* `brew/setup`: setup brew on your machine
* `brew/install/[dep]`: install brew dependency
* `brew/uninstall/[dep]`: uninstall brew dependency
* `brew/trash`: uninstall brew

### Yarn

* `yarn/setup`: setup yarn on your current directory
* `yarn/add/[dep]`: install yarn dependency
* `yarn/remove/[dep]`: remove dependency
* `yarn/trash`: remove yarn files and uninstall it
* `yarn/workspace/add/[dir]`: add directory as package
* `yarn/workspace/remove/[dir]`: remove directory as package


### React Native

* `react-native/setup`: setup react-native build tools
* `react-native/update`: update react-native
* `react-native/trash`: remove react-native
* `react-native/debug/[platform]`: debug react-native
* `react-native/release/[platform]`: create release build
