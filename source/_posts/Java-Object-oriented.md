---
title: Java面向对象
date: 2020-07-10 17:28:43
tags:
- Java
- 面向对象
categories: 
- Java后端
- Java语言基础
quicklink: true
---
# Free Talk
面向对象是Java语言的核心，涉及的知识点非常多，这篇文章主要讲解三大特征(封装、继承、多态)、接口、异常等特性。其余部分会在之后单独地另写几篇文章。
参考资料：[JavaGuide](https://snailclimb.gitee.io/javaguide/#/docs/java/Java%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86?id=_2-java-%e9%9d%a2%e5%90%91%e5%af%b9%e8%b1%a1)
<!--more-->
# 三大特征
## 封装
**封装顾名思义，就是把一个对象的状态信息(也就是属性)隐藏在对象内部，不允许外部对象直接访问对象的内部信息，但是会提供一些可以被外界访问的方法来操作属性。**
简单的说，类会提供变量和方法供外界访问使用，就叫封装。
## 继承
**继承，就是因为不同的类对象之间，有这个很多的共同点，因此可以创建一个具有共同点的父类，子类再继承父类。**

例如，小明同学、小红同学、小李同学，都共享学生的特性（班级、学号等）。同时，每一个对象还定义了额外的特性使得他们与众不同。例如小明的数学比较好，小红的性格惹人喜爱；小李的力气比较大。

继承是使用已存在的类的定义作为基础建立新类的技术，新类的定义可以增加新的数据或新的功能，也可以用父类的功能，**但不能选择性地继承父类。**通过使用继承，可以快速地创建新的类，可以提高代码的重用，程序的可维护性，节省大量创建新类的时间 ，提高我们的开发效率。

+ 子类拥有父类对象所有的属性和方法（包括私有属性和私有方法），**但是父类中的私有属性和方法子类是无法访问，只是拥有。**
+ 子类可以拥有自己属性和方法，即子类可以对父类进行扩展。
+ 子类可以用自己的方式实现父类的方法。（以后介绍）。

## 多态
多态，即表示一个对象具有多种的状态。具体表现为父类的引用指向子类的实例。简单来讲，**多态就是同一个接口，使用不同的实例而执行不同操作。**[多态资料](https://www.cnblogs.com/scyq/p/11667881.html)
```Java
// 创建Animal类
class Animal{
	protected String name;	// 可被子类访问的name
	public Animal() {
		this.name = "Animal";
	}
	// 封装
	public String getName() {
		return this.name;
	}
}

class Cat extends Animal{
	Cat(){
		name = "Cat";
	}
}

class Dog extends Animal{
	Dog(){
		name = "Dog";
	}
}

public class Test {
	static public void board(Animal s) {		
		System.out.println(s.getName());
	}
	
	public static void main(String[] args) {
		Animal animal = new Animal();	//创建Animal对象
		Animal cat = new Cat();			//创建Cat对象
		Animal dog = new Dog();			//创建Dog对象
		// 三块广告牌
		board(animal);
		board(cat);
		board(dog);
		
	}
}

// output
// Animal
// Cat
// Dog
```
# 接口
在软件工程中，接口泛指供别人调用的方法或函数。在接口中，所有方法都必须是抽象方法，不能有实现。当类实现接口的时候，类要实现接口中所有的方法。否则，类必须声明为抽象的类。
{% note success no-icon %}
Java的类是不允许多继承的，而C++中是允许的，但是接口是允许多继承的。
{% endnote %}
```Java
//定义接口
interface Animal {
   public void eat();
   public void travel();
}
//实现接口
public class MammalInt implements Animal{
 
   public void eat(){
      System.out.println("Mammal eats");
   }
 
   public void travel(){
      System.out.println("Mammal travels");
   } 
 
   public int noOfLegs(){
      return 0;
   }
 
   public static void main(String args[]){
      MammalInt m = new MammalInt();
      m.eat();
      m.travel();
   }
}
```
# 异常
## 异常的层次分类
Java中异常的层次分类见下图，[图片来源](https://simplesnippets.tech/exception-handling-in-java-part-1/)
![异常层次分类](https://imgkr.cn-bj.ufileos.com/199703ce-a1b6-4968-9eb0-161a8217507e.png)
## Throwable类常用方法
+ **`public string getMessage():`**返回异常发生时的简要描述
+ **`public string toString():`**返回异常发生时的详细信息
+ **`public string getLocalizedMessage():`**返回异常对象的本地化信息。使用 `Throwable` 的子类覆盖这个方法，可以生成本地化信息。如果子类没有覆盖该方法，则该方法返回的信息与 `getMessage()`返回的结果相同
+ **`public void printStackTrace():`**在控制台上打印 `Throwable `对象封装的异常信息

## try-catch-finally
+ **try 块：** 用于捕获异常。其后可接零个或多个 catch 块，如果没有 catch 块，则必须跟一个 finally 块。
+ **catch 块：** 用于处理 try 捕获到的异常。
+ **finally 块：** 无论是否捕获或处理异常，finally 块里的语句都会被执行。当在 try 块或 catch 块中遇到 return 语句时，finally 语句块将在方法返回之前被执行。

```Java
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
 
 
public class Main {
    public static void main(String[] args) {
        String str = new Main().openFile();
        System.out.println(str);
         
    }
     
    public String openFile() {
        try {
            FileInputStream inputStream = new FileInputStream("d:/a.txt");
            int ch = inputStream.read();
            System.out.println("aaa");
            return "step1";
        } catch (FileNotFoundException e) {
            System.out.println("file not found");
            return "step2";
        }catch (IOException e) {
            System.out.println("io exception");
            return "step3";
        }finally{
            System.out.println("finally block");
            //return "finally";
        }
    }
}
```
{% note success no-icon %}
执行结果：
file not found
finally block
step2
{% endnote %}
可以看出，在try块中发生FileNotFoundException之后，就跳到第一个catch块，打印"file not found"信息，并将"step2"赋值给返回值，然后执行finally块，最后将返回值返回。
从这个例子说明，无论try块或者catch块中是否包含return语句，都会执行finally块。
[代码来源](https://www.cnblogs.com/dolphin0520/p/3769804.html)