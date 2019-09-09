---
title: Leetcode Tencent 50 344. Reverse String
date: 2019-09-08 15:02:21
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 链表
description: DataWhale暑期学习小组-LeetCode刷题第八期Taskxx。
---

# 描述

编写一个函数，其作用是将输入的字符串反转过来。输入字符串以字符数组` char[] `的形式给出。

不要给另外的数组分配额外的空间，你必须原地修改输入数组、使用$ O(1)$ 的额外空间解决这一问题。

你可以假设数组中的所有字符都是 `ASCII` 码表中的可打印字符。

 

**示例 1：**

```c
输入：["h","e","l","l","o"]
输出：["o","l","l","e","h"]
```

**示例 2：**

```c
输入：["H","a","n","n","a","h"]
输出：["h","a","n","n","a","H"]
```

来源：力扣（LeetCode）
链接：[344. Reverse String](https://leetcode-cn.com/problems/reverse-string)

# 解题思路

比较简单的一个题目，采用头尾双指针法，头尾交换，然后对象将指针往中间移动，知道两个指针相遇，退出循环，此时也交换完成，不管原来的数组的个数是奇数还是偶数，都可以用这种方法。具体代码如下：

# 代码

    ```c
void reverseString(char* s, int sSize)
{
    int head = 0, tail = sSize - 1;
    char tmp;
    
    while(head < tail)
    {
        tmp = s[head];
        s[head] = s[tail];
        s[tail] = tmp;
        head++;
        tail--;
    } 
}

```