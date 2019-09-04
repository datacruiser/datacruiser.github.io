---
title: Leetcode Tencent 50 33. Search in Rotated Sorted Array
date: 2019-09-03 19:52:12
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task23。
---

# 描述

假设按照升序排序的数组在预先未知的某个点上进行了旋转。

( 例如，数组` [0,1,2,4,5,6,7]` 可能变为 `[4,5,6,7,0,1,2]` )。

搜索一个给定的目标值，如果数组中存在这个目标值，则返回它的索引，否则返回 `-1` 。

你可以假设数组中不存在重复的元素。

你的算法时间复杂度必须是 $O(log n)$ 级别。

**示例 1:**

```c
输入: nums = [4,5,6,7,0,1,2], target = 0
输出: 4
```

**示例 2:**

```c

输入: nums = [4,5,6,7,0,1,2], target = 3
输出: -1
```

来源：力扣（LeetCode）
链接：[33. Search in Rotated Sorted Array](https://leetcode-cn.com/problems/search-in-rotated-sorted-array)

# 解题思路

看到题目对算法复杂度的要求，可以联想到此题需要采用二分查找法进行求解。但是难点在于怎么个二分法，因为我们不知道原数组在哪里被旋转了。

拿题目中提供的例子来分析一下，对于数组`[0,1,2,4,5,6,7]`共有下列七种旋转方法：

$$
\begin{bmatrix}
	0 & 1 & 2 & 4 & 5 & 6 & 7\\
    7 & 0 & 1 & 2 & 4 & 5 & 6\\
    6 & 7 & 0 & 1 & 2 & 4 & 5\\
    5 & 6 & 7 & 0 & 1 & 2 & 4\\
    4 & 5 & 6 & 7 & 0 & 1 & 2\\
    2 & 4 & 5 & 6 & 7 & 0 & 1\\
    1 & 2 & 4 & 5 & 6 & 7 & 0\\
\end{bmatrix}
$$

二分查找法的关键在于获得了中间数以后，判断下面的查找是在左半段还是右半段。观察上面矩阵各行中间位置的数，在前面的4行数据当中，中间数右半段是有序的，此时的条件是中间数小于最右边的数，即`nums[mid] < nums[right]`，在后面的3行数据当中，中间数左半段是有序的，此时的条件是中间数大于最右边的数，即`nums[mid] > nums[right]`。结合需要寻找的目标变量`target`，可以分以下两种情况：

- `nums[mid] < nums[right]`，右半段有序，若`nums[mid] < target <= nums[right]`，则在右半段寻找，修改数组下标变量，令`left = mid + 1`，否则在左半段寻找，修改数组下标变量，令`right = mid - 1`
- `nums[mid] > nums[right]`，左半段有序，若`nums[left] <= target < nums[mid]`，则在左半段寻找，修改数组下标变量，令`right = mid - 1`，否则在右半段寻找，修改数组下标变量，令`left = mid + 1`
- 根据题意，数组中不存在重复的数字，所以不存在`nums[mid]=nums[right]`的情况


# 代码


```c
int search(int* nums, int numsSize, int target)
{
    int left = 0, right = numsSize - 1; //初始化左右指针位置

    while(left <= right)                //二分查找终止条件
    {
        int mid = (right + left) / 2;   //初始化中间位置，mid = left + (right - left) / 2也可以
        if(nums[mid] == target) return mid; //如果找到目标，返回mid
        if(nums[mid] < nums[right])         //中间数右半段是有序的
        {
            if(nums[mid] < target && nums[right] >= target) //目标值在右半段
            {
                left  = mid + 1;
            }
            else
            {
                right = mid - 1;
            }
        }
        //中间数左半段是有序的
        else
        {
            if(nums[left] <= target && target < nums[mid]) //目标值在左半段
            {
                right = mid - 1;
            }
            else
            {
                left = mid + 1;
            }
        }
    }
    return -1; //循环跳出后如果仍未找到，返回-1
}
``` 




# 参考资料

- [[LeetCode] 33. Search in Rotated Sorted Array 在旋转有序数组中搜索](https://www.cnblogs.com/grandyang/p/4325648.html)
- [击败了99.83%的java用户](https://leetcode-cn.com/problems/search-in-rotated-sorted-array/solution/ji-bai-liao-9983de-javayong-hu-by-reedfan/)