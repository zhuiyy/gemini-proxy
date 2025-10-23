# 使用一个已知稳定的 Alpine Linux 系统版本
FROM alpine:3.20

# 启用 community 仓库并安装我们需要的软件
# 首先，将 community 仓库地址添加到官方仓库列表中
# 然后，更新软件列表
# 最后，安装 openssh 和 tmate
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.20/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache openssh tmate

# 复制启动脚本到容器中
COPY run.sh /run.sh
# 给予这个脚本文件可执行的权限
RUN chmod +x /run.sh

# 设置容器启动时要执行的命令
CMD ["/run.sh"]
