---
title: Leetcode Tencent 50 Task11 124. Binary Tree Maximum Path Sum
date: 2019-08-16 07:51:40
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 树
---

# 描述

给定一个非空二叉树，返回其最大路径和。

本题中，路径被定义为一条从树中任意节点出发，达到任意节点的序列。该路径至少包含一个节点，且不一定经过根节点。

**示例 1:**

```c

输入: [1,2,3]

       1
      / \
     2   3

输出: 6
```

**示例 2:**

```c

输入: [-10,9,20,null,null,15,7]

   -10
   / \
  9  20
    /  \
   15   7

输出: 42
```

来源：力扣（LeetCode）
链接：[](https://leetcode-cn.com/problems/binary-tree-maximum-path-sum)

# 解题思路

根据题意，可以将二叉树看作一个无向图，路径和就是在这个无向图找到当中任意找到两个顶点然后将它他们连起来，但是每条边只能被通过一次。举个例子：

```c
    4
   / \
  11  2
 / \
7   13
```

这是个简单的例子，我们可以一眼看出最长路径为7->11->13，此时该序列不经过根节点，因为如果要经过根节点，那么必然有边要被通过两次。但是如果将上述二叉树的2和13互换一下，变成下面这个样子：

```c
    4
   / \
  11  13
 / \
7   2
```

那么最长路径为7->11->4->13，此时路径经过根节点，但是对于11这个中间节点来说，它不可能把它的左右两个孩子节点同时带入到最终的路径当中，只能取一个大的，当然，考虑可能节点还会取负值，所以在具体递归函数里面还需要将节点取值与0作比较，即取左子树、右子树、0三者之间的最大值。另外，如果要将中间节点递归结果返回给它的父节点，那么需要返回中间节点本身的值与其左子树递归值和右子树递归值两者中间较大的值，两个子树的递归值本身还需要和0做比较，用表达式可以表示如下：
```c
ans=root.val + max(max(0, MS(root.left)), max(0, MS(root.right)))
```
这里总结一下，对于每个结点来说，我们要知道经过其左子结点的路径之和大还是经过右子节点的路径之和大。那么我们的递归函数返回值就可以定义为以当前结点为根结点，到叶节点的最大路径之和，然后将全局路径最大值的引用放在参数中，用结果 `result` 来表示。

关于递归函数的设计，有以下几种情况：

- 如果当前结点不存在，那么直接返回0
- 左右子节点调用递归函数，由于路径和有可能为负数，而我们当然不希望加上负的路径和，所以我们和0相比，取较大的那个
- 检查是维护旧路径还是创建新路径，维护旧路径就是将结果返回当前节点的父节点，创建新路径就是不返回当前节点的父节点，而是将当前节点的值以及其左右子树的值都加起来：`root.val+max(0,MS(root.left))+max(0,MS(root.right))`
- 更新全局最大值：`result=max(result, root.val+max(0,MS(root.left))+max(0,MS(root.right))`
- 返回维护旧路的值：`return max(root.val + max(max(0, MS(root.left)), max(0, MS(root.right))))`

最后在主函数当中初始化`result`，调用递归函数，再返回`result`。
# 代码


```c
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */

int max(int i, int j)// 辅助比较大小函数
{
	if(i < j)
		return j;
	return i;
}

int maxPathSumRecursive(struct TreeNode* root, int* result)//计算从树根出发的最大路径之和，result是全局最优解
{
	if(!root) return 0; //树为空，则返回0
	int left = max(maxPathSumRecursive(root->left, result), 0); //左子树 到根最大路径
	int right = max(maxPathSumRecursive(root->right, result), 0); //右子树 到根最大路径
	*result = max(*result, left + right + root->val); //对比维持旧路径与新建路径的对比，并更新全局变量
	return max(left, right) + root->val; //返回 到当前节点的父节点的最大路径
}

int maxPathSum(struct TreeNode* root)
{
	int result = INT_MIN; //result是全局最优解，初始值为负无穷
	maxPathSumRecursive(root, &result);  //传入result的引用
	return result;

}
``` 