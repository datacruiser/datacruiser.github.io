---
title: 28. 实现 strStr()
date: 2019-09-29 10:17:55
categories: Leetcode
tags:
- 数据结构
- 算法
- C语言
- 字符串
- 数组
description: LeetCode刷题系列。
---

# 描述

实现` strStr() `函数。

给定一个 `haystack` 字符串和一个 `needle `字符串，在 `haystack `字符串中找出 `needle `字符串出现的第一个位置 (从0开始)。如果不存在，则返回  -1。

**示例 1:**

```c
输入: haystack = "hello", needle = "ll"
输出: 2
```

**示例 2:**

```c

输入: haystack = "aaaaa", needle = "bba"
输出: -1
```

**说明:**

当 `needle` 是空字符串时，我们应当返回什么值呢？这是一个在面试中很好的问题。

对于本题而言，当 `needle` 是空字符串时我们应当返回 0 。这与`C`语言的` strstr() `以及 `Java`的 `indexOf() `定义相符。

来源：力扣（LeetCode）
链接：[28. Implement strStr()](https://leetcode-cn.com/problems/implement-strstr)

# 解题思路

本题的难度是 简单，但是我做下来感觉没有那么简单，或许是我太菜了吧。 

先说下，我原来的思路：

- 找到与`needle`字符串首字符相等的字符在`haystack`字符串当中首次出现的位置`position`
- 然后遍历`needle`字符串，逐个与`haystack`字符串在`postion`之后的字符进行比较遇到不同则返回-1
- 如果遍历之后没有返回，在跳出循环后返回`position`

具体代码如下：

```c

int strStr(char * haystack, char * needle)
{
    int haylen = strlen(haystack);
    int needlelen = strlen(needle);
    
    
    if(needlelen == 0)
        return 0;
    
    if(needlelen > haylen)
        return -1;
    
    int position = 0;
    
    //int* positionlist = (int *)malloc(hyalen * sizeof(int));

    //找到与needle字符串首字符相等的字符在haystack字符串当中首次出现的位置
    while(position < haylen)
    {
        if(haystack[position] == needle[0])
        {
            break;
        }
        
        position++;
    }
    
    //遍历
    
    for(int i  = 0; i < needlelen; i++)
    {
        if(haystack[position + i] != needle[i])
            return -1;
    }
    
    return position;
}
```

很遗憾，这样写是有bug的，比如`needle`的首字符在`haystack`中重复出现，且能够匹配上的完整字符串并不是第一个，比如下面这个例子：

![bug](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/%E5%AE%9E%E7%8E%B0%20strStr%28%29%20-%20%E6%8F%90%E4%BA%A4%E8%AE%B0%E5%BD%95%20-%20%E5%8A%9B%E6%89%A3%20%28LeetCode%29%202019-09-29%2016-06-17.png)

既然如此，后面就换了一种思路，索性开一个数组`positionlist`，把所有与`needle`首字符匹配的`position`都找出来并加以记录，后面再比较每个`position`开始的`needlelen`长度的字符串是否与`needle`相等，如果相等则返回当前的位置，都不想等的话在跳出循环后返回-1，具体代码如下：

# 代码

```c
//subString 子函数
char * subString(char * s, int startIndex, int endIndex)
{
/*
  s: 需要截取的字符串头指针变量
  startIndex: 截取起始索引
  endIndex: 截取终止索引
 */
    assert(endIndex >= startIndex);
    assert(s != NULL);

    int length = endIndex - startIndex;

    char *tmp = (char *)malloc(SHRT_MAX * sizeof(char));

    strncpy(tmp, s + startIndex, length);

    tmp[length] = '\0';

    return tmp;
}

int strStr(char * haystack, char * needle)
{
    int haylen = strlen(haystack);
    int needlelen = strlen(needle);
    
    
    if(needlelen == 0)
        return 0;
    
    if(needlelen > haylen)
        return -1;
    
    int position = 0;
    int positionIndex = 0;
    
    int* positionlist = (int *)malloc(haylen * sizeof(int));
    memset(positionlist, 0, sizeof(int) * haylen);
    //int positionlist[haylen];

    while(position < haylen)
    {
        if(haystack[position] == needle[0])
        {
            positionlist[positionIndex++] = position;
        }
        position++;
    }
    
    
    for(int j = 0; j < positionIndex; j++)
    {
        if(haylen - positionlist[j] < needlelen)
        {
            return -1;
        }
        else
        {
            char* tmp = subString(haystack, positionlist[j], positionlist[j] + needlelen);
            if(strcmp(tmp, needle) == 0)
            {
                return positionlist[j];
            }

        }

    }
    
    return -1;
    
}
```
