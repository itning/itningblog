---
layout: post
title: ' Hibernate注解 '
comments: true
date: 2018-06-19 20:57:34
updated: 2018-06-19 20:57:34
urlname: Hibernate-annotation
categories: Hibernate
tags:
- Hibernate
- 注解
---

# 类级别

## @Entity

```java
/**
*（可选）实体名称。
*实体类的名称。 此名称是用来指
*查询中的实体。 该名称不能是保留字面值
*在Java持久性查询语言中。
*/
String name() default "";
```

## @Table

```java
//表名 优先于@Entity(name="")
String name() default "";

String catalog() default "";

String schema() default "";
//表的唯一约束
UniqueConstraint[] uniqueConstraints() default { };
//表的索引
Index[] indexes() default {};
```

## @Embeddable

```mysql
/**
嵌入类
@Embeddable
public class Info implements Serializable {
    /**
     * 家庭地址
     */
    private String address;
    /**
     * 电话
     */
    private int tel;
 }

@Entity(name = "t_user")
public class User implements Serializable {
    /**
     * Id
     */
    @Id
    private String id;
    /**
     * 用户名
     */
    @Column
    private String username;
    /**
     * 密码
     */
    private String password;
    /**
     * 其他信息
     */
    private Info info;
**/

create table t_user (
    id varchar(255) not null, 
    address varchar(255), 
    tel integer not null, 
    password varchar(255), 
    username varchar(255), 
    primary key (id)
) engine=MyISAM
```



# 方法/属性级别

## @Id

```java
//表示主键
```



## @Colum

```java
//字段名,默认属性名
String name() default "";
//唯一
boolean unique() default false;
//该字段是否允许空
boolean nullable() default true;
//执行insert语句时,该字段是否出现在insert语句中
boolean insertable() default true;
//更新(update)的时候是否更新该字段
boolean updatable() default true;
/*
当使用该属性 
@Column(name = "Email",columnDefinition="varchar(128) not null")
    private String email;
SQL语句为:
 `Email` varchar(128) NOT NULL
 ----------------
 @Column(name = "Remark",columnDefinition="text")
    private String remark;
SQL语句:
 `Remark` text
*/
String columnDefinition() default "";
//（可选）包含该列的表的名称。
String table() default "";
//列长度 适用于string
int length() default 255;
//precision属性和scale属性表示精度，当字段类型为double时，precision表示数值的总长度，scale表示小数点所占的位数。
int precision() default 0;
int scale() default 0;
```



## @GeneratedValue

```java
//表示主键生成策略
//public enum GenerationType{    
//    TABLE,    使用指定表来决定主键取值 结合@TableGenerator使用
//    SEQUENCE,    使用序列来决定主键取值
//    IDENTITY,    根据数据库的Identity字段生成
//    AUTO   根据底层数据库自动选择(mysql 默认自动增长(int))
//}  
GenerationType strategy() default AUTO;
//表示主键生成器的名称
//@GeneratedValue(generator="aaa")
//@GenericGenerator(name = "aaa",strategy = "assigned")  //手工赋值
String generator() default "";
```



## @GenericGenerator

```java
/**
hibernate提供多种主键生成策略，有点是类似于JPA，有的是hibernate特有： 
native: 对于 oracle 采用 Sequence 方式，对于MySQL 和 SQL Server 采用identity（自增主键生成机制），native就是将主键的生成工作交由数据库完成，hibernate不管（很常用）。 
uuid: 采用128位的uuid算法生成主键，uuid被编码为一个32位16进制数字的字符串。占用空间大（字符串类型）。 
hilo: 使用hilo生成策略，要在数据库中建立一张额外的表，默认表名为hibernate_unique_key,默认字段为integer类型，名称是next_hi（比较少用）。 
assigned: 在插入数据的时候主键由程序处理（很常用），这是 <generator>元素没有指定时的默认生成策略。等同于JPA中的AUTO。 
identity: 使用SQL Server 和 MySQL 的自增字段，这个方法不能放到 Oracle 中，Oracle 不支持自增字段，要设定sequence（MySQL 和 SQL Server 中很常用）。 
          等同于JPA中的INDENTITY。 
select: 使用触发器生成主键（主要用于早期的数据库主键生成机制，少用）。 
sequence: 调用底层数据库的序列来生成主键，要设定序列名，不然hibernate无法找到。 
seqhilo: 通过hilo算法实现，但是主键历史保存在Sequence中，适用于支持 Sequence 的数据库，如 Oracle（比较少用） 
increment: 插入数据的时候hibernate会给主键添加一个自增的主键，但是一个hibernate实例就维护一个计数器，所以在多个实例运行的时候不能使用这个方法。 
foreign: 使用另外一个相关联的对象的主键。通常和<one-to-one>联合起来使用。 
guid: 采用数据库底层的guid算法机制，对应MYSQL的uuid()函数，SQL Server的newid()函数，ORACLE的rawtohex(sys_guid())函数等。 
uuid.hex: 看uuid，建议用uuid替换。 
**/
@GeneratedValue(generator = "paymentableGenerator") 
@GenericGenerator(name = "paymentableGenerator", strategy = "uuid")
private String id;
```



## @Embedded

```java
//表示该属性的类是嵌入类,必须结合@Embeddable注解
```



## @EmbeddedId

```java
//使用嵌入式主键类实现复合主键
//必须实现 java.io.Serializable;
//必须覆盖 equals hashCode方法
//复合主键类上结合@Embeddable类注解
```



## @Transient

```java
//表示该属性不需要映射为一个字段
```



## @OneToOne

```java
//属性表示默认关联的实体类型。如果集合类中指定了具体类型了，不需要使用targetEntity.否则要指定
Class targetEntity() default void.class;
//级联策略
CascadeType[] cascade() default {};
//加载策略:延迟加载 立即加载
FetchType fetch() default EAGER;
/**
*（可选）关联是否可选。 如果设置
*为false，则必须始终存在非空关系。
*/
boolean optional() default true;
//用于标记当实体之间是双向 控制权力交给主控方 在被控方加这个属性
String mappedBy() default "";
/**
理解CascadeType.REMOVE和orphanRemoval = true之间差异的简单方法。

对于orphanRemoval：如果您调用setOrders（null），相关的Order实体将自动在数据库中被删除。

删除级联：如果您调用setOrders（null），相关的Order实体将不会在数据库中自动删除。
**/
boolean orphanRemoval() default false;
```



## @JoinColumn

```java
//外键名,生成字段的时候用这个名字
String name() default "";
//对应的关联字段名称,默认对面的主键
String referencedColumnName() default "";
//是否唯一
boolean unique() default false;
boolean nullable() default true;
boolean insertable() default true;
boolean updatable() default true;
String columnDefinition() default "";
String table() default "";
ForeignKey foreignKey() default @ForeignKey();
```



## @JoinTable

```java
//多对多
//中间表 表名
String name() default "";
//控制字段名
JoinColumn[] joinColumns() default {};
//反转控制字段名
JoinColumn[] inverseJoinColumns() default {};
```



## @OneToMany

```java
/**
     * 订单  会向order表自动添加字段:uid
     * alter table t_order add constraint FKkymvvaj9rps3st3bkniqi0oci foreign key (uid)              * references t_user (id)
     */
    @OneToMany(cascade = {CascadeType.MERGE, CascadeType.REFRESH})
    @JoinColumn(name = "uid")
    private List<Order> orderList;
```



## @ManyToMany

```java
//用于标记当实体之间是双向 控制权力交给主控方 在被控方加这个属性
String mappedBy() default "";
```

