---
title: LeetCode Tencent 50 238. Product of Array Except Self
date: 2019-08-31 11:55:58
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期TaskXX。
---

# 描述

给定长度为 `n` 的整数数组 `nums`，其中` n > 1`，返回输出数组 `output` ，其中` output[i] `等于` nums` 中除` nums[i] `之外其余各元素的乘积。

**示例:**

```c
输入: [1,2,3,4]
输出: [24,12,8,6]
说明: 请不要使用除法，且在 O(n) 时间复杂度内完成此题。
```

进阶：
你可以在常数空间复杂度内完成这个题目吗？（ 出于对空间复杂度分析的目的，输出数组不被视为额外空间。）

来源：力扣（LeetCode）
链接：[238. Product of Array Except Self](https://leetcode-cn.com/problems/product-of-array-except-self)


# 解题思路

首先, 这道题要求不能用除法, 如果用除法就是一道简单题了, 只要遍历一遍求出数组所有元素总的积, 然后再遍历一遍就将总的积除以各个元素就可以求出除自己以外所有元素的积了. 那么不能用除法的话这道题需要怎么做呢? 

对于数组当中某一个元素, 如果我们知道其前面所有元素的乘积, 同时也知道其后面所有的数乘积, 那么二者相乘就是题目所要求的结果.

所以我们只要分别创建出这两个数组即可, 然后分别从原数组的两个方向遍历就可以分别创建出这样左右两个乘积累积数组, 最后再遍历一遍, 将这两个数组元素对于位置的乘积相乘就是最终的结果. 这个颇有一点双指针的味道, 具体代码看解法一. 

下面看看在空间上面是否还可以继续优化.

由于最终的结果都是要乘到结果 `result` 中, 所以可以不用单独的数组来保存乘积, 而是直接累积到结果 `result`中, 我们先从前面遍历一遍, 将乘积的累积存入结果`result`中, 然后从后面开始遍历, 用到一个临时变量 `right`, 初始化为1, 然后每次不断累积, 最终得到正确结果. 具体代码看解法二. 


# 代码

## 解法一：双数组解法

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */

//将数组初始化
void initArray(int* arr, int size, int element)
{
    for(int i = 0; i < size; i++)
        arr[i]  = element;
}


int* productExceptSelf(int* nums, int numsSize, int* returnSize){

    int leftProduct[numsSize], rightProduct[numsSize];
    initArray(leftProduct, numsSize, 1);  //初始化左边乘积为 1
    initArray(rightProduct, numsSize, 1); //初始化右边乘积为 1
    
    int* result= malloc(numsSize * sizeof(int));
    *returnSize = numsSize;
    
    for (int i = 0; i < numsSize - 1; ++i) 
    {
        leftProduct[i + 1] = leftProduct[i] * nums[i];
    }
    for (int i = numsSize - 1; i > 0; --i) 
    {
        rightProduct[i - 1] = rightProduct[i] * nums[i];
    }
        
    for (int i = 0; i < numsSize; ++i) 
    {
        result[i] = leftProduct[i] * rightProduct[i]; //左右成绩相乘
    }
    return result;
    
}


``` 

## 解法二：单数组法

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */

//将数组初始化
void initArray(int* arr, int size, int element)
{
    for(int i = 0; i < size; i++)
        arr[i]  = element;
}

int* productExceptSelf(int* nums, int numsSize, int* returnSize){

    int* result = malloc(numsSize * sizeof(int));
    *returnSize = numsSize;
    
    initArray(result, numsSize, 1); //将数组初始化为1
        
    for (int i = 1; i < numsSize; ++i) 
    {
        result[i] = result[i - 1] * nums[i - 1];
    }
    int right = 1;
        
    for (int i = numsSize - 1; i >= 0; --i) 
    {    
        result[i] *= right;
        right *= nums[i];
    }
    return result;
}


``` 

