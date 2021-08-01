---
title: Java枚举(enum)
date: 2020-07-11 11:21:02
tags:
- Java
- 面向对象
- 枚举
categories: 
- Java后端
- Java语言基础
quicklink: true
---
# Free Talk
上学期上Java课时都没有听说过枚举的概念，这次偶然在JavaGuide博客中看到了，就想写一些枚举相关知识。本篇文章会较为深入地讲解一下枚举的强大功能。
写这边博客的时候，又发现了廖雪峰的Java教程也写的很好，可以配套食用。
[JavaGuide](https://snailclimb.gitee.io/javaguide/#/docs/java/basic/%E7%94%A8%E5%A5%BDJava%E4%B8%AD%E7%9A%84%E6%9E%9A%E4%B8%BE%E7%9C%9F%E7%9A%84%E6%B2%A1%E6%9C%89%E9%82%A3%E4%B9%88%E7%AE%80%E5%8D%95)和[廖雪峰](https://www.liaoxuefeng.com/wiki/1252599548343744/1260473188087424)
<!--more-->
# 简介
**Java枚举其实是指一种特殊的类，它一般用来表示一组常量。**
```Java
package shuang.kou.enumdemo.enumtest;

public enum PizzaStatus {
    ORDERED,
    READY, 
    DELIVERED; 
}
```
上面的代码为了避免定义常量，将和Pizza有关的常量都放入了枚举类中。
```Java
System.out.println(PizzaStatus.ORDERED.name());//ORDERED
System.out.println(PizzaStatus.ORDERED);//ORDERED
System.out.println(PizzaStatus.ORDERED.name().getClass());//class java.lang.String
System.out.println(PizzaStatus.ORDERED.getClass());//class shuang.kou.enumdemo.enumtest.PizzaStatus
```
# Why need it?
在Java中我们想要定义常量，完全可以用`static final`来定义,比如我们想要定义周一到周日这几个常量。
```Java
public class Weekday {
    public static final int SUN = 0;
    public static final int MON = 1;
    public static final int TUE = 2;
    public static final int WED = 3;
    public static final int THU = 4;
    public static final int FRI = 5;
    public static final int SAT = 6;
}
```
但是当用这些常量来表示一组枚举值时，会产生一个严重的问题，编译器无法检查每个值的合理性。
```Java
if (weekday == 6 || weekday == 7) {
    if (tasks == Weekday.MON) {
        // TODO:
    }
}
```
{% note success no-icon %}
在上面的代码中，编译和运行都不会报错，但是存在两个问题：
1. `weekday`定义的常量范围为`0~6`，但此处值为`7`，编译器无法检查不在枚举中的`int`值；
2. 定义的常量仍可以和其他变量比较，违背了最初的意愿
{% endnote %}
**因此以枚举方式定义的常量使代码更具可读性，允许进行编译时检查，预先记录可接受值的列表，并避免由于传入无效值而引起的意外行为。**
[廖雪峰枚举](https://www.liaoxuefeng.com/wiki/1252599548343744/1260473188087424)

# ==比较
使用`enum`定义的枚举类是一种引用类型。
而引用类型比较，要使用`equals()`方法，如果使用`==`比较，它比较的是两个引用类型的变量是否是同一个对象。因此，引用类型比较，要始终使用`equals()`方法，但`enum`类型可以除外。
引用类型与基本数据类型分类见下表，[图片来源](https://blog.csdn.net/truelove12358/article/details/60143499)
![UlA35j.png](https://s1.ax1x.com/2020/07/11/UlA35j.png)
这是因为`enum`类型的每个变量在JVM中只有一个唯一实例，所以可以直接用`==`比较。
```Java
if (day == Weekday.FRI) { // ok!
}
if (day.equals(Weekday.SUN)) { // ok, but more code!
}
```

# Switch语句
```Java
public int getDeliveryTimeInDays() {
    switch (status) {
        case ORDERED: return 5;
        case READY: return 2;
        case DELIVERED: return 0;
    }
    return 0;
}

```
# enum类型
通过`enum`定义的枚举类，和其他的`class`有什么区别？
答案是没有任何区别。`enum`定义的类型就是`class`，只不过它有以下几个特点：
+ 定义的`enum`类型总是继承自`java.lang.Enum`，且无法被继承；
+ 只能定义出`enum`的实例，而无法通过`new`操作符创建`enum`的实例；
+ 定义的每个实例都是引用类型的唯一实例；
+ 可以将`enum`类型用于`switch`语句。(如上所示)

我们可以定义一个`Color`枚举类:
```Java
public enum Color {
    RED, GREEN, BLUE;
}
```
通过编译器编译出的`class`大概就是这样：
```Java
public final class Color extends Enum { // 继承自Enum，标记为final class
    // 每个实例均为全局唯一:
    public static final Color RED = new Color();
    public static final Color GREEN = new Color();
    public static final Color BLUE = new Color();
    // private构造方法，确保外部无法调用new操作符:
    private Color() {}
}
```
所以，编译后的`enum`类和普通`class`并没有任何区别。但是我们自己无法按定义普通`class`那样来定义`enum`，必须使用`enum`关键字，这是Java语法规定的。

因为`enum`是一个`class`，每个枚举的值都是`class`实例。
# 常用方法
## name()
返回常量名
```Java
String s = Weekday.SUN.name(); // "SUN"
```
## ordinal()
返回定义的常量的顺序，从0开始计数
```Java
int n = Weekday.MON.ordinal(); // 1
```
