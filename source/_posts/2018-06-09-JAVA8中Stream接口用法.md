---
layout: post
title: ' JAVA8中Stream接口用法 '
comments: true
date: 2018-06-09 00:36:46
updated: 2018-06-09 00:36:46
urlname: JAVA8-stream-interface-usage
categories: J2SE
tags:
- Stream
- Lambda
- JAVA
- J2SE
---

JAVA8 中所有Stream接口

{% asset_img a.png a %}

##count

返回Stream中元素的数量

```java
List list = new ArrayList();
list.add("aa");
list.add(1);
long count = list.stream().count();
//输出 2
System.out.println(count);
```

## filter&forEach

filter : 返回匹配的元素

forEach:为每个元素执行操作

```java
List<Integer> list = new ArrayList();
list.add(2);
list.add(1);
list.add(3);
long count = list.stream().filter(s -> s > 2).count();
//输出1
System.out.println(count);
//输出3
list.stream().filter(s -> s > 2).forEach(s -> System.out.println(s));
```

## anyMatch&allMatch

anyMatch: 此流中有一个元素匹配就返回true

allMatch : 此流中所有元素都匹配返回true

```
List<Integer> list = new ArrayList<>();
list.add(2);
list.add(1);
list.add(3);
boolean anyMatch = list.stream().anyMatch(s -> s > 2);
//输出true
System.out.println(anyMatch);
boolean allMatch = list.stream().allMatch(s -> s > 2);
//输出false
System.out.println(allMatch);
```
## map

给定流处理并返回值

```java
List<Integer> list = new ArrayList<>();
list.add(2);
list.add(1);
list.add(3);
list.stream().map(s -> s += s).forEach(System.out::println);
```
