#!/bin/bash
set -x  # 启用调试模式，显示执行的每个命令

echo "=== Starting installation script ==="
echo "Current working directory: $(pwd)"
echo "Current PATH: $PATH"
echo "Current user: $(whoami)"
echo "System information: $(uname -a)"

echo "=== Installing Go ==="
echo "Downloading Go..."
curl -L https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz -o go.tar.gz
ls -la go.tar.gz || echo "Failed to download Go"

echo "Extracting Go..."
tar -xzf go.tar.gz || echo "Failed to extract Go"
ls -la go/ || echo "Go directory not found"

echo "Setting up Go environment..."
mkdir -p /tmp/go-path
mv go /tmp/ || echo "Failed to move Go to /tmp"
ls -la /tmp/go || echo "Go not found in /tmp"

# 导出并验证环境变量
export PATH=$PATH:/tmp/go/bin
export GOPATH=/tmp/go-path
echo "Updated PATH: $PATH"
echo "GOPATH: $GOPATH"

# 验证 Go 安装
echo "Verifying Go installation..."
which go || echo "Go not found in PATH"
go version || echo "Go command failed"

echo "=== Installing Hugo ==="
echo "Downloading Hugo..."
curl -L https://github.com/gohugoio/hugo/releases/download/v0.136.1/hugo_0.136.1_linux-amd64.tar.gz -o hugo.tar.gz
ls -la hugo.tar.gz || echo "Failed to download Hugo"

echo "Extracting and installing Hugo..."
tar -xzf hugo.tar.gz || echo "Failed to extract Hugo"
ls -la hugo || echo "Hugo binary not found"

echo "Moving Hugo to /usr/local/bin..."
mv hugo /usr/local/bin/ || echo "Failed to move Hugo to /usr/local/bin"
ls -la /usr/local/bin/hugo || echo "Hugo not found in /usr/local/bin"

# 验证 Hugo 安装
echo "Verifying Hugo installation..."
which hugo || echo "Hugo not found in PATH"
hugo version || echo "Hugo command failed"

echo "=== Setting up environment variables ==="
# 创建环境变量脚本
echo "Creating environment variable script..."
echo 'export PATH=$PATH:/tmp/go/bin' > /tmp/env.sh
echo 'export GOPATH=/tmp/go-path' >> /tmp/env.sh
cat /tmp/env.sh

echo "=== Installation complete ==="
echo "Final PATH: $PATH"
echo "Final GOPATH: $GOPATH"
echo "Directory contents of /usr/local/bin:"
ls -la /usr/local/bin/
echo "Directory contents of /tmp/go/bin:"
ls -la /tmp/go/bin/

# 检查模块下载权限
echo "=== Checking permissions ==="
echo "Temporary directory permissions:"
ls -la /tmp/
echo "Go path permissions:"
ls -la /tmp/go-path/

# 验证 Hugo 模块功能
echo "=== Testing Hugo modules ==="
cd site || echo "Failed to change to site directory"
hugo mod init || echo "Hugo mod init failed"
hugo mod verify || echo "Hugo mod verify failed"

set +x  # 关闭调试模式