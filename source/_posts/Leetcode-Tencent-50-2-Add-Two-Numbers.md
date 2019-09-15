---
title: Leetcode Tencent 50 Task 31 2. Add Two Numbers
date: 2019-09-15 15:55:06
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 链表
description: DataWhale暑期学习小组-LeetCode刷题第八期Task31。
---

# 描述

给出两个`非空` 的链表用来表示两个非负的整数。其中，它们各自的位数是按照 `逆序` 的方式存储的，并且它们的每个节点只能存储 `一位` 数字。

如果，我们将这两个数相加起来，则会返回一个新的链表来表示它们的和。

您可以假设除了数字 0 之外，这两个数都不会以 0 开头。

**示例：**

```c
输入：(2 -> 4 -> 3) + (5 -> 6 -> 4)
输出：7 -> 0 -> 8
原因：342 + 465 = 807
```

来源：力扣（LeetCode）
链接：[2. Add Two Numbers](https://leetcode-cn.com/problems/add-two-numbers)

# 解题思路

看到链表的题目通常会想到做两件事情，首先是链表的遍历，然后是新建一个链表头节点。

本题的思路也是如此，就是新建一个链表，然后从头遍历两个输入的链表，每两个数相加，根据相加的结果，添加一个新节点到新链表的 后面。为了避免两个输入链表同时为空，我们新建一个`result`空节点，然后将两个节点相加生成的新节点按顺序加到`result`节点之后，由于`result`节点本身是需要最后指向返回链表的头节点的，因此本身不能改变，为了后续的操作，我们再用一个`current`指针指向`result`链表的最后一个节点。

数据结构准备完毕就可以进行算法的设计和操作了。 

首先让两个链表相加，这题的最低位在链表的开头，一下子让难度降低不少，这样我们在遍历链表的同时可以按从低到高的顺序直接相加。while循环的条件是两个链表中只要有一个不为空或者`carry`有进位就需要继续遍历下去。考虑到链表可能为空，所以在取当前节点值的时候需要判断下链表是否为空，为空则取0，不为空则取节点值。

然后把两个节点值相加，同时还要考虑加上进位`carry`，`carry`的可能取值为0或者1。然后用`sum/10`更新进位`carry`。然后以`sum%10`为值建立一个新的节点，连接到`current`后面，再将`current`移动到下一个节点，即让`current`指针永远指向`result`链表的最后一个节点。

然后更新两个节点，其实就是两个节点如果不为空，则将指针后移一位，这是遍历链表的常规操作。

while循环退出以后，最高位是否有进位这一需要特殊处理的情况也已经在循环当中处理，直接返回`result`即可。具体代码如下：

# 代码

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */


typedef struct ListNode* List;

List addTwoNumbers(List l1, List l2)
{
    List result = (List)malloc(sizeof(struct ListNode));
    result->val = 0;
 
    List current = NULL;
    int carry = 0;
    
    while (l1 || l2 || carry)
    {
        if(current == NULL)
        {
            current = result;
        }
        else
        {
            current->next = (List)malloc(sizeof(struct ListNode));  //    如果current不指向NULL新建节点
            current->next->val = 0;                                 
            current = current->next;
        }
        int val1 = l1 ? l1->val : 0;
        int val2 = l2 ? l2->val : 0;
        int sum =val1 + val2 + carry;
        carry = sum / 10;                                           //    更新进位carry
        current->val = sum % 10;                                     
        current->next = NULL;
   
        if(l1)
            l1 = l1->next;
        if(l2)
            l2 = l2->next;
    }
    
    return result;
}
```