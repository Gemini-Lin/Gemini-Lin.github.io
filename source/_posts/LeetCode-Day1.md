---
title: LeetCode体验篇
date: 2020-07-21 13:27:11
tags:
- LeetCode
- HOT100
categories: 
- LeetCode
---
# Free Talk
作为LeetCode新手，我选择了HOT100里的一下简单和中等及困难的题目来刷。
本篇文章是自己一周刷题的心得，主要内容为刷题的**心路历程、收获以及解题方法**。
![LeetCode](https://s1.ax1x.com/2020/07/24/UjVUyV.png)
<!--more-->
## 心路历程
一开始刷题的时候我是相当抗拒的，完全不会做。不会做的原因主要有两个方面：
**1. 常用的库函数方法的使用**
> 对于这一点是新手非常容易懵逼，解决途径可以一开始先查API，后面用多了常用方法就记住了。

**2. 特殊的解题技巧**
> 这个最好的方法就是不断地刷题积累经验，特别是注意复习总结，我现在的计划是每周日总结一下这周刷的题。

# 2 两数相加
题目：https://leetcode-cn.com/problems/add-two-numbers/
## 解题历程
1. 学会使用定义的类来使用链表
 ```java
ListNode L = new ListNode(0);
L.next = new ListNode(val);
```
2. 异常判断(考虑链表为空的情况)
```Java
// 使用三目运算符
int x = (l1 == null ? 0 : l1.val);
```
3. 特殊情况处理(最后一位是否为0)
```Java
if(add != 0){
    l.next = new ListNode(add);
}
```

## 完整代码
```Java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        ListNode pre = new ListNode(0);
        ListNode l = pre;
        int add = 0;
        int val = 0;

        while(l1 != null || l2 != null){
            int x = l1 == null ? 0: l1.val;
            int y = l2 == null ? 0: l2.val;
            val = x + y + add;
        
            add = val / 10;
            val = val % 10 ;
            l.next = new ListNode(val);
            l = l.next;

            if(l1 != null){l1 = l1.next;}
            if(l2 != null){l2 = l2.next;}
        }
        if(add != 0){
           l.next = new ListNode(add);
        }
        // 注意返回的链表
        return pre.next;
    }
}
```
# 3 无重复字符的最长子串
# 4 寻找两个正序数组的中位数
# 5 最长回文子串
# 10 正则表达式匹配
# 20 有效的括号
```Java
class Solution {

  // Hash table that takes care of the mappings.
  private HashMap<Character, Character> mappings;

  // Initialize hash map with mappings. This simply makes the code easier to read.
  public Solution() {
    this.mappings = new HashMap<Character, Character>();
    this.mappings.put(')', '(');
    this.mappings.put('}', '{');
    this.mappings.put(']', '[');
  }

  public boolean isValid(String s) {

    // Initialize a stack to be used in the algorithm.
    Stack<Character> stack = new Stack<Character>();

    for (int i = 0; i < s.length(); i++) {
      char c = s.charAt(i);

      // If the current character is a closing bracket.
      if (this.mappings.containsKey(c)) {

        // Get the top element of the stack. If the stack is empty, set a dummy value of '#'
        char topElement = stack.empty() ? '#' : stack.pop();

        // If the mapping for this bracket doesn't match the stack's top element, return false.
        if (topElement != this.mappings.get(c)) {
          return false;
        }
      } else {
        // If it was an opening bracket, push to the stack.
        stack.push(c);
      }
    }

    // If the stack still contains elements, then it is an invalid expression.
    return stack.isEmpty();
  }
}
```
