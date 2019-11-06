---
title: 如何用Go打造区块链（5）—地址
date: 2019-11-06 19:33:42
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

# 介绍（Introduction）

在 [上一篇文章](http://datacruiser.io/2019/11/06/%E5%A6%82%E4%BD%95%E7%94%A8Go%E6%89%93%E9%80%A0%E5%8C%BA%E5%9D%97%E9%93%BE%EF%BC%884%EF%BC%89%E2%80%94%E4%BA%A4%E6%98%93%E8%AE%B0%E5%BD%95%EF%BC%88%E4%B8%80%EF%BC%89/)中，我们开始实现了交易记录。大家也了解到了交易记录的内在本质：没有用户账户数据，不需要你的个人信息（比如姓名、护照号、身份证号码等）存储在比特币系统当中。但是依然需要一些东西能够证明你是交易记录输出的所有者（输出当中锁定着输出拥有者的币值）。这是需要有比特币地址（Bitcoin addresses）的原因。到目前为止我使用用户随机定义IDE字符串为地址，现在是时候实现实际的地址了，就像它在比特币中所实现的那样。

> 这部分的代码改动很大，依然没有意义去解释所有的变动。可以到[这个页面](https://github.com/Jeiwan/blockchain_go/compare/part_4...part_5#files_bucket)去查看与上一篇文章之间的代码变动。

# 比特币地址（Bitcoin Address）

这是一个比特币地址的例子：[1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa](https://www.blockchain.com/btc/address/1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa)。这是第一个比特币地址，传闻属于中本聪本人。比特币地址是公开的。假如你想要向某人发送一些比特币，你需要知道他们的地址。但是地址（尽管是独一无二的）并不能证明你就是某一个“钱包”的主人。事实上，这样的地址只是一种公钥（public keys）大众可读的映射（human readable representation）。在比特币当中，通过一对存储在你的电脑或者其它你有权限进入的电脑的秘钥，公钥（public keys）和私钥来证明你对比特币的所有权。比特币依靠 一些列的加密算法来产生这些秘钥，确保在这个世界上没有人可以在没有物理得到你的秘钥的情况下进入你的比特币，让我们来讨论这些算法先。

# 公钥加密（Public-ley Cryptography）

公钥加密算法需要一对秘钥：公钥和私钥。公钥并不敏感，可以透露给别人。相应的，私钥不能透露：因为私钥是所有者的身份证明，只有所有者才有权限查看。你就是你的私钥（在加密货币的世界里，必然的）。

本质上，一个比特币钱包就是一对这样的密钥（公钥和私钥）。当你安装钱包应用或者用一个比特币客户端来产生一个新的地址，一对密钥就这样的为了产生了。控制私钥的人掌握着所有发到这个地址的比特币。

私钥和公钥在表现上只是随机字节序列，因此无法直接阅读或者在屏幕上面打印。这也是为什么比特币采用一种将公钥转换为可读字符串算法的原因。

> 如果你曾经使用过一个比特币钱包应用，它就像一个专门为你产生的助记口诀。这样的字段将代替私钥来使用并且能够通过它们产生私钥。这个机制在[BIP-039](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)中实现。

好了，现在我们知道在比特币系统中用什么来标识用户。但是如何检查交易记录输出的所有权关系以及存储在里面的比特币？

# 数字签名（Digital Signatures）

在数学以及密码学上，有一个数字签名的概念—能够保证以下几点的算法：

- 从发送者到接收者的数据传递不会改变数据
- 数据由一个确定的发送者创建
- 发送者不能否认发送数据

通过对数据应用签名算法（对数据进行签名），用户可以取得一个签名，随着这个签名可以得到验证。数字签名发生在私钥的使用上，然后需要一个公钥才能够得到验证。

为了对数据进行数字签名，我们需要以下东西：

- 待签名的数据
- 私钥

签名过程中所产生的签名将存储在交易记录输入当中。为了验证签名，需要具备以下条件：

- 被签过名的数据
- 签名
- 公钥

简单地说，验证过程可以描述如下：确认这个签名就是用一个私钥从这个数据中获得并用于产生相应的公钥。

> 数据签名不是加密，你无法从一个签名当中重构出数据。它与哈希过程类似：你用对数据跑一遍哈希算法然后取得一个代表数据的独一无二的哈希值。签名与哈希之前的区别在于密钥对：这让签名的验证变得可能。
> 但是密钥对也可用于数据加密：私钥用于加密，公钥用于解密。虽然比特币并没有采用加密算法。

比特币中每一个交易记录输入都被创建这个交易记录的人签过名。每一个交易记录在存入区块之前都必须得到验证。验证（除了其它程序）意味着：

- 确认输入有权限使用来自上一个交易记录的输出
- 确认交易记录的签名是正确的

![](https://jeiwan.net/images/signing-scheme.png)

签名及验证过程示意图

现在让我们来看看一个交易记录的生命周期：

- 开始的时候，只有创始区块包含币基交易记录。币基交易记录当中并没有实际的输入，因此并不需要签名。币基交易记录的输出包含一个哈希计算过的公钥（采用RIPEMD16(SHA256(PubKey))进行计算）
- 当一个人发送一个比特币，将创建一个交易记录。这个交易记录的输入将于前面一个交易记录的输出相对应。每一个输入将存储一个未哈希计算过的公钥和整个交易记录的签名
- 比特币网络中的其他收到这个交易记录的节点将会对它进行验证。除了其它事情，它们会确认：一个输入公钥的哈希与相对应的输出的哈希相匹配（这个确保发送者只是花了属于他们自己的比特币）；签名是正确的（确保交易记录由实际的比特币拥有者创建）
- 当一个挖矿节点准备去挖一个新的区块时，它首先在区块中放一个交易记录然后开始挖矿
- 当一个区块被挖出来以后，网络上的其它节点会收到一个信息，表示有一个新的区块产生并在大家验证以后被加入到区块链中
- 在区块被加入到区块链当中，交易记录便完成了，它的输出可以被新的交易记录引用

# 椭圆曲线密码学（Elliptic Curve Cryptography）

正如之前所描述的，公钥和私钥是随机字节序列。因为私钥会用于比特币拥有者的身份证明，因此需要一个条件：随机数算法必须能够产生真随机字节。我们并不希望产生一个会被多个人拥有的私钥。

比特币用椭圆曲线来产生私钥。椭圆曲线是一个复杂的数学概念，我们并不打算在这里详细解释（如果你够好奇，可以参考[椭圆曲线的产生]()，警告：数学公式！）。我们所要知道的是这些曲线可以用来产生真的大随机数。比特币中所使用的曲线可以随机从$0~2^256$之间取一个数（大约$10^77$，在可见的宇宙范围内大约有$10^78$ 到 $10^82$个原子。）如此大的上限基本确保不太可能产生两次产生同一个私钥。

此外，比特币（包括我们）采用`ECDSA（Elliptic Curve Digital Signature Algorithm）`算法来对交易记录进行签名。

# Base58

现在让我回到前面提到过的比特币地址：

```go
1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa.
```

现在我们知道它是人类可读的一串公钥。如果我们对它进行解码，下面是公钥看起来的样子（以16进制书写的一串字节码）

```go
0062E907B15CBF27D5425399EBF6F0FB50EBB88F18C29B7D93
```

比特币采用 `Base58 `算法将公钥转换为人类可读的格式。这个算法与著名的` Base64 `算法类似，不过采用更短的字母表：一些字符从字母表中删除以避免相似字符攻击。因此，以下字符不再字母表中：0（数字零），O（字母O），I（字母i），l（小写L），因为它们看起来很容易混淆。此外，+和/也没有。

让我们看一下如何从一个公钥产生地址的示意：

![](https://jeiwan.net/images/address-generation-scheme.png)

这样，前面所提到的解码后的比特币地址（Bitcoin Address）包含三部分：

```go
Version  Public key hash                           Checksum
00       62E907B15CBF27D5425399EBF6F0FB50EBB88F18  C29B7D93
```


因为哈希函数是单向不可逆的，从哈希值获得公钥是不可能的。但是我们可以通过将公钥代入存储的哈希函数看它所产生的哈希值并进行比较以确认某一个公钥是否对应一个特定的哈希。

好了，所有的相关概念已经介绍清楚了，让我们来写一些代码吧。在写代码的过程当中有些概念会变得更为清晰。

# 地址的实现（Implementing Addresses）

我们将从钱包结构体开始：

```go
type Wallet struct {
	PrivateKey ecdsa.PrivateKey
	PublicKey  []byte
}

type Wallets struct {
	Wallets map[string]*Wallet
}

func NewWallet() *Wallet {
	private, public := newKeyPair()
	wallet := Wallet{private, public}

	return &wallet
}

func newKeyPair() (ecdsa.PrivateKey, []byte) {
	curve := elliptic.P256()
	private, err := ecdsa.GenerateKey(curve, rand.Reader)
	pubKey := append(private.PublicKey.X.Bytes(), private.PublicKey.Y.Bytes()...)

	return *private, pubKey
}
```

一个钱包只是一对密钥。我们同样需要钱包门（Wallets）类型来保存钱包的一个集合，保存到一个文件，并从文件中载入钱包。在钱包的构造函数当中一对新的密钥产生。`newKeyPair `函数非常清晰明了：`ECDSA`是基于椭圆曲线算法，所以我们需要一个。下一步，通过曲线产生一个私钥，公钥从私钥产生。有一点需要注意：在基于椭圆曲线的算法当中，公钥是曲线上面的点。这样，一个公钥是一个（X，Y）坐标的组合。在比特币当中，这些坐标被连接起来然后现成一个公钥。

现在，让我们来产生一个地址：

```go
func (w Wallet) GetAddress() []byte {
	pubKeyHash := HashPubKey(w.PublicKey)

	versionedPayload := append([]byte{version}, pubKeyHash...)
	checksum := checksum(versionedPayload)

	fullPayload := append(versionedPayload, checksum...)
	address := Base58Encode(fullPayload)

	return address
}

func HashPubKey(pubKey []byte) []byte {
	publicSHA256 := sha256.Sum256(pubKey)

	RIPEMD160Hasher := ripemd160.New()
	_, err := RIPEMD160Hasher.Write(publicSHA256[:])
	publicRIPEMD160 := RIPEMD160Hasher.Sum(nil)

	return publicRIPEMD160
}

func checksum(payload []byte) []byte {
	firstSHA := sha256.Sum256(payload)
	secondSHA := sha256.Sum256(firstSHA[:])

	return secondSHA[:addressChecksumLen]
}
```

下面是将一个公钥转化为一个 `Base58 `地址的步骤：

- 取得公钥然后用`RIPEMD160(SHA256(PubKey) `算法对它进行两次哈希计算
- 预先将地址产生算法的版本给哈希
- 用`SHA256(SHA256(payload))` 哈希计算步骤2的结果来获得 `checksum`。`checksum` 是所得哈希值的前四个字节
- 将`checksum` 加到`version + PubKeyHash` 组合后面
- 对`version + PubKeyHash + checksum` 组合进行` Base58` 编码

根据以上步骤，我们可以获得一个实际的比特币地址，你甚至可以到 blockchain.info 上去检查它的余额。但是我能够确保不过你尝试多少次所能够查询到的余额都是0。这就是选择合适的公钥加密算法如此重要的原因：考虑到私钥是随机数，产生相同随机数的机会应该尽可能地低。理想的，应该是几乎不可能。

同时，你并不需要连接到一个比特币节点就能够产生地址。地址产生算法采用了由许多程序语言和库实现的开源算法组合。

现在我们需要修改输入和输出代码来使用前面产生的地址：

```go
type TXInput struct {
	Txid      []byte
	Vout      int
	Signature []byte
	PubKey    []byte
}

func (in *TXInput) UsesKey(pubKeyHash []byte) bool {
	lockingHash := HashPubKey(in.PubKey)

	return bytes.Compare(lockingHash, pubKeyHash) == 0
}

type TXOutput struct {
	Value      int
	PubKeyHash []byte
}

func (out *TXOutput) Lock(address []byte) {
	pubKeyHash := Base58Decode(address)
	pubKeyHash = pubKeyHash[1 : len(pubKeyHash)-4]
	out.PubKeyHash = pubKeyHash
}

func (out *TXOutput) IsLockedWithKey(pubKeyHash []byte) bool {
	return bytes.Compare(out.PubKeyHash, pubKeyHash) == 0
}
```

注意，我们不再使用 `ScriptPubKey `和 `ScriptSig `字段，因为我们并不打算实现一个脚本语言。相应的的，`ScriptSig `分解为签名过的`PubKey `字段，而 `ScriptPubKey `被重命名为 `PubKeyHash`。我们将实现比特币中的输出 锁定/解锁 以及输出签名的逻辑，不过采用了其它的方法。

`UsesKey` 方法检查一个输入是否可以用一个特定的密钥去解锁一个输出。需要注意的输入存储的是原始的公钥（未哈希计算过的），但是这个函数采用的是哈希过的。 `IsLockedWithKey `检查提供的公钥哈希是否是用于去锁定输出。这是对`UsesKey `函数的补充，它们都在 `FindUnspendTransactions `当中用于构建交易记录之间的连接。

锁将输出简单地锁定了。当我们向其他人发送比特币，我只知道它们的地址，地址也是函数的唯一参数。然后地址被解码，然后抽取出公钥哈希值存入 PubKeyHash 字段。

现在，让我检查一下一切工作正常：

```go
$ blockchain_go createwallet
Your new address: 13Uu7B1vDP4ViXqHFsWtbraM3EfQ3UkWXt

$ blockchain_go createwallet
Your new address: 15pUhCbtrGh3JUx5iHnXjfpyHyTgawvG5h

$ blockchain_go createwallet
Your new address: 1Lhqun1E9zZZhodiTqxfPQBcwr1CVDV2sy

$ blockchain_go createblockchain -address 13Uu7B1vDP4ViXqHFsWtbraM3EfQ3UkWXt
0000005420fbfdafa00c093f56e033903ba43599fa7cd9df40458e373eee724d

Done!

$ blockchain_go getbalance -address 13Uu7B1vDP4ViXqHFsWtbraM3EfQ3UkWXt
Balance of '13Uu7B1vDP4ViXqHFsWtbraM3EfQ3UkWXt': 10

$ blockchain_go send -from 15pUhCbtrGh3JUx5iHnXjfpyHyTgawvG5h -to 13Uu7B1vDP4ViXqHFsWtbraM3EfQ3UkWXt -amount 5
2017/09/12 13:08:56 ERROR: Not enough funds

$ blockchain_go send -from 13Uu7B1vDP4ViXqHFsWtbraM3EfQ3UkWXt -to 15pUhCbtrGh3JUx5iHnXjfpyHyTgawvG5h -amount 6
00000019afa909094193f64ca06e9039849709f5948fbac56cae7b1b8f0ff162

Success!

$ blockchain_go getbalance -address 13Uu7B1vDP4ViXqHFsWtbraM3EfQ3UkWXt
Balance of '13Uu7B1vDP4ViXqHFsWtbraM3EfQ3UkWXt': 4

$ blockchain_go getbalance -address 15pUhCbtrGh3JUx5iHnXjfpyHyTgawvG5h
Balance of '15pUhCbtrGh3JUx5iHnXjfpyHyTgawvG5h': 6

$ blockchain_go getbalance -address 1Lhqun1E9zZZhodiTqxfPQBcwr1CVDV2sy
Balance of '1Lhqun1E9zZZhodiTqxfPQBcwr1CVDV2sy': 0
```

非常好！现在让我们来实现交易记录签名。

# 实现签名（Implementing Signatures）

交易记录必须签过名，因为在比特币中这是保证一个人无法使用不属于他的比特币的唯一方式。如果一个签名是非法的，交易记录也会被认为是非法的，无法加入到区块链当中。

我们已经有实现交易记录签名的所有东西，除了一件事情：用来签名的数据。交易记录的哪部分实际上是签过名的？或者一整个交易记录整体的签名？数字签名的选择非常重要。要求是用来签名的数据必须包含能够用唯一的方式识别数据的信息。举个例子，如果 对输出包含的币值进行签名是没有意义的，因为这个签名并不会考虑发送者和接收者。

考虑到交易记录解锁前一个输出，重新分配它们的币值，然后锁定新的输出，以下数据必须进行数字签名：

- 未解锁输出中保存的公钥哈希值。这会识别一个交易记录的“发送者”。
- 新的锁定的输出中存储的公钥哈希值。这会识别一个交易的“接收者”。
- 新输出所包含的币值。

> 在比特币当中，锁定/解锁的逻辑存储在脚本当中，分别存储在输入的 ScriptSigand 字段和输出的 ScriptPubKey 字段。因为比特币允许不同类型的脚本，它还会对 ScriptPubKey 的全部内容进行签名。

正如你所看到的，我们并不需要对输入当中存储的公钥进行签名。正因为如此，在比特币当中，这不是一个签过名的交易记录，而是它的带从引用的输出中来输入存储的 ScriptPubKey 字段的截取过的拷贝。

> 取得整理过的交易记录拷贝的详细过程在这里描述。这个可能有些过期，但是我无法找到一个更可靠的信息来源。

Ok，这看起来有些复杂，那么就让我们开始编程吧。我们从 `Sign `方法开始：

```go
func (tx *Transaction) Sign(privKey ecdsa.PrivateKey, prevTXs map[string]Transaction) {
	if tx.IsCoinbase() {
		return
	}

	txCopy := tx.TrimmedCopy()

	for inID, vin := range txCopy.Vin {
		prevTx := prevTXs[hex.EncodeToString(vin.Txid)]
		txCopy.Vin[inID].Signature = nil
		txCopy.Vin[inID].PubKey = prevTx.Vout[vin.Vout].PubKeyHash
		txCopy.ID = txCopy.Hash()
		txCopy.Vin[inID].PubKey = nil

		r, s, err := ecdsa.Sign(rand.Reader, &privKey, txCopy.ID)
		signature := append(r.Bytes(), s.Bytes()...)

		tx.Vin[inID].Signature = signature
	}
}
```

这个方法以一个私钥和之前的交易记录的`map`数据为输入。正如之前所言，为了对一个交易记录进行签名，我们需要进入这个交易记录当中的输入所引用的输出，因此我们需要存储这些输出的交易记录。

让我们一条条过这个方法：

```go
if tx.IsCoinbase() {
	return
}
```

因为币基交易记录中没有实际的输入所以不会被签名。

```go
txCopy := tx.TrimmedCopy()
```

截取过的交易记录拷贝会被签名，并不对整个交易记录：

```go
func (tx *Transaction) TrimmedCopy() Transaction {
	var inputs []TXInput
	var outputs []TXOutput

	for _, vin := range tx.Vin {
		inputs = append(inputs, TXInput{vin.Txid, vin.Vout, nil, nil})
	}

	for _, vout := range tx.Vout {
		outputs = append(outputs, TXOutput{vout.Value, vout.PubKeyHash})
	}

	txCopy := Transaction{tx.ID, inputs, outputs}

	return txCopy
}
```

这份拷贝会包含所有的输入和输出，但是 `TXInput.Signature `和`TXInput.PubKey `字段会被设为 `nil`。

下一步，我们会遍历这份拷贝中的所有输入：

```go
for inID, vin := range txCopy.Vin {
	prevTx := prevTXs[hex.EncodeToString(vin.Txid)]
	txCopy.Vin[inID].Signature = nil
	txCopy.Vin[inID].PubKey = prevTx.Vout[vin.Vout].PubKeyHash
```

在每一个输入当中，签名被设置为 `nil` （只是再次确认），并且 `PubKey `被设为引用的输出的 `PubKeyHash`。在这个时候，所有的交易记录，除了当前的交易记录都是“空的”（empty）。它们的 `Signature `和 `PubKey `字段被设为 `nil`。这样，输入会被单独的签名，虽然在我们的程序当中这并不需要，但是比特币允许交易记录包含引用不同地址的输入。

```go`
	txCopy.ID = txCopy.Hash()
	txCopy.Vin[inID].PubKey = nil
```

`Hash `方法将交易记录序列化并用`SHA-256 `算法进行哈希值计算。得到的哈希值是我们要进行签名的数据。得到这个哈希值以后我们应该重新设置 `PubKey `字段，以让他们对后面的遍历没有影响。

现在，最关键的代码段：

```go
	r, s, err := ecdsa.Sign(rand.Reader, &privKey, txCopy.ID)
	signature := append(r.Bytes(), s.Bytes()...)

	tx.Vin[inID].Signature = signature
```

我们用`privKey `对`txCopy.ID`进行签名。一个`ECDSA`签名是一对数字，是我们组合并存储在输入的 `Signature `字段当中的数字。

接下来，验证函数：

```go
func (tx *Transaction) Verify(prevTXs map[string]Transaction) bool {
	txCopy := tx.TrimmedCopy()
	curve := elliptic.P256()

	for inID, vin := range tx.Vin {
		prevTx := prevTXs[hex.EncodeToString(vin.Txid)]
		txCopy.Vin[inID].Signature = nil
		txCopy.Vin[inID].PubKey = prevTx.Vout[vin.Vout].PubKeyHash
		txCopy.ID = txCopy.Hash()
		txCopy.Vin[inID].PubKey = nil

		r := big.Int{}
		s := big.Int{}
		sigLen := len(vin.Signature)
		r.SetBytes(vin.Signature[:(sigLen / 2)])
		s.SetBytes(vin.Signature[(sigLen / 2):])

		x := big.Int{}
		y := big.Int{}
		keyLen := len(vin.PubKey)
		x.SetBytes(vin.PubKey[:(keyLen / 2)])
		y.SetBytes(vin.PubKey[(keyLen / 2):])

		rawPubKey := ecdsa.PublicKey{curve, &x, &y}
		if ecdsa.Verify(&rawPubKey, txCopy.ID, &r, &s) == false {
			return false
		}
	}

	return true
}
```

这个方法非常简单明了。首先，我们需要同样的交易记录拷贝：

```go
txCopy := tx.TrimmedCopy()
```

接下来，我们需要与产生密钥对相同的曲线：

```go
curve := elliptic.P256()
```

接下来，我们检查每一个输入当中的签名：

```go
for inID, vin := range tx.Vin {
	prevTx := prevTXs[hex.EncodeToString(vin.Txid)]
	txCopy.Vin[inID].Signature = nil
	txCopy.Vin[inID].PubKey = prevTx.Vout[vin.Vout].PubKeyHash
	txCopy.ID = txCopy.Hash()
	txCopy.Vin[inID].PubKey = nil
```

这段是与`Sign` 方法中完全相同的，因为在验证阶段我们需要与签名时完全一样的数据。

```go
	r := big.Int{}
	s := big.Int{}
	sigLen := len(vin.Signature)
	r.SetBytes(vin.Signature[:(sigLen / 2)])
	s.SetBytes(vin.Signature[(sigLen / 2):])

	x := big.Int{}
	y := big.Int{}
	keyLen := len(vin.PubKey)
	x.SetBytes(vin.PubKey[:(keyLen / 2)])
	y.SetBytes(vin.PubKey[(keyLen / 2):])
```

这里解压存储在`TXInput.Signature` 和`TXInput.PubKey` 中的数据，因为一个签名是一对数字，而一个公钥是一对坐标。早先的时候为了保存，我们将他们组合在一起，现在我们需要将它们解压出来在加密当中使用。

```go
	rawPubKey := ecdsa.PublicKey{curve, &x, &y}
	if ecdsa.Verify(&rawPubKey, txCopy.ID, &r, &s) == false {
		return false
	}
}

return true
```

现在我们用从输入获取的公钥创建一个 `ecdsa.PublicKey`，然后将从输入获取的签名传递给`ecdsa.Verify `并执行验证。加入所有的输入都能够得到验证，返回`true`；即便只有一个输入验证失败，返回` false`。

现在，我们需要一个函数来获得之前的交易记录。因为这需要与区块链交互，我们将它定义成一个 `Blockchain `的方法：

```go
func (bc *Blockchain) FindTransaction(ID []byte) (Transaction, error) {
	bci := bc.Iterator()

	for {
		block := bci.Next()

		for _, tx := range block.Transactions {
			if bytes.Compare(tx.ID, ID) == 0 {
				return *tx, nil
			}
		}

		if len(block.PrevBlockHash) == 0 {
			break
		}
	}

	return Transaction{}, errors.New("Transaction is not found")
}

func (bc *Blockchain) SignTransaction(tx *Transaction, privKey ecdsa.PrivateKey) {
	prevTXs := make(map[string]Transaction)

	for _, vin := range tx.Vin {
		prevTX, err := bc.FindTransaction(vin.Txid)
		prevTXs[hex.EncodeToString(prevTX.ID)] = prevTX
	}

	tx.Sign(privKey, prevTXs)
}

func (bc *Blockchain) VerifyTransaction(tx *Transaction) bool {
	prevTXs := make(map[string]Transaction)

	for _, vin := range tx.Vin {
		prevTX, err := bc.FindTransaction(vin.Txid)
		prevTXs[hex.EncodeToString(prevTX.ID)] = prevTX
	}

	return tx.Verify(prevTXs)
}
```

这些函数非常简单：`FindTransaction` 函数通过ID（这个需要遍历区块链中的所有区块）来找交易记录；`SignTransaction` 函数获得一个交易记录，找到它所引用的交易记录然后对它进行签名；`VerifyTransaction `函数同样，只是对交易记录进行验证。

现在，我们需要实际签名和验证交易记录。签名在 `NewUTXOTransaction` 函数当中：

```go
func NewUTXOTransaction(from, to string, amount int, bc *Blockchain) *Transaction {
	...

	tx := Transaction{nil, inputs, outputs}
	tx.ID = tx.Hash()
	bc.SignTransaction(&tx, wallet.PrivateKey)

	return &tx
}
```

验证发生在将一个交易记录放入一个区块之前：

```go
func (bc *Blockchain) MineBlock(transactions []*Transaction) {
	var lastHash []byte

	for _, tx := range transactions {
		if bc.VerifyTransaction(tx) != true {
			log.Panic("ERROR: Invalid transaction")
		}
	}
	...
}
```

然后就这样！让我们再一次确认所有的步骤和流程：

```go
$ blockchain_go createwallet
Your new address: 1AmVdDvvQ977oVCpUqz7zAPUEiXKrX5avR

$ blockchain_go createwallet
Your new address: 1NE86r4Esjf53EL7fR86CsfTZpNN42Sfab

$ blockchain_go createblockchain -address 1AmVdDvvQ977oVCpUqz7zAPUEiXKrX5avR
000000122348da06c19e5c513710340f4c307d884385da948a205655c6a9d008

Done!

$ blockchain_go send -from 1AmVdDvvQ977oVCpUqz7zAPUEiXKrX5avR -to 1NE86r4Esjf53EL7fR86CsfTZpNN42Sfab -amount 6
0000000f3dbb0ab6d56c4e4b9f7479afe8d5a5dad4d2a8823345a1a16cf3347b

Success!

$ blockchain_go getbalance -address 1AmVdDvvQ977oVCpUqz7zAPUEiXKrX5avR
Balance of '1AmVdDvvQ977oVCpUqz7zAPUEiXKrX5avR': 4

$ blockchain_go getbalance -address 1NE86r4Esjf53EL7fR86CsfTZpNN42Sfab
Balance of '1NE86r4Esjf53EL7fR86CsfTZpNN42Sfab': 6
```

非常棒！一切正常！

让我们将 `NewUTXOTransaction `函数中的`bc.SignTransaction(&tx, wallet.PrivateKey) `注释掉来确保不能对未签名的交易记录进行挖矿：

```go
func NewUTXOTransaction(from, to string, amount int, bc *Blockchain) *Transaction {
   ...
	tx := Transaction{nil, inputs, outputs}
	tx.ID = tx.Hash()
	// bc.SignTransaction(&tx, wallet.PrivateKey)

	return &tx
}

$ go install
$ blockchain_go send -from 1AmVdDvvQ977oVCpUqz7zAPUEiXKrX5avR -to 1NE86r4Esjf53EL7fR86CsfTZpNN42Sfab -amount 1
2017/09/12 16:28:15 ERROR: Invalid transaction
```

# 结论（Conclusion）

我们能够走得这么远实现这么多比特币的关键特性非常了不起。除了网络部分，我们几乎实现了所有，在下一部分，我们将完成交易记录部分。

# 链接（Links:）

- [Full source codes](https://github.com/Jeiwan/blockchain_go/tree/part_5)
- [Public-key cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography)
- [Digital signatures](https://en.wikipedia.org/wiki/Digital_signature)
- [Elliptic curve](https://en.wikipedia.org/wiki/Elliptic_curve)
- [Elliptic curve cryptography](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography)
- [ECDSA](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm)
- [Technical background of Bitcoin addresses](https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses)
- [Address](https://en.bitcoin.it/wiki/Address)
- [Base58](https://en.bitcoin.it/wiki/Base58Check_encoding)
- [A gentle introduction to elliptic curve cryptography](https://andrea.corbellini.name/2015/05/17/elliptic-curve-cryptography-a-gentle-introduction/)