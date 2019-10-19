---
title: Leetcode-234. 回文链表
date: 2019-10-19 14:31:53
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 链表
- 快慢指针 
description: Leetcode刷题系列.
---
# 描述

请判断一个链表是否为回文链表。

**示例 1:**

```c
输入: 1->2
输出: false
```

**示例 2:**

```c
输入: 1->2->2->1
输出: true
```

**进阶：**

你能否用 O(n) 时间复杂度和 O(1) 空间复杂度解决此题？

来源：力扣（LeetCode）
链接：[234. Palindrome Linked List](https://leetcode-cn.com/problems/palindrome-linked-list)

# 解题思路

本题的主要思路是采用快慢指针, 快指针一次走两步, 慢指针一次走一步, 这样当快指针走到链表结尾的时候，慢指针正好走到中间。然后将慢指针走过部分的链表进行反转，单链表的反转可以参考这一题[206. Reverse Linked List](http://datacruiser.io/2019/09/01/Leetcode-Tencent-50-206-Reverse-Linked-List/). 

在链表反转以后需要对原链表的奇偶性做一个判断，如果是奇数，在慢指针走过的那个中间元素就不需要进行判断，移动反转后的链表指针一位，然后进行逐个判断元素是否相等。

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

bool isPalindrome(struct ListNode* head)
{
    //链表为空或者链表只有一个节点，返回true
    if(!head || !head->next) return true;
    
    //如果只有两个节点，则比较两个节点是否相等
    if(head->next && !head->next->next)
    {
        if(head->val == head->next->val)
            return true;
        else
            return false;
    }
    
    //链表长度
    int len = getLength(head);
    
    //快慢指针初始化
    struct ListNode *slow, *fast;
    slow = head->next;
    fast = head->next->next;
    
    //快慢指针分别移动到中部和链表尾部
    while(fast && fast->next)
    {
        slow = slow->next;
        fast = fast->next->next;
    }
    
    //slow之前部分的链表反转，fisrtHalfHead节点是反转以后前半部分链表的头
    struct ListNode *firstHalfHead = NULL;
    
    while(head != slow)
    {
        struct ListNode *nextTmp = head->next;
        head->next = firstHalfHead;
        firstHalfHead = head;
        head = nextTmp;
    }
    
    //若链表长度为奇数，则舍弃中间结点
    if(len % 2 == 1)
    {
        slow = slow->next;
    }
    
    //分别从反转后的链表的头以及原链表的中间开始遍历比较
    while(firstHalfHead && slow)
    {
        if(firstHalfHead->val != slow->val)
        {
            return false;
        }
        
        firstHalfHead = firstHalfHead->next;
        slow = slow->next;
    }
    
    return true;
    
}
```




