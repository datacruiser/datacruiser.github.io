---
title: Leetcode Tencent 50 160. Intersection of Two Linked Lists
date: 2019-09-07 15:11:30
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 链表
description: DataWhale暑期学习小组-LeetCode刷题第八期Taskxx。
---

# 描述

编写一个程序，找到两个单链表相交的起始节点。

如下面的两个链表：

![例子](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/14/160_statement.png)

在节点 `c1` 开始相交。

 

**示例 1：**

![1](https://assets.leetcode.com/uploads/2018/12/13/160_example_1.png)

```c
输入：intersectVal = 8, listA = [4,1,8,4,5], listB = [5,0,1,8,4,5], skipA = 2, skipB = 3
输出：Reference of the node with value = 8
输入解释：相交节点的值为 8 （注意，如果两个列表相交则不能为 0）。从各自的表头开始算起，链表 A 为 [4,1,8,4,5]，链表 B 为 [5,0,1,8,4,5]。在 A 中，相交节点前有 2 个节点；在 B 中，相交节点前有 3 个节点。
```

**示例 2：**

![2](https://assets.leetcode.com/uploads/2018/12/13/160_example_2.png)

```c
输入：intersectVal = 2, listA = [0,9,1,2,4], listB = [3,2,4], skipA = 3, skipB = 1
输出：Reference of the node with value = 2
输入解释：相交节点的值为 2 （注意，如果两个列表相交则不能为 0）。从各自的表头开始算起，链表 A 为 [0,9,1,2,4]，链表 B 为 [3,2,4]。在 A 中，相交节点前有 3 个节点；在 B 中，相交节点前有 1 个节点。
```

**示例 3：**

![3](https://assets.leetcode.com/uploads/2018/12/13/160_example_3.png)

```c
输入：intersectVal = 0, listA = [2,6,4], listB = [1,5], skipA = 3, skipB = 2
输出：null
输入解释：从各自的表头开始算起，链表 A 为 [2,6,4]，链表 B 为 [1,5]。由于这两个链表不相交，所以 intersectVal 必须为 0，而 skipA 和 skipB 可以是任意值。
解释：这两个链表不相交，因此返回 null。
```

**注意：**

- 如果两个链表没有交点，返回 `null`.
- 在返回结果后，两个链表仍须保持原有的结构。
- 可假定整个链表结构中没有循环。
- 程序尽量满足 $O(n)$ 时间复杂度，且仅用 $O(1)$ 内存。


来源：力扣（LeetCode）
链接：[160. Intersection of Two Linked Lists](https://leetcode-cn.com/problems/intersection-of-two-linked-lists)

# 解题思路

本题的解题关键在于确定两个链表的长度。

首先，对于两个长度相等的链表，无论他们是否相交，遍历链表然后逐一进行比较，如果遇到两个相同的节点就返回当前节点，此时的节点即为相交的节点，如果遍历到链表尾部未遇到两个相同的节点，则返回`NULL`，此时两个链表不相交。

其次，对于两个长度不相等的链表，就不能直接进行逐一从头开始遍历了。因为，如果两个链表有交点，那么交点以后的链表长度应该是相同的，那么如果从链表头指针开始遍历并逐一进行比较必然无法找到两个相同的节点。这里需要做一些变通。

假设链表A的长度为`lengthA`，链表B的长度为`lengthB`，且两者不相等，那么长的链表先行遍历$|lengthA - lengthB|$个节点，后面先行遍历后的长链表和未遍历的短链表长度就又相同了，然后就可以用对待两个等长链表的方法来求解本题。

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
 
 
//将链表节点的指针类型定义别名
typedef struct ListNode* List;

//定义返回链表长度的辅助函数
int getLength(List L)
{
    int cnt = 0;
    while(L)
    {
        L =  L->next;
        cnt++;
    }
    
    return cnt;
}


List getIntersectionNode(List headA, List headB) 
{
    List lA = headA;           //定义两个链表节点指针
    List lB = headB;
    
    if(!lA || !lB)             //如果其中一个为空则直接返回NULL
        return NULL;
    
    int lengthA = getLength(lA); //获取两个链表的长度
    int lengthB = getLength(lB);
    
    if(lengthA > lengthB)        //让长链表先行遍历|lengthA - lengthB|个节点
    {
        for(int i = 0; i < lengthA - lengthB; i++)
        {
            lA = lA->next;
        }
    }
    else
    {
        for(int i = 0; i < lengthB - lengthA; i++)
        {
            lB = lB->next;
        }            
    }
    while(lA && lB)               //等长链表逐一遍历比较，寻找交叉节点
    {
        if(lA == lB)
            return lA;
        else
        {
            lA = lA->next;
            lB = lB->next;
        }
    }
    return NULL;
}
```