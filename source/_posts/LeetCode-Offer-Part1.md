---
title: LeetCode-Offer-Part1
date: 2020-11-09 16:24:15
tags:
- LeetCode
- 剑指 Offer
categories: 
- LeetCode
---

# Free Talk

这系列文章用来记录 剑指 Offer 第二版 的 75 题题解。

Part 1 ： 1 - 15 题

<!--more-->

# Problems

![image-20201109163055750](https://i.loli.net/2020/11/09/VZjrQEMeJB14v6C.png)

# 用两个栈实现队列

[剑指 Offer 09. 用两个栈实现队列](https://leetcode-cn.com/problems/yong-liang-ge-zhan-shi-xian-dui-lie-lcof/)

## 辅助栈

```java
class CQueue {
    // 第二次做这种类型的算法题
    Stack<Integer> stack1 ;
    Stack<Integer> stack2 ;

    public CQueue() {
        // 我现在有个很傻的方法
        // 用一个栈来存放，另外一个栈用来辅助删除操作
        stack1 = new Stack<Integer>();
        stack2 = new Stack<Integer>();
    }
    
    public void appendTail(int value) {
        stack1.push(value);
    }
    
    public int deleteHead() {
        if(stack1.isEmpty()) return - 1;
        while(!stack1.isEmpty()){
            stack2.push(stack1.pop());
        }
        int res = stack2.pop();
        while(!stack2.isEmpty()){
            stack1.push(stack2.pop());
        }
        return res;
    }
}

/**
 * Your CQueue object will be instantiated and called as such:
 * CQueue obj = new CQueue();
 * obj.appendTail(value);
 * int param_2 = obj.deleteHead();
 */
```

### 执行结果

![image-20201109164645087](https://i.loli.net/2020/11/09/XewqEg9pVDNzyWu.png)

## 辅助栈优化

```java
class CQueue {
    // 第二次做这种类型的算法题
    Stack<Integer> stack1 ;
    Stack<Integer> stack2 ;

    public CQueue() {
        // 我现在有个很傻的方法
        // 用一个栈来存放，另外一个栈用来辅助删除操作
        stack1 = new Stack<Integer>();
        stack2 = new Stack<Integer>();
    }
    
    public void appendTail(int value) {
        stack1.push(value);
    }
    
    public int deleteHead() {
        // 这边其实可以做一个优化，不需要每次都把第一个栈的元素放到第二个栈内
        // 栈二专门用来维护删除的元素
        if(!stack2.isEmpty()) return stack2.pop();
        if(stack1.isEmpty()) return - 1;
        
        while(!stack1.isEmpty()){
            stack2.push(stack1.pop());
        }
        
        return stack2.pop();
    }
}

/**
 * Your CQueue object will be instantiated and called as such:
 * CQueue obj = new CQueue();
 * obj.appendTail(value);
 * int param_2 = obj.deleteHead();
 */
```

### 执行结果

![image-20201109170057618](https://i.loli.net/2020/11/09/SZR4T5ycBftVxiq.png)

# 斐波那契数列 

[剑指 Offer 10- I. 斐波那契数列](https://leetcode-cn.com/problems/fei-bo-na-qi-shu-lie-lcof/)

## 无脑递归

```java
class Solution {
    public int fib(int n) {
        if(n == 0) return 0;
        if(n == 1) return 1;
        return fib(n - 1) + fib(n - 2);
    }
}
```

### 执行结果

![image-20201109171234613](https://i.loli.net/2020/11/09/sEMkvNeTUzVmqSb.png)

没有考虑到溢出的问题，不能用递归了。

## 循环 + 溢出处理

```java
class Solution {
    public int fib(int n) {
        int a = 0, b = 1, sum = 0;
        
        if(n == 1) return 1;

        for(int i = 1; i < n ; i ++){
            sum = (a + b) % 1000000007;
            a = b;
            b = sum;
        }

        return sum;
    }
}
```

### 执行结果

![image-20201109171601885](https://i.loli.net/2020/11/09/ILPJkcKSG1hFbBY.png)

# 数组中重复的数字

[剑指 Offer 03. 数组中重复的数字](https://leetcode-cn.com/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/)

## 排序 + 遍历

```java
class Solution {
    public int findRepeatNumber(int[] nums) {
        // 将数组排序，如果没有重复的元素，那么元素的数组索引是等于元素的值
        Arrays.sort(nums);
        int res = 0 ;
        
        for(int i = 0; i < nums.length - 1; i ++){
            if(nums[i] == nums[i + 1]) {
                res = nums[i];
                break;
            }
        }

        return res;
    }
}
```

### 执行结果

![image-20201109172913174](https://i.loli.net/2020/11/09/CH4av2M6DJstIUG.png)

## 原地置换

```java
class Solution {
    public int findRepeatNumber(int[] nums) {
        // 做一下优化，可以不用先都排好队，然后再比较
        int tmp ;
        
        for(int i = 0; i < nums.length ; i ++){
            while(nums[i] != i){
                if(nums[i] == nums[nums[i]]){
                    return nums[i];
                }
                tmp = nums[i];
                nums[i] = nums[tmp];
                nums[tmp] = tmp;
            }
        }

        return -1;
    }
}
```

### 执行结果

![image-20201109173639650](https://i.loli.net/2020/11/09/Wb6V7wTHSQY3Kaz.png)

# 二维数组中的查找

[面试题4. 二维数组中的查找](https://leetcode-cn.com/problems/er-wei-shu-zu-zhong-de-cha-zhao-lcof/)

## 右上角开始（从下或左走）

```java
class Solution {
    public boolean findNumberIn2DArray(int[][] matrix, int target) {
        int m = matrix.length;
        if(m == 0) return false;
        int n = matrix[0].length;

        int i = 0;
        int j = n - 1;

        while(i < m && j >= 0){
            if(matrix[i][j] == target) return true;
            if(matrix[i][j] > target){
                j --;
                continue;
            }
            if(matrix[i][j] < target){
                i ++;
            }
        }

        return false;
    }
}
```

### 执行结果

![image-20201109185153685](https://i.loli.net/2020/11/09/mdr1OzAyXf8v7la.png)

# 青蛙跳台阶问题

[剑指 Offer 10- II. 青蛙跳台阶问题](https://leetcode-cn.com/problems/qing-wa-tiao-tai-jie-wen-ti-lcof/)

## 斐波那契数列变形

```java
class Solution {
    public int numWays(int n) {
        // f(n) = f(n - 1) + f(n - 2) 
        int count = 0;
        int sum = 0;
        int a = 0, b = 1;

        if(n == 0) return 1;

        for(int i = 0; i < n ; i ++){
            count = (a + b) % 1000000007;
            a = b;
            b = count;
        }

        return count;
    }
}
```

### 执行结果

![image-20201109190848253](https://i.loli.net/2020/11/09/4l1TJvDcgoKChAu.png)

# 旋转数组的最小数学

[剑指 Offer 11. 旋转数组的最小数字](https://leetcode-cn.com/problems/xuan-zhuan-shu-zu-de-zui-xiao-shu-zi-lcof/)

## 遍历+ 比较+ 提前结束

```java
class Solution {
    public int minArray(int[] numbers) {
        for(int i = 0; i < numbers.length - 1 ;  i ++ ){
            if(numbers[i] > numbers[i + 1]){
                return numbers[i + 1];
            }
        }
        return numbers[0];
    }
}
```

### 执行结果

![image-20201109225604588](https://i.loli.net/2020/11/09/u3V8GKNzrntvWYl.png)

# 矩阵中的路径

[剑指 Offer 12. 矩阵中的路径](https://leetcode-cn.com/problems/ju-zhen-zhong-de-lu-jing-lcof/)

## DFS + 剪枝

```java
class Solution {
    public boolean exist(char[][] board, String word) {
     // 利用 DFS 深度优先遍历，去一直递归下去，再做剪枝处理

     char[] Word = word.toCharArray();
     for(int i = 0; i < board.length ; i ++ ){
         for(int j = 0; j < board[0].length ; j ++ ){
             if(dfs(board, Word, i , j ,0)) return true;
         }
     }
    
     return false;    
    }

    public boolean dfs(char[][] board, char[] Word, int i, int j ,int k){
        if(i < 0 || i >= board.length || j < 0 || j >= board[0].length
        || board[i][j] != Word[k]) return false;
        if(k == Word.length - 1) return true;

        char tmp = board[i][j];
        board[i][j] = 0;
        boolean res = dfs(board, Word, i - 1 , j, k + 1) || dfs(board, Word, i + 1 , j, k + 1) || dfs(board, Word, i , j - 1, k + 1) || dfs(board, Word, i , j + 1, k + 1);
        board[i][j] = tmp;
        return  res;
    }
}
```

### 执行结果

![image-20201109232230123](https://i.loli.net/2020/11/09/1BHsD2RlGjpE8AX.png)

# 替换空格

[剑指 Offer 05. 替换空格](https://leetcode-cn.com/problems/ti-huan-kong-ge-lcof/)

## 遍历 + 字符串修改

```java
class Solution {
    public String replaceSpace(String s) {
        // 直接遍历一次就行
        for(int i = 0; i < s.length() ; i ++ ){
            if(s.charAt(i) == ' '){
                s = s.substring(0, i) + "%20" + s.substring(i + 1, s.length());
            }
        }
        return s;
    }
}
```

### 执行结果

![image-20201110083019914](https://i.loli.net/2020/11/10/Kiraz3klVuvpTD5.png)

## 遍历 + 字符数组修改

```java
class Solution {
    public String replaceSpace(String s) {
        // 改为在字符数组上操作
        char[] S = new char[s.length() * 3];
        int count = 0;
        for(int i = 0; i < s.length() ; i ++ ){
            if(s.charAt(i) == ' '){
                S[count ++] = '%';
                S[count ++] = '2';
                S[count ++] = '0';
            }else{
                S[count ++] = s.charAt(i);
            }
        }
        // 需要把结尾的空余部分去除
        String res = new String(S, 0 , count);
        return res;
    }
}
```

### 执行结果

![image-20201110083725196](https://i.loli.net/2020/11/10/aAKYUdfyXN6EIq9.png)

# 机器人的运动范围

[剑指 Offer 13. 机器人的运动范围](https://leetcode-cn.com/problems/ji-qi-ren-de-yun-dong-fan-wei-lcof/)

## DFS  + 状态标记

```java
class Solution {
    int count = 0;
    public int movingCount(int m, int n, int k) {
        boolean[][] travel = new boolean[m][n];
        dfs(0, 0, m ,n ,k , travel);
        return count;
    }
     
    public void dfs(int i, int j, int m, int n ,int k, boolean[][] travel){
        if(i < 0 || i >= m || j < 0|| j >= n || travel[i][j] == true) return ;
        int x = 0;
        int tmpi = i;
        while(i >= 1){
            x += i % 10;
            i = i / 10;
        }
        i = tmpi;
        int y = 0;
        int tmpj = j;
        while(j >= 1){
            y += j % 10;
            j = j / 10;
        }
        j = tmpj;
        if(x + y > k) return;
        count ++;
        travel[i][j] = true;
        dfs(i + 1, j , m , n , k , travel);
        dfs(i - 1, j , m , n , k , travel);
        dfs(i , j - 1 , m , n , k , travel);
        dfs(i , j + 1 , m , n , k , travel);
        return;
    }
}
```

### 执行结果

![image-20201110093724264](https://i.loli.net/2020/11/10/xatnM2NW7Sy14lR.png)

# 从尾到头打印链表

[剑指 Offer 06. 从尾到头打印链表](https://leetcode-cn.com/problems/cong-wei-dao-tou-da-yin-lian-biao-lcof/)

## 链表长度 + 数组倒序

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
    public int[] reversePrint(ListNode head) {
        // 简单解法：用数组存放链表，然后数组倒序输出
        int count = 0;
        ListNode pre = head;
        while(head != null){
            count ++;
            head = head.next;
        }
        head = pre;
        int[] res = new int[count];
        count --;
        while(head != null){
            res[count --] = head.val;
            head = head.next;
        }
        return res;
    }

}
```

### 执行结果

![image-20201110094957588](https://i.loli.net/2020/11/10/1fYgjlBeyr9OiUI.png)

# 重建二叉树

[剑指 Offer 07. 重建二叉树](https://leetcode-cn.com/problems/zhong-jian-er-cha-shu-lcof/)

## 哈希表 + 深度优先 + 遍历拆分

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    HashMap<Integer, Integer> map = new HashMap<>();
    public TreeNode buildTree(int[] preorder, int[] inorder) {
        // 前序遍历：根 左 右
        // 中序遍历： 左 根 右
        for(int i = 0; i < inorder.length; i ++ ){
            map.put(inorder[i], i);
        }
        return dfs(preorder, 0, preorder.length, inorder, 0, inorder.length);
    }

    public TreeNode dfs(int[] preorder, int pStart, int pEnd, int[] inorder, int iStart, int iEnd){

        if(pStart == pEnd) return null;
        int p = preorder[pStart];
        TreeNode root = new TreeNode(p);
        int i_index = map.get(p);
        int left = i_index - iStart;

        root.left = dfs(preorder, pStart + 1, pStart + left + 1, inorder, iStart, i_index);
        root.right = dfs(preorder, pStart + left + 1, pEnd, inorder, i_index + 1, iEnd);

        return root;        
    }
}
```

### 执行结果

![image-20201110101014460](https://i.loli.net/2020/11/10/Mh8n4O5YLWbimfS.png)

# 减绳子

[剑指 Offer 14- I. 剪绳子](https://leetcode-cn.com/problems/jian-sheng-zi-lcof/)

## 动态规划

```java
class Solution {
    public int cuttingRope(int n) {
        // 可以采用动态规划的思想
        // dp[i] 为 长度为 i 的 绳子能够得到的最大乘积
        // dp[i] = Math.max(dp[i - j]*j,(i - j) *j);
        int[] dp = new int[n + 1];
        dp[0] = 1;
        dp[1] = 1;
        for(int i = 2 ; i < n + 1 ; i ++ ){
            for(int j = 1 ; j < i ; j ++ ){
                dp[i] = Math.max(dp[i],Math.max(dp[i - j] * j, (i - j) * j));
            }
        }

        return dp[n];
    }
}
```

### 执行结果

![image-20201110125111734](https://i.loli.net/2020/11/10/xC7TnKs6oR2ueHl.png)

# 剪绳子 II

[剑指 Offer 14- II. 剪绳子 II](https://leetcode-cn.com/problems/jian-sheng-zi-ii-lcof/)

## 数学公式推导

```java
class Solution {
    public int cuttingRope(int n) {
        // 动态规划因为存在溢出，没法进行比较。刚刚试了很多次，太累了
        // 可以使用数学公式推导得到，当每段绳子都为3是，乘积最大
        if(n == 2) return 1;
        if(n == 3) return 2;
        if(n == 4) return 4;
        // 这边 必须设置为 long
        long res = 1;

        while(n > 4){
            res *= 3 ;
            res %= 1000000007;
            n -= 3;
        }

        return (int)(res * n % 1000000007);
    }
}
```

### 执行结果

![image-20201110131438132](https://i.loli.net/2020/11/10/C6WRmzhd52ug3Yy.png)

# 合并两个排序的链表

[剑指 Offer 25. 合并两个排序的链表](https://leetcode-cn.com/problems/he-bing-liang-ge-pai-xu-de-lian-biao-lcof/)

## 遍历比较

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
    public ListNode mergeTwoLists(ListNode l1, ListNode l2) {
        ListNode pre = new ListNode(0);
        ListNode node = pre;
        while(l1 != null && l2 != null){
            if(l1.val > l2.val){
                pre.next = l2;
                l2 = l2.next;
                pre = pre.next;
            }else{
                pre.next = l1;
                l1 = l1.next;
                pre = pre.next;
            }
        }

        while(l1 != null){
            pre.next = l1;
            l1 = l1.next;
            pre = pre.next;
        }

        while(l2 != null){
            pre.next = l2;
            l2 = l2.next;
            pre = pre.next;
        }

        return node.next;
    }
}
```

### 执行结果

![image-20201110144104201](https://i.loli.net/2020/11/10/KQeX6MGbx1PlCrL.png)

# 树的子结构

[剑指 Offer 26. 树的子结构](https://leetcode-cn.com/problems/shu-de-zi-jie-gou-lcof/)

## 双重递归

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    public boolean isSubStructure(TreeNode A, TreeNode B) {
        // 本来应该是一个双重递归，我刚刚却一直把它写在一个递归里面，导致思路特别乱
        return (A != null && B != null) && 
        (isSame(A, B) || isSubStructure(A.left, B) || isSubStructure(A.right , B));
    }

    public boolean isSame(TreeNode A, TreeNode B){
        if(B == null) return true;
        if(A == null || A.val != B.val ) return false;
        return isSame(A.left, B.left) && isSame(A.right, B.right);
    }
}
```

### 执行结果

![image-20201110152811879](https://i.loli.net/2020/11/10/OJ8PjHmvFW3t5Yk.png)

# 完结撒花

![image-20201110155014123](https://i.loli.net/2020/11/10/MyrQf49bIdwC3RH.png)

用了一天时间完成了第一部分 15 题。