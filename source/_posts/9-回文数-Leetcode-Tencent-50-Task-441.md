---
title: 9. 回文数 Leetcode Tencent 50 Task 41
date: 2019-09-26 18:41:34
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 字符串
description: DataWhale暑期学习小组-LeetCode刷题第八期Task41。
---

# 描述

判断一个整数是否是回文数。回文数是指正序（从左向右）和倒序（从右向左）读都是一样的整数。

**示例 1:**

```c
输入: 121
输出: true
```

**示例 2:**

```c
输入: -121
输出: false
解释: 从左向右读, 为 -121 。 从右向左读, 为 121- 。因此它不是一个回文数。
```

**示例 3:**

```c
输入: 10
输出: false
解释: 从右向左读, 为 01 。因此它不是一个回文数。
```

**进阶:**

你能不将整数转为字符串来解决这个问题吗？

来源：力扣（LeetCode）
链接：[9. Palindrome Number]https://leetcode-cn.com/problems/palindrome-number

# 解题思路

既然题干已经说明了不能将整数转化为字符串，那么本题的解法只能对整数本身进行操作了。主要的思路就是用`%`和`/`来获得整数的最低位和最高位，然后进行比较，遇到不相等则返回`false`。主要步骤如下：

- 显然x如果是负数，那么一定不会回文串
- 首先需要找到x的位数所对应的能够通过求余取得x最高位的整数`div`，听起来很拗口，举个例子，比如x是三位数，那么需要求得得整数是100，如果x是4位数，那么需要求得得整数是1000，以此类推
- 然后定义两个头尾指针，因为要移动，就姑且叫它指针吧，左边通过`x / div` 获取x的最高位，记为`left`，右边通过`x % 10`获取x的最低位，记为`right`
- 然后去除已经比较过的头尾两个数，通过`x % div`去除头指针，再将这个结果除以10去除尾指针
- 最后`div`也要相应减少两位：`div / = 100`
- 直到`x>0`不成立跳出循环，返回`true`

具体代码如下：

# 代码

```c

bool isPalindrome(int x)
{
    if( x < 0) return false;
    
    int div = 1;
    while(x / div >= 10) div *= 10;
    
    while(x > 0)
    {
        int left = x / div;
        int right = x % 10;
        if(left != right) return false;
        x = (x % div) / 10;
        div /= 100;
    }
    
    return true;
}

```
