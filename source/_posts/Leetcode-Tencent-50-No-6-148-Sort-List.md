---
title: Leetcode Tencent 50 No.6 148. Sort List
date: 2019-08-07 15:19:27
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
description: DataWhale暑期学习小组-LeetCode刷题第八期Task5。
---
# 描述

在 $O(n log n)$ 时间复杂度和常数级空间复杂度下，对链表进行排序。

**示例 1:**


```c
输入: 4->2->1->3
输出: 1->2->3->4
```


**示例 2:**

```c
输入: -1->5->3->4->0
输出: -1->0->3->4->5
```



# 解题思路

首先，回顾一下常见排序算法及各自的时间、空间复杂度：

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/Big-O%2BAlgorithm%2BComplexity%2BCheat%2BSheet%2B%2528Know%2BThy%2BComplexities%2529%2Bericdrowell%2B2019-08-07%2B19-48-29.png)

根据题意，本题要求时间复杂度$O(nlgn)$，因此可以排除选择排序和插入排序，而冒泡排序本身不适合单链表，也可以一并排除，剩下来主要有归并排序、快速排序和堆排序。其中堆排序需要新开一个数组转存数据来构建堆，空间复杂度为$O(n)$，也不符合题意要求。

归并排序在对数组进行排序时，需要一个临时数组来存储所有元素，空间复杂度为$O(n)$。但是利用归并算法对单链表进行排序时，可以通过next指针来记录元素的相对位置，因此时间复杂度也为$O(1)$。 

## 快速排序

快速排序的主要思路如下：

- 对于一个数组A，选定一个基准元素
- 遍历剩余元素，并与基准元素进行比较
- 按比较结果的大小将剩余元素分成两组，一组全部比基准元素大，记为B，另外一组全部基准元素小，记为S
- 将基准元素的位置挪到比它小的那组元素的最后
- 分别对B和S重复以上4个步骤，直到所有的元素都已经排序成功

我们来分析下算法的时间复杂度，由于单链表只能从链表头节点向后遍历，必须选择头节点作为基准元素。这样第二步的遍历操作的时间复杂度就是$O(n)$，而第三、第四步会将链表划分为$lgn$段，因此总体的时间复杂度为$O(nlgn)$。

示意图如下：

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/quick-sort-part-1.png)

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/quick-sort-part-2.png)

**图片来自[www.w3resource.com](https://www.w3resource.com/csharp-exercises/searching-and-sorting-algorithm/searching-and-sorting-algorithm-exercise-9.php)**

## 归并排序

和快排一样，归并排序也是基于分治的思想，但是不同的是，分完了以后后面还需要从底层开始向上合并，主要思想如下：

- 遍历链表L，找到链表中间节点将链表分成两部分L1，L2
- 分别对L1、L2重复进行遍历并分组，直到每个链表近含有一个元素为止
- 然后调用合并两个有序链表的函数将链表两两合并，直到全部完成为止

示意图如下：

![归并排序](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/Merge-Sort-e1546955959370.jpg)

链表的归并排序除了找到中间节点的操作必须遍历链表外，其它操作与数组的归并排序基本相同，而对于中间节点的寻找也是关键所在。可以采用slow，fast遍历的方法来确定链表的中间节点。简单说就是slow指针每次移1位，fast指针每次移2位，到了fast指向Null的时候，slow的位置就是链表的中间节点。下面是一个寻找7个元素链表中间节点的示意图：

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/IMG_0373.HEIC%202019-08-07%2020-59-25.png)

接下来是以上两种算法的代码部分，其中归并算法需要参考[Task3](http://datacruiser.io/2019/08/05/Leetcode-%E8%85%BE%E8%AE%AF%E7%B2%BE%E9%80%8950%E9%A2%98-No-4-23-%E5%90%88%E5%B9%B6K%E4%B8%AA%E9%93%BE%E8%A1%A8/)中的合并两个有序链表的函数。

# 代码

## 快速排序

```c
void swap(int *a,int *b)
{
    int t=*a;
    *a=*b;
    *b=t;
}

struct ListNode *partion(struct ListNode *pBegin,struct ListNode *pEnd)
{
    if(pBegin==pEnd||pBegin->next==pEnd)    
        return pBegin;
    int key=pBegin->val;    //选择pBegin作为基准元素
    struct ListNode *p=pBegin,*q=pBegin;
    while(q!=pEnd)
    {   //从pBegin开始向后进行一次遍历
        if(q->val<key)
        {
            p=p->next;
            swap(&p->val,&q->val);
        }
        q=q->next;
    }
    swap(&p->val,&pBegin->val);
    return p;
}
    
void quick_sort(struct ListNode *pBegin,struct ListNode *pEnd)
{
    if(pBegin==pEnd||pBegin->next==pEnd)    
        return;
    struct ListNode *mid=partion(pBegin,pEnd);
    quick_sort(pBegin,mid);
    quick_sort(mid->next,pEnd);
}
   
struct ListNode* sortList(struct ListNode* head) 
{
    if(head==NULL||head->next==NULL)    
        return head;
    quick_sort(head, NULL);
    return head;
}
```

## 归并排序

```c
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

struct ListNode* sortList(struct ListNode* head)
{
	if(!head || !head->next)
		return head;
	struct ListNode *slow = head, *fast = head, *pre = head;
	while(fast && fast->next)
	{
		pre = slow;
		slow = slow->next;
		fast = fast->next->next;
	}
	pre->next = NULL;
	return mergeTwoLists(sortList(head), sortList(slow));//slow为原链表的中间节点
}


```

