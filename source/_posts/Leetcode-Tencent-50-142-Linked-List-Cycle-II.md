---
title: Leetcode Tencent 50 Task35 142. Linked List Cycle II
date: 2019-09-07 20:00:44
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 链表
description: DataWhale暑期学习小组-LeetCode刷题第八期Task35。
---

# 描述

给定一个链表，返回链表开始入环的第一个节点。 如果链表无环，则返回 `null`。

为了表示给定链表中的环，我们使用整数 pos 来表示链表尾连接到链表中的位置（索引从 0 开始）。 如果 `pos` 是 `-1`，则在该链表中没有环。

说明：不允许修改给定的链表。

 

**示例 1：**

```c
输入：head = [3,2,0,-4], pos = 1
输出：tail connects to node index 1
解释：链表中有一个环，其尾部连接到第二个节点。
```

![1](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist.png)

**示例 2：**

```c

输入：head = [1,2], pos = 0
输出：tail connects to node index 0
解释：链表中有一个环，其尾部连接到第一个节点。
```

![2](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist_test2.png)

**示例 3：**

```c
输入：head = [1], pos = -1
输出：no cycle
解释：链表中没有环。
```

![3](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist_test3.png)


进阶：
你是否可以不用额外空间解决此题？

来源：力扣（LeetCode）
链接：[142. Linked List Cycle II](https://leetcode-cn.com/problems/linked-list-cycle-ii)




# 解题思路

这道题总体上的思路和[141. Linked List Cycle](http://datacruiser.io/2019/09/07/Leetcode-Tencent-50-141-Linked-List-Cycle/)这道题类似，也需要使用快慢指针的方法。

起初，我想当然的以为快慢指针第一次相遇的节点就是环开始的节点，直接将代码修改如下提交，结果有部分测试用例无法通过。

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


struct ListNode *detectCycle(struct ListNode *head) {
    List slow = head;
    List fast = head;
    while(fast && fast->next)
    {
        slow = slow->next;
        fast = fast->next->next;
        if(slow == fast)
            return slow;
    }
    return NULL;
}
```

后来在图上画了一下，发现快慢指针相遇只能说明一定有环，但是这个相遇的节点并不一定就是环开始的那个节点。

![示意图](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Linked%20Cycle%20II.png)

从上面的示意图当中可以看到，环开始的节点是3，而快慢两个指针第一次相遇的节点是7，而且我们发现从`head`到环开始的节点的距离与快慢指针第一次相遇的节点到环开始的节点距离相等，这个不是图示举例的巧合，可以严格地进行证明。按照图示当中的符号，根据慢指针一次移动1步，快指针一次移动2步，我们有下面这个等式：
$$2(F+C)=F+C+B+C$$

于是有$F=B$

这样解题思路就有了，在快慢指针第一次相遇以后跳出循环，然后将慢指针归位到`Head`，然后逐一移动快慢指针，此时两者都是一次移动1步，他们再次相遇的节点就是环开始的节。

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

typedef struct ListNode * PtrToListNode;
typedef PtrToListNode List;


List detectCycle(List head) 
{
    List slow = head;
    List fast = head;
    while(fast && fast->next)
    {
        slow = slow->next;
        fast = fast->next->next;
        if(slow == fast)
        {
            break;
        }
            
    }
    if(!fast || !fast->next) 
    {
        return NULL;
    }
        
    slow = head;
    while(true)
    {
        if(slow == fast)
        {
            return fast;
        }
            
        slow = slow->next;
        fast = fast->next;
    }
    return NULL;
}
```