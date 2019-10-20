---
title: Leetcode-152. 乘积最大子序列
date: 2019-10-20 12:22:22
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 数组
- 动态规划 
description: Leetcode刷题系列.
---
# 描述

给定一个整数数组 `nums` ，找出一个序列中乘积最大的连续子序列（该序列至少包含一个数）。

**示例 1:**

```c
输入: [2,3,-2,4]
输出: 6
解释: 子数组 [2,3] 有最大乘积 6。
```

**示例 2:**

```c
输入: [-2,0,-1]
输出: 0
解释: 结果不能为 2, 因为 [-2,-1] 不是子数组。
```

来源：力扣（LeetCode）
链接：[152. Maximum Product Subarray](https://leetcode-cn.com/problems/maximum-product-subarray)

# 解题思路

这个求最大子数组乘积问题是由[最大子列和](http://datacruiser.io/2019/08/29/Leetcode-Tencent-50-Task18-2-53-Maximum-Subarray/)演变而来, 但是却比求最大子列和要复杂, 因为在求和的时候, 遇到0, 不会改变最大值, 遇到负数, 也只是会减小最大值而已。而在求最大子数组乘积的问题中, 遇到0会使整个乘积为0, 而遇到负数, 则会使最大乘积变成最小乘积, 正因为有负数和0的存在, 使问题变得复杂了不少。比如, 我们现在有一个数组[2, 3, -2, 4], 我们可以很容易的找出所有的连续子数组, [2], [3], [-2], [4], [2, 3], [3, -2], [-2, 4], [2, 3, -2], [3, -2, 4], [2, 3, -2, 4], 然后可以很轻松的算出最大的子数组乘积为6, 来自子数组[2, 3]。

那么我们如何写代码实现自动找出最大子数乘积呢？我最先想到的方法比较简单粗暴，就是找出所有的子数组，然后算出每个子数组的乘积，再从中找出最大的那个。这种算法的时间复杂度是$O(N^2)$，提交以后无法通过。

下面来看看动态规划是怎么解这道题目的。

我们维护而且要用两个dp数组，其中max[i]表示子数组[0, i]范围内并且一定包含`nums[i]`数字的最大子数组乘积，min[i]表示子数组[0, i]范围内并且一定包含`nums[i]`数字的最小子数组乘积，初始化时max[0]和min[0]都初始化为nums[0]，其余都初始化为0。那么从数组的第二个数字开始遍历，那么此时的最大值和最小值只会在这三个数字之间产生，即`max[i-1]*nums[i]，min[i-1]*nums[i]`，和`nums[i]`。所以我们用三者中的最大值来更新max[i]，用最小值来更新min[i]，然后用max[i]来更新结果res即可，由于最终的结果不一定会包括`nums[n-1]`这个数字，所以max[n-1]不一定是最终解，不断更新的结果res才是，具体代码见解法一。

我们可以对上面的解法进行空间上的优化，以下摘自曾经的官方解答，大体思路如下：

Besides keeping track of the largest product, we also need to keep track of the smallest product. Why? The smallest product, which is the largest in the negative sense could become the maximum when being multiplied by a negative number.

Let us denote that:

`f(k) = Largest product subarray, from index 0 up to k.`
 

Similarly,

`g(k) = Smallest product subarray, from index 0 up to k.`
 

Then,
```
f(k) = max( f(k-1) * A[k], A[k], g(k-1) * A[k] )
g(k) = min( g(k-1) * A[k], A[k], f(k-1) * A[k] )
``` 

There we have a dynamic programming formula. Using two arrays of size n, we could deduce the final answer as f(n-1). Since we only need to access its previous elements at each step, two variables are sufficient.

```java
public int maxProduct(int[] A) {
   assert A.length > 0;
   int max = A[0], min = A[0], maxAns = A[0];
   for (int i = 1; i < A.length; i++) {
      int mx = max, mn = min;
      max = Math.max(Math.max(A[i], mx * A[i]), mn * A[i]);
      min = Math.min(Math.min(A[i], mx * A[i]), mn * A[i]);
      maxAns = Math.max(max, maxAns);
   }
   return maxAns;
}
```

根据上述描述，可以写出空间上面优化的代码，具体见解法二。


# 代码

## 解法一

```c
int Max(int a, int b)
{
    if( a > b)
        return a;
    else
        return b;
}

int Min(int a, int b)
{
    if(a > b)
        return b;
    else
        return a;
}

int maxProduct(int* nums, int numsSize)
{
    int res = nums[0], n = numsSize;
    
    int *max = (int *)malloc(sizeof(int) * n);
    int *min = (int *)malloc(sizeof(int) * n);
    
    memset(max, 0, n);
    memset(min, 0, n);
    
    max[0] = nums[0];
    min[0] = nums[0];
    
    for(int i = 1; i < n; i++)
    {
        max[i] = Max(Max(max[i - 1] * nums[i], min[i - 1] * nums[i]), nums[i]);
        min[i] = Min(Min(max[i - 1] * nums[i], min[i - 1] * nums[i]), nums[i]);
        
        res = Max(res, max[i]);
    }
    
    free(min);
    free(max);
    
    return res;
    
}
```

## 解法二

```c
int Max(int a, int b)
{
    if( a > b)
        return a;
    else
        return b;
}

int Min(int a, int b)
{
    if(a > b)
        return b;
    else
        return a;
}

int maxProduct(int* nums, int numsSize)
{
    int res = nums[0], n = numsSize;
    
    
    int max = nums[0];
    int min = nums[0];
    
    for(int i = 1; i < n; i++)
    {
        int max_tmp = max, min_tmp = min;
        
        max = Max(Max(max_tmp * nums[i], min_tmp * nums[i]), nums[i]);
        min = Min(Min(max_tmp * nums[i], min_tmp * nums[i]), nums[i]);
        
        res = Max(res, max);
    }
    
    return res;
    
}
```

# 参考

- [[LeetCode] Maximum Product Subarray 求最大子数组乘积](https://www.cnblogs.com/grandyang/p/4028713.html)

