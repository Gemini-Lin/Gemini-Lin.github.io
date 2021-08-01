---
title: LeetCode-SortingAlgorithm
date: 2020-11-06 21:13:30
tags:
- 排序算法
categories: 
- LeetCode
---

# Free Talk

今天面试的时候，因为第一道算法题没有做出来，面试官特地又给了一道排序算法，我想了想只想到冒泡，而且还没有实现出来。趁着这个机会，今天晚上正好总结一下常用的排序算法。

<!--more-->

# 排序数组

[912. 排序数组](https://leetcode-cn.com/problems/sort-an-array/)

```java
给你一个整数数组 nums，请你将该数组升序排列。
    输入：nums = [5,2,3,1]
	输出：[1,2,3,5]
```

# 选择排序

```java
class Solution {
    public int[] sortArray(int[] nums) {
        // 第一个排序算法是选择排序
        // 选择未排定的数组中最小的一个，放到数组最前面
        for(int i = 0; i < nums.length; i ++ ){
            int min = nums[i];
            int min_index = i;
            for(int j = i + 1; j < nums.length ; j ++ ){
                if(nums[j] < min){
                    min = nums[j];
                    min_index = j;
                }
            }
            nums[min_index] = nums[i];
            nums[i] = min;     
        }
        return nums;
    }
}
```

时间复杂度：O(n^2)

空间复杂度：O(1)

## 执行结果

![image-20201106213220767](https://i.loli.net/2020/11/06/uHLVMhXRSyJdNqp.png)



# 插入排序

```java
class Solution {
    public int[] sortArray(int[] nums) {
        // 插入排序
        // 将一个元素插入已经排好序的元素中
        for(int i = 1;  i < nums.length ; i ++ ){
            int j = i;
            // 这边一开始忘记要存放这个变量，因为后面右移的时候会覆盖掉这个值
            int tmp = nums[i];
            while(j > 0 && nums[j - 1] > tmp){
                nums[j] = nums[j - 1];
                j --;
            }
            nums[j] = tmp;
        }
        return nums;
    }
}
```

![image-20201106221553367](https://i.loli.net/2020/11/06/THqp15YegaKNitf.png)

## 对链表进行插入排序

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
    public ListNode insertionSortList(ListNode head) {
        // 我想对链表进行操作，也可以用刚刚学的到插入排序
        // 链表操作比较困难的是，没法实现数组的倒序比较
        // 节点之间的修改真的很烦
        if(head == null || head.next == null) return head;
        ListNode node = new ListNode(0);
        node.next = head;
        ListNode pre = head;
        ListNode cur = head.next;
        while(cur != null){
            if(cur.val > pre.val){
                pre = cur;
                cur = cur.next;
            }else{
                ListNode tmp = node;
                while(tmp.next != cur && tmp.next.val < cur.val){
                    tmp = tmp.next;
                }
                // 这边的节点修改特别绕、
                // 必须认真的画个图看看
                pre.next = cur.next;
                cur.next = tmp.next;
                tmp.next = cur;
                cur = pre.next;
            }
        }
        return node.next;
    }
}
```

### 执行结果

![image-20201106221540976](https://i.loli.net/2020/11/06/wKnGk7uFTZBLXfx.png)

## 理解链表插入

```java
// 因为链表的插入不熟悉，这边自己再写一遍
class Solution{
    public ListNode insertionSortList(ListNode root){
        if(root == null || root.next == null) return root;

        // 设置一个头节点
        ListNode node = new ListNode(0);
        node.next = root;
        // 设置一个前节点
        ListNode pre = root;
        // 设置一个当前节点, 为了进行链表插入的方便
        ListNode cur = root.next;
        
        while(cur != null){
            // 当前节点的值比之前按排序好的都大
            if(cur.val > pre.val){
                pre = cur;
                cur = cur.next;
            }else{
                ListNode tmp = node;
                // 注意因为可以插入第一节点，所以要从头节点开始，便于插入
                while(tmp.next != cur && tmp.next.val < cur.val){
                    tmp = tmp.next;
                }
                // 存放当前 cur 的值，插入后 cur 往后移一个
                pre.next = cur.next;
                // 将 cur 节点 插入 tmp 节点 后面的位置
                cur.next = tmp.next;
                tmp.next = cur;
                // 使 cur 节点表示 已排序链表的 后一个节点
                cur = pre.next;
            }
        }

        return node.next;
    }
}
```

### 执行结果

![image-20201107092450178](https://i.loli.net/2020/11/07/2CXntdajPeq9UxL.png)

# 归并排序

[88. 合并两个有序数组](https://leetcode-cn.com/problems/merge-sorted-array/)

```java
class Solution {
    int[] tmp;
    public int[] sortArray(int[] nums) {
        // 再写一个归并排序
        // 合并两个有序的数组
        // 需要使用一个额外的数组来存储
        tmp = new int[nums.length];
        mergeSort(nums, 0 , nums.length - 1);
        return nums;
    }

    public void mergeSort(int[] nums, int left ,int right){
        if(left >= right) return;
        int mid = (left + right) >>> 1;
        mergeSort(nums, left, mid);
        mergeSort(nums, mid + 1, right);
        int i = left;
        int j = mid + 1;
        int count = 0;
        while(i <= mid && j <= right){
            if(nums[i] < nums[j]){
                tmp[count ++] = nums[i ++];
            }else{
                tmp[count ++] = nums[j ++];
            }
        }

        while(i <= mid){
            tmp[count ++] = nums[i ++];
        }

        while(j <= right){
            tmp[count ++] = nums[j ++];
        }

        for(int k = left; k <= right; k ++){
            nums[k] = tmp[k - left];
        }
    }
}
```

![image-20201107223118370](https://i.loli.net/2020/11/07/v63FEjXAUegftyL.png)

## 辅助数组

```java
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
    // 可以创建一个辅助数组，存放两个数组的值
        int[] res = new int[m + n];
        // 两个数组都是有序的
        int count = 0;
        int j = 0;
        for(int i = 0 ; i < m ; i ++ ){
            if (j < n && nums1[i] > nums2[j]) {
                while (j < n && nums1[i] > nums2[j]) {
                    res[count++] = nums2[j];
                    j++;
                }
            }
            res[count ++ ] = nums1[i];
        }

        while(j != n){
            res[count ++] = nums2[j];
            j ++;
        }
        // 好像只能识别这种方式的数组复制
        System.arraycopy(res, 0, nums1, 0 , m + n);
    }
}
```

### 执行结果

![image-20201107110449468](https://i.loli.net/2020/11/07/heKxgTH8I26Vck4.png)

## 从后往前比

```java
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
    // 从后往前比较，就可以不使用额外的空间
        // 两个数组都是有序的
        int count = m + n - 1;
        int j = n - 1;
        int i = m - 1;
        for(i = m  - 1; i >= 0 ; i -- ){
            if (j >= 0 && nums1[i] < nums2[j]) {
                while (j >= 0 && nums1[i] < nums2[j]) {
                    nums1[count --] = nums2[j];
                    j --;
                }
            }
            nums1[count -- ] = nums1[i];
        }

        while(count >= 0){
            nums1[count --] = nums2[j --];
        }
    }
}
```

### 执行结果

![image-20201107112248759](https://i.loli.net/2020/11/07/BviqsWPoJrdfhp8.png)

# 快速排序

```java
class Solution {
    public int[] sortArray(int[] nums) {
        // 快排解法
        // 快排是每次确定的一个 元素 在数组中位置，一分为二，进行递归

        quicksort(nums, 0 , nums.length - 1);
        return nums;

    }
    public void quicksort(int[] nums, int left, int right){
        if(left < right){
            // 得到 分治点
            int mid = partition(nums, left, right);
            quicksort(nums, left, mid - 1);
            quicksort(nums, mid + 1, right);
        }
    }

    // 确定元素在数组中的位置
    public int partition(int[] nums, int left, int right){
        int j = left ;
        for(int i = left ; i < right  ; i ++ ){
            if(nums[i] < nums[right]){
                swap(nums, i , j);
                j ++;
            }
        }
        swap(nums, j, right);
        return j;
    }

    public void swap(int[] nums, int i, int j){
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
}
```

## 执行结果

![image-20201107121245735](https://i.loli.net/2020/11/07/IsQhvGuLWxdSctr.png)

# 堆排序

```java
class Solution {
    public int[] sortArray(int[] nums) {
        // 看了相当久的堆排序
        // 先构建一个大根堆（父节点的值大于子节点的值）
        // 将父节点与末尾节点交换，
        // 将剩下的节点继续构成大根堆
        heapify(nums);
        int length = nums.length;
        for(int i = length - 1; i > 0 ; ){
            // 将根节点与末尾节点交换
            swap(nums, 0 , i);
            i --;
            siftDown(nums, 0 ,i);
        }
        return nums;
    }

    public void heapify(int[] nums){
        int length = nums.length;
        // 从中间的节点开始遍历，因为这样就已经遍历到全部的节点了
        for(int i = (length - 1) / 2 ; i >= 0; i --){
            siftDown(nums, i , length - 1);
        }
    }

    public void siftDown(int[] nums, int k, int end){
        while(2 * k + 1 <= end){
            int j = 2 * k + 1;
            // 如果右叶子节点大于左叶子节点，就将右叶子节点与父节点交换
            if(j + 1 <= end && nums[j] <= nums[j + 1]){
                j ++ ;
            }
            // 父节点比子节点都大，就直接返回
            if(nums[j] > nums[k]){
                swap(nums, j , k);
            }else{
                break;
            }
            // 继续遍历下一个节点
            k = j;
        }
    }

    public void swap(int[] nums, int i ,int j){
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
}
```

堆排序参考资料：https://www.cnblogs.com/mtgh/p/11374434.html

- 时间复杂度：O(NlogN)，这里 *N* 是数组的长度；
- 空间复杂度：O(1)。

## 执行结果

![image-20201107214134707](https://i.loli.net/2020/11/07/DPoByW7vTA4zCZm.png)

# 冒泡排序

## 简单版

```java
class Solution {
    public int[] sortArray(int[] nums) {
        // 冒泡排序
        // 依次比较相邻的两个树，一次遍历就将最大的数放到了最后面
        for(int i = 0; i < nums.length; i ++ ){
            for(int j = 0; j < nums.length - i - 1; j ++ ){
                if(nums[j] > nums[j + 1]){
                    swap(nums, j , j + 1);
                }
            }
        }
        return nums;
    }

    public void swap(int[] nums, int i , int j){
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
}
```

## 标识位优化

```java
class Solution {
    public int[] sortArray(int[] nums) {
        // 冒泡排序
        // 依次比较相邻的两个树，一次遍历就将最大的树放到了最后面
        // 加入了标识位，用于判断内侧循环的数组是否已经是排序完成了
        boolean sort = false;
        for(int i = 0; i < nums.length; i ++ ){
            for(int j = 0; j < nums.length - i - 1; j ++ ){
                sort = true;
                if(nums[j] > nums[j + 1]){
                    swap(nums, j , j + 1);
                    sort = false;
                }
            }
            if(sort) break;
        }
        return nums;
    }

    public void swap(int[] nums, int i , int j){
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
}
```

