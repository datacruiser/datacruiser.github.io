---
title: Leetcode Tencent 50 557. Reverse Words in a String III
date: 2019-09-08 19:43:06
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 字符串
description: DataWhale暑期学习小组-LeetCode刷题第八期Taskxx。
---

# 描述

给定一个字符串，你需要反转字符串中每个单词的字符顺序，同时仍保留空格和单词的初始顺序。

**示例 1:**

```c
输入: "Let's take LeetCode contest"
输出: "s'teL ekat edoCteeL tsetnoc" 
```

**注意：在字符串中，每个单词由单个空格分隔，并且字符串中不会有任何额外的空格。**

来源：力扣（LeetCode）
链接：[557. Reverse Words in a String III](https://leetcode-cn.com/problems/reverse-words-in-a-string-iii)

# 解题思路

考虑到本题最后的条件，就是在字符串当中，每个单词由单个空格分隔，并且字符串中不会有任何额外的空格，这个条件使得这道题的难度降低不少。

主要的思路是遍历字符串数组，遇到空格就将空格前面的[单词进行反转](http://datacruiser.io/2019/09/08/Leetcode-Tencent-50-344-Reverse-String/)，一遍遍历以后只剩下最后一个单词未反转。出了循环以后单独再遍历一下最后一个单词，然后直接返回原数组。具体代码如下：

# 代码

```c
/* 单个单词的反转，注意输入的参数
s: 字符串数组的头指针
sSize: 字符串数组的长度
*/
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



char * reverseWords(char * s)
{
    int length = strlen(s);                    //获取字符串的长度
    int index = 0;                             //记录空格所在位置后一个元素的下标，用于表示输入字符串当中单个单词所在位置
    
    for(int i = 0; i < length; i++)
    {
        if(s[i] == ' ')
        {
            reverseString(s + index, i - index);
            index = i + 1;                     //更新下一个单词起始下标
            //break;
        }
    }
    reverseString(s + index,  length - index); //退出循环后对最后一个单词进行反转
   
    return s;
}

```
