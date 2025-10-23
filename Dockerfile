# 使用稳定且软件丰富的 Debian 系统
FROM debian:bullseye-slim

# 更新软件列表，并安装我们需要的工具：
# openssh-client: 我们的核心工具，用于建立反向SSH通道
# netcat-openbsd: 我们的“门卫”，用于应付健康检查
RUN apt-get update && apt-get install -y \
    openssh-client \
    netcat-openbsd \
    --no-install-recommends

# 复制我们的启动脚本
COPY run.sh /run.sh
RUN chmod +x /run.sh

# 声明我们会使用 10000 端口
EXPOSE 10000

# 运行启动脚本
CMD ["/run.sh"]
