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

让我们从常规介绍图论的教科书所讨论的“图论的起源”——[Seven Bridges of Königsberg](https://en.wikipedia.org/wiki/Seven_Bridges_of_K%C3%B6nigsberg)开始。在[Kaliningrad](https://en.wikipedia.org/wiki/Kaliningrad)有7座桥连通两个被Pregolya河所围绕的大岛河被同一条河流分开的两部分陆地。

![Our area of interest](https://cdn-images-1.medium.com/max/800/1*Yiwa1Lzpj6XHAXW3G9KcqA.png)

在18世纪的时候，这里叫做Königsberg，普鲁士的一部分，并且这部分地区有更多地桥。关于Königsberg的桥的问题或者是脑力测试是是否能够当且仅当穿越每座桥一次然后漫步这座城市。那时候还没有网络连通，因此这个应该是比较有趣的。下图是18世纪Königsberg七桥问题的示意图。

![Seven bridges of Königsberg](https://cdn-images-1.medium.com/max/800/1*_8_S3LGba5fYlF9epPXPAA.png)

你可以试一试。看看能不能当且仅当穿越每座桥一次然后漫步这座城市。

- 必须穿越每座桥；

- 穿越每座桥的次数不能超过一次。

如果你对这个问题非常熟悉，你应该知道这是不可能实现的。无论你如何努力，最终你都会放弃。

让我们试着理解一下欧拉是怎么理解以及他是如何给出解决方案的（如果最终无解，仍然需要一个证明）。这着实是一个挑战，因为重复一遍这位值得尊敬的数学家的思考过程不是一件很有荣誉感的事情。（如此尊敬以至于[Knuth和他的朋友在他们的书](https://www.amazon.com/Concrete-Mathematics-Foundation-Computer-Science/dp/0201558025/)向[欧拉](https://en.wikipedia.org/wiki/Leonhard_Euler)致敬）。让我们从画出它的不可能开始吧。

![Impossible](https://cdn-images-1.medium.com/max/1000/1*RPIPDVcZbWM0hy519YoZIA.png)

这里有4个独自的地方，两个岛屿和两部分陆地。还有7座桥。探索一下岛屿和陆地连通桥梁的数目是否有一些模式在里面将会非常有趣（后面我们会使用“陆地”来表示四块不同的地方）。

[Number of bridges](https://cdn-images-1.medium.com/max/800/1*TQzVW18ZSpYIuOFY5ZJJJg.png)

粗略地看，这里好像是有着某种意义上的规律。每一块陆地都有奇数座桥梁与它相连。如果你必须穿越每座桥梁一次的话，那么你可以进入一块陆地然后离开它，如果它有两座桥梁与它相连的话。

![EXAMPLES OF 2 bridige lands](https://cdn-images-1.medium.com/max/600/1*jDQ0LcOdE1Ln3_27yVcnJg.png)

![EXAMPLES OF 2 bridige lands](https://cdn-images-1.medium.com/max/400/1*tqshIPv13IkTZIZaFIej_Q.png)

![EXAMPLES OF 2 bridige lands](https://cdn-images-1.medium.com/max/400/1*Vs7ZeH7lHhAAXGLXH2Lyhw.png)

从上面的示意图当中可以明显地看出，如果你通过穿越一座桥进入一块陆地的时候，你一定能穿越第二座桥而离开它。当第三座桥出现的时候，你不可以通过穿越与这块陆地相连的所有桥而离开这块陆地。如果你试着去总结对于一块单一的陆地的原理的时候，你会明显地得到，在有偶数座桥的情况下，通常是可以离开陆地的，反之如果是奇数座桥则不可能。试着在你的脑海当中捋一捋！

让我们加一个桥看看所有连通桥的变化以及是否能够解决这个问题。

![Notice the new bridge](https://cdn-images-1.medium.com/max/800/1*olODXmFJsEj28jF70Sg9dw.png)

现在我们分别有两个偶数（4，4）和两个奇数（3，5）个桥连通着四块陆地，让我们用这座额外的桥画一条新的路线。

![Wow](https://cdn-images-1.medium.com/max/800/1*0tIgvHoB7uGpedZx1ZnLug.png)

我们可以看出在决定方案是否可行时连通桥数的奇偶性扮演重要的角色。这里有一个问题。连通桥数能够解决这个问题吗？每次都需要偶数次吗？深入探索发现并不是这样的。那正是欧拉做的事情。他发现连通桥数确实有关系。并且更有趣的时，奇数连通桥数的陆地的数量也有关系。这正是欧拉开始将陆地和桥梁“转换”到我们现在所知道的图。这里有一些图能够代表Königsberg七桥问题的示意（注意我们临时加入的桥并不在其中）。

![Lines are a bit twisty](https://cdn-images-1.medium.com/max/800/1*DZ0h0t88ZtzLNQhgalPztg.png)

在抽象这个问题的时候有一个重要的时间需要注意。**当你解决一个特定的问题的时候，最重要的事情是能够将解决方案推广到类似的问题上去。**在这个特别的案例当中，欧拉的任务是将过桥问题一般化，然后能够在未来解决类似的问题，比如这个世界所有的桥。可视化也有助于从不同的角度来看这个问题。下面的几张图是上述Königsberg七桥问题的几种不同表示方式。

![various representations](https://cdn-images-1.medium.com/max/800/1*h8-Y7kfLY81IeZ61y6RhPA.png)

的确，对于图像方面的问题可视化图确实是一个好的选择。现在我们需要梳理图论的方法是如何解决Königsberg问题的。请注意从每一个圆中出来的线条数。让我们先给它们一个专业一些的名字吧，从现在开始，我们称它们为节点（vertices），连通它们的线条称之为边（edges）。你应该已经发现之前我们使用的字母缩写，**V**代表vertex，**E**代表edge。

![vertex和edge示意](https://cdn-images-1.medium.com/max/800/1*UlIW_fTvf-URBTJHFU-mDg.png)

下面比较重要的概念是节点（vertex）的度（degree），连到每个节点边的个数。在上面的例子当中，每块陆地连通桥数可以用图上各个节点的度来表示。

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

- **连通图**：不包含未触达节点的图，任意两个节点之间必须有一条路径

- **未连通图**：包含未触达节点的图，并不是任意两个节点之间都存在一条连通路径

- **有限图**：包含有限的节点和边的图

- **无限图**：在特定方向上趋向于无穷出的图

在下面的一些段落当中我们会讨论上述的一些概念。

图可以是有向的也可以是无向的，这是一个非常有趣的特性。相信大部分人都了解Facebook vs Twitter这个非常流行的关于有向和无向的例子。Facebook的好友关系可以简单地用无向图来表示，因为加入Alice是Bob的朋友，那么Bob必然也是ALice的朋友。这是无向的，双方互相好友。

![undirected Graph](https://cdn-images-1.medium.com/max/800/1*NsSbLC2ssMmNIUTBl3jrnQ.png)

同样可以看到打上”Patrick”标签的节点，比较特殊（他没有朋友），因此没有任何边与之相连。考虑到他仍然是图的一部分，在这种情况下，我认为这张图是没有连通的，是一张未连通图（**disconnected graph**）。在连通图当中，不会有不可触达的节点，任意两个节点之间必须有一条路径相连。

与Facebook例子相对应的诗，如果Alice在Twitter上关注了Bob，并不需要Bob也同样的关注Alice。因此“关注”的关系必然是有方向的，一个顶点（用户）通过一个有向的边（关注）连向另外一个节点。

![directed Graph](https://cdn-images-1.medium.com/max/800/1*NogzJ2ZbrTrwh43ph-XAIQ.png)

现在，让我们了解下什么是一张有限连通无向图，先回到欧拉图：

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

正如之前注意到，在BST当中有个“搜索”。基本的，任何你需要能够快速的查找的东西，应该放在BST当中。”应该”并不代表着必须，在编程当中需要记住的最重要的事情是用合适的工具解决问题。有大量的案例更欢迎O(N)查找复杂度的链表，而不是O(logN)查找复杂度的BST。

通常我们会用一个实现BST的库，比如C++当中的std::set或者std::map。不过在这个教程当中我们乐意去重新造我们自己的轮子。BST在大部分的通用编程语言当中都有实现。你可以你所希望的编程语言的文档当中找到。下面是一个“真实的例子”，这是我们要解决的问题——Airbnb房子搜索。

![A glimpse on Airbnb Homes Search](https://cdn-images-1.medium.com/max/1000/1*2WwX3k9JJHeLX2d8hYz39Q.png)

我们如何通过基于一些过滤条件的查询尽可能快地查询到合适的房子。这是一个困难的任务。考虑到Airbnb保存了将近[400万的可选房子](https://press.airbnb.com/app/uploads/2017/08/4-Million-Listings-Announcement-1.pdf)就更难了。

![Airbnb Fast Facts](https://cdn-images-1.medium.com/max/800/1*-FXZCO9EfVU5cpt-UbsK3Q.png)

因此当一个用户搜索房子的时候，他有机会“接触”数据库当中400万的记录。当然，用户是从来没有足够”好奇心”去看上百万的数据的，结果将限制在网页上面能够显示的排前的一些结果。我这边没有一些关于Airbnb的分析，但是可以采用编程中很有效的工具“假设”。我们假设单一的用户需要查看最多1000的房间才能够找到中意的。

最重要的因素是实时并发查询的用户数，这会影响到这个项目的架构，包括数据结构和数据的技术选择。显然，如果只有100个用户，那么我们就没有什么可以烦恼的了。

反之，如果总用户特别是实时用户远远超过百万，我们需要仔细地考虑每一个决定。对，是每一个决定，这也是为什么公司在提高服务的同时高薪雇佣最好的人才。

Google，Facebook，Airbnb，Netflix，Amazon，Twitter以及其它处理大量数据并且选择同时向上百万的实时用户提供服务的公司都开始雇佣相应的工程师。这也是为什么我们程序员，要在可能的面试当中不断挑战数据结构、算法以解决相应的问题，因为解决快速、高效地解决这些问题的能力正是他们所看重的。

这里有一个用例。我们仍然讨论Airbnb，一个用户访问Airbnb的主页，试着筛选出最匹配的房间。我们将如何解决这个问题呢？（注意，这是一个纯后端的问题，所以我们不关心前端，也不关心网络情况）

首先，我们已经熟悉程序员所掌握的最有用的工具，让我们先从一些假设开始：

- 我们要处理的数据都在内存当中

- 内存足够大

最够大，到底需要多大呢？这是一个好问题。存储实际的数据需要多少内存。再一次假设，如果我们处理4百万单元的数据，也知道每个单元的大小，那么我们可以简单地推导出需要的内存大小，4M*sizeof(one_unit)。

让我们考虑“房间”对象以及它的属性。让我们至少从解决问题所需要处理的特性开始考虑（一个”房间”就是我们的单元）。我们用C++结构体的伪代码来表示。你可以轻易地转换成MongoDB Schema对象或者其它任何你想要的东西。我们仅仅讨论特性名字和类型（尝试使用比特域和比特集来节省空间）。

```cpp
// feel free to reorganize this struct to avoid redundant space
// usage because of aligning factor
// Remark 1: some of the properties could be expressed as enums,
// bitset is chosen for as multi-value enum holder.
// Remark 2: for most of the count values the maximum is 16
// Remark 3: price value considered as integer,
// int considered as 4 byte.
// Remark 4: neighborhoods property omitted 
// Remark 5: to avoid spatial queries, we're 
// using only country code and city name, at this point won't consider 
// the actual coordinates (latitude and longitude)
struct AirbnbHome
{
  wstring name; // wide string
  uint price;
  uchar rating;
  uint rating_count;
  vector<string> photos; // list of photo URLs
  string host_id;
  uchar adults_number;
  uchar children_number; // max is 5
  uchar infants_number; // max is 5
  bitset<3> home_type;
  uchar beds_number;
  uchar bedrooms_number;
  uchar bathrooms_number;
  bitset<21> accessibility;
  bool superhost;
  bitset<20> amenities;
  bitset<6> facilities;
  bitset<34> property_types;
  bitset<32> host_languages;
  bitset<3> house_rules;
  ushort country_code;
  string city;
};
```

明显，上述的结构体并不完美，包含了很多假设和不完整的部分。我只是从Airbnb所提供的过滤器推断出满足这些查询所需要存在的一些特性列表。这只是一个例子。

现在我们应该计算一下对于每一个`AirbnbHome`对象需要多少字节的数据。

- **Home name**：`name`是一个`wstring`类型的数据，以支持多种语言的名字或标题，这意味着每一个字符需要2字节的空间。快速看一下Airbnb的列表，我们可以假设房间名字可以至多有100个字符，虽然大部分其实在50个左右，而不是100，我们假设100个字符为最大值，这需要~200字节的内存。`uint`是4字节，`uchar`是1字节，`ushort`是2字节，同样这也是我们的假设。

- **Photos**：图片本身会另外存储在存储服务器当中，比如Amazon S3（截至目前，对Airbnb来说，这个假设很有可能是对的，不过依然只是一个假设）

- **Photo URLS**：我们会保留图片的URL，并且考虑对于URL没有标准大小的限制，不过事实上，URL会在2083个字符以内，我们将它作为任意URL的最大存储大小。如果每一个房间平均有5张图片的话，最多需要占用~10Kb

- **Photo IDS**：让我们再考虑一下这个。通常存储服务器会用基准URL来保存内容，比如`http(s)://s3.amazonaws.com/<bucket>/<object>`,这里有一个共同的模式来构建URL并且我们只需要存储实际的图片ID。我们假定我们用一些唯一ID生成器，返回20字节的唯一字符串标示ID使得对于特定的图片，其图片对象和URL模式看起来是这样子的`https://s3.amazonaws.com/some-know-bucket/<unique-photo-id>`。这样能够提高空间利用效率，存储5张图片的字符串ID只需要100字节的空间。

- **Host ID**：对于`host_id`可以使用同样的小技巧，拥有房间的用户ID需要占用20字节的空间（实际上，我们可以仅仅使用整型用户ID，但是考虑到像MongoDB这样的数据库系统有一些特别的唯一ID生成器，我们假设一个20字节的字符串ID作为“平均”值，后面只需要做一些小的修改就可以匹配其它的数据库系统。Mongo's的ID长度是24字节）。最终，当对象大小是4字节是我们需要32比特集，当对象大小是8字节是，我们需要32~64之间比特集。记住我们的假设，在这个例子当中，我们对于任何可以枚举表示有能够取多个值的特性，采用比特集，换一句话说，是一种多选确认框。

![Airbnb House Amenities](https://cdn-images-1.medium.com/max/800/1*YcTk591Iy-MzQte5jnXfRg.png)

- **Amenities**：每一个Airbnb的房间都有可用辅助设施的列表，比如”熨斗”，“洗衣机”，”电视”，“wifi”，”烟气探测器”等等。设施的类别可能超过20种，我们坚持设置为20种是因为在Airbnb的过滤页面上面正好显示了20种。如果我们将各种设施进行排序，那么采用比特集来存储是否有相应的设施，将会给我们节约了不少空间。比如，如果一个房间拥有上述所有的设施，我们只要在比特集对应的位置进行设置即可。

![Bitset allows to save 20 different values using just 20 bits](https://cdn-images-1.medium.com/max/800/1*Lj3oDNQ70FdpOT_lKfdD2w.png)

举个例子，检查一个房间是否有“洗衣机”：

```cpp
bool HasWasher(AirbnbHome* h)
{
	return h->amenities[2]
}
```

或者可以更加专业一点：

```cpp
const int KITCHEN = 0;
const int HEATING = 1;
const int WASHER = 2;
//...
bool HasWasher(AirbnbHome* h)
{
  return (h != nullptr) && h->amenities[WASHER];
}

bool HasWasherAndKitchen(AirbnbHome* h)
{
  return (h != nullptr) && h->amenities[WASHER] && h->amenities[KITCHEN];
}

bool HasAllAmenities(AirbnbHome* h, const std::vector<int>& amenities)
{
  bool has = (h != nullptr);
  for (const auto a : amenities) {
    has &= h->amenities[a];
  }
  return has;
}
```

你可以尽你所能地优化代码，并修正编译错误。我们只是强调比特集在所论述问题中应用思路。

- **House rules, Home Type**：对这两个特性我们采用与辅助设施一样的方法。

- **Country code, City name**：最后，国家编码和城市名字。看上诉代码中的注释，为了避免地理空间查询，我们不打算存储经纬度坐标，而是保存国家代码和城市名字缩写通过位置搜索的工作量（为了简化，请原谅我将街道略去了）。[国家编码](https://en.wikipedia.org/wiki/Country_code)可以用2个字符、3个字符或者3个数字来表示，我们采用数字表示并用`ushot`类型来保存。不幸的是，比起国家，城市的数量更多，因此我们无法使用“城市编码”类似的东西，虽然在内部我们依然可以使用。我们保存实际的城市名字来代替，平均城市名字长度预留50字节的空间以应对特殊情况，比如[Taumatawhakatangihangakoauauotamateaturipukakapikimaungahoronukupokaiwhenuakitanatahu](https://en.wikipedia.org/wiki/Taumatawhakatangihangakoauauotamateaturipukakapikimaungahoronukupokaiwhenuakitanatahu)这样的一共有字符的城市。我们最后用一个布尔变量来指示是否为那个特殊的名字超长的城市。因此，记住字符串和向量的内存开销。我们最终给本结构体增加额外的32字节的存储开销，以防万一。我们也假设工作在64位的系统上完成，虽然我们选择了非常紧凑的值来保存int型和short型数据。

```cpp
// Note the comments
struct AirbnbHome
{
  wstring name; // 200 bytes
  uint price; // 4 bytes
  uchar rating; // 1 byte
  uint rating_count; // 4 bytes
  vector<string> photos; // 100 bytes
  string host_id; // 20 bytes
  uchar adults_number; // 1 byte
  uchar children_number; // 1 byte
  uchar infants_number; // 1 byte
  bitset<3> home_type; // 4 bytes
  uchar beds_number; // 1 byte
  uchar bedrooms_number; // 1 byte
  uchar bathrooms_number; // 1 byte
  bitset<21> accessibility; // 4 bytes
  bool superhost; // 1 byte
  bitset<20> amenities; // 4 bytes
  bitset<6> facilities; // 4 bytes
  bitset<34> property_types; // 8 bytes
  bitset<32> host_languages; // 4 bytes, correct me if I'm wrong
  bitset<3> house_rules; // 4 bytes
  ushort country_code; // 2 bytes
  string city; // 50 bytes
};
```

最后，约**420**+字节的空间需求，加上预留的**32**字节，一共**452**字节，为了对齐方便，我们将数据圆整到**500字节**。因此，每个“房间”对象需要的存储空间最多需要500字节，对于所有的房间列表，500字节 * 400万 = 1.86GB~**2GB**。看起来有模有样的。在构造这个结构体的时候我们做了很多假设，使得它更加简单，节省内存空间，我实际期望远远大于2GB，如果我在计算当中有什么错误请让我知道。不过，继续往前，无论我们对这些数据做什么，我们至少需要2GB的内存。如果你感到枯燥，请克服它，因为我们才刚刚开始。

现在是这个任务最难的部分。选择正确的数据结构（尽可能高效地过滤列表）并不是最难的。对我来说，最难的是如果通过一些过滤来搜索列表。假如只有一个搜索主键（一个过滤条件），我们可以很简单地解决这个问题。假设用户只关心价格，我们只要价格落在用户期望区间内的所有`AirbnbHome`对象即可。加入我们使用BST，下面将是它看起来的样子。

![price](https://cdn-images-1.medium.com/max/800/1*6cm5jXJsovsulzqUQNo2ww.png)

你想象一下，所有400万的对象，这棵树会变成非常非常大。并且，内存开销也会因为我们使用BST来存储对象而变得很大。由于每个父树节点在其左子节点和右子节点上都有两个附加的指针，因此每个子指针加起来最多8个额外字节（假设是64位系统）。对于400万个节点，总计高达~62Mb，与2Gb的对象数据相比，它看起来非常小，但也不是我们可以轻易“忽略”的。

最后一个插图中的树表明，任何项目都可以很容易的在O(LogN)复杂度内找到。如果你不熟悉或者不太确定用大O来表示算法复杂度，我们会在下面进行说明，如果已经熟悉了解可以跳过这部分内容。

### Algorithmic complexity

考虑到后面会有一篇长文：“Algorithmic Complexity and Software Performance: The Missing Manual”来详细介绍和解释算法复杂度，这里我们先快速过一下。大部分情况，为一个算法选择大O复杂度，是相当容易的。首先需要注意的是我们通常考虑最差情况。比如一个算法为解决问题产品正面效果的最大运算次数。

假设一个数组包含100个未排序的元素。要找到一个元素需要经过多少次的比较（也考虑一下都匹配不上可能需要的比较次数）？最多需要100次，由于我们需要将要寻找的数值与数组中的所有元素进行比较。不考虑所寻找的元素可能就在数组的第一个位置（这样的比较会非常简单），我们要考虑最差的可能情况（元素能够匹配上并且在数组的最末位置）。

![array](https://cdn-images-1.medium.com/max/600/1*ty0mOl97RJvfnECai3VxqQ.png)

“计算”算法复杂度的关键是找到**输入大小（size of input）**与**运算次数（number of operations）**之间的**依赖（dependency）**关系，比如上述的数组有100个元素，运算次数也是100，如果数组的元素数量（它的输入）增加到1423，找到任意元素的运算次数在最差情况下也同样提高到1423次。在这个案例当中，输入和运算次数之间的线性关系非常明了，可以称之为**线性的**，运算次数随着数组输入的增加而增加。这是计算复杂性的关键，我们说在一个未排序的数组当中查询一个元素需要O(N)的时间来强调查找过程最多需要N次的运算（或者等同于与N的常数倍，比如3N）。另外一方面，访问数组的任一一个元素需要常数时间，比如O(1)。这是因为数组的结构所决定的。数组是一个连续的数据结构，并保存相同类型的数据，因此“跳转”到特定的元素只需要计算与数组第一个元素的相对位置即可。

![test](https://cdn-images-1.medium.com/max/800/1*I8cUohRCKnF8FUznv6-dEA.png)

有一个事情很清晰，BST存储的数据是有序的。那么在BST当中查询一个数据的算法复杂度如何呢？我们应该计算最差的情况下查询一个元素的运算次数。

看上面这张插图。当我们从根节点开始查找的时候，第一次比较可能会有三个结果：

- 1 直接找到节点

- 2 如果需要查找的元素比节点值小则将在节点左边的子树继续进行比较

- 3 如果需要查找的元素比节点值大则将在节点右边的子树继续进行比较

每一步我都会将需要进行比较考虑的节点数减少一半。在BST当中查询一个元素需要的运算数等同于树的高度。树的高度就是最长路径上面节点的数目。在这个案例当中，结果是4.树的高度是$log{_2}N+1$，正如上图所示。因此它的查询复杂度是O(logN+1)=O(logN)。这意味着在400万节点当中搜索最差的情况下需要log4000000 = ~**22**次运算。

### Back to the tree

在BST当中访问一个元素的复杂度是O(logN)。为什么不采用哈希表呢？哈希表具有常亮的元素访问时间，这意味着在任何地方使用哈希表总是合理的。

![hashtables](https://cdn-images-1.medium.com/max/600/1*MoSZx3_lIQtpkHUQg5A0iw.png)

在这个问题当中我们需要考虑一个重要的需求。我必须提供范围搜索。比如价格从80美元到162美元的房间。在BST当中，通过顺序遍历树并保留一个计数器就可以很容易的特定范围内所有的节点。如果用哈希表则实现的成本很高，因此在本案列当中采用BST是合理的。

这里还有一个问题，让我再次考虑哈希表。那就是数据的分布密度。价格不可能一直上涨，大部分的房子在同样的价格范围之内，如上图所示。这个直方图表示了实际价格的分布，上百万的房间具有同样的价格范围（+/- 18~212美元），同样的平均价格。进度的数组可以发挥重要的作用。假设价格是数组的索引，房间的列表是数组的值，我们可以在常数时间内访问任一范围的价格（几乎是常数时间）。下面是抽象的示意图：

![homes](https://cdn-images-1.medium.com/max/800/1*GWjOQqisi3Hi5f3Ic5P6_Q.png)

就像一个哈希表一样，我们通过价格访问房间的集合。所有同价格的房间分组并用一个单独的BST保存。假如我们用home IDs代替上述定义的对象也可以帮我们节省存储空间。最有可能的方案是将所有房间的完整对象保存到一个映射home ID到房间完整对象的哈希表，再存储一个用home IDs映射房间价格的哈希表（或者数组）。

因此，当用户需要一个价格范围的时候，我们从价格表中获取相应的home IDs，将结果缩减到合适的大小，比如每一页10~30个条目，然后用每一个home ID来匹配获取完整的房间对象（home objects）。

还要记住另外一件事情。对于BST平衡非常重要，这是树的查询复杂度为O(logN)的唯一保证条件。问题是当你在排序后的BST当中插入元素时不平衡是很常见的事情。最终，树变得像一个趋向于线性运算效率的链表。暂且先忘掉这个事情，假设我们所有的树都是完美平衡的。再看一眼上面的插图。每一个数组元素代表着一棵大树。如果我们将插图改成下面这样会怎么样呢？

![More like a graph](https://cdn-images-1.medium.com/max/800/1*CPvsz7H8IuGrFdoa4USKsQ.png)

这看起来更像一张图。这个最有迷惑性的数据结构和图，将我们带到了一下部分的内容。

## Graph representation: Outro

关于图的坏消息是并没有一个关于图形表示的单一定义。这也是在库中找不到`std::graph`的原因。我们已经有一个机会展示叫做BST的“特殊”图的机会。但是问题在于，树是图的一种，但图不仅仅是一棵树。最后的插图表明在单一的抽象下我们有很多树，“价格和房间”以及其他一些不同类型的节点，价格只是具有价格信息的节点，并引用满足特定价格的整棵树的home IDs（房间节点）。它就像一个混合的数据结构，而不是我们在教科书当中看到的简单的图。

这也是展示图的关键，图的展示并没有固定的结构。你可以用你所愿意最方面的方式来表示图，主要的事情是将它“看作”一张图。而通过“看图”，我们指的是应用特定于图的一些算法。

N-ary树怎么样，它看起来更像一张图：

![N-ary](https://cdn-images-1.medium.com/max/800/1*WAGdBjYglJ73UEpOrUh1BA.png)

然后首先映入脑海的是表示N-ary树节点的形式可以如下：

```cpp
struct NTreeNode
{
	T value;
	vector<NtreeNode*> children;
}
```

这个结构仅表示一棵树的单一节点。完整的树看起来是这样的：

```cpp
// almost pseudocode
class NTree
{
public:
	void Insert(const T&)
	void Remove(const T&)
	// lines of imitted code
private:
	NTreeNode* root_;
};
```

这个类是基于名为`root_`的单一树节点的抽象。这也是我们构建任意大小的树所需要的全部。是一棵树的起始节点。如果要增加新的节点，我们需要分配相应的内存并将新节点加在根节点下面。

图和N-ary树非常想，不过也有一些些不同。让我们把它指出来。

![spot the slight difference](https://cdn-images-1.medium.com/max/800/1*Cu05NUgY1SBx3ZzeH8SLgw.png)

这是一张图吗？不是。也可以说是，但是和之前的插图一样是同一棵N-ary树，只是有些旋转。作为一个法则，当你看到一棵树的时候，你可以确定那也是一张图。因此，定义一个图节点的结构，我们可以采用相同的结构：

```cpp
struct GraphNode
{
  T value;
  vector<GraphNode*> adjacent_nodes;
};
```

这足以构建一张图了吗？很遗憾，还不够，原因如下。从之前的两个插图之间比对一下，找找差别：

![Both are graphs](https://cdn-images-1.medium.com/max/600/1*Cu05NUgY1SBx3ZzeH8SLgw.png)

左边的插图没有单一的节点可以“进入”，对应的，右边的图没有不可触达的节点。听起来非常熟悉。

>A graph is **connected** when there is a path between every pair of vertices. 

>[Wikipedia](https://en.wikipedia.org/wiki/Connectivity_%28graph_theory%29)

显然，对于“价格和房间”图，并不是每一对对于节点之间都有一条路径。这仅是一个例子用来表明我们不能够用一个单一的GraphNode结构来构建一张图，有些情况下，我们必须处理这样的非连通图。看一下下面这个类：

```cpp
class ConnectedGraph
{
public:
  // API
  
private:
  GraphNode* root_;
};
```

就像N-ary树是围绕单一根节点构建的一样，一个连通图也可以围绕一个根节点进行构建。对于树这里是这么表述的：树都是有根的，它们都一个起始节点。一张连通图可以用有根的树来表示，这是显然的，但是需要记住的是实际的表示会根据各自算法的不同而不同，要解决的问题的不同而不同。然后，考虑基于节点的图，一张非连通图可以表示如下：

```cpp
class DisconnectedGraphOrJustAGraph
{
public:
  // API
  
private:
  std::vector<GraphNode*> all_roots_;
};
```

对于实现图的遍历算法（DFS/BFS）,自然而然地会采用类树的表示。确实能够带来很多帮助。然后，高效地路径跟踪可能需要不同的表示方式。还记得欧拉图吗？要跟踪一张图的“欧拉性”，我们需要在途中找一个欧拉路径。那意味着遍历每条边一次来访问所有节点，且当完成跟踪时还有未遍历的边时则该图没有一条欧拉路径，因此不是一张欧拉图。

还有一种更快的方法，我们可以检查节点的度（假设每个节点保存它的度），正如定义所说，假如一张图包含有奇数度的节点并且不是只有两个这样的节点，那么它不是一张欧拉图。这样的检查的复杂度是O(|V|)，其中|V|是图中节点的个数。我们可以跟踪记录奇数/偶数度，确保在插入新的边的时候讲奇数/偶数度的检查提高到O(1)。没关系，我们只是跟踪记录一张图，就这样。下面是图的表示和返回路径的Trace()函数。

```cpp
// A representation of a graph with both vertex and edge tables
// Vertex table is a hashtable of edges (mapped by label)
// Edge table is a structure with 4 fields
// VELO = Vertex Edge Label Only (e.g. no vertex payloads)

class ConnectedVELOGraph {
public:
    struct Edge {
        Edge(const std::string& f, const std::string& t)
            : from(f)
            , to(t)
            , used(false)
            , next(nullptr)
        {}
        std::string ToString() {
            return (from + " - " + to + " [used:" + (used ? "true" : "false") + "]");
        }

        std::string from;
        std::string to;
        bool used;
        Edge* next;
    };

    ConnectedVELOGraph() {}
    ~ConnectedVELOGraph() {
        vertices_.clear();
        for (std::size_t ix = 0; ix < edges_.size(); ++ix) {
            delete edges_[ix];
        }
    }

public:
    void InsertEdge(const std::string& from, const std::string& to) {
        Edge* e = new Edge(from, to);
        InsertVertexEdge_(from, e);
        InsertVertexEdge_(to, e);
        edges_.push_back(e);
    }

public:
    void Print() {
        for (auto elem : edges_) {
            std::cout << elem->ToString() << std::endl;
        }
    }

    std::vector<std::string> Trace(const std::string& v) {
        std::vector<std::string> path;
        Edge* e = vertices_[v];
        while (e != nullptr) {
            if (e->used) {
                e = e->next;
            } else {
                e->used = true;
                path.push_back(e->from + ":-:" + e->to);
                e = vertices_[e->to];
            }
        }
        return path;
    }

private:
    void InsertVertexEdge_(const std::string& label, Edge* e) {
        if (vertices_.count(label) == 0) {
            vertices_[label] = e;
        } else {
            vertices_[label]->next = e;
        }
    }

private:
    std::unordered_map<std::string, Edge*> vertices_;
    std::vector<Edge*> edges_;
};
```

注意bugs，bugs无处不在。这段代码包含很多假设，比如，标签，对于节点我们理解为字符串标签。当然，你可以简单地将它修改为任何你想要的东西。在这个例子当中是什么内容不重要。下一个，命名，在注释中提到过，VELOGraph是节点边标签唯一图的简称。需要指出的是，这个图包含一个用关联到各自顶点的边来映射顶点标签的表，以及包含节点对（由特定边连接）和由Trace()函数使用的标志的边的列表。看一眼Trace()的实现。它采用边的变迁来标志一个已经遍历过的边（每一次Trace()的调用会重置所有标志）。

## Twitter Example: Tweet Delivery Problem

这里有另外一个叫做邻接矩阵的实现，在有向图中非常有用，像我们在Twitter的关注者网络中所用的一样。

![Directed graph](https://cdn-images-1.medium.com/max/800/1*NogzJ2ZbrTrwh43ph-XAIQ.png)

在这个Twitter例子当中有8个节点。因此，我们需要用|V|x|V|矩阵来表示这张图。如果有一个从**v**到**u**的有向边，则matrix[v][u]元素是`true`，否则为`false`。

![Twitter's example](https://cdn-images-1.medium.com/max/800/1*s--uEeTmQg9f8LhHHGFKtA.png)

正如你所看到的，这个矩阵太过于稀疏，但是却能够快速访问。看看Patrick是否关注了Sponge Bob，我们只要检查一下`matrix["Patrick"]["Sponge Bob"]`的值即可。为了得到Ann的关注者列表，我们只要执行整个“Ann”列（黄色的标题）。为了寻找谁被Sponge Bob关注，我们只要执行“Sponge Bob”行就可以了。邻接矩阵也可以用于无向图，如果有一条边连接**v**和**u**，我们将adj\_matrix[v][u] = 1,adj\_matrix[u][v] = 1。无向图的邻接矩阵是对称的。

注意，与其在邻接矩阵当中保存0和1，我们可以保存一些“更有价值的东西”，比如**边的权重**。最好的一个例子就是带有距离信息的图。

![distance](https://cdn-images-1.medium.com/max/600/1*gMt-tHRL-FeRk-P2-OYprg.png)

![distance 2](https://cdn-images-1.medium.com/max/600/1*zH3p8q22YGh-UfzsrJ4VDA.png)

上图表示Patrick， Sponge Bob和其它人的家之间的距离（**权重图**）。我们在无直接相连的节点之间使用“无限符号”。那并不意味着它们之间根本没有路径，同时也不意味着必须有路径。当需要应该一个寻找不同节点之间路径的算法的时候可以进行定义（甚至还有更好的方法来存储事件和顶点，称为关联矩阵）。

![82000Tb](https://cdn-images-1.medium.com/max/800/1*mXDa1tFIZi5ohpamzVz-cQ.jpeg)

邻接矩阵看起来是一个很好的Twitter关注者网络的解决方案，为将近3亿（月活用户）的用户保留方矩阵需要3亿 * 3亿 * 1字节（保存布尔值）。需要将近~82000Tb的空间，大小相当于1024 * 82000Gb，不知道你的集群如何，反正我的笔记本是没有那么多的内存。字节集呢？[BitBoard](https://github.com/vardanator/ultron/blob/master/src/arrays/bitboard.h)可以帮助我们一些，将所需空间减少到~10000Tb。可是依然很大。正如之前提起过，邻接矩阵太过于稀疏了。它强迫我们使用了比实际多更多地空间。这也是使用边事件到节点的列表有价值的原因。关键是，邻接矩阵允许我们同事保存“关注”和“未关注”的信息，但是我们所想要的信息是关注，看起来像下面这个样子：

<figure class="half">
    <img src="https://cdn-images-1.medium.com/max/600/1*jtt7z3iHFr7xSFSKX95DTA.png">
    <img src="https://cdn-images-1.medium.com/max/600/1*qqTFXXc44_2aqx4dEhPkQw.png">
</figure>

上面两张插图下面这张叫做[链接列表](https://en.wikipedia.org/wiki/Adjacency_list)。每一个列表描述图中节点邻居节点的集合。顺便说一句，用链接列表来展示图的实现实际上上会有些不同。在插图当中，我们更强调更为合理、可以以O(1)算法复杂度访问节点的哈希表的应用，至于链接节点列表的具体数据结构我们并没有提起，从链表到向量，选择权在你手里。

要点是，为了找出Patrick是否关注Liz，我们需要访问哈希表（常数时间）然后遍历列表将每一个元素与“Liz”进行比较（线性时间）。在这里线性时间并不算太坏，因为我们只需要循环一个与“Patrick”链接的固定数目的节点。存储空间复杂度如何，能够在Twitter当中使用不？不是太妙，我们至少需要3亿条哈希表记录，每一个哈希表指向一个包含平均约707个的twitter关注者向量（google获得的数据，不是特别严谨的统计所得，之所以选择向量是为了避免链表左/右指针的内存开销）。

因此，假如我们考虑每一条哈希表记录指向一个707个user IDs（每一个需要8字节内存空间）的数组，并假设哈希表的内存开销只是它的键，再一次，也就是user IDs，所以哈希表本身需要3亿 * 8字节的存储空间。总共的，我们需要3亿 * 8字节空间用于哈希表 + 707 * 8字节用于每个哈希键， 一共是 300亿 * 8 * 707 * 8字节=~ 12Tb。也不能这样就自我感觉良好，但是比起10000Tb，确实是好了不少。

坦诚地说，我也不知道12Tb这个数是否合理，但是考虑到我为一个特定的32GB内存的服务器花费30美元的现实，要存储12Tb数据那么需要只是奥385台类似的服务器，再加上一些用于分布式数据控制的服务器，那么圆整到400台。每月的花费大于1.2万美元。

再考虑到数据需要备份冗余，并且总有一些出错的情况发生，我们考虑三倍数量的服务器，并增加一些控制服务器，让我们假设我们需要1500台服务器，届时每月的花费是4.5万美元。嗯，对我来说保存一台服务器就够难了，但是对于Twitter来说这不算什么，让我们假设对于Twitter这是可行的。

现在，这样就可以了吗？还没有。这仅仅是考虑了关注者的数据。Twitter主要的事情是什么？我的意思是，技术上来讲，最大的问题是什么？如果你说是tweets的快速推送，那么你将和很多人达成共识。我第二个表示同意，而且不仅是快，而是飞快。假设Patrick发tweet讲了一些他关于食物的想法，那么他的关注者应该在合理的时间内收到这条tweet。这需要多长时间呢？我们可以在此进行任意的假设，并采用任何我们想要使用的抽象，但我们队现实世界的生产系统很感兴趣，让我们来试着挖掘一下。下面是当一个人发tweet的时候发生的典型事情。

![twitter fast](https://cdn-images-1.medium.com/max/1000/1*rxZGqG1AW6lSlhIl9sQuGA.png)

再一次，还是不知道一条tweet推送到所有关注他的人那边所需要的具体时间，但是公开可用的数据告诉我们每天有将近5亿条被推送的tweet。

因此我们可以假设上述过程每天要发生5亿次。关于tweet的推送速度我找不到其它可供参考的资料。我必须收回关于一条tweet需要最多5秒才能推送到关注者的言论。并且也注意到一些大V，那些有上百万关注者的名人。他们可能会在Twitter上发布一些关于他们在海滨别墅享用美味早餐的消息，但是Twitter为向数百万的关注者传递这些超级有用的内容付出了巨大的努力。

为了解决tweet推送问题，我们并不需要某个特定人关注了谁的图，而是需要谁关注了他的图。之前的图（哈希表+一些列表）允许我们快速找到特定用户所有关注的人员。但是它不允许我们快速的找到所有关注一个特定用户的人，那样我们需要扫描所有的哈希表的键。这也是为什么我们需要构建另外一张图，这与我们之前为一个用户关注了谁的图正好相反。这张新图再次包含含有3亿节点的哈希表，每一个值都指向一个链接节点的列表，但是这一次，这个链接节点的列表表示的是关注者，即关注特定用户的人。

![followers](https://cdn-images-1.medium.com/max/800/1*axs6Z0F87LcnxtHJXoNPKw.png)












