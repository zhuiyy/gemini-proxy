#!/bin/sh

# --- “门卫”程序：应付健康检查 ---
# 这部分会在后台启动一个极简的web服务器。
# 它只做一件事：监听10000端口，并对任何连接请求回应"HTTP 200 OK"。
echo "正在后台启动健康检查“门卫”..."
while true; do
  { echo -e 'HTTP/1.1 200 OK\r\n'; } | nc -l -p 10000
done &

# --- “主角”程序：tmate SSH通道 ---
# 这部分和之前一样，是我们的核心功能。
# 它会生成密钥，并循环启动 tmate。
ssh-keygen -t ed25519 -f /tmp/ssh_key -N ""

while true; do
  echo "正在启动新的 tmate 会话... 请在下方日志中查找 SSH 连接地址。"
  
  # -F 参数让 tmate 在前台运行，它会自己打印SSH信息
  tmate -F -k /tmp/ssh_key -S /tmp/tmate.sock

  echo "tmate 会话已断开，将在5秒后重启..."
  sleep 5
done
