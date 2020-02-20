---
title:  椭圆曲线密码学简介（四）：破解安全性及与RSA之间的比较
date: 2020-02-18 14:56:06
categories:
- [密码学]
tags:
- [加密货币]
- [加密算法]
- [椭圆曲线]
- [公钥加密]
- [区块链]
- [非对称加密]
description: 本文对在加密货币当中大量使用的椭圆曲线密码学进行介绍，本文在上一篇文章的基础上，试着说明下离散对数问题到底有多难，并给出了两种破解方法，第二部分试着回答在RSA等其它基于幂模运算的加密系统工作得好好的时候为什么我们还需要椭圆曲线密码系统。
---

本文主要翻译自[这篇文章](https://andrea.corbellini.name/2015/06/08/elliptic-curve-cryptography-breaking-security-and-a-comparison-with-rsa/)。

这篇文章是[椭圆曲线密码学简介](https://andrea.corbellini.name/2015/05/17/elliptic-curve-cryptography-a-gentle-introduction/)这个系列的第四篇也是最后一篇。

在[上一篇文章](http://datacruiser.io/2020/02/02/Elliptic-Curve-Cryptography-ECDH-and-ECDSA/)当中，我们了解了两种算法`ECDH`和`ECDSA`，并且也知道椭圆曲线离散对数问题是如何在安全性方面发挥重要作用的。不过，你如果留心的话，对于离散对数问题的复杂度我们还没有严格意义上的数学证明，只是主观上面认为它是“hard”，但具体是到什么程度还不知道，本文的前半部分会给你一个基于当前技术求解离散对数问题有多“hard”的一个大致认识。

第二部分，我们试着回答这个问题：在RSA等其它基于幂模运算的加密系统工作得好好的时候为什么我们还需要椭圆曲线密码系统。

# 离散对数问题破解（Breaking the discrete logarithm problem）

接下来我们会看到两个当前最有效的椭圆曲线离散对数求解算法：`baby-step,giant-step`算法和`Pollard's rho`算法。

在开始之前，先让我们来回顾一下什么是离散对数问题：给定两个点$P$和 $Q$，寻找整数$x$满足$Q=xP$，其中这些点都属于基点为$G$阶为$n$的椭圆曲线子群。

## Baby-step giant-step

在进入具体的算法之前，我们快速过一下：对于任意一个正整数$x$，我们总可以将它写成这样的形式：$x=am+b$，其中$a,m,b$是任意整数。举个例子，对于10我们可以这样写10 = 2·3 + 4。

脑子里面有了这根弦以后，我们可以离散对数问题进行重写：
$$\begin{align} 
Q&=xP\\ 
Q&=(am+b)P\\
Q&=amP+bP\\
Q-amP&=bP
\end{align}
$$

`baby-step giant-step`算法是一个在中间会合的算法。比起逐个计算每一个$x$来找到满足方程要求的$x$，对于$bP$我们可以计算得更少，对于$Q-amP$也可以计算得更少，直到我们找到一个满足条件的。算法的具体工作步骤如下：

- 计算$m=\lceil \sqrt{n}\rceil$
- 对于$0,...,m$中的每一个$b$，计算$bP$并将结果保存在一张哈希表当中
- 对于$0,...,m$中的每一个$a$：
  - 计算$amP$
  - 计算$Q-amP$
  - 检查哈希表并寻找是否存在一个点$bP$满足$Q-amP=bP$
  - 如果存在这样的表，那么我们就找到了这样的一个整数$x=am+b$

正如你所看到的，我们计算$bP$时的系数$b$用很小的步长，但在第二部分当中，我们计算$amP$使用很大的步长，这两部分分别就是算法“baby”部分和“giant”部分。具体它可以如下图所示：

![The baby-step, giant-step algorithm: initially we calculate few points via small steps and store them in a hash table. Then we perform the giant steps and compare the new points with the points in the hash table. Once a match is found, calculating the discrete logarithm is a matter of rearranging terms.](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECDH%26ECDSA/baby-step-giant-step.gif)

为了理解这个算法为何有效，先暂时不考虑点$bP$被缓存起来了，我们直接来看方程$Q=amP+bP$，看以下步骤：

- 当$a=0$时，我们检查$Q$是否等于$bP$，其中$b$是 $0,...,m$之间的一个整数。这样子，我们就可以将$Q$与所有从$0P$到 $mP$之间的点进行比较
- 当$a=1$时，我们检查$Q$是否等于$mP+bP$，我们就可以将$Q$与所有从$mP$到 $2mP$之间的点进行比较
- 当$a=2$时，我们可以将$Q$与所有从$2mP$到 $3mP$之间的点进行比较
- ...
- 当$a=m-1$时，我们可以将$Q$与所有从$(m-1)mP$到 $m^2P=nP$之间的点进行比较

总结一下，我们最多在$2m$步的加法和乘法当中检查完所有从$0P$到 $nP$的点，精确的说`baby steps`是$m$步，`giant steps`最多$m$步。

如果将哈希查表的时间复杂度考虑为$O(1)$，不难发现整个算法的时间和空间复杂度均为$O(\sqrt{n})$，如果你考虑了字节的长度，则是$O(2^{k/2})$。这依然是指数级别的时间复杂度，不过比起暴力破解还是要好不少。

## Baby-step giant-step in practice

在实践当中我们可以看看$O(\sqrt{n})$到底意味着什么。我们先找一个标准曲线：`prime192v1`。这条曲线的阶为$n=$0xffffffff ffffffff ffffffff 99def836 146bc9b1 b4d22831。这个数的平方根大约为7.922816251426434·$10^{28}$

现在想象一下在一个哈希表当中存储$\sqrt{n}$个点，假设每个点需要32字节的空间，那么我们的哈希表需要大约2.5·$10^{30}$字节的内存空间。目前整个世界的存储能力比起这个需求都相差甚远，即便每一个点只需要1个字节的存储空间，我依然离将它们全部存下来相去甚远。

更加令人绝望的是`prime192v1`是阶数最低的曲线。另外一个来自NIST的标准曲线的阶数高达6.9·$10^{156}$，其时间和空间的复杂度更加不可想象。

## Playing with baby-step giant-step

原作者也写了[一段python代码](https://github.com/andreacorbellini/ecc/blob/master/logs/babygiantstep.py)实现了`baby-step giant-step`算法。显然，它只能在一些阶数比较小的曲线上面工作，不要试着去采用`secp521r1`，否则会出现内存错误。

这段代码可以产出下面这样的一个输出：
>Curve: y^2 = (x^3 + 1x - 1) mod 10177
>Curve order: 10331
>p = (0x1, 0x1)
>q = (0x1a28, 0x8fb)
>325 * p = q
>log(p, q) = 325
>Took 105 steps

# Pollard's $\rho$

`Pollard's rho`是计算离散对数问题的另外一个算法。和`baby-step giant-step`算法一样，它的时间复杂度也是$O(\sqrt{n})$，但是它的空间复杂度仅仅为$O(1)。如果`baby-step giant-step`无法解决离散对数问题是因为巨大的存储空间需求，那么`Pollard's rho`是否可以呢？让我们拭目以待。

首先，再次强调一下离散对数问题的形式：给定$P$和 $Q$，寻找$x$满足 $Q=xP$。在`Pollard's rho`算法当中，我们求解一个略微不同的问题：给定$P$和 $Q$，寻找整数$a,b,A,B$满足 $aP+bQ=AP+BQ$。

当上面这四个整数找到以后，我们可以结合方程$Q=xP$解除$x$：
$$\begin{align} 
aP+bQ&=AP+BQ\\ 
aP+bxP&=aP+BxP\\
(a+bx)P&=(A+Bx)P\\
(a-A)P&=(B-b)xP
\end{align}
$$

将$P$消除就可以得到$x$。不过在这样做之前，我们必须记住我们的子群是以阶为$n$的循环子群，因此在点乘法当中使用的系数是要进行模$n$处理的，具体的$x$求解过程如下：
$$\begin{align} 
a-A&\equiv (B-b)x(\mod n)\\ 
x&=(a-A)(B-b)^{-1}\mod n
\end{align}
$$

`Pollard's rho`算法的操作原则非常简单：我们产生一系列的伪随机点$X_1,X_2,...$，其中$X=a_iP+b_iQ$。这个序列可以通过一个伪随机函数$f$产生：
$$(a_{i+1},b_{i+1})=f(X_i)$$

伪随机函数$f$以最新的点$X_i$作为序列的输入，然后以系数$a_{i+1}$和 $b_{i+1}$作为输出。由此，我们可以计算$X_{i+1}=a_{i+1}P+b_{i+1}Q$，随后，我们可以再次以$X_{i+1}$作为输入得到新的系数，这样不断重复。

至于伪随机函数$f$内部是如何工作的并不重要，当然，确定的函数比起其它不确定的可以更快地获得结果。我们真正在乎的是$f$基于前一个点来确定下一个点，这样所有的系数$a_i$ 和$b_i$对我们而言变成已知。

用这样的函数$f$，我们迟早会在我们的序列当中看到一个循环，从表达式上面看就是得到一个点$X_j=X_i$，如下图所示：

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECDH%26ECDSA/pollard-rho.png)

我们必须看到循环的原因非常简单：点的数目是有限的，因此我们迟早会重复。一旦我们看到循环在哪里开始，我们可以用这个上面的方程来求解离散对数问题。

接下来问题变成我们如何高效的检测到这个循环呢？

## Tortoise and Hare（快慢指针法）

为了检测循环，我们有一个高效的方法：`tortoise and hare`算法，也被叫作`Floyd's cycle-finding`算法。下面的图片展示了`torise and hare`算法的操作原则，也是`Pollard's rho`算法的核心。

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECDH%26ECDSA/tortoise-hare.gif)

我们基于曲线$y^2\equiv x^3+2x+3(\mod 97)$和点$P=(3,6)$ 以及点$Q=(80,87)$.这些点属于一个阶为5的循环子群。我们以不同的速度在一个序列对中进行工作直到找到两个不同的整数对$(a,b)$和 $(A,B)$产生同一个点。在这个例子当中，我们找到整数对$(3,3)$和 $(2,0)$满足这个要求，然后我们可以计算该对数问题得到$x=(3-2)(0-3)^{-1}\mod 5=3$，而事实上我们确实有$Q=3P$。

我们让tortoise和hare从序列的左边走到序列的右边，绿色的是走得慢的tortoise，一步一步地走，红色的hare每次跳过一个点得走，本质上是快慢指针法来寻找循环开始的地方。

一段时间以后，tortoise和hare会找到相同的点，但是系数对却不相同。或者用方程来表达，tortoise找到的对是$(a,b)$，hare找到的对是$(A,B)$，且满足$aP+bQ=AP+BQ$。

非常容易看出这个算法只需要固定大小的内存空间$O(1)$。但是计算时间依然开销很大，可以从概率的角度来证明时间复杂度为$O(\sqrt{n})$。严格的证明是基于[birthday paradox](https://en.wikipedia.org/wiki/Birthday_problem)，指的是两个人生日相同的概率，这和我们所考虑的两个不同的整数对$(a,b)$得到相同的点的概率类似。

>译者注，根据文章[最后的留言讨论](http://blog.chxj.name/elliptic-curve-cryptography-breaking-security-and-a-comparison-with-rsa-zh/)，实际上, 原作者关于 Pollard's ρ 算法的部分讲解是不够准确的。根据作者的前面的说法系数(a,b)总由它前面点决定, 这也就是说, 相同点一定生成相同的系数, 而 GIF 动图中的点(3,6)第一次生成了 a=3,b=3 但第二次生成了 a=2, b=0. 这与前面的说法是矛盾的，对照作者提供的python代码，下一个点的系数并非由前一个点生成, 而是由前一个点和前一个点的系数共同决定。而下一个点又能由前一个点决定, 系数和点的不同循环周期创造了找到问题的解的可能。

## Playing with Pollard's $\rho$

原作者有一段使用`Pollard's rho`算法的[python代码](https://github.com/andreacorbellini/ecc/blob/master/logs/pollardsrho.py)，这不是原始`Pollard's rho`算法的实现，只是一个小小的变种，作者使用了更高效的产生伪随机序列的方法。代码里面包含了一些有用的注释，如果你对算法的详细细节有兴趣，最好读一读。

和`baby-step giant-step`算法一样，也仅仅在一些小的椭圆曲线上面有效工作，并产生类似的输出。

## Pollard's $\rho$ in practice

由于空间需求无法满足，`baby-step giant-step`在实践中是无法使用的。而`Pollard's rho`只需要很少的空间，那么他的实用性如何呢？

Certicon在1998年发起了一个在位数从109到359的椭圆曲线上面计算离散对数问题的[挑战](https://blackberry.certicom.com/)，最终只有109位的曲线被成功破解，且最好的成功尝试是在2004年提交的，[Wikipedia](https://en.wikipedia.org/wiki/Discrete_logarithm_records)上面的记录如下：
>The prize was awarded on 8 April 2004 to a group of about 2600 people represented by Chris Monico. They also used a version of a parallelized Pollard rho method, taking 17 months of calendar time.

正如我们之前所说，`prime192v1`是一个最小的椭圆曲线。我们也知道`Pollard's rho`的时间复杂度是$O(\sqrt{n})$。如果我们使用与`Chris Monico`相同的技术（同样的算法，同样的硬件，数量相同的机器），那么在`prime192v1`上面计算离散对数问题需要化多长时间呢？

$$17 \,\mathrm{months} \times \frac{\sqrt{2^{192} } }{\sqrt{2^{109} } } \approx 5\cdot 10^{13} \,\mathrm{months}$$

这个数字可以清楚的说明使用这样的技术来破解离散对数问题是多么的困难。

# Pollard's $\rho$ vs Baby-step giant-step

将[baby-step giant-step代码](https://github.com/andreacorbellini/ecc/blob/master/logs/babygiantstep.py)和[Pollard's rho代码](https://github.com/andreacorbellini/ecc/blob/master/logs/pollardsrho.py)和[brute-force代码](https://github.com/andreacorbellini/ecc/blob/master/logs/bruteforce.py)放到一起组成[第四段代码](https://github.com/andreacorbellini/ecc/blob/master/logs/comparelogs.py)来比较他们之间的性能。

运行第四段代码可以对比所有的算法在一个阶数较小的曲线上面求解一个离散对数问题所需要的时间对比：
>Curve order: 10331
>Using bruteforce
>Computing all logarithms: 100.00% done
>Took 1m 12s (5182 steps on average)
>Using babygiantstep
>Computing all logarithms: 100.00% done
>Took 0m 3s (152 steps on average)
>Using pollardsrho
>Computing all logarithms: 100.00% done
>Took 0m 8s (139 steps on average)

正如我们所期望的，暴力法（brute-force）比起另外两种算法要慢很多。`Baby-step giant-step`是最快的，`Pollard's rho`要比它慢一倍，虽然它所消耗的内存更少步数也更少。

再来看运算步数，暴力法平均需要5182步，这个数字非常接近曲线阶数的一半。`Baby-step giant-step`和`Pollard's rho`平均分别需要152和139步，两者都非常接近阶数的平方根：$\sqrt{10331}=101.64$。

# Final consideration

在介绍这些算法的时候，我已经给出了很多的数字。阅读的时候需要给他们足够的重视：算法可以有很多种方式来进行优化。硬件可以提升，可以构建专用硬件设备。

目前看起来不可行的方法，并不意味着后续不能提升。更不是说已经没有其它更好的方法存在。

# Shor's algorithm

如果当前的技术不合适，那以后的呢？确实，事情的发展让人有些担忧：存在一种[量子算法](https://en.wikipedia.org/wiki/Quantum_algorithm)可以在多项式的时间复杂度内解决离散对数问题：[Shor's algoritm](https://en.wikipedia.org/wiki/Shor%27s_algorithm)的时间复杂度是$O((\log n)^3)$，空间复杂度是$O(\log n)$。

量子计算机目前还没有成熟到足以运行Shor's这样的算法，但是[抗量子的加密算法](https://en.wikipedia.org/wiki/Post-quantum_cryptography)现在看来将会更加有研究价值，今天我们用于加密的东西在明天可能变得不再安全。

# ECC and RSA

现在让我们忘记量子计算，把它当作一个严重问题的日子和远着呢！接下来要回答的问题是：既然`RSA`已经可以很好的工作，为什么还要大费周章地去捣鼓椭圆曲线呢？

`NIST`给出了一个简洁的答案，提供了一个取得相同等级的安全性能时两者密钥所需字节大小的对比表格：

![](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECDH%26ECDSA/Elliptic%20Curve%20Cryptography%3A%20breaking%20security%20and%20a%20comparison%20with%20RSA%20-%20Andrea%20Corbellini%202020-02-20%2014-27-07.png)

需要注意的是，在`RSA`的密钥长度和`ECC`的密钥长度之间并没有线性关系，换言之，如果我们翻倍`RSA`的密钥长度，并不意味着必须对`ECC`的密钥长度进行翻倍。这个表格不仅告诉我们`ECC`使用更少的内存，而且密钥的产生和签名验证都更快。

那么这是什么原因呢？在计算离散对数问题时我们比较快的算法是前面介绍过的`Baby-step giant-step`算法和`Pollard's rho`算法，而在`RSA`的计算当中，我们有着更快、更高效的算法。特别是[general number field sieve](https://en.wikipedia.org/wiki/General_number_field_sieve)：一个整数因子分解算法可以用于计算离散对数，该算法是目前最快的因子分解算法。

所有这些都可以应用与其它基于幂模运算的加密系统，包括`DSA`，`D-H`和`EIGamal`等等。

# Hidden threats of NSA

接下来是较难的一部分。到目前我们一直在讨论算法和数学。下面让我们把人考虑进去，这将会让问题变得更加复杂。

首先让我们放出问题，问题是：`NIST`曲线的随机数种子是哪里来的？答案是令人失望的：我们并不知道。这些种子并没有经过大家一致讨论而被认为是正当的。

是不是有这种可能，`NIST`发现了大量的弱椭圆曲线，然后尝试了大量可能的种子找到了一个有漏洞的曲线？这个问题我无法回答，但是却非常重要且关乎法律。我们知道，`NIST`确实成功标准化了至少一个[有漏洞的随机数生成器](https://en.wikipedia.org/wiki/Dual_EC_DRBG)。或许他们也能够标准化出一系列的含有漏洞的弱椭圆曲线。对于问题的答案，我们依然无法知晓。

尤其重要的是，需要特别理解的是“可验证的随机”和“安全”并不是等价的。不论你的离散对数问题有多难，你的密钥有多长，如果算法本身被破解了，皮之不存，毛将焉附，那么我们也是束手无策的。

基于这一点的考虑，`RSA`胜出。它并不需要特别的可能可以作弊的领域参数。在我们不信任任一权威机构以及自己无法构建我们自己的领域参数的时候，`RSA`以及其它基于幂模运算的加密系统是一个好的替代选择。如果你问：是的，传输安全层（TLS）可以使用`NIST`的曲线。如果你检查一下[google](https://google.com)，你可以看到连接就是使用了`ECDHE`和`ECDSA`，基于`prime256v1`的认证证书。

# That's all!

最后，希望大家能够喜欢这一系列的文章。我的目的是能够给大家介绍基本的知识、术语和惯例来理解当前的`ECC`。如果能够达成我的目标，你现在可以理解现存基于`ECC`的加密系统并将你的知识延伸到阅读一些其它不那么友好的文档。当撰写这一系列的文章的时候，我本可以跳过一些详细细节，使用一个更简单的术语，但我觉得这样做你将无法理解。我相信我在简单和面面俱到之间做了很好的权衡。

务必注意，仅仅通过阅读本系列文章，你并不能实现安全的`ECC`加密系统，为了确保安全性，我们需要了解很多细微但重要的细节。记住[Smart's attack](https://wstein.org/edu/2010/414/projects/novotney.pdf)和[Sony's mistake](https://www.bbc.com/news/technology-12116051)──这两个例子应该可以让你知道产生不安全的算法是多么的容易，不安全的算法被人恶意利用也是多么的容易。

那么，后面如果有志于更加深入的探索`ECC`的世界，应该从哪里开始呢？

首先，我们以及了解了质素域上的`Weierstrass`椭圆曲线，但是你必须知道还有其它类型的曲线和域，特别是以下几种：

- 二元域上面的`Koblitz`曲线：它们是形如$y^2+xy=x^3+ax^2+1$（其中$a$是0或1）定义在包含$2^m$（其中$m$是质数）个元素的有限域上的椭圆曲线。它们可以实现特别高效的点加和标量乘法。标准化的 `Koblitz `曲线有` nistk163`,`nistk283`,`nistk571`（这三条曲线分别定义在 163, 283 和 571 位的域上）
- 二元曲线：这类曲线与`Koblitz`曲线类似，它们是形如$x^2+xy=x^3+x^2+b$（其中$b$是整数，通常来源于一个随机数种子）。顾名思义，二元曲线被限制在二元域上。标准化的二元曲线有` nistb163`, `nistb283` 和 `nistb571`。 必须要说明的是, 有越来越多的担忧认为 `Koblitz` 曲线和二元曲线可能并没有质数曲线那么安全
- `Edwards`曲线：它们形如$x^2+y^2=1+dx^2y^2$（其中$d$是0或1）。它们特别有趣，不仅在于点加法和标量乘法特别快，而且计算点加的公式在任何情况下（$P \ne Q, P = Q, P = -Q$）都是一样的。该特性充分考虑了旁路攻击的可能性，即当你在测量标量乘法所耗费的时间以后用这个计算所耗费的时间来猜测标量参数的一种攻击方式。`Edwards`相对较新（2007年出现），目前尚未有`Certicom`或`NIST`之类的权威机构对其进行标准化
- `Curve25519`和 `Ed25519` 是两种分别为` ECDH` 和` ECDSA` 的某种变体特别设计的椭圆曲线。 和 `Edwards` 曲线一样, 这两种曲线也很快速并且能够抵御旁路攻击。也和 `Edwards` 曲线一样, 这两种曲线也尚未被标准化所以我们不能在流行软件中看到它们的身影（除了 `OpenSSH`, 它从 2014 年起支持了 `Ed25519` 密钥对）

如果你对 `ECC` 的实现细节感兴趣, 那么我建议你阅读 `OpenSSL` 和 `GnuTLS` 的源码。

最后，如果你对数学细节感兴趣，而不是算法的安全性和有效性，你必须知道：
- 椭圆曲线是亏格（genus）为 1 的代数变体
- 无限远处的点的概念来源于影射几何（projective geometry） 并可以通过齐次坐标（homogeneous coordinates）来表现 （尽管椭圆曲线并不需要影射几何中的绝大部分特性）

更别忘记研究有限域（finite fields）和场理论（field theory）。

如果对这些主体感兴趣，可以通过上面的这些关键字去了解。

现在这个系列文章就正式结束了，感谢大家的阅读，下次再见！

# 译者后记

原作者[Andrea Corbellini](https://github.com/andreacorbellini) 是一个善于总结和表达且喜欢与人互动的工程师, 通过阅读和翻译他的文章，让我受益非浅。从最基本的曲线方程，结合代数和几何两个维度，从连续域到离散域，循序渐渐，步步深入，慢慢揭开`ECC`的神秘面纱。看了网上不少这方面的博客，不得不少，从质量和可理解性上，他的系列文章是最高的，而且到目前，我也看到不仅仅是我一个人还在翻译学习他的文章。另外，在文章的最后，他的给出了很多后续扩展阅读的方向，从数学上的，从算法上的，从工程实现上的……等等，继续学习，为了求知而求知，与各位有兴趣的读者共勉！

