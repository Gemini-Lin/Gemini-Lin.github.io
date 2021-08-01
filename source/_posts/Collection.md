---
title: Java集合(Collection)
date: 2020-07-14 10:22:23
tags:
- Java
- 集合
categories: 
- Java后端
- Java语言基础
quicklink: true
---
# Free Talk
**什么是集合（Collection）？集合就是“由若干个确定的元素所构成的整体”。**
在Java中，如果一个Java对象可以在内部持有若干其他Java对象，并对外提供访问接口，我们把这种Java对象称为集合。
[廖雪峰](https://www.liaoxuefeng.com/wiki/1252599548343744/1265109905179456)、[JavaGuide](https://snailclimb.gitee.io/javaguide/#/docs/java/collection/Java%E9%9B%86%E5%90%88%E6%A1%86%E6%9E%B6%E5%B8%B8%E8%A7%81%E9%9D%A2%E8%AF%95%E9%A2%98)
<!--more-->
# 集合概览
从下图可以看出，在 `Java` 中除了以` Map `结尾的类之外， 其他类都实现了 `Collection` 接口。
并且，以 `Map` 结尾的类都实现了 `Map` 接口。
![Collection](https://s1.ax1x.com/2020/07/14/UN9vl9.png)
# Why need it?
**当我们需要保存一组类型相同的数据的时候，我们应该是用一个容器来保存，**这个容器就是数组，但是，使用数组存储对象具有一定的弊端， 因为我们在实际开发中，存储的数据的类型是多种多样的，于是，就出现了“集合”，集合同样也是用来存储多个数据的。

数组的缺点是一旦声明之后，长度就不可变了；同时，声明数组时的数据类型也决定了该数组存储的数据的类型；而且，数组存储的数据是有序的、可重复的，特点单一。 但是集合提高了数据存储的灵活性，**Java 集合不仅可以用来存储不同类型不同数量的对象，还可以保存具有映射关系的数据。**

# 集合框架
## List
+ **`Arraylist：`**Object[ ]数组
+ **`Vector：`**Object[ ]数组
+ **`LinkedList：`**双向链表(JDK1.6 之前为循环链表，JDK1.7 取消了循环)

## Set
+ **`HashSet`（无序，唯一）**: 基于 `HashMap` 实现的，底层采用 `HashMap` 来保存元素
+ **`LinkedHashSet`**：`LinkedHashSet` 是 `HashSet` 的子类，并且其内部是通过 `LinkedHashMap` 来实现的。
+ **`TreeSet`（有序，唯一）**： 红黑树(自平衡的排序二叉树)

## Map
+ `HashMap`： JDK1.8 之前 `HashMap` 由数组+链表组成的，数组是 `HashMap` 的主体，链表则是主要为了解决哈希冲突而存在的（“拉链法”解决冲突）。JDK1.8 以后在解决哈希冲突时有了较大的变化，当链表长度大于阈值（默认为 8）（将链表转换成红黑树前会判断，如果当前数组的长度小于 64，那么会选择先进行数组扩容，而不是转换为红黑树）时，将链表转化为红黑树，以减少搜索时间
+ `LinkedHashMap`： `LinkedHashMap` 继承自 `HashMap`，所以它的底层仍然是基于拉链式散列结构即由数组和链表或红黑树组成。另外，`LinkedHashMap` 在上面结构的基础上，增加了一条双向链表，使得上面的结构可以保持键值对的插入顺序。同时通过对链表进行相应的操作，实现了访问顺序相关逻辑。
+` Hashtable`： 数组+链表组成的，数组是 `HashMap` 的主体，链表则是主要为了解决哈希冲突而存在的
+ `TreeMap`： 红黑树（自平衡的排序二叉树）

# List
在集合类中，`List`是最基础的一种集合：它是一种有序列表。

`List`的行为和数组几乎完全相同：`List`内部按照放入元素的先后顺序存放，每个元素都可以通过索引确定自己的位置，`List`的索引和数组一样，从0开始。

数组和`List`类似，也是有序结构，如果我们使用数组，在添加和删除元素的时候，会非常不方便。例如，从一个已有的数组`{'A', 'B', 'C', 'D', 'E'}`中删除索引为`2`的元素：
![List](https://s1.ax1x.com/2020/07/14/UNPt8e.png)

**这个“删除”操作实际上是把`'C'`后面的元素依次往前挪一个位置，而“添加”操作实际上是把指定位置以后的元素都依次向后挪一个位置，腾出来的位置给新加的元素。这两种操作，用数组实现非常麻烦。**

**因此，在实际应用中，需要增删元素的有序列表，我们使用最多的是`ArrayList`。**实际上，`ArrayList`在内部使用了数组来存储所有元素。例如:
1. 一个`ArrayList`拥有5个元素，实际数组大小为6（即有一个空位）：
![ArrayList1](https://s1.ax1x.com/2020/07/14/UNPza6.png)
2. 当添加一个元素并指定索引到`ArrayList`时，`ArrayList`自动移动需要移动的元素：
![ArrayList2](https://s1.ax1x.com/2020/07/14/UNi1Mj.png)
3. 然后，往内部指定索引的数组位置添加一个元素，然后把`size`加1：
![ArrayList3](https://s1.ax1x.com/2020/07/14/UNiJZq.png)
4. 继续添加元素，但是数组已满，没有空闲位置的时候，`ArrayList`先创建一个更大的新数组，然后把旧数组的所有元素复制到新数组，紧接着用新数组取代旧数组：
![ArrayList4](https://s1.ax1x.com/2020/07/14/UNiWWD.png)
5. 现在，新数组就有了空位，可以继续添加一个元素到数组末尾，同时`size`加1：
![ArrayList5](https://s1.ax1x.com/2020/07/14/UNFEpF.png)

可见，`ArrayList`把添加和删除的操作封装起来，让我们操作`List`类似于操作数组，却不用关心内部元素如何移动。

# Iterator 迭代器
```Java
public interface Iterator<E> {
    //集合中是否还有元素
    boolean hasNext();
    //获得集合中的下一个元素
    E next();
    ......
}
```
`Iterator` 对象称为迭代器（设计模式的一种），迭代器可以对集合进行遍历，但每一个集合内部的数据结构可能是不尽相同的，所以每一个集合存和取都很可能是不一样的，虽然我们可以人为地在每一个类中定义 `hasNext()` 和 `next()` 方法，但这样做会让整个集合体系过于臃肿。于是就有了迭代器。

**迭代器的定义为：提供一种方法访问一个容器对象中各个元素，而又不需要暴露该对象的内部细节。**

## 作用
`Iterator` 主要是用来遍历集合用的，它的特点是更加安全，因为它可以确保，在当前遍历的集合元素被更改的时候，就会抛出 `ConcurrentModificationException` 异常。

Java中的`Iterator`功能比较简单，并且只能单向移动：

　　(1) 使用方法`iterator()`要求容器返回一个`Iterator`。第一次调用`Iterator`的`next()`方法时，它返回序列的第一个元素。注意：`iterator()`方法是`java.lang.Iterable`接口,被`Collection`继承。

　　(2) 使用`next()`获得序列中的下一个元素。

　　(3) 使用`hasNext()`检查序列中是否还有元素。

　　(4) 使用`remove()`将迭代器新返回的元素删除。

　　`Iterator`是Java迭代器最简单的实现，为`List`设计的`ListIterator`具有更多的功能，它可以从两个方向遍历`List`，也可以从`List`中插入和删除元素。[牛客网](https://www.nowcoder.com/questionTerminal/8863f297b1fc4bbca6de95528b6051e1)
## 使用
我们通过使用迭代器来遍历 `HashMap`，演示一下迭代器 `Iterator` 的使用。
```Java
// 泛型Map
Map<Integer, String> map = new HashMap();
map.put(1, "Java");
map.put(2, "C++");
map.put(3, "PHP");
// 使用方法iterator()要求容器返回一个Iterator。
Iterator<Map.Entry<Integer, String>> iterator = map.entrySet().iterator();
// while循环，调用hasNext()方法，直到序列中无元素
while (iterator.hasNext()) {
  // 调用next()方法，获取序列中的下一个元素
  Map.Entry<Integer, String> entry = iterator.next();
  // 遍历输出每个元素的Key、Value
  System.out.println(entry.getKey() + entry.getValue());
}
```