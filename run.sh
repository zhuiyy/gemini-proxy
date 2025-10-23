#!/bin/bash
set -e

echo "--- Starting Render SSH Relay ---"

# 1. 启动欺骗健康检查的后台进程 (监听 10000 端口，永远返回 200 OK)
# 使用 while 循环确保如果 nc 意外退出可以重启
while true; do
    { echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nok"; } | nc -l -p 10000 -q 1 >/dev/null 2>&1
done &
echo "[HealthCheck] Fake HTTP server running on port 10000"

# 2. 以分离模式(detached)启动 tmate 会话
# 这是之前失败的关键：不能在前台直接运行，必须让它在后台建立连接
rm -f /tmp/tmate.sock
tmate -S /tmp/tmate.sock new-session -d
echo "[Tmate] Session started in detached mode, waiting for connection..."

# 3. 等待 tmate 建立连接并获取 SSH 地址
# 它需要几秒钟来与 tmate 服务器握手
tmate -S /tmp/tmate.sock wait tmate-ready
SSH_CMD=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')

echo "----------------------------------------------------------------"
echo "SUCCESS! Your SSH relay is ready."
echo ""
echo "SSH Connect Command (Copy this to your local terminal):"
echo "==>  $SSH_CMD"
echo ""
echo "To use as a SOCKS5 proxy (e.g., for Gemini API):"
echo "==>  ssh -D 1080 -N $(echo $SSH_CMD | cut -d ' ' -f 2-)"
echo "     (Then set your app to use SOCKS5 proxy at 127.0.0.1:1080)"
echo "----------------------------------------------------------------"

# 4. 阻止容器退出
# 只要这个命令在运行，Render 就认为服务正常
tail -f /dev/null
