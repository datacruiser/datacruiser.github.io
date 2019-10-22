---
title: Leetcode-337. 打家劫舍 III
date: 2019-10-22 16:15:10
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 二叉树
- 深度优先搜索
description: Leetcode刷题系列.
---
# 描述

在上次打劫完一条街道之后和一圈房屋后，小偷又发现了一个新的可行窃的地区。这个地区只有一个入口，我们称之为“根”。 除了“根”之外，每栋房子有且只有一个“父“房子与之相连。一番侦察之后，聪明的小偷意识到“这个地方的所有房屋的排列类似于一棵二叉树”。 如果两个直接相连的房子在同一天晚上被打劫，房屋将自动报警。

计算在不触动警报的情况下，小偷一晚能够盗取的最高金额。

**示例 1:**

```c
输入: [3,2,3,null,3,null,1]

     3
    / \
   2   3
    \   \ 
     3   1

输出: 7 
解释: 小偷一晚能够盗取的最高金额 = 3 + 3 + 1 = 7.
```

**示例 2:**

```c
输入: [3,4,5,1,3,null,1]

     3
    / \
   4   5
  / \   \ 
 1   3   1

输出: 9
解释: 小偷一晚能够盗取的最高金额 = 4 + 5 = 9.
```

来源：力扣（LeetCode）
链接：[337. House Robber III](https://leetcode-cn.com/problems/house-robber-iii)


# 解题思路

这道题是之前两道的[Leetcode-198. 打家劫舍](http://datacruiser.io/2019/10/18/Leetcode-198-%E6%89%93%E5%AE%B6%E5%8A%AB%E8%88%8D/)和[Leetcode-213. 打家劫舍 II](http://datacruiser.io/2019/10/18/Leetcode-213-%E6%89%93%E5%AE%B6%E5%8A%AB%E8%88%8D-II/)拓展，需要注意的是，小偷依然不需要每隔一个偷一次，比如下面这个例子：

```c
       4
       /
      1
     /
    2
   /
  3
```

如果隔一个偷，那么是 4+2=6，其实最优解应为 4+3=7，隔了两个，所以说纯粹是怎么多怎么来，追求利益最大化。

通常，树类的问题，首先想到的是用递归的方法来求解，另外，本题的计算需要依赖之前的结果，可以利用回溯法来做。

对于某一个节点，如果其左子节点存在，通过递归调用函数，算出不包含左子节点返回的值，同理，如果右子节点存在，算出不包含右子节点返回的值，那么该节点的最大值可能有两种情况：
- 该节点值+不包含左子节点和右子节点的返回值之和
- 左右子节点返回值之和不包含当前节点值
- 取以上两者的较大值

具体代码见解法一。

这个解法虽然比较费时，中间有很多重复计算，但是还是可以通过的。

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/337.%20%E6%89%93%E5%AE%B6%E5%8A%AB%E8%88%8D%20III%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-10-22%2022-21-21.png)

参考一下题解当中前排的优秀实现，需要在递归函数当中设置一个中间变量来对每次递归得到的上述两个结果进行保存，并返回一个大小位2的一维数组`res`，其中`res[0]`表示不包含当前节点值的最大值，`res[1]`表示包含当前值的最大值，那么在遍历某个节点的时候，首先对其左右子节点调用递归函数，分别得到包含与不包含左子节点的最大值，和包含与不包含右子节点的最大值，则当前节点的`res[0]`就是其左子节点两种情况中的较大值加上其右子节点两种情况中的较大值，而`res[1]`就是不包含左子节点值的最大值+不包含右子节点值的最大值+当前节点值之和，然后返回`res`。

最后在主函数当中调用递归函数，在返回的2元数组当中求最大值，具体代码见解法二。

其实解法二是一种以空间换时间的方法，看看下面的OJ结果和前面对比就知道了。

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/337.%20%E6%89%93%E5%AE%B6%E5%8A%AB%E8%88%8D%20III%20-%20%E5%8A%9B%E6%89%A3%EF%BC%88LeetCode%EF%BC%89%202019-10-22%2022-21-21.png)


# 代码

## 解法一

```c
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */

typedef struct TreeNode* Tree;

#define max(a, b) ((a)>(b)?(a):(b))

int robsolver(Tree root)
{
     if(!root) return 0;
    
    //当前节点值
    int include = root->val;
    
    //左右子节点返回值之和不包含当前节点值
    int exclude = robsolver(root->left) + robsolver(root->right);
    
    //不包含左子节点的返回值之和，即左子节点的左右子节点返回值之和
    if(root->left)
        include += robsolver(root->left->left) + robsolver(root->left->right);
 
    //不包含右子节点的返回值之和，即右子节点的左右子节点返回值之和
    if(root->right)       
        include += robsolver(root->right->left) + robsolver(root->right->right);
    
    //比较，取两者的最大值
    return max(include, exclude);

}

int rob(Tree root)
{
    return robsolver(root);
}

```

## 解法二

```c
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */

typedef struct TreeNode* Tree;

#define max(a, b) ((a)>(b)?(a):(b))

int* robsolver(Tree root)
{
    int* res = (int *)malloc(2 * sizeof(int));
    //int* left = (int *)malloc(2 * sizeof(int));
    //int* right = (int *)malloc(2 * sizeof(int));
    memset(res, 0, 2 * sizeof(int));
    //memset(left, 0, 2 * sizeof(int));
    //memset(right, 0, 2 * sizeof(int));

    if(!root) return res;
    
    int* left = robsolver(root->left);
    int* right = robsolver(root->right);
    
    res[0] = max(left[0], left[1]) + max(right[0], right[1]);
    res[1] = left[0] + right[0] + root->val;
    
    //free(left);
    //free(right);
    
    return res;

}

int rob(Tree root)
{
    //int* result = (int *)malloc(2 * sizeof(int));
    //memset(result, 0, 2 * sizeof(int));
    
    int* result = robsolver(root);
    
    return max(result[0], result[1]);
    
    //free(result);
    
    //return ret;

}
```



# 参考

- [打家劫舍 官方题解](https://leetcode-cn.com/problems/house-robber/solution/da-jia-jie-she-by-leetcode/)
- [[LeetCode] 198. House Robber 打家劫舍](https://www.cnblogs.com/grandyang/p/4383632.html)

