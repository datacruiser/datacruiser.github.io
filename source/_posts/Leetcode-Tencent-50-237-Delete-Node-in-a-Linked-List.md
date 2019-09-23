---
title: Leetcode Tencent 50 Task 38 237. Delete Node in a Linked List
date: 2019-09-01 15:02:29
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task38。
---

# 描述

请编写一个函数，使其可以删除某个链表中给定的（非末尾）节点，你将只被给定要求被删除的节点。

现有一个链表 -- head = [4,5,1,9]，它可以表示为:

![图片](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2019/01/19/237_example.png)
 

**示例 1:**

```c

输入: head = [4,5,1,9], node = 5
输出: [4,1,9]
解释: 给定你链表中值为 5 的第二个节点，那么在调用了你的函数之后，该链表应变为 4 -> 1 -> 9.
```

**示例 2:**

```c

输入: head = [4,5,1,9], node = 1
输出: [4,5,9]
解释: 给定你链表中值为 1 的第三个节点，那么在调用了你的函数之后，该链表应变为 4 -> 5 -> 9.
```
 

说明:

- 链表至少包含两个节点。
- 链表中所有节点的值都是唯一的。
- 给定的节点为非末尾节点并且一定是链表中的一个有效节点。
- 不要从你的函数中返回任何结果。

来源：力扣（LeetCode）
链接：[237. Delete Node in a Linked List](https://leetcode-cn.com/problems/delete-node-in-a-linked-list)

# 解题思路

这道题与常规的链表节点删除问题有些不同, 常规的操作都是给出一个头指针和待删除节点的值，然后通过遍历链表找到待删除节点，将待删除的节点的前一个节点的`next`指向待删除节点的`next`，然后将节点删除。 

本题仅仅给出一个节点，需要一些非常规的方法。具体思路是这样的，将该节点的后一个节点的值赋值给该节点，然后将待删除节点的后一个节点删除，这样“曲线救国”实现删除当前节点的目的。实际上只是修改了当前节点的值，然后将与当前节点值相同的后一节点删除。具体代码如下：

# 代码

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
void deleteNode(struct ListNode* node) {
    node->val = node->next->val;
    node->next = node->next->next;
}
``` 

