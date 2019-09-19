---
title: 8. 字符串转换整数 (atoi) Leetcode Tencent 50
date: 2019-09-19 11:35:07
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 字符串
description: DataWhale暑期学习小组-LeetCode刷题第八期Taskxx。
---

# 描述

请你来实现一个 `atoi` 函数，使其能将字符串转换成整数。

首先，该函数会根据需要丢弃无用的开头空格字符，直到寻找到第一个非空格的字符为止。

当我们寻找到的第一个非空字符为正或者负号时，则将该符号与之后面尽可能多的连续数字组合起来，作为该整数的正负号；假如第一个非空字符是数字，则直接将其与之后连续的数字字符组合起来，形成整数。

该字符串除了有效的整数部分之后也可能会存在多余的字符，这些字符可以被忽略，它们对于函数不应该造成影响。

注意：假如该字符串中的第一个非空格字符不是一个有效整数字符、字符串为空或字符串仅包含空白字符时，则你的函数不需要进行转换。

在任何情况下，若函数不能进行有效的转换时，请返回 0。

说明：

假设我们的环境只能存储 32 位大小的有符号整数，那么其数值范围为 [−231,  231 − 1]。如果数值超过这个范围，请返回  INT_MAX $(2^{31} − 1)$ 或 INT_MIN $(−2^{31})$ 。

**示例 1:**

```c
输入: "42"
输出: 42
```

**示例 2:**

```c
输入: "   -42"
输出: -42
解释: 第一个非空白字符为 '-', 它是一个负号。
     我们尽可能将负号与后面所有连续出现的数字组合起来，最后得到 -42 。
```

**示例 3:**

```c
输入: "4193 with words"
输出: 4193
解释: 转换截止于数字 '3' ，因为它的下一个字符不为数字。
```

**示例 4:**

```c
输入: "words and 987"
输出: 0
解释: 第一个非空字符是 'w', 但它不是数字或正、负号。
     因此无法执行有效的转换。
```

**示例 5:**

```c
输入: "-91283472332"
输出: -2147483648
解释: 数字 "-91283472332" 超过 32 位有符号整数范围。 
     因此返回 INT_MIN 。
```

来源：力扣（LeetCode）
链接：[8. String to Integer (atoi)](https://leetcode-cn.com/problems/string-to-integer-atoi)

# 解题思路

本题在求解的时候需要注意以下几点：

- 前面空格的过滤
- 正负号的判断和处理
- 判断是否溢出
- 数字的处理

空格的处理就是在遍历字符串的时候遇到空格直接移动指针，不进行任何处理，遇到正负号时用一个变量`sign`来表示正负。最后一个循环就是处理数字，并且在数字处理的过程中判断是否有溢出，为了溢出不出错用`long`来定义`result`变量。

数字的处理的核心代码就一行`result = 10 * result + (str[i] - '0')`，就是逐位不断地与10相乘并加上数字，数字通过字符串相减`str[i] - '0'` 获得。

具体代码如下，如果不想用`long`来定义`result`，可以在最后一次进位相乘前判断`reslult`的值，提前返回，具体代码见解法二。

# 代码

## 解法一

```c
int myAtoi(char * str)
{
    int length = strlen(str);
    
    if(length == 0) return 0;
    
    int sign = 1, i = 0;
    
    long result = 0;
    
    while(i < length && str[i] == ' ') ++i;                   //过滤掉前面的空字符
    
    if(i < length && (str[i] == '+' || str[i] == '-'))        //判断正负号
    {
        sign = (str[i] == '+') ? 1 : -1;
        i++;
    }
    
    while(i < length && str[i] >= '0' && str[i] <= '9')       //处理数字
    {
              
        result = 10 * result + (str[i] - '0');
        i++;
        
        if(result > INT_MAX || result < INT_MIN)              //判断是否溢出，为了避免溢出，用long来定义result
        {
            return (sign == 1) ? INT_MAX : INT_MIN;
        }
    }
    
    return result * sign;
    
}


```

## 解法二

```c
int myAtoi(char * str)
{
    int length = strlen(str);
    
    if(length == 0) return 0;
    
    int sign = 1, i = 0, result = 0;
    
    while(i < length && str[i] == ' ') ++i;                   //过滤掉前面的空字符
    
    if(i < length && (str[i] == '+' || str[i] == '-'))        //判断正负号
    {
        sign = (str[i] == '+') ? 1 : -1;
        i++;
    }
    
    while(i < length && str[i] >= '0' && str[i] <= '9')       //处理数字
    {
        
        if(result > INT_MAX / 10 || (result == INT_MAX / 10 && str[i] - '0' > 7))
        {
            return (sign == 1) ? INT_MAX : INT_MIN;
        }
        
        result = 10 * result + (str[i] - '0');
        i++;
       
       /*
        if(result > INT_MAX || result < INT_MIN)              //判断是否溢出，为了避免溢出，用long来定义result
        {
            return (sign == 1) ? INT_MAX : INT_MIN;
        }
        */
    }
    
    return result * sign;
    
}


```
