---
title: Leetcode Tencent 50 Task24 54. Spiral Matrix
date: 2019-09-03 15:15:48
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task24。
---

# 描述

给定一个包含 $m \times n$ 个元素的矩阵（$m$ 行, $n$ 列），请按照顺时针螺旋顺序，返回矩阵中的所有元素。

**示例 1:**

```c
输入:
[
 [ 1, 2, 3 ],
 [ 4, 5, 6 ],
 [ 7, 8, 9 ]
]
输出: [1,2,3,6,9,8,7,4,5]
```

**示例 2:**

```c
输入:
[
  [1, 2, 3, 4],
  [5, 6, 7, 8],
  [9,10,11,12]
]
输出: [1,2,3,4,8,12,11,10,9,5,6,7]
```

来源：力扣（LeetCode）
链接：[54. Spiral Matrix](https://leetcode-cn.com/problems/spiral-matrix)

# 解题思路

第一次碰到这样的题目，非常清楚解题的难点是遍历二维数组的时候如何转向（左遍历、下遍历、右遍历、上遍历），以及在转向以后下标的处理，苦想15分钟还是不得其解，于是参考相关大佬的解法。这里根据我自己的理解介绍其中的两种。

## 解法一

- 设定数组上下左右边界：`upper = 0, down = matrixSize - 1, left = 0, right = *matrixColSize - 1`
- 若上下/左右边界不交错，则按顺时针分别进行遍历：
  - 向右遍历数组，保持行指标`upper`不变，列指标从`left`到`right`，遍历后重新设定边界`++upper`，然后判断上下是否交错，交错则跳出循环，表明矩阵已经螺旋遍历完成
  - 向下遍历数组，保持列指标`right`不变，列指标从`upper`到`down`，遍历后重新设定边界`--right`，然后判断左右是否交错，交错则跳出循环，表明矩阵已经螺旋遍历完成
  - 向左遍历数组，保持行指标`down`不变，列指标从`right`到`left`，遍历后重新设定边界`--down`，然后判断上下是否交错，交错则跳出循环，表明矩阵已经螺旋遍历完成
  - 向上遍历数组，保持列指标`left`不变，列指标从`down`到`upper`，遍历后重新设定边界`++left`，然后判断左右是否交错，交错则跳出循环，表明矩阵已经螺旋遍历完成
  
具体代码见解法一。

## 解法二

解法二的核心是通过引入一个遍历`directIndex`为数组的遍历设定一个方向，然后按照`0, 1, 2, 3`分别代表向右、向下、向左和向上，如果螺旋完一圈`directIndex`超过4，则将它4取模，重新开始走一圈。每走完一行，需要修改数组边界，举个例子，如果用`colLength`表示行的长度，如果第一行走完，相应地要`--colLength`。大循环的条件是待返回结果数组的下标小于需要返回的数组元素的中个数。

具体代码见解法二。

# 代码

## 解法一

```c
int* spiralOrder(int** matrix, int matrixSize, int* matrixColSize, int* returnSize)
{
    //如果矩阵为空则返回NULL
    if(matrixSize == 0 || *matrixColSize == 0)
     {
        *returnSize=0;
        return NULL;
     }

    //数据边界初始化
    int upper = 0;
    int down = matrixSize - 1;
    int left = 0;
    int right = *matrixColSize - 1;

    //返回结果内存分配
    *returnSize = matrixSize * *matrixColSize;
    int* result = (int*)malloc(sizeof(int)* *returnSize);
    //返回数组下标
    int index = 0;
    
    while(true)
    {
        for(int i = left; i <= right; ++i)      //数组向右移动
        {
            result[index++] = matrix[upper][i];
        }

        if(++upper > down)                      //重新设定上边界，判断上下是否交错
        {
            break;
        }

        for(int i = upper; i <= down; ++i)      //数组向下移动
        {
            result[index++] = matrix[i][right];
        }

        if(--right < left)                      //重新设定右边界，判断左右是否交错
        {
            break;
        }

        for(int i = right; i >= left; --i)      //数组向左移动
        {
            result[index++] = matrix[down][i];
        }

        if(--down < upper)                      //重新设定下边界，判断上下是否交错
        {
            break;
        }

        for(int i = down; i >= upper; --i)      //数组向上移动
        {
            result[index++] = matrix[i][left];
        }

        if(++left > right)                      //重新设定左边界，判断左右是否交错
        {
            break;
        }
    }
    
    return result;
}
```


## 解法二


```c
int* spiralOrder(int** matrix, int matrixSize, int* matrixColSize, int* returnSize)
{
     //如果矩阵为空则返回NULL
     if(matrixSize == 0 || *matrixColSize == 0)
     {
        *returnSize=0;
        return NULL;
     }
     //返回结果内存分配
    *returnSize = matrixSize * *matrixColSize;
    int* result = (int*)malloc(sizeof(int)* *returnSize);

    //返回数组下标
    int index = 0;
    int nowRow = 0, nowCol = -1;
    int colLength = *matrixColSize, rowLength = matrixSize - 1;

    //数组遍历方向指示变量
    int directIndex = 0;

    //大循环结束条件返回数组下标小于待返回数组元素总个数
    while(index < *returnSize)
    {
        switch(directIndex)
        {
        case 0:                                //向右遍历数组
                for(int i = 0; i < colLength; ++i)
                {
                    ++nowCol;
                    result[index++] = matrix[nowRow][nowCol];
                }
                //数组边界修改
                --colLength;
                break;
                
        case 2:                               //向左遍历数组
                for(int i = 0; i < colLength; ++i)
                {
                    --nowCol;
                    result[index++] = matrix[nowRow][nowCol];
                }
                //数组边界修改 
                --colLength;
                break;
                
        case 1:                               //向下遍历数组
                for(int i = 0; i < rowLength; ++i)
                {
                    ++nowRow;
                    result[index++] = matrix[nowRow][nowCol];
                }
                //数组边界修改 
                --rowLength;
                break;
                
        case 3:                               //向上遍历数组
                for(int i = 0; i < rowLength; ++i)
                {
                    --nowRow;
                    result[index++] = matrix[nowRow][nowCol];
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

```


# 参考资料

- [C++详细题解](https://leetcode-cn.com/problems/spiral-matrix/solution/cxiang-xi-ti-jie-by-youlookdeliciousc-3/)