---
title: Leetcode Tencent 50 Task20 11. Container With Most Water
date: 2019-08-25 20:47:08
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task20。
---

# 描述

给定 n 个非负整数 $a_1，a_2，...，a_n$，每个数代表坐标中的一个点 $(i, a_i)$ 。在坐标内画 n 条垂直线，垂直线 i 的两个端点分别为 $(i, a_i)$ 和 $(i, 0)$。找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水。

说明：你不能倾斜容器，且 n 的值至少为 2。

![](https://aliyun-lc-upload.oss-cn-hangzhou.aliyuncs.com/aliyun-lc-upload/uploads/2018/07/25/question_11.jpg)

图中垂直线代表输入数组 [1,8,6,2,5,4,8,3,7]。在此情况下，容器能够容纳水（表示为蓝色部分）的最大值为 49。

 

**示例:**

```c

输入: [1,8,6,2,5,4,8,3,7]
输出: 49
```

来源：力扣（LeetCode）
链接：[11. Container With Most Water](https://leetcode-cn.com/problems/container-with-most-water)



# 解题思路

依据题意，我们得到容器体积的计算公式为：
$$V=(j-i)  \times (min(a_i,a_j))$$
然后便很容易想到用一个两重循环来遍历$i,j$，求出其中的最大的体积。
以上算法的时间复杂度是$O(n^2)$，有没有更加优化的算法呢？

当然还是有的，我可以设置两个指针$i,j$，一个指向数组的头，一个指向数组的尾，然后不断向中间遍历，在遍历的过程当中更新容器的最大体积。遍历的条件是比较$a_i$和 $a_j$的大小，如果$a_i$小，则`i++`，反之`j++`，遍历的停止条件是`i<j`。

这样，只需要遍历一遍就能够找到最大值，算法时间复杂度是$O(n)$。

下面分别给出两个方法的代码。

# 代码

## 解法一：二重循环

```c
//定义辅助比较函数
int min(int a, int b)
{
    if(a > b) return b;
    else return a;
}

int max(int a, int b)
{
    if(a > b) return a;
    else return b;
}

int maxArea(int* height, int heightSize)
{
    int maxVolume = 0;
    for (int i = 0; i < heightSize; i++)
        for(int j = i + 1; j < heightSize; j++)
            maxVolume = max(maxVolume, (j - i) * min(height[i], height[j]));  //更新最大容积
    return  maxVolume;
}



``` 

## 解法二：双指针法

```c
//定义辅助比较函数
int min(int a, int b)
{
    if(a > b) return b;
    else return a;
}

int max(int a, int b)
{
    if(a > b) return a;
    else return b;
}

int maxArea(int* height, int heightSize)
{
    int i = 0, j = heightSize - 1;
    int maxVolume = 0;
    while (i < j)
    {
        maxVolume = max(maxVolume, (j - i) * min(height[i], height[j])); //更新最大容积
        if (height[i] < height[j])
            i++;                                                         //前端指针右移
        else
            j--;                                                         //末端指针左移  
    }
    return  maxVolume;
}


``` 
