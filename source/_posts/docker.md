---
title: Docker入门教程
date: 2020-06-28 09:52:57
tags:
- Docker
categories: 
- Java后端
- 开发工具
copyright: true
quicklink: true
---
# Free Talk
![Docker](https://s1.ax1x.com/2020/06/29/Nh1Saj.png)
我之前一直都听过鼎鼎大名的Docker,但都没有仔细地了解一下，有一次给后端接Mysql数据库时，本来想下一个Mysql的，但是安装配置太麻烦，就直接从Docker上下了一个镜像就解决了，这就是我的Docker初体验。
接下来，就请乘坐我的宇宙航线，开启Docker之旅:sparkles:。
<!--more-->
# What is Dcoker?
在讲述Docker前，我们需要了解一下的它的诞生起源，也就是**Why need it?**
## 环境配置
软件开发过程中，遇到最麻烦的问题就各种环境的安装，从一开始的C语言到Java到数据库postgresql等,很多时候自己的程序在本机跑没有问题，但是别人的机子就跑不通。这个时候开发者经常说“**it works on my machine**”,其实往往在别的机子不行。
于是聪明的开发者就想，我能不能把环境一起安装呢?也就是说，我在安装的软件程序的时候，不仅仅安装程序应用本身，而且把它所需要的环境依赖都一同安装下来。
## 虚拟机
虚拟机(Virtual Machine)其实就是一种很好的解决方案，我只要使用Vmware安装Linux虚拟机，就可以在Windows系统中运行Linux虚拟环境。虽然用户可以通过虚拟机还原软件的原始环境。但是，这个方案有几个缺点。
1. 占用内存空间
> 我自己在运行Linux虚拟机就要划分80GB的磁盘空间，而且一跑起来风扇就开始快速转动。
2. 启动慢
> 启动操作系统虚拟多久，启动虚拟机就要多久。我因为之前划分了磁盘，每次启动要几分钟的时间。
3. 操作不便捷
> 虚拟机是完整的操作系统，想要启动一个服务，往往需要冗余步骤。

## Linux容器
针对前面提到的虚拟机存在的问题，Linux发展出另一种虚拟化技术(Linux Containers),也就是**Linux容器**。
![container](https://s1.ax1x.com/2020/07/12/U3vH8f.png)
> 关于容器的概念我们可以把它通俗地理解为一个个集装箱，每一个集装箱之间是相互隔离运行的，但是在运输的时候又共享同一艘货轮(操作系统)，也就是说每一个容器都是一个进程，共享操作系统的资源。


### 容器VS虚拟机
虚拟机技术是虚拟化一整套硬件，在上面运行一个完整的操作系统。
而容器虚拟化的是操作系统，而不是硬件，容器之间是共享同一个操作系统资源的。

## Docker
Docker 属于 Linux 容器的一种**封装**，提供简单易用的容器使用接口。它是目前最流行的 Linux 容器解决方案。

Docker 将应用程序与该程序的依赖，打包在一个文件里面。运行这个文件，就会生成一个虚拟容器。程序在这个虚拟容器里运行，就好像在真实的物理机上运行一样。有了 Docker，就不用担心环境问题。

总体来说，Docker 的接口相当简单，用户可以方便地创建和使用容器，把自己的应用放入容器。容器还可以进行版本管理、复制、分享、修改，就像管理普通的代码一样。

# Docker的基本概念
![docker](https://s1.ax1x.com/2020/07/12/U3xAr4.png)
## Image镜像
我们可以把镜像理解成是一个特殊的文件系统。
>对于Linux操作系统而言，内核模块启动后，会挂载root文件系统为其提供用户空间的支持。而Docker镜像就相当于是一个root文件系统。

Docker 把应用程序及其依赖，打包在 image 文件里面。只有通过这个文件，才能生成 Docker 容器。image 文件可以看作是容器的**模板**。Docker 根据 image 文件生成容器的实例。同一个 image 文件，可以生成多个同时运行的容器实例。

因为Docker在设计时，采用的是Union FS的技术，将其设计为**分层存储**的架构。
**因此在镜像构建时，会一层层地构建，前一层是后一层地基础。**每一层构建完就不会再发生改变，后一层上的任何改变只会影响到自己这一层。可以见上图中的镜像层次分布。
## Container容器
镜像（Image）和容器（Container）的关系，就像是面向对象程序设计中的 类 和 实例 一样，镜像是静态的定义，**容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。**
## Repository仓库
仓库就是一个集中存放镜像文件的地方。
# Docker常用命令
```Docker
# 启动Docker服务
sudo service docker start
# Pull Docker镜像
docker image pull library/hello-world
# 运行image镜像,生成容器实例
docker container run hello-world
# 结束实例进程
docker container kill[containerID]
```
参考资料：
https://www.ruanyifeng.com/blog/2018/02/docker-tutorial.html
https://juejin.im/post/5b260ec26fb9a00e8e4b031a#heading-6