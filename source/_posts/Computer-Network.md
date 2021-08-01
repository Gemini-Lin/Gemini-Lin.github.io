---
title: Computer Network
date: 2020-06-08 08:41:18
tags:
- 计算机网络
categories: 
- 课程总结
- 计算机网络
coptright: true
---

# 概述
![tRorRg.png](https://s1.ax1x.com/2020/06/08/tRorRg.png)
> 第8点会考一些基本安全知识
<!--more--->
## 计算机网络的概念

## 什么是协议？
### 网络协议
### 三要素
### 和现实协议的对比

## 服务
### 服务划分
面向连接的不一定可靠，无连接的一定不可靠

## 网络核心
### 电路交换
频分
时分
码分
### 分组交换
特点：
### 比较优缺点

## 分组交换网络中延迟、丢失和吞吐量

### 分组交换的4种时延
1. 节点处理时延
2. 排队时延(变换剧烈)
3. **传输时延**
4. **传播时延**

### 吞吐量
瓶颈链路是制约吞吐量的链路

## 协议层及服务模型
### TCP/IP协议的五层模型

![tRTNpF.png](https://s1.ax1x.com/2020/06/08/tRTNpF.png)

# 应用层
![tRTdX9.png](https://s1.ax1x.com/2020/06/08/tRTdX9.png)

## 应用层协议原理
### 端口号
端口号用16位(0-65535)
常用端口：
HTTP：80
邮件服务：25
TelNet：23
SSH：22

上层需要的服务，是本层无法确保的：
传输层不能向上一层提供时延保证

## Web应用和HTTP协议
### HTTP协议
持久和非持久连接的区别：

### RTT

### Cookies
作用、原理、流程
4个重要方面

### web缓存
作用、流程
条件GET

## 电子邮件SMTP、POP3、IMAP
用户本地到服务器的连接方式

## DNS
DNS服务器提供的功能：

### DNS的查询方法
递归：
迭代：

## CDN
作用：
方案：

# 运输层

## UDP
### 校验和
### 伪首部的作用

## 可靠数据传输原理
Rdt1.0-3.0
流水线GBN
选择性重传SR

## TCP
### 报文段结构
20字节的固定首部

### TCP序号和确认
填ACK，Seq
序号Seq：
数据段中第一个字节在数据流中的位置编号
ACK：

TCP估计RTT时：不计算重发的包的--忽略重传

### 连接管理
3次握手、4次挥手 释放连接

### 拥塞控制原理
场景原因

简述TCP拥塞控制

经典图
窗口变化，阈值变化

# 套接字编程
## 字节序
网络是大端字节序

## 基本套接字函数的使用
send和rec缺省是阻塞的

## 5种I/O模式

# 网络层

## 虚电路和数据报网络
区别

## 路由器结构
3种交换结构

## 网际协议
### IP数据包分片和重组
traceroute原理:TTL
### IP地址划分
CIDR

## 路由算法
链路状态
距离向量

# 链路层
## 
进程
服务器
接口
## 奇偶校验
## CRC循环冗余码计算
## 多路访问
ALOHA(纯、时隙)
效率推导了解一下：求极限

CSMA/CD的运行机制
二进制指数回退算法

## MAC、ARP
IP地址不变，MAC不停变化

## 交换机
只学习
VLAN 作用


