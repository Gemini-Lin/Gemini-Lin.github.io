---
title: LeetCode-Easy
date: 2020-11-01 19:46:17
tags:
- LeetCode
- Easy
categories: 
- LeetCode
---

# Free Talk

看了一下实习的面经，发现简单类型的算法题竟然也不少，想刷个十几道练练手。

<!--more-->

# 二叉树的最大深度

[104. 二叉树的最大深度](https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/)

## 递归 + 深度优先搜索

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
    public int maxDepth(TreeNode root) {
        // 找出最大深度
        // 可以做递归判断 + 一个计数 
        return dfs(root, 0);
    }

    public int dfs(TreeNode node, int count){
        if(node == null) return count;
        count ++;
        count = Math.max(dfs(node.left, count), dfs(node.right, count));
        return count;
    }
}
```

### 执行结果

![image-20201101195057700](https://i.loli.net/2020/11/01/SpthZP4ECiGrxDV.png)

# 多数元素

[169. 多数元素](https://leetcode-cn.com/problems/majority-element/)

## 哈希表

```java
class Solution {
    public int majorityElement(int[] nums) {
        // 这个相当简单，如果不考虑时间复杂度，就直接遍历就可以
        // 用一个 哈希表存放， key 为 元素， value 为 元素出现的次数

        HashMap<Integer, Integer> map = new HashMap<>();
        for(int num: nums){
            map.put(num, map.getOrDefault(num, 0) + 1);
        }
        int m = nums.length / 2;
        int res = nums[0];
        for(int num: nums){
            if(map.get(num) > m){
                res = num;
            }
        }

        return res;
    }
}
```

### 执行结果

![image-20201101204758997](https://i.loli.net/2020/11/01/Ke7fS8YJFihzo6Z.png)

## 数组排序

```java
class Solution {
    public int majorityElement(int[] nums) {
        // 刚刚的时间复杂度太高，改用数组排序
        Arrays.sort(nums);
        return nums[nums.length / 2];
    }
}
```

### 执行结果

![image-20201101205337066](https://i.loli.net/2020/11/01/M1J8wqRtdgZcWhp.png)

## 投票法

```java
class Solution {
    public int majorityElement(int[] nums) {
        // 看了一下题解的投票法，思路很新颖，理解很简单
        int vote = Integer.MIN_VALUE;
        int count = 0;
        for(int num: nums){
            if(count == 0){
                vote = num;
            }
            count += (num == vote)? 1 : -1;
        }

        return vote;
    }
}
```

### 执行结果

![image-20201101210057150](https://i.loli.net/2020/11/01/k9DjU15Tv3K6CFp.png)

## Array.sort()排序原理

刚刚写的用数组排序的算法，发现时间复杂度还不错，突然想了解一下，它底层的实现原理。

简单查阅了一下 JDK 1.8 的具体实现，附上源码。

> 源码真的太多了，想要了解的可以看看这篇文章：https://zhuanlan.zhihu.com/p/37510564

# 翻转二叉树

[226. 翻转二叉树](https://leetcode-cn.com/problems/invert-binary-tree/)

## 递归

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
    public TreeNode invertTree(TreeNode root) {
        // 翻转二叉树，其实就是交换左右节点
        // 可以采用 深度优先搜索，交换节点
        if(root == null) return root;

        TreeNode tmp = root.left;
        root.left = root.right;
        root.right = tmp;

        invertTree(root.left);
        invertTree(root.right);

        return root;
    }
}
```

### 执行截图

![image-20201102154552097](https://i.loli.net/2020/11/02/KinPXLuwxycvze8.png)

# 找到所有数组中消失的数字

[448. 找到所有数组中消失的数字](https://leetcode-cn.com/problems/find-all-numbers-disappeared-in-an-array/)

## 原地修改

```java
class Solution {
    public List<Integer> findDisappearedNumbers(int[] nums) {
        // 这个既要求时间复杂度，又要求空间复杂度，确实很麻烦
        // 本来想是用个哈希表来存储，但是只能改为在本地修改数组

        List<Integer> res = new ArrayList<>();

        for(int i = 0; i < nums.length ; i ++ ){
            // 这边刚刚忘记考虑绝对值，导致索引为负
            int tmp = Math.abs(nums[i]) - 1;
            if(nums[tmp] > 0){
                nums[tmp] *= -1;
            }
            
        }

        // 这边忘记考虑等号，憨批行为
        for(int i = 1; i <= nums.length; i ++ ){
            if(nums[i - 1] >= 0){
                res.add(i);
            }
        }

        return res;
    }
}
```

### 执行截图

​	![image-20201102163137936](https://i.loli.net/2020/11/02/MfwsJRuKP1Ge2ZD.png)

# 汉明距离

[461. 汉明距离](https://leetcode-cn.com/problems/hamming-distance/)

## 二进制运算

```java
class Solution {
    public int hammingDistance(int x, int y) {
        // 没想到什么好的方法，可能关于二进制操作有一些库函数可以利用
        // 比如说逻辑按位与运算，只要计算结果不为0的位树和
        // 果然是不熟悉 Java的位运算，其实思路上没什么问题

        // 为什么这里要用异或而不能是与运算呢
        // 原来是我这个憨憨把与运算不小心理解错了
        int res = x ^ y;
        int count = 0;
        while(res != 0){
            if((res & 1) == 1){
                count ++ ;
            }
            // 这边的右移位确保每次按位与最后一位
            res = res >> 1;
        }

        return count;
    }
}
```

### 执行结果

![image-20201102171521827](https://i.loli.net/2020/11/02/CKo8vPnX4yWc3ta.png)

# 二叉树的直径

[543. 二叉树的直径](https://leetcode-cn.com/problems/diameter-of-binary-tree/)

## 转换节点 + 递归

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
    int count = 0;
    public int diameterOfBinaryTree(TreeNode root) {
        // 这一题真的不仅仅是简单难度
        // 可以转换一下思维，求直径，其实就是求一个节点到其他节点的最长路径
        // 那么可以固定一个节点为路径的 “根节点”，求这个节点的最长路径
        reverse(root);
        return count;
    }

    public int reverse(TreeNode root){
        if(root == null) return 0;
        
        int left = reverse(root.left);
        int right = reverse(root.right);

        count = Math.max(count, left + right);
        return 1 + Math.max(left, right);
    }
}
```

### 执行结果

![image-20201102175628736](https://i.loli.net/2020/11/02/mgiThkCbJeFKpal.png)

# 合并二叉树

[617. 合并二叉树](https://leetcode-cn.com/problems/merge-two-binary-trees/)

## 两个二叉树 + 前序遍历

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
    public TreeNode mergeTrees(TreeNode t1, TreeNode t2) {
        // 可以讲两个二叉树做递归遍历
        if(t1 == null && t2 == null) return null;
        return recurse(t1, t2);
    }

    public TreeNode recurse(TreeNode t1, TreeNode t2){

        // 递归首先需要判定结束条件
        // 一开始判断条件写错了
        if(t1 == null || t2 == null){
            t1 = (t1 == null) ? t2: t1;
            return t1;
        }

        t1.val += t2.val;
        // 没有考虑清楚返回值的处理
        t1.left = recurse(t1.left, t2.left);
        t1.right = recurse(t1.right, t2.right);
        
        return t1;
    }
    
}
```

### 执行结果

![image-20201102200523526](https://i.loli.net/2020/11/02/4Pv2buC5WKHp8VN.png)

# 完结撒花

![image-20201102200620940](https://i.loli.net/2020/11/02/OQXFKfjptvZk1qM.png)

简单的题目虽然刷完了，但是我发现自己对于二叉树的递归，了解的远远不够深刻，必须要总结出一个系统的解题方法。

