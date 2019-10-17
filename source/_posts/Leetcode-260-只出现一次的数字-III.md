---
title: Leetcode-260. 只出现一次的数字 III
date: 2019-10-17 16:31:28
categories:
- [LeetCode]
tags:
- 数据结构
- 算法
- C语言
- 位运算
description: Leetcode刷题系列.
---
# 描述

给定一个整数数组 `nums`，其中恰好有两个元素只出现一次，其余所有元素均出现两次。 找出只出现一次的那两个元素。

**示例 :**

```c
输入: [1,2,1,3,2,5]
输出: [3,5]
```

**注意：**

- 结果输出的顺序并不重要，对于上面的例子， [5, 3] 也是正确答案。
- 你的算法应该具有线性时间复杂度。你能否仅使用常数空间复杂度来实现？

来源：力扣（LeetCode）
链接：[260. Single Number III](https://leetcode-cn.com/problems/single-number-iii)

# 解题思路

本题依然是考察位运算，是[Single Number](http://datacruiser.io/2019/08/11/Leetcode-Tencent-50-Task7-136-Single-Number/)的延伸, 本题里面是有两个只出现一次的数字，虽然没有那么直接，但是本题还是可以利用异或的性质进行求解。主要的思路是将这两个数字进行分组，分在不同的组当中，然后采用[Single Number](http://datacruiser.io/2019/08/11/Leetcode-Tencent-50-Task7-136-Single-Number/)中的解法进行求解，具体的步骤如下：
- 把原数组全部异或起来，得到一个数字`mask`，是数组当中不同的两个数字异或的结果，这个数字的二进制上面为1的位可以用来对原来两个不同的数进行区分
- 利用`mask = mask & (-mask)`取出`mask`最右端为1的位，这是如何做到的呢？
  - 我们以3，5为例，两者的二进制分别为：11，101，异或以后的的值为110，我们现在要取出右边的1，即10
  - 首先取负数的操作，在二进制当中取负数的操作采用补码的形式，补码就是反码+1
  - 110的反码就是11...1001，+1以后是11...1010，然后与110与，得到了10
- 我们用第二位的1来和数组中每个数字相与，根据结果的不同，一定可以将3和5区分开来，而其他的数字由于是成对出现，所以区分开来也是成对的，最终都会 '异或' 成0，不会3和5产生影响
- 最后分别将两个小组中的数字都异或起来，就可以得到最终结果了

具体代码如下：

# 代码

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* singleNumber(int* nums, int numsSize, int* returnSize)
{
    //返回数组的size是确定的
    *returnSize = 2;
    
    int mask = 0;
    
    int* result = (int *)malloc(sizeof(int) * 2);
    
    //返回变量初始化
    result[0] = result[1] = 0;
    
    //全部元素异或
    for(int i = 0; i < numsSize; i++)
    {
        mask ^= nums[i];
    }
    
    //取最右边的1
    mask &= -mask;
    
    for(int i = 0; i < numsSize; i++)
    {
        //区分两个不同的数字
        if(mask & nums[i])
            result[0] ^= nums[i];
        else
            result[1] ^= nums[i];
    }
    
    return result;

}

```



# 参考

- [[LeetCode] Single Number III 单独的数字之三](https://www.cnblogs.com/grandyang/p/4741122.html)
- [只出现一次的数字 III（详解排序、哈希集与位运算）](https://leetcode-cn.com/problems/single-number-iii/solution/zhi-chu-xian-yi-ci-de-shu-zi-iiixiang-jie-pai-xu-h/)