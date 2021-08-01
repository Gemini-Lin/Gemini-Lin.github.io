---
title: Java反射(Reflection)
date: 2020-07-11 16:28:34
tags:
- Java
- 反射
categories: 
- Java后端
- Java语言基础
quicklink: true
---
# Free Talk
本篇文章会从Class类、访问字段等角度深度理解Java反射的特性。
同时文章基本上都是直接照搬廖雪峰的反射博客，他真的写的太好了，通俗易懂，我有种班门弄斧的感觉，甚至产生放弃写博客的念头。
[廖雪峰博客](https://www.liaoxuefeng.com/wiki/1252599548343744/1264799402020448)
<!--more-->
# 简述
**Java的反射是指程序在运行期间可以拿到一个对象的所有信息。**
正常情况下，如果我们要调用一个对象的方法，或者访问一个对象的字段，通常会传入对象实例：

```Java
// Main.java
import com.itranswarp.learnjava.Person;

public class Main {
    String getFullName(Person p) {
        return p.getFirstName() + " " + p.getLastName();
    }
}
```
但是，如果不能获得`Person`类，只有一个`Object`实例，比如这样：
```Java
String getFullName(Object obj) {
    return ???
}
```
怎么办？有童鞋会说：强制转型啊！
```Java
String getFullName(Object obj) {
    Person p = (Person) obj;
    return p.getFirstName() + " " + p.getLastName();
}
```
强制转型的时候，你会发现一个问题：编译上面的代码，仍然需要引用`Person`类。不然，去掉`import`语句，你看能不能编译通过？

**所以，反射是为了解决在运行期，对某个实例一无所知的情况下，如何调用其方法。**

# Class类
`JVM`在执行过程中动态记载`class`类，`JVM`在第一次读取到一种`class`类型时，将其加载进内存中。
每加载一种`class`,`JVM`就为其创建一个`Class`类型的实例，并关联起来。
{% note success no-icon %}
这里的`Class`类型是一个名叫`Class`的`class`:
```Java
public final class Class {
    private Class() {}
}
```
{% endnote %}
通过`Class`实例获取`class`信息的方法称为反射（Reflection）。
获取`Class`实例的方法有以下三种。
## class方法
直接通过一个`class`的静态变量`class`获取：
```Java
Class cls = String.class;
```
## getClass()方法
如果我们有一个实例变量，可以通过该实例变量提供的`getClass()`方法获取：
```Java
String s = "Hello";
Class cls = s.getClass();
```
## Class.forName()方法
如果知道一个`class`的完整类名，可以通过静态方法`Class.forName()`获取：
```Java
Class cls = Class.forName("java.lang.String");
```
{% note success no-icon %}
因为`Class`实例在`JVM`中是唯一的，所以，上述方法获取的`Class`实例是同一个实例。可以用`==`比较两个`Class`实例：
```Java
Class cls1 = String.class;

String s = "Hello";
Class cls2 = s.getClass();

boolean sameClass = cls1 == cls2; // true
```
{% endnote %}
# 访问字段
对任意的一个`Object`实例，只要我们获取了它的`Class`，就可以获取它的一切信息。
我们先看看如何通过`Class`实例获取字段信息。`Class`类提供了以下几个方法来获取字段：
+ **`Field getField(name)：`**根据字段名获取某个public的field（包括父类）
{% note success no-icon %}
即获取name所对应的Public的字段
{% endnote %}
+ **`Field getDeclaredField(name)：`**根据字段名获取当前类的某个field（不包括父类）
{% note success no-icon %}
即获取name所对应的字段，可以是Public，也可以是Private
{% endnote %}
+ **`Field[] getFields()：`**获取所有public的field（包括父类）
+ **`Field[] getDeclaredFields()：`**获取当前类的所有field（不包括父类）

实例代码：
```Java
public class Main {
    public static void main(String[] args) throws Exception {
        // 上面提到第一种的class方法获取Class实例
        Class stdClass = Student.class;
        // 获取public字段"score":
        System.out.println(stdClass.getField("score"));
        // 获取继承的public字段"name":
        System.out.println(stdClass.getField("name"));
        // 获取private字段"grade":
        System.out.println(stdClass.getDeclaredField("grade"));
    }
}

class Student extends Person {
    public int score;
    private int grade;
}

class Person {
    public String name;
}
```
{% note success no-icon %}
上述代码首先获取`Student`的`Class`实例，然后，分别获取`public`字段、继承的`public`字段以及`private`字段，打印出的`Field`类似：
```Java
public int Student.score
public java.lang.String Person.name
private int Student.grade
```
{% endnote %}
一个`Field`对象包含了一个字段的所有信息：
+ `getName()：`返回字段名称，例如，`"name"`；
+ `getType()：`返回字段类型，也是一个`Class`实例，例如，`String.class`；
+ `getModifiers()：`返回字段的修饰符，它是一个`int`，不同的`bit`表示不同的含义。

以`String`类的`value`字段为例，它的定义是：
```Java
public final class String {
    private final byte[] value;
}
```
我们用反射获取该字段的信息，代码如下：
```Java
Field f = String.class.getDeclaredField("value");
f.getName(); // "value"
f.getType(); // class [B 表示byte[]类型
int m = f.getModifiers();
Modifier.isFinal(m); // true
Modifier.isPublic(m); // false
Modifier.isProtected(m); // false
Modifier.isPrivate(m); // true
Modifier.isStatic(m); // false
```
## 获取字段值
利用反射拿到字段的一个`Field`实例只是第一步，我们还可以拿到一个实例对应的该字段的值。

例如，对于一个`Person`实例，我们可以先拿到`name`字段对应的`Field`，再获取这个实例的`name`字段的值：
```Java
// reflection
import java.lang.reflect.Field;
public class Main {

    public static void main(String[] args) throws Exception {
        // 上面提到的第二种方法getClass()获取Class实例
        Object p = new Person("Xiao Ming");
        Class c = p.getClass();
        Field f = c.getDeclaredField("name");
        Object value = f.get(p);
        System.out.println(value); // "Xiao Ming"
    }
}

class Person {
    private String name;

    public Person(String name) {
        this.name = name;
    }
}
```
上述代码先获取`Class`实例，再获取`Field`实例，然后，用`Field.get(Object)`获取指定实例的指定字段的值。

运行代码，如果不出意外，会得到一个`IllegalAccessException`，这是因为`name`被定义为一个`private`字段，正常情况下，`Main`类无法访问`Person`类的`private`字段。要修复错误，可以将`private`改为`public`，或者，在调用`Object value = f.get(p);`前，先写一句：
```Java
f.setAccessible(true);
```
调用`Field.setAccessible(true)`的意思是，别管这个字段是不是`public`，一律允许访问。

可以试着加上上述语句，再运行代码，就可以打印出`private`字段的值。
{% note success no-icon %}
**有童鞋会问：如果使用反射可以获取`private`字段的值，那么类的封装还有什么意义？**

答案是正常情况下，我们总是通过`p.name`来访问`Person`的`name`字段，编译器会根据`public`、`protected`和`private`决定是否允许访问字段，这样就达到了数据封装的目的。

而反射是一种非常规的用法，使用反射，首先代码非常繁琐，其次，它更多地是给工具或者底层框架来使用，目的是在不知道目标实例任何信息的情况下，获取特定字段的值。

此外，`setAccessible(true)`可能会失败。如果`JVM`运行期存在`SecurityManager`，那么它会根据规则进行检查，有可能阻止`setAccessible(true)`。例如，某个`SecurityManager`可能不允许对`java`和`javax`开头的`package`的类调用`setAccessible(true)`，这样可以保证`JVM`核心库的安全。
{% endnote %}
## 设置字段值
通过`Field`实例既然可以获取到指定实例的字段值，自然也可以设置字段的值。

设置字段值是通过`Field.set(Object, Object)`实现的，**其中第一个`Object`参数是指定的实例，第二个`Object`参数是待修改的值。**示例代码如下：
```Java
// reflection
import java.lang.reflect.Field;

public class Main {

    public static void main(String[] args) throws Exception {
        // 创建Person对象实例
        Person p = new Person("Xiao Ming");
        // 获取实例name
        System.out.println(p.getName()); // "Xiao Ming"
        // 通过getClass()获取Class实例
        Class c = p.getClass();
        // 通过getDeclaredField(name)获取Field实例
        Field f = c.getDeclaredField("name");
        // 对于private字段，调用setAccessible()来允许访问
        f.setAccessible(true);
        // 使用Field.set(obj,obj)来修改实例的字段值
        f.set(p, "Xiao Hong");
        System.out.println(p.getName()); // "Xiao Hong"
    }
}

class Person {
    private String name;

    public Person(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name;
    }
}
```
{% note info no-icon %}
运行上述代码，打印的`name`字段从`Xiao Ming`变成了`Xiao Hong`，说明通过反射可以直接修改字段的值。

同样的，修改非`public`字段，需要首先调用`setAccessible(true)`。
{% endnote %}

## 小结
1. `Java`的反射API提供的`Field`类封装了字段的所有信息：
2. 通过`Class`实例的方法可以获取`Field`实例：`getField()`，`getFields()`，`getDeclaredField()`，`getDeclaredFields()`；
3. 通过`Field`实例可以获取字段信息：`getName()`，`getType()`，`getModifiers()`；
4. 通过`Field`实例可以读取或设置某个对象的字段，如果存在访问限制，要首先调用`setAccessible(true)`来访问非`public`字段。
5. 通过反射读写字段是一种非常规方法，它会破坏对象的封装。

# 调用方法
我们已经能通过`Class`实例获取所有`Field`对象，同样的，可以通过`Class`实例获取所有`Method`信息。`Class`类提供了以下几个方法来获取`Method：`
+ **`Method getMethod(name, Class...)：`**获取某个`public`的`Method`（包括父类）
+ **`Method getDeclaredMethod(name, Class...)：`**获取当前类的某个`Method`（不包括父类）
+ **`Method[] getMethods()：`**获取所有`public`的`Method`（包括父类）
+ **`Method[] getDeclaredMethods()：`**获取当前类的所有`Method`（不包括父类）

示例代码：
```Java
public class Main {
    public static void main(String[] args) throws Exception {
        Class stdClass = Student.class;
        // 获取public方法getScore，参数为String:
        System.out.println(stdClass.getMethod("getScore", String.class));
        // 获取继承的public方法getName，无参数:
        System.out.println(stdClass.getMethod("getName"));
        // 获取private方法getGrade，参数为int:
        System.out.println(stdClass.getDeclaredMethod("getGrade", int.class));
    }
}

class Student extends Person {
    public int getScore(String type) {
        return 99;
    }
    private int getGrade(int year) {
        return 1;
    }
}

class Person {
    public String getName() {
        return "Person";
    }
}
```
{% note info no-icon %}
上述代码首先获取`Student`的`Class`实例，然后，分别获取`public`方法、继承的`public`方法以及`private`方法，打印出的`Method`类似：
```Java
public int Student.getScore(java.lang.String)
public java.lang.String Person.getName()
private int Student.getGrade(int)
```
{% endnote %}
一个`Method`对象包含一个方法的所有信息：

+ `getName()：`返回方法名称，例如：`"getScore"`；
+ `getReturnType()：`返回方法返回值类型，也是一个`Class`实例，例如：String.class；
+ `getParameterTypes()：`返回方法的参数类型，是一个`Class`数组，例如：`{String.class, int.class}`；
+ `getModifiers()：`返回方法的修饰符，它是一个`int`，不同的`bit`表示不同的含义。

## 小结
Java的反射API提供的Method对象封装了方法的所有信息：
1. 通过`Class`实例的方法可以获取`Method`实例：`getMethod()`，`getMethods()`，`getDeclaredMethod()`，`getDeclaredMethods()`；
2. 通过`Method`实例可以获取方法信息：`getName()`，`getReturnType()`，`getParameterTypes()`，`getModifiers()`；
3. 通过`Method`实例可以调用某个对象的方法：`Object invoke(Object instance, Object... parameters)`；
4. 通过设置`setAccessible(true)`来访问非`public`方法；
5. 通过反射调用方法时，仍然遵循多态原则。