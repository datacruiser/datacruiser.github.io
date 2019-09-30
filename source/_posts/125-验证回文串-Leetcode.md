---
title: 125.验证回文串 Leetcode
date: 2019-09-30 13:23:03
categories: Leetcode
tags:
- 数据结构
- 算法
- C语言
- 字符串 
description: LeetCode刷题系列。
---

# 描述

给定一个字符串，验证它是否是回文串，只考虑字母和数字字符，可以忽略字母的大小写。

说明：本题中，我们将空字符串定义为有效的回文串。

**示例 1:**

```c
输入: "A man, a plan, a canal: Panama"
输出: true
```

**示例 2:**

```c
输入: "race a car"
输出: false
```

来源：力扣（LeetCode）
链接：[125. Valid Palindrome](https://leetcode-cn.com/problems/valid-palindrome)

# 解题思路

简单题通常的解法都是简单粗暴，见招拆招。

回文串仿佛是各种题目当中屡试不爽，本题依然也是验证回文串，不过要求比较简化。主要有以下两点：

- 只考虑字母和数字字符，其它字符统统忽略 
- 字母的大小写也忽略

为了满足以上两点要求，我们对输入的字符串做一些处理，第一步是过滤字符，将非字母和数字字符过滤掉，通过以下函数实现：

```c
char* filter(char* s)
{
    int len = strlen(s);
    int index = 0;
    
    for(int i = 0; i < len; i++)
    {
        if((s[i]>='a' && s[i] <= 'z') || (s[i]>='A' && s[i] <= 'Z') || (s[i]>='0' && s[i] <= '9') )
        //if(isalnum(s[i])) C语言内置的用于判断是否字母和数字字符的函数
        {
            s[index++] = s[i];          
        }
    }
    
    s[index] = '\0'; //末尾休止符
    
    return s;
}
```

需要注意的是，这里不需要再开列新的字符串空间复制字符再返回，可以直接对原字符串进行修改，然后返回。

返回以后的字符串再进行大小写转化，将所有的小写字符转化为大写字符，通过以下函数实现：

```c
char* transfer(char* s)
{
    int len = strlen(s);
    
    for(int i = 0; i < len; i++)
    {
        if(s[i] >= 'a' && s[i] <= 'z')
        {
            s[i] += 'A' - 'a';
        }
    }
    
    return s;
}
```

最后，在主函数当中新建一个`char*`指针变量`tmp`，需要注意的是在使用双指针法判断是否回文串的时候，`right`应该为`strlen(tmp) - 1`，而不是原字符串的`strlen(s) - 1`。

具体代码如下：

# 代码


```c
char* filter(char* s)
{
    int len = strlen(s);
    int index = 0;
    
    for(int i = 0; i < len; i++)
    {
        if((s[i]>='a' && s[i] <= 'z') || (s[i]>='A' && s[i] <= 'Z') || (s[i]>='0' && s[i] <= '9') )
        //if(isalnum(s[i]))
        {
            s[index++] = s[i];          
        }
    }
    
    s[index] = '\0';
    
    return s;
}

char* transfer(char* s)
{
    int len = strlen(s);
    
    for(int i = 0; i < len; i++)
    {
        if(s[i] >= 'a' && s[i] <= 'z')
        {
            s[i] += 'A' - 'a';
        }
    }
    
    return s;
}

bool isPalindrome(char * s)
{
    char* tmp = transfer(filter(s));
    
    int left  = 0, right = strlen(tmp) - 1;
    
    while(left <  right)
    {
        if(tmp[left] !=  tmp[right])
        {
            return false;
        }
        
        left++;
        right--;
    }
    
    return true;
}

```
