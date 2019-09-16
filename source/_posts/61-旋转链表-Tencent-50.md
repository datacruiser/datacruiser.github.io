---
title: 61. 旋转链表 Tencent 50
date: 2019-09-16 19:03:28
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 链表
description: DataWhale暑期学习小组-LeetCode刷题第八期Task33。
---

# 描述

给定一个链表，旋转链表，将链表每个节点向右移动 `k` 个位置，其中 `k` 是非负数。

**示例 1:**

```c
输入: 1->2->3->4->5->NULL, k = 2
输出: 4->5->1->2->3->NULL
解释:
向右旋转 1 步: 5->1->2->3->4->NULL
向右旋转 2 步: 4->5->1->2->3->NULL
```

**示例 2:**

```c
输入: 0->1->2->NULL, k = 4
输出: 2->0->1->NULL
解释:
向右旋转 1 步: 2->0->1->NULL
向右旋转 2 步: 1->2->0->NULL
向右旋转 3 步: 0->1->2->NULL
向右旋转 4 步: 2->0->1->NULL
```

来源：力扣（LeetCode）
链接：[61. Rotate List](https://leetcode-cn.com/problems/rotate-list)

# 解题思路

本题需要注意的是`k`有可能大于链表的长度，这个在示例2里面也已经给出来了，所以在求解之前需要获得链表的长度。

然后需要处理极端条件，就是链表长度为0时，直接返回`NULL`。

如果链表长度为`length`，则需要用`k`对`length`取模，取模后的`startIndex`才是需要进行旋转的位置。

`startIndex`确定下来以后采用快慢指针，快指针先走`startIndex`步，然后两个指针一起走，当快指针走到末尾时，慢指针的下一个位置是新的顺序的头结点。

这里先将快指针的`next`指向`head`，相当于先将链表成环，然后将快指针移到慢指针的`next`，最后将慢指针的`next`指向`NULL`，相当于将环打断，最后返回快指针头节点。

示意图如下：

![rotate list](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Rotate%20List.png)

具体代码如下：

# 代码

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */


int getLength(struct ListNode* head)
{
    int count = 0;
    while(head)
    {
        count++;
        head = head->next;
    }
    
    return count;
}

struct ListNode* rotateRight(struct ListNode* head, int k)
{
    if(!head) return NULL;
    
    struct ListNode *rotated = head;
    
    int length = getLength(rotated);
    
    int startIndex = k % length;
    
    struct ListNode *result = head, *slow = head;
    
    for(int i = 0; i < startIndex; i++)
    {
        if(result)
            result = result->next;
    }
    
    if(!result)
        return head;
    
    while(result->next)
    {
        result = result->next;
        slow = slow->next;
    }
    
    result->next = head;
    result = slow->next;
    slow->next = NULL;
    
    return result;
    
  
}
```