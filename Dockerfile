# 使用一个精简的 Debian 系统作为基础
FROM debian:bullseye-slim

# 在容器内部更新软件列表，并安装我们需要的工具
RUN apt-get update && apt-get install -y \
    tmate \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# --- 关键部分 ---
# 在容器内部，创建并切换到 /app 目录。
# 这个目录只存在于容器里，您的本地项目不需要它。
WORKDIR /app

# 将您本地的 run.sh 文件，复制到容器内部的 /app/ 目录中
COPY run.sh /app/run.sh
# 赋予这个脚本执行权限
RUN chmod +x /app/run.sh

# 声明容器会监听 10000 端口（用于Render的健康检查）
EXPOSE 10000

# 当容器启动时，执行位于容器内部 /app/ 目录下的 run.sh 脚本
CMD ["/app/run.sh"]
