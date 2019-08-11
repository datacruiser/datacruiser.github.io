---
title: Leetcode Tencent 50 Task8 169. Majority Element
date: 2019-08-11 16:09:52
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 位运算
description: DataWhale暑期学习小组-LeetCode刷题第八期Task8。
---

# 描述

给定一个大小为 n 的数组，找到其中的众数。众数是指在数组中出现次数大于 `⌊ n/2 ⌋` 的元素。

你可以假设数组是非空的，并且给定的数组总是存在众数。

**示例 1:**

```c
输入: [3,2,3]
输出: 3
```

**示例 2:**

```c
输入: [2,2,1,1,1,2,2]
输出: 2
```

来源：力扣（LeetCode）
链接：[169. Majority Element](https://leetcode-cn.com/problems/majority-element)



# 解题思路

本题依然是考察位运算，如果没有这个提示，很容易想到用一个`map<key,value>`来求解，其中`key`为数组当中出现过的去重元素，`value`是对应元素出现过的次数，这样遍历一遍数组就可以求得这个`map`，然后找出`value`大于 `⌊ n/2 ⌋`的那一个键值对，返回`key`。这个方法倒是能够在`O(N)`的时间复杂度内求解问题，但是需要开辟额外的空间。另外一种比较容易想到的办法是用两重循环，第一重遍历数组，第二重对数组中元素出现的次数进行计数，然后最后取出count> `⌊ n/2 ⌋`的那个元素。代码如下：

```c
int majorityElement(int* nums, int numsSize){
    int major = numsSize / 2;
    
    for(int i = 0; i<numsSize; i++)
    {
        int count = 0;
    
        for(int j = 0; j<numsSize; j++)
        {
            if(nums[j] == nums[i]){
                count++;
            }
            
        }
        if(count > major)
            return nums[i];
    }
    
    return 0;

}
```

不过非常遗憾，超时了……44个测试用例通过了42个，卡在了第43个。根据题目归类，同样应该还有采用位运算的更加优雅的算法。

首先来理解下面这段代码：

```c
#include<stdio.h>
int main(int argc, char const *argv[])
{
	/* code */
	int num = 63;
	for (int i = 0; i < 32; ++i)
	{
		/* code */
		printf("%d %d\n", i, num & (1 << i));

	}
	return 0;
}
```

运行输出为：

```
0 1
1 2
2 4
3 8
4 16
5 32
6 0
7 0
8 0
9 0
10 0
11 0
12 0
13 0
14 0
15 0
16 0
17 0
18 0
19 0
20 0
21 0
22 0
23 0
24 0
25 0
26 0
27 0
28 0
29 0
30 0
31 0
```
不难发现，我们用`num & (1 << i)`这串用于取得整数`num`二进制第`i`位是否为1，若为1则返回该位为1右侧补`i-1`个0的整数的位操作，将`num`分拆为一系列用类似整数表示整数子串，以上面的代码为例：

$$63=32(2^5)+16(2^4)+8(2^3)+4(2^2)+2(2^1)+1(2^0)$$

于是，我们的思路来了，能否将题目中所需要寻找的众数也进行这样的分拆，用位来进行表示，然后判断它从0～31位上面是0或者是1。将众数二进制位串位数记位`i`，那现在的问题就转换为从0～31遍历`i`的时候，通过题目透露的**众数是指在数组中出现次数大于 `⌊ n/2 ⌋` 的元素**这个条件来判断第`i`位是0或者是1。从上面的例子可以看出，如果第`i`位是1，则`num & (1 << i)`不等于0，这里我们可以遍历整个数组，设置两个计数器`count_1`、`count_0`，分别统计不等于0出现的次数和等于0出现的次数，根据众数的定义，比较这两个计算器的大小，`count_1`大则意味着众数该位为1，否则为0。最后将遍历`i`的结果累加便得到了所要求的众数。

# 代码


```c
int majorityElement(int* nums, int numsSize){
    int result = 0;
    
    for(int i = 0; i<32; i++)
    {
		int count_1 = 0, count_0 = 0;    
        for(int j = 0; j<numsSize; j++)
        {
            if((nums[j] & (UINT32_C(1) << i)) != 0)
            {
                count_1++;
            }
            else
            	count_0++;
            
        }
        if(count_1 > count_0)
            result |= (UINT32_C(1) << i);
    }
    
    return result;

}
```