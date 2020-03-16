---
title: Leetcode Tencent 50 70. Climbing Stairs
date: 2019-09-08 22:47:47
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数学
description: DataWhale暑期学习小组-LeetCode刷题第八期Taskxx。
---

# 描述

假设你正在爬楼梯。需要 `n` 阶你才能到达楼顶。

每次你可以爬 `1` 或` 2 `个台阶。你有多少种不同的方法可以爬到楼顶呢？

注意：给定` n `是一个正整数。

**示例 1：**

```c
输入： 2
输出： 2
解释： 有两种方法可以爬到楼顶。
1.  1 阶 + 1 阶
2.  2 阶
```

**示例 2：**

```c
输入： 3
输出： 3
解释： 有三种方法可以爬到楼顶。
1.  1 阶 + 1 阶 + 1 阶
2.  1 阶 + 2 阶
3.  2 阶 + 1 阶
```

来源：力扣（LeetCode）
链接：[70. Climbing Stairs](https://leetcode-cn.com/problems/climbing-stairs)


# 解题思路

首先在稿纸上面罗列了一下，`n`从`1`取到`5`时各有多少种不同的方法：

- `n`为`1`时有`1`一种方法
- `n`为`2`时有`2`一种方法
- `n`为`3`时有`3`一种方法
- `n`为`4`时有`5`一种方法
- `n`为`5`时有`8`一种方法

可以发现有这样的规律，`f(5)=f(4)+f(3)`，`f(4)=f(3)+f(2)`，`f(3)=f(2)+f(1)`……其实如果把`n`变大，根据题意，可以走`1`或者`2`步，那么走到第`n`阶台阶可以分别从`n-1`阶走`1`步上来，也可以从`n-2`阶走`2`步上来。则有第`n`阶的可行走法的状态转移方程：
$$climbStairs(n)=climbStairs(n-1)+climbStairs(n-2)$$

于是最初想到使用递归的解法，代码如下：

```c
int climbStairs(int n)
{
    
    if(n == 1) return 1;
    else if(n == 2) return 2;
    else
        return climbStairs(n -  1) + climbStairs(n - 2);

}
```

提交上去以后超时，那么就需要把中间过程保存下来了，可以定义一个数组来保存每一种台阶的总的可行方法。具体代码如下：


# 代码

```c
int climbStairs(int n)
{
    if(n == 1) return 1;
    else if(n == 2) return 2;
    
    else
    {
        int dp[n + 1];
        dp[1] = 1;
        dp[2] = 2;
        for(int i = 3; i < n + 1; i++)
        {
            dp[i]  = dp[i - 1] + dp[i - 2];
        }
    return dp[n];
    }
    
    
    
    //if(n == 1) return 1;
    //else if(n == 2) return 2;
    //else
    //    return climbStairs(n -  1) + climbStairs(n - 2);

}
```