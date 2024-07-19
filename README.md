# C program devkit

Only for MacOS

```
├── Clibfile # C package config
├── README.md
├── bin
│   ├── clib # C package manager

├── dist
│   └── <target>
└── src
    ├── assets # assets
    ├── libs # local libs
    └── main.c # entry
```

# Deps

* Ruby3
  * Bundler  `gem install bundler`

# Clib

Small Package Manager

```
Usage: clib [options]
    -r, --run=COMMAND                Run Command
```

## install

install c libs

`bin/clib -r install`

## uninstall

uninstall c libs

`bin/clib -r uninstall`

## build

build program

`bin/clib -r build`

## run

build then run program

`bin/clib -r run`

or

`bin/clib -r preview`


# Clibfile

Introduce clibfile

```
name "game"  # app name

version "0.1.0"
repo ""
entry "src/main.c" # entry
output "dist/game" # option. use name as default output name


dependencies do
  lib "raylib" # dep libs
end

# custom command
# can run by `bin/clib -r <command_name>`
command "clean" do
  `rm -rf dist/#{@app_name}`
  puts "delete: #{@app_name}"
end

command "test" do
  puts "test"
end
```
