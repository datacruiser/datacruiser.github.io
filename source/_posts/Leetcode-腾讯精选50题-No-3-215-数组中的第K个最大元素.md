---
title: Leetcode 腾讯精选50题 No.3 215. 数组中的第K个最大元素
date: 2019-08-04 21:21:05
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
description: DataWhale暑期学习小组-LeetCode刷题第八期Task2。
---
# 描述

在未排序的数组中找到第 k 个最大的元素。请注意，你需要找的是数组排序后的第 k 个最大的元素，而不是第 k 个不同的元素。

**示例 1:**
```c
输入: [3,2,1,5,6,4] 和 k = 2
输出: 5
```


**示例 2:**
```c

输入: [3,2,3,1,2,4,5,5,6] 和 k = 4
输出: 4
```


**说明:**

你可以假设 k 总是有效的，且 1 ≤ k ≤ 数组的长度。

# 解题思路

首先，简单粗暴的思路就是将数组从大到小排序，然后直接取第k-1个数据，实现代码如下：

```c
//用来传递给qsort函数的比较函数参数
int comp(const void*a, const void*b)
{
    return *(int*)b - *(int*)a;//降序排列
}

int findKthLargest(int* nums, int numsSize, int k){
    qsort(nums, numsSize, sizeof(int), comp);//将原数组排序
    return nums[k-1];  //返回第K大的元素
}
```

当然，这道题本身是要考察对优先队列/堆这一数据结构的掌握情况。如果采用最大堆/最小堆的思路如下：
- 使用数组内容构建一个最大堆/最小堆
- 通过每次pop出堆顶元素来维护维护堆的结构
- 在满足一定的pop次数（最大堆K-1次，最小堆numSize-K次）以后，堆顶的元素就是第k大的数字

下面的代码是基于最大堆实现的代码，其中，最大堆数据结构代码参考慕课浙江大学《数据结构》公开课，地址如下：

[浙江大学《数据结构》公开课](https://www.icourse163.org/learn/ZJU-93001?tid=1206471203#/learn/content?type=detail&id=1211167093&cid=1213729248)



# 代码

```c
typedef struct HNode *Heap; /* 堆的类型定义 */
struct HNode {
    int *Data; /* 存储元素的数组 */
    int Size;          /* 堆中当前元素个数 */
    int Capacity;      /* 堆的最大容量 */
};
typedef Heap MaxHeap; /* 最大堆 */
typedef Heap MinHeap; /* 最小堆 */
 
#define MAXDATA 100000  /* 该值应根据具体情况定义为大于堆中所有可能元素的值 */
 
MaxHeap CreateHeap( int MaxSize )
{ /* 创建容量为MaxSize的空的最大堆 */
 
    MaxHeap H = (MaxHeap)malloc(sizeof(struct HNode));
    H->Data = (int *)malloc((MaxSize+1)*sizeof(int));
    H->Size = 0;
    H->Capacity = MaxSize;
    H->Data[0] = MAXDATA; /* 定义"哨兵"为大于堆中所有可能元素的值*/
 
    return H;
}
 
bool IsFull( MaxHeap H )
{
    return (H->Size == H->Capacity);
}
 
bool Insert( MaxHeap H, int X )
{ /* 将元素X插入最大堆H，其中H->Data[0]已经定义为哨兵 */
    int i;
  
    if ( IsFull(H) ) { 
        printf("最大堆已满");
        return false;
    }
    i = ++H->Size; /* i指向插入后堆中的最后一个元素的位置 */
    for ( ; H->Data[i/2] < X; i/=2 )
        H->Data[i] = H->Data[i/2]; /* 上滤X */
    H->Data[i] = X; /* 将X插入 */
    return true;
}
 
#define ERROR -1 /* 错误标识应根据具体情况定义为堆中不可能出现的元素值 */
 
bool IsEmpty( MaxHeap H )
{
    return (H->Size == 0);
}
 
int DeleteMax( MaxHeap H )
{ /* 从最大堆H中取出键值为最大的元素，并删除一个结点 */
    int Parent, Child;
    int MaxItem, X;
 
    if ( IsEmpty(H) ) {
        printf("最大堆已为空");
        return ERROR;
    }
 
    MaxItem = H->Data[1]; /* 取出根结点存放的最大值 */
    /* 用最大堆中最后一个元素从根结点开始向上过滤下层结点 */
    X = H->Data[H->Size--]; /* 注意当前堆的规模要减小 */
    for( Parent=1; Parent*2<=H->Size; Parent=Child ) {
        Child = Parent * 2;
        if( (Child!=H->Size) && (H->Data[Child]<H->Data[Child+1]) )
            Child++;  /* Child指向左右子结点的较大者 */
        if( X >= H->Data[Child] ) break; /* 找到了合适位置 */
        else  /* 下滤X */
            H->Data[Parent] = H->Data[Child];
    }
    H->Data[Parent] = X;
 
    return MaxItem;
} 
 
/*----------- 建造最大堆 -----------*/
void PercDown( MaxHeap H, int p )
{ /* 下滤：将H中以H->Data[p]为根的子堆调整为最大堆 */
    int Parent, Child;
    int X;
 
    X = H->Data[p]; /* 取出根结点存放的值 */
    for( Parent=p; Parent*2<=H->Size; Parent=Child ) {
        Child = Parent * 2;
        if( (Child!=H->Size) && (H->Data[Child]<H->Data[Child+1]) )
            Child++;  /* Child指向左右子结点的较大者 */
        if( X >= H->Data[Child] ) break; /* 找到了合适位置 */
        else  /* 下滤X */
            H->Data[Parent] = H->Data[Child];
    }
    H->Data[Parent] = X;
}
 
void BuildHeap( MaxHeap H )
{ /* 调整H->Data[]中的元素，使满足最大堆的有序性  */
  /* 这里假设所有H->Size个元素已经存在H->Data[]中 */
 
    int i;
 
    /* 从最后一个结点的父节点开始，到根结点1 */
    for( i = H->Size/2; i>0; i-- )
        PercDown( H, i );
}

int findKthLargest(int* nums, int numsSize, int k){
    MaxHeap h = CreateHeap(numsSize);//初始化最大堆
    for(int i=0; i < numsSize; i++)
        Insert(h, nums[i]); //将数组元素插入堆
    BuildHeap(h); // 根据已插入的元素创建最大堆
    int result; 
    for(int i=0; i<k; i++) // 弹出K-1次堆顶元素
    {
        result = DeleteMax(h);
    }
    return result; 
}
```