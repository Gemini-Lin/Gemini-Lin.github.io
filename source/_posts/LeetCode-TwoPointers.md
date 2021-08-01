---
title: LeetCode-TwoPointers
date: 2020-10-19 15:50:21
tags:
- LeetCode
- Two Pointers
categories: 
- LeetCode
---

# Free Talk

之前刷题的时候，经常遇到双指针问题，打算写一篇专题，系统刷一下，总结一下常用的解题方法。

<!--more-->

# Finished Problem

![image-20201019155221355](https://i.loli.net/2020/10/19/Qkpdb7eHJIFD89U.png)

# 颜色分类

 [75. 颜色分类](https://leetcode-cn.com/problems/sort-colors/)

## 双指针

```java
class Solution {
    public void sortColors(int[] nums) {
        // 能不能用一次扫描实现呢
        // 用两个指针来存放
        // left 表示 白色的元素的索引位置
        // right 表示 蓝色的元素的索引位置
        int left = 0;
        int right = nums.length - 1;

        // 更新 left 、 right
        for(int i = 0; i < nums.length ; i ++ ){
            if(nums[i] < 1){
                left ++;
            }
            if(nums[i] > 1){
                right --;
            }
        }

        for(int i = 0; i < nums.length ; i ++ ){
            if(i < left){
                nums[i] = 0;
            }else if(i > right){
                nums[i] = 2;
            }else{
                nums[i] = 1;
            }   
        }

    }
}
```

### 执行结果

![image-20201019160529591](https://i.loli.net/2020/10/19/7NgDrK36xvUR81L.png)

# 环形链表

 [141. 环形链表](https://leetcode-cn.com/problems/linked-list-cycle/)

## 集合存放

```java
/**
 * Definition for singly-linked list.
 * class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) {
 *         val = x;
 *         next = null;
 *     }
 * }
 */
public class Solution {
    public boolean hasCycle(ListNode head) {
        // 该从哪里判断链表有环呢？
        // 可以通过一个集合来存放，集合中的元素不会重复
        Set<ListNode> set = new HashSet<ListNode>();
        while(head != null ){
            if(!set.add(head)){
                return true;
            }
            head = head.next;
        }
        return false;
    }
}
```

### 执行结果

![image-20201019163127631](https://i.loli.net/2020/10/19/ATIZypSjnLKsl3F.png)

## 快慢指针

```java
/**
 * Definition for singly-linked list.
 * class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) {
 *         val = x;
 *         next = null;
 *     }
 * }
 */
public class Solution {
    public boolean hasCycle(ListNode head) {
        // 龟兔赛跑
        // 设置快慢指针
        // 算法核心思想：
        // 假设兔子去追乌龟，兔子每次走两步，乌龟走一步
        // 如果链表中有环，则兔子会追上乌龟
        
        if(head == null || head.next == null){
            return false;
        }

        ListNode slow = head.next;
        ListNode fast = head.next.next;

        while(slow != fast){
            if(fast == null || fast.next == null){
                return false;
            }
            slow = slow.next;
            fast = fast.next.next;
        }

        return true;
    }
}
```

### 执行结果

![image-20201019163840414](https://i.loli.net/2020/10/19/XPC8tfOVzihWTJ1.png)

# 环形链表 II

[142. 环形链表 II](https://leetcode-cn.com/problems/linked-list-cycle-ii/)

## 快慢指针

```java
/**
 * Definition for singly-linked list.
 * class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) {
 *         val = x;
 *         next = null;
 *     }
 * }
 */
public class Solution {
    public ListNode detectCycle(ListNode head) {
        // 空间复杂度为 o(1) 
        // 用之前提到的快慢指针解决
        // 因为返回的要求发生了改变
        // 必须返回入环的第一个节点
        // 这边需要有一个数学的推理过程
        // 假设:
        // 链表头到环的入口 的长度为 a
        // 环的长度为 b
        // 但快慢指针相遇时
        // f = 2s;
        // f = s + nb;
        // f = 2nb, s = nb;
        // 因此此时让 链表头 和 慢指针 一起开始走
        // 当它们相遇时，即为入口环地址


        if(head == null || head.next == null){
            return null;
        }

        ListNode fast = head;
        ListNode slow = head;

        while(true){
            if(fast == null || fast.next == null) return null;
            fast = fast.next.next;
            slow = slow.next;
            if(fast == slow) break;
        }

        ListNode pre = head;
        while(pre != slow){
            pre = pre.next;
            slow = slow.next;
        }

        return pre;
    
    }
}
```

### 执行结果

![image-20201021105544204](https://i.loli.net/2020/10/21/TgtD4lO8Ke7PakY.png)

# 反转链表

[206. 反转链表](https://leetcode-cn.com/problems/reverse-linked-list/)

## 双指针迭代

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public ListNode reverseList(ListNode head) {
        // 双指针迭代
        ListNode pre = null;
        ListNode cur = head;
        while(cur != null){
            // 将当前的节点的后一点指针 指向前面的点
            ListNode tmp = cur.next;
            cur.next = pre;
            // 将节点往后迭代
            pre = cur;
            cur = tmp;
        }
        return pre;
    }
}
```

### 执行截图

![image-20201021113345742](https://i.loli.net/2020/10/21/wYQLUmKBGXsk2Hl.png)

# 回文链表

 [234. 回文链表](https://leetcode-cn.com/problems/palindrome-linked-list/)

## 链表反转 + 快慢指针

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public boolean isPalindrome(ListNode head) {
        // 思路确定中间的节点
        // 将中间节点后的链表反转
        // 遍历比较链表节点的值是否相同
        if(head == null || head.next == null) return true;
        ListNode mid = generateMiddle(head);
        ListNode rvs = reverseList(mid);
        while(rvs != null){
            if( rvs.val != head.val ){
                return false;
            }
            rvs = rvs.next;
            head = head.next;
        }
        return true;
    }

    // 用快慢指针
    public ListNode generateMiddle(ListNode head){
        ListNode slow = head;
        ListNode fast = head;
        while(fast != null && fast.next != null){
            slow = slow.next;
            fast = fast.next.next;     
        }
        return slow;
    }

    // 链表节点反转
    public ListNode reverseList(ListNode head){
        ListNode pre = null;
        ListNode cur = head;

        while(cur != null){
            ListNode tmp = cur.next;
            cur.next = pre;
            pre = cur;
            cur = tmp;
        }

        return pre;
    }
}
```

### 执行截图

![image-20201021191130303](https://i.loli.net/2020/10/21/znKEecOftswu9WC.png)

# 移动零

[283. 移动零](https://leetcode-cn.com/problems/move-zeroes/)

## 指针记录

```java
class Solution {
    public void moveZeroes(int[] nums) {
        // 只要一个指针就可以
        // 如果遍历的指针是非零的，就把放在左边
        // 遍历结束后，j 的位置就是 0 应该开始存放的数组下标

        int j = 0;
        for(int i = 0 ; i < nums.length ; i ++ ){
            if(nums[i] != 0){
                nums[j ++] = nums[i];
            }
        }

        for(int i = j ; i < nums.length ; i ++ ){
            nums[i] = 0;
        }
    }
}
```

### 执行结果

![image-20201021213835444](https://i.loli.net/2020/10/21/loUx7zLa8MKIqV3.png)

## 一次遍历

```java
class Solution {
    public void moveZeroes(int[] nums) {
    // 看了大神的解法
    // 利用了快排的思路
    // 以中间点 0 为区分点
    // 把不等于 0 的值 放在左边
    // 等于 0 的值 放在右边
    // 当遍历到不等于的点时
    // 交换两侧的点，并且让中间点自增，直到找到临界点

    int j = 0;
    for(int i = 0; i < nums.length ; i ++ ){
        if(nums[i] != 0){
            int tmp = nums[i];
            nums[i] = nums[j];
            nums[j ++] = tmp;
        }
    }
    
    }
}
```

### 执行结果

![image-20201021215727428](https://i.loli.net/2020/10/21/FJ6bQpjYfCLTUxu.png)

# 寻找重复数

[287. 寻找重复数](https://leetcode-cn.com/problems/find-the-duplicate-number/)

## 二分法

```java
class Solution {
    public int findDuplicate(int[] nums) {
        // 第一想法是用哈希表存放
        // 但是看了一下要求，只能使用 O(1) 的额外空间
        // 于是被迫看了题解，提到了二分法，时间复杂度为 N log N
        // 思路：
        // 将数组中的点，与中间值做比较，
        // 如果小于等于中间值的点的数量大于中间值，说明重复的数在中间点左侧
        // 因此不断地缩小范围，直到left right 相等时

        int left = 0;
        int right = nums.length - 1;

        while(left < right){
            int mid = (left + right) >>> 1;
            int count = 0;

            for(int num: nums){
                if(num <= mid){
                    count ++;
                }
            }

            if(count > mid){
                right = mid;
            }else{
                left = mid + 1;
            }
        }

        return left;       
    }
}
```

### 执行结果

![image-20201022092035770](https://i.loli.net/2020/10/22/WLbgaUq1F9VcCwf.png)

# 完结撒花

![image-20201022092209651](https://i.loli.net/2020/10/22/qNnw8WehmxuDMvX.png)