---
title: Leetcode Tencent 50 Task19 15. 3Sum
date: 2019-08-26 21:14:42
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 数组
description: DataWhale暑期学习小组-LeetCode刷题第八期Task19。
---

# 描述


给定一个包含 $n$ 个整数的数组` nums`，判断 `nums` 中是否存在三个元素 $a，b，c$ ，使得 $a + b + c = 0$ ？找出所有满足条件且不重复的三元组。

注意：答案中不可以包含重复的三元组。

例如, 给定数组 `nums = [-1, 0, 1, 2, -1, -4]`，

满足要求的三元组集合为：

```c
[
  [-1, 0, 1],
  [-1, -1, 2]
]
```

来源：力扣（LeetCode）
链接：[15. 3Sum](https://leetcode-cn.com/problems/3sum)


# 解题思路
  

本题对返回值的要求低，限制少，对于只有数字反馈要求的题目我们应该优先考虑先排序后处理，因为排序只会占用我们$nlogn$的处理时间，但在后续操作中的优势却会逐渐增大，甚至于某些题目离开了排序接近于无解。

排序后我们可以清楚地认识到三数之和==0这个条件，意味着在数字不全为0的情况下，至少有一个负数的存在，固排序后的情况大概率为：$[-\infty,...(0)...,+\infty]$，0可能存在，也可能不存在。

且同样的$a+b+c==0$也存在以下三种情况：

- $a,b,c,$互异
- $a=b=-c/2 ||\,\,\,-a/2=b=c$
- $a=b=c=0$

因为上述情况的存在，导致在排序时我们不可以删除重复项，否则后面两种情况就会被忽略掉，严格来讲我们应该做稳定排序，即使在这里排序稳定与否并没有区别。

对原数组进行排序后，然后开始遍历排序后的数组，这里注意不是遍历到最后一个停止，而是到倒数第三个就可以了。这里可以先做个剪枝优化，就是当遍历到正数的时候就 break，因为数组现在是有序的了，如果第一个数就是正数，则后面的数字就都是正数，就永远不会出现和为0的情况了。然后还要加上重复就跳过的处理，处理方法是从第二个数开始，如果和前面的数字相等，就跳过，不想把相同的数字  fix 两次。对于遍历到的数，用0减去这个 fix 的数得到一个 target，然后只需要再之后找到两个数之和等于 target 即可。

用两个指针分别指向 fix 数字之后开始的数组首尾两个数，如果两个数和正好为 target，则将这两个数和 fix 的数一起存入结果中。然后就是跳过重复数字的步骤了，两个指针都需要检测重复数字。如果两数之和小于 target，则将左边那个指针i右移一位，使得指向的数字增大一些。同理，如果两数之和大于 target，则将右边那个指针j左移一位，使得指向的数字减小一些，代码如下，这次给出的C++和java的代码，对于C则需要处理二级指针，写起来很麻烦，有时间理解了再补上来。

# 代码

## C++

```cpp

class Solution 
{
public:
    vector<vector<int>> threeSum(vector<int>& nums) 
    {
        vector<vector<int>> res; //初始化vector变量res，vector当中存储的是int型的vector
        sort(nums.begin(), nums.end()); //排序
        if (nums.empty() || nums.back() < 0 || nums.front() > 0) return {};  //如果数组为空或者数组的最大值小于0或者数据的最小值大于0，直接返回
        for (int k = 0; k < (int)nums.size() - 2; ++k) 
        {
            if (nums[k] > 0) break; //遍历到正数的时候跳出循环
            if (k > 0 && nums[k] == nums[k - 1]) continue; //遍历到重复的时候先跳过
            int target = 0 - nums[k], i = k + 1, j = (int)nums.size() - 1; //设置双指针，i为第k个元素之后的元素，j为数组最末尾的元素
            while (i < j) // 第二重循环的条件就是i<j，这是使用双指针这个trick的常规操作
            {
                if (nums[i] + nums[j] == target) //找到元素对
                {
                    res.push_back({nums[k], nums[i], nums[j]});  //将元素序列推到res当中
                    while (i < j && nums[i] == nums[i + 1]) ++i; //从小到大遍历，跳过重复元素
                    while (i < j && nums[j] == nums[j - 1]) --j; //从大到小遍历，跳过重复元素
                    ++i; --j; //指针遍历
                } 
                else if (nums[i] + nums[j] < target) ++i; //如果未找到且整体三个元素<0，则i++
                else --j; //如果未找到且整体三个元素>0，则j--
            }
        }
        return res;
    }
};
``` 

## java

```java
class Solution 
{
    public List<List<Integer>> threeSum(int[] A) 
    {
        List<List<Integer>>res = new ArrayList<List<Integer>>();
	    if (A == null || A.length == 0)
		    return res;
	    Arrays.sort(A);
	    for (int i = 0; i < A.length; i++) 
        {
		    if (i - 1 >= 0 && A[i] == A[i - 1]) continue;// Skip equal elements to avoid duplicates

            int left = i + 1, right = A.length - 1; 
		    while (left < right) 
            {// Two Pointers
			    int sum = A[i] + A[left] + A[right];
			    if (sum == 0) 
                { 
				    res.add(Arrays.asList(A[i], A[left], A[right]));
				    while (left + 1 < right && A[left] == A[left+1])// Skip equal elements to avoid duplicates
					    left++;
                    while (right -1 > left && A[right] == A[right-1])// Skip equal elements to avoid duplicates
					    right--;
                    left++; 
				    right--;
                } 
                else if (sum < 0) 
                { 
				    left++;
                } 
                else 
                {
				    right--;
                }
            }
	    }
	    return res;
    }
}

``` 
