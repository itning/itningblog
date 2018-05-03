---
layout: post
title: ' JAVA JMS Java消息服务（Java Message Service） 的实现ActiveMQ '
comments: true
date: 2018-05-03 12:06:31
updated: 2018-05-03 12:06:31
urlname: Java-Message-Service
categories: J2SE
tags:
- ActiveMQ
- Java消息服务
---
> JMS即Java消息服务（Java Message Service）应用程序接口是一个Java平台中关于面向消息中间件（MOM）的API，用于在两个应用程序之间，或分布式系统中发送消息，进行异步通信。Java消息服务是一个与具体平台无关的API，绝大多数MOM提供商都对JMS提供支持。
	JMS是一种与厂商无关的 API，用来访问消息收发系统消息。它类似于JDBC(Java Database Connectivity)：这里，JDBC 是可以用来访问许多不同关系数据库的 API，而 JMS 则提供同样与厂商无关的访问方法，以访问消息收发服务。许多厂商都支持 JMS，包括 IBM 的 MQSeries、BEA的 Weblogic JMS service和 Progress 的 SonicMQ，这只是几个例子。 JMS 使您能够通过消息收发服务（有时称为消息中介程序或路由器）从一个 JMS 客户机向另一个 JMS客户机发送消息。消息是 JMS 中的一种类型对象，由两部分组成：报头和消息主体。报头由路由信息以及有关该消息的元数据组成。消息主体则携带着应用程序的数据或有效负载。根据有效负载的类型来划分，可以将消息分为几种类型，它们分别携带：简单文本(TextMessage)、可序列化的对象 (ObjectMessage)、属性集合 (MapMessage)、字节流 (BytesMessage)、原始值流 (StreamMessage)，还有无有效负载的消息 (Message)。

##Java消息服务应用程序结构支持两种模型
###点对点或队列模型
在点对点或队列模型下，一个生产者向一个特定的队列发布消息，一个消费者从该队列中读取消息。这里，生产者知道消费者的队列，并直接将消息发送到消费者的队列。
{% asset_img a.png 点对点或队列模型 %}
这种模式被概括为：
只有一个消费者将获得消息
生产者不需要在接收者消费该消息期间处于运行状态，接收者也同样不需要在消息发送时处于运行状态。
每一个成功处理的消息都由接收者签收
###发布者/订阅者模型
发布者/订阅者模型支持向一个特定的消息主题发布消息。0或多个订阅者可能对接收来自特定消息主题的消息感兴趣。在这种模型下，发布者和订阅者彼此不知道对方。这种模式好比是匿名公告板。
{% asset_img b.png 发布者/订阅者模型 %}
 这种模式被概括为：
多个消费者可以获得消息
在发布者和订阅者之间存在时间依赖性。发布者需要建立一个订阅（subscription），以便客户能够订阅。订阅者必须保持持续的活动状态以接收消息，除非订阅者建立了持久的订阅。在那种情况下，在订阅者未连接时发布的消息将在订阅者重新连接时重新发布。

##ActiveMQ
###安装,配置,启动

> 官方下载页面: http://activemq.apache.org/download.html

解压后 在conf目录中 activemq.xml 这个XML 文件
将 0.0.0.0 改成 localhost
```
<transportConnectors>
            <!-- DOS protection, limit concurrent connections to 1000 and frame size to 100MB -->
            <transportConnector name="openwire" uri="tcp://localhost:61616?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="amqp" uri="amqp://localhost:5672?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="stomp" uri="stomp://localhost:61613?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="mqtt" uri="mqtt://localhost:1883?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="ws" uri="ws://localhost:61614?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
        </transportConnectors>
```
windows 环境 在 bin 目录中 启动 activemq.bat 这个脚本
 5.10 版本后
```
 .\activemq start
```
 5.9 之前

```
 .\activemq
```

JAVA API : https://github.com/itning/BigData/tree/master/src/main/java/top/itning/activemq
