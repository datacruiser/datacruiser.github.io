---
title: Leetcode-739. 每日温度
date: 2019-10-21 09:35:43
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 单调栈 
- 数组
description: Leetcode刷题系列.
---
# 描述

根据每日 `气温 `列表，请重新生成一个列表，对应位置的输入是你需要再等待多久温度才会升高超过该日的天数。如果之后都不会升高，请在该位置用 `0 `来代替。

例如，给定一个列表 `temperatures = [73, 74, 75, 71, 69, 72, 76, 73]`，你的输出应该是 `[1, 1, 4, 2, 1, 1, 0, 0]`。

提示：气温 列表长度的范围是 `[1, 30000]`。每个气温的值的均为华氏度，都是在` [30, 100]` 范围内的整数。

来源：力扣（LeetCode）
链接：[739. Daily Temperatures](https://leetcode-cn.com/problems/daily-temperatures)


# 解题思路

简单粗暴的解题思路，需要两重遍历，第一重从`i`开始遍历，第二重从`j=i+1`开始遍历，第二重遍历的时候每个数都往后看，直到找到比它大的数，找到以后记录`j-i`，然后跳出即可。具体代码见解法一。

当然，这种暴力解法在Leetcode上面通常是会超时的……

华丽丽地超时了：

```c
35 / 37 个通过测试用例
状态：超出时间限制
提交时间：0 分钟之前
```

然后看了大神们的解法，又学到了，原来这道题要使用[递减栈](https://blog.csdn.net/liujian20150808/article/details/50752861)。

递减栈又叫单调栈，其定义如下：

单调栈就是**栈内元素单调递增或者递减**的栈，单调栈只能够在栈顶操作。

从数组的角度，单调栈具有如下性质：

- 单调栈里的元素具有单调性
- 元素加入栈前，会在栈顶端把破坏栈单调性的元素都删除
- 使用单调栈可以找到元素向左遍历第一个比他小的元素，也可以找到元素向左遍历第一个比他大的元素
	- 当单调栈中的元素是单调递增的时候，根据上面我们从数组的角度阐述单调栈的性质的叙述，可以得出：
	 	- 当a > b 时，则将元素a插入栈顶，新的栈顶则为a
	 	- 当a < b 时，则将从当前栈顶位置向前查找（边查找，栈顶元素边出栈），停止查找，将元素a插入栈顶（在当前找到的数之后，即此时元素a找到了自己的“位置”）
	- 当单调栈中的元素是单调递减的时候，则有：
	  	- 当a < b 时，则将元素a插入栈顶，新的栈顶则为a
	  	- 当a > b 时，则将从当前栈顶位置向前查找（边查找，栈顶元素边出栈），直到找到第一个比a大的数，停止查找，将元素a插入栈顶（在当前找到的数之后，即此时元素a找到了自己的“位置”）

本题采用单调递减栈，栈里只有递减元素，首先遍历数组，如果栈不为空，且当前数字大于栈顶元素，那么如果直接入栈的话就不是递减栈了，所以我们取出栈顶元素，那么由于当前数字大于栈顶元素的数字，而且一定是第一个大雨栈顶元素的数，那么我们直接求出下标差就是二者的距离了，然后继续看新的栈顶元素，直到当前数字小于等于栈顶元素停止，然后将数字入栈，这样就可以一直保持递减栈，且每个数字和第一个大于它的数的距离也可以算出来了，具体代码见解法二：

# 代码

## 解法一

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* dailyTemperatures(int* T, int TSize, int* returnSize)
{
    int *res = (int *)malloc(sizeof(int) * TSize);
    //res数组初始化
    for(int i = 0; i < TSize; i++)
        res[i] = 0;
    
    *returnSize = TSize;
    
    for(int i = 0; i < TSize; i++)
    {
        int current = T[i];
        if(current < 100)
        {
            for(int j = i + 1; j < TSize; j++)
            {
                if(T[j] > current)
                {
                    res[i] = j - i;
                    break;
                }
            }
        }
    }
    
    return res;
    
}
```

## 解法二

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
#define OK 0
#define NULL 0

typedef int DataType;
typedef struct node{
    DataType data;
    struct node * next;
}Stack;

//创建栈，此时栈中没有任何元素
Stack* CreateStack()
{
    Stack *stack = (Stack*)malloc(sizeof(Stack));
    if(NULL != stack)
    {
       stack->next = NULL;
       return stack;
    }
    return NULL;
}

//撤销栈
void DestoryStack(Stack* stack)
{
    free(stack);
}
 
int IsEmpty(Stack* stack)
{
    return (stack->next == 0);
}
 
//入栈，成功返回1，失败返回0， 把元素 data 存入 栈 stack 中
int PushStack(Stack* stack, DataType data)
{
    Stack* newst = (Stack*)malloc(sizeof(Stack));
    if(NULL != newst)
    {
        newst->data = data;
        newst->next = stack->next;  //s->next = NULL;
        stack->next = newst;
        return 1;
    }
    return 0;
}
 
/*
    出栈，成功返回1，失败返回0，出栈不取出元素值，只是删除栈顶元素。
    如出栈要实现，取出元素值，并释放空间，可结合取栈顶元素函数做修改，这里不再给出。
 */
 
int PopStack(Stack* stack)
{
    Stack* tmpst;
    if(!IsEmpty(stack))
    {
        tmpst = stack->next;
        stack->next = tmpst->next;
        free(tmpst);
        return 1;
    }
    return 0;
}

int PopStackReturn(Stack* stack, DataType *data)
{
    Stack* tmpst;
    if(!IsEmpty(stack))
    {
        tmpst = stack->next;
        stack->next = tmpst->next;
        *data = tmpst->data;
        free(tmpst);
        return 1;
    }
    return 0;
}
 
//取栈顶元素，仅取出栈顶元素的值，取出之后，该元素，任然存在栈中。成功返回元素值，失败输出提示信息，并返回 -1
DataType GetTopElement(Stack* stack)
{
    if(!IsEmpty(stack))
    {
        return stack->next->data;
    }
    return -1;
}


int* dailyTemperatures(int* T, int TSize, int* returnSize) 
{
    int i;
    int temp;
    int topData;
    int ret;
    int *NewT = malloc(TSize * sizeof(int));
    if (NewT == NULL) 
    {
        printf("malloc fail");
        return NULL;
    }
    memset(NewT, 0, TSize * sizeof(int));

    Stack* stack = CreateStack();
    if (stack == NULL) 
    {
        printf("CreateStack fail");
        return NULL;
    }
    for (i = 0; i < TSize; i++) 
    {
        while (!IsEmpty(stack) && (T[i] > T[GetTopElement(stack)])) 
        {
            temp = GetTopElement(stack);
            NewT[temp] = i - temp;
            PopStack(stack);
        }
        PushStack(stack, i);
    }
    
    DestoryStack(stack);
    *returnSize = TSize;
    return NewT;
}
```

# 参考

- [[LeetCode] Daily Temperatures 日常温度](https://www.cnblogs.com/grandyang/p/8097513.html)
- [单调栈的介绍以及一些基本性质](https://blog.csdn.net/liujian20150808/article/details/50752861)
- LeetCode他人解法
