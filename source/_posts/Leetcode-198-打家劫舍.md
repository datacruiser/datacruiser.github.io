---
title: Leetcode-198. 打家劫舍
date: 2019-10-18 11:53:51
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 位运算
description: Leetcode刷题系列.
---
# 描述

你是一个专业的小偷，计划偷窃沿街的房屋。每间房内都藏有一定的现金，影响你偷窃的唯一制约因素就是相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警。

给定一个代表每个房屋存放金额的非负整数数组，计算你在不触动警报装置的情况下，能够偷窃到的最高金额。

**示例 1:**

```c
输入: [1,2,3,1]
输出: 4
解释: 偷窃 1 号房屋 (金额 = 1) ，然后偷窃 3 号房屋 (金额 = 3)。
     偷窃到的最高金额 = 1 + 3 = 4 。
```

**示例 2:**

```c
输入: [2,7,9,3,1]
输出: 12
解释: 偷窃 1 号房屋 (金额 = 2), 偷窃 3 号房屋 (金额 = 9)，接着偷窃 5 号房屋 (金额 = 1)。
     偷窃到的最高金额 = 2 + 9 + 1 = 12 。
```

来源：力扣（LeetCode）
链接：[198. house robber](https://leetcode-cn.com/problems/house-robber)

# 解题思路

一开始把本题想得太简单了，只是将只抢奇数和只抢偶数进行求和，然后进行比较，取大的数，代码如下：

```c
int rob(int* nums, int numsSize){
    
    int max1 = 0, max2 = 0;
    
    for(int i = 0; i < numsSize; i += 2)
        max1 += nums[i];
    
    for(int i = 1; i < numsSize; i += 2)
        max2 += nums[i];
    
    if(max1 > max2)
        return max1;
    else 
        return max2;
}
```

提交以后解答错误，提示如下：

```c
39 / 69 个通过测试用例                    状态：解答错误
                                  提交时间：22 分钟之前
输入： 
[2,1,1,2]
输出：
3
预期：
4
```

显然，把这道题想得太过于简单了，为了不触发警报，除了隔一间房子以外，还可以隔两间房子、甚至三间。因此，本题的的本质相当于在一列数组当中取出一个或者多个不相邻的数，使其和最大。

对于这类求极值的问题 首先考虑动态规划（Dynamic Progrmming）的方法来求解，动态规划的核心就是找到状态转移方程。

从最简单的情况开始考虑，记：$f(k)=$从前$k$个房间中能够抢劫到的最大数额，$A_i=$第 $i$ 个房屋的钱数，则有：
- `n=1`时，有$f(1)=A_1$
- `n=2`时，有$f(2)=max(A_1, A_2)$
- `n=3`时, 有两个选项:
  - 抢第三个房子, 将数额与第一个房子相加, 此时$f(3)=(f(1)+A_3)=(f(3-1)+A_3)$
  - 不抢第三个房子, 保持现有最大数额, 此时$f(3)=f(2)=f(3-1)$
  - 当然, 根据题意, 会选择上面两种情况当中的最大值. 于是可以总结出状态转移方程如下:
  - $f(k)=max(f(k-2)+A_k, f(k-1))$

我们选择$f(-1)=f(0)=0$, 最终返回$f(n)$. 由于每一步只需要前两个最大值, 因此只需要两个变量就够了, 具体代码见解法一:

还有一种解法, 核心思想还是用动态规划, 分别维护两个变量`robEven`和`robOdd`, 顾名思意, `robEven`就是要抢偶数位置的房子, `robOdd`就是要抢奇数位置得房子. 然后在遍历数组时, 如果是偶数位置, 那么`robEven`就要加上当前数字, 然后和`robOdd`进行比较, 取较大得值来更新`robEven`. 实际上, `robEven`组成的值并不是只由偶数位置的数字, 只是和当前要抢得房子的奇偶有关. 同理, 当奇数位置时, `robOdd`加上当前数字和`robEven`比较, 取较大值来更新`robOdd`. 这种按照奇偶区分来更新得方法, 可以保证组成最大和得数字不相邻. 然后最后再返回`robEven`和`robOdd`当中的较大的值. 

具体代码见解法二. 

# 代码

## 解法一

```c
#define max(a, b) ((a)>(b)?(a):(b))


int rob(int* nums, int numsSize)
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

```

## 解法二

```c
#define max(a, b) ((a)>(b)?(a):(b))

int rob(int* nums, int numsSize) 
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
```



# 参考

- [打家劫舍 官方题解](https://leetcode-cn.com/problems/house-robber/solution/da-jia-jie-she-by-leetcode/)
- [[LeetCode] 198. House Robber 打家劫舍](https://www.cnblogs.com/grandyang/p/4383632.html)