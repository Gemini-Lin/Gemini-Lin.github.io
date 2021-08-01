---
title: JVM系列（五）-- 字节码执行机制(Part 2)
date: 2020-07-16 12:16:22
tags:
- JVM
- 字节码
- 方法调用
categories: 
- Java后端
- JVM
copyright: true
---
# 方法调用
Java 的方法的执行分为两个部分：
**1. 方法调用：确定被调用的方法是哪一个；
2. 基于栈的解释执行：真正地执行方法的字节码。**

方法调用并不等同于方法中的代码被执行，方法调用阶段唯一的任务就是**确定被调用方法的版本（即调用哪一个方法）**，暂时还未涉及方法内部的具体运行过程。
<!--more-->
{% note success no-icon %}
一切方法的调用在 Class 文件中存储的都是常量池中的符号引用，而不是方法实际运行时的入口地址（直接引用），直到类加载的时候，甚至是实际运行的时候才回去会去确定要被运行的方法的直接引用。
{% endnote %}

# 解析调用
**解析(Resolution),指的是在类加载的解析阶段就完成方法调用。**

解析调用能够成立的条件：方法在程序真正运行之前就有一个可确定的调用版本，并且这个方法的调用版本在运行期是不可变的，**即“编译期可知，运行期不可变”。**
{% note success no-icon %}
**满足这个要求的方法有两类：静态方法、私有方法**
前者与类型直接关联，后者在外部不可被访问，这两种方法各自的特点决定了它们都不可能通过继承或别的方式重写出其他版本，因此它们都适合在类加载阶段进行解析。
{% endnote %}

## 方法调用字节码指令
**调用不同类型的方法，字节码指令集里设计了不同的指令。**在Java虚拟机支持以下5条方法调用字节码指令，分别是：
+ `invokestatic`：调用静态方法；
+ `invokespecial`：调用构造器<init>方法、私有方法、父类方法；
+ `invokevirtual`：调用所有虚方法，除了静态方法、构造器方法、私有方法、父类方法、final 方法的其他方法叫虚方法；
+ `invokeinterface`：调用接口方法，会在运行时确定一个该接口的实现对象；
+ `invokedynamic`：在运行时动态解析出调用点限定符引用的方法，再执行该方法。

>前面4条调用指令，分派逻辑都固化在Java虚拟机内部，而`invokedynamic`指令的分派逻辑是由用户设定的引导方法来决定的，其实从 dynamic 的意思就看的出来。
这是因为其他 4 种方法的第一个参数都是**被调用的方法的符号引用，是在编译时确定的，所以它们缺乏动态类型语言支持**，因为动态类型语言只有在运行期才能确定接收者的类型，即变量的类型检查的主体过程在运行期，而非编译期。

{% note success no-icon %}
**因此解析调用对应的方法调用指令为：**
+ `invokestatic`：调用静态方法；
+ `invokespecial`：调用构造器<init>方法、私有方法、父类方法；
+ 被final修饰的方法（尽管它使用`invokevirtual`指令调用）
{% endnote %}

# 分派调用
在介绍分派调用前，我们先来介绍一下 Java 所具备的面向对象的 3 个基本特征：封装，继承，多态。

其中多态最基本的体现就是重载和重写了，**重载和重写的一个重要特征就是方法名相同，其他各种不同：**

+ 重载：发生在同一个类中，入参必须不同，返回类型、访问修饰符、抛出的异常都可以不同；
+ 重写：发生在子父类中，入参和返回类型必须相同，访问修饰符大于等于被重写的方法，不能抛出新的异常。

相同的方法名实际上给虚拟机的调用带来了困惑，**因为虚拟机需要判断，它到底应该调用哪个方法，而这个过程会在分派调用中体现出来。**其中：

+ **方法重载 —— 静态分派**
+ **方法重写 —— 动态分派**

## 静态分派
在介绍静态分派前，我们先来介绍一下什么是变量的**静态类型和实际类型**。
```Java
public class StaticDispatch {
    static abstract class Human {
    }

    static class Man extends Human {
    }

    static class Woman extends Human {
    }

    public void sayHello(Human guy) {
    	System.out.println("Hello guy!");
    }

    public void sayHello(Man man) {
    	System.out.println("Hello man!");
    }

    public void sayHello(Woman woman) {
    	System.out.println("Hello woman!");
    }

    public static void main(String[] args) {
        Human man = new Man();
        Human woman = new Woman();
        StaticDispatch sr = new StaticDispatch();
        sr.sayHello(man);
        sr.sayHello(woman);
        /* 输出：
        Hello guy!
        Hello guy!
        因为是根据变量的静态类型，也就是左面的类型：Human 来判断调用哪个方法，
        所以调用的都是 public void sayHello(Human guy)
        */
    }
}

/* 简单讲解 */
// 使用
Human man = new Man();

// 实际类型发生变化
Human man = new Man();
man = new Woman();

// 静态类型发生变化
sr.sayHello((Man) man);   // 输出：Hello man!
sr.sayHello((Woman) man); // 输出：Hello woman!
```
**其中 `Human` 称为变量的静态类型，`Man` 称为变量的实际类型。
在重载时，编译器是通过方法参数的静态类型，而不是实际类型，来判断应该调用哪个方法的。**

**所有依赖静态类型来决定方法执行版本的分派动作，都称为静态分派。静态分派的最典型应用表现就是方法重载。**静态分派发生在javac编译阶段，因此确定静态分派的动作实际上不是由虚拟机来执行的。
## 动态分派
**动态分派就是在运行时，根据实际类型确定方法执行版本的分派过程。**

动态分派的过程：
```Java
public class DynamicDispatch {
    static abstract class Human {
  	  protected abstract void sayHello();
    }

    static class Man extends Human {
        protected void sayHello() {
        	System.out.println("Hello man");
        }
    }

    static class Woman extends Human {
        protected void sayHello() {
        	System.out.println("Hello woman");
        }
    }

    public static void main(String[] args) {
        Human man = new Man();
        Human woman = new Woman();
        man.sayHello();
        woman.sayHello();
        man = woman;
        man.sayHello();
        /* 输出
        Hello man
        Hello woman
        Hello woman
        */
    }
}
```
显然这里选择调用的方法版本是不可能再根据静态类型来决定的，因为静态类型同样都是 `Human` 的两个变量 `man` 和 `woman` 在调用`sayHello()`方法时产生了不同的行为，甚至变量 `man` 在两次调用中还执行了两个不同的方法。导致这个现象的原因很明显，是因为这两个变量的实际类型不同。

**`javap` 输出字节码分析：**
```
javap -verbose DynamicDispatch
public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
        stack=2, locals=3, args_size=1
        0: new           #2      // class com/jvm/ch8/DynamicDispatch$Man
        3: dup
        4: invokespecial #3      // Method com/jvm/ch8/DynamicDispatch$Man."<init>":()V
        7: astore_1
        8: new           #4      // class com/jvm/ch8/DynamicDispatch$Woman
        11: dup
        12: invokespecial #5     // Method com/jvm/ch8/DynamicDispatch$Woman."<init>":()V
        15: astore_2
        16: aload_1		        // 把刚创建的对象的引用压到操作数栈顶，
                                // 供之后执行sayHello时确定是执行哪个对象的sayHello
        17: invokevirtual #6    // 方法调用
        20: aload_2             // 把刚创建的对象的引用压到操作数栈顶，
                                // 供之后执行sayHello时确定是执行哪个对象的sayHello
        21: invokevirtual #6    // 方法调用
        24: aload_2
        25: astore_1
        26: aload_1
        27: invokevirtual #6    // Method com/jvm/ch8/DynamicDispatch$Human.sayHello:()V
        30: return
```
`invokevirtual`指令的运行时解析过程:
1. 找到操作数栈顶的第一个元素所指向的对象的**实际类型**，记作C。
2. 如果在类型C中找到与常量中的描述符和简单名称都相符的方法，则进行访问权限校验，如果通过则返回这个方法的直接引用，查找过程结束；不通过则返回`java.lang.IllegalAccessError`异常。
3. 否则，按照继承关系从下往上依次对C的各个父类进行第二步的搜索和验证过程。
4. 如果始终没有找到合适的方法，则抛出`java.lang.AbstractMethodError`异常。

正是因为`invokevirtual`指令执行的第一步就是在运行期确定接收者的实际类型，所以两次调用中的`invokevirtual`指令并不是把常量池中方法的符号引用解析到直接引用上就结束了，还会根据方法接收者的实际类型来选择方法版本，**这个过程就是Java语言中方法重写的本质。**

**我们把这种在运行期根据实际类型确定方法执行版本的分派过程称为动态分派。**


**字段永远不参与多态**，哪个类的方法访问某个名字的字段时，该名字指的就是这个类能看到的那个字段。
```Java
public class FieldHasNoPolymorphic{

    static class Father{
        public int money = 1;

        public Father(){
            money = 2;
            showMeTheMoney();
        }

        public void showMeTheMoney(){
            System.out.println("I am Father,i have $" + money);
        }
    }

    static class Son extends Father{
        public int money = 3;

        public Son(){
            money = 4;
            showMeTheMoney();
        }

         public void showMeTheMoney(){
            System.out.println("I am Son,i have $" + money);
        }
    }

    public static void main(String[] args){
        Father gay = new Son();
        System.out.println("This gay has $" + gay.money);
    }
}
```
本来不想打上面的代码，但是这个输出里面涉及的知识很多，我觉得大多数人的都不知道正确的输出。
**正确输出：**
```Java
I am Son,i have $0
I am Son,i have $4
This gay has $2
```
{% note success no-icon %}
**惊不惊喜，意不意外**
输出两句都是`“I am Son”`，这是因为`Son`类在创建的时候，首先隐式调用了`Father`的构造函数，而`Father`构造函数中对`showMeTheMoney()`的调用是一次虚方法调用，实际执行的版本是`Son::showMeTheMoney()`方法，所以输出的是`“Iam Son”`，这点经过前面的分析相信读者是没有疑问的了。

而这时候虽然父类的`money`字段已经被初始化成2了，但`Son::showMeTheMoney()`方法中访问的却是子类的`money`字段，这时候结果自然还是0，因为它要到子类的构造函数执行时才会被初始化。`main()`的最后一句通过静态类型访问到了父类中的`money`，输出了2。
{% endnote %}
## 单分派与多分派
**方法的接收者与方法的参数统称为方法的宗量,据分派基于多少种宗量，可以将分派划分为单分派和多分派两种。**
1. Java 语言的静态分派属于多分派，根据 **方法接收者的静态类型** 和 **方法参数类型** 两个宗量进行选择。
2. Java 语言的动态分派属于单分派，只根据 **方法接收者的实际类型** 一个宗量进行选择。

## 虚拟机动态分派的实现
动态分派在虚拟机中执行的非常频繁，而且方法查找的过程要在类的方法元数据中搜索合适的目标，从性能上考虑，不太可能进行如此频繁的搜索，需要进行性能上的优化。

**一种基础而且常见的优化手段是为类型在方法区中建立一个虚方法表(VirtualMethod Table)。**
![虚方法表](https://s1.ax1x.com/2020/07/16/UDyNqA.png)
{% note success no-icon %}
**虚方法表中存放着各个方法的实际入口地址。**
如果某个方法在子类中没有被重写，那子类的虚方法表中的地址入口和父类相同方法的地址入口是一致的，都指向父类的实现入口。如果子类中重写了这个方法，子类虚方法表中的地址也会被替换为指向子类实现版本的入口地址。

在图中，`Son`重写了来自`Father`的全部方法，因此`Son`的方法表没有指向`Father`类型数据的箭头。但是`Son`和`Father`都没有重写来自`Object`的方法，所以它们的方法表中所有从`Object`继承来的方法都指向了`Object`的数据类型。
{% endnote %}

# 参考资料
1. 《深入理解Java虚拟机》
2. https://github.com/TangBean/understanding-the-jvm/blob/master/Ch2-Java%E8%99%9A%E6%8B%9F%E6%9C%BA%E7%A8%8B%E5%BA%8F%E6%89%A7%E8%A1%8C/02-%E8%99%9A%E6%8B%9F%E6%9C%BA%E5%AD%97%E8%8A%82%E7%A0%81%E6%89%A7%E8%A1%8C%E5%BC%95%E6%93%8E_01-%E6%96%B9%E6%B3%95%E8%B0%83%E7%94%A8.md
