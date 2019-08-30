---
title: Leetcode Tencent 50 121. Best Time to Buy and Sell Stock
date: 2019-08-30 19:49:21
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task1X。
---

# 描述

给定一个数组，它的第 `i` 个元素是一支给定股票第 `i` 天的价格。

如果你最多只允许完成一笔交易（即买入和卖出一支股票），设计一个算法来计算你所能获取的最大利润。

注意你不能在买入股票前卖出股票。

**示例 1:**

```c
输入: [7,1,5,3,6,4]
输出: 5
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
     注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格。
```

**示例 2:**

```c

输入: [7,6,4,3,1]
输出: 0
解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
```

来源：力扣（LeetCode）
链接：[121. Best Time to Buy and Sell Stock](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock)


# 解题思路

两种解法, 首先一种是暴力解法, 需要两重循环, 第一重遍历从第`1`个到第`pricesSize-1`个元素, 第二重遍历从第`2`个到第`pricesSize`个元素, 分别用`i`和`j`来表示, 然后找出`prices[j]-prices[i]`的最大值. 这样算法时间复杂度是$O(n^2)$, 超时. 

第二种解法是双指针法, 第一个指针寻找整个数组当中的最小值, 指针位置记为`lowIndex`, 第二个指针寻找在`lowIndex`位置以后的数组元素的最大值. 这样只需要遍历一遍就能够求解问题.


# 代码

# 暴力解法

```c
int maxProfit(int* prices, int pricesSize){
    int maxprofit = 0;
    int profit = 0;
    for (int i = 0; i < pricesSize - 1; i++) 
    {
        for (int j = i + 1; j < pricesSize; j++) 
        {
            profit = prices[j] - prices[i];
            if (profit > maxprofit)
                maxprofit = profit;
        }
    }
    return maxprofit;


}

```

## 双指针

```c

int max(int a, int b)
{
    if(a > b) return a;
    else return b;
}

int maxProfit(int* prices, int pricesSize)
{
    int maxProfit = 0;
    int lowPrice = INT_MAX;
    for(int i = 0; i < pricesSize; i++)
    {
        if(prices[i] < lowPrice)
        {
            lowPrice = prices[i];
        }
        else if(prices[i] - lowPrice > maxProfit)
        {
            maxProfit = max(maxProfit, prices[i] - lowPrice);
        }
    }

    return maxProfit;
}

``` 
