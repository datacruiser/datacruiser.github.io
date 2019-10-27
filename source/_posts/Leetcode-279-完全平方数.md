---
title: Leetcode-279. 完全平方数
date: 2019-10-27 18:08:01
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 数学
- 广度优先搜索
- 动态规划
description: Leetcode刷题系列.
---

# 描述

给定正整数 n，找到若干个完全平方数（比如` 1, 4, 9, 16, ...`）使得它们的和等于 n。你需要让组成和的完全平方数的个数最少。

**示例 1:**

```c
输入: n = 12
输出: 3 
解释: 12 = 4 + 4 + 4.
```

**示例 2:**

```c
输入: n = 13
输出: 2
解释: 13 = 4 + 9.
```

来源：力扣（LeetCode）
链接：[279. Perfect Squares](https://leetcode-cn.com/problems/perfect-squares)

# 解题思路

这道题和之前的[322. 零钱兑换](http://datacruiser.io/2019/10/24/Leetcode-322-%E9%9B%B6%E9%92%B1%E5%85%91%E6%8D%A2/)这道题神似，可以将完全平方数当作各种可能用来组合的零钱，利用动态规划进行求解应该也是常规方法。不过本题的考察点除此之外，也是另有玄机的。比如[四平方和定理](https://zh.wikipedia.org/wiki/%E5%9B%9B%E5%B9%B3%E6%96%B9%E5%92%8C%E5%AE%9A%E7%90%86)。

## 数学思路

说实话，第一次听说这个定理，这个定理主要是说**每个正整数均可表示为4个整数的平方和**，其实是可以表示为4个以内的平方数之和，那么就是说返回结果只有 1,2,3 或4其中的一个。

首先我们将数字简化一下，由于一个数如果含有因子4，那么我们可以把4都去掉，这样并不会影响结果，比如将8变成2，个数都是2，把12变成3，个数都是3，返回的结果都相同。另外一个可以化简的地方就是如果一个数除以8余7的话，那么肯定是由4个完全平方数组成，具体俺也不会证明。

接下来尝试将其拆分为两个平方数之和，如果拆成功了那么就会返回1或者2，因为其中一个平方数可能为0。

具体的代码实现请见解法一。

注意下面的 `!!a + !!b` 这个表达式，可能很多人不太理解这个的意思，其实很简单，感叹号!表示逻辑取反，那么一个正整数逻辑取反为0，再取反为1，所以用两个感叹号!!的作用就是看a和b是否为正整数，都为正整数的话返回2，只有一个是正整数的话返回1。

解法一是纯数学的角度，除此之外依然可以用动态规划的解法来做。

## 动态规划

### 找子问题

我们建立一个长度为`n+1`的一维数组`dp`，其中`dp[i]`代表到数字`i`组成最少完全平方个数，如果把`dp`数组都求解出来了，那么原问题也就迎刃而解了，其值即为`dp[n]`。

### 确定状态

子问题只和一个变量--数字的位置相关。因此，序列中数的位置`i`就是**状态**，而状态`i`对应的值，就是组成正整数`n`所需要的最少完全平方数的个数。显然，状态一共有`n+1`个。

### 找出状态转移方程

假设`dp[i]=x`，则表示组成正整数`i`的最少完全平方数是`x`个，我们现在看看`dp[i + j * j]`会是如何，如果从正整数`i + j * j`的状态转移到正整数`i`的状态。 显然，因为要求最小值，`dp[i + j * j]`是其本身与`dp[i] + 1`两者之间较小的值，因为`i + j * j`比起`i`，起码会多一个完全平方数`j`。

### 初始状态

`dp`数组按如下要求进行初始化：
- `dp[0] = 0`
- 其余初始化为`INT_MAX`

具体代码见解法二。

需要注意的是这里的写法，`i`必须从0开始，到`n`结束，是[0,n]的闭区间。`j`必须从1开始，因为我们的初衷是想用 `dp[i]` 来更新 `dp[i + j * j]`，如果 i=0, j=0 了，那么 dp[i] 和 dp[i + j * j] 就相等了，怎么能用本身` dp` 值加1来更新自身。

## BFS广度优先解法

下面再来看一个BFS的解法，第一次在题解当中抄BFS的解法，首先还是先让自己弄懂，但是在MOOC听了一遍以后就一直懵懵懂懂的状态。

可以看作从根节点0出发，往下搜索子节点，找到匹配则返回深度即可，相当于最短路径，即BFS广度优先搜索。

每层节点的子节点分别为父节点加上$(1, 4, 9, 16....(i^2 < n)$ 。使用队列存储节点，每次遍历前先获取当层节点数，即队列长度。然后依次遍历该节点子节点，如果长度符合则返回，不符合且是第一次访问，则添加到队列中去，如果已经访问过，则不需要添加。需要额外的哈希数组，用来存储访问过的元素，队列和哈希数组总共需要额外的2N的空间。搜索图如下：

![搜索图](https://pic.leetcode-cn.com/fade3888433f7428772b99ebc783a7df63cc26fd23378a3814059eca27a2a8a8-%E5%AE%8C%E5%85%A8%E5%B9%B3%E6%96%B9%E6%95%B0.png)

具体代码见解法三。

# 代码

## 解法一

```c
int numSquares(int n)
{
    while (n % 4 == 0) 
    {
        n /= 4;
    }
    
    if (n % 8 ==7)
        return 4;
    
    for (int a = 0; a * a <= n; a++)
    {
        int b = sqrt(n - a * a);
        if(a * a + b * b == n)
        {
            return !!a + !!b;
        }
    }
    
    return 3;
}
```

## 解法二

```c
int min(int a, int b)
{
    if (a > b)
        return b;
    else 
        return a;
}

int numSquares(int n)
{
    int dp[n+1];
    dp[0] = 0;
    
    for (int i = 1; i <= n; i++)
        dp[i] = INT_MAX;
    
    for (int i = 0; i <= n; i++)
    {
        for (int j = 1; i + j * j <= n; j++)
        {
            dp[i + j * j] = min(dp[i] + 1, dp[i + j * j]);
        }
    }
    
    return dp[n];
}
```

## 解法三

```c
/* BFS */

typedef struct {
    int length, max;
    int front, rear;
    int *sq;
} queue;

queue* queueCreate(int k) {
    queue* a;
    if (k < 0)
        return NULL;
    else
        a = (queue*) malloc(sizeof(queue));
    if (!a)
        return NULL;
    else
    {
        a->max = k+1;
        a->length = a->front = a->rear = 0;
        a->sq = (int *)malloc(sizeof(int) * (k+1));
        if (!a->sq)
        {
            free(a);
            return NULL;
        }
        return a;
    }    
}

int enQueue(queue* obj, int value) {
    if (obj->length == (obj->max - 1))
        return 0;
    else
    {
        obj->sq[obj->rear] = value;
        obj->rear = (obj->rear + 1) % obj->max;
        obj->length++;
    }
        
    return 1;
}

int deQueue(queue* obj) {
    int head;
    
    if (obj->front == obj->rear)
        return 0;
    else
    {
        head= obj->front;
        obj->front = (obj->front + 1) % obj->max;
        obj->length--;
        return obj->sq[head];
    }
}

int queueLength(queue *obj)
{
    return obj->length;
}


int isEmpty(queue* obj) {
     if (obj->front == obj->rear)
        return 1;
    else
        return 0;
}

int isFull(queue* obj) {
    if (obj->length == obj->max - 1)
        return 1;
    else
        return 0;
}

void queueFree(queue* obj) {
    free(obj->sq);
    free(obj);
    return;
}


int numSquares(int n){
    int i,j,next, curr, size, steps = 0, *visited;
    queue *q;
    
    if (n == 0 || n == 1)
        return n;
    
    q = queueCreate(n + 1);
    visited = (int *)malloc(sizeof(int) * (n+1));
    for (i = 0; i <= n; i++)
        visited[i] = 0;
    
    //根节点入队列
    enQueue(q, 0);
    visited[0] = 1;
    
    while(!isEmpty(q))
    {
        //深度加一
        steps++;
        size = queueLength(q);
        for (i = 0; i < size; i++)
        {
            //遍历子节点
            curr = deQueue(q);
            for (j = 1; j * j <= n; j++)
            {
                next = curr + j*j;
                if (next == n) return steps;
                if (next > n) break;
                if (visited[next]) continue;
                //加入队列，以待访问其子节点
                visited[next] = 1;
                enQueue(q, next);
            }
        }
    }
    queueFree(q);
    free(visited);
    return steps;

}
```


# 参考

- [[LeetCode] 279. Perfect Squares 完全平方数](https://www.cnblogs.com/grandyang/p/4800552.html)
- [c语言 BFS广度优先解法 图解](https://leetcode-cn.com/problems/perfect-squares/solution/cyu-yan-bfsyan-du-you-xian-jie-fa-tu-jie-by-mrsonk/)