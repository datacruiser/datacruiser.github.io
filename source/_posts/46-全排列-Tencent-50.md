---
title: 46. 全排列 Tencent 50
date: 2019-09-17 19:12:26
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Taskxx。
---

# 描述

给定一个没有重复数字的序列，返回其所有可能的全排列。

**示例:**

```c
输入: [1,2,3]
输出:
[
  [1,2,3],
  [1,3,2],
  [2,1,3],
  [2,3,1],
  [3,1,2],
  [3,2,1]
]
```

来源：力扣（LeetCode）
链接：[46. permutations]https://leetcode-cn.com/problems/permutations

# 解题思路

这道题是求全排列问题，给的输入数组没有重复项，需要用递归深度优先搜索`DFS`来求解。这里需要用到一个 `visited` 数组来标记某个数字是否访问过，然后在` DFS `递归函数的循环应从头开始，而不是从 `level` 。`level`的本质是记录当前已经拼出的个数，一旦其达到了 `nums` 数组的长度，说明此时已经是一个全排列了，因为再加数字的话，就会超出。还有就是，为啥这里的 `level` 要从0开始遍历，因为这是求全排列，每个位置都可能放任意一个数字，这样会有个问题，数字有可能被重复使用，由于全排列是不能重复使用数字的，所以需要用一个 `visited` 数组来标记某个数字是否使用过，具体代码如下：

# 代码

```c
/**
 * Return an array of arrays of size *returnSize.
 * The sizes of the arrays are returned as *returnColumnSizes array.
 * Note: Both returned array and *columnSizes array must be malloced, assume caller calls free().
 */


void dfs(int *item,int level, int *nums, int n, int *visited, int ***out, int *returnSize)
{
    if(level == n)
    {
        (*returnSize)++;
        *out = realloc(*out,sizeof(int*)*(*returnSize));
        (*out)[*returnSize - 1] = malloc(sizeof(int)*n);
        memcpy((*out)[*returnSize - 1], item , sizeof(int)*n);
        return;
    }
    for(int i = 0; i < n; i++)
    {
        if(visited[i] == 0)
        {
            visited[i] = 1;
            item[level] = nums[i];
            dfs(item, level + 1, nums, n, visited, out, returnSize);
            visited[i] = 0;
            item[level] = 0;
        }
    }
}

int** permute(int* nums, int numsSize, int* returnSize, int** returnColumnSizes)
{
    if(!nums)
        return NULL;
    
    //内存空间声明
    int *visited = malloc(sizeof(int)*numsSize);
    int *item = malloc(sizeof(int)*numsSize);
    int **result = malloc(sizeof(int*));
    
    //数据初始化
    memset(visited, 0, sizeof(int)*numsSize);
    memset(item, 0, sizeof(int)*numsSize);
    
    //数据初始化
    *returnSize = 0;
    
    dfs(item, 0, nums, numsSize, visited, &result, returnSize);
    
    int *col = malloc(sizeof(int)*(*returnSize));
    
    for(int i=0; i < (*returnSize); i++)
        col[i] = numsSize;
    
    *returnColumnSizes = col;
    return result;
}

```

# 参考资料

- [LeetCode 46. 全排列 Permutations （C语言）](http://element-ui.cn/news_show_3444.shtml)
- [[LeetCode] 46. Permutations 全排列](https://www.cnblogs.com/grandyang/p/4358848.html)

