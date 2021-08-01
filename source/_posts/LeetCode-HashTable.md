---
title: LeetCode-HashTable
date: 2020-10-17 08:47:09
tags:
- LeetCode
- HashTable
categories: 
- LeetCode
---

# Free Talk

HashTable 在 LeetCode 的题目中经常出现，打算刷完 Hot 100 里面的 HashTable Tags，熟悉一下 HashTable 相关的 API。

<!--more-->

# Finished Problem

![image-20201017155859227](https://i.loli.net/2020/10/17/zoWUOLYRTkmSJGu.png)

# 每日温度

 [739. 每日温度](https://leetcode-cn.com/problems/daily-temperatures/)

## 两次循环遍历

```java
class Solution {
    public int[] dailyTemperatures(int[] T) {
        // 这道题的核心应该是求 后面的天数中 第一个比当前气温的高的相差天数
        // 思路一：
        // 两次循环遍历
        // i 表示当前的天数 , j 表示之后的天数

        int[] res = new int[T.length];
        for(int i = 0 ; i < T.length ; i ++ ){
            res[i] = 0;
            for(int j = i ; j < T.length ; j ++ ){
                // 找到第一个大于温度的时候，就退出当前循环
                if(T[j] > T[i]){
                    res[i] = j - i;
                    break;
                }
            }
        }

        return res;

    }
}
```

### 执行结果

![image-20201017090251106](https://i.loli.net/2020/10/17/B85yfc2XUhNpDA4.png)

## 栈

```java
class Solution {
    public int[] dailyTemperatures(int[] T) {
        // 第一种思路最大的问题 是需要两次遍历
        // 那我们能不能只通过一次遍历就实现呢？
        // 思路二：栈
        // 通过栈来存放数组的下标，栈内的元素为还没有找到更高的气温的下标

        // 常见的多态 Java官方 推荐用 Deque 实现 Stack 同样具备 FIFO
        Deque<Integer> stack = new ArrayDeque<Integer>();
        // 会默认初始化为0
        int[] res = new int[T.length];

        for(int i = 0 ; i < T.length ; i ++ ){
            // 注意这里需要循环比较，用当前的元素 去比较栈内的每一个元素
            while(!stack.isEmpty() && T[i] > T[stack.peek()]){
                res[stack.peek()] = i - stack.peek();
                stack.pop();
            }
            stack.push(i);
        }
        return res;
    }
}
```

### 执行结果 -- ArrayDeque

![image-20201017093857158](https://i.loli.net/2020/10/17/yoWEYu4kelnH9U7.png)

### 执行结果 -- LinkedList

![image-20201017094009855](https://i.loli.net/2020/10/17/s4fHoqCGMYOSwAR.png)

# 最大矩形

 [85. 最大矩形](https://leetcode-cn.com/problems/maximal-rectangle/)

## 傻瓜遍历

```java
class Solution {
    public int maximalRectangle(char[][] matrix) {

        // 首先的想法是怎么定义一个矩阵
        // 可以通过存储矩阵左上角元素的 p，q 值 和 右下角元素的 m, n 值
        // 矩阵的元素下标范围 行 [p, m] 列 [q, n]
        // 如果在这个范围内的矩阵元素 存在 0 则失效
        

    }

    // 这种单纯的遍历的时间复杂度太高了， 遂放弃
    public int maxRectangle(int p, int q, int m, int n, char[][] matrix){
        for(int i = p ; i <= m ; i ++ ){
            for(int j = q ; j <= n ; j ++ ){
                if(matrix[i][j] == 0){
                    return 0;
                }
            }
        }

        return (m - p)*(n - q);
    }
}
```

## 动态规划

```java
class Solution {
    public int maximalRectangle(char[][] matrix) {

        // 使用动态规划 转化为 柱状图
        if(matrix.length == 0) return 0;
        int maxArea = 0;
        int[][] dp = new int[matrix.length][matrix[0].length];

        for(int i = 0; i < matrix.length; i ++ ){
            for(int j = 0; j < matrix[0].length; j ++ ){
                if(matrix[i][j] == '1'){
                    dp[i][j] = j == 0 ? 1 : dp[i][j - 1] + 1;

                    int width = dp[i][j];

                    for(int k = i; k >= 0; k -- ){
                        width = Math.min(width, dp[k][j]);
                        maxArea = Math.max(maxArea, (i - k + 1)* width);
                    }
                }
            }
        }

        return maxArea;
    }
}
```

### 执行结果

![image-20201017163546333](https://i.loli.net/2020/10/17/Cg2NfG1ryHVJjku.png)

# 二叉树的中序遍历

[94. 二叉树的中序遍历](https://leetcode-cn.com/problems/binary-tree-inorder-traversal/)

## 递归打印

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode() {}
 *     TreeNode(int val) { this.val = val; }
 *     TreeNode(int val, TreeNode left, TreeNode right) {
 *         this.val = val;
 *         this.left = left;
 *         this.right = right;
 *     }
 * }
 */
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        // 思路：递归算法
        // 前序遍历：打印 - 左 - 右
        // 中序遍历：左 - 打印 - 右
        // 后序遍历：左 - 右 - 打印
        // 对于每个节点按照 左节点 - 根节点 - 右节点 的顺序遍历
        List<Integer> res = new ArrayList<Integer>();
        // 这边注意一下List 是抽象类，不能实例化
        findInt(root, res);
        return res;
    }

    public void findInt(TreeNode root, List<Integer> res){
        if(root == null){
            return;
        }
        // 先不停遍历左节点，直到左节点为空，然后添加左节点的值到 List 中
        findInt(root.left, res); 
        res.add(root.val);
        findInt(root.right, res);
    }
}
```

### 执行结果

![image-20201018153417898](https://i.loli.net/2020/10/18/q7LwDhovEkyPSb6.png)

# 只出现一次的数字

[136. 只出现一次的数字](https://leetcode-cn.com/problems/single-number/)

## Map存放

```java
class Solution {
    public int singleNumber(int[] nums) {
        // 思路：用一个 Map 存放元素的信息，Key 为元素，Value 为元素出现的次数
         Map<Integer,Integer> map = new HashMap<Integer,Integer>();
         // For each 循环遍历数组
         for(Integer i: nums){
             // 自动装箱
             Integer count = map.get(i);
             // 注意自增运算符的使用
             count = count == null ? 1 : ++ count;
             map.put(i, count);
         }

        // 判断出现次数为 1 的元素
         for(Integer i: map.keySet()){
             Integer count = map.get(i);
             if(count == 1){
                 return i;
             }
         }

         return -1;
    }
}
```

### 执行结果

![image-20201018181342511](https://i.loli.net/2020/10/18/K6MdzFZIrpkJNBW.png)

## 异或运算

```java
class Solution {
    public int singleNumber(int[] nums) {
     // 思路：异或运算
     // 异或运算满足加法交换律，因为其余每个元素均出现两次，
     // 因此异或遍历所有的元素，剩下的值即为只出现一次的元素

     int single = 0;
     for(int num : nums){
         single ^= num;
     }
     return single;
    }
}
```

### 执行结果

![image-20201018182030763](https://i.loli.net/2020/10/18/QWnxNrZi2JDeo97.png)

# 前 K 个高频元素

 [347. 前 K 个高频元素](https://leetcode-cn.com/problems/top-k-frequent-elements/)

## 堆排序

```java
class Solution {
    public int[] topKFrequent(int[] nums, int k) {
        // 思路和刚刚那题有点像
        // 用一个 Map 存放 元素 和 元素出现的次数
        
        Map<Integer, Integer> map = new HashMap<Integer,Integer>();

        for(Integer num: nums){
            Integer count = map.get(num);
            count = count == null ? 1 : ++ count;
            map.put(num, count);
        }

        // 如何知道 出现频率第 K 高的元素所对应的 count ?
        // 通过一个最小堆 根据 count 来存放元素的 key
        PriorityQueue<Integer> pq = new PriorityQueue<>(new Comparator<Integer>(){
            @Override
            public int compare(Integer a, Integer b){
                return map.get(a) - map.get(b);
            }
        });

        // 将元素的 Key 放入堆中
        for(Integer key: map.keySet()){
            if(pq.size() < k){
                pq.add(key);
            }else if(map.get(key) > map.get(pq.peek())){
                pq.remove();
                pq.add(key);
            }
        }

        // 取出最小堆中的值
        int[] res = new int[k];
        for(int i = 0; i < k; i ++ ){
            res[i] = pq.remove();
        }

        return res;
    }
}
```

### 执行结果

![image-20201018193623530](https://i.loli.net/2020/10/18/8j9uG4Krdhc1AnL.png)

# 找到字符串中所有字母异位词

[438. 找到字符串中所有字母异位词](https://leetcode-cn.com/problems/find-all-anagrams-in-a-string/)

## 超时做法

```java
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        // 想到了哈希表
        // 计算字符串 p 的长度 n ，将 p 中每个字符存入 key, value 为 字符出现的个数
        // 从左往右遍历字符串 s, 并且循环遍历 n 次
        int m = s.length();
        int n = p.length();

        List<Integer> res = new ArrayList<Integer>();
        HashMap<Character, Integer> map = new HashMap<Character, Integer>();
        // 得到遍历字符串 p 后的哈希表
        for(int j = 0 ; j < n ; j ++ ){
            Character ch = p.charAt(j);
            Integer count = map.get(ch);
            count = count == null ? 1 : ++ count;
            map.put(ch, count);
        }

        for(int i = 0; i < m ; i ++ ){
            // 复制一个哈希表
            HashMap<Character, Integer> itemMap = (HashMap<Character, Integer>) map.clone();
            int j = i;
            // 从 i 开始，连续遍历 n 个 字符，如果字符在哈希表中，则将对应的 value 减 1;
            // 如果不在哈希表，则直接结束循环 
            for(j = i; j < i + n && j < m; j ++ ){
                Character ch = s.charAt(j);
                Integer count = itemMap.get(ch);
                if(count == null || count == 0){
                    break;
                }else{
                    count --;
                    itemMap.put(ch, count);
                }
            }
            // 如果是正确匹配了全部子串，则把子串的头索引加入列表中
            if(j == i + n){
                res.add(new Integer(i));
            }
        }

        return res;
    }
}
```

### 测试结果

![image-20201019110001034](https://i.loli.net/2020/10/19/XFi7GZlcRdUohEL.png)

## 滑动窗口

```java
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        // 其实我一开始脑海中闪过的就是 滑动窗口
        int m = s.length();
        int n = p.length();

        List<Integer> res = new ArrayList<Integer>();
        // 用于存放 字符串 p
        Map<Character, Integer> map = new HashMap<Character, Integer>();
        // 用于存放 字符串 s 的滑动窗口
        Map<Character, Integer> window = new HashMap<Character, Integer>();
        // 得到遍历字符串 p 后的哈希表
        for(int j = 0 ; j < n ; j ++ ){
            Character ch = p.charAt(j);
            Integer count = map.get(ch);
            count = count == null ? 1 : ++ count;
            map.put(ch, count);
        }

        int left = 0;
        int right = 0;
        int valid = n;

        // 核心思想和刚刚那种做法不一样
        // 先自增右边界，找到满足条件的子串，然后收缩左边界
        while(right < m){
           Character ch = s.charAt(right);
           // 当且仅当 当前的字符 是目标子串需要的，并且 value 还是 小于 目标子串时
           if(map.containsKey(ch)){
               // 一行设置 value，比前面的简便一些
               window.put(ch, window.getOrDefault(ch, 0) + 1);
               if(window.get(ch) <= map.get(ch)){
                   valid -- ;
               }
           }

           while(valid == 0){
               // 如果长度等于目标子串
               if(right - left + 1 == n) res.add(new Integer(left));
               // 如果左边界的字符时目标子串中存在的
               if(map.containsKey(s.charAt(left))){
                   // 对应的 value 减一
                   window.put(s.charAt(left), window.get(s.charAt(left)) - 1);
                   // 如果此时的 value 值不满足条件，让 valid 加 1， 修改右边界
                   if(window.get(s.charAt(left)) < map.get(s.charAt(left))){
                       valid ++;
                   }
               }
               left++;
           }

           right ++;
        }

        return res;
    }
}
```

### 执行结果

![image-20201019113327316](https://i.loli.net/2020/10/19/iXfx3cFyjMeYBdv.png)



# 和为K的子数组

 [560. 和为K的子数组](https://leetcode-cn.com/problems/subarray-sum-equals-k/)

## 滑动窗口

```java
class Solution {
    public int subarraySum(int[] nums, int k) {
        // 第一想法是递归
        // 再看看发现有子数组是连续的
        // 思路：滑动窗口，设置左右指针
        // 问题出在 元素可以为负值，不可以使用滑动窗口
        int count = 0;
        int sum = 0;

        // 想要用队列，FIFO，先进先出
        LinkedList<Integer> queue = new LinkedList<Integer>(); 

        int left = 0;
        int right = 0;
        while(right < nums.length){
            if(nums[right] + sum < k){
                queue.add(nums[right]);
                sum += nums[right];
            }
            if(nums[right] + sum == k){
                queue.add(nums[right]);
                sum += nums[right];
                count ++;
            }
            while(nums[right] + sum > k && left < right){
                sum -= queue.removeFirst();
                left ++;
            }
            right ++;
        }

        return count;
    }
}
```

### 测试结果

![image-20201019151424750](https://i.loli.net/2020/10/19/XxZfahAbKCG6oBk.png)

## 枚举

```java
class Solution {
    public int subarraySum(int[] nums, int k) {

        // 简单枚举
        int count = 0;
        
        for(int i = 0 ; i < nums.length; i ++ ){
            int sum = 0;
            for(int j = i ; j >= 0 ; j -- ){
                sum += nums[j];
                if(sum == k){
                    count ++;
                }
            }
        }

        return count;
    }
}
```

### 执行结果

![image-20201019152010070](https://i.loli.net/2020/10/19/DEUAMcuZb8geNyB.png)

## 哈希表优化

```java
class Solution {
    public int subarraySum(int[] nums, int k) {

        // 哈希表优化
        int count = 0;
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        int pre = 0;
        // 初始化
        map.put(0, 1);

        for(int i = 0 ; i < nums.length ; i ++ ){
            pre += nums[i];
            if(map.containsKey(pre - k)){
                count += map.get(pre - k);
            }
            map.put(pre, map.getOrDefault(pre , 0) + 1);
        }

        return count;
    }
}
```

### 执行结果

![image-20201019154430101](https://i.loli.net/2020/10/19/ZKAir9ogMHDzFey.png)

# 完结撒花

![image-20201019154805966](https://i.loli.net/2020/10/19/9X4i3zUIRaBoQZD.png)