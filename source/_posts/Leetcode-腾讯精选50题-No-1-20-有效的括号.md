---
title: Leetcode 腾讯精选50题 No.2 20 有效的括号
date: 2019-08-04 11:11:17
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
description: DataWhale暑期学习小组-LeetCode刷题第八期Task1。
---

# 描述

给定一个只包括 `'('`，`')'`，`'{'`，`'}'`，`'['`，`']'` 的字符串，判断字符串是否有效。

有效字符串需满足：

左括号必须用相同类型的右括号闭合。
左括号必须以正确的顺序闭合。
注意空字符串可被认为是有效字符串。

**示例1**：


```c
输入: "()"
输出: true
```

**示例2**：


```c
输入: "()[]{}"
输出: true
```

**示例3**：


```c
输入: "(]"
输出: false
```


**示例4**：


```c
输入: "([)]"
输出: false
```

**示例5**：


```c
输入: "{[]}"
输出: true
```

# 解题思路

本题非常适合用栈（Stack）这种数据结构来求解。根据题意，我们发现如果是有效括号的话那么左右括号一定成对出现，并且括号中间的括号也可以成对。举个例子：“{[()]}”，最中间的是()，他们可以相互抵消，抵消以后的[]也可以抵消，最后最外面的{}也是成对的。

我们可以利用栈的特性，首先判断字符串是否为空，如果为空，返回true，如果不为空则遍历整个字符串，遇到左括号，入栈，遇到右括号，检查栈顶是否是左括号，如果是，那么就将栈顶出栈，右括号也不入栈，最后再判断栈是否为空。因为如果字符串的是合法的，那么最终栈为空，否则栈不为空。

总结起来，步骤如下：

- 判断字符串是否为空，空着返回true
- 遍历字符串
	- 遇到左括号，压栈
	- 遇到右括号：
		- 当前栈为空，返回false
		- 当前右括号对应的左括号与栈顶元素不想等，返回false
- 循环结束后判断栈是否为空，不为空返回false

# 代码

```c

typedef struct CharNode * PtrToCharNode;

struct CharNode{
    char data[100000];
    int top;//栈顶指针
};

typedef PtrToCharNode Stack;

//入栈，为了简洁，未判断栈是否已满
bool push(Stack s,char x){
    s->top++;
    s->data[s->top] =x ;
    return true;
}

//出栈，为了简洁，未判断栈是否为空
char pop(Stack s){
    return (s->data[(s->top)--]);
}

bool isValid(char* s) {
    Stack p = (Stack)malloc(sizeof(struct CharNode)); //分配栈的内存
    p->top = 0;
    //判断字符串是否为空
    if(strlen(s) == 0)
    	return true;
    //将首字符入栈
    push(p, s[0]);
    //遍历字符串
    for(int i=1; i<strlen(s); i++)
    {
        if(p->data[p->top] == '[')//判断中括号
        {
            if(s[i] == ']') 
            	pop(p);
            else 
            	push(p, s[i]);
        }
        else if(p->data[p->top] == '(')//判断小括号
        {
            if(s[i]==')')
            	pop(p);
            else 
            	push(p, s[i]);
        }
        else if(p->data[p->top]=='{')//判断大括号
        {
            if(s[i]=='}')
            	pop(p);
            else 
            	push(p,s[i]);
        }
        else 
        	push(p,s[i]);
    }
    if(p->top == 0) //判断最后栈是否为空
    	return true;
    else 
    	return false;

}
```
