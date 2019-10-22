---
title: Leetcode-48. 旋转图像
date: 2019-10-21 23:03:57
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 数组
description: Leetcode刷题系列.
---
# 描述

给定一个 `n × n` 的二维矩阵表示一个图像。

将图像顺时针旋转 90 度。

**说明：**

你必须在[原地](https://baike.baidu.com/item/%E5%8E%9F%E5%9C%B0%E7%AE%97%E6%B3%95)旋转图像，这意味着你需要直接修改输入的二维矩阵。**请不要**使用另一个矩阵来旋转图像。

**示例 1:**

```c
给定 matrix = 
[
  [1,2,3],
  [4,5,6],
  [7,8,9]
],

原地旋转输入矩阵，使其变为:
[
  [7,4,1],
  [8,5,2],
  [9,6,3]
]
```

**示例 2:**

```c
给定 matrix =
[
  [ 5, 1, 9,11],
  [ 2, 4, 8,10],
  [13, 3, 6, 7],
  [15,14,12,16]
], 

原地旋转输入矩阵，使其变为:
[
  [15,13, 2, 5],
  [14, 3, 4, 1],
  [12, 6, 8, 9],
  [16, 7,10,11]
]
```

来源：力扣（LeetCode）
链接：[48. Rotate Image](https://leetcode-cn.com/problems/rotate-image)

# 解题思路

这题我首先想到的是递归的思路，我们先来看看n=3和n=4的两种情况。对于n=3的情况，其实就是外围这一圈数字[1,2,3,6,9,8,7,4]围绕着中间的5进行旋转，旋转的主要操作就是外围的数据进行移位，然后对于n=4的情况，就是将外围的数字旋转两遍，如下图所示，第一轮是最外围红色数字，第二轮是内圈蓝色的数字。

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Rotate%20Image.png)

既然是递归，那么就要考虑递归的参数。

首先，需要被原地旋转的矩阵本身肯定是需要被传递进去的，而且也是要以指针的方式传参。

另外就是每一轮旋转时需要移动的位数，比如在n=4的情况下，第一轮，需要移动`n-1=3`位，第二轮的时候已经将旋转好的外围数据去除，此时只需要移动1位，也就是说，每次递归调用，元素移动的位数是以2递减的，那么需要一个变量来表示这个值。

然后，每轮旋转开始时的元素在原数组当中的下标是每轮递增的，比如在n=4时，第一轮的开始元素A11（5）在原二维数组当中的下标是A[0][0]，第二轮的开始元素A22（4）在原二维数组当中的下标则是A[1][1]，这个下标`firstIndex`变量也是要在递归函数当中修改。

下面来看看每一轮递归调用旋转的具体实现过程：可以参考上图n=4的情况。

首先这个旋转需要循环`n-1`次，然后每次就是将每一行除最后一个元素外的其它元素换到另外一列上面，因为一共四条边，每次循环一共需要进行4次。

具体代码见解法一。

下面再来介绍一种迭代实现的解法，其实原理类似，就是对于当前位置，计算旋转后的新位置，然后再计算下一个新位置，第四个位置又变成当前位置了，所以这个方法每次循环换四个数字，如下所示：

```c
1  2  3                 7  2  1         7  4  1

4  5  6      -->        4  5  6　　 -->  8  5  2　　

7  8  9                 9  8  3　　　　　 9  6  3
```

代码见解法二。

还有一种解法，是先求出转置矩阵，然后再翻转每一行。这个方法的时间复杂度也是$O(N^2)$。 

具体代码见解法三。

# 代码

## 解法一

```c
void rotateSolver(int** matrix, int firstIndex, int n)
{
    if (n <= 1)
    {
        return;
    }
    
    for (int i = 0; i< n - 1; i++)
    {
        int tmp = matrix[firstIndex][firstIndex + i];
        matrix[firstIndex][firstIndex + i] = matrix[firstIndex + n - 1 - i][firstIndex];
        matrix[firstIndex + n - 1 - i][firstIndex] = matrix[firstIndex + n - 1][firstIndex + n - 1 - i];
        matrix[firstIndex + n - 1][firstIndex + n - 1 - i] = matrix[firstIndex + i][firstIndex + n - 1];
        matrix[firstIndex + i][firstIndex + n - 1] = tmp;
    }
    rotateSolver(matrix, firstIndex + 1, n - 2);
}



void rotate(int** matrix, int matrixSize, int* matrixColSize)
{
    rotateSolver(matrix, 0, matrixSize);
}
```

## 解法二

```c
void rotate(int** matrix, int matrixSize, int* matrixColSize)
{
    int n = matrixSize;
    
    for (int i = 0; i < n / 2; i++) 
    {
        for (int j = i; j < n - 1 - i; j++) 
        {
            int tmp = matrix[i][j];
            matrix[i][j] = matrix[n - 1 - j][i];
            matrix[n - 1 - j][i] = matrix[n - 1 - i][n - 1 - j];
            matrix[n - 1 - i][n - 1 - j] = matrix[j][n - 1 - i];
            matrix[j][n - 1 - i] = tmp;
        }
    }
}
```

## 解法三

```
void rotate(int** matrix, int matrixSize, int* matrixColSize)
{
    int n = matrixSize;
    
    // 矩阵转置
    for(int i = 0; i < n; i++)
    {
        for(int j = i; j < n; j++)
        {
            int tmp = matrix[j][i];
            matrix[j][i] = matrix[i][j];
            matrix[i][j] = tmp;
        }
    }
    
    // 行翻转
    
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < n / 2; j++)
        {
            int tmp = matrix[i][j];
            matrix[i][j] = matrix[i][n - j -1];
            matrix[i][n - j - 1] = tmp;
        }
    }
}
```

# 参考

- [LeetCode 48. Rotate Image（递归）](https://blog.csdn.net/da_kao_la/article/details/89138709)
- [旋转图像官方题解](https://leetcode-cn.com/problems/rotate-image/solution/xuan-zhuan-tu-xiang-by-leetcode/)