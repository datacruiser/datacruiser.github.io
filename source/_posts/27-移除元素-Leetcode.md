---
title: 27. 移除元素 Leetcode
date: 2019-09-28 23:04:44
categories: Leetcode
tags:
- 数据结构
- 算法
- C语言
- 数组
description: LeetCode刷题系列。
---

# 描述

给定一个数组 `nums` 和一个值 `val`，你需要原地移除所有数值等于` val `的元素，返回移除后数组的新长度。

不要使用额外的数组空间，你必须在原地修改输入数组并在使用` O(1)` 额外空间的条件下完成。

元素的顺序可以改变。你不需要考虑数组中超出新长度后面的元素。

**示例 1:**
```c
给定 nums = [3,2,2,3], val = 3,

函数应该返回新的长度 2, 并且 nums 中的前两个元素均为 2。

你不需要考虑数组中超出新长度后面的元素。
```

**示例 2:**

```c

给定 nums = [0,1,2,2,3,0,4,2], val = 2,

函数应该返回新的长度 5, 并且 nums 中的前五个元素为 0, 1, 3, 0, 4。

注意这五个元素可为任意顺序。

你不需要考虑数组中超出新长度后面的元素。
```

**说明:**

为什么返回数值是整数，但输出的答案是数组呢?

请注意，输入数组是以“引用”方式传递的，这意味着在函数里修改输入数组对于调用者是可见的。

你可以想象内部操作如下:

```c
// nums 是以“引用”方式传递的。也就是说，不对实参作任何拷贝
int len = removeElement(nums, val);

// 在函数里修改输入数组对于调用者是可见的。
// 根据你的函数返回的长度, 它会打印出数组中该长度范围内的所有元素。
for (int i = 0; i < len; i++) {
    print(nums[i]);
}
```

来源：力扣（LeetCode）
链接：[27. Remove Element](https://leetcode-cn.com/problems/remove-element)

# 解题思路

本题解法很多，这里例举两种，解法一是遍历数组，发现当前第`i`个元素与`val`相等的就就地将其与最末尾的元素交换，成功交换一次以后修`length--`更新末尾指针，然后跳出当轮循环，直到碰到一个不想等的元素再`i++`，最后退出循环后返回`length`。


解法二其实总体的思路也可以算作双指针的思路，不过实现起来更加优雅，直接改变原数组元素，并且进行重拍，遍历数组，遇到有不想等的就放到数组前面，同时`length++`，最后遍历结束后返回`length`，这次在`length`指针以后位置的元素无关紧要。

具体代码如下：

# 代码

## 解法一

```c
void swap_num(int *p1, int *p2)
{
    int *tmp = *p1;
    *p1 = *p2;
    *p2 = tmp;
}

int removeElement(int* nums, int numsSize, int val)
{
    int length = numsSize;
    int i = 0;
    while(i < len)
    {
        if(nums[i] == val)
        {
            swap_num(&nums[length - 1], &nums[i]);
            length--;
            continue;
        }
        i++;
    }
    return length;
}

```

## 解法二

```c
int removeElement(int* nums, int numsSize, int val)
{
    int length  =  0;
    for(int i = 0; i < numsSize; i++)
    {
        if(nums[i]  != val)
        {
            nums[length++] = nums[i];
        }
    }
    
    return length;
}
```
