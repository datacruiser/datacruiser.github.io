---
title: Leetcode Tencent 50 Task7 136. Single Number
date: 2019-08-11 08:00:32
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 位运算
description: DataWhale暑期学习小组-LeetCode刷题第八期Task7。
---
# 描述

给定一个非空整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。

说明：

你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？

**示例 1:**

```c
输入: [2,2,1]
输出: 1
```

**示例 2:**

```c
输入: [4,1,2,1,2]
输出: 4
```

来源：力扣（LeetCode）
链接：[136. Single Number](https://leetcode-cn.com/problems/single-number)


# 解题思路

本题依然是考察位运算，如果没有这个提示，很容易想到用一个`map<key,value>`来求解，其中`key`为数组当中出现过的去重元素，`value`是对应元素出现过的次数，这样遍历一遍数组就可以求得这个`map`，然后找出`value`为1的那一个键值对，返回`key`。这个方法倒是能够在`O(N)`的时间复杂度内求解问题，但是需要开辟额外的空间。为了满足题意，显然还有更优雅的实现。


最近正好在看**《深入理解计算机系统》**，*2.1.7节 C语言中的位级运算*提到任何一位向量$a$，都有$a\bigoplus a=0$。本题当中除了只出现过一次的元素，其它元素都出现两次，那么将数组遍历，然后让他们两两异或，最后剩下的就是那个只出现过一次的元素。


# 代码


```c
int singleNumber(int* nums, int numsSize)
{
    int result = nums[0];
    for(int i = 1; i<numsSize; i++)
    {
        result ^= nums[i];
    }
    
    return result;
}
```
