---
title: 89. 格雷编码 Leetcode Tencent 50
date: 2019-09-25 08:21:42
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 位操作
description: DataWhale暑期学习小组-LeetCode刷题第八期Taskxx。
---

# 描述

格雷编码是一个二进制数字系统，在该系统中，两个连续的数值仅有一个位数的差异。

给定一个代表编码总位数的非负整数 n，打印其格雷编码序列。格雷编码序列必须以 0 开头。

**示例 1:**
```c
输入: 2
输出: [0,1,3,2]
解释:
00 - 0
01 - 1
11 - 3
10 - 2

对于给定的 n，其格雷编码序列并不唯一。
例如，[0,2,3,1] 也是一个有效的格雷编码序列。

00 - 0
10 - 2
11 - 3
01 - 1
```

示**例 2:**
```c
输入: 0
输出: [0]
解释: 我们定义格雷编码序列必须以 0 开头。
     给定编码总位数为 n 的格雷编码序列，其长度为 2n。当 n = 0 时，长度为 20 = 1。
     因此，当 n = 0 时，其格雷编码序列为 [0]。
```

来源：力扣（LeetCode）
链接：[89. Gray Code](https://leetcode-cn.com/problems/gray-code)


# 解题思路

解题之前进一步了解[格雷编码](https://en.wikipedia.org/wiki/Gray_code)，再看一下四位的格雷码：
```c
Decimal Binary  Grey
    0	0000	0000
    1	0001	0001
    2	0010	0011
    3	0011	0010
    4	0100	0110
    5	0101	0111
    6	0110	0101
    7	0111	0100
    8	1000	1100
    9	1001	1101
    10	1010	1111
    11	1011	1110
    12	1100	1010
    13	1101	1011
    14	1110	1001
    15	1111	1000
```
不难发现格雷码的规律，正如题干中说描述的，主要特点是两个相邻数的代码只有一位二进制数不同的编码。碰到这种对于位级别进行操作的题目容易想到采用位操作，有没有什么办法能够实现二进制码与格雷码之间的转换呢，如果有那么本题就迎刃而解了。

显然是有的，前面给出的wiki百科里面就给出了相关代码片段：

```c
/*
        The purpose of this function is to convert an unsigned
        binary number to reflected binary Gray code.
 
        The operator >> is shift right. The operator ^ is exclusive or.
*/
unsigned int binaryToGray(unsigned int num)
{
        return (num >> 1) ^ num;
}
```

把上述代码应用到本题，具体代码如下：


# 代码


```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* grayCode(int n, int* returnSize)
{
    int length = pow(2, n);
    int *result = (int *)malloc(sizeof(int) * length);
    
    for(int i = 0; i < length; i++)
    {
        *(result+i) = (i >> 1) ^ i;
    }
    
    *returnSize = length;
    
    return result;
}

```

