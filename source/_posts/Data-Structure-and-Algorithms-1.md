---
title: 数据结构与算法篇(一) -- 红黑树
date: 2020-05-29 01:59:55
tags:
- 数据结构
categories: 
- 课程总结
- 数据结构
copyright: true
---
# 红黑树原理

## 二叉查找树
二叉查找树具有以下的特性：
1. 某节点的左子树节点值仅包含小于该节点值
2. 某节点的右子树节点值仅包含大于该节点值
3. 左右子树每个也必须是二叉查找树

简单的讲：*越小的放在越左边*。
<!--more-->
**你以为的二叉查找树**
![image](https://s1.ax1x.com/2020/05/30/tQrsc6.png)
**变态的二叉查找树**
![image](https://s1.ax1x.com/2020/05/30/tQrfNd.png)
这种畸形的二叉查找树就会退化成**链表**，查找节点的时间复杂度就会从**O($ log_2^n $)退化成O(n)**。而根据我们在小学二年级就学过的[去除顶端优势]，我们引入了红黑树，达到树的平衡。

## 红黑树简介
**R-B Tree**，全称是Red-Black Tree，又称为“红黑树”，它一种特殊的**二叉查找树**。红黑树的每个节点上都有存储位表示节点的颜色，可以是红(Red)或黑(Black)。

### 特性
1. 每个节点或者是黑色，或者是红色。(*没啥用*)
2. 根节点是**黑色**。
3. *每个叶子节点是黑色的*。
4. **如果一个节点是红色的，则它的子节点必须是黑色的。**
5. **从一个节点到该节点的子孙节点的所有路径上包含相同数目的黑节点。**
> 第5点确保没有一条路径会比其他路径长出两倍。

示意图如下：
![image](https://s1.ax1x.com/2020/05/30/tQs3UH.png)

### 应用
主要是用来储存有序的数据，时间复杂度为O($log_2^n$)，效率非常高。
例如：Java集合中的**TreeSet、TreeMap**，C++ STL中的**set、map**，以及Linux中**虚拟内存**的管理等。

# Recolor and Rotation

**Recolor:** 重新标记节点为黑色或红色
**Rotation:** 旋转，达到树的平衡

## 插入
当我们插入一个新的节点X时，要遵循如下公式：
1. 将新插入的节点标记为红色
2. 如果X是根节点，则标记为黑色
3. 如果X的parent不是黑色，同时X也不是root:
    + 如果X的uncle是红色
        1. 将parent和uncle标记为黑色
        2. 将grand parent 标记为红色
        3. 让X的颜色和grand parent的颜色相同，重复2.3步骤
    + 如果X的uncle是黑色
        1. 左左
        2. 左右
        3. 右右
        4. 右左

> 第一个左指的是parent节点是在grand parent的左边还是右边
> 第二个左指的是此节点X是在parent的左边还是右边        

![image](https://s1.ax1x.com/2020/05/30/tQsY8I.png)

跟着上面的公式走:

1. 将新插入的 X 节点标记为红色
2. 发现 X 的 parent (P) 同样为红色，这违反了红黑树的第三条规则「不能有两个连续相邻的红色节点」
3. 发现 X 的 uncle (U) 同样为红色
4. 将 P 和 U 标记为黑色
5. 将 X 和 X 的 grand parent (G) 标记为相同的颜色，即红色，继续重复公式 2、3
6. 发现 G 是根结点，标记为黑色
7. 结束

### 左左
**p在g的左边，x在p的左边**
1. 右旋g
2. 交换g和p的颜色
![image](https://s1.ax1x.com/2020/05/30/tQsdr8.png)

### 左右
1. 左旋p
2. 变成左左了
![image](https://s1.ax1x.com/2020/05/30/tQsDaQ.png)

### 右右
1. 左旋g
2. 交换g和p的颜色
![image](https://s1.ax1x.com/2020/05/30/tQsc2q.png)

### 右左
1. 右旋p
2. 变成右右了
![image](https://s1.ax1x.com/2020/05/30/tQsWrT.png)

## 案例演示
插入 10，20，30，15 到一个空树中

1. 向空树中第一次插入数字 10，肯定是 root 节点
2. root 节点标记成黑色
![image](https://image-static.segmentfault.com/313/178/313178228-5d37b7346452f_articlex)
1. 向树中插入新节点 20，标记为红色
2. 20 > 10，并发现 10 没有叶子节点，将新节点 20 作为 10 的右孩子
![image](https://image-static.segmentfault.com/310/491/310491414-5d37b7319f447_articlex)
1. 向树中插入新节点 30，标记为红色
2. 30 > 10，查找 10 的右子树，找到 20
3. 30 > 20，继续查找 20 的右子树，发现 20 没有叶子节点，将值插在此处
4. 30 和 20 节点都为红色，30 为右孩子，20 也为右孩子，触发了**右右情况**
5. 通过一次旋转，提起 20 节点
6. 20 节点是根结点，标记为黑色
![image](https://image-static.segmentfault.com/386/112/3861123538-5d37b733ce90e_articlex)
1. 向树中插入新节点 15，标记为红色
2. 通过比对大小和判断是否有叶子节点，最终插值为 10 节点的右孩子
3. 15 和 10 节点都为红色，15 的 uncle 节点 30 也为红色
4. 按照公式，将 15 的 parent 10 和 uncle 30 更改为黑色
5. 让 15 节点 grand parent 20 的颜色与 15 节点的颜色一样，变为红色
6. 20 为根结点，将其改为黑色
![image](https://image-static.segmentfault.com/842/419/842419664-5d37b734b8439_articlex)

# C语言实现
## 基本定义
``` C
#define RED        0    // 红色节点
#define BLACK    1    // 黑色节点

typedef int Type;

// 红黑树的节点
typedef struct RBTreeNode{
    unsigned char color;        // 颜色(RED 或 BLACK)
    Type   key;                    // 关键字(键值)
    struct RBTreeNode *left;    // 左孩子
    struct RBTreeNode *right;    // 右孩子
    struct RBTreeNode *parent;    // 父结点
}Node, *RBTree;

// 红黑树的根
typedef struct rb_root{
    Node *node;
}RBRoot;
```
## 左旋
![image](https://s1.ax1x.com/2020/05/30/tQWj1J.png)
``` C
#define RED        0    // 红色节点
#define BLACK    1    // 黑色节点

typedef int Type;

// 红黑树的节点
typedef struct RBTreeNode{
    unsigned char color;        // 颜色(RED 或 BLACK)
    Type   key;                    // 关键字(键值)
    struct RBTreeNode *left;    // 左孩子
    struct RBTreeNode *right;    // 右孩子
    struct RBTreeNode *parent;    // 父结点
}Node, *RBTree;

// 红黑树的根
typedef struct rb_root{
    Node *node;
}RBRoot;
```

## 右旋
![image](https://s1.ax1x.com/2020/05/30/tQWvc9.png)
``` C
/* 
 * 对红黑树的节点(y)进行右旋转
 *
 * 右旋示意图(对节点y进行左旋)：
 *            py                               py
 *           /                                /
 *          y                                x                  
 *         /  \      --(右旋)-->            /  \                     #
 *        x   ry                           lx   y  
 *       / \                                   / \                   #
 *      lx  rx                                rx  ry
 * 
 */
static void rbtree_right_rotate(RBRoot *root, Node *y)
{
    // 设置x是当前节点的左孩子。
    Node *x = y->left;

    // 将 “x的右孩子” 设为 “y的左孩子”；
    // 如果"x的右孩子"不为空的话，将 “y” 设为 “x的右孩子的父亲”
    y->left = x->right;
    if (x->right != NULL)
        x->right->parent = y;

    // 将 “y的父亲” 设为 “x的父亲”
    x->parent = y->parent;

    if (y->parent == NULL) 
    {
        //tree = x;            // 如果 “y的父亲” 是空节点，则将x设为根节点
        root->node = x;            // 如果 “y的父亲” 是空节点，则将x设为根节点
    }
    else
    {
        if (y == y->parent->right)
            y->parent->right = x;    // 如果 y是它父节点的右孩子，则将x设为“y的父节点的右孩子”
        else
            y->parent->left = x;    // (y是它父节点的左孩子) 将x设为“x的父节点的左孩子”
    }

    // 将 “y” 设为 “x的右孩子”
    x->right = y;

    // 将 “y的父节点” 设为 “x”
    y->parent = x;
}
```
## 添加
### 直接插入
``` C
/*
 * 添加节点：将节点(node)插入到红黑树中
 *
 * 参数说明：
 *     root 红黑树的根
 *     node 插入的结点        // 对应《算法导论》中的z
 */
static void rbtree_insert(RBRoot *root, Node *node)
{
    Node *y = NULL;
    Node *x = root->node;

    // 1. 将红黑树当作一颗二叉查找树，将节点添加到二叉查找树中。
    while (x != NULL)
    {
        y = x;
        if (node->key < x->key)
            x = x->left;
        else
            x = x->right;
    }
    rb_parent(node) = y;

    if (y != NULL)
    {
        if (node->key < y->key)
            y->left = node;                // 情况2：若“node所包含的值” < “y所包含的值”，则将node设为“y的左孩子”
        else
            y->right = node;            // 情况3：(“node所包含的值” >= “y所包含的值”)将node设为“y的右孩子” 
    }
    else
    {
        root->node = node;                // 情况1：若y是空节点，则将node设为根
    }

    // 2. 设置节点的颜色为红色
    node->color = RED;

    // 3. 将它重新修正为一颗二叉查找树
    rbtree_insert_fixup(root, node);
}
```
### 修正
``` C
/*
 * 添加节点：将节点(node)插入到红黑树中
 *
 * 参数说明：
 *     root 红黑树的根
 *     node 插入的结点        // 对应《算法导论》中的z
 */
static void rbtree_insert(RBRoot *root, Node *node)
{
    Node *y = NULL;
    Node *x = root->node;

    // 1. 将红黑树当作一颗二叉查找树，将节点添加到二叉查找树中。
    while (x != NULL)
    {
        y = x;
        if (node->key < x->key)
            x = x->left;
        else
            x = x->right;
    }
    rb_parent(node) = y;

    if (y != NULL)
    {
        if (node->key < y->key)
            y->left = node;                // 情况2：若“node所包含的值” < “y所包含的值”，则将node设为“y的左孩子”
        else
            y->right = node;            // 情况3：(“node所包含的值” >= “y所包含的值”)将node设为“y的右孩子” 
    }
    else
    {
        root->node = node;                // 情况1：若y是空节点，则将node设为根
    }

    // 2. 设置节点的颜色为红色
    node->color = RED;

    // 3. 将它重新修正为一颗二叉查找树
    rbtree_insert_fixup(root, node);
}
```
## 删除
### 直接删除
``` C
/*
 * 添加节点：将节点(node)插入到红黑树中
 *
 * 参数说明：
 *     root 红黑树的根
 *     node 插入的结点        // 对应《算法导论》中的z
 */
static void rbtree_insert(RBRoot *root, Node *node)
{
    Node *y = NULL;
    Node *x = root->node;

    // 1. 将红黑树当作一颗二叉查找树，将节点添加到二叉查找树中。
    while (x != NULL)
    {
        y = x;
        if (node->key < x->key)
            x = x->left;
        else
            x = x->right;
    }
    rb_parent(node) = y;

    if (y != NULL)
    {
        if (node->key < y->key)
            y->left = node;                // 情况2：若“node所包含的值” < “y所包含的值”，则将node设为“y的左孩子”
        else
            y->right = node;            // 情况3：(“node所包含的值” >= “y所包含的值”)将node设为“y的右孩子” 
    }
    else
    {
        root->node = node;                // 情况1：若y是空节点，则将node设为根
    }

    // 2. 设置节点的颜色为红色
    node->color = RED;

    // 3. 将它重新修正为一颗二叉查找树
    rbtree_insert_fixup(root, node);
}
```
### 修正
``` C 
/*
 * 添加节点：将节点(node)插入到红黑树中
 *
 * 参数说明：
 *     root 红黑树的根
 *     node 插入的结点        // 对应《算法导论》中的z
 */
static void rbtree_insert(RBRoot *root, Node *node)
{
    Node *y = NULL;
    Node *x = root->node;

    // 1. 将红黑树当作一颗二叉查找树，将节点添加到二叉查找树中。
    while (x != NULL)
    {
        y = x;
        if (node->key < x->key)
            x = x->left;
        else
            x = x->right;
    }
    rb_parent(node) = y;

    if (y != NULL)
    {
        if (node->key < y->key)
            y->left = node;                // 情况2：若“node所包含的值” < “y所包含的值”，则将node设为“y的左孩子”
        else
            y->right = node;            // 情况3：(“node所包含的值” >= “y所包含的值”)将node设为“y的右孩子” 
    }
    else
    {
        root->node = node;                // 情况1：若y是空节点，则将node设为根
    }

    // 2. 设置节点的颜色为红色
    node->color = RED;

    // 3. 将它重新修正为一颗二叉查找树
    rbtree_insert_fixup(root, node);
}
```
# Free Talk
我打算在今后的板块中都增加一个Free Talk的环节，讲讲自己的感受。
其实之前一直有听说过红黑树的名字，就是没有深入了解，正好在家待着没事干，就打算写一个数据结构与算法的系列，就当做是复习和进一步学习吧。
这次的博客主要是参考了两篇文章，一篇是比较详细的讲解算法实现和原理，一篇特点是动图易懂。自己写完了这篇博客也只能算是懂了第二篇，算法的后半部分确实没啃动。感觉一开始就将红黑树有些硬核，面试应该不可能有手写代码吧。
接下打算就是把JVM的系列和数据结构与算法的系列穿插着写，然后算法的系列会加入LeetCode模块，JVM的系列还没有考虑好要怎么用代码实现学习。
**To be a better man!**

参考链接：
[博客园](https://www.cnblogs.com/skywang12345/p/3245399.html)
[segment](https://segmentfault.com/a/1190000020118044)