# 使用一个稳定且小巧的 Debian 系统作为基础
FROM debian:bullseye-slim

# 更新软件列表，并安装 tmate 和 openssh-client
# -y 参数会自动对所有提示回答 "yes"
# openssh-client 包含了我们需要的 ssh-keygen 工具
# --no-install-recommends 可以让最终的镜像更小
RUN apt-get update && apt-get install -y \
    tmate \
    openssh-client \
    --no-install-recommends

# 将启动脚本复制到容器中
COPY run.sh /run.sh
# 给予脚本可执行权限
RUN chmod +x /run.sh

# 设置容器启动时要执行的命令
CMD ["/run.sh"]
