---
layout: post
title: ' SpringCloud组件用途实现原理及POM坐标 '
comments: true
date: 2019-03-19 17:57:31
updated: 2019-03-19 17:57:31
urlname: SpringCloud-component-usage-principle-and-POM-coordinates
categories: SpringCloud
tags: 
- SpringCloud
---

# Spring Cloud是什么？

>Spring Cloud为开发人员提供了快速构建分布式系统中一些常见模式的工具（例如配置管理，服务发现，断路器，智能路由，微代理，控制总线，一次性令牌，全局锁定，领导选举，分布式会话，集群状态）
>
>---[https://spring.io/projects/spring-cloud](https://spring.io/projects/spring-cloud)

Spring Cloud POM 例子

```xml
<properties>
        <spring-cloud.version>Greenwich.SR1</spring-cloud.version>
</properties>

<dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
</dependencyManagement>

<repositories>
        <repository>
            <id>spring-milestones</id>
            <name>Spring Milestones</name>
            <url>https://repo.spring.io/milestone</url>
        </repository>
</repositories>
```
学习资源： 
- [纯洁的微笑](http://www.ityouknow.com/spring-cloud)
- [程序猿DD](http://blog.didispace.com/categories/Spring-Cloud/)
- [liaokailin的专栏](http://blog.csdn.net/liaokailin/article/category/6212338)
- [周立 Spring Cloud](http://www.itmuch.com/)
- [方志朋 Spring Cloud 专栏](http://blog.csdn.net/column/details/15197.html)
- [许进 跟我学Spring Cloud](http://xujin.org/categories/%E8%B7%9F%E6%88%91%E5%AD%A6Spring-Cloud/)

# Spring Cloud 都有哪些常用组件？

| 组件名  | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| Eureka  | Eureka用于服务的注册与发现。Eureka是Netflix开源的一款提供服务注册和发现的产品，它提供了完整的Service Registry和Service Discovery实现。也是spring Cloud体系中最重要最核心的组件之一。 |
| Ribbon  | Ribbon是Netflix发布的云中间层服务开源项目，其主要功能是提供客户端实现负载均衡算法。 |
| Feign   | Feign支持服务的调用以及均衡负载。Feign是从Netflix中分离出来的轻量级项目，能够在类接口上添加注释，成为一个REST API 客户端。 |
| Config  | Spring Cloud Config为分布式系统中的外部配置提供服务器和客户端支持。 |
| Bus     | Spring Cloud Bus通过轻量消息代理连接各个分布的节点。         |
| Stream  | Spring Cloud Stream 是一个构建消息驱动微服务的框架。         |
| Zuul    | 微服务网关                                                   |
| Hystrix | Hystrix处理服务的熔断防止故障扩散。Hystrix-dashboard 是一款针对Hystrix进行实时监控的工具，通过Hystrix Dashboard我们可以在直观地看到各Hystrix Command的请求响应时间, 请求成功率等数据。 |
| Sleuth  | Spring Cloud Sleuth为服务之间调用提供链路追踪。通过Sleuth可以很清楚的了解到一个服务请求经过了哪些服务，每个服务处理花费了多长。从而让我们可以很方便的理清各微服务间的调用关系。 |

# 使用Spring Cloud/微服务的优劣？

单体（Monolithic）架构主要存在以下问题：

1. 系统间通常以API的形式互相访问，耦合紧密导致难以维护；
2. 各业务领域需要采用相同的技术栈，难以快速应用新技术；
3. 对系统的任何修改都必须整个系统一起重新部署/升级，运维成本高；
4. 在系统负载增加时，难以进行水平扩展；
5. 当系统中一处出现问题，会影响整个系统；

而微服务架构的出现改善了单体架构的不足，微服务的优势也就体现出来了：

1. 每个微服务可以有专门的团队开发，开发者可以自己选择自己开发的微服务所用的技术
2. 微服务单独部署，加快部署速度
3. 独立扩展，快速方便

当然微服务也有不足之处：

1. 部署复杂：微服务是分布式系统，所以会带来固有的复杂性。
2. 进程间相互通讯影响效率：微服务之间相互通信必然要相对于单体架构的时间要长，而且网络通讯必然是有安全隐患的
3. 测试复杂：测试某个服务流程是否正确，需要将所使用的微服务全部打开，复杂性有所提高。
4. 微服务太多端口复杂，内存占用也提高很多

# Spring Cloud VS Dubbo

> Dubbo是阿里巴巴公司开源的一个高性能优秀的服务框架，使得应用可通过高性能的 RPC 实现服务的输出和输入功能，可以和Spring框架无缝集成。来源：百度百科

[请问哪位大神比较过spring cloud和dubbo，各自的优缺点是什么?【知乎】](https://www.zhihu.com/question/45413135)

{% asset_img cloudvsdubbo.jpg SpringCloudVSDubbo %}

# 常用组件Maven坐标

## Eureka 服务注册与发现

```xml
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>

<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

## Ribbon 负载均衡

```xml
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
</dependency>
```

## Feign REST客户端

```xml
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

## Config 配置中心

```xml
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-config-server</artifactId>
</dependency>

<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-config</artifactId>
</dependency>
```

## Bus(AMQL实现) 总线

```xml
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-bus-amqp</artifactId>
</dependency>
```

## Stream 消息

```xml
<!-- or '*-stream-kafka' -->
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-stream-rabbit</artifactId> 
</dependency>
```

## Zuul 网关

```xml
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-netflix-zuul</artifactId>
</dependency>
```

## Hystrix 容灾

```xml
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
</dependency>
```

## Sleuth 链路监测

```xml
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-sleuth</artifactId>
</dependency>
```