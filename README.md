crystal-build
-------------

[![Build Status](https://travis-ci.org/pine613/crystal-build.svg?branch=master)](https://travis-ci.org/pine613/crystal-build)
[![codecov.io](http://codecov.io/github/pine613/crystal-build/coverage.svg?branch=master)](http://codecov.io/github/pine613/crystal-build?branch=master)


crystal-build is an [crenv](https://github.com/pine613/crenv) plugin that provides an crenv install command.

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

### Development

Tests are executed using [Carton](https://github.com/perl-carton/carton):

```
$ carton install
$ carton exec -- prove -r t # all
$ carton exec -- prove t/<dir>/<file>.t
```

### Acknowledgement

- [riywo](https://github.com/riywo)
- [hokaccha](https://github.com/hokaccha)

### Change log

- 1.3.0 - Support FreeBSD
- 1.2.0 - Support installing Crystal from Homebrew bottles
- 1.1.0 - Support [shards](https://github.com/ysbaddaden/shards) auto-install
- 1.0.0 - First release

## License
MIT License
