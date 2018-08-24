---
title: >-
  How to think in graphs: Anillustrative introduction to Graph Theory and its
  applications
date: 2018-08-23 14:01:11
categories: 图论
tags: 
- 图论
- 图挖掘算法
description: 翻译自FreeCodeCamp，从应用的角度介绍图论及图挖掘常用算法和实现。
---
最近因为工作的需要，接触了一些复杂网络分析方面的东西，追根溯源到图数据库、图论等方面的理论和应用，在medium上面看到[这篇文章](https://medium.freecodecamp.org/i-dont-understand-graph-theory-1c96572a1401)不错，为了更好的吸收文章的内容，索性把它翻译一遍以飨读者。

图论是计算机领域最重要、最有趣的研究课题之一。但是同时，也是最难理解的之一，至少对我来说是这样子的。

记住，使用图并像图一样思考，可以让我们成为更好的程序员。至少，那是我们所应该的思考方式。一张图由一个节点集合V和边集合E有序构成，记做G=(V,E)。

当我试着去学习图论并实现一些算法的时候，通常会被卡主，只是因为那太乏味了。

理解东西的最好方式就是从理解它的应用开始。在这篇文章当中，我们会去证明图论的各种应用。但是更重要的诗，这些应用会包含详细的说明。现在让我们开始并深入了解吧。

![He meant Monte Cristo](https://cdn-images-1.medium.com/max/1000/1*Oq1WosxCfpi8N8tIRhSlWQ.png)

# 目录

- 声明

- Königsberg七桥问题

- 图描述：Intro

- 图描述和二叉树简介（Airbnb例子）

- 图描述：Outro

- Twitter例子：tweet发送问题

- 图算法：Intro

- Netflix和Amazon：索引反转例子

- 遍历：DFS和BFS

- Uber和最短路径问题（Dijkstras算法）

## 声明

**声明1**：我不是计算机科学、算法、数据结构，特别的图理论方面的专家。我也没有参与本文所讨论公司的相关项目。本文给出的解决方案也不是最终方案，可能会有彻底地优化。如果你发现任何不合理的地方，非常欢迎留言讨论。如果你在提到的公司上班或者参与过相关的软件项目，请回复实际的解决方案，这非常有利于他人。其它方面，请做一名耐心的读者，这篇文章相当长。

**声明2**：本文从某种程度上与它所提供的信息在类型上有些不同。有时候看起来与子标题有些偏离，但是耐心的读者最终会对大框架有一个完整的认识。

**声明3**：本文是为广大的程序员所写。目前读者群是初级程序员，我喜欢对于有经验的程序员读起来也同样有趣。

## Seven Bridges of Königsberg

让我们从常规介绍图论的教科书所讨论的“图论的起源”——[Seven Bridges of Königsberg](https://en.wikipedia.org/wiki/Seven_Bridges_of_K%C3%B6nigsberg)开始。在[Kaliningrad](https://en.wikipedia.org/wiki/Kaliningrad)有7座桥连接两个被Pregolya河所围绕的大岛河被同一条河流分开的两部分陆地。

![Our area of interest](https://cdn-images-1.medium.com/max/800/1*Yiwa1Lzpj6XHAXW3G9KcqA.png)

在18世纪的时候，这里叫做Königsberg，普鲁士的一部分，并且这部分地区有更多地桥。关于Königsberg的桥的问题或者是脑力测试是是否能够当且仅当穿越每座桥一次然后漫步这座城市。那时候还没有网络连接，因此这个应该是比较有趣的。下图是18世纪Königsberg七桥问题的示意图。

![Seven bridges of Königsberg](https://cdn-images-1.medium.com/max/800/1*_8_S3LGba5fYlF9epPXPAA.png)

你可以试一试。看看能不能当且仅当穿越每座桥一次然后漫步这座城市。

- 必须穿越每座桥；

- 穿越每座桥的次数不能超过一次。

如果你对这个问题非常熟悉，你应该知道这是不可能实现的。无论你如何努力，最终你都会放弃。

让我们试着理解一下欧拉是怎么理解以及他是如何给出解决方案的（如果最终无解，仍然需要一个证明）。这着实是一个挑战，因为重复一遍这位值得尊敬的数学家的思考过程不是一件很有荣誉感的事情。（如此尊敬以至于[Knuth和他的朋友在他们的书](https://www.amazon.com/Concrete-Mathematics-Foundation-Computer-Science/dp/0201558025/)向[欧拉](https://en.wikipedia.org/wiki/Leonhard_Euler)致敬）。让我们从画出它的不可能开始吧。

![Impossible](https://cdn-images-1.medium.com/max/1000/1*RPIPDVcZbWM0hy519YoZIA.png)

这里有4个独自的地方，两个岛屿和两部分陆地。还有7座桥。探索一下岛屿和陆地连接桥梁的数目是否有一些模式在里面将会非常有趣（后面我们会使用“陆地”来表示四块不同的地方）。

[Number of bridges](https://cdn-images-1.medium.com/max/800/1*TQzVW18ZSpYIuOFY5ZJJJg.png)

粗略地看，这里好像是有着某种意义上的规律。每一块陆地都有奇数座桥梁与它相连。如果你必须穿越每座桥梁一次的话，那么你可以进入一块陆地然后离开它，如果它有两座桥梁与它相连的话。

![EXAMPLES OF 2 bridige lands](https://cdn-images-1.medium.com/max/600/1*jDQ0LcOdE1Ln3_27yVcnJg.png)

![EXAMPLES OF 2 bridige lands](https://cdn-images-1.medium.com/max/400/1*tqshIPv13IkTZIZaFIej_Q.png)

![EXAMPLES OF 2 bridige lands](https://cdn-images-1.medium.com/max/400/1*Vs7ZeH7lHhAAXGLXH2Lyhw.png)

从上面的示意图当中可以明显地看出，如果你通过穿越一座桥进入一块陆地的时候，你一定能穿越第二座桥而离开它。当第三座桥出现的时候，你不可以通过穿越与这块陆地相连的所有桥而离开这块陆地。如果你试着去总结对于一块单一的陆地的原理的时候，你会明显地得到，在有偶数座桥的情况下，通常是可以离开陆地的，反之如果是奇数座桥则不可能。试着在你的脑海当中捋一捋！

让我们加一个桥看看所有连接桥的变化以及是否能够解决这个问题。

![Notice the new bridge](https://cdn-images-1.medium.com/max/800/1*olODXmFJsEj28jF70Sg9dw.png)

现在我们分别有两个偶数（4，4）和两个奇数（3，5）个桥连接着四块陆地，让我们用这座额外的桥画一条新的路线。

![Wow](https://cdn-images-1.medium.com/max/800/1*0tIgvHoB7uGpedZx1ZnLug.png)

我们可以看出在决定方案是否可行时连接桥数的奇偶性扮演重要的角色。这里有一个问题。连接桥数能够解决这个问题吗？每次都需要偶数次吗？深入探索发现并不是这样的。那正是欧拉做的事情。他发现连接桥数确实有关系。并且更有趣的时，奇数连接桥数的陆地的数量也有关系。这正是欧拉开始将陆地和桥梁“转换”到我们现在所知道的图。这里有一些图能够代表Königsberg七桥问题的示意（注意我们临时加入的桥并不在其中）。

![Lines are a bit twisty](https://cdn-images-1.medium.com/max/800/1*DZ0h0t88ZtzLNQhgalPztg.png)

在抽象这个问题的时候有一个重要的时间需要注意。**当你解决一个特定的问题的时候，最重要的事情是能够将解决方案推广到类似的问题上去。**在这个特别的案例当中，欧拉的任务是将过桥问题一般化，然后能够在未来解决类似的问题，比如这个世界所有的桥。可视化也有助于从不同的角度来看这个问题。下面的几张图是上述Königsberg七桥问题的几种不同表示方式。

![various representations](https://cdn-images-1.medium.com/max/800/1*h8-Y7kfLY81IeZ61y6RhPA.png)

的确，对于图像方面的问题可视化图确实是一个好的选择。现在我们需要梳理图论的方法是如何解决Königsberg问题的。请注意从每一个圆中出来的线条数。让我们先给它们一个专业一些的名字吧，从现在开始，我们称它们为节点（vertices），连接它们的线条称之为边（edges）。你应该已经发现之前我们使用的字母缩写，**V**代表vertex，**E**代表edge。

![vertex和edge示意](https://cdn-images-1.medium.com/max/800/1*UlIW_fTvf-URBTJHFU-mDg.png)

下面比较重要的概念是节点（vertex）的度（degree），连到每个节点边的个数。在上面的例子当中，每块陆地连接桥数可以用图上各个节点的度来表示。

![degree concept](https://cdn-images-1.medium.com/max/800/1*ESq5g9Vi988AHHXTA1cfLw.png)

在欧拉的努力工作下，证明遍历图（城市）中每条边（桥）一次且仅为一次的可能性取决于每个节点（陆地）的度。为了向欧拉致敬，这种包括这些边的路径叫做**欧拉路径**。欧拉路径的长度是它所含的边数。显卡开始看一些更为严谨一些的语言。

> 一个有限无向图G(V,E)的欧拉路径是G的每条边只出现一次的路径。如果G中存在一条欧拉路径，那么可以叫做欧拉图。[1]

> **定理**。一个有限无向图当前仅当正好两个节点为奇数度或者所有节点为偶数度时才是欧拉图。在后面这种情况下，每一个图的欧拉路径都是一个回路，在前面的情况下，没有回路。[1]

![Exatly two vertices have an odd degree in the illustration at the left，and all vertices are of an odd degree in illustration at the right](https://cdn-images-1.medium.com/max/600/1*v-TkQFTU_sNzgKJiyDkkwA.png)

![Exatly two vertices have an odd degree in the illustration at the left，and all vertices are of an odd degree in illustration at the right](https://cdn-images-1.medium.com/max/600/1*mq6Gk_irYP3jwEIk33apqA.png)

我根据参考书[1]的定义用”Euler path”代替“Eulerian path”。如果你知道这两者之间的区别，请留言分享。

首先，我们来澄清一下上面定义和定理当中出现的一些新概念：

- **无向图**：由无特定方向的边组成的图

- **有向图**：由有特定方向的边组成的图

- **连接图**：不包含未触达节点的图，任意两个节点之间必须有一条路径

- **未连接图**：包含未触达节点的图，并不是任意两个节点之间都存在一条连通路径

- **有限图**：包含有限的节点和边的图

- **无限图**：在特定方向上趋向于无穷出的图

在下面的一些段落当中我们会讨论上述的一些概念。

图可以是有向的也可以是无向的，这是一个非常有趣的特性。相信大部分人都了解Facebook vs Twitter这个非常流行的关于有向和无向的例子。Facebook的好友关系可以简单地用无向图来表示，因为加入Alice是Bob的朋友，那么Bob必然也是ALice的朋友。这是无向的，双方互相好友。

![undirected Graph](https://cdn-images-1.medium.com/max/800/1*NsSbLC2ssMmNIUTBl3jrnQ.png)

同样可以看到打上”Patrick”标签的节点，比较特殊（他没有朋友），因此没有任何边与之相连。考虑到他仍然是图的一部分，在这种情况下，我认为这张图是没有连接的，是一张未连接图（**disconnected graph**）。在连接图当中，不会有不可触达的节点，任意两个节点之间必须有一条路径相连。

与Facebook例子相对应的诗，如果Alice在Twitter上关注了Bob，并不需要Bob也同样的关注Alice。因此“关注”的关系必然是有方向的，一个顶点（用户）通过一个有向的边（关注）连向另外一个节点。

![directed Graph](https://cdn-images-1.medium.com/max/800/1*NogzJ2ZbrTrwh43ph-XAIQ.png)

现在，让我们了解下什么是一张有限连接无向图，先回到欧拉图：

![Euler Graph](https://cdn-images-1.medium.com/max/800/1*h_S6hGd0Y1uDl9Pltn8QYw.png)

我们为什么将Königsberg七桥问题和欧拉图放在一起讨论呢？显然，这样不会显得那么无聊，通过一步步探索这个问题慢慢得到解决方案的过程我们避免太干巴巴的理论，但又达到了接触到图后面的各种元素（节点，边，有向，无向）的目的。不过我们还有没有完成欧拉图和上面的问题。

接下来我们要切换到图的计算机层面的表示，那才是我们程序员最感兴趣的话题。在一个计算机程序当中表示一个图，我们可以设计一个记录图路径的算法，然后判断它是不是欧拉图。在那之前，试着想一想欧拉图的一个好的应用场景（暂且撇开繁琐的桥问题）。

## Graph Representation：Intro

这是一个冗长复杂的任务，需要一些耐心。还记得数组（Arrays）和链表（Linked Lists）之间的比较吗？如果你需要快速的访问元素使用数组，如果你需要快速的插入/删除使用链表。我相信你曾经也一度面对诸如“如何表示列表”的事情挣扎过。在图的案例当中，因为首先你需要决定如何精确地表现图，图的实际表现会更加复杂。链接列表、矩阵矩阵，或者边列表？扔个硬币来决定吧。

你本应该努力地扔，因为我们将从树开始。你应该接触过二叉树（BT）至少一次（下面不是二分查找树）。

![just a sample](https://cdn-images-1.medium.com/max/800/1*xWoN44k1_pdTG8PwZeutxw.png)

因为它也是由节点和边构成，也是一张图。你至少也能够回忆起二叉树通常所表示的数据（至少在教科书里所提及的）。

```cpp
struct BinTreeNode
{
  T value; // don't bother with template<>
  TreeNode* left;
  TreeNode* right;
};
class BinTree
{
public:
  // insert, remove, find, bla bla
private:
  BinTreeNode* root_;
};
```

对于已经熟悉二叉树的人来说这看起来太基础了，但我仍然要描述它以确认我们大家在一个频道上面（注意我处理的依然是伪代码）。

```cpp
BinTreeNode<Apple>* root = new BinTreeNode<Apple>("Green");

root->left = new BinTreeNode<Apple>("Yellow");
root->right = new BinTreeNode<Apple>("Yellow 2");

BinTreeNode<Apple>* yellow_2 = root->right;

yellow_2->left = new BinTreeNode<Apple>("Almost red");
yellow_2->right = new BinTreeNode<Apple>("Red");
```

如果你刚开始认识树，请仔细阅读上述的伪代码，然后跟着以下说明的步骤。

![Colors are just for bright visualization](https://cdn-images-1.medium.com/max/1000/1*qGSs9H5TJrkC226E1Tr5bA.png)

一个二叉树是一个简单的节点“集合（collection）”，每一个节点都有左右子节点。二分搜索树在应用一些简单规则的时候在快速查询当中非常有用。二分搜索树（BST）将它们的键值进行排序。你可以自由地实现基于任何规则的二叉树，甚至可以进行名字的变更。对BST最大的期望是能够满足**二分搜索**的特性（这也是它的名字来源）。任意节点的键值必须比它的左边节点的键值大，而比它的右边键值小。

关于”大于”的表述有一点非常有趣，这是理解BST的关键。当你把这个特性改成“大于或者等于”，你的BST可以保存插入地等值新节点，或者它仅保留独二无一值的节点。关于BST你可以在网上找到非常好的文章。我们不打算提供BST的完整实现，为了一致性的缘故，我们展示一个简单的BST。

![BST](https://cdn-images-1.medium.com/max/800/1*gb8tsJ_MOTcIvZlYC2HkmQ.png)

### Intro to Graph representation and binary trees(Airbnb example)

树是非常有用的数据结构。你可能还没有过在项目从头实现一个树的经验。但是你不经意间很可能已经使用它们。让我们看一个人工但有价值的示例，并尝试回答“为什么”问题，“为什么首先使用二叉搜索树”。

正如之前注意到，在BST当中有个“搜索”。基本的，任何你需要能够快速的查找的东西，应该放在BST当中。






