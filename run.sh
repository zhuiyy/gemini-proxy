#!/bin/sh

# --- “门卫”程序：应付健康检查 (保持不变) ---
echo "正在后台启动健康检查“门卫”..."
while true; do
  { echo -e 'HTTP/1.1 200 OK\r\n'; } | nc -l -p 10000
done &

# --- “主角”程序：使用 SSH 连接 localhost.run ---
# 首先，我们需要接受 localhost.run 服务器的公钥，避免交互式提示
# 我们先尝试获取一次，并将其加入到 known_hosts 文件中
echo "正在添加 localhost.run 的服务器指纹..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan localhost.run >> ~/.ssh/known_hosts

# 无限循环，确保连接断开后会自动重连
while true; do
  echo "正在尝试连接 localhost.run 来建立反向SSH通道..."
  echo "请在下方日志中查找 'tunneled with tls termination' 开头的连接地址。"

  # 使用 ssh 命令建立反向隧道
  # -R 80:localhost:8888 是一个占位隧道，我们并不实际使用它，
  # 它的唯一目的是保持SSH连接，localhost.run 会给我们一个随机的SSH地址用于真正的隧道
  # -o "StrictHostKeyChecking=no" 和 -o "UserKnownHostsFile=/dev/null" 是为了避免密钥检查问题
  # -o "ServerAliveInterval=60" 会每60秒发一个心跳包，防止连接被断开
  ssh -o "ServerAliveInterval=60" -o "ExitOnForwardFailure=yes" -R 80:localhost:8888 ssh.localhost.run

  echo "SSH 连接已断开，将在10秒后重启..."
  sleep 10
done
