---
title: Maven入门介绍
date: 2020-07-18 15:20:04
tags:
- Maven
categories: 
- Java后端
- 开发工具
copyright: true
quicklink: true
---
# What is Maven？
Maven是一个**Java项目管理和构建工具**，它可以定义项目结构、项目依赖，并使用统一的方式进行自动化构建，是Java项目不可缺少的工具。
![Maven](https://s1.ax1x.com/2020/07/18/UgJM0x.png)
<!--more-->
# Maven介绍
在Java项目开发中，我们常常需要引入一些依赖包，通常都要把jar包放入`classpath`下。

其次，我们要确定项目的目录结构。比如，`src`目录存放Java源码，`resource`目录存放配置文件，`bin`目录存放编译生成的`.class`文件。

此外，我们还需要配置环境，比如JDK版本等一系列的配置问题。

**这个时候，前辈们就开发出了Maven，专门为Java项目打造的管理和构建工具。**

# Maven项目结构
![Maven项目结构](https://s1.ax1x.com/2020/07/18/UgNBAx.png)
项目的根目录`a-maven-project`是**项目名**，
它有一个**项目描述文件**`pom.xml`，
存放**Java源码**的目录是`src/main/java`，
存放**资源文件**的目录是`src/main/resources`，
存放**测试源码**的目录是`src/test/java`，
存放**测试资源**的目录是`src/test/resources`。
最后，所有编译、打包生成的文件都放在`target`目录里。这些就是一个Maven项目的标准目录结构。
## Pom
**Pom是指项目对象模型(Project Object Model),是Maven工作的基础。**在执行task或者goal时，Maven会去项目根目录下读取`pom.xml`获得需要的配置信息。

**pom.xml文件如下：**
```xml
<project ...>// 类似于Java的包名
	<modelVersion>4.0.0</modelVersion>
        // 所使用的object model版本，为了确保稳定的使用，这个元素是强制性的。
	<groupId>com.itranswarp.learnjava</groupId>
        // 是项目创建团体或组织的唯一标志符，通常是域名倒写
	<artifactId>hello</artifactId>// 类似于Java的类名
	<version>1.0</version>// 开发版本
	<packaging>jar</packaging>// 打包的方式，默认为jar
	<properties>
        ...
	</properties>
	<dependencies>
        <dependency> 
        // 表示依赖，在子节点dependencies中添加具体依赖的groupId artifactId和version 
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
            <version>1.2</version>
        </dependency>
    // 使用dependency声明一个依赖后，Maven就会自动下载这个依赖包并把它放到classpath中。
	</dependencies>
</project>
```
# 依赖管理
Maven定义了几种依赖关系，分别是`compile`、`test`、`runtime`和`provided`：
![依赖关系](https://s1.ax1x.com/2020/07/18/UgwBse.png)
其中，默认的`compile`是最常用的，Maven会把这种类型的依赖直接放入classpath。
## 命令行编译
在命令中，进入到pom.xml所在目录，输入以下命令：
```Java
$ mvn clean package
```
即可在`target`目录下获得编译后自动打包的jar。
## 镜像加速
中国区用户可以使用阿里云提供的Maven镜像仓库。使用Maven镜像仓库需要一个配置，在用户主目录下进入`.m2`目录，创建一个`settings.xml`配置文件，内容如下：
```xml
<settings>
    <mirrors>
        <mirror>
            <id>aliyun</id>
            <name>aliyun</name>
            <mirrorOf>central</mirrorOf>
            <!-- 国内推荐阿里云的Maven镜像 -->
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        </mirror>
    </mirrors>
</settings>
```
# 构建流程
## Build LifeCycle
**Build LifeCycle是指一个项目build的过程**。Maven的 Build LifeCycle 分为三种，分别为`default`（处理项目的部署）、`clean`（处理项目的清理）、`site`（处理项目的文档生成）。他们都包含不同的 lifecycle。

Build LifeCycle 是由 phases 构成的，下面重点介绍 default Build LifeCycle 几个重要的 phase：
```Java
validate    验证项目是否正确以及必须的信息是否可用
compile     编译源代码
test    测试编译后的代码，即执行单元测试代码
package     打包编译后的代码，在target目录下生成package文件
integration-test    处理package以便需要时可以部署到集成测试环境
verify      检验package是否有效并且达到质量标准
install     安装package到本地仓库，方便本地其它项目使用
deploy  部署，拷贝最终的package到远程仓库和替他开发这或项目共享，在集成或发布环境完成
```
## Goal
**Goal代表一个特定任务。**

其实我们类比一下就明白了：
+ lifecycle 相当于 Java 的 package，它包含一个或多个 phase；
+ phase 相当于 Java 的 class，它包含一个或多个 goal；
+ goal 相当于 class 的 method，它其实才是真正干活的。

## 常用命令
`mvn clean`：清理所有生成的class和jar；
`mvn clean compile`：先清理，再执行到`compile`；
`mvn clean test：`先清理，再执行到`test`，因为执行`test`前必须执行`compile`，所以这里不必指定`compile`；
`mvn clean package：`先清理，再执行到`package`。

# 参考资料
1. https://www.liaoxuefeng.com/wiki/1252599548343744/1309301146648610
2. https://www.trinea.cn/android/maven/