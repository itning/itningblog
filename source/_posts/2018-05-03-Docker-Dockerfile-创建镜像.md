---
layout: post
title: ' Docker Dockerfile 创建镜像 '
comments: true
date: 2018-03-31 18:53:17
updated: 2018-03-31 18:53:17
urlname: Docker-Dockerfile-creates-an-image
categories: Docker
tags:
- Docker
- Dockerfile
- 镜像
- 容器
---
> 从刚才的 docker commit 的学习中，我们可以了解到，镜像的定制实际上就是定制每一层所添加的配置、文件。如果我们可以把每一层修改、安装、构建、操作的命令都写入一个脚本，用这个脚本来构建、定制镜像，那么之前提及的无法重复的问题、镜像构建透明性的问题、体积的问题就都会解决。这个脚本就是 Dockerfile。

```
# 第一行必须指定基于的基础镜像
FROM centos

#维护者信息
MAINTAINER itning itning@itning.top

#注意压缩文件要和Dockerfile文件在同一文件夹下
#ADD指令自动将压缩文件解压为目录
ADD jdk-8u152-linux-x64.tar.gz /usr/local
ADD apache-tomcat-9.0.6.tar.gz /usr/local

#设置环境变量
ENV PATH /usr/local/jdk-8u152-linux-x64/bin:$PATH

#运行指令
RUN /usr/local/apache-tomcat-9.0.6/bin/startup.sh
```
{% asset_img a.jpg a %}
{% asset_img b.jpg b %}
{% asset_img c.jpg c %}
{% asset_img d.jpg d %}
