# fnx

A package manager for the [Fennel](https://fennel-lang.org/) language.

> _**Disclaimer:** It's an early-stage project, and you should expect breaking changes._

- [1-liner Installer](#1-liner-installer)
- [.fnx.fnl File](#fnxfnl-file)
- [Usage](#usage)
- [Installing](#installing)
  - [Options](#installation-options)
  - [Requirements](#requirements)
- [Not a Roadmap](#not-a-roadmap)

## 1-liner Installer

You need to have all [requirements](#requirements) first.

```
curl -fsSL https://raw.githubusercontent.com/gbaptista/fnx/main/get-fnx.sh -o get-fnx.sh && sh get-fnx.sh
```

## `.fnx.fnl` File

The `.fnx.fnl` file is a regular Fennel source code in the root directory of your project that should return a table.

Example:

```fennel
{:name    "my-package"
 :version "0.0.1"

 :dependencies {
   :fspec         {:fennel/local "../fspec"}

   :supernova     {:lua/local "../supernova"}

   :splah         {:fennel/fnx {:path "/home/splah"}}

   :radioactive   {:fennel/fnx {:git/url "https://git.sr.ht/~gbaptista/radioactive"}}
   :fireball      {:fennel/fnx {:git/url "https://github.com/gbaptista/fireball.git"}}

   :moonlight     {:fennel/fnx {:git/sourcehut "~gbaptista/moonlight" :commit "a6c728b"}}

   :meteor        {:fennel/fnx {:git/sourcehut "~gbaptista/meteor" :branch "main"}}

   :jellyfish     {:fennel/fnx {:git/sourcehut "~gbaptista/jellyfish" :tag "v0.0.1"}}

   :purple-rain   {:fennel/fnx {:git/github "gbaptista/purple-rain"}}

   :dkjson        {:lua/rock ">= 2.5"}
   :luafilesystem {:lua/rock ">= 1.8.0"}}}
```

| key | description |
|-----|-------------|
| `:name` | Your package name. |
| `:version` | Your package version. Follows [Semantic Versioning 2.0.0](https://semver.org/) |
| `:dependencies` | Your package dependencies. The example above should be self explanatory. |

## Usage

> _Try the [Hello World](https://github.com/gbaptista/fnx-hello-world) example._

Start by creating a [.fnx.fnl](#fnxfnl-file) file for your project.

| command &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | description |
|---------|-------------|
| `fnx` | It’s an alias for the `fennel` command that wraps it with `fnx` capabilities. Just use it as a replacement for anything that you would do with `fennel`. It accept any of the options available for the `fennel` command. |
| `fnx help` | List the available `fnx` commands. |
| `fnx version` | It returns the `fnx` version. |
| `fnx config` | It returns the current `fnx` configuration. |
| `fnx debug` | It returns `fnx` injections for the current directory. |
| `fnx dep` | Dependencies Manager CLI. It lists the available `fnx dep` commands. Its commands accept `--global` and `--local` for `luarocks`. The default is `--local`. |
| `fnx dep install` | Install the dependencies described in the `.fnx.fnl` file. Use `-f` to force the re-installation of all dependencies. |
| `fnx dep uninstall` | Uninstall the dependencies described in the `.fnx.fnl` file. Use `-f` to skip confirmation. |
| `fnx dep list` | It lists the dependencies described in the `.fnx.fnl` file. |

## Installing

You need to have all [requirements](#requirements) first.

Check the [1-liner Installer](#1-liner-installer) as well.

```sh
git clone git@github.com:gbaptista/fnx.git

cd fnx

luarocks install luafilesystem --local
luarocks install supernova --local

fennel install.fnl
```

### Installation Options

Options for the `fennel install.fnl` command:

| option | description |
|--------|-------------|
| `-s` | Use auto-detect information and skip questions. |
| `-f` | Use auto-detect information and overwrite files without confirmation. |
| `-d` | Install in development mode as a [symbolic link](https://en.wikipedia.org/wiki/Symbolic_link) for the source code. |

### Requirements

- [Lua](https://www.lua.org/download.html)
- [Fennel](https://fennel-lang.org/setup#downloading-fennel)
- [LuaRocks](https://github.com/luarocks/luarocks/wiki/Download)
- [Git](https://git-scm.com/)
- [Unix](https://en.wikipedia.org/wiki/Unix)
  - [`sh`](https://en.wikipedia.org/wiki/Bourne_shell) [`chmod`](https://en.wikipedia.org/wiki/Chmod) `cp` `ln` `mkdir` `rm`

### Not a Roadmap

A list of things that I don't have time to do or that just aren't itching me enough to do something about it, but I would like to do it someday, eventually:

- [ ] git;
- [ ] binaries;
- [ ] `fnx dep add`;
- [ ] `fnx dep remove`;
- [ ] Lock file;
- [ ] Actually use the version numbers for something;
- [ ] Improve performance;
- [ ] Get inspired by [nix](https://nixos.org) to improve the approach;
- [ ] Provide Windows Support.
