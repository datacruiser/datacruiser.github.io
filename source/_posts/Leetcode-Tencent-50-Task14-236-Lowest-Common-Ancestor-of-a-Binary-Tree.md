---
title: Leetcode Tencent 50 Task14 236. Lowest Common Ancestor of a Binary Tree
date: 2019-08-17 17:12:55
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 树
description: DataWhale暑期学习小组-LeetCode刷题第八期Task14。
---

# 描述

给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。

[百度百科](https://baike.baidu.com/item/%E6%9C%80%E8%BF%91%E5%85%AC%E5%85%B1%E7%A5%96%E5%85%88/8918834?fr=aladdin)中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

例如，给定如下二叉树:  root = [3,5,1,6,2,0,8,null,null,7,4]

![](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/15/binarytree.png)

    

**示例 1:**

```c
输入: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
输出: 3
解释: 节点 5 和节点 1 的最近公共祖先是节点 3。

```


**示例 2:**


```c
输入: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
输出: 5
解释: 节点 5 和节点 4 的最近公共祖先是节点 5。因为根据定义最近公共祖先节点可以为节点本身。

```

说明:

- 所有节点的值都是唯一的。
-  p、q 为不同节点且均存在于给定的二叉搜索树中。


来源：力扣（LeetCode）
链接：[236. Lowest Common Ancestor of a Binary Tree](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree)



# 解题思路

这道题在上一道题的基础上少了一个搜索的条件，那么原来二叉搜索树的节点值左<根<右的性质就不能用了，但是递归的思路还是可行的：

- 边界条件：
    - 如果`root`为空，则返回`NULL`
    - 如果`root`等于其中某个节点，则返回`root`
- 分而治之
    - `left = lowestCommonAncestor(root->left, p, q)`
    - `right = lowestCommonAncestor(root->right, p, q)`
- 结果返回
    - 如果`left`和`right`都不为空时，说明`p`和`q`一个在`root`的左子树，一个在`root`的右子树，返回`root`
    - 如果只有`left`有返回值，说明`left`的返回值是最小公共祖先
    - 如果只有`right`有返回值，说明`right`的返回值是最小公共祖先


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
struct TreeNode* lowestCommonAncestor(struct TreeNode* root, struct TreeNode* p, struct TreeNode* q) {
    if(!root) return NULL;
    else if(root == q || root == p) return root;
    
    //有可能返回p，q，NULL
    struct TreeNode* left = lowestCommonAncestor(root->left, p, q);
    struct TreeNode* right = lowestCommonAncestor(root->right, p, q);
    
    if(left && right) return root;
    return left ? left:right;
}


``` 