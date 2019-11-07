---
title: 如何用Go打造区块链（7）—网络
date: 2019-11-07 20:06:24
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

到目前为止，我们构建了一个含有以下特征的区块链：匿名、安全、以及随机产生地址；区块链数据存储；PoW系统；可靠的交易记录存储方式。这些特征都非常关键，但是这还不够。能够让这些特征升华的，并且让加密货币变得可能的，是网络（network）。这样的区块链实现如果只能在单一的电脑上面运行有什么用？这些基础加密特性有什么有，如果仅有一个用户？网络让这些机制工作并发挥作用。

你可以将这些区块链的特征视为基本准则，你会发现与人类希望共同生活和成长的准则类似。一种社会性的安排。区块链网络是遵从同样准则的程序社区，也正是遵从这些准则让这个网络变得活力四射。同样的，当人们分享共同的想法，他们将变得更强，然后可以一起构建更美好的生活。如果其中有人遵从不一样的准则，他们将在一个隔离的社会（国家、社区等）里生活。同样的，如果有一个区块链节点执行不一样的规则，它们将形成一个单独的网络。

这个非常重要：没有一个有共识的网络或者大部分节点有共识的网络，这些规则就毫无用处。

>免责声明：不幸的是，我没有足够的时间去实现一个真正的P2P网络原型。在这篇文章当中，我会证明一个最平常的情景，会涉及不同类型的节点。提高这个场景然后将它实现为一个真正的P2P 网络会是各位读者一个绝好的挑战和实践！我也不能保证除了本文所实现的情景以外的其它情景能够解决问题。对不起！
>这部分介绍了关键的代码变化，因此在这里解释所有的代码不是特别有意义。可以参看[这个页面](https://github.com/Jeiwan/blockchain_go/compare/part_6...part_7#files_bucket)看与上一部分文章之间的代码变动。

# 区块链网络 Blockchain Network


区块链网络是去中心化的，这意味着没有服务器提供服务，然后客户端通过服务区获取或处理数据。在区块链网络当中分布着不同的节点（nodes），每一个节点都是网络上完整（full-fledged）的节点。一个节点就是所有：即是节点也是服务器。这个非常重要，必须牢牢记住，因为这与普通的 web 应用完全不同。

区块链网络是一个 P2P （Peer-to-Peer）网络，这意味着各个节点与其它节点之间直接连接。它的拓扑结构是平的，在节点规则当中没有层级关系。下面是它的示意图：

![](https://jeiwan.net/images/p2p-network.png)


[(Business vector created by Dooder - Freepik.com)](https://www.freepik.com/dooder)

这样的网络当中的节点更难以实现，因为它们需要执行很多的操作。每一个节点都要与其它不同的节点之间互动，它需要获得其它节点的状态，并与自己的状态对比，如果发现自己的状态不是最新的还需要更新自己的状态。

# 节点角色 Node Roles

除了要全能以外，区块链节点可以在网络中扮演不同的角色。如下所示：


- 矿机。

这样的节点运行在超强性能或者专门的硬件（比如ASIC）上，它们的唯一目标就是尽快挖到新的区块。矿机仅在采用PoW机制的区块链上能够工作，因为挖矿本身实际上就是求解PoW谜题。打个比方，在采用PoS（Proof-of-Stake）机制的区块链上，并没有挖矿。

- 全能节点。

这些节点验证由矿机挖到的区块并确认交易记录。为了做这件事情，它们必须要有区块链的整个网站拷贝。这样的节点也履行一些日常的操作，比如帮助其它节点去发现彼此。一个网络必须要有很多全能节点，这个非常重要，因为是这些节点在做这样的决定：它们决定着一个区块或者交易记录是否合法有效。

- 简单支付验证 SPV.

简单支付验证（Simplified Payment Verification）。承担简单支付验证的节点并不保存区块链的完整拷贝，但是它们依然可以验证交易记录（并不是所有的，是一个子集，举个例子，比如发往特定地址的的）。一个SPV 节点依赖于一个全能节点获取数据，一个全能节点会有很多个SPV节点连接。SPV节点让钱包应用变得可能：你不用下载整个区块链，但是依然可以验证你的交易记录。

# 网络简化 Network simplification

为了在我们的区块链中实现网络，我们需要简化一些东西。问题在于我们并没有很多台电脑用来模拟一个拥有很多节点的网络。我们原本可以使用虚拟机或者 Docker 来解决这个问题，但是这会让事情变得更加复杂：我们的目的原本关注于区块链的实现，但是你必须又要提供虚拟机或者 Docker的应对措施。因此，我们要在单机上同时运行多个拥有不同地址的节点。为了取得这样的效果，我们将不同的端口视为不同的节点，以代替IP 地址。举了例子，会有以下不同地址的节点：127.0.0.1:3000, 127.0.0.1:3001, 127.0.0.1:3002等。我们将调用端口节点ID 并用` NODE_IDenvironment` 变量来设置它们。这样，你可以打开多个命令行窗口，设置不同的`NODE_IDs` 就有不同的节点运行。

这个方法也要求不同的区块链和钱包文件。它们现在依赖于节点 ID并被命名为 blockchain_3000.db, blockchain_30001.db and wallet_3000.db, wallet_30001.db等。

# 实现 Implementation

那么问题来了，当我们下载比特币内核并首次运行会发生什么？它必须连接到一些节点去下载区块链的最先状态。假如你的电脑不被有些比特币识别，那么这个让你下载区块链的节点又在哪里呢？

在比特币内核中硬编码一个节点地址会是一个错误：节点会被攻击或者关机，导致新的节点无法加入网络。相应的，在比特币内核当中，有硬编码的 DNS seeds 。它们不是节点，是知道一些节点IP地址的DNS 服务器。当你开始一个全新的比特币内核是，它会连接到其中的一个 种子（seed）然后获得一份全能节点的列表，然后从它们那里下载区块链。

在我们的实现当中，目前也是集中式的。我们会有以下三个节点：

- 中央节点。这是其它所有节点都会连接的，也是与其它节点交互数据的节点。
- 一个挖矿节点。这个节点会在内存池保存新的交易记录，并且当有足够的交易记录时，会挖一个新的区块。
- 一个钱包节点。这个节点用于在钱包之前转移币。不像SPV节点，它保存一份完整的区块链拷贝。

# 情景 The Scenario


这篇文章的目的是实现以下场景：

- 中央节点创建一个区块链。
- 其它节点（钱包节点）连接到中央节点并下载区块链。
- 还有一个挖矿节点将连到中央节点并从中央节点下载区块链。
- 钱包节点创建交易记录。
- 挖矿节点接收交易记录并将它保存在自己的内存池当中。
- 当内存池中的交易记录足够多时，矿工便开始挖新的区块。
- 当一个新的区块被挖出来，它将会被发送到中央节点。
- 钱包节点会与中央节点同步。
- 钱包节点的用户会检查它们的支付是否成功。
- 这就是比特币看起来的样子。即便我们没有准备构建一个实际的P2P网络，但是我们所实现的也是一个实际的、主要以及最重要的比特币案例。

# 版本 version

节点之间都过消息的方式进行沟通交流。当一个新节点运行，它会从一个DNS种子获得一些已有节点的地址，便向它们发送版本消息，在我们的实现中看起来像下面的样子：

```go
type version struct {
    Version    int
    BestHeight int
    AddrFrom   string
}
```

我们只有一个区块链版本，所以在 `Version` 结构体的字段中并没有保存任何重要信息。`BestHeight` 字段保存节点的区块链的长度。`AddFrom `保存发送者的地址。

当一个节点收到一个版本信息时它应该干什么？它将以自己的版本信息进行回应。某种意义上，这就像握手：双方之间没有一方的主动示意互动便不可能。但这又不仅仅是礼貌：版本用于寻找一个更长的区块。当一个节点收到一个版本信息它将检查节点的区块链是否比BestHeigh 字段中的值长。假如不是，节点会要求与下载缺失的区块。

为了收到消息，我们需要一个服务器：

```go
var nodeAddress string
var knownNodes = []string{"localhost:3000"}

func StartServer(nodeID, minerAddress string) {
    nodeAddress = fmt.Sprintf("localhost:%s", nodeID)
    miningAddress = minerAddress
    ln, err := net.Listen(protocol, nodeAddress)
    defer ln.Close()

    bc := NewBlockchain(nodeID)

    if nodeAddress != knownNodes[0] {
        sendVersion(knownNodes[0], bc)
    }

    for {
        conn, err := ln.Accept()
        go handleConnection(conn, bc)
    }
}
```

首先，我们硬解码中央节点的地址：一开始，每一个节点都必须知道要连接到哪里。`minerAddress` 参数指定了挖矿奖励的接收地址。下面这段：

```go
if nodeAddress != knownNodes[0] {
    sendVersion(knownNodes[0], bc)
}
```

意味着假如目前的节点不是中央节点，它必须向中央节点发送版本信息并确认它的区块链是否过时了。

```go
func sendVersion(addr string, bc *Blockchain) {
    bestHeight := bc.GetBestHeight()
    payload := gobEncode(version{nodeVersion, bestHeight, nodeAddress})

    request := append(commandToBytes("version"), payload...)

    sendData(addr, request)
}
```


我们的消息，在底层的角度看，是字节序列。前面12个字节指定了命令名字（“version”，在这个案例中），后面的字节包含 `gob-encoded` 信息结构体。`commandToBytes` 看起来是这样的：

```go
func commandToBytes(command string) []byte {
    var bytes [commandLength]byte

    for i, c := range command {
        bytes[i] = byte(c)
    }

    return bytes[:]
}
```

它创建了一个 12-byte 的缓冲，并用命令名去覆盖它，让剩下的字节留空。相应的逆函数如下：

```go
func bytesToCommand(bytes []byte) string {
    var command []byte

    for _, b := range bytes {
        if b != 0x0 {
            command = append(command, b)
        }
    }

    return fmt.Sprintf("%s", command)
}
```

当一个节点收到一个命令，它调用` bytesToCommand `获取命令名字并以正确的操作执行命令体：

```go
func handleConnection(conn net.Conn, bc *Blockchain) {
    request, err := ioutil.ReadAll(conn)
    command := bytesToCommand(request[:commandLength])
    fmt.Printf("Received %s command\n", command)

    switch command {
    ...
    case "version":
        handleVersion(request, bc)
    default:
        fmt.Println("Unknown command!")
    }

    conn.Close()
}
```

OK，版本命令的处理内容如下：

```go
func handleVersion(request []byte, bc *Blockchain) {
    var buff bytes.Buffer
    var payload verzion

    buff.Write(request[commandLength:])
    dec := gob.NewDecoder(&buff)
    err := dec.Decode(&payload)

    myBestHeight := bc.GetBestHeight()
    foreignerBestHeight := payload.BestHeight

    if myBestHeight < foreignerBestHeight {
        sendGetBlocks(payload.AddrFrom)
    } else if myBestHeight > foreignerBestHeight {
        sendVersion(payload.AddrFrom, bc)
    }

    if !nodeIsKnown(payload.AddrFrom) {
        knownNodes = append(knownNodes, payload.AddrFrom)
    }
}
```

首先，我们需要解码 `request `然后获取 `payload`。这与其它所有的操作函数类似，所以在后面的片段当中我将省略这部分代码。

然后一个节点比较它的 `BestHeight `与从信息中得到的大小。假如节点的区块链更长，它将回应自己的版本信息；否则，它会发送 `getblocks `消息。

# 获得区块 getblocks

```go
type getblocks struct {
    AddrFrom string
}
```

`getblocks `意味着“给我看看你有什么区块”（在比特币当中，要比这个要复杂得多）。需要注意的是，这并不是说“给我你所有的区块”，而是给我一个区块哈希值的列表。这样有助于降低网络负荷，因为区块可以从不同的节点下载，而且我们也不愿意从一个节点下载Gb级别以上的数据。

处理命令简单如下：

```go
func handleGetBlocks(request []byte, bc *Blockchain) {
    ...
    blocks := bc.GetBlockHashes()
    sendInv(payload.AddrFrom, "block", blocks)
}
```

在我们的简单实现当中，`handleGetBlocks `会返回所有的区块哈希值。

# inv

```go
type inv struct {
    AddrFrom string
    Type     string
    Items    [][]byte
}
```

比特币使用 `inv `来告诉其它节点当前节点有什么区块和交易记录。同样的，它不包含所有的区块和交易记录，只是它们的哈希值。`Type `字段表明它们是区块还是交易记录。

`inv `命令的处理要稍微难一些：

```go
func handleInv(request []byte, bc *Blockchain) {
    ...
    fmt.Printf("Recevied inventory with %d %s\n", len(payload.Items), payload.Type)

    if payload.Type == "block" {
        blocksInTransit = payload.Items

        blockHash := payload.Items[0]
        sendGetData(payload.AddrFrom, "block", blockHash)

        newInTransit := [][]byte{}
        for _, b := range blocksInTransit {
            if bytes.Compare(b, blockHash) != 0 {
                newInTransit = append(newInTransit, b)
            }
        }
        blocksInTransit = newInTransit
    }

    if payload.Type == "tx" {
        txID := payload.Items[0]

        if mempool[hex.EncodeToString(txID)].ID == nil {
            sendGetData(payload.AddrFrom, "tx", txID)
        }
    }
}
```

如果区块哈希被转移了，我们要将它们保存在 `blockInTransit `变量当中以便跟踪下载的区块。这允许我们从不同的节点下载区块。当我们将区块放到传输状态以后，我向 `inv `信息的发送者下达 `getdata `命令然后更新 `blockInTransit`。在一个实际的`P2P `网络当中，我们需要在不同的节点之间传送区块。

在我们的实现当中，我们从不用 `inv `多个哈希值。这是为什么当 `payload.Type == "tx"`只是获取了第一个哈希值。然后我们检查我们的内存池中是否已经有这个哈希，如果没有，下达 `getdata `命令。

# getdata

```go
type getdata struct {
    AddrFrom string
    Type     string
    ID       []byte
}
```

`getdata `是针对特定区块或者交易记录的请求，它可以只包含一个区块／交易记录 ID。

```go
func handleGetData(request []byte, bc *Blockchain) {
    ...
    if payload.Type == "block" {
        block, err := bc.GetBlock([]byte(payload.ID))

        sendBlock(payload.AddrFrom, &block)
    }

    if payload.Type == "tx" {
        txID := hex.EncodeToString(payload.ID)
        tx := mempool[txID]

        sendTx(payload.AddrFrom, &tx)
    }
}
```


这个函数的处理方式非常简单：如果它们需要一个区块，返回一个区块；如果它们需要一个交易记录，返回交易记录。注意，我们并不检查实际上我们是否有这样的区块或者交易记录。这是一个瑕疵：）

# block and tx

```go
type block struct {
    AddrFrom string
    Block    []byte
}

type tx struct {
    AddFrom     string
    Transaction []byte
}
```


正是这些消息实际上在做着数据传送的事情。

处理`block `消息非常简单：

```go
func handleBlock(request []byte, bc *Blockchain) {
    ...

    blockData := payload.Block
    block := DeserializeBlock(blockData)

    fmt.Println("Recevied a new block!")
    bc.AddBlock(block)

    fmt.Printf("Added block %x\n", block.Hash)

    if len(blocksInTransit) > 0 {
        blockHash := blocksInTransit[0]
        sendGetData(payload.AddrFrom, "block", blockHash)

        blocksInTransit = blocksInTransit[1:]
    } else {
        UTXOSet := UTXOSet{bc}
        UTXOSet.Reindex()
    }
}
```


当我们收到一个新的区块，我们将它放到我们的区块链。假如还有更多的区块需要下载，我们将从已下载其之前区块的节点下载。当我们最终下载完全部区块，`UTXO set `会重新索引。

> TODO：在将它加入到区块链之前，我们需要验证每一个进来的区块，而不是无条件地信任。
> TODO：如果区块链很大的话，这会花很多时间去重新索引整个 UTXO set，因此采用UTXOSet.Update(block)，而不是运行UTXOSet.Reindex()。


处理 `tx `消息是最复杂的部分：

```go
func handleTx(request []byte, bc *Blockchain) {
    ...
    txData := payload.Transaction
    tx := DeserializeTransaction(txData)
    mempool[hex.EncodeToString(tx.ID)] = tx

    if nodeAddress == knownNodes[0] {
        for _, node := range knownNodes {
            if node != nodeAddress && node != payload.AddFrom {
                sendInv(node, "tx", [][]byte{tx.ID})
            }
        }
    } else {
        if len(mempool) >= 2 && len(miningAddress) > 0 {
        MineTransactions:
            var txs []*Transaction

            for id := range mempool {
                tx := mempool[id]
                if bc.VerifyTransaction(&tx) {
                    txs = append(txs, &tx)
                }
            }

            if len(txs) == 0 {
                fmt.Println("All transactions are invalid! Waiting for new ones...")
                return
            }

            cbTx := NewCoinbaseTX(miningAddress, "")
            txs = append(txs, cbTx)

            newBlock := bc.MineBlock(txs)
            UTXOSet := UTXOSet{bc}
            UTXOSet.Reindex()

            fmt.Println("New block is mined!")

            for _, tx := range txs {
                txID := hex.EncodeToString(tx.ID)
                delete(mempool, txID)
            }

            for _, node := range knownNodes {
                if node != nodeAddress {
                    sendInv(node, "block", [][]byte{newBlock.Hash})
                }
            }

            if len(mempool) > 0 {
                goto MineTransactions
            }
        }
    }
}
```

最先要做的事情就是将新的交易记录放到内存池当中（再强调一遍，将交易记录放入内存池之前必须进行验证）。下一段：

```go
if nodeAddress == knownNodes[0] {
    for _, node := range knownNodes {
        if node != nodeAddress && node != payload.AddFrom {
            sendInv(node, "tx", [][]byte{tx.ID})
        }
    }
}
```

检查当前节点是否就是中央节点。在我们的实现当中，中央节点不进行挖矿作业。而是在网络当中转发新的交易记录给其它的节点。

下一大段代码只针对挖矿节点。让我们将它分成几部分：

```go
if len(mempool) >= 2 && len(miningAddress) > 0 {
```

`miningAddress `只是在挖矿节点中设置。当有2个或2个以上的交易记录在当前挖矿节点的内存池当中的时候，挖矿便开始了。

```go
for id := range mempool {
    tx := mempool[id]
    if bc.VerifyTransaction(&tx) {
        txs = append(txs, &tx)
    }
}

if len(txs) == 0 {
    fmt.Println("All transactions are invalid! Waiting for new ones...")
    return
}
```


首先，所有在内存池中的交易记录得到验证。非法的交易记录会被忽略，如果没有合法的交易记录，挖矿会被中断。

```go
cbTx := NewCoinbaseTX(miningAddress, "")
txs = append(txs, cbTx)

newBlock := bc.MineBlock(txs)
UTXOSet := UTXOSet{bc}
UTXOSet.Reindex()

fmt.Println("New block is mined!")
```

验证过的交易记录会放入到区块当中，包括含有奖励的币基交易记录。在挖矿区块以后，`UTXO set`将重新索引。

> TODO：再一次强调，UTXOSet.Update 应该代替UTXOSet.Reindex使用。

```go
for _, tx := range txs {
    txID := hex.EncodeToString(tx.ID)
    delete(mempool, txID)
}

for _, node := range knownNodes {
    if node != nodeAddress {
        sendInv(node, "block", [][]byte{newBlock.Hash})
    }
}

if len(mempool) > 0 {
    goto MineTransactions
}
```

当一个交易记录被挖出以后，它将从内存池中移除。任何知道当前节点的其它节点，收到含有新区块哈希值的 `inv `消息。在处理了这些消息以后它可以对这个区块提出要求。

# 结果 Result


让我们试一下我们之前定义的场景。

首先，在第一个终端窗口设置`NODE_ID `为3000（export NODE_ID=3000）。为了不混淆哪个节点所对应的命令行，我将在在下一个段落之前在每段代码前面设置像NODE 3000 或者 NODE 3001的标签。

- NODE 3000

新建一个钱包和一个区块链：

```go
$ blockchain_go createblockchain -address CENTREAL_NODE
```

(为了简洁和清晰，我将使用假地址)


在这之后，区块链包含了单一的创世区块。我需要保存这个区块并在其它节点中使用。创世区块用来区分不同的区块链。（在比特币内核当中，创世区块是硬编码的）

```go
$ cp blockchain_3000.db blockchain_genesis.db 
```

- NODE 3001

下一步，打开一个新的终端窗口并将节点ID设置为3001。这将是一个钱包节点。用`blockchain_go createwallet `新建一些地址，我们将它们命名为 `WALLET_1, WALLET_2, WALLET_3`。

- NODE 3000

发一些币给钱包地址：

```go
$ blockchain_go send -from CENTREAL_NODE -to WALLET_1 -amount 10 -mine
$ blockchain_go send -from CENTREAL_NODE -to WALLET_2 -amount 10 -mine
```

-mine 标签意味着区块会马上被同一个节点挖到。我们必须得有这个标签，因为开始的时候在网络当中并没有挖矿节点。

开始节点：

```go
$ blockchain_go startnode
```

节点必须运行直到节点的最后。

- NODE 3001


用之前保存的创世区块开始节点的区块链

```go
$ cp blockchain_genesis.db blockchain_3001.db
```

运行这个节点：

```go
$ blockchain_go startnode
```

这会从中央节点下载所有的区块。为了检验一些正常，停止这个节点然后查询余额：

```go
$ blockchain_go getbalance -address WALLET_1
Balance of 'WALLET_1': 10

$ blockchain_go getbalance -address WALLET_2
Balance of 'WALLET_2': 10
```

同样，你也可以检查`CENTRAL_NODE`地址的余额，因为节点3001现在已经有它的区块链了：

```go
$ blockchain_go getbalance -address CENTRAL_NODE
Balance of 'CENTRAL_NODE': 10
```

- NODE 3002

打开一个新的终端并将ID设置为3002，然后产生一个钱包。这将是一个挖矿节点。对区块链进行初始化：

```go
$ cp blockchain_genesis.db blockchain_3002.db
```

然后开始节点：

```go
$ blockchain_go startnode -miner MINER_WALLET
```

- NODE 3001

发一些币：

```go
$ blockchain_go send -from WALLET_1 -to WALLET_3 -amount 1
$ blockchain_go send -from WALLET_2 -to WALLET_4 -amount 1
```

- NODE 3002

非常快！切换到挖矿节点然后可以看到它挖了一个新的区块！也可以检查中央节点的输出。

- NODE 3001

切换到钱包节点然后开始这个节点：

```go
$ blockchain_go startnode
```

它会下载新挖的区块！

停止它，然后检查余额：

```go
$ blockchain_go getbalance -address WALLET_1
Balance of 'WALLET_1': 9

$ blockchain_go getbalance -address WALLET_2
Balance of 'WALLET_2': 9

$ blockchain_go getbalance -address WALLET_3
Balance of 'WALLET_3': 1

$ blockchain_go getbalance -address WALLET_4
Balance of 'WALLET_4': 1

$ blockchain_go getbalance -address MINER_WALLET
Balance of 'MINER_WALLET': 10
```

嗯，就这样！

# 结论 Conclusion


这是系列文章的最后一部分。我原本可以发表更多的文章来实现一个P2P网络的现实原型，但是实在没有时间做这件事情。我希望这篇文章能够回答你们关于比特币技术的问题并提出一些新的问题，然后你们可以自己寻找答案。比特币技术当中还有很多更有趣的事情隐藏着！祝各位好运！

P.S. 你可以开始通过实现`addr `消息来提高网络的性能，正如比特币网络协议当中所描述的，链接如下。这是非常重要的消息，因为它允许节点去发现彼此。我开始实现它，但是还没有完成。

# Links:

- [Source codes](https://github.com/Jeiwan/blockchain_go/tree/part_7)
- [Bitcoin protocol documentation](https://en.bitcoin.it/wiki/Protocol_documentation)
- [Bitcoin network](https://en.bitcoin.it/wiki/Network)
