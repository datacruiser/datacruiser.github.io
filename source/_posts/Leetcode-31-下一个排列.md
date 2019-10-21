---
title: Leetcode-31. 下一个排列
date: 2019-10-21 21:01:19
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 单调栈 
- 数组
description: Leetcode刷题系列.
---
# 描述

实现获取下一个排列的函数，算法需要将给定数字序列重新排列成字典序中下一个更大的排列。

如果不存在下一个更大的排列，则将数字重新排列成最小的排列（即升序排列）。

必须原地修改，只允许使用额外常数空间。

以下是一些例子，输入位于左侧列，其相应输出位于右侧列。

```c
1,2,3 → 1,3,2
3,2,1 → 1,2,3
1,1,5 → 1,5,1
```

来源：力扣（LeetCode）
链接：[31. Next Permutation](https://leetcode-cn.com/problems/next-permutation)

# 解题思路

因为还没有系统地学习过离散数学，看到这样的题目通常都是一脸茫然的，参考了wiki百科[Permutation](https://en.wikipedia.org/wiki/Permutation#Generation_in_lexicographic_order)以及《离散数学及其应用》第七版P368~369上面的算法介绍, 按字典顺序生成下一个最大排列的算法如下:

- Find the largest index` k `such that `a[k] < a[k + 1]`. If no such index exists, the permutation is the last permutation.
- Find the largest index `l` greater than` k` such that `a[k] < a[l]`.
- Swap the value of `a[k]` with that of` a[l]`.
- Reverse the sequence from `a[k + 1]` up to and including the final element `a[n]`.

再来看下面一个例子，有如下的一个数组
```c
1　　2　　7　　4　　3　　1
```
下一个排列为：
```c
1　　3　　1　　2　　4　　7
```

看看这个算法是如何做到的. 

- 首先, 满足`a[k] < a[k + 1]`的最后一对整数分别为`a[2]=2和a[3]=7`
- 而排在`a[2]`右边且大于`a[2]`的最小整数是`a[5]=3`
- 交换`a[2]`和`a[5]`
- 然后将剩余的数字进行升序即可

知道了这个算法以后代码写起来应该就比较容易了，具体如下：

# 代码

```c
// 交换nums数组当中的两个元素
void swap(int* nums, int a, int b)
{
    int tmp = nums[a];
    nums[a] = nums[b];
    nums[b] = tmp;
}
// 对 nums 数组的 start 到 end 做倒序排列
void reverse(int* nums, int start, int end) 
{
    while(start < end)
    {
        swap(nums, start++, end--);
    }
}


void nextPermutation(int* nums, int numsSize)
{
    if(!nums || numsSize == 0) return;
    
    int firstIndex = -1, secondIndex = -1;
    
    
    for(int i = numsSize - 2; i >= 0; i--)
    {
        if(nums[i] < nums[i + 1])
        {
            firstIndex = i;
            break;
        }
    }
    
    if(firstIndex == -1)
    {
        reverse(nums, 0, numsSize - 1);
        return;
    }
    
    for (int i = numsSize - 1; i >= firstIndex; i--) 
    {
        if (nums[i] > nums[firstIndex]) 
        {
            secondIndex = i;
            break;
        }
    }
   
    swap(nums, firstIndex, secondIndex);
    reverse(nums, firstIndex + 1, numsSize - 1);
    return;
   
}
```

# 参考

- [Permutation](https://en.wikipedia.org/wiki/Permutation#Generation_in_lexicographic_order)
- [[LeetCode] 31. Next Permutation 下一个排列](https://www.cnblogs.com/grandyang/p/4428207.html)
- [下一个排列](https://leetcode-cn.com/problems/next-permutation/solution/xia-yi-ge-pai-lie-by-powcai/)