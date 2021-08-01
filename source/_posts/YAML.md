---
title: YAML语言教程
date: 2020-07-27 16:45:29
tags:
- SpringBoot
- YAML
categories: 
- Java后端
- 开发工具
---
# Free Talk
在 SpringBoot 我们通常使用( application.yml )来配置全局文件。
**YAML（发音/ˈjæməl/）是一个可读性高，用来表达数据序列化的格式，远比 JSON 格式方便。**
<!--more-->
# YAML语法
## YAML基本语法
+ **使用缩进表示层级关系**
+ **缩进时不允许使用Tab键，只允许使用空格。**
+ 缩进的空格数目不重要，只要相同层级的元素左侧对齐即可
+ 大小写敏感
+ '#'表示注释，从这个字符一直到行尾，都会被解析器忽略。

## YAML支持的三种数据结构
+ 对象：键值对的集合
+ 数组：一组按次序排列的值
+ 字面量：单个的、不可再分的值

# 值的写法
## 字面量(数字、字符串、布尔)
+ k:v ：字面直接来写；
+ 字符串默认不用加上单引号或者双引号；
+ '' ：单引号；会转义特殊字符，特殊字符最终只是一个普通的字符串数据
+ "" ：双引号；不会转义字符串里面的特殊字符；特殊字符会作为本身想表示的意思

> name: "zhangsan \n lisi"：输出；zhangsan 换行 lisi
 name: 'zhangsan \n lisi'：输出；zhangsan \n lisi

## 对象、Map(属性和值)
```YAML
friends:
    lastName: Gemini
    age: 20
```
## 数组(List、Set)
用- 值表示数组中的一个元素
```YAML
pets:
‐ cat
‐ dog
‐ pig
```
行内表示
```YAML
pets: [cat,dog,pig]
```
## 引用
锚点 & 和别名 * ，可以用来引用。
```YAML
- &showell Steve 
- Clark 
- Brian 
- Oren 
- *showell 
```
转为 JavaScript 代码如下:
```JavaScript
[ 'Steve', 'Clark', 'Brian', 'Oren', 'Steve' ]
```
# Demo
```YAML
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/demo?characterEncoding=utf-8&serverTimezone=UTC&useSSL=false
    username: root
    password: root
mybatis:
  mapper-locations: "classpath:/mybatis/mapper/*.xml,classpath:/mybatis/mapper/extend/ *.xml"
logging:
  level:
    cn.geminiplanet.springbootdemo.mapper: debug
```
# 参考资料
1. http://www.ruanyifeng.com/blog/2016/07/yaml.html
2. wiki.suncaper.net
