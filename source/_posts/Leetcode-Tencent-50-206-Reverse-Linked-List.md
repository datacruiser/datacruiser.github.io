---
title: Leetcode Tencent 50 206. Reverse Linked List
date: 2019-09-01 23:27:03
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
  description: DataWhale暑期学习小组-LeetCode刷题第八期Task36。
---

# 描述

反转一个单链表。

示例:

输入: 1->2->3->4->5->NULL
输出: 5->4->3->2->1->NULL
进阶:
你可以迭代或递归地反转链表。你能否用两种方法解决这道题？

来源：力扣（LeetCode）
链接：[206. Reverse Linked List](https://leetcode-cn.com/problems/reverse-linked-list)

# 解题思路

迭代的思路，创建一个辅助链表`newHead`，初始指向`NULL`节点，然后遍历原链表`head`，将原链表的每个节点依次加到新的辅助链表的前面，同时同步移动辅助链表头节点的指针。具体见下图：

![Reverse Linked List](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Reverse%20Linked%20List.png)

在遍历链表时，将当前节点的`next`指针改为指向前一个元素，也就是反向指向当前节点。但是，因为是单链表，当前节点没有引用其上一个节点，因此必须事先存储其前一个元素。另外，也基于这样的考虑，在更改引用之前，还需要一个临时节点来存储下一个节点。最好返回辅助链表`newHead`的头指针。具体代码见解法一。

递归的思路，看看上图的`STEP 1`，核心的步骤就是将当前节点作为当前节点下一节点的`next`节点，然后为了避免成环，将当前节点指向下一节点的引用打断，以上两个步骤可以通过下面两行代码实现：

```c
head->next->next = head; //将当前节点作为当前节点下一个节点的next节点
head->next = NULL;       //将当前节点指向下一节点的引用打断，不然会形成环
```
详细代码看解法二。


# 代码

## 解法一：迭代解法

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */

struct ListNode* reverseList(struct ListNode* head)
{
    struct ListNode* newHead = NULL;
    while(head)
    {
        struct ListNode* nextTemp = head->next;
        head->next = newHead;
        newHead = head;
        head = nextTemp;
    }
    return newHead;
}

``` 

## 解法二：递归解法

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */

struct ListNode *reverseList(struct ListNode *head)
{
    if (head == NULL || head->next == NULL) 
        return head;

    struct ListNode *newHead = reverseList(head->next);

    //此处注意，因为只有一个节点的时候就返回了，但是返回时，head节点是返回链的上一个节点
    head->next->next = head; //将当前节点作为当前节点下一个节点的next节点
    head->next = NULL;       //将当前节点指向下一节点的引用打断，不然会形成环

    return newHead;
}

``` 

