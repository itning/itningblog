---
layout: post
title: ' 单点登录SSO和集中式认证服务CAS和开放授权OAuth的简要解释 '
comments: true
date: 2019-04-08 14:15:42
updated: 2019-04-08 14:15:42
urlname: A-brief-explanation-of-single-sign-on-SSO-and-centralized-authentication-service-CAS-and-open-authorized-OAuth
categories: Essays
tags:
- SSO
- CAS
- OAuth
- OAuth2
---
# 什么是SSO？

> 维基百科中对[SSO](https://zh.wikipedia.org/wiki/%E5%96%AE%E4%B8%80%E7%99%BB%E5%85%A5)的解释：
>
> **单点登录**（英语：Single sign-on，缩写为 SSO），又译为**单一签入**，一种对于许多相互关连，但是又是各自独立的软件系统，提供[访问控制](https://zh.wikipedia.org/wiki/%E5%AD%98%E5%8F%96%E6%8E%A7%E5%88%B6)的属性。当拥有这项属性时，当用户[登录](https://zh.wikipedia.org/wiki/%E7%99%BB%E5%85%A5)时，就可以获取所有系统的访问权限，不用对每个单一系统都逐一登录。这项功能通常是以[轻型目录访问协议](https://zh.wikipedia.org/wiki/%E8%BD%BB%E5%9E%8B%E7%9B%AE%E5%BD%95%E8%AE%BF%E9%97%AE%E5%8D%8F%E8%AE%AE)（LDAP）来实现，在服务器上会将用户信息存储到LDAP数据库中。相同的，**单一退出**（single sign-off）就是指，只需要单一的退出动作，就可以结束对于多个系统的访问权限。

简单来说，单点登陆就是用户登陆过一个系统后访问其它需要认证的系统，不用用户再重复输入用户名和密码。

单点登陆包含 单点登陆 单点登出

可以看下单点登陆图解：

{% asset_img dandiandenglu.png 单点登陆图解 %}

[单点登录原理与简单实现](https://www.cnblogs.com/ywlaker/p/6113927.html)

那么CAS又是什么呢？

# 什么是CAS？

> **集中式认证服务**（英语：Central Authentication Service，缩写**CAS**）是一种针对[万维网](https://zh.wikipedia.org/wiki/%E4%B8%87%E7%BB%B4%E7%BD%91)的[单点登录](https://zh.wikipedia.org/wiki/%E5%8D%95%E7%82%B9%E7%99%BB%E5%BD%95)协议。它的目的是允许一个用户访问多个应用程序，而只需提供一次凭证（如用户名和密码）。它还允许web应用程序在没有获得用户的安全凭据（如密码）的情况下对用户进行身份验证。“CAS”也指实现了该协议的软件包。

可以说CAS实现了SSO。

其中CAS定义了一些规范：

|       定义       |                             描述                             |
| :--------------: | :----------------------------------------------------------: |
|      Client      |                  终端用户或者是 WEB 浏览器                   |
|      Server      |                   统一认证服务所在的服务器                   |
|     Service      |            终端用户或者 WEB 浏览器试图访问的应用             |
|      Proxy       | 作为代理的服务，用户通过该服务（代理）访问Back-end service（后端应用） |
| Back-end service | 用户通过代理访问的应用，这个应用就被称为后端服务（Back-end service） 。它也被称作“target service”目标服务 |
|       TGT        | Ticket Grangting Ticket 。TGT是CAS为用户签发的登录票据，拥有了TGT，用户就可以证明自己在CAS成功登录过。TGT封装了Cookie值以及此Cookie值对应的用户信息。当HTTP请求到来时，CAS以此Cookie值为key查询缓存中有无TGT ，如果有的话，则相信用户已登录过。 |
|        ST        | Service Ticket 。ST是CAS为用户签发的访问某一service的票据。用户访问service时，service发现用户没有ST，则要求用户去CAS获取ST。用户向CAS发出获取ST的请求，CAS发现用户有TGT，则签发一个ST，返回给用户。用户拿着ST去访问service，service拿ST去CAS验证，验证通过后，允许用户 |
|       TGC        | Ticket Grangting Cookies 保持TGT信息的cookies，保存在使用浏览器的客户端 |
|       PGT        | Proxy TicketGranting Ticket。Proxy Service认证成功后，CAS会生成PGT，并将值回传给Proxy Service 。Proxy Service拿到PGT后，就可以为Target Service做代理，为其申请PT。 |
|      PGTIOU      | Proxy TicketGranting Ticket IOU。PGTIOU是CAS协议中定义的一种附加票据，它增强了传输、获取PGT的安全性。 |
|        PT        | Proxy Ticket。PT是用户访问Target Serivce的票据。用户经由Proxy Service去CAS获取到PT后，再访问Target Serivce，Target Serivce去CAS验证PT成功后，才允许用户访问。 |

CAS作为一个规范，规定了一系列需要暴露的服务端:

|        地址         |       描述       |
| :-----------------: | :--------------: |
|       /login        |       登录       |
|       /logout       |       登出       |
|      /validate      |      验证ST      |
|  /serviceValidate   | 验证ST [CAS 2.0] |
|   /proxyValidate    | 验证PT [CAS 2.0] |
| /p3/serviceValidate | ST验证 [CAS 3.0] |
|  /p3/proxyValidate  | PT验证 [CAS 3.0] |

{% asset_img cas.png CAS时序图 %}

CAS标准：<https://apereo.github.io/cas/4.2.x/protocol/CAS-Protocol-Specification.html>

CAS实现：<https://www.apereo.org/projects/cas>

# OAuth OAuth2 又是什么？

> **开放授权**（OAuth）是一个[开放标准](https://zh.wikipedia.org/wiki/%E5%BC%80%E6%94%BE%E6%A0%87%E5%87%86)，允许用户让第三方应用访问该用户在某一网站上存储的私密的资源（如照片，视频，联系人列表），而无需将用户名和[密码](https://zh.wikipedia.org/wiki/%E5%AF%86%E7%A0%81)提供给第三方应用。
>
> OAuth 2.0是OAuth协议的下一版本，但不向下兼容OAuth 1.0。OAuth 2.0关注客户端开发者的简易性，同时为Web应用、桌面应用、手机和智能设备提供专门的认证流程。

```
 +--------+                               +---------------+
 |        |--(A)- Authorization Request ->|   Resource    |
 |        |                               |     Owner     |
 |        |<-(B)-- Authorization Grant ---|               |
 |        |                               +---------------+
 |        |
 |        |                               +---------------+
 |        |--(C)-- Authorization Grant -->| Authorization |
 | Client |                               |     Server    |
 |        |<-(D)----- Access Token -------|               |
 |        |                               +---------------+
 |        |
 |        |                               +---------------+
 |        |--(E)----- Access Token ------>|    Resource   |
 |        |                               |     Server    |
 |        |<-(F)--- Protected Resource ---|               |
 +--------+                               +---------------+
```

- （A）用户打开客户端以后，客户端请求资源所有者（用户）的授权。
- （B）用户同意给予客户端授权。
- （C）客户端使用上一步获得的授权，向认证服务器申请访问令牌。
- （D）认证服务器对客户端进行认证以后，确认无误，同意发放访问令牌。
- （E）客户端使用访问令牌，向资源服务器申请获取资源。
- （F）资源服务器确认令牌无误，同意向客户端开放资源。

客户端必须得到用户的授权（authorization grant），才能获得令牌（access token）。OAuth 2.0定义了四种授权方式。

- 授权码模式（authorization code）
- 简化模式（implicit）
- 密码模式（resource owner password credentials）
- 客户端模式（client credentials）

使用GitHub的OAuth2的一个例子:

访问<https://github.com/settings/applications/new>申请 Client ID 和 Client Secret

[GitHub的OAuth2文档](https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/)

1. 使用浏览器访问

   ``GET https://github.com/login/oauth/authorize``

   请求参数:

   - response_type：表示授权类型，必选项，此处的值固定为"code"
   - client_id：表示客户端的ID，必选项
   - redirect_uri：表示重定向URI，可选项
   - scope：表示申请的权限范围，可选项
   - state：表示客户端的当前状态，可以指定任意值，认证服务器会原封不动地返回这个值。

   例如:``https://github.com/login/oauth/authorize?response_type=code&client_id=f240fa1fb1eb47037def&redirect_uri=http://localhost:8080/&state=suijizifuchuan``

   访问后浏览器会返回一个授权页面:

   {% asset_img diyibu.png 授权页面 %}

   我们授权后浏览器会重定向到如下地址:

   ``http://localhost:8080/?code=d83761f6f1297179075a&state=suijizifuchuan``

   - code：表示授权码，必选项。该码的有效期应该很短，通常设为10分钟，客户端只能使用该码一次，否则会被授权服务器拒绝。该码与客户端ID和重定向URI，是一一对应关系。
   - state：如果客户端的请求中包含这个参数，认证服务器的回应也必须一模一样包含这个参数。

2. 发送POST请求获取令牌

   ``POST https://github.com/login/oauth/access_token``

   请求参数:

   - grant_type：表示使用的授权模式，必选项，此处的值固定为"authorization_code"。
   - code：表示上一步获得的授权码，必选项。
   - redirect_uri：表示重定向URI，必选项，且必须与A步骤中的该参数值保持一致。
   - client_id：表示客户端ID，必选项。

   **注意:GitHub的参数与以上参数有些不同**

   | 参数            | l类型    | 解释                                                 |
   | --------------- | -------- | ---------------------------------------------------- |
   | `client_secret` | `string` | **需要。**您从GitHub收到的GitHub应用程序的客户机密。 |
   | `code`          | `string` | **需要。**您收到的代码作为对第1步的回复。            |
   | `redirect_uri`  | `string` | 应用程序中的URL，用于在授权后发送用户。              |
   | `state`         | `string` | 您在步骤1中提供的不可思议的随机字符串。              |
   | `client_id`     | `string` | **需要。**您从GitHub收到的GitHub应用程序的客户端ID。 |

   {% asset_img dierbu.png 令牌 %}

   其中:

   ``1a4800d2903cab1e18b65d6489aadf407c06776e``就是你获取到的令牌

3. 使用访问令牌访问API

   ``GET https://api.github.com/user?access_token=...``

[OAuth 2.0 认证的原理与实践](https://waylau.com/principle-and-practice-of-oauth2/)

[理解OAuth 2.0](http://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html)