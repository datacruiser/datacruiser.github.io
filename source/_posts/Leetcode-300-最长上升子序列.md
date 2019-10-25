---
title: Leetcode-300. 最长上升子序列
date: 2019-10-25 14:39:06
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 二分查找
- 动态规划
description: Leetcode刷题系列.
---

# 描述

给定一个无序的整数数组，找到其中最长上升子序列的长度。

**示例:**

```c
输入: [10,9,2,5,3,7,101,18]
输出: 4 
解释: 最长的上升子序列是 [2,3,7,101]，它的长度是 4。
```

**说明:**


- 可能会有多种最长上升子序列的组合，你只需要输出对应的长度即可。
- 你算法的时间复杂度应该为 $O(n^2)$ 。

进阶: 你能将算法的时间复杂度降低到 $O(n \log n)$ 吗?


来源：力扣（LeetCode）
链接：[300. Longest increasing Subsequence](https://leetcode-cn.com/problems/longest-increasing-subsequence)

# 解题思路

早上在上班通勤的路上正好在看郭炜老师讲动态规划的视频，里面正好也有这道题[最长上升子序列](https://www.icourse163.org/learn/PKU-1001894005#/learn/content?type=detail&id=1211268468&cid=1213844100)

## 找子问题

令输入的数组为$A_n$，我们将原问题转化为求以$A_k(k=1,2,3...N)$为终点的最长上升子序列的长度的问题，其中**终点**为该上升子序列最右边的那个数。

虽然这个子问题和原问题形式上并不完全一致，但是只要这$N$个子问题都解决了，那么这$N$个问题的解当中最大的那个就是整个问题的解。

## 确定状态

子问题只和一个变量--数字的位置相关。因此，序列中数的位置$k$就是**状态**，而状态$k$对应的值，就是以$A_k$作为终点的最长上升子序列的长度。显然，状态一共有$N$个。

## 找出状态转移方程

我们用一个一维数组`dp[k]`来表示$A_k$作为终点的最长上升子序列的长度, 那么状态转移方程如下:
- 初始状态: dp[1] = 1
- 转移方程: dp[k] = max{dp[i]: 1 <= i < k, 且 Ai < Ak 且 k 不等于 1} + 1, 如果找不到这样的i, 则dp[k] = 1

`dp[k]`的值就是在$A_k$左边, 终点数值小于$A_k$，且长度最大的那个上升子序列的长度再加1，因为$A_k$左边任何终点小于$A_k$的子序列，加上$A_k$后就能够形成一个更长的上升子序列。

上面的原理弄清楚了，代码写起来就比较简单了，除了`dp`数组，我们还定义一个返回变量`res`，用这个变量在每次循环的时候保存更新后的`dp`数组当中的最大值。

另外，需要特别注意下：在用`numsSize`作为参量来定义`dp`数组长度时，一定要提前判断一下是否为0，如果为0则直接返回0。

我们来总结下动态规划的设计流程：

- 首先明确`dp`数组所存数组的定义，也就是子问题如何定义，这步很重要，如果不得当或者不够清晰，会严重阻碍之后的步骤，这个在郭老师的视频里面也有涉及，一开始定义的子问题就无法进行状态转移方程的推导
- 然后根据子问题的定义确定状态，即状态与什么变量相关
- 运用数学归纳法的思路，假设`dp[0...i-1]`都已知的情况下，想办法求出`dp[i]`，如果`dp`定义得当，这一步不难，可以找几个例子在纸上画一画先手工推一推。这一步如果完成了，整个题目基本就迎刃而解了
- 如果上一步无法完成，可能是 `dp` 数组的定义不够恰当，需要重新定义 `dp` 数组的含义；或者可能是 `dp` 数组存储的信息还不够，不足以推出下一步的答案，需要把 `dp` 数组扩大成二维数组甚至三维数组
- 最后就是要思考一下初始状态下会如何，以此来对`dp`数组进行初始化，以确保算法能够正确运行

具体代码见解法一。

本题的进阶是将算法的时间复杂度降低到$O(n \log n)$，那就需要进一步优化了，上述算法的算法时间复杂度为$O(N^2)$。

不得不说，对于此题，能想到用二分查找法来进行求解的，不是一般人。

二分法也有不同的解法，下面介绍其中的两种，第一种来自[动态规划设计方法&&纸牌游戏讲解二分解法](https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/dong-tai-gui-hua-she-ji-fang-fa-zhi-pai-you-xi-jia/)，大家自己看吧，就不再贴图和复述了。

如果能够看懂作者的讲解下面代码实现应该非常容易，具体请看解法二。

另外一种也是神仙级的解法，主要思路如下：

- 建立一个数组`ends`，把首元素放进去
- 遍历之后的元素，分以下几种情况
  - 遍历之后的新元素比`ends`数组中的首元素小的话，将`ends`数组的首元素替换为遍历到的新元素
  - 遍历之后的新元素比`ends`数组中的末尾元素还大的话，那么将新元素添加到`ends`数组的末尾，并不覆盖
  - 如果遍历到的新元素比`ends`数组中的首元素大、`ends`数组中的末尾元素小的话，此时用二分查找法，找到第一个不小于此元素的位置并覆盖掉该位置上面原来的数字
- 遍历完整个`nums`数组当中的全部元素以后，此时`ends`数组的长度就是要求的LIS（Longest Increasing Subsequence）的长度，需要特别注意的是，`ends`数组本身的值并不一定是一个真实的LIS，比如若输入数组` nums` 为` {4, 2， 4， 5， 3， 7}`，那么算完后的 `ends` 数组为` {2， 3， 5， 7}`，可以发现它不是一个原数组的 LIS，只是长度相等而已，千万要注意这点

具体代码请看解法三。

还有一种解法与上述思路类似，主要也是考虑到C语言没有STL可用，用`len`变量来保存`ends`数组的长度，在遍历`nums`数组元素的时候，每次都用二分查找在`ends`数组的[0,len]区域内搜索新元素的位置，如果新元素的位置正好位于右边界，则`len++`，最后返回`len`。

真是办法总比困难多，没有想不到，只有做不到，有一句话说得好：所有的程序都是人想出来的！

具体代码见解法四。

# 代码

## 解法一

```c
int max(int a, int b)
{
    if(a > b)
        return a;
    else 
        return b;
}

int lengthOfLIS(int* nums, int numsSize)
{
    //一定要判断
    if(numsSize <= 0)
        return 0;
    
    int dp[numsSize];
    
    //memset(dp, 1, (numsSize) * sizeof(int));

    for(int i = 0; i < numsSize; i++)
        dp[i] = 1;
    
    int res = 0;
    
    for(int i = 0; i < numsSize; i++)
    {
        for(int j = 0; j < i; j++)
        {
            if(nums[i] > nums[j])
            {
                dp[i] = max(dp[i], dp[j] + 1);
            }
        }
        
        res = max(res, dp[i]);
    }
    
    return res;
}
```

## 解法二

```c


int lengthOfLIS(int* nums, int numsSize)
{
    // 判断数组不为空
    if(numsSize <= 0)
        return 0;
    
    int top[numsSize];
    
    // 牌堆数初始化为 0
    int piles = 0;
    
    for(int i = 0; i < numsSize; i++)
    {
        // 要处理的扑克牌
        int poker = nums[i];
        
        /***** 搜索左侧边界的二分查找 *****/
        int left = 0, right = piles;
        
        while(left < right)
        {
            int mid = left + (right - left) / 2;
            
            if(top[mid] > poker)
            {
                right = mid;
            }
            
            else if(top[mid] < poker)
            {
                left = mid + 1;
            }
            
            else 
            {
                right = mid;
            }
        }
        
        /*********************************/
        
        // 没找到合适的牌堆，新建一堆
        if(left == piles)
            piles++;
        
        // 把这张牌放到牌堆顶
        top[left] = poker;
    }
    
    // 牌堆数就是 LIS 长度
    return piles;
   
}
```

## 解法三

```cpp
class Solution {
public:
    int lengthOfLIS(vector<int>& nums) {
        if (nums.empty()) return 0;
        vector<int> ends{nums[0]};
        for (auto a : nums) {
            if (a < ends[0]) ends[0] = a;
            else if (a > ends.back()) ends.push_back(a);
            else {
                int left = 0, right = ends.size();
                while (left < right) {
                    int mid = left + (right - left) / 2;
                    if (ends[mid] < a) left = mid + 1;
                    else right = mid;
                }
                ends[right] = a;
            }
        }
        return ends.size();
    }
};
```

## 解法四

```c
//搜索
int binarySearch(int* p, int left, int right, int target)
{
    
    int mid;
    
    while(left < right)
    {
        mid = left + (right - left) / 2;
        
        if(p[mid] < target)
            left = mid + 1;
        else
            right = mid;
    }
    
    return right;
}

int lengthOfLIS(int* nums, int numsSize) 
{
    if(numsSize == 0)
        
        return 0;
    
    int ends[numsSize];
    
    ends[0] = nums[0];
    
    int len = 1;
    
    for(int i = 1; i < numsSize; i++)
    {
        int pos = binarySearch(ends, 0, len, nums[i]);
        
        ends[pos] = nums[i];
        
        if(pos == len)
        {
            len++;
        }
    }
    
    return len;
}
```



# 参考

- [[LeetCode] 300. Longest Increasing Subsequence 最长递增子序列](https://www.cnblogs.com/grandyang/p/4938187.html)
- [动态规划设计方法&&纸牌游戏讲解二分解法](https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/dong-tai-gui-hua-she-ji-fang-fa-zhi-pai-you-xi-jia/)
- Leetcode他人解法