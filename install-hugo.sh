#!/bin/bash
set -x  # 启用调试模式，显示执行的每个命令

# 保存当前目录
CURRENT_DIR=$(pwd)

echo "=== Starting installation script ==="
echo "Current working directory: $CURRENT_DIR"
echo "Current PATH: $PATH"
echo "Current user: $(whoami)"
echo "System information: $(uname -a)"

# 设置安装目录为用户目录
INSTALL_DIR="$HOME/.local"
GO_INSTALL_DIR="$INSTALL_DIR/go"
BIN_DIR="$INSTALL_DIR/bin"

# 创建必要的目录
mkdir -p $GO_INSTALL_DIR $BIN_DIR

echo "=== Installing Go ==="
echo "Downloading Go..."
curl -L https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz -o go.tar.gz
ls -la go.tar.gz || echo "Failed to download Go"

echo "Extracting Go..."
tar -xzf go.tar.gz || echo "Failed to extract Go"
ls -la go/ || echo "Go directory not found"

echo "Setting up Go environment..."
cp -r go/* $GO_INSTALL_DIR/ || echo "Failed to copy Go to $GO_INSTALL_DIR"
ls -la $GO_INSTALL_DIR || echo "Go not found in $GO_INSTALL_DIR"

# 设置环境变量
echo "Setting up environment variables..."
export GOROOT=$GO_INSTALL_DIR
export GOPATH=$INSTALL_DIR/gopath
export PATH=$GOROOT/bin:$GOPATH/bin:$BIN_DIR:$PATH
export GO111MODULE=on

# 创建必要的目录
mkdir -p $GOPATH/{bin,src,pkg}

# 验证 Go 安装
echo "Verifying Go installation..."
which go || echo "Go not found in PATH"
go version || echo "Go command failed"
echo "Current PATH: $PATH"
echo "GOROOT: $GOROOT"
echo "GOPATH: $GOPATH"

echo "=== Installing Hugo ==="
echo "Downloading Hugo..."
curl -L https://github.com/gohugoio/hugo/releases/download/v0.136.1/hugo_extended_0.136.1_linux-amd64.tar.gz -o hugo.tar.gz
ls -la hugo.tar.gz || echo "Failed to download Hugo"

echo "Extracting and installing Hugo..."
tar -xzf hugo.tar.gz || echo "Failed to extract Hugo"
ls -la hugo || echo "Hugo binary not found"

echo "Moving Hugo to bin directory..."
mv hugo $BIN_DIR/ || echo "Failed to move Hugo to $BIN_DIR"
chmod +x $BIN_DIR/hugo
ls -la $BIN_DIR/hugo || echo "Hugo not found in $BIN_DIR"

# 验证 Hugo 安装
echo "Verifying Hugo installation..."
which hugo || echo "Hugo not found in PATH"
hugo version || echo "Hugo command failed"

# 验证 Hugo 模块功能
echo "=== Testing Hugo modules ==="
cd site || echo "Failed to change to site directory"

# 检查并处理现有的 go.mod
if [ -f "go.mod" ]; then
    echo "Existing go.mod found:"
    cat go.mod
    # 重新初始化模块
    rm go.mod go.sum
    hugo mod init github.com/modelcontextprotocol/specification || echo "Hugo mod init failed"
else
    echo "Initializing new go.mod"
    hugo mod init github.com/modelcontextprotocol/specification || echo "Hugo mod init failed"
fi

# 清理和下载模块
echo "Cleaning and downloading modules..."
hugo mod clean || echo "Hugo mod clean failed"
hugo mod get -u ./... || echo "Hugo mod get failed"
hugo mod tidy || echo "Hugo mod tidy failed"
hugo mod verify || echo "Hugo mod verify failed"

# 确保模块下载成功
echo "=== Verifying module setup ==="
ls -la go.mod go.sum || echo "Module files not found"
go env || echo "Go environment not set"

# 返回到原始目录
cd $CURRENT_DIR

# 直接执行 Hugo 命令而不是创建构建脚本
echo "=== Building Hugo site ==="
export GOROOT=$GO_INSTALL_DIR
export GOPATH=$INSTALL_DIR/gopath
export PATH=$GOROOT/bin:$GOPATH/bin:$BIN_DIR:$PATH
export GO111MODULE=on
cd site && rm -rf public/* && hugo --minify

echo "=== Installation complete ==="
echo "Final PATH: $PATH"
echo "Final GOROOT: $GOROOT"
echo "Final GOPATH: $GOPATH"
echo "Directory contents of $BIN_DIR:"
ls -la $BIN_DIR/
echo "Directory contents of $GOROOT/bin:"
ls -la $GOROOT/bin/

set +x  # 关闭调试模式