---
title: Leetcode Tencent 50 Task9 231. Power of Two
date: 2019-08-11 16:10:23
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 位运算
description: DataWhale暑期学习小组-LeetCode刷题第八期Task9。
---

# 描述

给定一个整数，编写一个函数来判断它是否是 2 的幂次方。

**示例 1:**
```
输入: 1
输出: true
解释: 20 = 1
```

**示例 2:**
```
输入: 16
输出: true
解释: 24 = 16
```

**示例 3:**
```
输入: 218
输出: false
```

来源：力扣（LeetCode）
链接：[231. Power of Two](https://leetcode-cn.com/problems/power-of-two)


# 解题思路

本题依然是考察位运算，掌握了小技巧非常简单，首先一个整数如果是2的幂次方需要满足以下两个条件：

- 该整数需要大于0；
- 该整数对应的二进制位串有且仅有一个1，且在最高位。

那么本题的思路就出来，写一个统计整数二进制位串1的个数的辅助函数，如果满足整数>0且二进制位串中1的个数为1则返回`true`，否则返回`false`。

# 代码


```c
int count(int num) {
    int count = 0; 
    while(num != 0){
        if(num & 1) 
            count++;
        num >>= 1; 
    }
    return count;
}
/*
bool isPowerOfTwo(int n)
{
	if (n > 0 && count(n) == 1)
		return true;
	else 
	   return false;
}
*/

bool isPowerOfTwo(int n)
{
	return (n > 0 && count(n) == 1);

}
``` 
