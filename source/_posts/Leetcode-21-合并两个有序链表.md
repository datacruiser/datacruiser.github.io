---
title: Leetcode 21. 合并两个有序链表
date: 2019-08-05 17:02:41
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 树
---

# 描述

将两个有序链表合并为一个新的有序链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。 

示例：

输入：1->2->4, 1->3->4
输出：1->1->2->3->4->4

来源：力扣（LeetCode）
链接：[Leetcode 21. 合并两个有序链表](https://leetcode-cn.com/problems/merge-two-sorted-lists)

# 解题思路

本题考察链表，本题的主要思路是新建一个空链表，然后逐个原有序链表元素的大小，把小的接在新建的链表后面，然后被接走数据的那个链表指针后移一位，同时新建的空链表指针也后移一位，直到有一个链表走到了头，此时将另外一个还有剩余元素的链表的所有数据接到新建的链表后面。

最后返回指向接入的链表最小元素的位置，即新建空链表的下一个指针位置。

# 代码


```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */


struct ListNode* mergeTwoLists(struct ListNode* l1, struct ListNode* l2)
{
    struct ListNode *head = (struct ListNode*)malloc(sizeof(struct ListNode));  //新建空链表 并分配空间
    struct ListNode *cur = head; //声明一个辅助链表指针 指向新建的空链表
    
    while(l1 && l2) //传入的有序链表均不为空
    {
        if(l1->val > l2->val)
        {
            cur->next = l2;
            l2 = l2->next;
        }
        else
        {
            cur->next = l1;
            l1 = l1->next;
        }
        cur = cur->next;
    }
    
    cur->next = l1 ? l1:l2; //剩余链表元素拼接
    return head->next; //返回指向接入的链表最小元素的位置，这是辅助链表指针的作用
}
``` 