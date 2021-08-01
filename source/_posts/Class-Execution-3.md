---
title: JVM系列（六）-- 字节码执行机制(Part 3)
date: 2020-07-16 17:27:51
tags:
- JVM
- 字节码
- 动态类型语言支持
- 基于栈的字节码解释执行引擎
categories: 
- Java后端
- JVM
copyright: true
---
# 动态类型语言支持
**动态类型语言，就是类型检查的主体过程在运行期，而非编译期的编程语言。**

动/静态类型语言各自的优点？
+ 动态类型语言：灵活性高，开发效率高。
+ 静态类型语言：编译器提供了严谨的类型检查，类型相关的问题能在编码的时候就发现。
<!--more-->

# 动态类型语言
根据前面提到的动态类型语言的定义，我们将举两个例子来介绍一下**什么是“类型检查”和什么是“在编译期还是运行期进行”**。
```Java
public static void main(String[] args){
    int [][][] array = new int[1][0][-1];
}
```
{% note success no-icon %}
上面这段Java代码能够正常编译，但运行的时候会出现`NegativeArraySizeException`异常。

在《Java虚拟机规范》中明确规定了`NegativeArraySizeException`是一个运行时异常（`Runtime Exception`），通俗一点说，运行时异常就是指只要代码不执行到这一行就不会出现问题。

与运行时异常相对应的概念是连接时异常，例如很常见的`NoClassDefFoundError`便属于连接时异常，即使导致连接时异常的代码放在一条根本无法被执行到的路径分支上，类加载时也照样会抛出异常。
{% endnote %}
不过，在C语言里，**语义相同的代码就会在GCC编译期就直接报错**，而不是等到运行时才出现异常。

由此看来，一门语言的哪一种检查行为要在运行期进行，哪一种检查要在编译期进行并没有什么必然的因果逻辑关系，**关键是在语言规范中人为设立的约定**。

Java虚拟机层面提供的动态类型支持：
+ `invokedynamic` 指令 
> `Lambda` 表达式就是通过 `invokedynamic` 指令实现的。
+ `java.lang.invoke` 包

# java.lang.invoke包
这个包的主要目的是在之前单纯依靠符号引用来确定调用的目标方法这条路之外，**提供一种新的动态确定目标方法的机制，称为“方法句柄”（MethodHandle）。**

## 方法句柄的使用
1. 获得方法的参数描述，第一个参数是方法返回值的类型，之后的参数是方法的入参。
```Java
 MethodType mt = MethodType.methodType(void.class, String.class);
``` 
2. 获取一个普通方法的调用
```Java
 /**
  * 需要的参数：
  * 1. 被调用方法所属类的类对象
  * 2. 方法名
  * 3. MethodType 对象 mt
  * 4. 调用该方法的对象
  */
 MethodHandle.lookup().findVirtual(receiver.getClass(), "方法名", mt).bindTo(receiver);
```
3. 获取一个父类方法的调用：
```Java
 /**
  * 需要的参数：
  * 1. 被调用方法所属类的类对象
  * 2. 方法名
  * 3. MethodType 对象 mt
  * 4. 调用这个方法的类的类对象
  */
 MethodHandle.lookup().findSpecial(GrandFather.class, "方法名", mt, getClass());
```
4. 通过 `MethodHandle mh` 执行方法：
```Java
 /* 
 invoke() 和 invokeExact() 的区别：
 - invokeExact() 要求更严格，要求严格的类型匹配，方法的返回值类型也在考虑范围之内
 - invoke() 允许更加松散的调用方式
 */
 mh.invoke("Hello world");
 mh.invokeExact("Hello world");
```

## 使用示例
```Java
public class MethodHandleTest {
    static class ClassA {
        public void println(String s) {
            System.out.println(s);
        }
    }

    public static void main(String[] args) throws Throwable {
        /*
        obj的静态类型是Object，是没有println方法的，
        但通过方法句柄，无论obj最终是哪个实现类，下面这句都能正确调用到println方法
         */
        Object obj = System.currentTimeMillis() % 2 == 0 ? System.out : new ClassA();
        /*
        invoke()和invokeExact()的区别：
        - invokeExact()要求更严格，要求严格的类型匹配，方法的返回值类型也在考虑范围之内
        - invoke()允许更加松散的调用方式
         */
        getPrintlnMH(obj).invoke("Hello world");
        getPrintlnMH(obj).invokeExact("Hello world");
    }

    private static MethodHandle getPrintlnMH(Object receiver) 
        	throws NoSuchMethodException, IllegalAccessException {
        /* MethodType代表方法类型，第一个参数是方法返回值的类型，之后的参数是方法的入参 */
        MethodType mt = MethodType.methodType(void.class, String.class);
        /*
        lookup()方法来自于MethodHandles.lookup，
        这句的作用是在指定类中查找符合给定的方法名称、方法类型，并且符合调用权限的方法句柄
        */
        /*
        因为这里调用的是一个虚方法，按照Java语言的规则，方法第一个参数是隐式的，代表该方法的接收者，
        也即是this指向的对象，这个参数以前是放在参数列表中进行传递，现在提供了bindTo()方法来完成这件事情
        */
        return MethodHandles.lookup().findVirtual(receiver.getClass(), "println", mt).bindTo(receiver);
    }
}
```
`MethodHandles.lookup` 中 3 个方法对应的字节码指令：

+ `findStatic()`：对应 `invokestatic`
+ `findVirtual()：`对应 `invokevirtual` & `invokeinterface`
+ `findSpecial()：`对应 `invokespecial`

`MethodHandle` 和 `Reflection `的区别
+ **本质区别：** 它们都在模拟方法调用，但是
 + `Reflection` 模拟的是 Java 代码层次的调用；
 + `MethodHandle` 模拟的是字节码层次的调用。
+ **包含信息的区别：**
 + `Reflection` 的 `Method `对象包含的信息多，包括：方法签名、方法描述符、方法的各种属性的Java端表达方式、方法执行权限等；
 + `MethodHandle` 对象包含的信息比较少，既包含与执行该方法相关的信息。


 # 实战演示
 ```Java
 class Test{

     class GrandFather{
         void thinking(){
             System.out.println("I am grandfather");
         }
     }

     class Father extends GrandFather{
         void thinking(){
             System.out.println("I am father");
         }
     }

     class Son extends Father{
         void thinking(){
             try{
                 // 获取方法的类型
                 MethodType mt = MethodType.methodType(void.class);
                 // 实现动态方法调用
                 MethodHandle mh = lookup().findSpecial(GrandFather.class,"thinking",mt,getClass());
                 // 执行该方法
                 mh.invoke(this);
             }catch(Throwable e){

             }
         }
     }

     public static void main(String[] args){
         (new Test().new Son()).thinking();
         /* 
         实现了调用祖父类的方法
         输出：
         I am grandfather 
         */
     }
 }
 ```
{% note success no-icon %}
**在Java程序中，可以通过`“super”`关键字很方便地调用到父类中的方法，但却无法访问祖类的方法呢？**

原因是在`Son`类的`thinking()`方法中根本无法获取到一个实际类型是`GrandFather`的对象引用，而`invokevirtual`指令的分派逻辑是固定的，只能按照方法接收者的实际类型进行分派，这个逻辑完全固化在虚拟机中，程序员无法改变。
{% endnote %}

# 基于栈的字节码解释执行引擎
前面一章我们提到，**基于栈的解释执行，是真正地执行方法地字节码**。这里的栈是Part 1中提到的，**栈帧中的操作数栈**。
## 解释执行
先通过 `javac` 将代码编译成字节码，虚拟机再通过加载字节码文件，**解释执行**字节码文件生成机器码，解释执行的流程如下：
```
词法分析 -> 语法分析 -> 形成抽象语法树 -> 遍历语法树生成线性字节码指令流
```
# 指令集分类
## 基于栈的指令集
+ **优点：**
 + 可移植：寄存器由硬件直接提供，程序如果直接依赖这些硬件寄存器，会不可避免的受到硬件的约束；
 + 代码更紧凑：字节码中每个字节对应一条指令，多地址指令集中还需要存放参数；
 + 编译器实现更简单：不需要考虑空间分配问题，所需的空间都在栈上操作。
+ **缺点：** 执行速度稍慢
 + 完成相同的功能，需要更多的指令，因为出入栈本身就产生相当多的指令；
 + 频繁的栈访问导致频繁的内存访问，对于处理器而言，内存是执行速度的瓶颈。

**示例：两数相加**
```Java
 iconst_1  // 把常量1入栈
 iconst_1
 iadd      // 把栈顶两元素出栈相加，结果再放回栈顶
 istore_0  // 把栈顶值存入局部变量表第0个Slot中
```
# 基于寄存器的指令集
**示例：两数相加**
```Java
mov  eax, 1 // 把EAX寄存器的值设为1
add  eax, 1 // 把这个值加1，结果就保存在EAX寄存器里面
```

# 执行过程分析
```Java
public class Architecture {
    
    public int calc() {
        int a = 100;
        int b = 200;
        int c = 300;
        return (a + b) * c;
    }

    public static void main(String[] args) {
        Architecture architecture = new Architecture();
        architecture.calc();
    }
    /*
    calc函数的字节码分析：
    public int calc();
    descriptor: ()I
    flags: ACC_PUBLIC
    Code:
    stack=2, locals=4, args_size=1 
    // stack=2，说明需要深度为2的操作数栈
    // locals=4，说明需要4个Slot的局部变量表
    // args_size=1, 说明方法参数的个数为1，这里为默认隐藏的this
    
    0: bipush 100                  // 将单字节的整型常数值push到操作数栈
    2: istore_1                    // 将操作数栈顶的整型值出栈并存放到第一个局部变量Slot中
    3: sipush 200
    6: istore_2
    7: sipush 300
    10: istore_3
    11: iload_1                    // 将局部变量表第一个Slot中的整型值复制到操作数栈顶
    12: iload_2
    13: iadd                       // 将操作数栈中头两个元素出栈并相加，将结果重新入栈
    14: iload_3
    15: imul                       // 将操作数栈中头两个元素出栈并相乘，将结果重新入栈
    16: ireturn                    // 返回指令，结束方法执行，将操作数栈顶的整型值返回给此方法的调用者
    */
}
```
# 参考链接
1. 《深入理解Java虚拟机》
2. https://github.com/TangBean/understanding-the-jvm/blob/master/Ch2-Java%E8%99%9A%E6%8B%9F%E6%9C%BA%E7%A8%8B%E5%BA%8F%E6%89%A7%E8%A1%8C/02-%E8%99%9A%E6%8B%9F%E6%9C%BA%E5%AD%97%E8%8A%82%E7%A0%81%E6%89%A7%E8%A1%8C%E5%BC%95%E6%93%8E_01-%E6%96%B9%E6%B3%95%E8%B0%83%E7%94%A8.md
3. https://github.com/TangBean/understanding-the-jvm/blob/master/Ch2-Java%E8%99%9A%E6%8B%9F%E6%9C%BA%E7%A8%8B%E5%BA%8F%E6%89%A7%E8%A1%8C/02-%E8%99%9A%E6%8B%9F%E6%9C%BA%E5%AD%97%E8%8A%82%E7%A0%81%E6%89%A7%E8%A1%8C%E5%BC%95%E6%93%8E_02-%E5%9F%BA%E4%BA%8E%E6%A0%88%E7%9A%84%E5%AD%97%E8%8A%82%E7%A0%81%E8%A7%A3%E9%87%8A%E6%89%A7%E8%A1%8C%E5%BC%95%E6%93%8E.md
