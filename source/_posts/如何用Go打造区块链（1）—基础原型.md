---
title: 如何用Go打造区块链（1）—基础原型
date: 2019-10-28 11:13:22
categories:
- [区块链]
tags:
- go
- hash
- 工作证明
- 交易
- 分布式
description: 由于众所周知的原因，最近区块链又一次被推到了风口，下面转发几篇两年前翻译的首发于知乎关于如何用Go语言打造区块链的文章。Go语言是由google开发并于2009年发布的一种静态、强类型、编译型、并发型，并具有垃圾回收（GC）功能的编程语言，特别适用于分布式网络系统开发，而区块链（blockchain）本质上是一本在网络上分布存储的账本，这两者具有天然的匹配性，目前火热的[Ethereum Project](https://ethereum.org/)就是用go原生实现的。这一系列的文章是由[Ivan Kuznetsov](https://jeiwan.net/)所写，本人觉得是一个结合Go语言学习区块链技术的好资料，后面将用自己的语言翻译一遍，从第一篇开始，顺便对Go语言以及区块链有一个初步的认识。
---

# 介绍

区块链（blockchain）是21世纪最具革命性的技术之一，正在不断地变得更为成熟，潜力无限。本质上，区块链只是一个分布式记录账本的数据库。其独特性在于它不是一个私有的数据库，而是一个公共数据库。它的每一个使用者都拥有它的全部或者部分，并且当且仅当数据库的多数持有者达成一致意见时才能够加进去新的数据记录。正是这样的原因，区块链使得加密货币和智能合约变得可能。

在这一系列的文章当中，我们将基于区块链的简单实现构建一个简化版的加密货币。

# 区块（Block）

让我们从区块链中的区块开始。区块链中的区块存储着有价值的信息。举个例子，比特币的区块存储对于任何加密货币都是核心的交易记录。除此之外，一个区块还包含一些技术信息，比如它的版本号，当前的时间戳以及上一个区块的哈希值（hash）。

在这篇文章当中我们并不打算去实现区块链或者比特币规范所定义的区块，而是一个简化版本的区块，它只包含最重要的核心信息。差不多是这个样子：

```go
type Block struct {
	Timestamp     int64
	Data          []byte
	PrevBlockHash []byte
	Hash          []byte
}
```

- `Timestamp`是当前的时间戳（即区块被创建的时间）
- `Data`是区块中实际包含的有用信息
- `PrevBlockHash`存储着前一个区块的哈希值
- `Hash`是当前区块的哈希值

在比特币规范当中，`Timestamp`，`PrevBlockHash`，`Hash`是区块头部数据（block headers），自成一个单独的数据结构，而交易记录（Transactions，在我们这个版本当中就是Data）构成另外一个单独的数据结构。为了简化，这里我们将两者混合到一个数据结构当中。

接下来我们如何计算哈希值？哈希值如何计算是区块链的重要特性，也正是这一特性让区块链确保安全。哈希值在计算上是一个非常困难的操作，即便是非常快的计算机也需要一些时间（这也是人们为什么购买计算能力更强的GPU来挖矿的原因）。这是人为有意的设计，目的是让在区块链当中增加新的区块变得更难，以确保一旦有新的区块成功加入便很难被篡改。在后面的文章当中我们会讨论并实现这一机制。

现在我们只需要将区块中的各个值关联起来，然后据此计算一个[SHA-256哈希](https://zh.wikipedia.org/wiki/SHA-2)。让我们在`SetHash()`函数中实现哈希值的计算，`SetHash()`会调用`bytes`包和`sha256`包中的函数，代码如下：

```go
func (b *Block) SetHash() {
	timestamp := []byte(strconv.FormatInt(b.Timestamp, 10))
	headers := bytes.Join([][]byte{b.PrevBlockHash, b.Data, timestamp}, []byte{})
	hash := sha256.Sum256(headers)

	b.Hash = hash[:]
}
```

然后按照Go语言的惯例，实现一个简化创建区块的函数，代码如下：

```go
func NewBlock(data string, prevBlockHash []byte) *Block {
	block := &Block{time.Now().Unix(), []byte(data), prevBlockHash, []byte{}}
	block.SetHash()
	return block
}
```

然后区块部分的代码就完成了！

# 区块链（Blockchain）

现在让我们来实现一个区块链。本质上，区块链是带有特定数据结构的数据库：它是一个有序的、反向链接的列表（back-linked list）。这意味着区块是按照插入的顺利存储的，并且每个区块都链接到前面一个区块。这种结构允许快速地获取最新的区块，也可以非常高效地通过哈希值获得其对应的区块。

在Go语言中这种结构可以通过数组（Array）和图（Map）来实现：数据用来存储有序哈希（在Go语言中数组是有序的）；然后图来存储哈希（hash） [公式] 区块（block）对（图是无序的数据结构）。不过就我们目前的区块链原型当中，只使用数组就可以了，因为暂时还不需要通过哈希来获取区块。

```go
type Blockchain struct {
	blocks []*Block
}
```

这是我们的第一个区块链！我从来没有想到过原来这么简单！

现在要考虑往区块链里面添加区块了：

```go
func (bc *Blockchain) AddBlock(data string) {
	prevBlock := bc.blocks[len(bc.blocks)-1]
	newBlock := NewBlock(data, prevBlock.Hash)
	bc.blocks = append(bc.blocks, newBlock)
}
```

就这样了吗？还是。。。？

显然，要增加一个区块需要一个已经存在的区块，但是目前我们的区块链里面还没有区块！因此，在任何区块链，必须至少有一个区块，并且这个最先在这个链中的区块被称为“创始块”（Genesis Block）。来让我们实现创建创始块的方法吧。

```go
func NewGenesisBlock() *Block {
	return NewBlock("Genesis Block", []byte{})
}
```

现在让我们来实现一个用创始块创建一个区块链的函数：

```go
func NewBlockchain() *Blockchain {
	return &Blockchain{[]*Block{NewGenesisBlock()}}
}
```

让我们测试一下这个区块链能否正常工作：

```go
func main() {
	bc := NewBlockchain()

	bc.AddBlock("Send 1 BTC to Ivan")
	bc.AddBlock("Send 2 more BTC to Ivan")

	for _, block := range bc.blocks {
		fmt.Printf("Prev. hash: %x\n", block.PrevBlockHash)
		fmt.Printf("Data: %s\n", block.Data)
		fmt.Printf("Hash: %x\n", block.Hash)
		fmt.Println()
	}
}
```

输出：

```go
Prev. hash:
Data: Genesis Block
Hash: aff955a50dc6cd2abfe81b8849eab15f99ed1dc333d38487024223b5fe0f1168

Prev. hash: aff955a50dc6cd2abfe81b8849eab15f99ed1dc333d38487024223b5fe0f1168
Data: Send 1 BTC to Ivan
Hash: d75ce22a840abb9b4e8fc3b60767c4ba3f46a0432d3ea15b71aef9fde6a314e1

Prev. hash: d75ce22a840abb9b4e8fc3b60767c4ba3f46a0432d3ea15b71aef9fde6a314e1
Data: Send 2 more BTC to Ivan
Hash: 561237522bb7fcfbccbc6fe0e98bbbde7427ffe01c6fb223f7562288ca2295d1
```

完全正确。

# 结论

我们创建了一个极简的区块链原型：它只不过是一个由区块构成的数组，每个区块都链接指向上一个区块。当然，真正的区块链远比这个复杂的多。在我们的区块链里面添加一个区块又快又容易，然后在实际的区块链当中添加一个区块着实需要一些工作：在获得增加区块的允许之前要做很繁重的计算才行（这个机制被称之为“工作证明机制”，即“Proof-of-Work”，POW）。并且，区块链是一个没有单一决策者的分布式数据库。因此，任何一个区块被加入之前都需要得到网络中其他的参与和的确认和批准（这个机制被称之为“共识机制”，即“Consenus”），还有，在我们的区块链里面还没有任何交易记录呢！

在后面的文章里面，我们将进一步实现上述缺失的特性。

# 链接

- [Full source codes](https://github.com/Jeiwan/blockchain_go/tree/part_1) 
- [Block hashing algorithm](https://en.bitcoin.it/wiki/Block_hashing_algorithm)


