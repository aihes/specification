#!/bin/bash
curl -L https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz | tar -C /tmp -xz
export PATH=$PATH:/tmp/go/bin
curl -L https://github.com/gohugoio/hugo/releases/download/v0.136.1/hugo_extended_0.136.1_linux-amd64.tar.gz | tar -xz
mv hugo /usr/local/bin/