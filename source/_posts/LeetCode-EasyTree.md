---
title: LeetCode-EasyTree
date: 2020-11-08 17:00:24
tags:
- LeetCode
- Tree
- Easy
categories: 
- LeetCode
---

# Free Talk

开始专门针对 Tree 的刷题训练，先刷个 10 题的简单类型，练练感觉。

目标：10 题内 80% 以上都不看题解，全部由自己完成。

<!--more-->

# Problems

![image-20201108170445639](https://i.loli.net/2020/11/08/RVJ6KL13GeBmsja.png)

# 相同的树

[100. 相同的树](https://leetcode-cn.com/problems/same-tree/)

## DFS + Boolean

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
    boolean same = true;
    public boolean isSameTree(TreeNode p, TreeNode q) {
        dfs(p, q);
        return same;
    }

    public void dfs(TreeNode p, TreeNode q){
        if(p == null && q == null) return ;
        if(q == null || p == null){
            same = false;
            return;
        } 
        if(p.val != q.val){
            same =false;
            return;
        }
        dfs(p.left, q.left);
        dfs(p.right, q.right);

        return;
    }
}
```

### 执行结果

![image-20201108171942801](https://i.loli.net/2020/11/08/ioENK6jsanLztwC.png)

# 二叉树的层序遍历 II

[107. 二叉树的层次遍历 II](https://leetcode-cn.com/problems/binary-tree-level-order-traversal-ii/)

## 队列 + 栈（逆序输出）

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
    
    public List<List<Integer>> levelOrderBottom(TreeNode root) {
        // 左 右 根
        // 层序遍历
        // 使用队列
        Queue<TreeNode> queue = new LinkedList<>();
        Stack<List> stack = new Stack<>();

        if(root != null){
            queue.offer(root);
        }

        List<List<Integer>> res = new ArrayList<>();

        while(!queue.isEmpty()){
            int size = queue.size();
            List<Integer> layer = new ArrayList<>();
            for(int i = 0; i < size ; i ++ ){
                TreeNode pre = queue.poll();
                layer.add(pre.val);
                if(pre.left != null){
                    queue.offer(pre.left);
                }
                if(pre.right != null){
                    queue.offer(pre.right);
                }
            }
            stack.push(layer);
        }

        while(!stack.isEmpty()){
            res.add(stack.pop());
        }
        
        return res;
    }

}
```

### 执行结果

![image-20201108174055864](https://i.loli.net/2020/11/08/b38LypUvTmPltZz.png)

## 头插法 + 队列

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
    
    public List<List<Integer>> levelOrderBottom(TreeNode root) {
        // 左 右 根
        // 层序遍历
        // 使用队列
        // 链表的插入有头插和尾插，使用头插就可以实现逆序，不需要再用一个栈
        Queue<TreeNode> queue = new LinkedList<>();

        if(root != null){
            queue.offer(root);
        }

        List<List<Integer>> res = new ArrayList<>();

        while(!queue.isEmpty()){
            int size = queue.size();
            List<Integer> layer = new ArrayList<>();
            for(int i = 0; i < size ; i ++ ){
                TreeNode pre = queue.poll();
                layer.add(pre.val);
                if(pre.left != null){
                    queue.offer(pre.left);
                }
                if(pre.right != null){
                    queue.offer(pre.right);
                }
            }
            res.add(0, layer);
        }

        return res;
    }

}
```

### 执行结果

![image-20201108174604986](https://i.loli.net/2020/11/08/OQFdkvr2mZxh8Cp.png)

 # 将有序数组转换为二叉搜索树

[108. 将有序数组转换为二叉搜索树](https://leetcode-cn.com/problems/convert-sorted-array-to-binary-search-tree/)

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
    public TreeNode sortedArrayToBST(int[] nums) {
        // 二叉搜索树可以通过中序遍历得到一个升序数组
        // 那么应该怎么转过来呢
        return dfs(nums, 0 , nums.length);
    }

    public TreeNode dfs(int[] nums, int left, int right){
        if(left >= right) return null;

        int mid = (left + right) >>> 1;
        TreeNode root = new TreeNode(nums[mid]);
        root.left = dfs(nums, left, mid);
        root.right = dfs(nums, mid + 1, right);
        return root;
    }
}
```

### 执行结果

![image-20201108203040541](https://i.loli.net/2020/11/08/1pRIcQbzqt8EfXH.png)

# 平衡二叉树

[110. 平衡二叉树](https://leetcode-cn.com/problems/balanced-binary-tree/)

## 后序遍历 + 哈希表

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
    HashMap<TreeNode,Integer> leftMap = new HashMap<>();
    HashMap<TreeNode,Integer> rightMap = new HashMap<>();
    boolean balance = true;
    public boolean isBalanced(TreeNode root) {
        // 左 右 根
        if(root == null) return true;
        dfs(root);
        return balance;
    }

    public void dfs(TreeNode root){
        if(root == null) return;

        dfs(root.left);
        dfs(root.right);

        leftMap.put(root, Math.max(leftMap.getOrDefault(root.left, 0) + 1,rightMap.getOrDefault(root.left, 0) + 1 ));
        rightMap.put(root, Math.max(leftMap.getOrDefault(root.right, 0) + 1,rightMap.getOrDefault(root.right, 0) + 1 ));
        if(Math.abs(leftMap.get(root) - rightMap.get(root)) > 1) balance = false;
        return;
    }
}
```

### 执行结果

![image-20201108205516421](https://i.loli.net/2020/11/08/wJhPct1S6DlUNzu.png)

## 优化版 + 提前结束递归

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
    HashMap<TreeNode,Integer> leftMap = new HashMap<>();
    HashMap<TreeNode,Integer> rightMap = new HashMap<>();
    boolean balance = true;
    public boolean isBalanced(TreeNode root) {
        // 左 右 根
        if(root == null) return true;
        dfs(root);
        return balance;
    }

    public void dfs(TreeNode root){
        if(root == null) return;
        
        if(balance){
            dfs(root.left);
            dfs(root.right);

            leftMap.put(root, Math.max(leftMap.getOrDefault(root.left, 0) + 1,rightMap.getOrDefault(root.left, 0) + 1 ));
            rightMap.put(root, Math.max(leftMap.getOrDefault(root.right, 0) + 1,rightMap.getOrDefault(root.right, 0) + 1 ));
            if(Math.abs(leftMap.get(root) - rightMap.get(root)) > 1) balance = false;
        }

        return;
    }
}
```

### 执行结果

![image-20201108210502392](https://i.loli.net/2020/11/08/E7kMJ5L41mIlD8b.png)

##  函数返回值存储 + 提前中断

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
    public boolean isBalanced(TreeNode root) {
        // 其实可以不用哈希表来存放节点的左右子树情况
        // 因为只使用了一次，可以直接放在函数返回值里
        // 同时利用了后序遍历，自顶向下判断，可以提前终止
        return dfs(root) != - 1;
    }

    public int dfs(TreeNode root){
        if(root == null) return 0;
        
        int left = dfs(root.left);
        if(left == -1) return -1;
        int right = dfs(root.right);
        if(right == -1) return -1;
        return Math.abs(left - right) >= 2 ? -1 : Math.max(left, right) + 1;
    }
}
```

### 执行结果

![image-20201108212543334](https://i.loli.net/2020/11/08/XEc7dNK5ILtzemO.png)

# 二叉树的最小深度

[111. 二叉树的最小深度](https://leetcode-cn.com/problems/minimum-depth-of-binary-tree/)

## 深度优先遍历

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
    public int minDepth(TreeNode root) {
        // 深度优先遍历，加上一个深度存储
        return dfs(root);
    }

    public int dfs(TreeNode root){
        if(root == null) return 0;

        int left = dfs(root.left);
        int right = dfs(root.right);

        if(left == 0 && right != 0) return right + 1;
        if(left != 0 && right == 0) return left + 1;
        return Math.min(left, right) + 1;
    }
}
```

### 执行结果

![image-20201108214452468](https://i.loli.net/2020/11/08/wCMc1sqoOSuN8e6.png)

终于刷完 LeetCode 100 题了 ！！！！！

![image-20201109090623287](https://i.loli.net/2020/11/09/otCixdPWhEVYyp5.png)

# 路径总和

## 后序遍历 + 提前终止

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
    boolean path = false;
    public boolean hasPathSum(TreeNode root, int sum) {
        // 递归 
        // 用后序遍历
        // 左 右 根
        dfs(root, sum);
        return path;
    }

    public void dfs(TreeNode root, int sum){
        if(root == null) return ;

        if(path) return;
        dfs(root.left, sum - root.val);
        dfs(root.right, sum - root.val);
        if(root.left == null && root.right == null && (sum - root.val) == 0){
            path = true;
        }
        return ;
    }
}
```

### 执行结果

![image-20201109092400678](https://i.loli.net/2020/11/09/XdLAPFUTxZpuNyD.png)

# 二叉搜索树的最近公共祖先

[235. 二叉搜索树的最近公共祖先](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-search-tree/)

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
        // 左 右 根
        return dfs(root, p , q);
    }

    public TreeNode dfs(TreeNode root, TreeNode p, TreeNode q){
        if(root == null || root == p || root == q) return root;

        TreeNode left = dfs(root.left, p , q);
        TreeNode right = dfs(root.right, p , q);
        if(left == null) return right;
        if(right == null) return left;
        return root;
    }
}
```

### 执行结果

![image-20201109094726557](https://i.loli.net/2020/11/09/4RAoMkVdCOPJnQ9.png)

## 范围优化

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
        // 应该可以利用二叉搜索树的特性来解
        return dfs(root, p ,q);
    }

    public TreeNode dfs(TreeNode root, TreeNode p , TreeNode q){
        if(root == null || root == p || root == q) return root;

        // 缩小一下遍历的范围
        if(root.val >= p.val && root.val >= q.val){
          return dfs(root.left, p ,q);
        }

        if(root.val <= p.val && root.val <= q.val){
           return dfs(root.right, p ,q);
        }

        return root;

    }
}
```

### 执行结果

![image-20201109100607400](https://i.loli.net/2020/11/09/i7523oQxc1jEPDb.png)

#　二叉树的所有路径

[257. 二叉树的所有路径](https://leetcode-cn.com/problems/binary-tree-paths/)

## 深度优先遍历 + StringBuilder

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
    public List<String> binaryTreePaths(TreeNode root) {
        // 深度优先遍历
        // 道理比较简单，输出这种字符串类型我是服了
        List<String> res = new ArrayList<>();
        dfs(root, "", res);
        return res;
    }

    public void dfs(TreeNode root, String path, List<String> res){
        if(root == null) return ;
        StringBuilder pathSB = new StringBuilder(path);
        pathSB.append(Integer.toString(root.val));
        if(root.left == null && root.right == null){
            res.add(pathSB.toString());
        }else{
            pathSB.append("->");
            dfs(root.left, pathSB.toString(), res);
            dfs(root.right, pathSB.toString(), res);
        }
        return ;
    }
}
```

### 执行结果

![image-20201109102413784](https://i.loli.net/2020/11/09/XSoAgMLQ45fnpst.png)

# 左叶子之和

## 一次判断两层(左右节点是否为叶子节点)

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
    public int sumOfLeftLeaves(TreeNode root) {
        if(root == null) return 0;
        return dfs(root);
    }

    public int dfs(TreeNode root){
        int res = 0;
        if(root.left != null){
            res += isLeaves(root.left) ? root.left.val : dfs(root.left);
        }
        if(root.right != null){
            res += isLeaves(root.right) ? 0 : dfs(root.right);
        }

        return res;
    }

    public boolean isLeaves(TreeNode root){
        if(root.left == null && root.right == null) return true;
        return false;
    }
}
```

### 执行结果

![image-20201109105931599](https://i.loli.net/2020/11/09/uTAXkzCZ5fPwRr4.png)

# 二叉搜索树中的众树

[501. 二叉搜索树中的众数](https://leetcode-cn.com/problems/find-mode-in-binary-search-tree/)

## 中序遍历 + 列表

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
    List<Integer> list = new ArrayList<>();
    int current = 0;
    int count = 0;
    int maxCount = 0;
    public int[] findMode(TreeNode root) {
        // 第一想法是用一个哈希表存放结点的值
        // 但是这个是二叉搜索树，可以使用它的节点特性
        // 利用二叉搜索树的中序遍历是升序的
        dfs(root);
        int [] res = new int[list.size()];
        for(int i = 0; i < list.size(); i ++ ){
            res[i] = list.get(i);
        }
        return res;
    }

    public void dfs(TreeNode root){
        if(root == null) return ;

        dfs(root.left);

        if(root.val == current){
            count ++;
        }else{
            current = root.val;
            count = 1;
        }
        if(count ==  maxCount){
            list.add(current);
        }
        if(count > maxCount){
            maxCount = count;
            list.clear();
            list.add(current);
        }

        dfs(root.right);
    }
}
```

### 执行结果

![image-20201109112654913](https://i.loli.net/2020/11/09/KIEexgmVNRGHnqW.png)

# 完结撒花

![image-20201109114335148](https://i.loli.net/2020/11/09/KPqae29ykw8Gb5p.png)

我发现刷题就应该先从简单做起，中等难度的题型很多都是简单难度的变形或者组合而成。