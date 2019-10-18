---
title: Leetcode-64. 最小路径和
date: 2019-10-18 17:33:09
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

给定一个包含非负整数的 m x n 网格，请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。

说明：每次只能向下或者向右移动一步。

**示例:**

```c
输入:
[
  [1,3,1],
  [1,5,1],
  [4,2,1]
]
输出: 7
解释: 因为路径 1→3→1→1→1 的总和最小。
```

来源：力扣（LeetCode）
链接：[64. Minimus Path Sum](https://leetcode-cn.com/problems/minimum-path-sum)

# 解题思路

此题也需要采用动态规划来进行求解. 比较常见的错误解法是每次走右边或者下边数字中较小得那个, 这样的贪婪算法所获得得局部最优解并不一定是全局最优解. 

既然是动态规划, 还是要抓牢两点, 一个是边界条件, 或者叫初始状态, 另外一个核心就是状态转移方程. 

我们维护一个二维的 dp 数组, 其中 dp[i][j] 表示到达当前位置的最小路径和. 接下来找状态转移方程. 因为到达当前位置 (i, j)  只有两种情况, 要么从上方 (i-1, j) 过来, 要么从左边 (i, j-1) 过来, 我们选择 dp 值较小的那个路径，即比较 dp[i-1][j] 和 dp[i][j-1], 将其中的较小值加上当前的数字 grid[i][j], 就是当前位置的 dp 值了. 得到状态转移方程如下:
$$dp[i][j] = grid[i][j]+min(dp[i-1][j], dp[i][j-1])$$

然后边界条件需要特殊处理，进行提前赋值。

比如起点位置，直接赋值为grid[0][0]，还有就是第一行和第一列，其中第一行的位置只能够从左边过来，第一列的位置只能从上面过来，所以这一行一列需要提前初始化好。

下面我们来看看具体的代码（解法一）。

上面的解法我们可以看到，实际上我们是用grid[0][0]来填充了dp[0][0]，本题没说不可以修改原数组，那么可不可以利用直接修改grid来保存整个结果呢？

答案是可以的，也就是说我们可以进一步优化空间，接使用原数组 grid 进行累加，这里的累加方式跟解法一稍有不同，没有提前对第一行和第一列进行赋值，而是放在一起判断了，当i和j同时为0时，直接跳过。否则当i等于0时，只加上左边的值，当j等于0时，只加上面的值，否则就比较左边和上面的值，加上较小的那个即可，代码看解法二。

# 代码

## 解法一

```c
#define min(a, b) ((a)<(b)?(a):(b))

int minPathSum(int** grid, int gridSize, int* gridColSize)
{
    int m = gridSize, n = gridColSize[0];
    
    int dp[m][n];

    //dp数组初始化
    dp[0][0] = grid[0][0];
    
    if(m == 0 || n == 0) return 0;
    
    for (int i = 1; i < m; ++i) 
        dp[i][0] = grid[i][0] + dp[i - 1][0];
    for (int j = 1; j < n; ++j) 
        dp[0][j] = grid[0][j] + dp[0][j - 1];
    
    for (int i = 1; i < m; ++i) 
    {
        for (int j = 1; j < n; ++j) 
        {
            dp[i][j] = grid[i][j] + min(dp[i - 1][j], dp[i][j - 1]);
        }
    }
    return dp[m - 1][n - 1];
    
}
```

## 解法二

```c
#define min(a, b) ((a)<(b)?(a):(b))

int minPathSum(int** grid, int gridSize, int* gridColSize)
{
    int m = gridSize, n = gridColSize[0];
       
    if(m == 0 || n == 0) return 0;
            
    for (int i = 0; i < m; ++i) 
    {
        for (int j = 0; j < n; ++j) 
        {
            if(i == 0 && j == 0) continue;
            else if(i == 0)
                grid[0][j] += grid[0][j - 1];
            else if(j == 0)
                grid[i][0] += grid[i - 1][0];
            else
                
                grid[i][j] += min(grid[i - 1][j], grid[i][j - 1]);
        }
    }
    return grid[m - 1][n - 1];
    
}
```



# 参考

- [最小路径和官方题解](https://leetcode-cn.com/problems/minimum-path-sum/solution/zui-xiao-lu-jing-he-by-leetcode/)
- [[LeetCode] 64. Minimum Path Sum 最小路径和](https://www.cnblogs.com/grandyang/p/4353255.html)
