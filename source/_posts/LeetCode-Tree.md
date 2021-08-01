---
title: LeetCode-Tree
date: 2020-11-05 09:56:28
tags:
- LeetCode
- Tree
categories: 
- LeetCode
---

# Free Talk

终于可以刷最常用的二叉树了，我对于二叉树的递归和迭代理解的不是很清楚，趁这篇文章学习总结一下。

<!--more-->

# Finished Problem

![image-20201105095907511](https://i.loli.net/2020/11/05/CzlfsMqERJo4L9T.png)

# 验证二叉搜索树

[98. 验证二叉搜索树](https://leetcode-cn.com/problems/validate-binary-search-tree/)

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
    public boolean isValidBST(TreeNode root) {
        // 二叉搜索树的特征记一下
        // 可以采用 DFS 深度优先遍历
        // 这边给定范围的做法特别妙
        return dfs(root, null, null);
    }

    public boolean dfs(TreeNode root, Integer low, Integer high){
        // 先给定终止条件
        if(root == null) return true;

        if(low != null && root.val <= low){
            return false;
        }
        if(high != null && root.val >= high){
            return false;
        }

        if(!dfs(root.left, low, root.val)) return false;
        if(!dfs(root.right, root.val, high)) return false;

        return true;
    }
}
```

### 执行结果

![image-20201105110103479](https://i.loli.net/2020/11/05/oTjDa5CBKALbEmc.png)

## 中序遍历

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
    long pre = Long.MIN_VALUE;
    public boolean isValidBST(TreeNode root) {
        // 采用中序遍历
        // 因为中序遍历是先访问左子树，再访问节点，然后访问右子树
        // 因此二叉搜索树中序遍历的结果，应该是递增的
        if(root == null) return true;

        if(!isValidBST(root.left)){
            return false;
        }

        if(root.val <= pre){
            return false;
        }

        pre = root.val;

        if(!isValidBST(root.right)){
            return false;
        }

        return true;
    }
}
```

### 执行结果

![image-20201105111103403](https://i.loli.net/2020/11/05/AoTEMgacufptO1K.png)

# 从前序与中序遍历序列构造二叉树

[105. 从前序与中序遍历序列构造二叉树](https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)

## 递归 （根节点 + 左右子树）

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
    public TreeNode buildTree(int[] preorder, int[] inorder) {
        // 这种题好像以前在数据结构课程中做过
        // 前序遍历：根 左 右 
        // 中序遍历：左 根 右
        // 看了题解，发现和我当初解题的思路是一样的，不过考试的时候没考算法
        // 我们可以观察到可以从前序遍历直接得到根节点
        // 再根据根节点，从中序遍历得到左右子树
        // 不停地递归左右子树
        return buildTreeHelper(preorder, 0, preorder.length, inorder, 0 , inorder.length);

    }

    public TreeNode buildTreeHelper(int[] preorder, int pStart, int pEnd, 
    int []inorder, int iStart, int iEnd){
        // 相等意味着已经遍历完前序数组，直接返回
        if(pStart == pEnd){
            return null;
        }

        int root_val = preorder[pStart];
        TreeNode root = new TreeNode(root_val);

        int root_index = 0;
        for(int i = iStart; i < iEnd; i ++ ){
            if(inorder[i] == root_val){
                root_index = i;
                break;
            }
        }

        int left = root_index - iStart;

        // 这边的数组的起始位置需要注意一下
        root.left = buildTreeHelper(preorder, pStart + 1, pStart + left + 1, inorder,iStart, root_index);
        root.right = buildTreeHelper(preorder,pStart + left + 1, pEnd, inorder, root_index + 1, iEnd);

        return root;     
    }
}
```

### 执行结果

![image-20201105141747473](https://i.loli.net/2020/11/05/9PfdmoDU8JpeKMZ.png)

## 哈希表优化

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
        // 再刚刚的题解上做一个优化
        // 查找根节点的索引位置，由循环遍历改为哈希表存放
        HashMap<Integer,Integer> map = new HashMap<>();
        public TreeNode buildTree(int[] preorder, int[] inorder) {
            // 这种题好像以前在数据结构课程中做过
            // 前序遍历：根 左 右 
            // 中序遍历：左 根 右
            // 看了题解，发现和我当初解题的思路是一样的，不过考试的时候没考算法
            // 我们可以观察到可以从前序遍历直接得到根节点
            // 再根据根节点，从中序遍历得到左右子树
            // 不停地递归左右子树
            for(int i = 0; i < inorder.length; i ++ ){
                map.put(inorder[i],i);
            }
            return buildTreeHelper(preorder, 0, preorder.length, inorder, 0 , inorder.length);

        }

        public TreeNode buildTreeHelper(int[] preorder, int pStart, int pEnd, 
        int []inorder, int iStart, int iEnd){
            // 相等意味着已经遍历完前序数组，直接返回
            if(pStart == pEnd){
                return null;
            }

            int root_val = preorder[pStart];
            TreeNode root = new TreeNode(root_val);

            int root_index = 0;
            root_index = map.get(root_val);

            int left = root_index - iStart;

            // 这边的数组的起始位置需要注意一下
            root.left = buildTreeHelper(preorder, pStart + 1, pStart + left + 1, inorder,iStart, root_index);
            root.right = buildTreeHelper(preorder,pStart + left + 1, pEnd, inorder, root_index + 1, iEnd);

            return root;     
        }
    }
```

### 执行结果

![image-20201105142210925](https://i.loli.net/2020/11/05/j7kOcFJWa68K9XG.png)

# 二叉树展开为链表

[114. 二叉树展开为链表](https://leetcode-cn.com/problems/flatten-binary-tree-to-linked-list/)

## 前序遍历

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
    public void flatten(TreeNode root) {
        // 看起来很简单
        // 展开顺序：根 左 右
        // 那这个就是前序遍历
        // 返回结果是 void, 那应该是在二叉树上直接做修改
        while(root != null){
            if(root.left == null){
                // 左子树为空，将根节点置为右子树
                root = root.right;
            }else{
                // 将右子树接到左子树的最右节点上
                TreeNode pre = root.left;
                while(pre.right != null){
                    pre = pre.right;
                }
              
                pre.right = root.right;
                // 将左子树接到右子树的节点
                root.right = root.left;
                // 左子树设置为空
                root.left = null;

                root = root.right;
            }
        }
    }
}
```

### 执行结果

![image-20201105165801114](https://i.loli.net/2020/11/05/5m34LpTKnR9WDXM.png)

# 二叉树中的最大路径和

[124. 二叉树中的最大路径和](https://leetcode-cn.com/problems/binary-tree-maximum-path-sum/)

# 根据字符出现频率排序

[451. 根据字符出现频率排序](https://leetcode-cn.com/problems/sort-characters-by-frequency/)

## 桶排序

```java
class Solution {
    public String frequencySort(String s) {
        // 看到跟谁学的面经里面有这道题
        // 利用桶排序做法

        // 初始化 HashMap
        HashMap<Character,Integer> map = new HashMap<>();
        char[] array = s.toCharArray();
        for(char ch: array){
            map.put(ch,map.getOrDefault(ch, 0) + 1 );
        }

        // 装桶
        List<Character>[] list = new List[s.length() + 1];
        // 遍历 key,将 value相同的字母加入同一个链表
        for(char key: map.keySet()){
            int i = map.get(key);
            if(list[i] == null ){
                list[i] = new ArrayList<>();
            }
            list[i].add(key);
        }

        // 倒桶，按照字母出现次数的高低，倒序输出
        char[] res = new char[s.length()];
        int index = 0;
        for(int i = s.length(); i > 0; i --){
            if(list[i] == null) continue;
            for(char ch: list[i]){
                for(int j = 0; j < i ; j ++ ){
                    res[index ++ ] = ch;
                }
            }
        }

        return new String(res);
    }
}
```

### 执行结果

![image-20201106001122725](https://i.loli.net/2020/11/06/hdp1YjsP8zvOB53.png)

# 二叉树的右视图

[199. 二叉树的右视图](https://leetcode-cn.com/problems/binary-tree-right-side-view/)

## 层序遍历 + 队列 + 输出最后一个元素

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
    public List<Integer> rightSideView(TreeNode root) {
        // 今天面试的时候就考了这一题，结果我没想出来层序遍历怎么写
        // 层序遍历需要使用队列来 存放
        // 以后每天晚上睡觉前，都把刷过的题目再看一遍

        List<Integer> list = new ArrayList<>();
        // 一般使用 链表来实现队列
        Queue<TreeNode> queue = new LinkedList<>();

        if(root != null){
            queue.offer(root);
        }

        while(!queue.isEmpty()){
            int size = queue.size();
            for(int i = 0; i < size ; i ++ ){
                TreeNode pre = queue.poll();
                if(i == size - 1){
                    list.add(pre.val);
                }
                if(pre.left != null){
                    queue.offer(pre.left);
                }
                if(pre.right != null){
                    queue.offer(pre.right);
                }
            }
        }

        return list;
    }
}
```

### 执行结果

![image-20201106205119924](https://i.loli.net/2020/11/06/u4X5QKmbsPcvTCl.png)

## DFS + 深度判断

```java
// 在面试的过程中，使用的界面就相当于记事本，需要自己去写函数和类
class Solution{
    List<Integer> res = new ArrayList<>();

    public List<Integer> rightSideView(TreeNode root){
        dfs(root, 0);
        return res;
    }

    // 按照 根 右  左 的顺序遍历
    public void dfs(TreeNode root, int depth){
        if(root == null) return ;

        if(depth == res.size()){
            res.add(root.val);
        }
        depth ++;
        dfs(root.right,depth);
        dfs(root.left,depth);
        return ;
    }
}
```

### 执行结果

![image-20201106210807088](https://i.loli.net/2020/11/06/WN6zaZnGtKkmMuE.png)

# 二叉树的最近公共祖先

[236. 二叉树的最近公共祖先](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/)

## 后序遍历

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
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        // 递归我总是想不清楚
        // 从下往上的找，可以利用 左 右 根 后序遍历

        if(root == null || root == p || root == q) return root;

        TreeNode left = lowestCommonAncestor(root.left, p, q);
        TreeNode right = lowestCommonAncestor(root.right, p , q);

        if(left == null) return right;
        if(right == null) return left;

        return root;      
    }

}
```

### 执行结果

![image-20201107231950835](https://i.loli.net/2020/11/07/CTfXsMbWlBPZ1Qu.png)

# 打家劫舍 III

[337. 打家劫舍 III](https://leetcode-cn.com/problems/house-robber-iii/)

## 层序遍历（错误解法）

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
    public int rob(TreeNode root) {
        // 像是最优化问题
        int max1 = 0;
        int max2 = 0;
        int depth = 0;
        // 好像是可以用层序遍历，他是一层层的盗取
        Queue<TreeNode> queue = new LinkedList<>();
        if(root != null) {
            queue.offer(root);
        }

        while(!queue.isEmpty()){
            int size = queue.size();
            depth ++;
            for(int i = 0; i < size ; i ++ ){
                TreeNode pre = queue.poll();
                if(depth % 2 == 1){
                    max1 += pre.val;
                    if(pre.left != null){
                        queue.offer(pre.left);
                    }
                    if(pre.right != null){
                        queue.offer(pre.right);
                    }
                }else{
                    max2 += pre.val;
                    if(pre.left != null){
                        queue.offer(pre.left);
                    }
                    if(pre.right != null){
                        queue.offer(pre.right);
                    }
                }
            }
        }

        return Math.max(max1, max2);
    }
}
```

## DFS＋哈希表

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
    HashMap<TreeNode,Integer> choose = new HashMap<>();
    HashMap<TreeNode,Integer> ignore = new HashMap<>();

    public int rob(TreeNode root) {
        // 采用深度优先搜索，利用哈希表存放节点的状态
        // 选择这个节点的最大值，不选择这个节点的最大值
        dfs(root);
        return Math.max(choose.getOrDefault(root, 0), ignore.getOrDefault(root, 0));     
    }

    public void dfs(TreeNode root){
        if(root == null) return ;
        dfs(root.left);
        dfs(root.right);

        choose.put(root, root.val + ignore.getOrDefault(root.left, 0) + ignore.getOrDefault(root.right, 0));
        ignore.put(root, Math.max(choose.getOrDefault(root.left, 0), ignore.getOrDefault(root.left, 0)) + Math.max(choose.getOrDefault(root.right, 0), ignore.getOrDefault(root.right, 0)));

        return;
    }
}
```

### 执行结果

![image-20201108000213034](https://i.loli.net/2020/11/08/J6khC8judg21Ta7.png)

# 路径总和 III

[437. 路径总和 III](https://leetcode-cn.com/problems/path-sum-iii/)

## 前缀和

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
    HashMap<Integer, Integer> map = new HashMap<>();
    public int pathSum(TreeNode root, int sum) {
        // 为什么自己这么垃圾啊，刚刚写的时候也想过用一个HashMap来存放节点的和
        // 但是就是考虑不到可以利用两个节点之间的前缀和关系
        map.put(0, 1);
        return getPath(root, sum, 0);
    }

    public int getPath(TreeNode root, int sum, int count){
        if(root == null) return 0;

        int res = 0;
        count += root.val;
        // 如果一个节点的前缀和为 count , 另一个节点的前缀和为 count - sum, 
        // 则两个节点之间的前缀和为 sum
        res += map.getOrDefault(count - sum, 0);
        map.put(count, map.getOrDefault(count, 0) + 1);

        res += getPath(root.left, sum, count);
        res += getPath(root.right, sum, count);

        // 因为只有当前的节点的子节点才会用到该节点的前缀和，因此返回后需要清楚
        map.put(count,  map.getOrDefault(count, 0) - 1);

        return res;
    }
}
```

### 执行结果

![image-20201108155209048](https://i.loli.net/2020/11/08/UwJ3dr2CtKgyTDG.png)

## 双重递归

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
    public int pathSum(TreeNode root, int sum) {
        // 双重递归的思路，是从一个节点开始，去递归它是否存放一条和为sum的路径
        // 之后再从别的节点开始重新递归
        if(root == null) return 0;

        return getPath(root, sum) + pathSum(root.left, sum) + pathSum(root.right, sum);
    }

    public int getPath(TreeNode root, int sum){
        if(root == null) return 0;

        int res = (sum - root.val) == 0 ? 1 : 0;

        return res + getPath(root.left, sum - root.val) + getPath(root.right, sum - root.val);
    }
}
```

### 执行结果

![image-20201108161450505](https://i.loli.net/2020/11/08/YqLeQorNfjhdOkx.png)

# 把二叉搜索树转换为累加树

[538. 把二叉搜索树转换为累加树](https://leetcode-cn.com/problems/convert-bst-to-greater-tree/)

## DFS + 右根左

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
    int sum = 0;
    public TreeNode convertBST(TreeNode root) {
        // 右 根 左
        dfs(root);
        return root;
    }

    public void dfs(TreeNode root){
        if(root == null) return ;
        
        dfs(root.right);
        root.val += sum;
        sum = root.val;
        dfs(root.left);

        return ;
    }
}
```

### 执行结果

![image-20201108164323770](https://i.loli.net/2020/11/08/U9GxutTY7rDCOIa.png)

# 第一目标完成

![image-20201108164543962](https://i.loli.net/2020/11/08/W42d5th1soITyQ9.png)

自己刷了十几题的树，发现所有的题其实都是遍历问题，要学会把握遍历的顺序（根，左，右 间的次序交换）。

但是自己离十五分钟内，做出中等难度的算法题的目标，还相差甚远。因此打算另开一张，继续接着刷树类型，及其他高频的算法题。

