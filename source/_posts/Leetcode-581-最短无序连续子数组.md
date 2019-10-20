---
title: Leetcode-581. 最短无序连续子数组
date: 2019-10-20 07:14:57
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 数组 
- 排序
description: Leetcode刷题系列.
---
# 描述

给定一个整数数组，你需要寻找一个连续的子数组，如果对这个子数组进行升序排序，那么整个数组都会变为升序排序。

你找到的子数组应是最短的，请输出它的长度。

**示例 1:**

```c
输入: [2, 6, 4, 8, 10, 9, 15]
输出: 5
解释: 你只需要对 [6, 4, 8, 10, 9] 进行升序排序，那么整个表都会变为升序排序。
```

**说明 :**

- 输入的数组长度范围在 [1, 10,000]。
- 输入的数组可能包含重复元素 ，所以升序的意思是<=。

来源：力扣（LeetCode）
链接：[581. Shortest Unsorted Continuous Subarray](https://leetcode-cn.com/problems/shortest-unsorted-continuous-subarray)


# 解题思路

本题的解题思路是先对原数组进行排序，然后逐个比较原数组和排序后的数组，记录数据不一致时的前后索引相减就是最短无序子数组的长度了。

这个思路的时间复杂度为排序的时间复杂度，如果采用快排，则为$O(N\log N)$，另外空间方面还需要$O(N)$用来存储排序后的数组。

具体代码如下：


# 代码

```c
int cmpfunc (const void * a, const void * b)
{
   return ( *(int*)a - *(int*)b );
}

int min(int a, int b)
{
    if(a > b)
        return b;
    else 
        return a;
}

int max(int a, int b)
{
    if(a > b)
        return a;
    else 
        return b;
}

int findUnsortedSubarray(int* nums, int numsSize)
{
    int *numscp = (int *)malloc(numsSize * sizeof(int));
    
    for(int i = 0; i < numsSize; i++)
    {
        numscp[i] = nums[i];
    }
    
    qsort(nums, numsSize, sizeof(int), cmpfunc);
    
    int start = numsSize, end = 0;
    
    for(int i = 0; i < numsSize; i++)
    {
        if(nums[i] != numscp[i])
        {
            start = min(start, i);
            end = max(end, i);
        }
    }
    
    //释放空间
    free(numscp);
    
    return  end - start < 0 ? 0 : end - start + 1;

}
```