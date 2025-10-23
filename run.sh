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
  # --- 新增的诊断步骤 ---
  echo "正在测试到 tmate.io 服务器的网络连接..."
  # 我们用 nc 命令尝试连接 tmate 的 SSH 端口 (22)，超时设为10秒
  # -z 选项表示不发送任何数据，只测试连接
  nc -z -v -w 10 ssh.tmate.io 22

  # 检查上一条命令的返回结果
  if [ $? -eq 0 ]; then
    echo "网络连接测试成功！准备启动 tmate..."
  else
    echo "网络连接测试失败！无法连接到 ssh.tmate.io。将在15秒后重试..."
    sleep 15
    continue # 跳过本次循环，直接进入下一次重试
  fi

  echo "正在启动新的 tmate 会话... 请在下方日志中查找 SSH 连接地址。"
  # 使用最简单、最核心的命令启动 tmate
  tmate -F -k /tmp/ssh_key

  echo "tmate 会话已断开，将在5秒后重启..."
  sleep 5
done
