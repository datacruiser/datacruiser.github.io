---
title: Leetcode-19.删除链表的倒数第N个节点
date: 2019-10-27 08:10:21
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 链表
- 双指针
description: Leetcode刷题系列.
---

# 描述

给定一个链表，删除链表的倒数第 n 个节点，并且返回链表的头结点。

**示例：**


```c
给定一个链表: 1->2->3->4->5, 和 n = 2.

当删除了倒数第二个节点后，链表变为 1->2->3->5.
```

**说明：**

给定的 n 保证是有效的。

**进阶：**

你能尝试使用一趟扫描实现吗？

来源：力扣（LeetCode）
链接：[19. Remove Nth Node From End of List](https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list)


# 解题思路

这道题放在中等难度也是有点说不过去，这里讲两个思路，第一个需要两次遍历，第一次遍历先求出链表的长度`len`，然后第二次遍历就知道从头再遍历`len-n`个节点后删除当时遍历到的节点后面的那个节点就可以了。

这里需要注意的是为了防止`Head`本身被删除，最好新建一个虚拟节点`newHead`，然后令`newhead->next=head`，最后返回虚拟节点的`next`。

具体代码见解法一。

本题的进阶是减少一次遍历，那么需要设置双指针，且双指针初始都指向新建的虚拟节点`newHead`，那么让其中一个指针先走`n+1`个节点，这样快慢指针之间就相差`n`个节点了，然后同时移动快慢指针，直到快指针指向了`NULL`，最后将慢指针的下一个节点指向其下下个节点即可。

具体代码见解法二。

# 代码

## 解法一

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */

typedef struct ListNode* List;

int getListLen(List head)
{
    int count = 0;
    
    while(head)
    {
        head = head->next;
        count++;
    }
    
    return count;
}

List removeNthFromEnd(List head, int n)
{
    List newHead = (List)malloc(sizeof(struct ListNode));
    List tmp = newHead;

    newHead->next = head;
    
    int len = getListLen(head);
    
    for (int i = 0; i < len - n; i++)
    {
        tmp = tmp->next;
    }

    //删除len-n次遍历后节点的节点
    tmp->next = tmp->next->next;
        
    List res = newHead->next;
    //free(tmp);
    free(newHead);
    
    return res;  
    
}
```

## 解法二

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
 
typedef struct ListNode* List;

List removeNthFromEnd(List head, int n)
{
    List newHead = (List)malloc(sizeof(struct ListNode));
    newHead->next = head;
    
    List slow = newHead, fast = newHead;
    
   for( int i = 0 ; i < n + 1 ; i ++ )
   {
        fast = fast->next;
    }
    
    while(fast)
    {
        slow = slow->next;
        fast = fast->next;
    }
    
    //List tmp = slow->next;
    slow->next = slow->next->next;
    //free(tmp);
    
    List res = newHead->next;
    free(newHead);
    
    return res;  
    
}
```