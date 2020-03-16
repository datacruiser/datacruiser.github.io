---
title: Leetcode Tencent 50 Task13 235. Lowest Common Ancestor of a Binary Search Tree
date: 2019-08-17 15:20:05
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 树
description: DataWhale暑期学习小组-LeetCode刷题第八期Task13。
---

# 描述

给定一个二叉搜索树, 找到该树中两个指定节点的最近公共祖先。

[百度百科](https://baike.baidu.com/item/%E6%9C%80%E8%BF%91%E5%85%AC%E5%85%B1%E7%A5%96%E5%85%88/8918834?fr=aladdin)中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

例如，给定如下二叉搜索树:  root = [6,2,8,0,4,7,9,null,null,3,5]

![](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/14/binarysearchtree_improved.png)

    

**示例 1:**

```c
输入: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
输出: 6 
解释: 节点 2 和节点 8 的最近公共祖先是 6。
```


**示例 2:**


```c
输入: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
输出: 2
解释: 节点 2 和节点 4 的最近公共祖先是 2, 因为根据定义最近公共祖先节点可以为节点本身。
```

说明:

- 所有节点的值都是唯一的。
-  p、q 为不同节点且均存在于给定的二叉搜索树中。


来源：力扣（LeetCode）
链接：[235. Lowest Common Ancestor of a Binary Search Tree](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-search-tree)



# 解题思路

这还是一道关于[二叉搜索树](https://zh.wikipedia.org/wiki/%E4%BA%8C%E5%85%83%E6%90%9C%E5%B0%8B%E6%A8%B9)的题，解题的时候肯定要用足二叉树的性质：

- 若任意节点的左子树不空，则左子树上所有节点的值均小于它的根节点的值
- 若任意节点的右子树不空，则右子树上所有节点的值均大于它的根节点的值
- 任意节点的左、右子树也分别为二叉查找树
- 没有键值相等的节点

最重要的性质就是左<根<右，那么根节点的值一直都是中间值，大于左子树的所有节点值，小于右子树的所有节点值。结合公共祖先的定义，和解答函数传入参数的提示，我们可以用递归的思路求解这道题目。

如果根节点的值大于p和q之间的较大值，说明p和q都在左子树，那么此时我们就进入根节点的左子节点继续递归；如果根节点的值小于p和q之间的较小值，说明p和q都在右子树，那么此时我们就进入根节点的右子节点继续递归；如果都不是，则说明当前根节点就是最小共同祖先，直接返回即可。

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

//定义比较求大值者函数
int max(int i, int j){
    if(i < j)
        return j;
    else
        return i;
}

//定义比较求小值者函数
int min(int i, int j){
    if(i < j)
        return i;
    else 
        return j;
}

struct TreeNode* lowestCommonAncestor(struct TreeNode* root, struct TreeNode* p, struct TreeNode* q) {
    if(!root) return NULL; //根节点为空则返回NULL
    if(root->val > max(p->val, q->val))
        return lowestCommonAncestor(root->left, p, q);
    else if(root->val < min(p->val, q->val))
        return lowestCommonAncestor(root->right, p, q);
    else return root; //退出递归
}


``` 

