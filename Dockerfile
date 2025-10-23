# 使用稳定且软件丰富的 Debian 系统
FROM debian:bullseye-slim

# 更新软件列表，并一次性安装所有需要的工具：
# tmate: 我们的主角，用于创建SSH通道
# openssh-client: 用于生成SSH密钥
# netcat-openbsd: 我们的“门卫”，用于应付健康检查
RUN apt-get update && apt-get install -y \
    tmate \
    openssh-client \
    netcat-openbsd \
    --no-install-recommends

# 复制我们的启动脚本
COPY run.sh /run.sh
RUN chmod +x /run.sh

# 声明我们会使用 10000 端口，这是给 Render 健康检查看的
EXPOSE 10000

# 运行启动脚本
CMD ["/run.sh"]
