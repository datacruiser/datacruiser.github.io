---
title: Leetcode Tencent 50 Task18 26. Remove Duplicates from Sorted Array
date: 2019-08-28 10:36:39
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task18。
---

# 描述

给定一个排序数组，你需要在原地删除重复出现的元素，使得每个元素只出现一次，返回移除后数组的新长度。

不要使用额外的数组空间，你必须在原地修改输入数组并在使用 $O(1)$ 额外空间的条件下完成。

**示例 1:**

给定数组` nums = [1,1,2], `

函数应该返回新的长度 2, 并且原数组 nums 的前两个元素被修改为 1, 2。 

你不需要考虑数组中超出新长度后面的元素。


**示例 2:**

给定 `nums = [0,0,1,1,1,2,2,3,3,4],`

函数应该返回新的长度 5, 并且原数组 nums 的前五个元素被修改为 0, 1, 2, 3, 4。

你不需要考虑数组中超出新长度后面的元素。

说明:

为什么返回数值是整数，但输出的答案是数组呢?

请注意，输入数组是以“引用”方式传递的，这意味着在函数里修改输入数组对于调用者是可见的。

你可以想象内部操作如下:

```c
// nums 是以“引用”方式传递的。也就是说，不对实参做任何拷贝
int len = removeDuplicates(nums);

// 在函数里修改输入数组对于调用者是可见的。
// 根据你的函数返回的长度, 它会打印出数组中该长度范围内的所有元素。
for (int i = 0; i < len; i++) {
    print(nums[i]);
}

```

来源：力扣（LeetCode）
链接：[26. Remove Duplicates from Sorted Array](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-array)




# 解题思路

首先，我的思路是遍历数组，在遇到相同的元素的时候将该元素移到最末尾，然后设置一个`count`变量来记录交换的次数, 最后返回`numSize-count`个元素。代码如下：

```c
void swap(int *x,int *y)//使用指针传递地址
{
    int temp;
    temp=*x;
    *x=*y;
    *y=temp;
}

int removeDuplicates(int* nums, int numsSize){
    int count = 0;
    for(int i = 0; i < numsSize - count; i++)
        for(int j= i+1; j < numsSize - count; j++)
            if(nums[i] == nums[j])
            {
                swap(&nums[j], &nums[numsSize-i-1]);
                count++;
            }
    return numsSize - count;
}
```

提交后结果如下，能够通过14个测试用例。

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/Task18%2026.%20Remove%20Duplicates%20from%20Sorted%20Array/%283%29%20%E5%88%A0%E9%99%A4%E6%8E%92%E5%BA%8F%E6%95%B0%E7%BB%84%E4%B8%AD%E7%9A%84%E9%87%8D%E5%A4%8D%E9%A1%B9%20-%20%E6%8F%90%E4%BA%A4%E8%AE%B0%E5%BD%95%20-%20%E5%8A%9B%E6%89%A3%20%28LeetCode%29%202019-08-28%2014-47-46.png)

好像这样的思路解决不了问题，并且也打乱了原来数组的有序性。

比较好的一个解决办法是采用快慢指针的方法，用快指针遍历整个数组，然后将不同元素的数据保存到慢指针的下标当中。开始的时候两个指针都指向第一个元素，如果两个指针指的元素相等，则快指针向前走一步，如果不同，则两个指针同时向前走一步，并将快指针坐标中的元素值赋值给慢指针坐标中的元素。如此这般，遍历一遍以后，返回慢指针当前的坐标＋1就是数组中不同元素的个数。具体代码如下：


    
# 代码


```c


int removeDuplicates(int* nums, int numsSize)
{
    if(numsSize == 0) return 0;
    int slow = 0, fast = 0;
    
    //int count = 0;
   while(fast < numsSize)
   {
       if(nums[slow] == nums[fast])
           fast++;
       else
       {
           nums[++slow] = nums[fast++];
           
       }
   }
   return slow+1;
}

``` 

