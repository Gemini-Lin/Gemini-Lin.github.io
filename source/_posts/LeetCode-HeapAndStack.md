---
title: LeetCode-HeapAndStack
date: 2020-10-26 10:37:19
tags:
- LeetCode
- Heap
- Stack
categories: 
- LeetCode
---

# Free Talk

再来写写 堆 和 栈 相关的题， 最近有点**渐入佳境**了。

<!--more-->

# Finished Problem

![image-20201026103844697](https://i.loli.net/2020/10/26/ZdIFpmona5lyDHs.png)

# 柱形图中最大的矩形

[84. 柱状图中最大的矩形](https://leetcode-cn.com/problems/largest-rectangle-in-histogram/)

## 动态规划 + 暴力破解

```java
class Solution {
    public int largestRectangleArea(int[] heights) {
        // S = Math.min(heights[i], heights[j]) * (j - i + 1)
        // 采用暴力解法，两次遍历，动态规划

        if(heights.length == 0) return 0;
        int S = 0;

        // 表示从 i 到 j 中的最小值
        // dp[i][j] = Math.min(dp[i][j - 1], heights[j])
        int[][] dp = new int[heights.length][heights.length];

        for(int i = 0; i < heights.length; i ++ ){
            dp[i][0] = heights[i];
            for(int j = i; j < heights.length; j ++ ){
                if(j == i) dp[i][j] = heights[i];
                else dp[i][j] = Math.min(dp[i][j - 1], heights[j]);
                S = Math.max(S, dp[i][j] * (j - i + 1));
            }
        }

        return S;
    }
}
```

### 超出内存限制

![image-20201026145549281](https://i.loli.net/2020/10/26/Q2DSB7FEVJNsf1z.png)

![image-20201026145507877](https://i.loli.net/2020/10/26/zVkIofTtW3nHJEa.png)

## 确定高度 + 栈存放宽度索引

```java
class Solution {
    public int largestRectangleArea(int[] heights) {
        // 先确定最高高度，再去找对应的宽度
        // 用栈来存放索引，比较得到左右的索引
        int n = heights.length;
        if(n == 0) return 0;
        int[] left = new int[n];
        int[] right = new int[n];
        int maxArea = 0;

        Stack<Integer> stack = new Stack<Integer>();
        for(int i = 0; i < n ; i ++ ){
            while(!stack.empty() && heights[stack.peek()] >= heights[i]){
                stack.pop();
            }
            left[i] = stack.empty() ? -1 : stack.peek();
            stack.push(i);
        }

        stack.clear();
        for(int i = n - 1; i >= 0 ; i -- ){
            while(!stack.empty() && heights[stack.peek()] >= heights[i]){
                stack.pop();
            }
            right[i] = stack.empty() ? n : stack.peek();
            stack.push(i);
        }

        for(int i = 0; i < n ; i ++ ){
            maxArea = Math.max(maxArea, (right[i] - left[i] - 1)* heights[i]);
        }

        return maxArea;
    }
}
```

### 执行结果

![image-20201026154859324](https://i.loli.net/2020/10/26/bxegtImOLYUfz4C.png)

# 最小栈

[155. 最小栈](https://leetcode-cn.com/problems/min-stack/)

## 题型新颖 + 辅助栈

```java
class MinStack {

    public Stack<Integer> stack;
    public Stack<Integer> minStack;
    /** initialize your data structure here. */
    // 第一次见到这种类型的题目，有点懵逼
    // 解题思路其实很简单，利用一个辅助栈来存放，保持栈顶元素始终为最小值
    public MinStack() {
        stack = new Stack<>();
        minStack = new Stack<>();
    }
    
    public void push(int x) {
        stack.push(x);
        if(minStack.empty() || x <= minStack.peek()){
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
    
    public int getMin() {
        return minStack.peek();
    }
}

/**
 * Your MinStack object will be instantiated and called as such:
 * MinStack obj = new MinStack();
 * obj.push(x);
 * obj.pop();
 * int param_3 = obj.top();
 * int param_4 = obj.getMin();
 */
```

### 执行结果

![image-20201026160256289](https://i.loli.net/2020/10/26/ONt7L1jhWBxVJQe.png)

# 数组中的第K个最大元素

[215. 数组中的第K个最大元素](https://leetcode-cn.com/problems/kth-largest-element-in-an-array/)

## 元素入栈再出栈

```java
class Solution {
    public int findKthLargest(int[] nums, int k) {
        // 感觉这道题特别熟悉
        // 前 K 个高频元素 和这题相当相似
        // 思路：
        // 首先第一步是将数组排序后入栈
        // 根据 K 值 依次出栈
        Arrays.sort(nums);
        int res = 0;

        Stack<Integer> stack = new Stack<Integer>();

        for(int num: nums){
            stack.push(num);
        }

        for(int i = 0; i < k; i ++ ){
            res = stack.pop();
        }

        return res;

    }
}
```

### 执行结果

![image-20201028093855572](https://i.loli.net/2020/10/28/ULBnINrul67MwdC.png)

# 滑动窗口最大值

[239. 滑动窗口最大值](https://leetcode-cn.com/problems/sliding-window-maximum/)

## 两层循环

```java
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        // 求解滑动窗口内的最大值
        int n = nums.length;
        int[] res = new int[n - k + 1];
        int max = nums[0];

        for(int i = 0; i < n - k + 1; i ++ ){
                max = nums[i];
            for(int j = i + 1; j < i + k; j ++ ){
                if(nums[j] > max) max =nums[j];
            }
            res[i] = max;
        }
        return res;
    }
}
```

### 超时

![image-20201028105934922](https://i.loli.net/2020/10/28/TLjWkOdoVtY9CUK.png)

![image-20201028105947718](https://i.loli.net/2020/10/28/IYReKk9ritdmMHf.png)

## 双向队列

```java
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        // 思考能不能降低时间复杂度
        // 每次移动窗口，其实就是右边的新增一个，左边减少一个元素
        // 可以通过一个双向队列来存放滑动窗口的值
        // 队列内的元素按照从大到小的顺序排列
        int n = nums.length;

        if(n <= 1) return nums;

        int[] res = new int[n - k + 1];
        LinkedList<Integer> deque = new LinkedList<Integer>();

        for(int i = 0; i < n; i ++ ){
            // 如果队列末尾的元素，小于当前元素，则依次出队列，
            while(!deque.isEmpty() && nums[deque.peekLast()] <= nums[i]){
                deque.pollLast();
            }
            // 添加当前元素的索引
            deque.addLast(i);

            // 如果当前的队首元素，也就是最大元素的索引在 滑动窗口之外
            if(deque.getFirst() < i - k + 1){
                deque.pollFirst();
            }

            // 当窗口的长度为 K 时，保存当前窗口的最大值
            if(i - k + 1 >= 0){
                res[i - k + 1] = nums[deque.getFirst()];
            }
        }
        return res;
    }
}
```

### 执行结果

![image-20201028125229951](https://i.loli.net/2020/10/28/iSXo5TP81Ryz2Ga.png)

# 字符串解码

[394. 字符串解码](https://leetcode-cn.com/problems/decode-string/)

## 错误代码

```java
class Solution {
    public String decodeString(String s) {
        // 有点像是正则表达式
        // 可以利用栈来存放 
        // 把左方括号的索引 i 入栈，当遇到右方括号 j 时出栈
        // 要解码的字符串为 tmp
        // s.charAt(i - 1) * s.substring(i + 1,j)
        // 然后把 tmp 字符串 替换 原字符串中 的 [i - 1, j]区间
        if(s.length() == 0) return null;

        Stack<Integer> stack = new Stack<Integer>();
        String tmp = null;

        for(int i = 0; i < s.length(); i ++ ){
            if(s.charAt(i) == '['){
                stack.push(i);
            }
            if(s.charAt(i) == ']'){
                int j = stack.pop();
                int times = s.charAt(j - 1) - '0';
                String sub = s.substring(j + 1, i);
                int length = sub.length();
                tmp =  String.join("", Collections.nCopies(times, sub));
                s = String.join("",s.substring(0, j - 1), tmp , s.substring(i + 1, s.length()));
            }
        }
        return s;
    }
}
```

### 测试结果

![image-20201028161704314](https://i.loli.net/2020/10/28/buqBQN7wLsUX2EJ.png)

## 更改结果

刚刚错误的原因主要有两个：

1. 没有考虑前面的数字不只有一位，改为通过一个循环记录数字
2. 没有考虑替换数组后的重新遍历的起点，修改为正确的遍历起点

```java
class Solution {
    public String decodeString(String s) {
        // 有点像是正则表达式
        // 可以利用栈来存放 
        // 把左方括号的索引 i 入栈，当遇到右方括号 j 时出栈
        // 要解码的字符串为 tmp
        // s.charAt(i - 1) * s.substring(i + 1,j)
        // 然后把 tmp 字符串 替换 原字符串中 的 [i - 1, j]区间
        if(s.length() == 0) return "";

        Stack<Integer> stack = new Stack<Integer>();
        String tmp = null;

        for(int i = 0; i < s.length();){
            if(s.charAt(i) == '['){
                stack.push(i);
            }
            if(s.charAt(i) == ']'){
                int j = stack.pop();
                int m = j;
                int time = 1;
                int times = 0;
                int count = 0;

                while((s.charAt(m - 1) >= '0') && (s.charAt(m - 1) <= '9')){
                    times = (s.charAt(m - 1) - '0') * time + times;
                    time = time * 10;
                    m --;
                    count ++;
                    if(m < 1) break;
                }

                String sub = s.substring(j + 1, i);
                int length = sub.length();
                tmp =  String.join("", Collections.nCopies(times, sub));
                s = String.join("",s.substring(0, j - count), tmp , s.substring(i + 1, s.length()));
                i = j + times * length - count - 1;
            }
            i ++;
        }
        return s;
    }
}
```

### 执行结果

![image-20201028164616802](https://i.loli.net/2020/10/28/mWDAG6Bc8pTJHMk.png)

# 完结撒花

![image-20201028164733742](https://i.loli.net/2020/10/28/imVSyhCvajeRLpP.png)