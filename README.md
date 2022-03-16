# Builder

Create rootfs for docker

[![](https://images.microbadger.com/badges/version/imega/base-builder.svg)](https://microbadger.com/images/imega/base-builder "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/imega/base-builder.svg)](http://microbadger.com/images/imega/base-builder "Get your own image badge on microbadger.com") [![CircleCI](https://circleci.com/gh/imega-docker/base-builder.svg?style=svg)](https://circleci.com/gh/imega-docker/base-builder) [![Build Status](https://travis-ci.org/imega-docker/base-builder.svg?branch=master)](https://travis-ci.org/imega-docker/base-builder)

## Usage

In your new project add folder `runner`. This dir for shell scripts(bash). Put `entrypoint.sh` script in `runner` this script will run first.
Next step. Put in project `Makefile`.

```
# Build rootfs for php

build:
	@docker run --rm \
		-v $(CURDIR)/runner:/runner \
		-v $(CURDIR)/build:/build \
		-v $(CURDIR)/src:/src \
		imega/base-builder \
# this packages installed for your image
		--packages=" \
			git \
			php7@edge-testing \
			" \
# this packages installed for auxiliary tools
		-d="curl"

.PHONY: build
```

-   -p --packages - this packages installed for your image
-   -d --dev-packages - this packages installed for auxiliary tools

## Start build

`make build`

You will receive a rootfs.tar.gz in a folder build.

## Build your image

Put Docker file in project. e.g.

```
FROM scratch

ADD build/rootfs.tar.gz /

ENTRYPOINT ["php"]
```

run `$docker run build -t test-image .`

## Runner scripts

You are allowed to use variables:

-   \$ROOTFS - This directory is the root of the file system.
-   \$SRC - This directory will be mounted in builder.

e.g.

You need to transfer configs in their way. Configs you place in `SRC` directory. Put command in `entrypoint.sh`

```
cp $SRC/daemon.sh $ROOTFS/app/daemon.sh
cp $SRC/rsyncd.conf $ROOTFS/etc/rsyncd.conf
```

## Packages

All packages can be found at http://pkgs.alpinelinux.org/packages. Specifying only the package name it will be taken from the main repository.
After adding a prefix to the package you will be able to determine the Eje repository.

The available prefixes is

-   `stable-main`
-   `stable-community`
-   `edge-main`
-   `edge-testing`
-   `edge-community`
-   `v313`
-   `v313community`
-   `v312`
-   `v312community`
-   `v311`
-   `v311community`
-   `v310`
-   `v310community`
-   `v39`
-   `v39community`
-   `v38`
-   `v38community`
-   `v37`
-   `v37community`
-   `v36`
-   `v36community`
-   `v35`
-   `v35community`
-   `v34`
-   `v34community`
-   `v33`
-   `v33community`
-   `v32`
-   `v31`
-   `v30`
-   `v30testing`

e.g.: `php7@edge-community` from http://dl-cdn.alpinelinux.org/alpine/edge/community

## The MIT License (MIT)

Copyright © 2020 iMega <info@imega.ru>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
