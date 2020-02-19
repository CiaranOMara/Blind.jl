# Blind.jl

[![Run tests](https://github.com/CiaranOMara/Blind.jl/workflows/Run%20tests/badge.svg)](https://github.com/CiaranOMara/Blind.jl/actions?query=workflow%3A%22Run+tests%22)

> This project follows the [semver](http://semver.org) pro forma and uses the [git-flow branching model](https://nvie.com/posts/a-successful-git-branching-model/ "original
blog post").

## Overview
This script blinds files by copying and renaming them with a random set of characters. The script also saves a record in `key.csv` for the un-blinding of files.

## Installation
    (v1.1) pkg> add https://github.com/CiaranOMara/Blind.jl

## Usage (Unix like systems)
If the `blind.sh` script is executable and locatable by your `PATH` variable, you can call it by executing `blind.sh` at the prompt.
Otherwise, run the script at the prompt with `sh blind.sh` or `julia blind.sh`.

To make the script executable, grant execution privileges to the bash script.
```console
chmod +x blind.sh
```

To make the script locatable, link the script under a directory like `~/Documents/Scripts`.
```console
ln -s <path to Blind.jl>/blind.sh ~/Documents/Scripts/blind
```

Then include the directory in your `PATH` variable.
```console
echo 'export PATH=$PATH:~/Documents/Scripts' >> ~/.profile
```

> ***Note:*** The example shows how to modify the `PATH` variable in a bash environment.
