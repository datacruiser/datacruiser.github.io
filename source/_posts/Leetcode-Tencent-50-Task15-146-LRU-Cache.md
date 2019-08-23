---
title: Leetcode Tencent 50 Task15 146. LRU Cache
date: 2019-08-19 08:20:34
categories: LeetCode 腾讯精选50题
tags:
- 数据结构
- 算法
- C语言
- 设计
description: DataWhale暑期学习小组-LeetCode刷题第八期Task15。
---



# 描述

运用你所掌握的数据结构，设计和实现一个  [LRU (最近最少使用)](https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU) 缓存机制。它应该支持以下操作： 获取数据 `get` 和 写入数据 `put` 。

获取数据 `get(key)` - 如果密钥 (key) 存在于缓存中，则获取密钥的值（总是正数），否则返回 -1。
写入数据 `put(key, value)` - 如果密钥不存在，则写入其数据值。当缓存容量达到上限时，它应该在写入新数据之前删除最近最少使用的数据值，从而为新的数据值留出空间。

**进阶:**

你是否可以在 $O(1)$ 时间复杂度内完成这两种操作？

**示例:**

```c
LRUCache cache = new LRUCache( 2 /* 缓存容量 */ );

cache.put(1, 1);
cache.put(2, 2);
cache.get(1);       // 返回  1
cache.put(3, 3);    // 该操作会使得密钥 2 作废
cache.get(2);       // 返回 -1 (未找到)
cache.put(4, 4);    // 该操作会使得密钥 1 作废
cache.get(1);       // 返回 -1 (未找到)
cache.get(3);       // 返回  3
cache.get(4);       // 返回  4
```


来源：力扣（LeetCode）
链接：[146. LRU Cache](https://leetcode-cn.com/problems/lru-cache)


# 解题思路

设计类的题目都略难，参考几位大神的题解，来整理下我的思路。

## LRU
### 什么是LRU算法

LRU是一种缓存机制，也是一种缓存淘汰策略。

计算机的缓存容量有限，如果缓存满了就要删除一些内容，给新内容腾位置。这里有两个问题：

- 删除哪些内容
- 衡量内容是否删除的依据

而LRU缓存淘汰算法就是一种用来回答以上两个问题的常用策略，LRU全称Least Recently Used，我们把那些最近没有用过的数据删除，换言之，那些最近使用的数据是有价值的，应该被保留的。

### LRU算法描述

LRU 算法实际上是让你设计数据结构：首先要接收一个 `capacity `参数作为缓存的最大容量，然后实现两个 API，一个是 `put(key, val)` 方法存入键值对，另一个是 `get(key) `方法获取 `key `对应的` val`，如果 `key `不存在则返回 -1。

根据题意，`get`和`put`方法都是$O(1)$的时间复杂度。下面一个算法工作的流程：

```c
/* 初始化缓存，分配容量为 2 */
LRUCache cache = new LRUCache(2);
// 你可以把 cache 理解成一个队列
// 假设左边是队头，右边是队尾
// 最近使用的排在队头，久未使用的排在队尾
// 圆括号表示键值对 (key, val)

cache.put(1, 1);
// cache = [(1, 1)]
cache.put(2, 2);
// cache = [(2, 2), (1, 1)]
cache.get(1);       // 返回 1
// cache = [(1, 1), (2, 2)]
// 解释：因为最近访问了键 1，所以提前至队头
// 返回键 1 对应的值 1
cache.put(3, 3);
// cache = [(3, 3), (1, 1)]
// 解释：缓存容量已满，需要删除内容空出位置
// 优先删除久未使用的数据，也就是队尾的数据
// 然后把新的数据插入队头
cache.get(2);       // 返回 -1 (未找到)
// cache = [(3, 3), (1, 1)]
// 解释：cache 中不存在键为 2 的数据
cache.put(1, 4);    
// cache = [(1, 4), (3, 3)]
// 解释：键 1 已存在，把原始值 1 覆盖为 4
// 不要忘了也要将键值对提前到队头

```

## 数据结构及算法设计

- 首先， 要求`get`和`put`都是$O(1)$的时间复杂度， 那么必须要用一个`hashmap`
- 其次，光用`hashmap`无法知道那个元素是最没有被使用过的，通常想要知道某个元素使用的时间顺序，那需要有一个`list`， 然后每次使用(get/put)的时候把这个元素放到`list`的最前面
- 另外，为了确保$O(1)$时间复杂度，需要用`linkedlist`
- 最后，为了在删除`linkedlist`的中间元素时把前后元素都连起来，采用`doublylinkedlist`

具体哈希链表的数据结构如下：

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/DoubleHashLinkedList.png)


# 代码

```c

/**
 * Your LRUCache struct will be instantiated and called as such:
 * LRUCache* obj = lRUCacheCreate(capacity);
 * int param_1 = lRUCacheGet(obj, key);
 
 * lRUCachePut(obj, key, value);
 
 * lRUCacheFree(obj);
*/

//定义哈希函数求余被除数与哈希表容量的倍数关系
#define scale 2

//定义双链表
typedef struct node 
{
    int value; //节点值
    int key;   //节点hash值
    struct node *last;  //指向前向节点
    struct node *next;  //指向后续节点
    bool deleted;       //是否删除标记
} Node;

//用二级指针变量cache来保存链表节点从而实现哈希表
typedef struct
{
    Node **cache;  //保存链表节点
    Node *head;    //头节点
    Node *tail;    //未节点
    int capacity;  //哈希表容量
    int count;     //节点数目
} LRUCache;


//返回参数key对应hash值所在的节点，若cache变量当中无该key所对应的hash值，返回NULL
Node* cacheGet(LRUCache *obj, int key) 
{
    int m = obj->capacity * scale;
    for (int a = 0; a < m; a++) 
    {
        int hash = (key + a) % m;
        Node *nd = obj->cache[hash];
        if (nd != NULL) 
        {
            if (nd->key == key)
            {
                return nd;
            }
        }
        else
        {
            return NULL;
        }
    }
    return NULL;
}

//返回参数key对应的节点的hash，若cache变量当中无该key所对应的节点，返回NULL
int cacheIndex(LRUCache *obj, int key)
{
    int m = obj->capacity * scale;
    for (int a = 0; a < m; a++) 
    {
        int hash = (key + a) % m;
        Node *nd = obj->cache[hash];
        if (nd != NULL)
        {
            if (nd->key == key)
            {
                return hash;
            }
        }
        else
        {
            return hash;
        }
    }
    return -1;
}

//根据key，value健值对初始化一个节点
Node * newNode(int key, int value)
{
    Node *node = calloc(1, sizeof(Node));
    node->key = key;
    node->value = value;
    return node;
}

//将节点移动到哈希链表的末尾
void moveToTail(LRUCache *obj, Node *node) 
{
    if (obj->tail != NULL) 
    {
        Node *tail = obj->tail;
        if (node != tail)   //判断当前节点是不是在哈希链表的尾部节点
        {
            Node *last = node->last; //保存存入节点的之前一个节点指针
            if (last != NULL) 
            {
                last->next = node->next; //
            }
            Node *next = node->next;
            if (next != NULL) 
            {
                next->last = last;
                node->next = NULL;
            }
            tail->next = node;
            obj->tail = node;
            if (obj->head == node) 
            {
                obj->head = next;
            }
            node->last = tail;
        }
    }
    else
    {
        obj->tail = node;
    }
}

//哈希链表初始化
LRUCache* lRUCacheCreate(int capacity) 
{
    LRUCache *cache = calloc(1, sizeof(LRUCache));
    cache->cache = calloc(capacity * scale, sizeof(Node *));
    cache->capacity = capacity;
    return cache;
}

int lRUCacheGet(LRUCache* obj, int key) 
{
    Node *node = cacheGet(obj, key);
    if (node != NULL) 
    {
        if (node->deleted) 
        {
            return -1;
        }
        moveToTail(obj, node);
        return node->value;
    }
    return -1;
}

void lRUCachePut(LRUCache* obj, int key, int value) 
{
    int index = cacheIndex(obj, key);
    if (index >= 0) 
    {
        Node *node = obj->cache[index];
        if (node != NULL) 
        {
            if (node->deleted) 
            {
                node->deleted = false;
                Node *next = obj->head->next;
                if (next) 
                {
                    next->last = NULL;
                    obj->head->next = NULL;
                    obj->head->deleted = true;
                    obj->head = next;
                }
            }
            node->value = value;
            moveToTail(obj, node);
        }
        else
        {
            node = newNode(key, value);
            obj->count++;
            if (obj->count > obj->capacity) 
            {
                obj->head->deleted = true;
                Node *next = obj->head->next;
                if (next) 
                {
                    next->last = NULL;
                    obj->head->next = NULL;
                    obj->head = next;
                }
                
            }
            moveToTail(obj, node);
            obj->cache[index] = node;
            if (obj->head == NULL) 
            {
                obj->head = node;
            }
        }
    }
    else
    {
        Node *node = obj->head;
        Node *next = node->next;
        if (next != NULL) 
        {
            obj->head = next;
            next->last = NULL;
        }
        node->key = key;
        node->value = value;
        moveToTail(obj, node);
    }
}

void lRUCacheFree(LRUCache* obj) 
{
    int m = obj->capacity * scale;
    for (int a = 0; a < m; a++) 
    {
        Node *node = obj->cache[a];
        if (node != NULL) 
        {
            free(node);
        }
    }
    free(obj->cache);
    free(obj);
}

```