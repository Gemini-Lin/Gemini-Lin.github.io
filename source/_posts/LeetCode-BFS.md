---
title: LeetCode-BFS
date: 2020-10-28 19:07:37
tags:
- LeetCode
- Breadth-First Search
categories: 
- LeetCode
---

# Free Talk

本来是想直接写 树 Tags，但是发现里面的题太多了，为了促进自己的积极性，退而求其次，选择了 **广度优先遍历**。

<!--more-->

# Finished Problem

![image-20201028191034033](https://i.loli.net/2020/10/28/TeaJyVlrpK7AiIL.png)

# BFS & DFS 简单介绍

## **DFS（Deep First Search）深度优先搜索。**

深度优先搜索的步骤分为 1.递归下去 2.回溯上来。

顾名思义，深度优先，则是以深度为准则，先一条路走到底，直到达到目标。这里称之为递归下去。

否则既没有达到目标又无路可走了，那么则退回到上一步的状态，走其他路。这便是回溯上来

**DFS ：递归 + 回溯**

## BFS（Breath First Search）广度优先搜索。

广度优先搜索较之深度优先搜索之不同在于，深度优先搜索旨在不管有多少条岔路，先一条路走到底，不成功就返回上一个路口然后就选择下一条岔路，而广度优先搜索旨在面临一个路口时，把所有的岔路口都记下来，然后选择其中一个进入，然后将它的分路情况记录下来，然后再返回来进入另外一个岔路，并重复这样的操作。

**BFS：状态的选举和标记**

[来源资料](https://zhuanlan.zhihu.com/p/24986203)

# 对称二叉树

[101. 对称二叉树](https://leetcode-cn.com/problems/symmetric-tree/)

## 递归解法

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
        // 这么简单的题，竟然没有思路，真的惭愧
        // 递归解法：比较左子树的左节点和右子树的右节点，左子树的右节点和右子树的左节点

        if(root == null) return true;

        return bfs(root.left, root.right);
    }
    public boolean bfs(TreeNode left,TreeNode right){
        // 递归需要确定：
        // 结束条件
        // 递归方法
        if(left == null && right == null){
            return true;
        }

        if(left == null || right == null){
            return false;
        }

        if(left.val != right.val){
            return false;
        }

        return bfs(left.left, right.right) && bfs(left.right, right.left);
    }
}
```

### 执行结果

![image-20201029091547135](https://i.loli.net/2020/10/29/cJVyAeEfo5LZwm3.png)

## 迭代解法

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
        // 迭代解法
        // 迭代和递归的区别：
        // 递归是不停地调用自己，一般是通过 if else 判断实现
        // 迭代是更新变量的旧值，一般通过 for while 循环实现    

        return check(root, root);

    }

    public boolean check(TreeNode left, TreeNode right){
        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        queue.offer(left);
        queue.offer(right);

        while(!queue.isEmpty()){
            left = queue.poll();
            right = queue.poll();
            if(left == null && right == null){
                continue;
            }

            if(left == null || right == null){
                return false;
            }

            if(left.val != right.val){
                return false;
            }

            queue.offer(left.left);
            queue.offer(right.right);

            queue.offer(left.right);
            queue.offer(right.left);
        }

        return true;

    }
}
```

### 执行结果

![image-20201029095104883](https://i.loli.net/2020/10/29/EovgZVwmLJzAUnd.png)

# 二叉树的层序遍历

[102. 二叉树的层序遍历](https://leetcode-cn.com/problems/binary-tree-level-order-traversal/)

## BFS + 队列 + 分层

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
    public List<List<Integer>> levelOrder(TreeNode root) {
        // 都忘记层序遍历的写法了
        // 看了题解中讲的 DFS、BFS 的区别，以及 BFS 的应用场景
        // 有种醍醐灌顶的感觉，接下来打算把 树 Tags 刷个十几道，熟悉一下

        List<List<Integer>> res = new ArrayList<>();
        Queue<TreeNode> queue = new ArrayDeque<>();

        if(root != null){
            queue.add(root);
        }

        while(!queue.isEmpty()){
            List<Integer> level = new ArrayList<>();
            // 根据队列中上一层节点数量，遍历下一层的节点
            int n = queue.size();

            for(int i = 0; i < n ; i ++){
                TreeNode node = queue.poll();
                level.add(node.val);

                if(node.left != null){
                    queue.add(node.left);
                }

                if(node.right != null){
                    queue.add(node.right);
                }
            }

            res.add(level);
        }

        return res;
    }

}
```

### 执行结果

![image-20201030113135819](https://i.loli.net/2020/10/30/Zqr15oaYPtpDIwe.png)

# 岛屿数量

[200. 岛屿数量](https://leetcode-cn.com/problems/number-of-islands/)

## 岛屿问题 + DFS

```java
class Solution {
    public int numIslands(char[][] grid) {
        // 挺蒙蔽的
        // 该怎么去标识一个岛屿呢
        // 看了一下题解写到岛屿问题的 DFS 的解题套路

        int count = 0;
        for(int i = 0; i < grid.length ; i ++ ){
            for(int j = 0; j < grid[0].length ; j ++ ){
                if(grid[i][j] == '1'){
                    dfs(grid, i, j);
                    count ++ ;
                }
            }
        }

        return count;
    }

    public void dfs(char[][] grid, int r, int c){
        if(r < 0 || c < 0 || r >= grid.length || c >= grid[0].length 
        || grid[r][c] == '0' || grid[r][c] == '2') return ;

        grid[r][c] = '2';

        dfs(grid, r , c + 1);
        dfs(grid, r , c - 1);
        dfs(grid, r + 1 , c);
        dfs(grid, r - 1 , c);
    }

}
```

### 执行结果

![image-20201103150938361](https://i.loli.net/2020/11/03/97bX4VmpskiHCNS.png)

# 岛屿的周长

[463. 岛屿的周长](https://leetcode-cn.com/problems/island-perimeter/)

## DFS + 边界

```java
class Solution {
    public int islandPerimeter(int[][] grid) {
        // 写一下基础的 DFS 框架
        int count = 0;
        for(int i = 0; i < grid.length ; i ++ ){
            for(int j = 0; j < grid[0].length ; j ++ ){
                if(grid[i][j] == 1){
                    count = dfs(grid, i , j);
                }
            }
        }
        return count;
    }

    public int dfs(int[][] grid, int r, int c){
        // 边长由 二维数组边缘 和 海洋边缘 共同确定
        // 这个点真的一直没有想到
        if(r < 0 || c < 0 || r >= grid.length || c >= grid[0].length ) return 1;
        if(grid[r][c] == 0) return 1;
        if(grid[r][c] != 1) return 0;
        // 确定 Base Case

        grid[r][c] = 2;

        int size = 0;
        size += dfs(grid, r , c + 1);
        size += dfs(grid, r , c - 1);
        size += dfs(grid, r + 1, c);
        size += dfs(grid, r - 1, c);

        return size;
    }
}
```

### 执行结果

![image-20201103153846298](https://i.loli.net/2020/11/03/uFDJsTltWcSXmpU.png)

## 迭代

```java
class Solution {
    static int[] dx = {1, 0, - 1,0};
    static int[] dy = {0, 1, 0 , - 1};

    public int islandPerimeter(int[][] grid) {
        // 刚刚的时间复杂度和空间复杂度都太高了
        // 我打算换一种解法
        // 对于每个遍历到的元素，依次去判断的 上下左右 情况
        int m = grid.length;
        int n = grid[0].length;
        int res = 0;

        for(int i = 0; i < m ; i ++ ){
            for(int j = 0; j < n ; j ++ ){
                if(grid[i][j] == 1){
                    for(int k = 0; k < 4 ; k ++ ){
                        int x = i + dx[k];
                        int y = j + dy[k];
                        if(x < 0 || y < 0 || x >= m || y >= n || grid[x][y] == 0){
                            res ++;
                        }
                    }
                }
            }
        }

        return res;
    }
}
```

### 执行结果

![image-20201103155841155](https://i.loli.net/2020/11/03/Yq23TtfGORCredL.png)

# 岛屿的最大面积

[695. 岛屿的最大面积](https://leetcode-cn.com/problems/max-area-of-island/)

## DFS + 计数器

```java
class Solution {
    public int maxAreaOfIsland(int[][] grid) {
        // 感觉现在就是拿 模板 来做题的
        int res = 0;
        for(int i = 0; i < grid.length ; i ++ ){
            for(int j = 0; j < grid[0].length ; j ++ ){
                if(grid[i][j] == 1){
                    res = Math.max(res, dfs(grid, i , j));
                }
            }
        }

        return res;
    }

    public int dfs(int[][] grid, int r, int c){
        if(r < 0 || c < 0 || r >= grid.length || c >= grid[0].length 
        || grid[r][c] == 0 || grid[r][c] == 2) return 0;

        grid[r][c] = 2;
        int count = 0;

        count += dfs(grid, r , c + 1);
        count += dfs(grid, r , c - 1);
        count += dfs(grid, r + 1 , c);
        count += dfs(grid, r - 1 , c);

        return count + 1;
    }
}
```

### 执行结果

![image-20201103193024345](https://i.loli.net/2020/11/03/Bq9Np4cyKgboXE8.png)

# 最大人工岛

[827. 最大人工岛](https://leetcode-cn.com/problems/making-a-large-island/)

## DFS （未通过）

```java
class Solution {
    public int largestIsland(int[][] grid) {
        // 在之前的递归问题上，加了一个填海要求
        int res = 0;
        boolean hasZero = false;
        for(int i = 0; i < grid.length ; i ++ ){
            for(int j = 0; j < grid[0].length ; j ++ ){
                if(grid[i][j] == 0){
                    hasZero = true;
                    grid[i][j] = 1;
                    res = Math.max(res, dfs(grid, i , j));
                    grid[i][j] = 0;
                }
            }
        }
        return hasZero ? res : grid.length * grid[0].length;
    }

    public int dfs(int[][] grid, int r, int c){
        if(r < 0 || c < 0 || r >= grid.length || c >= grid[0].length 
        || grid[r][c] == 0 || grid[r][c] == 2) return 0;

        grid[r][c] = 2;
        int count = 0;

        count += dfs(grid, r , c + 1);
        count += dfs(grid, r , c - 1);
        count += dfs(grid, r + 1 , c);
        count += dfs(grid, r - 1 , c);

        return count + 1;
    }
}
```

### 执行结果

![image-20201103195326265](https://i.loli.net/2020/11/03/Jlc4mMGtXp7NR6f.png)

> 这道题有点复杂，并且冷门，暂时先不写了

# 课程表

[207. 课程表](https://leetcode-cn.com/problems/course-schedule/)

## 有向无环图

```java
class Solution {
    public boolean canFinish(int numCourses, int[][] prerequisites) {
        // 思路有点点懵
        // 这题要用到图论的知识，我已经一年多没有接触这个
        // 光看题解就想了半个多小时，才把思路理解清楚
        // 数据结构：
        // 1. 首先是构建一个队列，存放所有入度为 0 的节点（意味着当前课程是可以被直接执行的）
        // 2. 构建一个邻接表，以链表的形式，存放节点的先后链接关系
        // 3. 构建一个节点的入度表
        // Step:
        // 1. 先遍历每个节点，初始化入度表
        // 2. 将队列中的节点出队，修改对应结的邻接表中的所有节点的入队值（ -1 ）
        // 3. 将修改后入度为 0 的节点 放入队列
        int[] indegrees = new int[numCourses];
        Queue<Integer> queue = new LinkedList<>();
        List<List<Integer>> adjacency = new ArrayList<>();

        // 初始化邻接表
        for(int i = 0; i < numCourses ; i ++ ){
            adjacency.add(new ArrayList<>());
        }

        // 初始化入度表和邻接表
        for(int[] list : prerequisites){
            indegrees[list[0]]++;
            adjacency.get(list[1]).add(list[0]);
        }

        // 开始遍历课程，执行相应的入队操作
        for(int i = 0; i < numCourses; i ++ ){
            if(indegrees[i] == 0) queue.add(i);
        }

        // 开始遍历队列
        while(!queue.isEmpty()){
            int pre = queue.poll();
            numCourses --;
            for(int cur: adjacency.get(pre)){
                if(--indegrees[cur] == 0) queue.add(cur);
            }
        }

        return numCourses == 0;
    }
}
```

### 执行结果

![image-20201104113136107](https://i.loli.net/2020/11/04/kQOfwMYTUojFSCB.png)

# 删除无效的括号

[301. 删除无效的括号](https://leetcode-cn.com/problems/remove-invalid-parentheses/)

> 困难问题，暂时放弃