---
title: Github入门教学
date: 2020-05-14 13:12:28
tags:
- GitHub
categories: 
- 工具分享
copyrignt: true
---
# GitHub入门教学（Git，界面介绍，搜索）
## 前提：Git使用
GitHub是基于Git开发得到，学习Git是了解GitHub的前提，在这里我推荐一个特别喜欢的学习教程。

[廖雪峰Git教学](https://www.liaoxuefeng.com/wiki/896043488029600)

简单示例
```
mkdir learngit #创建一个空白目录
cd learngit 

git init #把这个目录变成Git可以管理的仓库

git add readme.txt #把文件添加到仓库

git commit -m "wrote a readme file" #把文件提交给仓库

git push -u origin master #把本地仓库中的所有内容上传到远程库
```
![t8gefS.png](https://s1.ax1x.com/2020/06/01/t8gefS.png)
<!--more-->
## GitHub介绍(敲黑板)

Keywords：

版本分支介绍，版本分支比较，Issue，Pull Request，Projects，Wiki，Github Pages

## GitHub搜索开源项目

开源项目的搜索方法
```
pushed:>2020-05-15   # 在最近这一天修改过
in:name [关键字]  # 名字里面包含关键字
in:readme [关键字] # readme里面包含关键字
in:description 【关键字】# 描述里面包含关键字
forks:>4 # stars数量大于4的项目
stars:>1000  # stars数量大于1000的项目
langusge:java  # 使用java作为开发语言
```

简单示例
```
in:description 爬虫 stars:>100  language:python
```

## [B站视频链接](https://www.bilibili.com/video/BV1ea4y1i7NN/)