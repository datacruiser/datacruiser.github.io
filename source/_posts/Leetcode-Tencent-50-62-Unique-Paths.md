---
title: Leetcode Tencent 50 62. Unique Paths
date: 2019-09-06 19:15:03
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Taskxx。
---

# 描述

一个机器人位于一个 $m x n$ 网格的左上角 （起始点在下图中标记为“Start” ）。

机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为“Finish”）。

问总共有多少条不同的路径？

![](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/10/22/robot_maze.png)

例如，上图是一个7 x 3 的网格。有多少可能的路径？

说明：m 和 n 的值均不超过 100。

**示例 1:**

```c
输入: m = 3, n = 2
输出: 3
解释:
从左上角开始，总共有 3 条路径可以到达右下角。
1. 向右 -> 向右 -> 向下
2. 向右 -> 向下 -> 向右
3. 向下 -> 向右 -> 向右
```

**示例 2:**

```c
输入: m = 7, n = 3
输出: 28
```

来源：力扣（LeetCode）
链接：[62. Unique Paths](https://leetcode-cn.com/problems/unique-paths)

# 解题思路

刚刚在MOOC看了北京大学郭炜老师关于[数字三角形的题目](https://www.icourse163.org/learn/PKU-1001894005?tid=1206483202#/learn/content?type=detail&id=1211268465&cid=1213844097&replay=true)，这道题的思路基本类似。

我们令`MaxPaths[i][j]`为到达`i,j`的最多路径，则动态方程为：`MaxPaths[i][j]=MaxPaths[i-1][j] + MaxPaths[i][j-1]`，考虑下边界条件，对于第一行或者第一列，根据移动的规则，只能够一直往右或者一直往下，只有一种可能的路径，即`MathPaths[0][j] = MaxPaths[i][0] = 1`

代码可以有两个写法，一种递归的写法，一种是迭代的写法。不过提交以后递归的写法超时了……


# 代码

## 解法一：递归解法，超时

```c
int uniquePaths(int m, int n)
{
    
    if(m == 1)
        return 1;
    
    if(n == 1)
        return 1;
    
    return uniquePaths(m - 1, n) + uniquePaths(m, n - 1);
}
```


## 解法二：迭代解法，


```c
int uniquePaths(int m, int n)
{
    int Maxpaths[m][n];
    
    for(int i = 0; i < m; i++)
        Maxpaths[i][0] = 1;
    
    for(int i = 0; i < n; i++)
        Maxpaths[0][i] = 1;
    
    for(int i = 1; i < m; i++)
        for(int j = 1; j < n; j++)
            Maxpaths[i][j] = Maxpaths[i - 1][j] + Maxpaths[i][j - 1];
    
    return Maxpaths[m - 1][n - 1];
            
}
```



