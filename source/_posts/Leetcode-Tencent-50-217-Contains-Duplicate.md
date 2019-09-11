---
title: Leetcode Tencent 50 Task 29 217. Contains Duplicate
date: 2019-08-31 22:46:13
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task29。
---

# 描述

给定一个整数数组，判断是否存在重复元素。

如果任何值在数组中出现至少两次，函数返回 `true`。如果数组中每个元素都不相同，则返回` false`。

**示例 1:**

```c
输入: [1,2,3,1]
输出: true
```

**示例 2:**

```c
输入: [1,2,3,4]
输出: false
```

**示例 3:**

```c
输入: [1,1,1,3,3,4,3,2,4,2]
输出: true
```

来源：力扣（LeetCode）
链接：[217. Contains Duplicate](https://leetcode-cn.com/problems/contains-duplicate)

# 解题思路

想到了两个解法，第一个解法需要遍历两遍数组，如果找到相等的元素返回`true`,  否则, 返回`false`, 时间复杂度为$O(N^2)$.  
但是这个解法会有超时.

第二个解法是先排序, 然后后面只需要遍历一遍数组就可以了, 比较相邻元素, 如果有重复的返回`true`, 否则, 返回`false`. 

两种解法的代码分别如下:

# 代码

## 解法一

```c

bool containsDuplicate(int* nums, int numsSize){
    for(int i = 0; i < numsSize; i++)
        for(int j = i + 1; j < numsSize; j++)
            if(nums[i] == nums[j])
                return true;
    return false;
}


``` 

## 解法二

```c
    
/* 快速排序 - 直接调用库函数 */
 
#include <stdlib.h>
 
/*---------------简单整数排序--------------------*/
int compare(const void *a, const void *b)
{ /* 比较两整数。非降序排列 */
    return (*(int*)a - *(int*)b);
}
/* 调用接口 */ 
//qsort(A, N, sizeof(int), compare);



bool containsDuplicate(int* nums, int numsSize){
    qsort(nums, numsSize, sizeof(int), compare); //调用快排算法
    for(int i = 0; i < numsSize - 1; i++)
        if(nums[i] == nums[i + 1])
            return true;
    return false;
}


``` 
