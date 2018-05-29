---
layout: post
title: ' Zookeeper 结构 命令行操作 '
comments: true
date: 2018-05-29 19:08:41
updated: 2018-05-29 19:08:41
urlname: Zookeeper-structure-Command-line-operations
categories: Zookeeper
tags:
- Zookeeper
---
## Zookeeper 特性
1、Zookeeper：一个leader，多个follower组成的集群
2、全局数据一致：每个server保存一份相同的数据副本，client无论连接到哪个server，数据都是一致的
3、分布式读写，更新请求转发，由leader实施
4、更新请求顺序进行，来自同一个client的更新请求按其发送顺序依次执行
5、数据更新原子性，一次数据更新要么成功，要么失败
6、实时性，在一定时间范围内，client能读到最新数据

## 节点类型

{% asset_img b.png d %}

1、Znode有两种类型：
短暂（ephemeral）（断开连接自己删除）
持久（persistent）（断开连接不删除）
2、Znode有四种形式的目录节点（默认是persistent ）
PERSISTENT
PERSISTENT_SEQUENTIAL（持久序列/test0000000019 ）
EPHEMERAL
EPHEMERAL_SEQUENTIAL
3、创建znode时设置顺序标识，znode名称后会附加一个值，顺序号是一个单调递增的计数器，由父节点维护
4、在分布式系统中，顺序号可以被用于为所有的事件进行全局排序，这样客户端可以通过顺序号推断事件的顺序

## 命令行工具

```
 ./zkCli.sh –server <ip>
```
{% asset_img a.png d %}
