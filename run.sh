#!/bin/sh

# --- “门卫”程序：应付健康检查 (保持不变) ---
echo "正在后台启动健康检查“门卫”..."
while true; do
  { echo -e 'HTTP/1.1 200 OK\r\n'; } | nc -l -p 10000
done &

# --- “主角”程序：tmate SSH通道 ---
# 生成密钥
ssh-keygen -t ed25519 -f /tmp/ssh_key -N ""

# 无限循环
while true; do
  echo "正在启动新的 tmate 会话... 请在下方日志中查找 SSH 连接地址。"

  # 使用最稳定、最明确的命令启动 tmate
  # -S: 明确指定会话文件路径，增加稳定性
  # -F: 在前台运行
  # -k: 指定我们生成的密钥
  tmate -S /tmp/tmate.sock -F -k /tmp/ssh_key

  echo "tmate 会话已断开，将在5秒后重启..."
  sleep 5
done
