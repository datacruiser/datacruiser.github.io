---
title: Leetcode Tencent 50 Task 34 141. Linked List Cycle
date: 2019-09-07 14:10:51
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 链表
description: DataWhale暑期学习小组-LeetCode刷题第八期Task34。
---

# 描述

给定一个链表，判断链表中是否有环。

为了表示给定链表中的环，我们使用整数 `pos` 来表示链表尾连接到链表中的位置（索引从 0 开始）。 如果 `pos` 是` -1`，则在该链表中没有环。

 

**示例 1：**

```c

输入：head = [3,2,0,-4], pos = 1
输出：true
解释：链表中有一个环，其尾部连接到第二个节点。
```

![1](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist.png)

**示例 2：**

```c

输入：head = [1,2], pos = 0
输出：true
解释：链表中有一个环，其尾部连接到第一个节点。
```

![2](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist_test2.png)

**示例 3：**

```c

输入：head = [1], pos = -1
输出：false
解释：链表中没有环。
```

![3](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist_test3.png)
 

**进阶：**

你能用 O(1)（即，常量）内存解决此问题吗？

来源：力扣（LeetCode）
链接：[141. Linked List Cycle](https://leetcode-cn.com/problems/linked-list-cycle)

# 解题思路

这道题采用的是快慢指针的思路，初始化两个指向传入链表的头节点，然后慢指针一次移动一个节点`slow = slow->next`，快指针一次移动两个节点`fast = fast->next->next`，如果一个链表有环，那么这两个指针必定会有指向同一个节点的时候。可以以在田径场上面两个速度不同的运动员为例，一个快，一个慢，不管这两个人初始位置如何，如果两人一直跑下去，总有速度快的运动员超过速度慢的运动员的时候，那个时候也就是在一个链表环里面快慢指针指向同一个节点的时候，此时直接返回`true`，跳出循环。

如果链表里面没有环，那么最终快指针也会移动到链表的结尾，在退出循环后返回`false`。这样子，也能够在$O(1)$的空间复杂度解决这个问题，具体代码如下：

# 代码

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
typedef struct ListNode * PtrToListNode;
typedef PtrToListNode List;

bool hasCycle(struct ListNode *head) 
{
    List slow = head;
    List fast = head;
    while(fast && fast->next)
    {
        slow = slow->next;
        fast = fast->next->next;
        if(slow == fast)
            return true;
    }
    return false;
    
}
```