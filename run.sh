#!/bin/sh

# 生成一个新的、不需要密码的ssh key，tmate会用它来建立连接
# -t ed25519 是一种现代且安全的密钥类型
# -f /tmp/ssh_key 是密钥存放的临时路径
# -N "" 表示密钥不需要密码
ssh-keygen -t ed25519 -f /tmp/ssh_key -N ""

echo "启动 tmate 会话..."
echo "请在 Render 日志中查找 'ssh' 开头的连接信息。"

# 无限循环，确保tmate断开后会自动重启
while true; do
  # 启动 tmate
  # -S /tmp/tmate.sock 指定一个临时的通信文件
  # -f /etc/tmate/tmate.conf 指定配置文件（这里我们用默认的）
  # -k /tmp/ssh_key 指定我们刚生成的密钥
  # new-session 创建一个新的会话
  # -d 表示在后台运行并等待客户端连接
  # "wait tmate-ready" 是一个命令，它会一直等到ssh连接信息生成完毕
  tmate -S /tmp/tmate.sock -k /tmp/ssh_key new-session -d "wait tmate-ready"

  # 从 tmate 获取 ssh 连接信息并打印出来，这样我们就能在Render日志里看到
  tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'
  
  # 等待 tmate 进程结束
  tmate -S /tmp/tmate.sock wait tmate-closed
  echo "tmate 会话已关闭，将在5秒后重启..."
  sleep 5
done
