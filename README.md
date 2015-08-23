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
- [makamaka](https://github.com/makamaka)

## License
(The MIT license)

Copyright (c) 2015 Pine Mizune

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Author
Pine Mizune
