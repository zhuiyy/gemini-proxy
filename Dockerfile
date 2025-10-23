FROM debian:bullseye-slim

# 安装必要的软件包
# tmate: 核心中转工具
# netcat-openbsd: 用于欺骗 Render 健康检查
# curl: 调试用
RUN apt-get update && apt-get install -y \
    tmate \
    netcat-openbsd \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制启动脚本
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Render 要求暴露一个端口（虽然我们用 netcat 欺骗它，但 Dockerfile 里最好声明一下）
EXPOSE 10000

# 启动命令
CMD ["/app/start.sh"]
