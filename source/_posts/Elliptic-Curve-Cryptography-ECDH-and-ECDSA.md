---
title: 椭圆曲线密码学简介（三）：ECDH和ECDSA
date: 2020-02-02 23:14:50
categories:
- [密码学]
tags:
- [加密货币]
- [加密算法]
- [椭圆曲线]
- [公钥加密]
- [区块链]
- [非对称加密]
description: 本文对在加密货币当中大量使用的椭圆曲线密码学进行介绍，本文在上一篇文章的基础上，进一步就采用椭圆曲线密码学的加密算法`ECDH`和数字签名算法`ECDSA`进行介绍。
---

本文主要翻译自[这篇文章](https://andrea.corbellini.name/2015/05/30/elliptic-curve-cryptography-ecdh-and-ecdsa/)，并参考笔者之前翻译的另外一篇文章[ECDSA算法如何保护我们的数据](http://datacruiser.io/2019/12/12/%E7%90%86%E8%A7%A3ECDSA%E7%AE%97%E6%B3%95%E5%A6%82%E4%BD%95%E4%BF%9D%E6%8A%A4%E6%88%91%E4%BB%AC%E7%9A%84%E6%95%B0%E6%8D%AE/)。


# 译者注

> 本文承接上文所引出的离散对数问题，在加密和数字签名两个场景就离散对数问题的具体应用方式展开具体的讨论。首先介绍了用于定义一个特定椭圆曲线离散域的子群的领域参数，然后基于这组领域参数分别在加密领域介绍`ECDH`算法，在数字签名领域介绍`ECDSA`算法。

# 领域参数（Domain parameters）

我们的椭圆曲线算法是在一个定义在一个椭圆曲线离散有限域的循环子群上面的，因此，我们的算法需要以下参数：

- 标识有限域规模的素数$p$
- 椭圆曲线方程的系数$a$和 $b$
- 产生子群的基准点$G$
- 子群的阶$n$
- 子群的协因子$h$

一言以蔽之，我们算法的领域参数就是一个包含六个元素的元组$(p,a,b,G,n,h)$


## 随机曲线（Random curves）

当我们在说离散对数问题是“hard”的时候，其实也并不完全对。有些特定的椭圆曲线所对应的离散对数问题可以用特殊目的的算法进行高效地破解。举个例子，所有满足$p=hn$的曲线（有限域的阶与椭圆曲线的阶相同）在[Smart's attack](https://wstein.org/edu/2010/414/projects/novotney.pdf)面前是脆弱的，该算法可以用经典计算机在多项式时间复杂度内解决离散对数问题。

现在，假设我给你一条椭圆曲线的领域参数。那么存在这样一个可能性，我已经发现了一些你并不知道的难度较低的椭圆曲线，并且还可能构思了一些破解我所给定的曲线的算法。我要如何向你证明我并不知道这条曲线的任何弱点呢？换句话说，我如何向你确保我所给你的这条曲线是安全的呢？

为了解决这类问题，有时候我们需要一个额外的领域参数：种子参数。这是一个用于产生方程系数和/或基准点的随机数。这些参数通过计算种子的哈希获得。众所周知，哈希的计算是“easy”的，但是求逆是“hard”的。

![从一个种子产出一个随机曲线示意图：随机数被用于计算曲线的不同参数](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECDH%26ECDSA/random-parameters-generation.png)

![如果我们想从领域参数反方向构建一个种子，需要解决哈希求逆的难题](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECDH%26ECDSA/seed-inversion.png)

通过种子产生的曲线可以被认为是随机的。这种通过哈希来产生参数的原则被称为[nothing up my sleeve](https://en.wikipedia.org/wiki/Nothing-up-my-sleeve_number)，通过哈希计算产生的数可以在根本上排除其具有掩藏特性的嫌疑，在密码学当中被大量的使用。

从某种程度上说，这个技巧可以确保给定的曲线没有被特殊的认为加工以向其作者暴露其脆弱性。事实上，如果我同时给你一条曲线和一个种子，这意味着我并不能随意选择参数，你也能够相对比较明确其实我并不能对该曲线进行特殊目的的攻击。

用于产生和验证随机曲线的标准算法在`ANSI X9.62`当中有进行描述，主要基于[SHA-1](https://en.wikipedia.org/wiki/SHA-1)，如果你对此比较好奇，你可以阅读这篇文档：[a specification by SECG](http://www.secg.org/sec1-v2.pdf)，了解产生可验证的随机曲线的算法。

原作者写了一段简单的[Python 脚本](https://github.com/andreacorbellini/ecc/blob/master/scripts/verifyrandom.py)来验证当前所有基于[OpenSSL](https://github.com/openssl/openssl/blob/81fc390/crypto/ec/ec_curve.c)的随机曲线，强烈推荐看一下。

# 椭圆曲线密码学（Elliptic Curve Cryptography）

前面经过了很多的铺垫，不过最终我们来到了这里，可以讲下椭圆曲线密码学到底是什么了，简洁的版本如下：

- 私钥（private key）是从$\{1,...,n-1\}$随机选取的一个正整数$d$，其中$n$是子群的阶
- 公钥（public key）则是点$H=dG$，其中$G$是子群的基准点

你看，如果我们知道$d$和 $G$，结合其它的领域参数，求解$H$是“easy”的。但是，如果我们知道$H$和 $G$，求解私钥$d$是“hard”的，因为这需要我们解决离散对数问题。

接下来我们介绍两个基于椭圆曲线密码学的公钥算法：

- ECDH（Elliptic Curve Diffie-Hellman）：主要用于加密
- ECDSA（Elliptic Curve Digital Signature Algorithm）：主要用于数字签名

## ECDH加密算法（Encryption with ECDH）

`ECDH`是[Diffie-Hellman algorithm](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)基于椭圆曲线的变种，更像是一个[key-agreement protocol](https://en.wikipedia.org/wiki/Key-agreement_protocol)，而不是一个加密算法。因为，`ECDH`仅仅定义了各种密钥如何产生以及在各方之间如何交换，具体如何用这些密钥来对数据进行加密由用户自己决定。

这个问题是如下解决的：双方（还是喜闻乐见的[Alice and Bob](https://en.wikipedia.org/wiki/Alice_and_Bob)）想安全的交换信息，[第三方](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)可能截取信息，但可能无法进行解码。这是传输层安全（TLS）设计的原则之一，下面来一起看一个例子。

具体工作原理如下：

- 第一步，Alice和Bob产生各自的私钥和公钥，Alice的私钥和公钥分别为$d_A$和 $H_A=d_A G$，Bob的私钥和公钥分别为$d_B$和 $H_B=d_B G$。需要注意的是，Alice和Bob使用相同的领域参数：在相同的有限域内定义的相同的椭圆曲线上的相同的基准点$G$

- Alice和Bob通过不安全的渠道交换他们的公钥$H_A$和 $H_B$，第三方可能截取$H_A$和 $H_B$， 但是无法仅仅通过公钥避开离散对数难题而推导出私钥$d_A$和 $d_B$

- Alice用自己的私钥和Bob的公钥计算$S=d_A H_B$，然后Bob也用自己的私钥和Alice的公钥计算$S=d_B H_A$，事实上，对于Alice和Bob，这个$S$是相同的：
$$S=d_A H_B=d_A(d_B G)=d_B(d_AG)=d_B H_A$$

截取信息的中间人，只知道$H_A$和 $H_B$以及其它的领域参数，但是依然无法获得在Alice和Bob之间共享的秘密信息$S$。这个问题就是众所周知的`Diffie-Hellman problem`，可以具体表述如下：

> 给出三个点$P$，$aP$ 和$bP$，求$abP$

或者等价于：

> 给出三个整数$k$，$k^x$ 和$k^y$，求$k^{xy}$

后面这个等价基于幂模运算，在原始的`Diffie-Hellman`算法当中使用。

![Alice和Bob可以非常方便的计算出共享的机密信息，对于截取信息的第三方来说却非常难](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECDH%26ECDSA/ecdh.png)

`Diffie-Hellman problem`背后的基本原理在[Youtube video by Khan Academy](https://www.youtube.com/watch?v=YEBfamv-_do#t=02m37s)当中也有解释，一会儿也会对采用幂模运算的原始`Diffie-Hellman`算法进行介绍。

采用椭圆曲线的`Diffie-Hellman problem`被认为是“hard”的，可以等同于离散对数问题的难度级别，不过并没有数学上面的严格证明。我们能够确认的是并没有比离散对数更难，因为解决离散对数问题是解决`Diffie-Hellman problem`的一种方式。

现在，Alice和Bob已经获得了共享的机密信息，这样他们就可以用对称加密的方式进行数据交换。

举个例子，Alice和Bob可以使用$S$的 $x$坐标作为安全加密算法[AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)或者[3DES](https://en.wikipedia.org/wiki/Triple_DES)对信息进行加密的密钥。

这个和TLS的做法类似，区别在于，TLS将坐标于其它相关的数字连接起来，然后计算连接结果字符串的哈希。

## ECDH应用举例（Playing with ECDH）

[这段代码](https://github.com/andreacorbellini/ecc/blob/master/scripts/ecdhe.py)可以用来计算基于特定椭圆曲线的公钥和私钥以及共享加密信息。

不同于我们之前所使用的例子，这段代码使用了一个标准的曲线，而不是一个在一个很小域上面的简单曲线。这个曲线是`secp256k1`，也是比特币里面用于数字签名的曲线。具体的领域参数如下：

- $p$ = 0xffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe fffffc2f
- $a$ = 0
- $b$ = 7
- $x_G$ = 0x79be667e f9dcbbac 55a06295 ce870b07 029bfcdb 2dce28d9 59f2815b 16f81798
- $y_G$ = 0x483ada77 26a3c465 5da4fbfc 0e1108a8 fd17b448 a6855419 9c47d08f fb10d4b8
- $n$ = 0xffffffff ffffffff ffffffff fffffffe baaedce6 af48a03b bfd25e8c d0364141
- $h$ = 1

这些参数来自[OpenSSL 源码](https://github.com/openssl/openssl/blob/81fc390/crypto/ec/ec_curve.c#L766)

这段代码非常简单，包含了一些我之前描述过的算法：点加法、翻倍与累加、ECDH等等。建议阅读并跑一下，代码的输出如下：

```python
Curve: secp256k1
Alice's private key: 0xc72e432030e533d59619f1ccb345015d874c5397e3fce829847b010e7f75e1a9
Alice's public key: (0x757abaa45b6938d6db9b91ca66f9ff7bac0e05ed78aa89a22a2a6a9d3bce0da4, 0x8815d45af0415f6d8d9506b15e989506968f159bf76b99a10f5200955ecba331)
Bob's private key: 0xce6f22b6d8dd621d23d0f1a6219e36619df2531d4985e47eb0c154375229e896
Bob's public key: (0x524a4c7666ec851b60a0540e24b66da2029d3baf8cb792d4e1a8f413a8a365a2, 0x39ded69ea9a5aac69fb53b736c310c267e16c3c0863576bd5aa4ebefb9b8b5db)
Shared secret: (0x68054720a6a2c983e95365c1addac5f5f5f5bd8239dce8757630247bb3368812, 0x7185800dc5f2010bb3f71f0c180d6b14f85a55302679f558d103277eaf55cd93)
```

## Ephemeral ECDH

可能有些人除了`ECDH`，还听说过`ECDHE`。在`ECDHE`当中的“E”代表“Ephemeral”，指的是密钥的交换是暂时的。

举个`ECDHE`的应用例子，在TLS当中，服务器和用户端在每次建立起连接的时候都产生密钥对，然后用TLS证书对密钥进行签名后在双方进行交换。

# ECDSA数字签名算法（Signing with ECDSA）

关于数字签名算法──`ECDSA`，在[这篇文章](http://datacruiser.io/2019/12/12/%E7%90%86%E8%A7%A3ECDSA%E7%AE%97%E6%B3%95%E5%A6%82%E4%BD%95%E4%BF%9D%E6%8A%A4%E6%88%91%E4%BB%AC%E7%9A%84%E6%95%B0%E6%8D%AE/)已经有了较为详细的描述，不过为了行文的完整性，这里还是再复述一遍。

我们考虑这样的一个场景：Alice想用他的私钥$d_A$对一个信息进行签名，然后Bob想用Alice的公钥$H_A$来验证这个签名。没有其它人，只有Alice才能够产生这样有效的签名。因为Alice的公钥可以公开，因此，每个人可以检查这个签名。

再一次，Alice和Bob使用相同的领域参数。接下来要看的算法是`ECDSA`，应用与椭圆曲线的[数字签名算法](https://en.wikipedia.org/wiki/Digital_Signature_Algorithm)的变种。

`ECDSA`工作在加密信息的哈希上面，而不是信息本身。哈希函数的选择由用户自己确定，显然，为了确保安全性，还是需要采用[密码级安全的哈希函数](https://en.wikipedia.org/wiki/Cryptographic_hash_function)。加密信息的哈希需要进行截取以确保哈希的字节长度与子群的阶$n$相等，被截取的哈希是一个正整数，通常用$z$来表示。

Alice采用的信息签名算法工作流程如下：

- 从$\{1,...,n-1\}$中随机选择一个整数$k$
- 计算点$P=kG$，其中$G$是领域参数当中的基点
- 计算数字$r=x_P \mod n$，其中$x_P$是点$P$的 $x$坐标 
- 如果$r=0$，选择另外一个$k$
- 计算$s=k^{-1}(z+r d_A) \mod n$，其中$d_A$是Alice的私钥，$k^{-1}$是 $k$模 $n$的乘法逆元
- 如果$s=0$，则选择另外一个$k$继续

最后$(r,s)$是数字签名对。

![Alice用他的私钥$d_A$和随机数$k$对哈希$z$进行签名，Bob用Alice的公钥$H_A$来验证信息是否正确签名](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECDH%26ECDSA/ecdsa.png)

用朴实的语言来描述，该算法首先产生机密信息$k$，然后将这个机密信息用椭圆曲线上面的点乘法（根据之前的知识，这个算法也是单向容易，反向难）隐藏在$r$当中。然后将$r$通过方程$s=s=k^{-1}(z+r d_A) \mod n$捆绑在加密消息哈希当中。

需要注意的是为了计算$s$，我们需要计算$k$ 模$n$的逆元，我们已经在前面讲到只有在$n$是素数的时候这个算法才能够有效。如果子群有非素数的阶，那么`ECDSA`是不能使用的。几乎所有标准曲线都用一个素数阶，而那些具有非素数阶的曲线并不适合于`ECDSA`。

## 数字签名验证（Verifying signatures）

为了对数字签名进行验证，我需要Alice的公钥$H_A$，截取后的哈希$z$，当然，也需要签名对$(r,s)$，主要分以下三步：

- 计算$u_1=s^{-1}z \mod n$
- 计算$u_2=s^{-1}r \mod n$
- 计算点$P=u_1G+u_2 H_A$

如果$r=x_P \mod n$则签名是有效的

## 算法的正确性（Correctness of the algorithm）

初看起来，隐藏在算法背后的逻辑并不是那么清晰，不过，当我们将目前所有列出的方程都放到一起就清楚明了了。

让我们从$P=u_1G + u_2 H_A$开始，我们知道，从公钥的定义可知，$H_A=d_A G$，其中$d_A$是私钥，我们可以将式子改写如下：
$$P=u_1G + u_2 H_A=u_1 G + u_2 d_A G=(u_1+u_2 d_A)G$$

再次利用$u_1$和 $u_2$的定义，我们可以将式子改写如下：
$$P=(u_1+u_2 d_A)G=(s^{-1}z+s^{-1}rd_A)G=s^{-1}(z+rd_A)G$$

这里为了简化，我们将后续的$\mod n$省略，另外，因为由$G$产生的循环子群的阶为$n$，因此，$\mod n$是多余的。

在前面，我们定义$s=s=k^{-1}(z+r d_A) \mod n$，方程两边都乘以$k$在除以$s$，我们得到$k=s^{-1}(z+r d_A)\mod n$，将这个方程代入前面计算$P$的方程，我们有：
$$P=s^{-1}(z+rd_A)G=kG$$

这个方程与前面算法第二步当中产生签名算法计算$P$的方程是相同的，那意味着产生签名和验证签名的时候，我们计算同一个点$P$，只是采用了不同的方程，这也是算法有效的原因。

## ECDSA应用举例（Playing with ECDSA）

当然，原作者同样写了[一段python代码](https://github.com/andreacorbellini/ecc/blob/master/scripts/ecdsa.py)用来签名的产生和验证。这段代码与`ECDH`的代码有部分相同，特别是领域参数和公/私钥对产生算法。

下面是这段代码可能的一个输出内容：
```python
urve: secp256k1
Private key: 0xdef65e81fb94235e4e52d89c2cd29718bb42c8b944700c26c4cac2f16e5f0d73
Public key: (0x42186bb04e3070de0370eff1aa4b88d6e20db8013a2daf16146119bafb211290, 0x62d3d86ee0469feab6b3fff7a295084392ef506d6836a920583520aa7e40d20b)

Message: b'Hello!'
Signature: (0x77c9fcd26adec8871bd9983c7e3aaed841e15095c2c25b4a0c46f3c4448ae7a5, 0xeb058fb78abdad4e316b44c09f1af610c389c8ae29b6f4ad19489e1c903a6807)
Verification: signature matches

Message: b'Hi there!'
Verification: invalid signature

Message: b'Hello!'
Public key: (0x7526ae6817faace403ac5dfddd6adbb3ca42a04ad58fc418d43eca4ea1c08cbd, 0x11c8b82217d09e046529ad0692859be73c3cbeca36254fa9084dccf2c8b35cc3)
Verification: invalid signature
```

你可以看到，这段代码首先对一段信息进行签名（字节信息“Hello!”），然后对签名进行验证。然后，试图用同样的签名对另外一段信息（“Hi there”）进行验证且失败了。最后，试图采用另外一个随机的公钥对同样的信息进行验证也失败了。

## $k$的重要性（The importance of $k$）

当我们产生`ECDSA`签名的时候，保持随机数$k$的机密性和随机性非常重要。如果我们在多个签名使用了同一个$k$，或者我们的随机数生成器某种程度上是可预测的，则很容易受到攻击而泄漏我们的私钥！

下面举一个多年前[sony公司犯过的一个错误](https://www.bbc.com/news/technology-12116051)。通常，PS3平台只能运行Sony用`ECDSA`签名过的游戏。这样，如果我想为我的PS3平台创建一个新游戏，在没有Sony的签名的情况下，我无法进行私自发布。但是，问题在于所有Sony产生的签名使用了同一个随机数$k$。

在这种情况下，我们只要购买两个签名过的游戏，抽取出它们的哈希$z_1$和 $z_2$以及签名对（$(r_1,s_1),(r_2,s_2)$），和领域参数一起就可以破解出Sony的私钥$d_S$。下面是具体步骤：

- 首先，$r_1=r_2$，因为$r=x_P \mod n$且 $P=kG$对于两个签名是一样的
- 从$s$的定义可以推导出$(s_1-s_2)\mod n = k^{-1}(z_1-z_2)\mod n$
- 上式两旁都乘以$k$，有：$k(s_1-s_2)\mod n=(z_1-z_2)\mod n$
- 再两边除以$(s_1-s_2)$得到：$k=(z_1-z_2)(s_1-s_2)^{-1}\mod n$

最后的式子可以让我们只用两个哈希和对应的签名来计算$k$，得到$k$以后我们可以使用$s$的定义方程计算私钥：
$$s=k^{-1}(z+rd_S)\mod n \rightarrow d_S=r^{-1}(sk-z)\mod n$$

即便$k$不是静态的，如果是可预测的，同样的技术也可以用于对私钥的破解。

# 预告

下一篇，也是这个系列的最后一篇，主要关注离散对数问题的求解、若干椭圆曲线密码学的重要问题以及RSA与ECC的比较等等，希望大家不用错过。

# 参考资料

- [Elliptic Curve Cryptography: ECDH and ECDSA](https://andrea.corbellini.name/2015/05/30/elliptic-curve-cryptography-ecdh-and-ecdsa/)
- [Diffie-Hellman algorithm](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)
- [数字签名算法](https://en.wikipedia.org/wiki/Digital_Signature_Algorithm)
- [密码级安全的哈希函数](https://en.wikipedia.org/wiki/Cryptographic_hash_function)
- [sony公司犯过的一个错误](https://www.bbc.com/news/technology-12116051)

