---
title: Leetcode 腾讯精选50题 No.4 23.合并K个链表
date: 2019-08-05 17:01:54
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
description: DataWhale暑期学习小组-LeetCode刷题第八期Task3。
---
# 描述

合并 k 个排序链表，返回合并后的排序链表。请分析和描述算法的复杂度。

**示例:**

```c
输入:
[
  1->4->5,
  1->3->4,
  2->6
]
输出: 1->1->2->3->4->4->5->6
```


# 解题思路

首先，简单粗暴的办法是将所有的链表逐一遍历，然后保存到一个数组当中，然后将这个数组排序，最后基于排序后的有序数组创建一个有序链表。时间复杂度方面，链表遍历为$O(N)$，稳定的排序需要$O(NlogN)$，从数组创建链表为$O(N)$，最终的时间复杂度为$O(NlogN)$。空间复杂度方面，无论是排序还是从数组创建有序列表，空间复杂度都是$O(N)$，因此最终的空间的复杂度为$O(N)$。

当然，本题肯定有更优的方法，记得在慕课浙江大学《数据结构》的课上有一道课后习题是要求将[两个有序链表序列合并](https://pintia.cn/problem-sets/1134360184290500608/problems/1138764336949059584)，这里应该可以借鉴一下。那么对于本题的求解思路如下：

- 获取链表的个数$k$
- 将合并两个链表的操作执行$k-1$次

从上面的步骤不难看出，由于合并两个链表本身的时间复杂度是$O(n)$，其中$n$是两个链表的总长度，因此把所有合并过程所需的时间加起来我们可以得到合并$k$个的时间复杂度为：
$$O(\sum_{i=1}^{k-1}(i*(\frac{N}{k})+\frac{N}{k})=O(kN)$$

时间复杂度方面，由于合并两个链表只需要开一个链表结构体的指针，且合并多次也不需要重新开这个指针，因此我们可以在$O(1)$的时间复杂度内完成所有合并工作。C语言的实现代码如下：

# 代码

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */

//合并两个有序链表
struct ListNode* mergeTwoLists(struct ListNode* l1, struct ListNode* l2)
{
    struct ListNode *head = (struct ListNode*)malloc(sizeof(struct ListNode));
    struct ListNode *cur = head;
    
    while(l1 && l2)
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
    
    cur->next = l1 ? l1:l2;
    return head->next;
}

struct ListNode* mergeKLists(struct ListNode** lists, int listsSize)
{
	if(listsSize == 0)
		return NULL;
	else if(listsSize == 1)
		return lists[0];
	else 
	{
	   struct ListNode *head = mergeTwoLists(lists[0], lists[1]);
       
	   for (int i = 2; i < listsSize; i++)
       {
           head = mergeTwoLists(head, lists[i]);
       }

       return head;
		
	}
	
}

```

