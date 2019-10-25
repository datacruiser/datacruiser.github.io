---
title: Leetcode-322. 零钱兑换
date: 2019-10-24 20:15:14
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 动态规划
description: Leetcode刷题系列.
---

# 描述

给定不同面额的硬币 coins 和一个总金额 amount。编写一个函数来计算可以凑成总金额所需的最少的硬币个数。如果没有任何一种硬币组合能组成总金额，返回 -1。

**示例 1:**

```c
输入: coins = [1, 2, 5], amount = 11
输出: 3 
解释: 11 = 5 + 5 + 1
```

**示例 2:**

```c
输入: coins = [2], amount = 3
输出: -1
```

**说明:**
你可以认为每种硬币的数量是无限的。

来源：力扣（LeetCode）
链接：[322. Coin Change](https://leetcode-cn.com/problems/coin-change)

# 解题思路

关于这道题, 这个[题解](https://leetcode-cn.com/problems/coin-change/solution/dong-tai-gui-hua-tao-lu-xiang-jie-by-wei-lai-bu-ke/)给出了非常详细的描述, 从动态规划的基本思路开始, 一步步怎么从暴力方法到到备忘录的递归再到迭代的动态规划, 深入浅出, 图文并茂, 是不可多得的题解. 

首先来看暴力解法, 最困难得一步, 就是写出状态转移方程, 这个问题的状态转移方程如下:

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/332-%E7%8A%B6%E6%80%81%E8%BD%AC%E7%A7%BB%E6%96%B9%E7%A8%8B.png)

附图来自[题解](https://leetcode-cn.com/problems/coin-change/solution/dong-tai-gui-hua-tao-lu-xiang-jie-by-wei-lai-bu-ke/)，原作者公众号`labuladong`，欢迎大家关注。

其实，这个方程就用到了「最优子结构」性质：**原问题的解由子问题的最优解构成**。即 f(11) 由 f(10), f(9), f(6) 的最优解转移而来。

具体代码见解法一。

画出递归树：

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/322-%E9%80%92%E5%BD%92%E6%A0%91.png)

时间复杂度分析：递归的总时间是子问题总数 x 每个子问题的时间。子问题总数为递归树节点个数，这个比较难看出来，是$O(N^k)$，总之是指数级别。每个子问题当中还有一个 for 循环，复杂度为$O(k)$，所以最终依然还是指数级别。

下面给递归的解法加一个记忆数组，将中间的计算结果进行保存，把一棵存在巨量冗余的递归树通过「剪枝」，改造成了一幅不存在冗余的递归图，极大减少了子问题（即递归图中节点）的个数。这个思路跟[Leetcode-139. 单词拆分](http://datacruiser.io/2019/10/23/Leetcode-139-%E5%8D%95%E8%AF%8D%E6%8B%86%E5%88%86/)的解法是类似的。

如果要加入记忆数组，通常的做法是在主调用函数当中什么记忆数组并进行初始化，然后在递归函数当中加入一个记忆数组的变量，因为最后记忆数组是要返回的，需要以指针或者引用的方式进行传参。

具体代码见解法二。

最后再来看看动态规划的解法。

我们维护一个一维动态数组` dp`，其中` dp[i]` 表示钱数为`i`时的最小硬币数的找零，注意由于数组是从0开始的，所以要多申请一位，数组大小为 `amount + 1`，这样最终结果就可以保存在 `dp[amount] `中。

初始化 `dp[0] = 0`，因为目标值若为0时，就不需要任何硬币。其他值可以初始化是 `amount + 1`，因为最小的硬币是1，所以 `amount` 最多需要 `amount` 个硬币，`amount + 1 ` 也就相当于当前的最大值了，注意这里不能用整型最大值来初始化，因为在后面的状态转移方程有加1的操作，有可能会溢出.

好，接下来就是要找状态转移方程了。我们先回归例子1，假设我取了一个值为5的硬币，那么由于目标值是 11，所以是不是假如我们知道 `dp[6]`，那么就知道了组成 11 的` dp `值了？所以更新 `dp[i]` 的方法就是遍历每个硬币，如果遍历到的硬币值小于`i`值（比如不能用值为5的硬币去更新 `dp[3]`）时，用 `dp[i - coins[j]] + 1` 来更新 `dp[i]`，所以状态转移方程为：

$$dp[i] = min(dp[i], dp[i - coins[j]] + 1)$$

其中 `coins[j]` 为第`j`个硬币，而 `i - coins[j]` 为钱数`i`减去其中一个硬币的值，剩余的钱数在 `dp `数组中找到值，然后加1和当前 `dp` 数组中的值做比较，取较小的那个更新 `dp `数组。

具体代码见解法三。

# 代码

## 解法一

```c
int min (int a, int b)
{
    if(a > b)
        return b;
    else 
        return a;
}

int coinChange(int* coins, int coinsSize, int amount)
{
    //金额为0 返回0
    if(amount == 0)
        return 0;
    
    int ans = INT_MAX;
    
    
    for (int i = 0; i < coinsSize; i++)
    {
        //金额比当前硬币面额小，换一个硬币
        if (amount - coins[i] < 0)
            continue;
        
        //递归调用，去掉当前可用硬币，因为硬皮可重复使用 *coins变量不变
        int tmp = coinChange(coins, coinsSize, amount - coins[i]);
        
        //如果子问题无解，换一个硬币
        if (tmp == -1)
            continue;
        
        //利用状态转移方程更新
        ans = min(ans, tmp + 1);
    }
    
    return ans == INT_MAX ? -1 : ans;

}
```


## 解法二

```c
int min (int a, int b)
{
    if(a > b)
        return b;
    else 
        return a;
}

int coinChangeSolver(int* coins, int coinsSize, int target, int *memo)
{
    if(target < 0)
        return -1;
    
    if(memo[target] != INT_MAX)
        return memo[target];
    
    for (int i = 0; i < coinsSize; i++)
    {
        //计算子问题的解
        int tmp = coinChangeSolver(coins, coinsSize, target - coins[i], memo);
        
        //如果子问题有解，更新答案
        if (tmp >= 0)
            memo[target] = min(memo[target], tmp + 1);
    }
    
    //记录并返回本轮答案
    return memo[target] = (memo[target] == INT_MAX) ? -1 : memo[target];
    
}

int coinChange(int* coins, int coinsSize, int amount)
{
    //记忆数组初始化为INT_MAX
    int memo[amount + 1];
    memo[0] = 0;

    for (int i = 1; i <= amount; i++)
        memo[i] = INT_MAX;
    
    
    return coinChangeSolver(coins, coinsSize, amount, memo);
    
}
```

## 解法三

```c
int min (int a, int b)
{
    if(a > b)
        return b;
    else 
        return a;
}



int coinChange(int* coins, int coinsSize, int amount)
{
    
    //dp数组初始化
    int dp[amount + 1];
    dp[0] = 0;

    for (int i = 1; i <= amount; i++)
        dp[i] = amount + 1;
    
    for(int i = 1; i <= amount; i++)
    {
        for(int j = 0; j < coinsSize; j++)
        {
            if(coins[j] <= i)
            {
                dp[i] = min(dp[i], dp[i - coins[j]] + 1);
            }
        }
    }
    
    return (dp[amount] > amount) ? -1 : dp[amount];
    
}
```

# 参考

- [[LeetCode] 322. Coin Change 硬币找零](https://www.cnblogs.com/grandyang/p/5138186.html)
- [动态规划套路详解](https://leetcode-cn.com/problems/coin-change/solution/dong-tai-gui-hua-tao-lu-xiang-jie-by-wei-lai-bu-ke/)
