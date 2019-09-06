---
title: Leetcode Tencent 50 Task 25 59. Spiral Matrix II
date: 2019-09-05 09:54:36
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task25。
---

# 描述

给定一个正整数 $n$，生成一个包含 1 到 $n^2$ 所有元素，且元素按顺时针顺序螺旋排列的正方形矩阵。

**示例:**

```c
输入: 3
输出:
[
 [ 1, 2, 3 ],
 [ 8, 9, 4 ],
 [ 7, 6, 5 ]
]
```

来源：力扣（LeetCode）
链接：[59. Spiral Matrix II](https://leetcode-cn.com/problems/spiral-matrix-ii)

# 解题思路

这道题可以理解为[54. Spiral Maxtrix](https://leetcode-cn.com/problems/spiral-matrix/)的逆过程，如果上一道题的思路理解了的话那么理解这道题就比较简单。具体解法如下：

## 解法一

- 设定数组上下左右边界：`upper = 0, down = n - 1, left = 0, right = n - 1`
- 设定初始值`count = 1`，数据上界`target = n * n`
- 如果`count <= target`时，则按顺时针分别对数组进行填充：
  - 向右填充数组，保持行指标`upper`不变，列指标从`left`到`right`，遍历后重新设定边界`++upper`
  - 向下填充数组，保持列指标`right`不变，列指标从`upper`到`down`，遍历后重新设定边界`--right`
  - 向左填充数组，保持行指标`down`不变，列指标从`right`到`left`，遍历后重新设定边界`--down`
  - 向上填充数组，保持列指标`left`不变，列指标从`down`到`upper`，遍历后重新设定边界`++left`
  
具体代码见解法一，给出了`Java`和`C`两个版本，一直对于C语言的二级指针的初始化有些懵懂，正好参考一下大神的代码看看相关的套路。

## 解法二

解法二的核心是通过引入一个变量`directIndex`为数组的填充设定一个方向，然后按照`0, 1, 2, 3`分别代表向右、向下、向左和向上，如果螺旋完一圈`directIndex`超过4，则将它4取模，重新开始走一圈。每走完一行，需要修改数组边界，举个例子，如果用`colLength`表示行的长度，如果第一行走完，相应地要`--colLength`。大循环的条件与解法一的相同。

这里有一点需要注意，第一遍水平方向的填充在水平方向一共有`n`个元素，在第一遍水平方向填充完成以后，在第一遍的垂直方向填充已经只有`n-1`个元素了，因此数组的`colLength`和`rowLength`分别初始化为`n`和`n-1`。

具体代码见解法二。
  

# 代码

## 解法一: Java版本

```java
class Solution 
{
    public int[][] generateMatrix(int n) 
    {
     
        int[][] result = new int[n][n];
    
        //数据边界初始化
        int upper = 0;
        int down = n - 1;
        int left = 0;
        int right = n - 1;



        int count = 1, target = n * n;

        while(count <= target)
        {
            for(int i = left; i <= right; ++i)      //数组向右移动
            {
                result[upper][i] = count++;
            }

            ++upper;                                //重新设定上边


            for(int i = upper; i <= down; ++i)      //数组向下移动
            {
                result[i][right] = count++;
            }

            --right;                                //重新设定右边


            for(int i = right; i >= left; --i)      //数组向左移动
            {
                result[down][i] = count++;
            }

            --down;                                 //重新设定下边界


            for(int i = down; i >= upper; --i)      //数组向上移动
            {
                result[i][left] = count++;
            }

            ++left;                                 //重新设定左边

        }

        return result;
    } 
}
```

## 解法一: C版本

```c
/**
 * Return an array of arrays of size *returnSize.
 * The sizes of the arrays are returned as *returnColumnSizes array.
 * Note: Both returned array and *columnSizes array must be malloced, assume caller calls free().
 */
 

int** generateMatrix(int n, int* returnSize, int** returnColumnSizes)
{
    //初始化二级指针和内存分配
    int **result = (int **)malloc(n * sizeof(int *));
    
    *returnSize = n;
    
    //返回列的大小初始化和内存分配
    *returnColumnSizes = (int*)malloc(sizeof(int)*n);
    
    //返回二级指针各行内存分配和列的大小赋值
    for (int i = 0; i < n; i++) 
    {
        result[i] = (int *)malloc(n * sizeof(int));
        returnColumnSizes[0][i] = n;
    }
    
    
    //数据边界初始化
    int upper = 0;
    int down = n - 1;
    int left = 0;
    int right = n - 1;

    int count = 1, target = n * n;

    while(count <= target)
    {
        for(int i = left; i <= right; ++i)      //数组向右移动
        {
            result[upper][i] = count++;
        }

        ++upper;                                //重新设定上边


        for(int i = upper; i <= down; ++i)      //数组向下移动
        {
            result[i][right] = count++;
        }

        --right;                                //重新设定右边


        for(int i = right; i >= left; --i)      //数组向左移动
        {
            result[down][i] = count++;
        }

        --down;                                 //重新设定下边界


        for(int i = down; i >= upper; --i)      //数组向上移动
        {
            result[i][left] = count++;
        }

        ++left;                                 //重新设定左边

    }

    return result;
        
}

```

## 解法二

```java
class Solution {
    public int[][] generateMatrix(int n) {
     
        int[][] result = new int[n][n];
    
        //待填充数组下标
        int nowRow = 0, nowCol = -1;
        int colLength = n, rowLength = n - 1;
        
        int count = 1, target = n * n;

        //数组遍历方向指示变量
        int directIndex = 0;

        //大循环结束条件返回数组下标小于待返回数组元素总个数
        while(count <= target)
        {
            switch(directIndex)
            {
                case 0:                                //向右遍历数组
                    for(int i = 0; i < colLength; ++i)
                    {
                        result[nowRow][++nowCol] = count++;
                    }
                    //数组边界修改
                    --colLength;
                    break;

                case 2:                               //向左遍历数组
                    for(int i = 0; i < colLength; ++i)
                    {
                        result[nowRow][--nowCol] = count++;
                    }
                    //数组边界修改 
                    --colLength;
                    break;

                case 1:                               //向下遍历数组
                    for(int i = 0; i < rowLength; ++i)
                    {
                        result[++nowRow][nowCol] = count++;
                    }
                    //数组边界修改 
                    --rowLength;
                    break;

                case 3:                               //向上遍历数组
                    for(int i = 0; i < rowLength; ++i)
                    {
                        result[--nowRow][nowCol] = count++;
                    }
                    //数组边界修改 
                    --rowLength;
                    break;
            }

            //数组移动方向修改
            ++directIndex;

            directIndex %= 4;                                   //以4为循环

        }
        return result;
    }
}
```


