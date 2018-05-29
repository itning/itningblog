---
layout: post
title: ' Zookeeper 基础 '
comments: true
date: 2018-05-29 19:07:07
updated: 2018-05-29 19:07:07
urlname: Zookeeper-basics
categories: Zookeeper
tags:
- Zookeeper
---
> Apache ZooKeeper is an effort to develop and maintain an open-source server which enables highly reliable distributed coordination.

Zookeeper 直译过来是 动物园管理员 说白了就是用来管理Hadoop(大象),Hive(蜜蜂) 的分布式协调服务

Zookeeper 提供两种服务
-->管理(存储，读取)用户程序提交的数据；
-->为用户程序提供数据节点监听服务；

------------------------------------------------------
**注意 关闭防火墙 SSH免密登陆**
**Zookeeper适合安装在奇数台机器上**
需要修改配置文件:

```
#  心跳间隔周期(毫秒)
tickTime=2000
# initLimit参数配置初始化连接时, follower和leader之间的最长心跳时间
initLimit=10
# 配置leader和follower之间发送消息, 请求和应答的最大时间长度
syncLimit=5
# 数据目录
dataDir=/home/ning/data/zookeeper
# 客户端连接的端口
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
server.1=node1:2888:3888
server.2=node2:2888:3888
server.3=node3:2888:3888
```

> http://shift-alt-ctrl.iteye.com/blog/1845568

需要在配置文件中设置的目录中新建名为 myid 的文件 内容为当前机器ID

例如 node1 机器在配置文件中ID 为1 则在myid文件中 内容为 1

在 bin 目录中

```
./zkServer.sh start
```
来进行启动
```
./zkServer.sh status
```
来进行查看节点状态

Zookeeper集群的角色：  Leader 和  follower  （Observer）

**zookeeper的选举机制（全新集群paxos）**
以一个简单的例子来说明整个选举的过程.
假设有五台服务器组成的zookeeper集群,它们的id从1-5,同时它们都是最新启动的,也就是没有历史数据,在存放数据量这一点上,都是一样的.假设这些服务器依序启动,来看看会发生什么.
1) 服务器1启动,此时只有它一台服务器启动了,它发出去的报没有任何响应,所以它的选举状态一直是LOOKING状态
2) 服务器2启动,它与最开始启动的服务器1进行通信,互相交换自己的选举结果,由于两者都没有历史数据,所以id值较大的服务器2胜出,但是由于没有达到超过半数以上的服务器都同意选举它(这个例子中的半数以上是3),所以服务器1,2还是继续保持LOOKING状态.
3) 服务器3启动,根据前面的理论分析,服务器3成为服务器1,2,3中的老大,而与上面不同的是,此时有三台服务器选举了它,所以它成为了这次选举的leader.
4) 服务器4启动,根据前面的分析,理论上服务器4应该是服务器1,2,3,4中最大的,但是由于前面已经有半数以上的服务器选举了服务器3,所以它只能接收当小弟的命了.
5) 服务器5启动,同4一样,当小弟.

**非全新集群的选举机制(数据恢复)**
那么，初始化的时候，是按照上述的说明进行选举的，但是当zookeeper运行了一段时间之后，有机器down掉，重新选举时，选举过程就相对复杂了。
需要加入数据id、leader id和逻辑时钟。
数据id：数据新的id就大，数据每次更新都会更新id。
Leader id：就是我们配置的myid中的值，每个机器一个。
逻辑时钟：这个值从0开始递增,每次选举对应一个值,也就是说:  如果在同一次选举中,那么这个值应该是一致的 ;  逻辑时钟值越大,说明这一次选举leader的进程更新.
选举的标准就变成：
		1、逻辑时钟小的选举结果被忽略，重新投票
		2、统一逻辑时钟后，数据id大的胜出
		3、数据id相同的情况下，leader id大的胜出
根据这个规则选出leader。

