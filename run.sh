#!/bin/sh

# 生成一个新的、不需要密码的ssh key
ssh-keygen -t ed25519 -f /tmp/ssh_key -N ""

# 无限循环，确保tmate断开后会自动重启
while true; do
  echo "启动新的 tmate 会话... 请在下方日志中查找 SSH 连接信息。"
  
  # 使用 -F 参数让 tmate 在前台运行
  # 它会自动打印所有连接信息到日志，然后保持运行等待连接
  tmate -F -k /tmp/ssh_key -S /tmp/tmate.sock

  echo "tmate 会话已断开，将在5秒后重启..."
  sleep 5
done
