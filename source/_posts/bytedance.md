---
title: 字节跳动面经
date: 2020-11-25 11:31:51
tags:
- 字节跳动
categories: 
- 面经
---

# Free Talk

本来都打算明天去滴滴入职了，结果字节跳动的一面竟然佛性通过了。

<!--more-->

# 字节跳动一面

自我介绍了一下（学校、年级、奖项、GPA）

讲讲UDP 和 TCP 的差别（具体讲 TCP 怎么实现可靠传输的，我讲了拥塞避免的三个状态及全部过程，扯了一下TCP的版本问题，面试官补充了重传机制）

UDP的使用场景（视频传输，DNS详细地讲了一下）

线程和进程的区别（从操作系统、JVM、协程，CPU调度的什么，协程与线程调度的区别）

HTTP协议（状态码（涉及的不够细），HTTP1.0 ，1.1，2.0，HTTPS，非对称加密和对称加密）

怎么实现 Redis 的快照机制，能够保证在 dump 过程中能够相应其他请求（让我自己来设计，我借鉴 Hash 的内存结构设计，自己简单设计了一个，用了两倍的内存空间）

Java 怎么标记 GC 的（引用计数法，GC roots，roots 由哪些构成的)

算法题：

先给了一题LeetCode 困难问题，接雨水（我大致讲了一下实现思路）

然后又给了一题LeetCode 中等问题，计算两个链表倒序相加的，比较简单

# 一面感受

面试官人真的超好，问的题目也比较基础，接下来还是再认真准备一下，说不定就进字节跳动了呢？

# 字节跳动二面

简单自我介绍一下

直接开始写算法题

LeetCode medium 难度 ：链表排序（要求空间复杂度为常量），我用插入排序写出来了，面试官让我再用归并排序写，我稍微讲了一下思路，没写出来

LeetCode hard 难度：n 皇后问题

写完两道算法题之后，面试官让我简单讲讲 MySQL 懂的所有知识、Redis 的数据类型

最后问了 cookie、session 的详细问题

# 二面感受

一开始都觉得自己要挂，后面突然状态好了起来。

# 字节跳动三面

这次的面试感觉出乎我的意料，不像是面试，更多地是面试官去引导我怎么思考。

一开始和面试官讲了我的基本情况，以及展示了自己的博客， 然后和面试官聊了一下关于抖音产品的看法。

之后面试官出了一道比较困难的 24 点组合问题，我在提示下一点点理清了思路，但是后面的递归的写法不太好。

最后面试官问了一个偏向架构设计思维的问题：抖音 的话题排行榜该怎么设计

我只是简单地从系数加权的角度来讲，后面面试官给我普及了大量的思维方式：

可以从视频内容、地址、时间、主题等信息去做一个相似度的分组处理，同时如果要做一个话题评论区，就从单纯的只读需求，到了写需求，如何做到评论的时效性和通知信息等等。

# 三面感受

其实这次面试表现不太好，面试官也直说我的能力和竞争的本科生没有太大的优势。不过，我还是要乐观地去面对它，希望能够拿到这个令我心动的Offer吧。

