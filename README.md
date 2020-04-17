# make-everythings
:muscle: Preconfigured .mk files to improve your productivity

## Installation

### In your home directory

```bash
git clone git@github.com:gponsinet/make-everythings ~/.mk
```

### With submodules

```bash
git submodule add git@github.com:gponsinet/make-everythings .mk
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
make -C app debug.react-native.android
```
