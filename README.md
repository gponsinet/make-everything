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

## Examples

### Yarn workspace + react-native

* Add yarn in your root directory

```
echo 'include .mk/yarn.mk' > Makefile
```

* Create a sub package for your react-native app

```
mkdir app
echo 'include ../.mk/android.mk' > app/Makefile
echo 'include ../.mk/react-native.mk' >> app/Makefile
```

* Run your app in debug mode (WIP)

```
cd app && make debug.react-native.android
```
