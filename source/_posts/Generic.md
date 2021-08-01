---
title: Java泛型
date: 2020-07-14 08:55:48
tags:
- Java
- 泛型
categories: 
- Java后端
- Java语言基础
quicklink: true
---
# Free Talk
Java 泛型（generics）是 JDK 5 中引入的一个新特性, 泛型提供了编译时类型安全检测机制，该机制允许程序员在编译时检测到非法的类型。
**泛型的本质是参数化类型，也就是说所操作的数据类型被指定为一个参数。**
[廖雪峰](https://www.liaoxuefeng.com/wiki/1252599548343744/1265102638843296)、[菜鸟](https://www.runoob.com/java/java-generics.html)
<!--more-->
# 什么是泛型？
在讲解什么是泛型之前，我们先观察Java标准库提供的`ArrayList`，它可以看作“可变长度”的数组，因为用起来比数组更方便。

实际上`ArrayList`内部就是一个`Object[]`数组，配合存储一个当前分配的长度，就可以充当“可变数组”：
```Java
public class ArrayList {
    private Object[] array;//是私有属性
    private int size;
    public void add(Object e) {...}
    public void remove(int index) {...}
    public Object get(int index) {...}
}
```
如果用上述`ArrayList`存储`String`类型，会有这么几个缺点：
+ 需要强制转型；
+ 不方便，易出错。

例如，代码必须这么写：
```Java
ArrayList list = new ArrayList();
list.add("Hello");
// 获取到Object，必须强制转型为String:
String first = (String) list.get(0);

list.add(new Integer(123));
// ERROR: ClassCastException:
// 发生"误转型",Integer转为String
String second = (String) list.get(1);
```

为了解决这个问题，我们必须把`ArrayList`变成一种模板：`ArrayList<T>`，代码如下：
```Java
public class ArrayList<T> {
    private T[] array;// T可以是任意的class
    private int size;
    public void add(T e) {...}
    public void remove(int index) {...}
    public T get(int index) {...}
}
```
这样一来，我们就实现了：编写一次模版，可以创建任意类型的`ArrayList`：
```Java
// 创建可以存储String的ArrayList:
ArrayList<String> strList = new ArrayList<String>();
// 创建可以存储Float的ArrayList:
ArrayList<Float> floatList = new ArrayList<Float>();
// 创建可以存储Person的ArrayList:
ArrayList<Person> personList = new ArrayList<Person>();
```

因此，泛型就是定义一种模板，例如`ArrayList<T>`，然后在代码中为用到的类创建对应的`ArrayList<类型>`，由编译器针对类型作检查。

## 小结
1. 泛型就是编写模板代码来适应任意类型；

2. 泛型的好处是使用时不必对类型进行强制转换，它通过编译器对类型进行检查；

3. 注意泛型的继承关系：可以把`ArrayList<Integer>`向上转型为`List<Integer>`（T不能变！），但不能把`ArrayList<Integer>`向上转型为`ArrayList<Number>`（T不能变成父类）。

# 使用泛型
使用`ArrayList`时，如果不定义泛型类型时，泛型类型实际上就是`Object`。
当我们定义泛型类型`<String>`后，`List<T>`的泛型接口变为强类型`List<String>`：
```Java
// 无编译器警告:
List<String> list = new ArrayList<String>();
list.add("Hello");
list.add("World");
// 无强制转型:
String first = list.get(0);
String second = list.get(1);
```

编译器如果能自动推断出泛型类型，就可以省略后面的泛型类型。例如，对于下面的代码：
```Java
List<Number> list = new ArrayList<Number>();
```
编译器看到泛型类型`List<Number>`就可以自动推断出后面的`ArrayList<T>`的泛型类型必须是`ArrayList<Number>`，因此，可以把代码简写为：
```Java
// 可以省略后面的Number，编译器可以自动推断泛型类型：
List<Number> list = new ArrayList<>();
```
## 泛型接口
**除了`ArrayList<T>`使用了泛型，还可以在接口中使用泛型。**例如，`Arrays.sort(Object[])`可以对任意数组进行排序，但待排序的元素必须实现`Comparable<T>`这个泛型接口：
```Java
public interface Comparable<T> {
    /**
     * 返回-1: 当前实例比参数o小
     * 返回0: 当前实例与参数o相等
     * 返回1: 当前实例比参数o大
     */
    int compareTo(T o);
}
```
可以直接对`String`数组进行排序：
```Java
// sort
import java.util.Arrays;

public class Main {
    public static void main(String[] args) {
        String[] ss = new String[] { "Orange", "Apple", "Pear" };
        Arrays.sort(ss);
        System.out.println(Arrays.toString(ss));
        // [Apple, Orange, Pear]
        }
}
```
这是因为`String`本身已经实现了`Comparable<String>`接口。如果换成我们自定义的`Person`类型就会得到`ClassCastException`，即无法将`Person`转型为`Comparable`。我们修改代码，让`Person`实现`Comparable<T>`接口：
```Java
// sort
import java.util.Arrays;

public class Main {
    public static void main(String[] args) {
        Person[] ps = new Person[] {
            new Person("Bob", 61),
            new Person("Alice", 88),
            new Person("Lily", 75),
        };
        Arrays.sort(ps);
        System.out.println(Arrays.toString(ps));
    }
}
class Person implements Comparable<Person> {
    String name;
    int score;
    Person(String name, int score) {
        this.name = name;
        this.score = score;
    }
    public int compareTo(Person other) {
        return this.name.compareTo(other.name);
        // 可以正确实现按name进行排序。
        // [Alice,88, Bob,61, Lily,75]
        // 按score从高到低排序
        // return this.score > other.score ? -1 : this.score == other.score ? 0 : 1;
        // [Alice,88, Lily,75, Bob,61]
    }
    public String toString() {
        return this.name + "," + this.score;
    }
}
```
## 通配符
+ ？ 表示不确定的 Java 类型
+ T (type) 表示具体的一个 Java 类型
+ K V (key value) 分别代表 Java 键值中的Key Value
+ E (element) 代表Element

## 小结
1. 使用泛型时，把泛型参数`<T>`替换为需要的`class`类型，例如：`ArrayList<String>，ArrayList<Number>`等；

2. 可以省略编译器能自动推断出的类型，例如：`List<String> list = new ArrayList<>();`；

3. 不指定泛型参数类型时，编译器会给出警告，且只能将`<T>`视为`Object`类型；

4. 可以在接口中定义泛型类型，实现此接口的类必须实现正确的泛型类型


