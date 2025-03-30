#!/bin/bash
# 安装Go
curl -L https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz | tar -xz
mkdir -p /tmp/go-path
mv go /tmp/
export PATH=$PATH:/tmp/go/bin
export GOPATH=/tmp/go-path

# 安装Hugo (使用标准版本，不需要Go依赖)
curl -L https://github.com/gohugoio/hugo/releases/download/v0.136.1/hugo_0.136.1_linux-amd64.tar.gz | tar -xz
mv hugo /usr/local/bin/

# 创建一个脚本来设置环境变量供后续构建使用
echo 'export PATH=$PATH:/tmp/go/bin' > /tmp/env.sh
echo 'export GOPATH=/tmp/go-path' >> /tmp/env.sh