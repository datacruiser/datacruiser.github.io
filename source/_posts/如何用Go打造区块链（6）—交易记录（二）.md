---
title: 如何用Go打造区块链（6）—交易记录（二）
date: 2019-11-07 17:46:52
categories:
- [区块链]
tags:
- go
- hash
- 工作证明
- 交易
- 分布式
- 数据库
- 命令行
description: 由于众所周知的原因，最近区块链又一次被推到了风口，下面转发几篇两年前翻译的首发于知乎关于如何用Go语言打造区块链的文章。Go语言是由google开发并于2009年发布的一种静态、强类型、编译型、并发型，并具有垃圾回收（GC）功能的编程语言，特别适用于分布式网络系统开发，而区块链（blockchain）本质上是一本在网络上分布存储的账本，这两者具有天然的匹配性，目前火热的[Ethereum Project](https://ethereum.org/)就是用go原生实现的。这一系列的文章是由[Ivan Kuznetsov](https://jeiwan.net/)所写，本人觉得是一个结合Go语言学习区块链技术的好资料，后面将用自己的语言翻译一遍，从第一篇开始，顺便对Go语言以及区块链有一个初步的认识。
---

# 介绍 Introduction


在本系列文章的前面部分我说过区块链是一个分布式数据库。但那时候，我们决定暂时跳过“分布式”的部分我先专注于“数据库”部分。到目前为止，我们已经基本实现区块链作为一个数据库的所有部分。我们会覆盖一些前面部分跳过的一些机制，然后在下一部分我们会在区块链的分布式特性方面进行工作。

前面的部分：

- [如何用Go打造区块链（1）—基础原型](http://datacruiser.io/2019/10/28/%E5%A6%82%E4%BD%95%E7%94%A8Go%E6%89%93%E9%80%A0%E5%8C%BA%E5%9D%97%E9%93%BE%EF%BC%881%EF%BC%89%E2%80%94%E5%9F%BA%E7%A1%80%E5%8E%9F%E5%9E%8B/)
- [如何用Go打造区块链（2）—工作证明机制（PoW）](http://datacruiser.io/2019/10/28/%E5%A6%82%E4%BD%95%E7%94%A8Go%E6%89%93%E9%80%A0%E5%8C%BA%E5%9D%97%E9%93%BE%EF%BC%882%EF%BC%89%E2%80%94%E5%B7%A5%E4%BD%9C%E8%AF%81%E6%98%8E%E6%9C%BA%E5%88%B6%EF%BC%88PoW%EF%BC%89/)
- [如何用Go打造区块链（3）—数据存储及命令行（CLI）](http://datacruiser.io/2019/10/29/%E5%A6%82%E4%BD%95%E7%94%A8Go%E6%89%93%E9%80%A0%E5%8C%BA%E5%9D%97%E9%93%BE%EF%BC%883%EF%BC%89%E2%80%94%E6%95%B0%E6%8D%AE%E5%AD%98%E5%82%A8%E5%8F%8A%E5%91%BD%E4%BB%A4%E8%A1%8C%EF%BC%88CLI%EF%BC%89/)
- [如何用Go打造区块链（4）—交易记录（一）](http://datacruiser.io/2019/11/06/%E5%A6%82%E4%BD%95%E7%94%A8Go%E6%89%93%E9%80%A0%E5%8C%BA%E5%9D%97%E9%93%BE%EF%BC%884%EF%BC%89%E2%80%94%E4%BA%A4%E6%98%93%E8%AE%B0%E5%BD%95%EF%BC%88%E4%B8%80%EF%BC%89/)
- [如何用Go打造区块链（5）—地址](http://datacruiser.io/2019/11/06/%E5%A6%82%E4%BD%95%E7%94%A8Go%E6%89%93%E9%80%A0%E5%8C%BA%E5%9D%97%E9%93%BE%EF%BC%885%EF%BC%89%E2%80%94%E5%9C%B0%E5%9D%80/)

> 这部分主要介绍关键代码变动，因此这里解释所有的代码不是特别有意义。可以参考[这个页面](https://github.com/Jeiwan/blockchain_go/compare/part_5...part_6#files_bucket)看与上一部分文章之间的代码变动。

# 奖励 Reward


在前面的文章当中跳过的一个小事情是挖矿的奖励。为了实现它的所有元素我们已经准备好了。

奖励（reward）只是一个币基交易记录（coinbase transaction）。当以挖矿节点开始挖一个新的区块，从队列中取得交易记录并给区块预留一个币基交易记录。币基交易记录的唯一输出包含矿工（miner）的公钥哈希值。

实现奖励只要通过更新一下 `send` 命令就可以：

```go
func (cli *CLI) send(from, to string, amount int) {
    ...
    bc := NewBlockchain()
    UTXOSet := UTXOSet{bc}
    defer bc.db.Close()

    tx := NewUTXOTransaction(from, to, amount, &UTXOSet)
    cbTx := NewCoinbaseTX(from, "")
    txs := []*Transaction{cbTx, tx}

    newBlock := bc.MineBlock(txs)
    fmt.Println("Success!")
}
```

在我们的实现当中，创建交易记录的人去挖新的区块，然后得到一个奖励。


# 未花费交易记录输出集 The UTXO Set


在[如何用Go打造区块链（3）—数据存储及命令行（CLI）](http://datacruiser.io/2019/10/29/%E5%A6%82%E4%BD%95%E7%94%A8Go%E6%89%93%E9%80%A0%E5%8C%BA%E5%9D%97%E9%93%BE%EF%BC%883%EF%BC%89%E2%80%94%E6%95%B0%E6%8D%AE%E5%AD%98%E5%82%A8%E5%8F%8A%E5%91%BD%E4%BB%A4%E8%A1%8C%EF%BC%88CLI%EF%BC%89/)当中，我们研究了比特币内核将区块存储在数据库中的方式。区块存储在 `blocks `（区块）数据库当中，交易记录输出存储在 `chainstate `（链状态）数据库当中。让我再回顾一下 `chainstate `的结构：

- 'c' + 32-byte transaction hash -> unspent transaction output record for that transaction
- 'B' -> 32-byte block hash: the block hash up to which the database represents the unspent transaction outputs

在那篇文章当中，我们已经实现了交易记录，但是我们并没有 `chainstate `来存储输出。这是我们即将打算要去做的。

`chainstate `不存储交易记录。反而，它存储叫做`UTXO set`的东西，或者叫未花费交易记录输出的集合。除此之外，它还存储“到代表未消费输出的数据库的区块哈希值”，因为我们不使用区块高度，我们暂时忽略它（但是我们将在下一篇文章中实现）。

那么，为什么我们要有 `UTXO set`呢？

看一下我们早先实现的 `Blockchain.FindUnspentTransactions `方法：

```go
func (bc *Blockchain) FindUnspentTransactions(pubKeyHash []byte) []Transaction {
    ...
    bci := bc.Iterator()

    for {
        block := bci.Next()

        for _, tx := range block.Transactions {
            ...
        }

        if len(block.PrevBlockHash) == 0 {
            break
        }
    }
    ...
}
```

这个函数寻找有未消费输出的交易记录。因为交易记录存储在区块当中，它遍历每一个区块然后检查其中的每一个交易记录。截止2017年9月18日，在比特币当中一共有485, 860个区块，所有的数据库大约占用140+Gb的容量。这意味着你必须运行一个完整的节点来验证交易记录。同时，验证交易记录需要遍历很多区块。

这个问题的解决方案是引入一个只存储未消费输出的索引值，这就是`UTXO set`所做的事情：这是一个从所有区块链交易记录（通过遍历区块，是的，但是只做一次）构建的快速缓存，随后会被用于计算余额和验证新的交易记录。截止2017年9月份，`UTXO set`差不多2.7Gb。

好了，让我们想想我们需要做什么来实现`UTXO set`。目前，下面的方法用于寻找交易记录：

- `Blockchain.FindUnspentTransactions` – 寻找含未消费输出的交易记录的主函数。在这个函数当中我们遍历所有的区块。
- `Blockchain.FindSpendableOutputs` – 当一个新的交易记录被创建时，这个函数会被使用。如果要找到足够数量的持有满足需求的足额输出的话。会用到`Blockchain.FindUnspentTransactions`.
- `Blockchain.FindUTXO` – 为一个特定的公钥哈希寻找未花费输出，用于获取余额。会用到 `Blockchain.FindUnspentTransactions`.
- `Blockchain.FindTransaction `– 通过ID 在区块链中找到一个交易记录。它会遍历所有的区块，直到找到满足要求的交易记录。

正如你所看到的，所有的方法都需要遍历数据库中的区块。但是目前我们还不能对全部进行优化，但是`UTXO set `并不存储所有的交易记录，而只是那些有未消费输出的。这样，在 `Blockchain.FindTransaction `中无法使用。

这样，我们想要下列方法：

- `Blockchain.FindUTXO` – 通过遍历区块寻找所有的未消费输出
- `UTXOSet.Reindex` — 用 `FindUTXO` 来寻找未消费输出，然后将他们存储在一个数据库当中，这是缓存发生的地方
- `UTXOSet.FindSpendableOutputs` – 与 `Blockchain.FindSpendableOutputs` 类似, 不过使用 `UTXO set`
- `UTXOSet.FindUTXO ` – 与 `Blockchain.FindUTXO` 类似, 不过使用 `UTXO set`
- `Blockchain.FindTransaction `保持不变

这样，两个最频繁使用的函数将会从现在开始使用缓存！让我们开始编码吧！

```go
type UTXOSet struct {
    Blockchain *Blockchain
}
```

我们将使用同一个数据库，不过将`UTXO set `存储在另外一个不同的 `bucket `当中。`UTXOSet `将与 `Blockchain `相结合。

```go
func (u UTXOSet) Reindex() {
    db := u.Blockchain.db
    bucketName := []byte(utxoBucket)

    err := db.Update(func(tx *bolt.Tx) error {
        err := tx.DeleteBucket(bucketName)
        _, err = tx.CreateBucket(bucketName)
    })

    UTXO := u.Blockchain.FindUTXO()

    err = db.Update(func(tx *bolt.Tx) error {
        b := tx.Bucket(bucketName)

        for txID, outs := range UTXO {
            key, err := hex.DecodeString(txID)
            err = b.Put(key, outs.Serialize())
        }
    })
}
```

这个方法将创建并初始化 `UTXO set`。首先，移除已经存在的 `bucket`，然后从区块链当中获得所有的未消费输出，最后将输出保存到 `bucket `当中。

`Blockchain.FindUTXO `和 `Blockchain.FindUnspentTransactions `几乎完全一样, 但是现在它返回一个含 `TransactionID → TransactionOutputs `对的图（map）。

现在，`UTXO set `可以用来发送比特币了：

```go
func (u UTXOSet) FindSpendableOutputs(pubkeyHash []byte, amount int) (int, map[string][]int) {
    unspentOutputs := make(map[string][]int)
    accumulated := 0
    db := u.Blockchain.db

    err := db.View(func(tx *bolt.Tx) error {
        b := tx.Bucket([]byte(utxoBucket))
        c := b.Cursor()

        for k, v := c.First(); k != nil; k, v = c.Next() {
            txID := hex.EncodeToString(k)
            outs := DeserializeOutputs(v)

            for outIdx, out := range outs.Outputs {
                if out.IsLockedWithKey(pubkeyHash) && accumulated < amount {
                    accumulated += out.Value
                    unspentOutputs[txID] = append(unspentOutputs[txID], outIdx)
                }
            }
        }
    })

    return accumulated, unspentOutputs
}
```

或者检查余额：

```go
func (u UTXOSet) FindUTXO(pubKeyHash []byte) []TXOutput {
    var UTXOs []TXOutput
    db := u.Blockchain.db

    err := db.View(func(tx *bolt.Tx) error {
        b := tx.Bucket([]byte(utxoBucket))
        c := b.Cursor()

        for k, v := c.First(); k != nil; k, v = c.Next() {
            outs := DeserializeOutputs(v)

            for _, out := range outs.Outputs {
                if out.IsLockedWithKey(pubKeyHash) {
                    UTXOs = append(UTXOs, out)
                }
            }
        }

        return nil
    })

    return UTXOs
}
```

这些都是与`Blockchain `相关的略微修改过的版本。原先的那些 `Blockchain `方法已经不需要了。

有了`UTXO set `以后意味着我们的数据（交易记录）现在分块存储：实际的交易记录存储在区块链中，未消费输出存储在 `UTXO set`中。这样的分离需要有可靠的同步机制，因为我们要`UTXO set `能够一直更新并存储最新交易记录的输出。但是我们也不愿意每次一个新的区块被挖出来就重新建立一次索引，因为我们要避免频繁的区块链扫描。所以，我们还需要一个更新 `UTXO set `的机制。

```go
func (u UTXOSet) Update(block *Block) {
    db := u.Blockchain.db

    err := db.Update(func(tx *bolt.Tx) error {
        b := tx.Bucket([]byte(utxoBucket))

        for _, tx := range block.Transactions {
            if tx.IsCoinbase() == false {
                for _, vin := range tx.Vin {
                    updatedOuts := TXOutputs{}
                    outsBytes := b.Get(vin.Txid)
                    outs := DeserializeOutputs(outsBytes)

                    for outIdx, out := range outs.Outputs {
                        if outIdx != vin.Vout {
                            updatedOuts.Outputs = append(updatedOuts.Outputs, out)
                        }
                    }

                    if len(updatedOuts.Outputs) == 0 {
                        err := b.Delete(vin.Txid)
                    } else {
                        err := b.Put(vin.Txid, updatedOuts.Serialize())
                    }

                }
            }

            newOutputs := TXOutputs{}
            for _, out := range tx.Vout {
                newOutputs.Outputs = append(newOutputs.Outputs, out)
            }

            err := b.Put(tx.ID, newOutputs.Serialize())
        }
    })
}
```

这个方法看起来非常复杂，但是它所干的事情却非常简单。当挖出一个新的区块，`UTXO set `应该相应地更新。更新意味着将已经花出去的移除，然后将新挖区块的未消费的加进去。加入一个交易记录的输出被移除的，不含任何输出，它本身也将会被移除。非常简单！

现在让我们把 `UTXO set `用在需要的地方：

```go
func (cli *CLI) createBlockchain(address string) {
    ...
    bc := CreateBlockchain(address)
    defer bc.db.Close()

    UTXOSet := UTXOSet{bc}
    UTXOSet.Reindex()
    ...
}
```

当一个新的区块链产生的时候对`UTXO set`重新索引（Reindex）。到目前为止，这是唯一要重新索引的地方，即便在这里看起来有些过分，因为在一个区块链刚刚被创建的时候，只有一个区块，一个交易记录，`Update `方法可以来代替 `Reindex()`。但是在不久的将来，我们需要重新索引机制。

```go
func (cli *CLI) send(from, to string, amount int) {
    ...
    newBlock := bc.MineBlock(txs)
    UTXOSet.Update(newBlock)
}
```

在一个新的区块被挖出来以后更新了 `UTXO set`。

让我们来检查它的工作情况。

```go
$ blockchain_go createblockchain -address 1JnMDSqVoHi4TEFXNw5wJ8skPsPf4LHkQ1
00000086a725e18ed7e9e06f1051651a4fc46a315a9d298e59e57aeacbe0bf73

Done!

$ blockchain_go send -from 1JnMDSqVoHi4TEFXNw5wJ8skPsPf4LHkQ1 -to 12DkLzLQ4B3gnQt62EPRJGZ38n3zF4Hzt5 -amount 6
0000001f75cb3a5033aeecbf6a8d378e15b25d026fb0a665c7721a5bb0faa21b

Success!

$ blockchain_go send -from 1JnMDSqVoHi4TEFXNw5wJ8skPsPf4LHkQ1 -to 12ncZhA5mFTTnTmHq1aTPYBri4jAK8TacL -amount 4
000000cc51e665d53c78af5e65774a72fc7b864140a8224bf4e7709d8e0fa433

Success!

$ blockchain_go getbalance -address 1JnMDSqVoHi4TEFXNw5wJ8skPsPf4LHkQ1
Balance of '1F4MbuqjcuJGymjcuYQMUVYB37AWKkSLif': 20

$ blockchain_go getbalance -address 12DkLzLQ4B3gnQt62EPRJGZ38n3zF4Hzt5
Balance of '1XWu6nitBWe6J6v6MXmd5rhdP7dZsExbx': 6

$ blockchain_go getbalance -address 12ncZhA5mFTTnTmHq1aTPYBri4jAK8TacL
Balance of '13UASQpCR8Nr41PojH8Bz4K6cmTCqweskL': 4
```

非常好！`1JnMDSqVoHi4TEFXNw5wJ8skPsPf4LHkQ1 `地址3次收到奖励：

- 第一次来自对创始区块（genesis blocks）的挖矿
- 第二次来自对以下区块的挖矿：`0000001f75cb3a5033aeecbf6a8d378e15b25d026fb0a665c7721a5bb0faa21b`.
- 第三次来自对以下区块的挖矿：`000000cc51e665d53c78af5e65774a72fc7b864140a8224bf4e7709d8e0fa433`.

# Merkle Tree


在这篇文章当中还有一个优化选项我还想要讨论以下的。

正如前面所言，完整的比特币数据库（区块链）大约占140Gb 的磁盘空间。因为比特币的分布式存储的特性，网络中的每一个节点都要独立且要自我实现，比如每个节点都要存储一份整个区块链的完整拷贝。随着很多人开始使用比特币，这条规则变得越来越难以坚持：每个人都运行一个完整的节点不太可能。并且，因为节点是网络的成熟的参与者，它们有责任：它们必须验证交易记录和区块。更进一步，它们与其它节点交流并下载新的节点也需要一定的带宽需求。

在中本聪（Satoshi Nakamoto）发布的[白皮书](https://bitcoin.org/bitcoin.pdf)当中，有一个对应的解决方案：简单支付验证（Simplified Payment Verification：SPV）。`SPV `是一个轻量的比特币节点，不下载整个区块链，也不对所有的区块和交易记录进行验证。相应的，它在区块中寻找交易记录（验证支付）然后链接到一个完整节点仅取得需要的数据。这样的机制允许有很多的轻量钱包节点而只运行一个完整的节点。

为了`SPV `的可行性，需要一种不需要下载整个区块就能够确认一个区块是否含有交易记录的机制。这也正是 `Merkle tree `所要扮演的角色。

比特币用 `Merkle trees `来获得交易记录哈希值，这个哈希值保存在区块头部数据当中并在PoW 系统当中会被考虑。直到现在，我们只是将每个区块中的每个交易记录的哈希值组合在一起然后再使用 `SHA-256`，只是取得区块交易记录唯一证明的好方式，但是却没有 `Merkle trees `的一些好处。

让我们看一个 `Merkle tree`：

![](https://jeiwan.net/images/merkle-tree-diagram.png)

每一个区块构建一个 `Merkle tree`，它从叶子（tree的底部）开始，每一个叶子就是一个交易记录的哈希（比特币采用 双 SHA-256 计算哈希值）。叶子的数量必须是偶数，但是并不是每一个区块都包含偶数个的交易记录。在奇数个交易记录的情况下，最后一个交易记录会被复制（只是在 Merkle tree中复制，并不是在区块当中！）。

从下往上走，叶子一对一对地分组，它们的哈希值被组合到一起，并产生一个新的哈希值来代替组合后的哈希。新的哈希组成新的树的节点。这个过程不断重复直到剩下仅有的一个节点，称之为树的根。树根的哈希就被用来作为所有交易记录的唯一表征，保存在区块头部数据当中，并在PoW 系统当中使用。

`Merkle trees` 的好处是一个节点可以在不下载整个区块的情况下验证特定交易记录的身份。一个交易记录哈希，一个 `Merkle `树根哈希，然后一个`Merkle `的路径就够了。

最后，让我们来写代码：

```go
type MerkleTree struct {
    RootNode *MerkleNode
}

type MerkleNode struct {
    Left  *MerkleNode
    Right *MerkleNode
    Data  []byte
}
```

我们从一个结构体开始。每一个` MerkleNode` 保存着数据还到其分支的链接。

`MerkleTree` 实际上是链接到下一个节点的根节点，它们就这样依次与更多的节点相连。

让我们先创建一个新的节点：

```go
func NewMerkleNode(left, right *MerkleNode, data []byte) *MerkleNode {
    mNode := MerkleNode{}

    if left == nil && right == nil {
        hash := sha256.Sum256(data)
        mNode.Data = hash[:]
    } else {
        prevHashes := append(left.Data, right.Data...)
        hash := sha256.Sum256(prevHashes)
        mNode.Data = hash[:]
    }

    mNode.Left = left
    mNode.Right = right

    return &mNode
}
```

每一个节点包含一些数据。当一个节点是一片叶子，数据将从外面传入（在我们的案例中是一个序列化的交易记录）。当一个节点链接到其它节点时，它将获取它们的数据然后组合组合并对数据进行哈希计算。

```go
func NewMerkleTree(data [][]byte) *MerkleTree {
    var nodes []MerkleNode

    if len(data)%2 != 0 {
        data = append(data, data[len(data)-1])
    }

    for _, datum := range data {
        node := NewMerkleNode(nil, nil, datum)
        nodes = append(nodes, *node)
    }

    for i := 0; i < len(data)/2; i++ {
        var newLevel []MerkleNode

        for j := 0; j < len(nodes); j += 2 {
            node := NewMerkleNode(&nodes[j], &nodes[j+1], nil)
            newLevel = append(newLevel, *node)
        }

        nodes = newLevel
    }

    mTree := MerkleTree{&nodes[0]}

    return &mTree
}
```

当一个新的树被创建出来以后，首先要确保的是它有偶数片树叶。在这之后，数据（序列化交易记录的数组）将被转化为树叶，然后树从这些树叶开始生长。

现在，让我们修改 `Block.HashTransactions`，它被用在PoW 系统当中获取交易记录哈希值：

```go
func (b *Block) HashTransactions() []byte {
    var transactions [][]byte

    for _, tx := range b.Transactions {
        transactions = append(transactions, tx.Serialize())
    }
    mTree := NewMerkleTree(transactions)

    return mTree.RootNode.Data
}
```

首先，交易记录被序列化（采用 `encoding/gob `包），然后让他们来构建一个 `Merkle tree`。树根会用来作为区块的交易记录的唯一识别特征。

# P2PKH


还有一个事情我想要再详细讨论一下。

你还记得，在比特币当中有一个 脚本（Script）编程语言，用于交易记录输出的锁定；然后交易记录输入提供数据来对它进行解锁。这个语言本身非常简单，在这个语言当中编程知识一个数据和操作符的序列。看下面这个例子：

```go
5 2 OP_ADD 7 OP_EQUAL
```

5，2，和7是数据。`OP_ADD` 和`OP_EQUAL` 是操作符。 `Script` 代码从左往右执行：每一段数据放入栈中（stack），后面的操作符作用于栈顶的数据。`Script` 的✅知识一个简单的FILO （先进后出）内存存储器：栈中的第一个数据最后被取用，后面来的的元素放到前面数据之前。

让我们分步执行前面的脚本：

```go
Stack: empty. Script: 5 2 OP_ADD 7 OP_EQUAL.
Stack: 5. Script: 2 OP_ADD 7 OP_EQUAL.
Stack: 5 2. Script: OP_ADD 7 OP_EQUAL.
Stack: 7. Script: 7 OP_EQUAL.
Stack: 7 7. Script: OP_EQUAL.
Stack: true. Script: empty.
```

`OP_ADD` 从堆中取得两个元素，将他们相加，然后将结果放入堆中。`OP_EQUAL` 从堆中取得两个数据然后进行比较：假如它们相等就将` true `放入堆中；否则放入` false`. 一段脚本的执行结果是堆顶元素的值：在我们的案例中，它是真值（true），这意味着脚本成功的执行完成了。

现在让我们看看在比特币中执行支付的脚本：

```go
<signature> <pubKey> OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
```

这段脚本叫做 `Pay to Public Key Hash (P2PKH)`，在比特币中这是最常用的一段脚本。它按照指令向一个公钥哈希进行支付，并用一个特定的公钥锁定比特币。这是比特币支付的核心：没有账户，没有账户之间的资金转移；只有一段检查输入的签名和公钥是匹配的脚本。

脚本分两部分进行存储：

- 第一部分,` <signature> <pubKey>`, 存储在输入的` ScriptSig` 字段
- 第二部分, `OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG` 存储在输出的 `ScriptPubKey` 字段
这样，它的输出定义了解锁逻辑，输入提供用于解锁输出的数据，让我们的执行这段脚本：

```go
Stack: empty
Script: <signature> <pubKey> OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
Stack: <signature>
Script: <pubKey> OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
Stack: <signature> <pubKey>
Script: OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
Stack: <signature> <pubKey> <pubKey>
Script: OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
Stack: <signature> <pubKey> <pubKeyHash>
Script: <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
Stack: <signature> <pubKey> <pubKeyHash> <pubKeyHash>
Script: OP_EQUALVERIFY OP_CHECKSIG
Stack: <signature> <pubKey>
Script: OP_CHECKSIG
Stack: true or false. Script: empty.
```
`OP_DUP `复制栈顶的元素。`OP_HASH160 `获得栈顶的元素用`RIPEMD160 `算法对它进行哈希运算；结算结果重新放回栈中。

`OP_EQUALVERIFY `比较连个堆顶的元素，如果两者不相等，结束脚本。`OP_CHECKSIG `通过对交易记录进行哈希计算以及`<signature> `和 `<pubKey>`数据验证一个交易记录的签名。后面的操作符非常复杂：首先不完整复制一份交易记录，求取哈希值（因为它是一个签名过的交易记录的哈希），然后用输入的`<signature> `和 `<pubKey> `验证签名是正确的。

有这样的脚本语言给比特币成为一个智能合约平台也创造了条件：脚本语言让其它的支付方案变得可能，不再是单一的比特币。

# 结论 Conclusion


然后就这样！我们已经基本实现了基于区块链的数字货币的所有特性。我们有区块链、地址、挖矿、还有交易记录。但是还有一个给这些机制以生命并让比特币成为一个全球系统：共识机制（consensus）。在下一篇文章当中，我们将开始开始实现区块链的“分布式”（decengtralized）部分。

敬请继续关注！

# 链接 Links:

- [Full source codes](https://github.com/Jeiwan/blockchain_go/tree/part_6)
- [The UTXO Set](https://en.bitcoin.it/wiki/Bitcoin_Core_0.11_(ch_2):_Data_Storage#The_UTXO_set_.28chainstate_leveldb.29)
- [Merkle Tree](https://en.bitcoin.it/wiki/Protocol_documentation#Merkle_Trees)
- [Script](https://en.bitcoin.it/wiki/Script)
- [“Ultraprune” Bitcoin Core commit](https://github.com/sipa/bitcoin/commit/450cbb0944cd20a06ce806e6679a1f4c83c50db2)
- [UTXO set statistics](https://statoshi.info/dashboard/db/unspent-transaction-output-set)
- [Smart contracts and Bitcoin](https://medium.com/@maraoz/smart-contracts-and-bitcoin-a5d61011d9b1)
- [Why every Bitcoin user should understand “SPV security”](https://medium.com/@jonaldfyookball/why-every-bitcoin-user-should-understand-spv-security-520d1d45e0b9)
