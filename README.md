crystal-build
-------------

[![Build Status](https://travis-ci.org/pine613/crystal-build.svg?branch=master)](https://travis-ci.org/pine613/crystal-build)


crystal-build is an [crenv](https://github.com/pine613/crenv) plugin that provides an crenv install command.

Almost all of code come from [node-build](https://github.com/riywo/node-build) and [nodebrew](https://github.com/hokaccha/nodebrew). Thanks a lot!

## Install

```
$ git clone https://github.com/pine613/crystal-build.git ~/.crenv/plugins/crystal-build
```

crystal-build currently supports only download a compiled tarball.

## Usage
### Using `crenv install` with crenv

To install a Crystal version for use with crenv, run `crenv install` with the exact name of the version you want to install. For example,

```
crenv install 0.7.4
```

Crystal versions will be installed into a directory of the same name under `~/.crenv/versions`.

To see a list of all available Crystal versions, run `crenv install --list`.

### Special environment variables

- `CRYSTAL_BUILD_CACHE_PATH`, if set, specifies a directory to use for caching downloaded package files.

## License
Please see LICENSE file.
