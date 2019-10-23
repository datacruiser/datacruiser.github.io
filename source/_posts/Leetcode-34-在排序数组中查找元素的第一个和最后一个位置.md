---
title: Leetcode-34. 在排序数组中查找元素的第一个和最后一个位置
date: 2019-10-22 23:27:24
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 数组
- 二分查找
description: Leetcode刷题系列.
---

# 描述

给定一个按照升序排列的整数数组 `nums`，和一个目标值 `target`。找出给定目标值在数组中的开始位置和结束位置。

你的算法时间复杂度必须是 `O(log n)` 级别。

如果数组中不存在目标值，返回 [-1, -1]。

**示例 1:**

```c
输入: nums = [5,7,7,8,8,10], target = 8
输出: [3,4]
```

**示例 2:**

```c
输入: nums = [5,7,7,8,8,10], target = 6
输出: [-1,-1]
```


来源：力扣（LeetCode）
链接：[34. Find First and Last Position of Element in Sorted Array](https://leetcode-cn.com/problems/find-first-and-last-position-of-element-in-sorted-array)

# 解题思路

这道题已经有提示使用二分查找，一开始我的思路是这样的，首先用二分查找找到一个下标`index`，如果`nums[index] == target`则设置两个变量`start`和`end`，并且都初始化为`index`，然后两次循环，一个向左，一个向右，找到不等于`target`的元素，同时`start--, end++`更新左右下标。写了一段下面的代码，简直又丑又长，关键还没法通过所有的测试案例。后来对比了高手们的代码发现关键在于未对`index`是否已经位于边界的情况进行判断。

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* searchRange(int* nums, int numsSize, int target, int* returnSize)
{
    
    *returnSize = 2;
    
    int* ret = (int *)malloc(sizeof(int) * 2);
    memset(ret, -1, 2 * sizeof(int));
    
    
    if(numsSize == 0) return ret;
    
    if(numsSize == 1)
    {
        if(nums[0] != target)
        {
            return ret;
        }
        else
        {
            ret[0] = ret[1] = 0;
            return ret;
        }
    }
    
    
     if(numsSize == 2)
    {
        if(nums[0] == target && nums[1] != target)
        {
            ret[0] = 0;
            ret[1] = 0;
            return ret;
        }
        else if(nums[0] == target && nums[1] == target)
        {
            ret[0] = 0;
            ret[1] = 1;
            return ret;
        }
        else if(nums[0] != target && nums[1] == target)
        {
            ret[0] = 1;
            ret[1] = 1;
            return ret;
        }
        else
        {
            return ret;
        }             
    }
    
    
    int start = 0, end = numsSize - 1;
    int index = -1;
    
    while(start < end)
    {
        int mid = start + (end - start) / 2;

        if(nums[mid] < target)
        {
            start = mid + 1;
        }
        
        else
        {
            end = mid;
        }
        
    }
    
    if(nums[start] == target)
        index = start;
    
    if(index == -1)
        return ret;
    
    else
    {
        //if()
        
        start = index;
        end = index;
        
        while(nums[start] == target && start > 0)
        {
            start--;
        }
        
        while(nums[end] == target && end < numsSize - 1)
        {
            end++;
        }
        

    }    
    
    ret[0] = start + 1;
    ret[1] = end - 1;
    
    
    return ret;
            
}
```

下面再来看看大神们的解法。

采用两次二分查找，第一次找到左边界，第二次找到右边界。具体代码如下：



# 代码

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* searchRange(int* nums, int numsSize, int target, int* returnSize)
{
    
    *returnSize = 2;
    
    int* ret = (int *)malloc(sizeof(int) * 2);
    memset(ret, -1, 2 * sizeof(int));
    
    int left = 0, right = numsSize;
    
    //寻找左边界
    while(left < right)
    {
        int mid = left + (right - left) / 2;
        //注意这里的条件 是< 不是<=
        if(nums[mid] < target) left = mid + 1;
        else
            right = mid;
    }
    
    //未找到相等的元素
    if(right == numsSize || nums[right] != target)
        return ret;
    
    //找到并记录左边界
    ret[0] = right;
    
    //寻找有边界
    left = 0;
    right = numsSize;
    
    while(left < right)
    {
        int mid = left + (right - left) / 2;
        //注意这里的条件 是<= 不是<
        if(nums[mid] <= target) left = mid + 1;
        else
            right = mid;
    }
    
    //有边界需要减1
    ret[1] = right - 1;
    
    return ret;
            
}
```

# 参考

- [[LeetCode] 34. Find First and Last Position of Element in Sorted Array 在有序数组中查找元素的第一个和最后一个位置](https://www.cnblogs.com/grandyang/p/4409379.html)
- [LeetCode Binary Search Summary 二分搜索法小结](https://www.cnblogs.com/grandyang/p/6854825.html)