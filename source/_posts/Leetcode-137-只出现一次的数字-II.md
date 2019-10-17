---
title: Leetcode-137. 只出现一次的数字 II
date: 2019-10-16 20:33:47
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

给定一个非空整数数组，除了某个元素只出现一次以外，其余每个元素均出现了三次。找出那个只出现了一次的元素。

**说明：**


你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？

**示例 1:**

```c
输入: [2,2,3,2]
输出: 3
```

**示例 2:**

```c
输入: [0,1,0,1,0,1,99]
输出: 99
```

来源：力扣（LeetCode）
链接：[137. Single Number II](https://leetcode-cn.com/problems/single-number-ii)


# 解题思路

本题依然是考察位运算，是[Single Number](http://datacruiser.io/2019/08/11/Leetcode-Tencent-50-Task7-136-Single-Number/)的延伸, 如果没有这个提示，很容易想到用一个`map<key,value>`来求解，其中`key`为数组当中出现过的去重元素，`value`是对应元素出现过的次数，这样遍历一遍数组就可以求得这个`map`，然后找出`value`为1的那一个键值对，返回`key`。这个方法倒是能够在`O(N)`的时间复杂度内求解问题，但是需要开辟额外的空间。为了满足题意，显然还有更优雅的实现。

[Single Number](http://datacruiser.io/2019/08/11/Leetcode-Tencent-50-Task7-136-Single-Number/)的解法比较独特, 利用了对于任一位向量，两两异或为0的特性。而本题是除了一个单独的数字之外，数组中其它的数字都出现了三次，根据题目对于时间复杂度和空间复杂度的要求，还是要利用位操作来解。

可以建立一个32位的数字，来统计每一位上1出现的个数，如果某一位上为1的话，那么如果该整数出现了三次，对3取余为0，这样把每个数的对应位都加起来对3取余，最终剩下来的那个数就是单独的数字。下面来看一个具体的例子：

以数组`[1,2,6,1,1,2,2,3,3,3]`为例，一共3个1，3个2，3个3，1个6，所有数字的二进制如下：

```c
十进制           二进制
    1           0 0 1
    2           0 1 0
    6           1 1 0
    1           0 0 1
    1           0 0 1
    2           0 1 0
    2           0 1 0
    3           0 1 1
    3           0 1 1
    3           0 1 1
```

看最右边的一列 1001100111，一共6个1，中间一列，0110011111，一共7个1，最左边的一列，0010000000，只有1个1。这里我们发现了规律，要获得唯一的那个数6的二进制 110，我们只要统计各列1的个数，然后对3求余操作即可。显然，这种方法可以解决一系列的问题，比如数组当中其余元素均出现四次或者五次及以上，然后其中一个只出现了一次，求那个出现了一次的元素。

具体代码见解法一。

另外，此种类型的题目还有一种通用解法，可以参考[这个链接](https://leetcode.com/problems/single-number-ii/discuss/43295/Detailed-explanation-and-generalization-of-the-bitwise-operation-method-for-single-numbers)。

具体代码见解法二。（回头可以专门开一个帖子来介绍这种通用的位操作的方法）

最后是此类问题的常规解法，借助哈希表，来统计每个元素出现的次数，最后取出出现一次的元素，当然，这个在空间复杂度是$O(N)$，无法满足本题的要求，不过提交依然能够通过。

具体代码见解法三。

# 代码

## 解法一

```c
int singleNumber(int* nums, int numsSize)
{
    int result = 0;
    
    for(int i = 0; i < 32; i++)
    {
        int count_one = 0;
        for(int j = 0; j < numsSize; j++)
        {
            count_one += (nums[j] >> i) & 1;
        }
        
        result |= UINT32_C(count_one % 3) << i;
        
    }
    
    return result;
}

```

## 解法二

```c
int singleNumber(int* nums, int numsSize)
{
    int x1 = 0, x2 = 0, mask = 0;
    
    for(int i = 0; i < numsSize; i++)
    {
        x2 ^= x1 & nums[i];
        x1 ^= nums[i];
        mask = ~(x1 & x2);
        x2 &= mask;
        x1 &= mask;
    }
          
    return x1;
}
```

## 解法三

```java
public int singleNumber(int[] nums) {
    HashMap<Integer, Integer> map = new HashMap<>();
    for (int i = 0; i < nums.length; i++) {
        if (map.containsKey(nums[i])) {
            map.put(nums[i], map.get(nums[i]) + 1);
        } else {
            map.put(nums[i], 1);
        }
    }
    for (Integer key : map.keySet()) { 
        if (map.get(key) == 1) {
            return key;
        }

    }
    return -1; 
}
```


# 参考

- [[LeetCode] 137. Single Number II 单独的数字之二](https://www.cnblogs.com/grandyang/p/4263927.html)
- [详细通俗的思路分析，多解法](https://leetcode-cn.com/problems/single-number-ii/solution/xiang-xi-tong-su-de-si-lu-fen-xi-duo-jie-fa-by--31/)