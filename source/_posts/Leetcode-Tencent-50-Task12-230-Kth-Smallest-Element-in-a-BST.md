---
title: Leetcode Tencent 50 Task12 230. Kth Smallest Element in a BST
date: 2019-08-16 11:15:37
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 树
description: DataWhale暑期学习小组-LeetCode刷题第八期Task12。
---

# 描述

给定一个二叉搜索树，编写一个函数 `kthSmallest` 来查找其中第 `k` 个最小的元素。

说明：
你可以假设 `k `总是有效的，1 ≤ k ≤ 二叉搜索树元素个数。

**示例 1:**

```c
输入: root = [3,1,4,null,2], k = 1
   3
  / \
 1   4
  \
   2
输出: 1
```


**示例 2:**

```c
输入: root = [5,3,6,2,4,null,null,1], k = 3
       5
      / \
     3   6
    / \
   2   4
  /
 1
输出: 3
```


进阶：
如果二叉搜索树经常被修改（插入/删除操作）并且你需要频繁地查找第 `k` 小的值，你将如何优化 `kthSmallest` 函数？



来源：力扣（LeetCode）
链接：[230. Kth Smallest Element](https://leetcode-cn.com/problems/kth-smallest-element-in-a-bst)


# 解题思路

这是一道关于[二叉搜索树](https://zh.wikipedia.org/wiki/%E4%BA%8C%E5%85%83%E6%90%9C%E5%B0%8B%E6%A8%B9)的题，解题的时候肯定要用足二叉树的性质：

- 若任意节点的左子树不空，则左子树上所有节点的值均小于它的根节点的值
- 若任意节点的右子树不空，则右子树上所有节点的值均大于它的根节点的值
- 任意节点的左、右子树也分别为二叉查找树
- 没有键值相等的节点

最重要的性质就是左<根<右，那么结合二叉树的中序遍历，就能够得到的一个有序数组，中序遍历最先遍历到的是最小的结点，那么我们只要用一个计数器，每遍历一个结点，计数器自增1，当计数器到达k时，返回当前结点值即可，这是迭代的解法。此题也可以用递归来解，依然使用中序遍历。


# 代码

## 迭代解法

```c
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */


int kthSmallest(struct TreeNode* root, int k){
    int count = 0;
    int idx = 0;
    struct TreeNode* p = root;
    struct TreeNode* stack[4096]; //定义指针数组 用数组来实现栈
    memset(stack, 0, sizeof(stack)); //给stack变量分配内存空间
    
    
    while (p || idx > 0) { //树不为空 栈不为空
        while (p) {
            stack[idx++] = p; //压栈
            p = p->left;
        }
        p = stack[--idx]; //出栈，同时p指向栈顶
        count++; //计数
        if (count == k) { 
            return p->val; //当计数为k时返回节点值
        }
        p = p->right; // 和前面的p = p->left 结对，组成中序遍历
    }
    
    return 0;
}
``` 

## 递归代码

```c
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */


int inorder(struct TreeNode* root, int* k) 
{
    if (!root) return -1;
    int val = inorder(root->left, k);
    if (*k == 0) return val;
    if (--(*k) == 0) return root->val;
    return inorder(root->right, k);
}


int kthSmallest(struct TreeNode* root, int k) 
{
    return inorder(root, &k); //k为全局变量，引用传递
}
```