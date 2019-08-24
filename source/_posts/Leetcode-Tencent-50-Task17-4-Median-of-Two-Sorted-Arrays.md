---
title: Leetcode Tencent 50 Task17 4. Median of Two Sorted Arrays
date: 2019-08-21 08:35:21
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task17。
---

# 描述

给定两个大小为 `m `和 `n `的有序数组 `nums1 `和 `nums2`。

请你找出这两个有序数组的中位数，并且要求算法的时间复杂度为` O(log(m + n))`。

你可以假设 `nums1` 和 `nums2` 不会同时为空。

**示例 1:**

```c

nums1 = [1, 3]
nums2 = [2]

则中位数是 2.0

```


**示例 2:**

```c

nums1 = [1, 2]
nums2 = [3, 4]

则中位数是 (2 + 3)/2 = 2.5

```

来源：力扣（LeetCode）
链接：[4. Median of Two Sorted Arrays](https://leetcode-cn.com/problems/median-of-two-sorted-arrays)


# 解题思路

显然，这道题对于时间复杂度有要求，常规的合并两个有序数组然后再根据数组下标再找中位数的思路是行不通的。看到` O(log(m + n))`应该能够想到采用二分法。

## 中位数定义

**中位数**（又称中值，英语：Median），统计学中的专有名词，代表一个样本、种群或概率分布中的一个数值，其可将数值集合划分为相等的上下两部分。对于有限的数集，可以通过把所有观察值高低排序后找出正中间的一个作为中位数。如果观察值有偶数个，则中位数不唯一，通常取最中间的两个数值的平均数作为中位数。

一个数集中最多有一半的数值小于中位数，也最多有一半的数值大于中位数。如果大于和小于中位数的数值个数均少于一半，那么数集中必有若干值等同于中位数。

设连续随机变量X的分布函数为F(X)，那么满足条件P(X≤m)=F(m)=1/2的数称为X或分布F的中位数。

对于一组有限个数的数据来说，其中位数是这样的一种数：这群数据的一半的数据比它大，而另外一半数据比它小。

计算有限个数的数据的中位数的方法是：把所有的同类数据按照大小的顺序排列。如果数据的个数是奇数，则中间那个数据就是这群数据的中位数；如果数据的个数是偶数，则中间那2个数据的算术平均值就是这群数据的中位数。

**公式**

根据定义，若实数$x_1,x_2,...,x_n$按大小顺序（顺序，降序皆可）排列$x_1^{'},x_2^{'},...x_n^{'}$，则实数数列$x=(x_1,x_2,...,x_n)$的中位数$Q_{\frac{1}{2}}(x)$为：


$$
Q_{\frac{1}{2}}(x)=\begin{cases}
x_{\frac{n+1}{2}}^{'}\quad &{\rm if} \,\,n\,\, {\rm is\,\, odd \,\,number.} \\\\
\frac{1}{2}\left(x_{\frac{n}{2}}^{'}+x_{\frac{n}{2}+1}^{'}\right)\quad &{\rm if} \,\,n\,\, {\rm is\,\, even \,\,number.}
\end{cases}
$$

其中`odd number`表示奇数，`even number`表示偶数。

## 题解

参考题解里面的一个[解答](https://leetcode-cn.com/problems/median-of-two-sorted-arrays/solution/he-bing-yi-hou-zhao-gui-bing-guo-cheng-zhong-zhao-/)，太详细了，这里直接转载贴图然后再加以说明。

### 配图1


![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task17%204.%20Median%20of%20Two%20Sorted%20Arrays/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%E7%9F%AD%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%EF%BC%8C%E9%95%BF%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%E8%87%AA%E5%8A%A8%E7%A1%AE%E5%AE%9A%EF%BC%88Python%20%E4%BB%A3%E7%A0%81%E3%80%81Java%20%E4%BB%A3%E7%A0%81%EF%BC%89%20-%20%E5%AF%BB%E6%89%BE%E4%B8%A4%E4%B8%AA%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E4%B8%AD%E4%BD%8D%E6%95%B0%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-08-21%2020-25-12.png)


### 配图2

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task17%204.%20Median%20of%20Two%20Sorted%20Arrays/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%E7%9F%AD%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%EF%BC%8C%E9%95%BF%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%E8%87%AA%E5%8A%A8%E7%A1%AE%E5%AE%9A%EF%BC%88Python%20%E4%BB%A3%E7%A0%81%E3%80%81Java%20%E4%BB%A3%E7%A0%81%EF%BC%89%20-%20%E5%AF%BB%E6%89%BE%E4%B8%A4%E4%B8%AA%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E4%B8%AD%E4%BD%8D%E6%95%B0%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-08-21%2020-26-22.png)

### 配图3

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task17%204.%20Median%20of%20Two%20Sorted%20Arrays/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%E7%9F%AD%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%EF%BC%8C%E9%95%BF%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%E8%87%AA%E5%8A%A8%E7%A1%AE%E5%AE%9A%EF%BC%88Python%20%E4%BB%A3%E7%A0%81%E3%80%81Java%20%E4%BB%A3%E7%A0%81%EF%BC%89%20-%20%E5%AF%BB%E6%89%BE%E4%B8%A4%E4%B8%AA%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E4%B8%AD%E4%BD%8D%E6%95%B0%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-08-21%2020-26-40.png)

### 配图4

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task17%204.%20Median%20of%20Two%20Sorted%20Arrays/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%E7%9F%AD%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%EF%BC%8C%E9%95%BF%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%E8%87%AA%E5%8A%A8%E7%A1%AE%E5%AE%9A%EF%BC%88Python%20%E4%BB%A3%E7%A0%81%E3%80%81Java%20%E4%BB%A3%E7%A0%81%EF%BC%89%20-%20%E5%AF%BB%E6%89%BE%E4%B8%A4%E4%B8%AA%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E4%B8%AD%E4%BD%8D%E6%95%B0%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-08-21%2020-26-55.png)

### 配图5

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task17%204.%20Median%20of%20Two%20Sorted%20Arrays/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%E7%9F%AD%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%EF%BC%8C%E9%95%BF%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%E8%87%AA%E5%8A%A8%E7%A1%AE%E5%AE%9A%EF%BC%88Python%20%E4%BB%A3%E7%A0%81%E3%80%81Java%20%E4%BB%A3%E7%A0%81%EF%BC%89%20-%20%E5%AF%BB%E6%89%BE%E4%B8%A4%E4%B8%AA%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E4%B8%AD%E4%BD%8D%E6%95%B0%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-08-21%2020-27-11.png)

### 配图6

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task17%204.%20Median%20of%20Two%20Sorted%20Arrays/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%E7%9F%AD%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%EF%BC%8C%E9%95%BF%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%E8%87%AA%E5%8A%A8%E7%A1%AE%E5%AE%9A%EF%BC%88Python%20%E4%BB%A3%E7%A0%81%E3%80%81Java%20%E4%BB%A3%E7%A0%81%EF%BC%89%20-%20%E5%AF%BB%E6%89%BE%E4%B8%A4%E4%B8%AA%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E4%B8%AD%E4%BD%8D%E6%95%B0%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-08-21%2020-27-25.png)

### 配图7

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task17%204.%20Median%20of%20Two%20Sorted%20Arrays/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%E7%9F%AD%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%EF%BC%8C%E9%95%BF%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%E8%87%AA%E5%8A%A8%E7%A1%AE%E5%AE%9A%EF%BC%88Python%20%E4%BB%A3%E7%A0%81%E3%80%81Java%20%E4%BB%A3%E7%A0%81%EF%BC%89%20-%20%E5%AF%BB%E6%89%BE%E4%B8%A4%E4%B8%AA%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E4%B8%AD%E4%BD%8D%E6%95%B0%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-08-21%2020-27-40.png)

### 配图8

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task17%204.%20Median%20of%20Two%20Sorted%20Arrays/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%E7%9F%AD%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%EF%BC%8C%E9%95%BF%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%E8%87%AA%E5%8A%A8%E7%A1%AE%E5%AE%9A%EF%BC%88Python%20%E4%BB%A3%E7%A0%81%E3%80%81Java%20%E4%BB%A3%E7%A0%81%EF%BC%89%20-%20%E5%AF%BB%E6%89%BE%E4%B8%A4%E4%B8%AA%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E4%B8%AD%E4%BD%8D%E6%95%B0%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-08-21%2020-27-57.png)

### 配图9

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task17%204.%20Median%20of%20Two%20Sorted%20Arrays/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%E7%9F%AD%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%EF%BC%8C%E9%95%BF%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%E8%87%AA%E5%8A%A8%E7%A1%AE%E5%AE%9A%EF%BC%88Python%20%E4%BB%A3%E7%A0%81%E3%80%81Java%20%E4%BB%A3%E7%A0%81%EF%BC%89%20-%20%E5%AF%BB%E6%89%BE%E4%B8%A4%E4%B8%AA%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E4%B8%AD%E4%BD%8D%E6%95%B0%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-08-21%2020-28-16.png)

### 配图10

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task17%204.%20Median%20of%20Two%20Sorted%20Arrays/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%E7%9F%AD%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%EF%BC%8C%E9%95%BF%E6%95%B0%E7%BB%84%E7%9A%84%E2%80%9C%E8%BE%B9%E7%95%8C%E7%BA%BF%E2%80%9D%E8%87%AA%E5%8A%A8%E7%A1%AE%E5%AE%9A%EF%BC%88Python%20%E4%BB%A3%E7%A0%81%E3%80%81Java%20%E4%BB%A3%E7%A0%81%EF%BC%89%20-%20%E5%AF%BB%E6%89%BE%E4%B8%A4%E4%B8%AA%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E4%B8%AD%E4%BD%8D%E6%95%B0%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-08-21%2020-28-38.png)

贴了这么多图，这里再用文字总结一下。上述方法的核心就是直接依据中位数的定义，在两个数组之间采用二分法找到两个数组作为一个整体时符合定义的分界线，然后根据两个数组元素个数的奇偶性来求出中位数的值。

这里有一个小trick，分别找出第$(m+n+1)/2$和$(m+n+2)/2$个元素，然后求平均值即可，这对于数组总体元素奇偶性都能够适用。

然后，为了找到符合中位数定义的分界线，其实可以转化为在两个有序数组中找到第K个元素，主要可以分为以下几步：
- 定义一个寻找两个有序数组中第K个元素的函数用来递归调用，并将K初始化为m+n的中间值
- 用两个变量`i`和`j`来标记`nums1`和`nums2`的起始位置
- 处理边界条件
  - 当一个数组的起始位置大于等于其数组长度的时候，那么就可以直接在另外一个数组当中找
  - 如果K=1的时候，那么直接比较两个数组起始位置上面的数字，返回较小的那个值即可
- 一般情况下，对K进行二分，分别在两个数组当中查找第K/2个元素
  - 确认数组中到底存不存在第K/2个数字，存在就取出来，不存在就赋值为整型最大值
  - 如果某一个数组没有第K/2个数字，淘汰另外一个数组前K/2个数字
  - 比较两个数组当中第K/2小的数字 `midValue1` 和 `midValue2`的大小，如果 `midValue1`小的化，我们可以淘汰 `nums1`中的前K/2个元素，随后将 `nums1`的起始位置后移K/2个，并且 `K=K-K/2`，调用递归
  

# 代码


```c
//定义辅助比较函数
int min(int a, int b)
{
    if(a > b) return b;
    else return a;
}

//定义递归调用该函数
int findKth(int* nums1, int i, int nums1Size, int* nums2, int j, int nums2Size, int k)
{
    if(i >= nums1Size)
    {
        return nums2[j + k - 1];
    }
    if(j >= nums2Size)
    {
        return nums1[i + k - 1];
    }

    if(k == 1)
    {
        return min(nums1[i], nums2[j]);
    }

    int midValue1 = (i + k / 2 - 1 < nums1Size) ? nums1[i + k / 2 -1] : INT_MAX;
    int midValue2 = (j + k / 2 - 1 < nums2Size) ? nums2[j + k / 2 -1] : INT_MAX;

    if(midValue1 < midValue2)
    {
        return findKth(nums1, i + k / 2, nums1Size, nums2, j, nums2Size, k - k / 2);
    }
    else
    {
        return findKth(nums1, i, nums1Size, nums2, j + k / 2, nums2Size, k - k / 2);
    }
    // return (arg1 > arg2) - (arg1 < arg2); // possible shortcut
    // return arg1 - arg2; // erroneous shortcut (fails if INT_MIN is present)
}


double findMedianSortedArrays(int* nums1, int nums1Size, int* nums2, int nums2Size)
{
    int m  = nums1Size, n = nums2Size;
    int left = (m + n + 1) / 2, right = (m + n + 2) / 2; //初始化K的位置，找到以后返回两者平均值即可

    return (findKth(nums1, 0, m, nums2, 0, n, left) + findKth(nums1, 0 , m, nums2, 0, n, right)) / 2.0;
}
``` 

# 参考

- [二分查找短数组的“边界线”，长数组的“边界线”自动确定（Python 代码、Java 代码）
](https://leetcode-cn.com/problems/median-of-two-sorted-arrays/solution/he-bing-yi-hou-zhao-gui-bing-guo-cheng-zhong-zhao-/)