---
title: Leetcode Tencent 50 Task19 53. Maximum Subarray
date: 2019-08-29 21:35:28
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task19。
---

# 描述

给定一个整数数组 `nums` ，找到一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。

**示例:**

```c

输入: [-2,1,-3,4,-1,2,1,-5,4],
输出: 6
解释: 连续子数组 [4,-1,2,1] 的和最大，为 6。

```

进阶:

如果你已经实现复杂度为 `O(n)` 的解法，尝试使用更为精妙的分治法求解。

来源：力扣（LeetCode）
链接：[53. Maximum Subarray](https://leetcode-cn.com/problems/maximum-subarray)




# 解题思路

这道题在陈越姥姥的《数据结构》MOOC课上面有过举例说明，可以有若干种解法。

本文主要采用动态规划的方法，主要步骤如下：

- 首先处理边界条件：
    - 数组元素个数为0的时候，直接返回0
    - 数组元素个数为1的时候，直接返回数组元素
- 遍历数组，当前最大连续子序列和为 `sum`，结果为 `max`
- 如果 `sum > 0`，则 `sum` 对结果有增益效果，则 `sum` 更新为加上当前遍历数字
- 如果 `sum <= 0`，则 `sum` 对结果无增益效果，需要舍弃，则 `sum` 直接更新为当前遍历数字
- 每次比较 `sum` 和 `max`的大小，将最大值置为 `max`，遍历结束返回结果



具体代码如下：


# 代码


```c

int maxSubArray(int* nums, int numsSize){
     if(numsSize == 0) return 0;
    if(numsSize == 1) return nums[0];
    int max = nums[0];
    int sum = -1000;

    for (int i = 0; i < numsSize; i++)
    {
        if(sum < 0) 
                sum = 0;
        sum += nums[i];
        if(sum > max) 
            max = sum;
           
    }

    return max;

}

``` 

