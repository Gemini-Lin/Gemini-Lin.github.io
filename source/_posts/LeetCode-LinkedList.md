---
title: LeetCode-LinkedList
date: 2020-10-25 20:09:08
tags:
- LeetCode
- Linked List
categories: 
- LeetCode
---

# Free Talk

链表是一种常用的数据结构，打算练练这个 Tags,  熟悉一下相关 API 调用。

<!--more-->

# Finished Problem

![image-20201025201127949](https://i.loli.net/2020/10/25/hQt8brH6CTULFnO.png)

# 合并K个升序链表

[23. 合并K个升序链表](https://leetcode-cn.com/problems/merge-k-sorted-lists/)

## 合并两个升序链表

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode() {}
 *     ListNode(int val) { this.val = val; }
 *     ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        // 傻瓜方法：将两个链表按升序合并
        // 还可以用 分治算法 做优化
        ListNode ans = null;
        for(int i = 0; i < lists.length; i ++ ){
            ans = mergeTwoLists(ans, lists[i]);
        }

        return ans;     
    }

    public ListNode mergeTwoLists(ListNode a, ListNode b){
        if(a == null || b == null){
            return a!= null ? a : b;
        }
        ListNode head = new ListNode(0);
        ListNode tail = head;

        while(a != null && b != null){
            if(a.val < b.val){
                tail.next = a;
                a = a.next;
            }else{
                tail.next = b;
                b = b.next;
            }
            tail = tail.next;
        }

        tail.next = (a != null) ? a : b;
        return head.next;
    }
}
```

### 执行截图

![image-20201025213437921](https://i.loli.net/2020/10/25/giYQXnMEwLVtzDZ.png)

# 排序链表

[148. 排序链表](https://leetcode-cn.com/problems/sort-list/)

## 快慢指针 + 链表升序合并 + 递归优化

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode() {}
 *     ListNode(int val) { this.val = val; }
 *     ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
class Solution {
    public ListNode sortList(ListNode head) {
        // 快慢指针 + 链表升序合并 + 递归优化

        if(head == null || head.next == null) return head;

        ListNode middle = middleNode(head);
        ListNode rightHead = middle.next;
        middle.next = null;
        
        ListNode left = sortList(head);
        ListNode right = sortList(rightHead);
        
        return sortTwoNodes(left, right);
    }

    public ListNode middleNode(ListNode head){
        if (head == null || head.next == null) {
            return head;
        }

        ListNode slow = head;
        ListNode fast = head.next;

        while(fast != null && fast.next != null){
            slow = slow.next;
            fast = fast.next.next;
        }

        return slow;
    }

    public ListNode sortTwoNodes(ListNode a, ListNode b){
        if(a == null || b == null){
            return a != null ? a : b;
        }

        ListNode head = new ListNode(0);
        ListNode tail = head;

        while(a != null && b != null){
            if(a.val < b.val){
                tail.next = a;
                a = a.next;
            }else{
                tail.next = b;
                b = b.next;
            }
            tail = tail.next;
        }

        tail.next = (a != null) ? a : b;    
        return head.next;
    }
}
```

### 执行结果

![image-20201026094349960](https://i.loli.net/2020/10/26/rnvye3aIdYUCzkc.png)

# 相交链表

[160. 相交链表](https://leetcode-cn.com/problems/intersection-of-two-linked-lists/)

## 我陪你慢慢走

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) {
 *         val = x;
 *         next = null;
 *     }
 * }
 */
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        // 走过的路程相同，速度一样，那么两个节点一定会相遇
        if(headA == null || headB == null) return null;
        ListNode preA = headA;
        ListNode preB = headB;

        while(headA != headB){
            headA = (headA == null) ? preB : headA.next;
            headB = (headB == null) ? preA : headB.next;
        }

        return headA;
    }
}
```

### 执行结果

![image-20201026103208733](https://i.loli.net/2020/10/26/KpfwHydMcNX51s7.png)

# 完结撒花

![image-20201026103244542](https://i.loli.net/2020/10/26/eZUMXAPOG75lEgx.png)

做链表的题，有点很舒服的感觉！！！