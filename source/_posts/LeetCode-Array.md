---
title: LeetCode-Array
date: 2020-10-02 11:21:39
tags:
- LeetCode
- Array
categories: 
- LeetCode
---

# Free Talk

昨天和朋友聊聊下大三下的实习，实习面试的时间大家都打算安排在十月底到十一月。之后谈谈面试的Java技术点和算法，发现自己现在还有很多不懂，LeetCode刷的也远远不够。因此打算这个月突击准备面试，然后按照 Tags 刷LeetCode Hot 100。在写本篇文章之前大致刷了十几道 Array Tag 的题，本来是打算刷完一次性做一个总结的，但是发现遗忘程度太快。因此计划写一篇LeetCode Array 专题，每刷一题，就总结一次。

<!--more-->

# Finished Problem

| 题号 | **题名**                                                     | **题解**                                                     | **通过率** | **难度** |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------- | -------- |
| 1    | [两数之和](https://leetcode-cn.com/problems/two-sum)         | [6844](https://leetcode-cn.com/problems/two-sum/solution)    | 49.5%      | 简单     |
| 4    | [寻找两个正序数组的中位数](https://leetcode-cn.com/problems/median-of-two-sorted-arrays) | [1776](https://leetcode-cn.com/problems/median-of-two-sorted-arrays/solution) | 38.8%      | 困难     |
| 11   | [盛最多水的容器](https://leetcode-cn.com/problems/container-with-most-water) | [1613](https://leetcode-cn.com/problems/container-with-most-water/solution) | 64.2%      | 中等     |
| 15   | [三数之和](https://leetcode-cn.com/problems/3sum)            | [1500](https://leetcode-cn.com/problems/3sum/solution)       | 29.6%      | 中等     |
| 31   | [下一个排列](https://leetcode-cn.com/problems/next-permutation) | [753](https://leetcode-cn.com/problems/next-permutation/solution) | 34.6%      | 中等     |
| 33   | [搜索旋转排序数组](https://leetcode-cn.com/problems/search-in-rotated-sorted-array) | [1203](https://leetcode-cn.com/problems/search-in-rotated-sorted-array/solution) | 39.1%      | 中等     |
| 34   | [在排序数组中查找元素的第一个和最后一个位置](https://leetcode-cn.com/problems/find-first-and-last-position-of-element-in-sorted-array) | [1197](https://leetcode-cn.com/problems/find-first-and-last-position-of-element-in-sorted-array/solution) | 40.4%      | 中等     |
| 39   | [组合总和](https://leetcode-cn.com/problems/combination-sum) | [986](https://leetcode-cn.com/problems/combination-sum/solution) | 71.4%      | 中等     |
| 42   | [接雨水](https://leetcode-cn.com/problems/trapping-rain-water) | [1374](https://leetcode-cn.com/problems/trapping-rain-water/solution) | 52.7%      | 困难     |
| 48   | [旋转图像](https://leetcode-cn.com/problems/rotate-image)    | [822](https://leetcode-cn.com/problems/rotate-image/solution) | 69.8%      | 中等     |
| 53   | [最大子序和](https://leetcode-cn.com/problems/maximum-subarray) | [1749](https://leetcode-cn.com/problems/maximum-subarray/solution) | 52.5%      | 简单     |
| 55   | [跳跃游戏](https://leetcode-cn.com/problems/jump-game)       | [1270](https://leetcode-cn.com/problems/jump-game/solution)  | 41.1%      | 中等     |

# 合并区间

[56题：合并区间](https://leetcode-cn.com/problems/merge-intervals/submissions/)

## 方法一

```java
class Solution {
    public int[][] merge(int[][] intervals) {
        int n = intervals.length;
        int[][] result = new int[n][2];
        int left = 0;
        int right = 0;
        int j = 0;
        // 先对二维数组根据一维数组的第一个元素进行排序，重写 Array.sort 比较器方法
        Arrays.sort(intervals, new Comparator<int[]>() {
            public int compare(int[] interval1, int[] interval2) {
                return interval1[0] - interval2[0];
            }
        });
       
        for(int i = 0; i < n ; i ++ ){
            left = intervals[i][0];
            right = intervals[i][1];
            // && 运算符 是左边条件不满足就终止了，不会继续计算右边条件；
            // 因此判断数组是否越界的条件应该放在前面
            while((i + 1) < n && right >= intervals[i + 1][0] ){
                // 这里对 right 进行赋值前， 需要判断后一个元素的右边界的大小
                if(right < intervals[i + 1][1]){
                    right = intervals[i + 1][1];
                }
                i ++;
            }
            result[j][0] = left;
            result[j][1] = right;
            j ++;
        }
        // 通过 Arrays.copyOf 移除多余的数组
        result = Arrays.copyOf(result , j);
        return result;
    }
}
```

### 执行结果

![image-20201012095255833](https://i.loli.net/2020/10/12/KSzEHjdNftbuZ6T.png)

## 方法二

```Java
class Solution {
    public int[][] merge(int[][] intervals) {
        int n = intervals.length;
        int[][] result = new int[n][2];
        int left = 0;
        int right = 0;
        int j = 0;
        // 这里对数组进行排序时，如果两个数组的第一个元素相同时，会继续按照第二个元素的大小进行比较
        Arrays.sort(intervals,new Comparator<int[]>(){
            public int compare(int[] a,int[] b){
                if(a[0] == b[0]){
                    return a[1] - b[1];
                }else{
                    return a[0] - b[0];
                }
            }
        });

        for(int i = 0; i < n ; i ++ ){
            left = intervals[i][0];
            right = intervals[i][1];
            while((i + 1) < n && right >= intervals[i + 1][0] ){
                if(right < intervals[i + 1][1]){
                    right = intervals[i + 1][1];
                }
                i ++;
            }
            result[j][0] = left;
            result[j][1] = right;
            j ++;
        }
        result = Arrays.copyOf(result , j);
        return result;
    }
}
```

### 执行结果

与方法一相比较，内存消耗增加了，但是执行用时减少

![image-20201012101013585](https://i.loli.net/2020/10/12/k8tGvKTC5XrVHcd.png)

# 不同路径

[62题：不同路径](https://leetcode-cn.com/problems/unique-paths/submissions/)

## 方法一 ：递归

### 第一次提交

```java
class Solution {
    public int uniquePaths(int m, int n) {
        // 递归查询
        int number = 0;
        number = findFinish(1 , 1 , m , n , number);
        return number;
    }

    public int findFinish(int x,int y,int m, int n,int number){
        if( x == m && y == n){
            number ++;
            return number;
        }
        if( x < m ){
            number = findFinish(x + 1 , y , m , n, number);
        }
        if( y < n ){
            number = findFinish(x , y + 1 , m , n, number);
        }
        return number;
    }

}
```

### 解题思路

看到这题，我的第一想法就是递归，花了十几分钟，快速把代码写了，顺利通过了测试，但是提交时显示超时。

> 看了一下题解，发现原因是递归时，进行了大量重复的计算，如图所示
>
> 解决方法：用一个 map 存放重复计算的点， key 为 i * j，value 为到当前点的路径数
>
> ![image-20201013184710378](https://i.loli.net/2020/10/13/aWDnMwboTtLl9gz.png)

## 方法二：动态规划

```java
class Solution {
    public int uniquePaths(int m, int n) {
        // 动态规划
        // 我觉得思想其实和我用递归差不多，但是使用数组进行存储，就避免了多余的计算存储
        int res[][] = new int[m][n];
        for(int i = 0; i < m; i ++) res[i][0] = 1;
        for(int j = 0; j < n; j ++) res[0][j] = 1;
        for(int i = 1 ; i < m ; i ++){
            for(int j = 1; j < n ; j ++){
                // 核心方程
                res[i][j] = res[i - 1][j] + res[i][j - 1];
            }
        }

        return res[m - 1][n - 1];
    }
}
```

### 执行结果

![image-20201013190530710](https://i.loli.net/2020/10/13/T4n7h8H31XWeJqY.png)

# 买卖股票的最佳时机

 [121题: 买卖股票的最佳时机](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/)

## 方法一: 两次遍历数组

```java
class Solution {
    public int maxProfit(int[] prices) {
        int buy = 0;
        int sell = 0;
        int n = prices.length;
        int profit = 0;

        // 方法一：遍历数组
        for(int i = 0; i < n; i ++ ){
                // 注意将每次 sell 遍历前清零
                sell = 0;
            for(int j = i + 1; j < n; j ++ ){
                // 当前的 买入价格
                buy = prices[i];
                // 后续 每一天中 股票价格最高的一天
                sell = Math.max(prices[j], sell) ;
                // 仅当 sell > buy ，才能获利卖出股票
                if(sell > buy){
                    profit = Math.max(sell - buy, profit);
                }
            }
        }

        return profit;
    }
}
```

### 执行结果

![image-20201014102802803](https://i.loli.net/2020/10/14/8f72EJPzFyi9pHK.png)

## 方法二: 一次遍历数组

```java
class Solution {
    public int maxProfit(int[] prices) {
        int n = prices.length;
        int profit = 0;

        // 方法二：
        // 一次遍历，找历史最低点
        /* 
          站在某一天的节点上思考。如果我在之前的那个股票价格的最低点买入股票，
          那我今天卖出，一定是利润最高的。
          注意历史最低点，不是指整个数组的最小值，而是已经遍历的最小值
        */

        int minPrice = Integer.MAX_VALUE;
        
        for(int i = 0 ; i < n; i ++ ){
            if(prices[i] < minPrice){
                minPrice = prices[i];
            }
            profit = Math.max(profit, prices[i] - minPrice);
        }

        return profit;
    }
}
```



### 执行结果

![image-20201014104128644](https://i.loli.net/2020/10/14/397EDF8TXnjtGCJ.png)