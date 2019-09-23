---
title: Leetcode Tencent 50 Task 39 7. Reverse Integer
date: 2019-09-01 09:30:37
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task39。
---

# 描述

给出一个` 32` 位的有符号整数，你需要将这个整数中每位上的数字进行反转。

**示例 1:**

```c
输入: 123
输出: 321
```

**示例 2:**

```c

输入: -123
输出: -321
```

**示例 3:**

```c

输入: 120
输出: 21
```

注意:

假设我们的环境只能存储得下` 32` 位的有符号整数，则其数值范围为 $[−2^{31},  2^{31} − 1]$。请根据这个假设，如果反转后整数溢出那么就返回 0。



来源：力扣（LeetCode）
链接：[7. Reverse Integer](https://leetcode-cn.com/problems/reverse-integer)

# 解题思路

本题的难点主要在于对于溢出的处理，这个在处理上面有两种方法，一种是在转换的过程当中就进行处理，另外一种是一开始就定义一个`long`的变量，然后在转换完成以后判断是否溢出。

如果除去需要考虑的溢出问题，那么本题在数学上的算法其实很简单。

我们想重复“弹出”`x` 的最后一位数字，并将它“推入”到`result` 的后面。最后，`result` 将与 `x` 相反。

要在没有辅助堆栈 / 数组的帮助下 “弹出” 和 “推入” 数字，我们可以使用数学方法。

弹出的过程就是不断得用`x`对10求余, 求除, 推入的过程是求余的结果不断加到`result`当中, 并且每次将`result`乘以10以后不断累加.

```c

//pop operation:
pop = x % 10;
x /= 10;

//push operation:
result = 0
temp = result * 10 + pop;
result = temp;
```


# 代码

## 解法一: 转换当中判断是否溢出

```c

int reverse(int x)
{
    int result = 0, pop, tmp;
    while (x != 0) 
        
    {
        if (abs(result) > INT_MAX / 10) return 0; //转换过程当中判断是否溢出, 溢出则直接返回0
        pop = x % 10;
        tmp = result * 10 + pop;
        result = tmp;
        x /= 10;
    }
        
    return result;
}


``` 

## 解法二: 转换后判断是否溢出, 这样一开始就要定义一个long型整数

```c
    
int reverse(int x){
    long result = 0;
    while (x != 0) 
    {
        result = result * 10 + x % 10; // pop, tmp等中间变量可以省略
        x /= 10;
    }
    
    return (result > INT_MAX || result < INT_MIN) ? 0 : result; //除了判断上界是否溢出, 也要考虑下界是否溢出

}

``` 
