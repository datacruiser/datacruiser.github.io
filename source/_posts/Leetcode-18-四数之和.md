---
title: Leetcode-18. 四数之和
date: 2019-10-22 20:20:00
categories:
- [LeetCode]
tags:
- 数据结构
- 算法
- C语言
- 数组
- 快慢指针
description: Leetcode刷题系列.
---

# 描述

给定一个包含 `n `个整数的数组 `nums` 和一个目标值 `target`，判断` nums` 中是否存在四个元素 `a，b，c` 和 `d` ，使得` a + b + c + d` 的值与` target` 相等？找出所有满足条件且不重复的四元组。

**注意：**

答案中不可以包含重复的四元组。

**示例：**

```c
给定数组 nums = [1, 0, -1, 0, -2, 2]，和 target = 0。

满足要求的四元组集合为：
[
  [-1,  0, 0, 1],
  [-2, -1, 1, 2],
  [-2,  0, 0, 2]
]
```


来源：力扣（LeetCode）
链接：[18. 4sum](https://leetcode-cn.com/problems/4sum)

# 解题思路

求几数之和还是有套路的，我们可以回想一下前面做过的[两数之和](https://leetcode-cn.com/problems/two-sum/)和[三数之和](http://datacruiser.io/2019/08/26/Leetcode-Tencent-50-Task19-15-3Sum/)，可以借助散列查找，也可以对数组排序以后采用快慢指针。

因为涉及到的数比较多，本文主要介绍后一种方法。

首先，排序，没什么太多可说的，调用C语言的`qsort`，这里的算法复杂度是$O(N \lgN)$，然后就是两重循环，每一重循环相当于规定了其中一个数，然后在第三重循环当中设置快慢指针，通过一轮的扫描找到满足与当前固定的两个数加到一起等于`target`的两个指针。具体代码如下（代码当中加入详细注释）：


# 代码

```c
/**
 * Return an array of arrays of size *returnSize.
 * The sizes of the arrays are returned as *returnColumnSizes array.
 * Note: Both returned array and *columnSizes array must be malloced, assume caller calls free().
 */
 
//快速排序需要用到的比较函数 
int comp(const void *a,const void *b)
{
    return *(int *)a - *(int *)b;
}


int** fourSum(int* nums, int numsSize, int target, int* returnSize, int** returnColumnSizes)
{
    //初始化返回数据的组数，需要注意的是：*在声明指针的时候是一种类型，但是在声明以后具体使用的时候就变成了一个运算符
    *returnSize = 0;
    
    //如果数组为空则返回0
    if (numsSize == 0) 
    {
        return 0;
    }
    
    //分配返回四元组集合个数维度的二级指针，其中int*指针的元组个数与输入数组的大小有关系，尽量取大一点
    int **ret = (int **)malloc(sizeof(int *) * (numsSize + 1) * 4);
    
    //定义三个指针，其中begin固定第一重循环的元素位置，left固定第二重循环的元素位置
    int left = 0;
    int begin = 0;
    int end = numsSize - 1;
    
    //第一重循环寻找的目标值，即target减去第一重循环固定下来的元素的值
    int loopTarget = 0;
    //第二重循环寻找的目标值，即在第一重循环的基础上减去第二重循环固定下来的元素的值
    int subTarget = 0;
    
    //定义数组的size
    *returnColumnSizes = malloc(sizeof(int) * (numsSize + 1) * 4);
    //快排
    qsort(nums, numsSize, sizeof(int), comp);
    //分配第一个四元组的空间
    ret[*returnSize] = malloc(sizeof(int) * 4);
    
    //第一重循环，注意循环结束的条件是 begin + 2 < end，不需要一直到数组的最后的位置，倒数第二个就可以了
    while (begin + 2 < end) 
    {
        从begin+1一位的数组元素开始
        left = begin + 1;
        
        //确定第一重循环的目标
        loopTarget = target - nums[begin];
        //第二重循环，循环结束条件为 left + 1 < end，也不需要一直在数据的最后的位置，倒数第一个就可以了 
        while (left + 1 < end) 
        {
            //需要寻找的左指针并初始化
            int i = left + 1;
            //需要寻找的右指针并初始化
            int j = end;
            //确定第二重循环的目标
            subTarget = loopTarget - nums[left];
            
            //寻找左右指针的遍历
            while (i < j) 
            {
                //如果相加比目标小，则左指针右移
                if (nums[i] + nums[j] < subTarget) 
                {
                    i++;
                } 
                //如果相加比目标大，则右指针左移
                else if (nums[i] + nums[j] > subTarget) 
                {
                    j--;
                } 
                //如果找到一组四元组
                else 
                {
                    //返回结果赋值
                    ret[*returnSize][0] = nums[begin];
                    ret[*returnSize][1] = nums[left];
                    ret[*returnSize][2] = nums[i];
                    ret[*returnSize][3] = nums[j];
                    //确定返回数组大小
                    (*returnColumnSizes)[*returnSize] = 4;
                    //返回数组大小更新
                    (*returnSize)++;
                    //再次分配下一轮寻找的四元组空间
                    ret[*returnSize] = malloc(sizeof(int) * 4);
                    //去重
                    while(nums[i] == nums[++i] && i < j) {}
                    //去重
                    while(nums[j] == nums[--j] && i < j) {}
                }
            }
            //去重
            while(nums[left] == nums[++left] && left + 1 < end) {}
        }
        //去重
        while(nums[begin] == nums[++begin] && begin + 2 < end) {}
    }
    
    return ret;
}

```
