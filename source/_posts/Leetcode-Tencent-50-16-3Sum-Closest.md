---
title: Leetcode Tencent 50 16. 3Sum Closest
date: 2019-09-01 13:39:53
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期TaskXX。
---

# 描述

给定一个包括 `n` 个整数的数组` nums` 和 一个目标值` target`。找出 `nums` 中的三个整数，使得它们的和与` target` 最接近。返回这三个数的和。假定每组输入只存在唯一答案。

例如，给定数组` nums = [-1，2，1，-4]`, 和 `target = 1`.

与` target` 最接近的三个数的和为 2. (-1 + 2 + 1 = 2).


来源：力扣（LeetCode）
链接：[16. 3Sum Closest](https://leetcode-cn.com/problems/3sum-closest)

# 解题思路

这里介绍两种解法, 第一种就是暴力解法, 因为是3个数相加, 需要循环三遍, 时间复杂度为$O(N^3)$. 

首先, 将与`target`最接近的三个数的和初始化为`closest  = nums[0] + nums[1] + nums[2]`, 将两者之差记为`diff = abs(target - closest)`.  然后遍历所有可能的`sum = nums[i] + nums[j] + nums[k]`, 如果有`sum`与`target`更加接近, 则基于`sum`更新`diff`和`cloesst`. 具体代码看解法一.

第二种解法主要分成两步, 第一步先进行排序, 然后对排好序的数组运用头尾双指针法. 快排的时间复杂度为$O(NlgN)$, 头尾双指针法的时间复杂度为$O(N^2)$, 总体的时间复杂度为$O(N^2)$. 

同样要定义一个变量` diff` 用来记录差的绝对值，然后开始遍历数组，先是确定一个数，然后用两个指针` left` 和` right` 来滑动寻找另外两个数，将三数之和记为`sum = nums[i] + nums[left] + nums[right]`,如果有`sum`与`target`更加接近, 则基于`sum`更新`diff`和`closest`，如果`sum > target`, 则`right++`, 否则`left++`, 具体代码见解法二. 

# 代码

## 解法一

```c
int threeSumClosest(int* nums, int numsSize, int target)
{
    int i, j, k;
    int closest = nums[0] + nums[1] + nums[2];
    int diff = abs(closest - target);
    for(int i = 0; i < numsSize; i++)
        for(int j = i + 1; j < numsSize; j++)
            for(int k  = j + 1; k < numsSize; k++)
            {
                int sum = nums[i] + nums[j] + nums[k];
                int newDiff = abs(sum - target);
                if(newDiff < diff)
                {
                    diff = newDiff;
                    closest = sum;
                }
               
            }
   
    return closest;
}
``` 

## 解法二

```c

/*
int abs(int x)
{
    if(x > 0) return x;
    else return -x;
}
*/

/* 快速排序 - 直接调用库函数 */
 
#include <stdlib.h>
 
/*---------------简单整数排序--------------------*/
int compare(const void *a, const void *b)
{ /* 比较两整数。非降序排列 */
    return (*(int*)a - *(int*)b);
}
/* 调用接口 */ 
//qsort(A, N, sizeof(int), compare);
/*---------------简单整数排序--------------------*/
 

int threeSumClosest(int* nums, int numsSize, int target)
{
    
    int closest = nums[0] + nums[1] + nums[2];
    int diff = abs(closest - target);
    qsort(nums, numsSize, sizeof(int), compare); //快排
    for (int i = 0; i < numsSize - 2; ++i) 
    {
        int left = i + 1, right = numsSize - 1;  //定义头尾指针
        while (left < right) 
        {
            int sum = nums[i] + nums[left] + nums[right]; //求三数之和
            int newDiff = abs(sum - target);
            if (diff > newDiff) 
            {
                diff = newDiff;
                closest = sum;
            }
            if (sum < target)  //左指针更新
                ++left;
            else 
                --right;       //右指针更新
        }
    }
    return closest;
    
}


``` 
