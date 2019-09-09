---
title: Leetcode Tencent 50 14. Longest Common Prefix
date: 2019-09-09 16:53:45
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 字符串
description: DataWhale暑期学习小组-LeetCode刷题第八期Taskxx。
---

# 描述

编写一个函数来查找字符串数组中的最长公共前缀。

如果不存在公共前缀，返回空字符串 ""。

**示例 1:**

```c
输入: ["flower","flow","flight"]
输出: "fl"
```

**示例 2:**

```c
输入: ["dog","racecar","car"]
输出: ""
解释: 输入不存在公共前缀。
```

来源：力扣（LeetCode）
链接：[14. Longest Common Prefix](https://leetcode-cn.com/problems/longest-common-prefix)

# 解题思路

本题的思路非常简单，依次遍历每个串的每一位的字符串是否相同。

首先定义一个临时的字符串指针变量，并用第一组的字符串进行初始化，然后逐个比较`result`变量各个字符与各组各个字符是否相等，并用一个计数器变量`j`进行计数，遇到不相等的字符退出循环。最后'\0'字符对字符串进行截断，只保留公共的前缀。

具体代码见解法一。

另外，本题也可以先对字符串进行排序，排序以后有共同字母多的两个字符串会被排到一起，而跟大家相同的字母越少的字符串会被挤到首尾两端，那么如果有共同前缀的话，一定会出现在首尾两端的字符串中，所以我们只需要找首尾字母串的共同前缀即可。

比如**例子1**排序后为 `["flight", "flow", "flower"]`，**例子2**排序后为 `["cat", "dog", "racecar"]`，虽然**例子2**没有共同前缀，但也可以认为共同前缀是空串，且出现在首尾两端的字符串中。由于是按字母顺序排的，而不是按长度，所以首尾字母的长度关系不知道，为了防止溢出错误，我们只遍历而这种较短的那个的长度，找出共同前缀返回即可。

具体代码见解法二。

# 代码

## 解法一

```c
char* longestCommonPrefix(char** strs , int strsSize) 
{
    char* result;         //创建一个返回字符指针变量result
    
    if(strsSize <= 0)   //判断输入一维数组是否大于0，即是否存在这个二维字符串
        return "";
    
    result = strs[0];     //将第一组字符串变量直接赋给result
    for(int i = 1; i < strsSize; i++)
    { 
        
        int j = 0;            //每次都从字符串第一个字符比较
        
        while(strs[i][j] && result[j] == strs[i][j])     //每组一位字符串与result变量进行比较
            j++;
        
        result[j] = '\0'; //比较结束之后截短result
    }
    
    return result;
}
```

## 解法二

```c
//辅助比较函数，取最小值
int min(int a, int b)
{
    if(a > b) return b;
    else return a;
}

//qsort需要传入的函数
int compar_words(const void *p, const void *q)
{
    return strcmp(*(char **)p, *(char **)q);
}


char* longestCommonPrefix(char** strs , int strsSize) 
{
    char* result;                                                          //创建一个临时字符指针变量result
    //int i, j;           
    
    if(strsSize <= 0)                                                      //判断输入一维数组是否大于0，即是否存在这个二维字符串；
        return "";
    
    qsort(strs, strsSize, sizeof(strs[0]), compar_words);                  //对字符串组按字母进行升序排序

    
    result = strs[0];                                                      //将第一组字符串变量直接赋给result；
    
    int i = 0, len = min(strlen(strs[0]), strlen(strs[strsSize - 1]));
    
    while(i < len && strs[0][i] == strs[strsSize - 1][i])                 //比较求得最长公共前缀的长度
    {        
        ++i;
    }
    
    result[i] = '\0';                                                     //将最长公共前缀后面的字符串进行截断
    
    
    return result;
}
```

## 参考资料

- [[LeetCode] Longest Common Prefix 最长共同前缀](https://www.cnblogs.com/grandyang/p/4606926.html)