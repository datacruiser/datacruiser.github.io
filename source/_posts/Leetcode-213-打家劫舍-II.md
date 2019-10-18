---
title: Leetcode-213. 打家劫舍 II
date: 2019-10-18 16:20:55
categories:
- [LeetCode]
tags:
- 数据结构
- 算法
- C语言
- 数组
- 动态规划 
description: Leetcode刷题系列.
---
# 描述

你是一个专业的小偷，计划偷窃沿街的房屋，每间房内都藏有一定的现金。这个地方所有的房屋都围成一圈，这意味着第一个房屋和最后一个房屋是紧挨着的。同时，相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警。

给定一个代表每个房屋存放金额的非负整数数组，计算你在不触动警报装置的情况下，能够偷窃到的最高金额。

**示例 1:**

```c
输入: [2,3,2]
输出: 3
解释: 你不能先偷窃 1 号房屋（金额 = 2），然后偷窃 3 号房屋（金额 = 2）, 因为他们是相邻的。
```

**示例 2:**

```c
输入: [1,2,3,1]
输出: 4
解释: 你可以先偷窃 1 号房屋（金额 = 1），然后偷窃 3 号房屋（金额 = 3）。
     偷窃到的最高金额 = 1 + 3 = 4 。
```

来源：力扣（LeetCode）
链接：[213. House Robber II](https://leetcode-cn.com/problems/house-robber-ii)

# 解题思路

这道题是[Leetcode-198. 打家劫舍](http://datacruiser.io/2019/10/18/Leetcode-198-%E6%89%93%E5%AE%B6%E5%8A%AB%E8%88%8D/)的延伸, 主要的区别就是头尾两间房子连到了一起, 给解题增加了一定的难度. 不过这个难度非常有限. 

既然头尾两间房子连到了一起, 那么就是意味着不能够同时抢劫$A_1$和 $A_n$两间房子, 问题可以等价于从[1, n-1]或者[2, n]的房子序列当中哪个序列能够抢到最多的钱. 这相当于两个已经解决的[Leetcode-198. 打家劫舍](http://datacruiser.io/2019/10/18/Leetcode-198-%E6%89%93%E5%AE%B6%E5%8A%AB%E8%88%8D/)的小问题, 分别求出在上述两个序列当中能够抢到的钱的最大值, 然后取其中的较大者. 另外, 还要考虑下特殊情况, 当只有一间房子的时候直接返回数组元素.

具体代码如下: 

# 代码

## 解法一

```c
#define max(a, b) ((a)>(b)?(a):(b))


int robhelp(int* nums, int numsSize)
{
    
    int max1 = 0, max2 = 0;

    for(int i = 0; i < numsSize; i++)
    {
        int tmp = max2;
        max2 = max(max1 + nums[i], max2);
        max1 = tmp;
    }
    
    return max2;

}

int rob(int* nums, int numsSize)
{
    if(numsSize == 1) return nums[0];
    
    int max1 = robhelp(nums, numsSize - 1);
    int max2 = robhelp(nums+1, numsSize - 1);
    
    return max(max1, max2);
}

```

## 解法二

```c
#define max(a, b) ((a)>(b)?(a):(b))

int robhelp(int* nums, int numsSize) 
{
    int robEven = 0;
    int robOdd = 0;
    
    for (int i = 0; i< numsSize; i++)
    {
        if (i % 2 == 0)
        {
            robEven = max(robEven + nums[i], robOdd);
        }
        else
        {
            robOdd = max(robEven, robOdd + nums[i]);
        }
    }
    
    return max(robOdd, robEven);
}


int rob(int* nums, int numsSize)
{
    if(numsSize == 1) return nums[0];
    
    int max1 = robhelp(nums, numsSize - 1);
    int max2 = robhelp(nums+1, numsSize - 1);
    
    return max(max1, max2);
}
```



# 参考

- [打家劫舍 官方题解](https://leetcode-cn.com/problems/house-robber/solution/da-jia-jie-she-by-leetcode/)
- [[LeetCode] 198. House Robber 打家劫舍](https://www.cnblogs.com/grandyang/p/4383632.html)