---
title: Leetcode Tencent 50 Task 27 88. Merge Sorted Array
date: 2019-09-09 20:23:33
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task27。
---

# 描述

给定两个有序整数数组` nums1` 和 `nums2`，将` nums2 `合并到 `nums1 `中，使得 `num1` 成为一个有序数组。

**说明:**

- 初始化` nums1` 和 `nums2` 的元素数量分别为 `m` 和 `n`。
- 你可以假设` nums1` 有足够的空间（空间大小大于或等于 m + n）来保存` nums2` 中的元素。


**示例:**

```c
输入:
nums1 = [1,2,3,0,0,0], m = 3
nums2 = [2,5,6],       n = 3

输出: [1,2,2,3,5,6]
```


来源：力扣（LeetCode)
链接：[88. Merge Sorted Array](https://leetcode-cn.com/problems/merge-sorted-array)

# 解题思路

根据题意，本题的思路还是比较简单的，采用双指针，为了节省空间，直接从后往前，因为`nums1`数组足够大，那么所有的元素从大到小，从`nums1`后面开始往前进行填充，具体代码如下：

# 代码

```c
void merge(int* nums1, int nums1Size, int m, int* nums2, int nums2Size, int n)
{
    
    int k = m + n - 1;
    int i = m - 1, j = n - 1;
    while(i >= 0 && j >= 0)
    {
        if(nums1[i] > nums2[j])
        {
            nums1[k--] = nums1[i--];
        }
        else
            nums1[k--] = nums2[j--];
    }
    
    if(j >= 0)
    {
        while(j >= 0)
            nums1[k--] = nums2[j--];
    }

}
```