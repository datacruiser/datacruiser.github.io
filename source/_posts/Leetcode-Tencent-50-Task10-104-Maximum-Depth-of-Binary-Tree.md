---
title: Leetcode Tencent 50 Task10 104. Maximum Depth of Binary Tree
date: 2019-08-13 15:15:07
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 树
description: DataWhale暑期学习小组-LeetCode刷题第八期Task10。
---

# 描述

给定一个二叉树，找出其最大深度。

二叉树的深度为根节点到最远叶子节点的最长路径上的节点数。

说明: 叶子节点是指没有子节点的节点。

**示例：**


给定二叉树 `[3,9,20,null,null,15,7]，`


```
    3
   / \
  9  20
    /  \
   15   7
```


返回它的最大深度 3 。

来源：力扣（LeetCode）
链接：[104. Maximum Depth of Binary Tree](https://leetcode-cn.com/problems/maximum-depth-of-binary-tree)


# 解题思路

本题考察二叉树，一看到树，首先要想到递归。

我们知道一棵二叉树的高度（Height）是其根节点的高度，而根节点的高度是其左子树高度$H_L$和右子树$H_R$两者中的最大值加1.因此可采用二叉树遍历的原理，递归地计算出二叉树的高度。而要活的根节点的高度，首先要获得其左右子树的高度，所以需要采用后序遍历，即先遍历每个根节点的左子树，然后遍历每个根节点的右子树，最后遍历根节点自己。

最后需要注意的是，根据定义，单个叶节点的高度为1，所以空树的高度为0，最后需要判断是否为空树，如果是空树则返回0。

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


int maxDepth(struct TreeNode* root){
    
    int HL = 0, HR = 0, MaxH = 0;   //初始化变量
    
    if(root){                       //如果树不为空 
        HL = maxDepth(root->left);  //求左子树的高度
        HR = maxDepth(root->right); //求右子树的高度
        MaxH = HL > HR ? HL:HR;     //取左右子树较大的高度
        return (MaxH + 1);          //返回树的高度
            
        }
    
    else 
        return 0;                  //空树则返回0
}
``` 
