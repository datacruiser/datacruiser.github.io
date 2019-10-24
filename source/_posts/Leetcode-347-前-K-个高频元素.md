---
title: Leetcode-347. 前 K 个高频元素
date: 2019-10-23 14:18:12
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 堆
- 哈希表
- Java
description: Leetcode刷题系列.
---

# 描述

给定一个非空的整数数组，返回其中出现频率前 $k$ 高的元素。

**示例 1:**

```c
输入: nums = [1,1,1,2,2,3], k = 2
输出: [1,2]
```

**示例 2:**

```c
输入: nums = [1], k = 1
输出: [1]
```

**说明：**

- 你可以假设给定的 $k$ 总是合理的，且 1 ≤ k ≤ 数组中不相同的元素的个数。
- 你的算法的时间复杂度必须优于 $O(n log n)$ , n 是数组的大小。

来源：力扣（LeetCode）
链接：[347. Top K Frequent Elements](https://leetcode-cn.com/problems/top-k-frequent-elements)

# 解题思路

对于这类统计数字的问题，HashMap应该是首选，通过HashMap<Key,Value>的KV对建立数字和其出现次数的映射，然后再按照出现的次数进行排序。关于排序，我们可以用堆排序来做，使用一个最大堆来按照映射次数从大到小排列，然后最后弹出堆中前面$k$个元素即可。

在Java当中使用`PriorityQueue`来实现，默认是最小堆，可以在构造的时候传入一个比较函数构造出最大堆。

具体代码见解法一。

当然，也可以直接使用最小堆实现，我们维护一个元素数目为$k$的最小堆，每次都将新的元素与堆顶元素（堆中频率最小的元素）进行比较，如果新的元素的频率比堆顶端的元素大，则弹出堆顶端的元素，将新的元素添加进堆中。最后这个堆中的$k$个元素即为前$k$个高频元素。

具体代码见解法二。

再来一个C语言的解法，基本思路差不多，首先构建哈希表（Key，Value），并且方便哈希表的构建，先对原数组进行排序，然后对哈希表进行排序，以Value为排序元素。最后从哈希表中提前$k$个排序结果即可。

具体代码见解法三。

# 代码

## 解法一：HashMap+最大堆

```java
class Solution 
{
    public List<Integer> topKFrequent(int[] nums, int k) 
    {
        //使用字典，统计每个元素出现的次数，元素为Key，元素出现的次数为Value
        HashMap<Integer,Integer> map = new HashMap<>();
        
        for(int num : nums)
        {
            map.put(num, map.getOrDefault(num, 0) + 1);
        }
        
        //建立最大堆，Java的PriorityQueue默认是最小堆，最大堆的建立需要自定义comparator
        PriorityQueue<Integer> pq = new PriorityQueue<>(new Comparator<Integer>()
                                                        {
                                                            @Override
                                                            public int compare(Integer a, Integer b)
                                                            {
                                                                return map.get(b) - map.get(a);
                                                            }
                                                        });
        //遍历map 用最大堆保存全部元素
        for(int key : map.keySet())
        {
            pq.add(key);
        }
        
        // 取出最大堆中前k个元素
        List<Integer> res = new ArrayList<>();
        
        for(int i = 1; i <= k; i++)
        {
            res.add(pq.remove());
        }
        
        return res;

    }
}
```

## 解法二：HashMap+最小堆

```java
class Solution 
{
    public List<Integer> topKFrequent(int[] nums, int k) 
    {
        //使用字典，统计每个元素出现的次数，元素为Key，元素出现的次数为Value
        HashMap<Integer,Integer> map = new HashMap<>();
        
        for(int num : nums)
        {
            map.put(num, map.getOrDefault(num, 0) + 1);
        }
        
        //建立最小堆，comparator依然需要自定义比较函数
        PriorityQueue<Integer> pq = new PriorityQueue<>(new Comparator<Integer>()
                                                        {
                                                            @Override
                                                            public int compare(Integer a, Integer b)
                                                            {
                                                                return map.get(a) - map.get(b);
                                                            }
                                                        });
        /*维护一个元素数目为k的最小堆，
        每次都将新的元素与堆顶元素（堆中频率最小的元素）进行比较
        如果新的元素的频率比堆顶端的元素大，则弹出堆顶端的元素，将新的元素添加进堆中
        最终，堆中的 kk 个元素即为前 kk 个高频元素
        */
        for(Integer key : map.keySet())
        {
            if(pq.size() < k)
            {
                pq.add(key);
            }
            else if(map.get(key) > map.get(pq.peek())) 
            {
                pq.remove();
                pq.add(key);
            }

        }
        
        // 取出最小堆中的元素
        List<Integer> res = new ArrayList<>();
        while (!pq.isEmpty()) {
            res.add(pq.remove());
        }
        return res;

    }
}
```

## 解法三：Hash+Qsort

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */

int cmp(int *a, int *b)
{
   return  *a - *b ;
}

int cmp_hash(int *a, int *b)
{
    return a[1] - b[1];
}


int* topKFrequent(int* nums, int numsSize, int k, int* returnSize)
{
    //原数组快排
    qsort(nums, numsSize, sizeof(int), cmp);
    
    int *res = (int *)malloc(sizeof(int) * k);
    
    //用二维数组来实习哈希表
    int hashtable[numsSize][2];
    
    //哈希表索引
    int index = 0;
    
    //返回元素索引
    int res_index = 0;
    
    //哈希表初始化
    memset(hashtable, 0, sizeof(hashtable));
    
    //哈希表K V计算
    for(int i = 0; i < numsSize; i++)
    {
        if(i == 0 || hashtable[index][0] != nums[i])
        {
            if(i != 0)
            {
                index++;
            }
            
            hashtable[index][0] = nums[i];
        }
        
        hashtable[index][1]++;
    }
    
    //哈希表快排
    qsort(hashtable, index + 1, sizeof(int) * 2, cmp_hash);
    
    for(int i = index; i >= 0 && res_index < k; i--)
    {
        res[res_index++] = hashtable[i][0];
    }
    
    *returnSize = k;
    
    return res;
        
}
```

# 参考

- [347. 前 K 个高频元素](https://leetcode-cn.com/problems/top-k-frequent-elements/solution/leetcode-di-347-hao-wen-ti-qian-k-ge-gao-pin-yuan-/)
- [LeetCode-347-前K个高频元素-C语言](https://www.codeleading.com/article/7774966045/)