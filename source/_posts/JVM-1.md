---
title: JVM系列（一）-- Java类的加载机制
date: 2020-05-27 16:52:42
tags:
- JVM
- java类
categories: 
- Java后端
- JVM
copyright: true
---

# 类的加载定义
类的加载指的是将类的.class文件中的二进制数据读入到内存中，将其放在运行时数据区的方法区内，然后在堆区创建一个`java.lang.Class`对象，用来封装类在方法区内的数据结构。

![image](http://favorites.ren/assets/images/2017/jvm/jvm-1.png)

类的最终加载产品是位于堆区中的Class对象，Class对象封装了类在方法区内的数据结构，并向Java程序提供访问接口。

与C语言的类比：C语言 --> 二进制文件 --> 计算机硬件；Java --> 字节码文件 --> JVM

> **注意事项：**类加载器并不需要等到某个类被“首次主动使用”时再加载，JVM规范允许类加载器在预料某个类将要被使用时就预先加载它，但是如果这个类在加载中遇到错误，只有在主动使用此类时才会报错(LinkageError)。
<!--more-->

# 类的生命周期
加载(Loading) -->  **验证(Verification) --> 准备(Preparation) --> 解析(Resolution)** --> 初始化(Intialization) --> 使用(Using) --> 卸载(Unloading) 共七个阶段；其中验证、准备和解析又统称为**连接(Linking)阶段**。

![image](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9tbWJpei5xcGljLmNuL21tYml6X3BuZy80QUc2dGljNjhBR2JSNnc4bWQ5cW1vcmdldjV5cHN0aWF3ekRKNk5kNmFONUZJRzVzaWFyYmlhTUFSSmljeFQ0UmR2ZzZtaDRhUWdnSVlmQ0xZNTAwMHVIRGliUS82NDA_d3hfZm10PXBuZw?x-oss-process=image/format,png)
> 在前五个阶段中，加载、验证、准备、初始化的顺序是确定的，但是解析阶段不一定，它在某些情况下可以在初始化阶段之前开始，这是为了支持Java的动态绑定。

## 加载

**三个任务：**
> + 通过一个类的全限定名来获取其定义的二进制字节流
> + 将这个字节流所代表的**静态存储结构**转化为方法区的运行时**数据结构**
> + 在Java堆中生成一个代表这个类的`java.lang.Class`对象，作为对方法区中数据的访问入口

## 验证：确保被加载的类的正确性

**四个阶段：**
> + **文件格式验证**：验证字节流是否符合Class文件格式规范；
> + **云数据验证**：对字节码描述的信息进行语义分析，以保证满足java语言的规范
> + **字节码验证**：通过数据流和控制流，确保程序语义是合法的、符合逻辑的。
> + **符号引用验证**：确保解析动作能够正确执行

> ps: 验证阶段非常重要，但是不是必须的，如果引用的类已经经过反复验证了，就可以使用`-Xverifynone`参数来关闭大部分的类验证措施，以缩短虚拟机类加载的时间。

## 准备：为类的静态变量分配内存，并将其初始化为默认值

1. 这时候进行内存分配的仅包括类变量(static)，而不包括实例变量，实例变量会在对象实例化时随着对象一块分配在java堆中。
2. 这里所设置的初始值通常情况下是数据类型默认的零值(如0，null,false),而不是被在java代码中显示赋予的值。
3. 如果类字段的字段属性表中存在`ConstantValue`属性，即同时被final和static修饰，那么在准备阶段变量value就会被初始化为ConstValue属性所指定的值。
**示例：**
> 假设一个类变量的定义为：`public static int value = 3;`
那么变量value在准备阶段过后的初始值为0，而不是3。因为此时尚未执行任何java方法，而赋值为3是在程序编译后，存放于类构造器`<clinit>()`方法中的，在初始化阶段执行。

 这里还需要注意如下几点：
>  + 对基本数据类型来说，对于类变量（static）和全局变量，如果不显式地对其赋值而直接使用，则系统会为其赋予默认的零值，而对于局部变量来说，在使用前必须显式地为其赋值，否则编译时不通过。
>  + 对于同时被static和final修饰的常量，必须在声明的时候就为其显式地赋值，否则编译时不通过；而只被final修饰的常量则既可以在声明时显式地为其赋值，也可以在类初始化时显式地为其赋值，总之，在使用前必须为其显式地赋值，系统不会为其赋予默认零值。
>  + 对于引用数据类型reference来说，如数组引用、对象引用等，如果没有对其进行显式地赋值而直接使用，系统都会为其赋予默认的零值，即null。
> + 如果在数组初始化时没有对数组中的各元素赋值，那么其中的元素将根据对应的数据类型而被赋予默认的零值。

## 解析

解析阶段是虚拟机将**常量池内的符号引用替换为直接引用**的过程。
符号引用就是一组符号来描述目标，可以是任何字面量。
直接引用就是直接指向目标的指针、相对偏移量或一个间接定位到目标的句柄。

## 初始化
初始化：为类的静态变量赋予正确的初始值，JVM负责对类进行初始化，主要对类变量进行初始化。在java中对类变量进行初始值设定有两种方式：
> 1. 声明类变量是指定初始值
> 2. 使用静态代码块为类变量指定初始值

**JVM初始化步骤**
> 1. 假如这个类还没有被加载和连接，则程序先加载并连接该类
> 2. 假如该类的直接父类还没有被初始化，则先初始化其直接父类
> 3. 假如类中有初始化语句，则系统依次执行这些初始化语句

类初始化时机：只有当对类的主动引用的时候才会导致类的初始化。
**类的主动引用**包括以下六种：
> 1. 创建类的实例，也就是new的方式
> 2. 访问某个类或接口的静态变量，或者对该静态变量赋值
> 3. 调用类的静态方法
> 4. 反射（如 Class.forName(“com.shengsiyuan.Test”)）
> 5. 初始化某个类的子类，则其父类也会被初始化
> 6. Java虚拟机启动时被标明为启动类的类（ JavaTest），直接使用 java.exe命令来运行某个主类

被动引用：
> 1. 通过子类引用父类静态字段，不会导致子类初始化；
> 2. Array[] arr = new Array[10]; 不会触发 Array 类初始化；
> 3. static final VAR 在编译阶段会存入调用类的常量池，通过 ClassName.VAR 引用不会触发 ClassName 初始化。

## 介绍生命周期
以下四种情况：
> + 执行了 System.exit()方法
> + 程序正常执行结束
> + 程序在执行过程中遇到了异常或错误而异常终止
> + 由于操作系统出现错误而导致Java虚拟机进程终止

# 类加载器
![image](http://favorites.ren/assets/images/2017/jvm/calssloader.png)

站在Java虚拟机的角度来讲，只存在两种不同的类加载器：
**启动类加载器：**
它使用C++实现（这里仅限于Hotspot，也就是JDK1.5之后默认的虚拟机，有很多其他的虚拟机是用Java语言实现的），是虚拟机自身的一部分；
**所有其它的类加载器：**
这些类加载器都由Java语言实现，独立于虚拟机之外，并且全部继承自抽象类 `java.lang.ClassLoader`，这些类加载器需要由启动类加载器加载到内存中之后才能去加载其他的类。

站在Java开发人员的角度来看，类加载器可以大致划分为以下三类：

**启动类加载器：**`BootstrapClassLoader`，负责加载存放在 `JDK\jre\lib`(JDK代表JDK的安装目录，下同)下，或被 `-Xbootclasspath`参数指定的路径中的，并且能被虚拟机识别的类库（如rt.jar，所有的java.开头的类均被 `BootstrapClassLoader`加载）。启动类加载器是无法被Java程序直接引用的。
**扩展类加载器：**`ExtensionClassLoader`，该加载器由 `sun.misc.Launcher$ExtClassLoader`实现，它负责加载 `JDK\jre\lib\ext`目录中，或者由 `java.ext.dirs`系统变量指定的路径中的所有类库（如javax.开头的类），开发者可以直接使用扩展类加载器。
**应用程序类加载器：**`ApplicationClassLoader`，该类加载器由 `sun.misc.Launcher$AppClassLoader`来实现，它负责加载用户类路径（ClassPath）所指定的类，开发者可以直接使用该类加载器，如果应用程序中没有自定义过自己的类加载器，一般情况下这个就是程序中默认的类加载器。

## JVM类加载机制
+ **全盘负责：**当一个类加载器负责加载某个Class时，该Class所依赖的和引用的其他Class也将由该类加载器负责载入，除非显示使用另外一个类加载器来载入；
+ **父类委托：**先让父类加载器试图加载该类，只有在父类加载器无法加载该类时才尝试从自己的类路径中加载该类；
+ **缓存机制：**缓存机制将会保证所有加载过的Class都会被缓存，当程序中需要使用某个Class时，类加载器先从缓冲区寻找该Class，只有缓存区不存在，系统才会读取该类对应的二进制数据，并将其转换成Class对象，存入缓存区。*这就是为什么修改了Class后，必须重启JVM，程序的修改才会生效。

# 类的加载

## 显式加载
调用`ClassLoader#loadClass(className)`或`Class.forName(className)`。
区别：
> 1. Class.forName()：将类的.class文件加载到jvm中之外，还会对类进行解释，执行类中的static块；
> 2. ClassLoader.loadClass()：只干一件事情，就是将.class文件加载到jvm中，不会执行static中的内容,只有在newInstance才会去执行static块。
> 3. Class.forName(name,initialize,loader)带参函数也可控制是否加载static块。并且只有调用了newInstance()方法采用调用构造函数，创建类的对象 。

## 隐式加载
1. new类对象；
2. 使用类的静态域；
3. 创建子类对象；
4. 使用子类的静态域；
5. 其他的隐式加载，在JVM启动时：
> + BootStrapLoader 会加载一些 JVM 自身运行所需的 Class；
> + ExtClassLoader 会加载指定目录下一些特殊的 Class；
> + AppClassLoader 会加载 classpath 路径下的 Class，以及 main 函数所在的类的 Class 文件。

# 双亲委派模型

**工作流程：**如果一个类加载器收到了类加载的请求，它首先不会自己去尝试加载这个类，而是把请求委托给父加载器去完成，依次向上，因此，所有的类加载请求最终都应该被传递到顶层的启动类加载器中，只有当父加载器在它的搜索范围中没有找到所需的类时，即无法完成该加载，子加载器才会尝试自己去加载该类。

**双亲委派机制：**
1. 当 `AppClassLoader`加载一个class时，它首先不会自己去尝试加载这个类，而是把类加载请求委派给父类加载器`ExtClassLoader`去完成。

2. 当 `ExtClassLoader`加载一个class时，它首先也不会自己去尝试加载这个类，而是把类加载请求委派给`BootStrapClassLoader`去完成。

3. 如果 `BootStrapClassLoader`加载失败（例如在 $JAVA_HOME/jre/lib里未查找到该class），会使用 `ExtClassLoader`来尝试加载；

4. 若`ExtClassLoader`也加载失败，则会使用 `AppClassLoader`来加载，如果 `AppClassLoader`也加载失败，则会报出异常 `ClassNotFoundException`。

# 面试问题

1. 简单讲下JVM中的类加载过程

2. JVM中的类加载和卸载的时机？

3. 如何理解JVM中不同类加载器的概念和作用？

4. 简单讲下JVM中的双亲委派模型？

5. 什么情况下会破坏双亲委派模型？为什么？可否举个例子？

6. Tomcat中的类加载机制有了解吗？为什么这么设计？

7. 实际开发中有遇到哪些类加载器相关的问题？你又是如何解决的？

8. JVM之上的弱类型语言例如Groovy是如何实现？简单讲下动态类加载机制？
参考资料：
[微信公众号](https://mp.weixin.qq.com/s?__biz=MzI4NDY5Mjc1Mg==&mid=2247483934&idx=1&sn=41c46eceb2add54b7cde9eeb01412a90&chksm=ebf6da61dc81537721d36aadb5d20613b0449762842f9128753e716ce5fefe2b659d8654c4e8&scene=21#wechat_redirect)
[Github博主](https://github.com/TangBean/understanding-the-jvm/blob/master/Ch2-Java%E8%99%9A%E6%8B%9F%E6%9C%BA%E7%A8%8B%E5%BA%8F%E6%89%A7%E8%A1%8C/01-%E8%99%9A%E6%8B%9F%E6%9C%BA%E7%9A%84%E7%B1%BB%E5%8A%A0%E8%BD%BD%E6%9C%BA%E5%88%B6.md)
[Blog](https://blog.csdn.net/duqi_2009/article/details/101877579)