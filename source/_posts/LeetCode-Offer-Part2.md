---
title: LeetCode-Offer-Part2
date: 2020-11-10 15:51:17
tags:
- LeetCode
- 剑指 Offer
categories: 
- LeetCode
---

# Free Talk

争取在今天内完成第二部分的 15 题 LeetCode。

<!--more-->

# Problems

![image-20201110155257088](https://i.loli.net/2020/11/10/eJkYvQf2xbNCTOM.png)

# 二叉树的镜像

[剑指 Offer 27. 二叉树的镜像](https://leetcode-cn.com/problems/er-cha-shu-de-jing-xiang-lcof/)

## 递归 + 保存节点信息

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
    public TreeNode mirrorTree(TreeNode root) {
        return getMirror(root);
    }

    public TreeNode getMirror(TreeNode root){
        if(root == null) return null;
        TreeNode mirror = root;
        // 这边的保存节点的信息，是重中之重
        TreeNode tmp = root.right;
        // 因为这里的赋值操作，修改了 root.right 的数据
        mirror.right = getMirror(root.left);
        mirror.left = getMirror(tmp);
        return mirror;
    }
}
```

### 执行结果

![image-20201110195644646](https://i.loli.net/2020/11/10/ZzhSwJubfo3xm4v.png)

# 对称的二叉树

[剑指 Offer 28. 对称的二叉树](https://leetcode-cn.com/problems/dui-cheng-de-er-cha-shu-lcof/)

## 递归 + 左右遍历

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
    public boolean isSymmetric(TreeNode root) {
        // 直接比较递归比较左右节点一不一样
        return (root == null) ? true : isSame(root.left, root.right); 
    }

    public boolean isSame(TreeNode root, TreeNode mirror){
        if(root == null && mirror == null) return true;
        if(root == null || mirror == null ||  root.val != mirror.val) return false;
        return isSame(root.left, mirror.right) && isSame(root.right, mirror.left);
    }
}
```

### 执行结果

![image-20201110201927625](https://i.loli.net/2020/11/10/enq9hYGo6i8rxzv.png)

# 表示数值的字符串

[剑指 Offer 20. 表示数值的字符串](https://leetcode-cn.com/problems/biao-shi-shu-zhi-de-zi-fu-chuan-lcof/)

##　有限状态机（直接复制的）

```java
class Solution {
    public boolean isNumber(String s) {
        // 存在数字的形式组合有很多种
        // 1. 小数点只能出现一次
        // 2. 不能出现除 e E 外的字母
        // 3. e 的后面必须有数字
        // 4. 符号只能出现在第一位和 e 的后面
        // 这题的情况特别复杂，看了题解是用有限状态机写的，不打算自己写了
    
        Map[] states = {
            new HashMap<>() {{ put(' ', 0); put('s', 1); put('d', 2); put('.', 4); }}, // 0.
            new HashMap<>() {{ put('d', 2); put('.', 4); }},                           // 1.
            new HashMap<>() {{ put('d', 2); put('.', 3); put('e', 5); put(' ', 8); }}, // 2.
            new HashMap<>() {{ put('d', 3); put('e', 5); put(' ', 8); }},              // 3.
            new HashMap<>() {{ put('d', 3); }},                                        // 4.
            new HashMap<>() {{ put('s', 6); put('d', 7); }},                           // 5.
            new HashMap<>() {{ put('d', 7); }},                                        // 6.
            new HashMap<>() {{ put('d', 7); put(' ', 8); }},                           // 7.
            new HashMap<>() {{ put(' ', 8); }}                                         // 8.
        };
        int p = 0;
        char t;
        for(char c : s.toCharArray()) {
            if(c >= '0' && c <= '9') t = 'd';
            else if(c == '+' || c == '-') t = 's';
            else if(c == 'e' || c == 'E') t = 'e';
            else if(c == '.' || c == ' ') t = c;
            else t = '?';
            if(!states[p].containsKey(t)) return false;
            p = (int)states[p].get(t);
        }
        return p == 2 || p == 3 || p == 7 || p == 8;
    }
}
```

### 执行结果

![image-20201110203249488](https://i.loli.net/2020/11/10/HXOI9yKTcQufpkx.png)

# 调整数组顺利使得奇数位于偶数前面

[剑指 Offer 21. 调整数组顺序使奇数位于偶数前面](https://leetcode-cn.com/problems/diao-zheng-shu-zu-shun-xu-shi-qi-shu-wei-yu-ou-shu-qian-mian-lcof/)

## 指针记录 + 变换

```java
class Solution {
    public int[] exchange(int[] nums) {
        // 可以使用一个指针来记录奇数的位置
        int count = -1;
        for(int i = 0; i < nums.length ; i ++){
            if(nums[i] % 2 == 1){
                count ++;
                swap(nums, i , count);
            }
        }
        return nums;
    }

    public void swap(int[] nums, int i, int j){
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
}
```

### 执行结果

![image-20201110204013059](https://i.loli.net/2020/11/10/ZyrDEYWqJI8npH7.png)

# 二进制中 1 的个数

[剑指 Offer 15. 二进制中1的个数](https://leetcode-cn.com/problems/er-jin-zhi-zhong-1de-ge-shu-lcof/)

## 位运算 + 右移

```java
public class Solution {
    // you need to treat n as an unsigned value
    public int hammingWeight(int n) {
        int count = 0;
        while(n != 0){
            // 要用位运算,不能用 求余 , 要当成无符号来处理
            count += (n & 1);
            n >>>= 1;  
        }
        return count;
    }
}
```

### 执行结果

![image-20201110204900493](https://i.loli.net/2020/11/10/2oHOFUKaRLesXjC.png)

# 顺时针打印矩阵

[剑指 Offer 29. 顺时针打印矩阵](https://leetcode-cn.com/problems/shun-shi-zhen-da-yin-ju-zhen-lcof/)

## 上下边界收缩（边界可以相等）

```java
class Solution {
    public int[] spiralOrder(int[][] matrix) {
        // 其实我的做法也是上下左右四个边界，结果写成了递归去了，直接循环就可以
        if(matrix.length == 0) return new int[0];
        int left = 0, right = matrix[0].length - 1;
        int top = 0, bottom = matrix.length - 1;
        int[] res = new int[(right + 1)*(bottom + 1)];
        int index = 0;
        while(true){
            // 从左往右，上边界下移
            for(int i = left ; i <= right ; i ++ ) res[index ++] = matrix[top][i];
            if(++top > bottom) break;
            // 从上往下， 右边界左移
            for(int i = top ; i <= bottom ; i ++ ) res[index ++] = matrix[i][right];
            if(--right < left) break;
            // 从右往左， 下边界上移
            for(int i = right ; i >= left ; i -- ) res[index ++] = matrix[bottom][i];
            if(--bottom < top) break;
            // 从下往上， 左边界右移
            for(int i = bottom ; i >= top; i -- ) res[index ++] = matrix[i][left];
            if(++left > right) break;
        }
        return res; 
    }
}
```

### 执行结果

![image-20201110213705010](https://i.loli.net/2020/11/10/zHVUbalJdOr6scE.png)

# 打印链表中的倒数第K个节点

[剑指 Offer 22. 链表中倒数第k个节点](https://leetcode-cn.com/problems/lian-biao-zhong-dao-shu-di-kge-jie-dian-lcof/)

## 求长度

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
    public ListNode getKthFromEnd(ListNode head, int k) {
        int n = 0;
        ListNode pre = head;
        while(head != null){
            n ++;
            head = head.next;
        }
        head = pre;
        for(int i = 0; i < (n - k); i ++){
            head = head.next;
        }

        return head;
    }
}
```

### 执行结果

![image-20201110215321988](https://i.loli.net/2020/11/10/Hakc639FzwPjNSe.png)

# 数组的整数次方

[剑指 Offer 16. 数值的整数次方](https://leetcode-cn.com/problems/shu-zhi-de-zheng-shu-ci-fang-lcof/)

 ## 超时解法

```java
class Solution {
    public double myPow(double x, int n) {
        // 这种解法会超时
        double res = 1;
        if(n > 0){
            while(n != 0){
                res *= x;
                n --;
            }
        }

        if(n < 0){
            n = Math.abs(n);
            while(n != 0){
                res /= x;
                n --;
            }
        }

        return res;
    }
}
```

### 执行结果

![image-20201110220745053](https://i.loli.net/2020/11/10/QCU8ycxDiH5j3dN.png)

## 位运算优化

```java
class Solution {
    public double myPow(double x, int n) {
        // 利用位运算优化
        if(x == 0) return 0;
        long b = n;
        double res = 1;
        if(n < 0){
            b = -b;
            x = (1 / x);
        }

        while(b != 0){
            if((b & 1) == 1) res *= x;
            x *= x;
            b >>>= 1;
        }

        return res;
    }
}
```

### 执行结果

![image-20201110221127463](https://i.loli.net/2020/11/10/mgbxNMEOd2iQA8r.png)

# 打印从 1 到最大的 n 位数

[剑指 Offer 17. 打印从1到最大的n位数](https://leetcode-cn.com/problems/da-yin-cong-1dao-zui-da-de-nwei-shu-lcof/)

## 长度打印

```java
class Solution {
    public int[] printNumbers(int n) {
        int length = 1;

        while(n != 0){
            length *= 10;
            n --;
        }

        int[] res = new int[length - 1];
        
        for(int i = 0; i < length - 1; i ++ ){
            res[i] = i + 1;
        }

        return res;
    }
}
```

### 执行结果

![image-20201110221553382](https://i.loli.net/2020/11/10/ek5HGpmJClVw3MB.png)

# 正则表达式匹配

[剑指 Offer 19. 正则表达式匹配](https://leetcode-cn.com/problems/zheng-ze-biao-da-shi-pi-pei-lcof/)

## 动态规划 + 条件判断 + 初始化

```java
class Solution {
    public boolean isMatch(String s,String p){
            // 太难了，把题解基本看懂了，直接复制过来了
            if (s == null || p == null) {
                return false;
            }
            boolean[][] dp = new boolean[s.length() + 1][p.length() + 1];
            dp[0][0] = true;//dp[i][j] 表示 s 的前 i 个是否能被 p 的前 j 个匹配
            for (int i = 0; i < p.length(); i++) { // here's the p's length, not s's
                if (p.charAt(i) == '*' && dp[0][i - 1]) {
                    dp[0][i + 1] = true; // here's y axis should be i+1
                }
            }
            for (int i = 0; i < s.length(); i++) {
                for (int j = 0; j < p.length(); j++) {
                    if (p.charAt(j) == '.' || p.charAt(j) == s.charAt(i)) {//如果是任意元素 或者是对于元素匹配
                        dp[i + 1][j + 1] = dp[i][j];
                    }
                    if (p.charAt(j) == '*') {
                        if (p.charAt(j - 1) != s.charAt(i) && p.charAt(j - 1) != '.') {//如果前一个元素不匹配 且不为任意元素
                            dp[i + 1][j + 1] = dp[i + 1][j - 1];
                        } else {
                            dp[i + 1][j + 1] = (dp[i + 1][j] || dp[i][j + 1] || dp[i + 1][j - 1]);
                            /*
                            dp[i][j] = dp[i-1][j] // 多个字符匹配的情况	
                            or dp[i][j] = dp[i][j-1] // 单个字符匹配的情况
                            or dp[i][j] = dp[i][j-2] // 没有匹配的情况
                             */
                            
                        }
                    }
                }
            }
            return dp[s.length()][p.length()];
    }
}
```

### 执行结果

![image-20201110225433535](https://i.loli.net/2020/11/10/9XNGUgHdz15cOMa.png)

# 翻转链表

[剑指 Offer 24. 反转链表](https://leetcode-cn.com/problems/fan-zhuan-lian-biao-lcof/)

## 栈

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
        // 用栈来存放
        Stack<Integer> stack = new Stack<Integer>();

        while(head != null){
            stack.push(head.val);
            head = head.next;
        }

        ListNode pre = new ListNode(0);
        ListNode node = pre;
        while(!stack.isEmpty()){
            pre.next = new ListNode(stack.pop());
            pre = pre.next;
        }

        return node.next ;
    }
}
```

### 执行结果

![image-20201110230705610](https://i.loli.net/2020/11/10/AqIRW5FzSGuo4Tg.png)

## 双指针

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
        // 使用双指针修改链表
        ListNode cur = head;
        ListNode pre = null;
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

### 执行结果

![image-20201110232325868](https://i.loli.net/2020/11/10/1cEvkbChp2HNZgd.png)

# 删除链表的节点

[剑指 Offer 18. 删除链表的节点](https://leetcode-cn.com/problems/shan-chu-lian-biao-de-jie-dian-lcof/)

## 双指针

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
    public ListNode deleteNode(ListNode head, int val) {
        // 删除链表 可以用双指针
        ListNode pre = new ListNode(0) ;
        ListNode node = pre;
        ListNode cur = head;
        while(cur != null){
            if(cur.val == val) break;
            pre.next = cur;
            pre = pre.next;
            cur = cur.next;
        }

        pre.next = cur.next;
        return node.next;
    }
}
```

### 执行结果

![image-20201110232948838](https://i.loli.net/2020/11/10/XmEQURNae8iqn7K.png)

# 复杂链表的复制

## 哈希表

```java
/*
// Definition for a Node.
class Node {
    int val;
    Node next;
    Node random;

    public Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
*/
class Solution {
    public Node copyRandomList(Node head) {
        // 采用题解中的哈希表存放节点
        HashMap<Node, Node> map = new HashMap<>();
        Node cur = head;
        while(cur != null){
            map.put(cur, new Node(cur.val));
            cur = cur.next;
        }

        cur = head;
        while(cur != null){
            map.get(cur).next = map.get(cur.next);
            map.get(cur).random = map.get(cur.random);
            cur = cur.next;
        }

        return map.get(head);
    }
}
```

### 执行结果

![image-20201110234207912](https://i.loli.net/2020/11/10/Cs7yaNH6zJWEquU.png)

# 最小的K个树

[剑指 Offer 40. 最小的k个数](https://leetcode-cn.com/problems/zui-xiao-de-kge-shu-lcof/)

## 排序输出

```java
class Solution {
    public int[] getLeastNumbers(int[] arr, int k) {

        Arrays.sort(arr);
        int[] res = new int[k];
        for(int i = 0 ; i < k ; i ++){
            res[i] = arr[i];
        }

        return res;
    }
}
```

### 执行结果

 ![image-20201110234547487](https://i.loli.net/2020/11/10/Vb8s4ZKHXkFzIpC.png)

# 包含 min 函数的栈

[剑指 Offer 30. 包含min函数的栈](https://leetcode-cn.com/problems/bao-han-minhan-shu-de-zhan-lcof/)

## 辅助栈

```java
class MinStack {
    // 辅助栈思想
    // 用一个栈存放最小值
    Stack<Integer> stack;
    Stack<Integer> minStack;
    /** initialize your data structure here. */
    public MinStack() {
        stack = new Stack<>();
        minStack = new Stack<>();
    }
    
    public void push(int x) {
        stack.push(x);
        if(minStack.isEmpty() || x <= minStack.peek()){
            minStack.push(x);
        }
    }
    
    public void pop() {
        if(stack.pop().equals(minStack.peek())){
            minStack.pop();
        }
    }
    
    public int top() {
        return stack.peek();
    }
    
    public int min() {
        return minStack.peek();
    }
}

/**
 * Your MinStack object will be instantiated and called as such:
 * MinStack obj = new MinStack();
 * obj.push(x);
 * obj.pop();
 * int param_3 = obj.top();
 * int param_4 = obj.min();
 */
```

### 执行结果

![image-20201111000538744](https://i.loli.net/2020/11/11/AUrMcQjgBvTJt9y.png)

# 完结撒花

![image-20201111000629023](https://i.loli.net/2020/11/11/sni45yjFwoHTPxW.png)

连着刷了四个小时，太累了，而且单纯为了追求效率，有些题目都没有理解好，还是按照 Tags 和 面经来刷比较好，感觉剑指 Offer 的题 普遍比较简单，难度比较少，为了节省精力，接下来只刷中等难度的。

