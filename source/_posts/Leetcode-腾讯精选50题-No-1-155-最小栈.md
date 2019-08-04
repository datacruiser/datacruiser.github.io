---
title: Leetcode 腾讯精选50题 No.1 155 最小栈
date: 2019-08-03 19:25:03
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
description: DataWhale暑期学习小组-LeetCode刷题第八期Task0。
---



# 描述

设计一个支持 push，pop，top 操作，并能在常数时间内检索到最小元素的栈。

- push(x) -- 将元素 x 推入栈中。
- pop() -- 删除栈顶的元素。
- top() -- 获取栈顶元素。
- getMin() -- 检索栈中的最小元素。
示例:


```c
MinStack minStack = new MinStack();
minStack.push(-2);
minStack.push(0);
minStack.push(-3);
minStack.getMin();   --> 返回 -3.
minStack.pop();
minStack.top();      --> 返回 0.
minStack.getMin();   --> 返回 -2.
```

# 解题思路

栈（Stack）是先进后出（First in-Last out）的数据结构，本身压栈（Push）、出栈（Pop）的时间复杂度都是O(1)，不过本题还要求寻找栈中最小值的时间复杂度也是O(1)，那么就不能用简单的排序过滤实现了。

这里可以考虑申请两个栈，一个用于正常的存储数据(data数组)，另一个用于存储最小值(min数组)，并设置相应两个栈的栈顶指针，对于压栈和出栈的时间复杂度当然是O(1)，但难点在getMin获取栈的最小值，若使用一般的求数组的最小值算法，其时间复杂度为O(n)，并不符合题意，需要做一些特别的处理。

对于用于存储data栈的最小值的min数组，当push数据进data数组的同时，将数据与min数组的栈顶元素进行比较，若大于min的栈顶元素则不压入min数组内，仅压入data数组，否则同时压入min数组中，这样getMin()就直接从min数组中的栈顶读取，时间复杂度为O(1)。 

# 代码

```c

typedef struct SNode * PtrToSNode;

struct SNode{
    int data[20000];
    int min[20000];
    int datatop;
    int mintop;
};
typedef PtrToSNode MinStack;

MinStack minStackCreate() 
{
    MinStack stack = (MinStack)malloc(sizeof(struct SNode));
    stack->datatop = -1;//栈顶初始化，其实是初始化数组下标
    stack->mintop = -1;
    memset(stack->data, 0, 20000);//将data数组填充为0
    memset(stack->min, 0 ,20000);
    return stack;
}

void minStackPush(MinStack stack, int element) 
{
    if(stack->datatop < 19999)
    {
        stack->datatop++;
        stack->data[stack->datatop] = element;
        if(stack->mintop == -1 || element <= stack->min[stack->mintop])//判断min栈为空或者栈顶元素大于将被压入的数据时则同时压入min栈
        {
            stack->mintop++;
            stack->min[stack->mintop] = element;
        }
    }
    else
    {
        return;
    }
}

void minStackPop(MinStack stack) 
{

    int temp;
    if(stack->datatop == -1)
    {
        return;
    }
    temp = stack->data[stack->datatop];//用临时变量保存data数组栈顶元素，后面与min数组的栈顶元素进行比较
    stack->datatop--;
    if(temp == stack->min[stack->mintop])//删除data栈顶元素时，同时比较data栈顶元素值是否等于min数组的栈顶元素值，若相等则min数组出栈
    {
       stack->mintop--;
    }
}

int minStackTop(MinStack stack) 
{

    return stack->data[stack->datatop];
}

int minStackGetMin(MinStack stack) 
{

    return stack->min[stack->mintop];
}

void minStackFree(MinStack stack) 
{
    free(stack);
}

```














