---
title: Docker运行Mysql镜像
date: 2020-07-24 11:46:58
tags:
- Docker
- Mysql
- Windows
categories: 
- Java后端
- 开发工具
---
# Free Talk
最近在进行Spring Boot学习，在配置数据库时想要使用Docker下载Mysql镜像，但是过程中遇到了挺多问题，故记录下解决过程。
**本篇文章内容包含利用Docker运行Mysql镜像，完成数据库配置。**
![Docker-Mysql](https://s1.ax1x.com/2020/07/24/UjmpMq.png)
<!--more-->
# 启用Hyper-V
打开控制面板-->程序-->启用或关闭windows功能，勾选Hyper-V,然后点击确定即可。
![Hyper-V](https://s1.ax1x.com/2020/07/24/Ujm2yq.png)
# 安装Docker
下载地址：https://hub.docker.com/editions/community/docker-ce-desktop-windows
# 启动Docker
打开windows命令行模式，输入docker version或docker -v查看，若出现如下信息则安装成功。
![docker version](https://s1.ax1x.com/2020/07/24/UjnQcn.png)
# 国内镜像加速
阿里云镜像加速地址：https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors
获取专属加速器地址，如下图：
![阿里云镜像](https://s1.ax1x.com/2020/07/24/UjuCUU.png)
打开docker，右键Settings-->Daemon-->Registry mirrors复制刚才的专属加速器地址到此即可，这样就完成了国内镜像加速。
![mirrors](https://s1.ax1x.com/2020/07/24/UjuFC4.png)


# 拉取Mysql镜像
官网：https://hub.docker.com/_/mysql
```
# 默认安装最新版本
docker pull mysql
# 查看镜像
docker images
```
![Mysql镜像](https://s1.ax1x.com/2020/07/24/UjulPe.png)

# 启动Mysql实例
```
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
# 其中some-mysql是您要分配给容器的名称，
# my-secret-pw是要为MySQL根用户设置的密码，
# tag是指定所需MySQL版本的标签。
eg:
docker run --name mysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql
```
![Mysql实例](https://s1.ax1x.com/2020/07/24/UjKGYF.png)

# 进入Mysql命令行
```
# 根据容器名称mysql使用命令进入容器
docker exec -it mysql bash
# 进入Mysql
mysql -u root -p
```
![Mysql命令行](https://s1.ax1x.com/2020/07/24/UjK0w6.png)

# 问题解决
## 安装镜像失败
```
no matching manifest for windows/amd64 10.0.18362 in the manifest list entries
```
**解决方法：**
打开docker，右键Settings-->Daemon-->点击 Basic 设置 "experimental": true。
> 解决manifest 匹配失败问题

## 启动Mysql实例失败
```
Error response from daemon: The virtual machine could not be started because a required feature is not installed.
```
**解决方法：**
打开 CMD 执行
```
BCDEdit /set hypervisorlaunchtype auto
```
重启计算机

# Docker常用命令
```
1.docker images // 查看镜像
2.docker run 镜像名称   // 生成一个正在运行的容器实例
3.docker stop 容器名称   // 停止容器
4.docker rm 容器名称  // 删除容器
5.docker start 容器名称  // 启动容器
6.docker restart 容器名称  //重启容器
7.docker rmi 镜像名称  // 删除镜像
8.docker exec -it 容器名称 /bin/bash  // 进入容器
9.docker ps  // 显示正在运行的所有容器
10.docker ps -a  // 显示所有容器（包括已经停止的）
11.docker pull 镜像名称:版本号  // 拉取镜像
```

# 参考资料
1. https://www.cnblogs.com/zhixie/p/11854659.html
2. https://www.cnblogs.com/zhixie/p/11845748.html
3. https://www.cnblogs.com/zjoch/archive/2011/12/12/2285177.html
4. https://stackoverflow.com/questions/57431890/error-response-from-daemon-hcsshimcreatecomputesystem-the-virtual-machine-co