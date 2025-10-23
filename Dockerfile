# 使用一个非常小巧的 Alpine Linux 系统作为基础
FROM alpine:latest

# 更新系统软件列表并安装我们需要的两个软件：openssh 和 tmate
# openssh 提供了ssh客户端功能
# tmate 是我们用来创建SSH连接的核心工具
RUN apk update && apk add --no-cache openssh tmate

# 创建一个脚本文件，用来启动 tmate
COPY run.sh /run.sh
# 给予这个脚本文件可执行的权限
RUN chmod +x /run.sh

# 设置容器启动时要执行的命令
CMD ["/run.sh"]
