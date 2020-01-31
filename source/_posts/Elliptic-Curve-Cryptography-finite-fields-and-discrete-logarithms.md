---
title: 椭圆曲线密码学简介（二）：有限域的椭圆曲线及离散对数问题
date: 2020-01-15 10:57:07
categories:
- [密码学]
tags:
- [加密货币]
- [加密算法]
- [椭圆曲线]
- [公钥加密]
- [区块链]
- [非对称加密]
description: 本文对在加密货币当中大量使用的椭圆曲线密码学进行介绍，本文在上一篇文章的基础上，进一步对有限域的椭圆曲线以及离散对数问题进行介绍。
---

本文主要翻译自[这篇文章](https://andrea.corbellini.name/2015/05/23/elliptic-curve-cryptography-finite-fields-and-discrete-logarithms/)

# 译者注

> 本文承接上文所讨论的椭圆曲线，并将曲线的定义域从实数域缩小到了有限域，引出离散对数问题

> 首先介绍了有限域的定义，并给出了一种基于模运算的有限域$\mathbb{F}_p$

> 然后对离散域上的椭圆曲线重新进行群的构建

> 接着介绍了群的阶数的概念，介绍了计算椭圆曲线上的群的阶数的算法，并讨论群和子群的阶数的联系

> 随后展示了如何用椭圆曲线上的任意一点，通过计算点的倍数的方法，构造一个循环子群

> 最后介绍了一种算法，可以在椭圆曲线上找到一个基点，并通过该基点生成一个阶数为大质数的循环子群


在[上一篇文章](http://datacruiser.io/2020/01/07/%E6%A4%AD%E5%9C%86%E6%9B%B2%E7%BA%BF%E5%AF%86%E7%A0%81%E5%AD%A6%E7%AE%80%E4%BB%8B/)当中，我们已经了解了在实数域的椭圆曲线可以用来定一个群。特别的，根据群的定义，我们在实数域上面的椭圆曲线定义了一个点加法的二元操作：对于曲线上面对齐的三个点，三点累加之和为0。并对加法运算的几何方法和代数方法进行了推导。

然后在加法的基础上面介绍了标量乘法，并找到了一种计算标量乘法的简单算法：翻倍和累加，可以使得算法时间复杂度到$O(\log n)$。

接下来，我们将椭圆曲线限定在有限域内，然后看看会有什么变化。

# 模$P$的整数域（The field of integers modulo p）

有限域，顾名思义，就是一个包含有限个元素的集合。一个有限域的具体例子就是模$p$的整数域，其中$p$是一个素数。通常它可表示为$\mathbb{Z}/p,GF(p),\mathbb{F}_p$等，为了简洁，本文采用最后一种符号$\mathbb{F}_p$。

在有限域中，我们有两种二元操作：加法$(+)$和乘法$(\times)$。两者都满足封闭性、结合律和交换律。对这两个操作，存在独一无二的单位元，且对每一个元素都有一个唯一的逆元。

最后，乘法相对加法满足分配率：$x\times (y+z)=x\times y+x\times z$

模$p$的整数域是包含所有从0到$p-1$的整数，即集合$\mathbb{F}_p$是定义在整数集$\{0,1,2,...,p-1\}$上。在$\mathbb{F}_p$上面的加法和乘法以[模运算（modular arithmetic）](http://en.wikipedia.org/wiki/Modular_arithmetic)的方式进行工作。下面是一些在$\mathbb{F}_{23}$上面的操作实例：

- 加法：$(18+9) \mod 23=4$
- 减法：$(7-14) \mod 23 =16$
- 乘法：$4\times 7 \mod 23=5$
- 加法逆元：$-5 \mod 23=18$
实际上：作为加法群时，其单位元为0，根据$(5+(-5)) \mod 23 = (5+18)\mod 23=0$，有$-5 \mod 23=18$
- 乘法逆元：$9^{-1}\mod 23=18$
实际上：作为乘法群时，其单位元为1，根据$9\times 9^{-1} \mod 23 = 9\times 18\mod = 1$，有$9^{-1}\mod 23=18$

如果对这些等式看起来有点模式，可以进一步阅读关于模运算的资料，比如wiki百科，或者[Khan Academy](https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/what-is-modular-arithmetic)。

正如我们之前所说，整数对$p$取模后所组成的有限域将具备以上所有性质。不过需要注意的是，$p$必须是一个质数！否则将无法成为一个域。比如模4整数集就不是一个域：因为2没有乘法逆元，即方程$2\times x \mod 4 = 1$无解。

# 模$p$除法（Division modulo p）

在完成对$\mathbb{F}_p$域上面对椭圆曲线进行定义之前，我们先来搞搞清楚$\mathbb{F}_p$域上面$x/y$意味着什么。本质上，我们可以认为：$x/y=x\times y^{-1}$，用语言来表示就是$x$ 除以$y$等价于$x$乘以$y$的乘法逆元。这个结果并不意外，且给出了求解除法的基本方法：找到元素的乘法逆元然后再做一个乘法。

利用[扩展欧几里德算法（Extended Euclidean algorithm）](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm)可以“方便”地计算乘法逆元，即便在最坏的情况下，算法的时间复杂度也仅为$O(\log p)$，如果考虑$p$的二进制比特长度为$k$的话，则为$O(k)$。

扩展欧几里德算法的具体细节不在本文的议题范围之内，不过下面是一个python脚本的具体实现：
```python
def extended_euclidean_algorithm(a, b):
    """
    Returns a three-tuple (gcd, x, y) such that
    a * x + b * y == gcd, where gcd is the greatest
    common divisor of a and b.

    This function implements the extended Euclidean
    algorithm and runs in O(log b) in the worst case.
    """
    s, old_s = 0, 1
    t, old_t = 1, 0
    r, old_r = b, a

    while r != 0:
        quotient = old_r // r
        old_r, r = r, old_r - quotient * r
        old_s, s = s, old_s - quotient * s
        old_t, t = t, old_t - quotient * t

    return old_r, old_s, old_t


def inverse_of(n, p):
    """
    Returns the multiplicative inverse of
    n modulo p.

    This function returns an integer m such that
    (n * m) % p == 1.
    """
    gcd, x, y = extended_euclidean_algorithm(n, p)
    assert (n * x + p * y) % p == gcd

    if gcd != 1:
        # Either n is 0, or p is not a prime number.
        raise ValueError(
            '{} has no multiplicative inverse '
            'modulo {}'.format(n, p))
    else:
        return x % p
```

# $\mathbb{F}_p$域上的椭圆曲线（Elliptic curves in $\mathbb{F}_p$）

现在，我们有足够的必要条件对$\mathbb{F}_p$域上的椭圆曲线进行定义，前面实数域上的定义如下：
$$E=\{(x,y) \in \mathbb{R}^2 | y^2=x^3+ax+b,4a^3+27b^2\neq0\}\cup\{0\}$$
$\mathbb{F}_p$有限域上的定义如下：
$$E=\{(x,y) \in (\mathbb{F}_p)^2 | y^2=x^3+ax+b \pmod{p},4a^3+27b^2\not\equiv0\pmod{p}\}\cup\{0\}$$

其中0依然是位于无限远的点，$a$和 $b$是 $\mathbb{F}_p$域上的两个整数。

![曲线$y^2\equiv x^3-7x+10 \pmod{p}$在 $p=19,97,127,487$时的图形，需要注意的是对于每一个$x$，最多有两个点，且所有的点关于$y=p/2$轴对称](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECCReview/elliptic-curves-mod-p.png)


![曲线$y^2\equiv x^3 \pmod{p}$，在$(0,0)$存在奇异点，不是一条有效的椭圆曲线](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECCReview/singular-mod-p.png)


从几何的角度，图形则从连续的曲线变成$xy$平面上面的不相连的离散点的集合。好在，我们可以依然证明，即便我们对于定义域进行诸多限制，$\mathbb{F}_p$域上的椭圆曲线依然可以组成一个阿贝尔群。

# 点加法（Point addition）

显然，为了使得点加法在$\mathbb{F}_p$域上依然有效，我们需要对定义作一些小小的修改。对于实数，我们定义三个共线的点之和为0。这个定义可以保留，但是我们需要搞明白在$\mathbb{F}_p$域中三点共线意味着什么。

在实数域，显然，三点共线意味着能够找到一条直线将三个点连在一起就好。当然，在$\mathbb{F}_p$域中，直线与实数域$\mathbb{R}$中的是有所不同的。不太严谨地说，$\mathbb{F}_p$中的直线是满足方程$ax+by+c\equiv 0\pmod{p}$的点$(x,y)$的集合。

![在曲线$y^2\equiv x^3-x+3\pmod{127}$上的两个点$P=(16,20)$和 $Q=(41,120)$的点加法。注意，直线$y\equiv4x+83 \pmod{127}$是通过平面上面的一组重复的平行线来将这些点连接起来的](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECCReview/point-addition-mod-p.png)

假设我们在一个群当中，点加法将保留所有我们已知的特性：

- $Q+0=0+Q=Q$
- 对于一个非0的点$Q$，逆元$-Q$是横坐标相同但是纵坐标相反的点。或者如果你愿意，可以这样计算，$-Q=(x_Q,-y_Q \mod p)$，举个例子，在$\mathbb{F}_29$域上的曲线有一个点$Q=(2,5)$，则其逆元$-Q=(2,-5 \mod 29)=(2,24)$
- 根据逆元的定义有$P+(-P)=0$

# 代数加法（Algebraic sum）

除了在每一个表达式后面加上一个$\mod p$的操作以外其它与前一篇文章当中所描述的步骤都相同。因此，令$P=(x_P,y_p),Q=(x_Q,y_Q),R=(x_R,y_R)$，我们可以按如下方程计算$P+Q=-R$：

$$
\begin{align}
x_R&=(m^2-x_P-x_Q)\mod\, p\\
y_R&=[y_P+m(x_R-x_P)]\mod\, p\\
&=[y_Q+m(x_R-x_Q)]\mod\, p
\end{align}
$$

如果$P\neqQ$，斜率$m$的形式如下：
$$m=(y_P-y_Q){(x_P-x_Q)}^{-1}\mod\,p$$

如果$P=Q$，则有：
$$m=(3x^2_P+a)(2y_P)^{-1}\mod\,p$$

方程形式的一致并不是巧合：实际上在任何一个域，方程的形式都是相同的，有限的或者无限的，仅在$\mathbb{F}_2$和 $\mathbb{F}_3$两个特定域上不成立。关于数学上的证明有兴趣的话可以参阅[proof from Stefan Friedl](http://math.rice.edu/~friedl/papers/AAELLIPTIC.PDF)。

另外，考虑到离散化后的曲线切线已无从谈起，以及其它方面的一些问题，在离散化域中，我们不再定义几何加法。

# 椭圆曲线群的阶（The order of an elliptic curve group）

显而易见，有限域上定义的椭圆曲线只有有限个点。但是有一个重要的问题不应该忽略：对于一个特定有限域上的椭圆曲线，到底有多少个点呢？

首先，我们将群中所包含点的数目定义为**群的阶**。

通常从$x$到 $p-1$进行暴力枚举不是一个可行的方式，这个需要$O(p)$的步骤，如果$p$是一个很大的质数，这将是一个难题。

所幸，有一个更快的算法可以计算群的阶：[Schoof's algorithm](https://en.wikipedia.org/wiki/Schoof%27s_algorithm)，这个算法可以在多项式级别的算法世界复杂度内，这正是我们所需要的。

# 标量乘法与循环子群（Scalar multiplication and cyclic subgroups）

$$nP=\underbrace{P+P+...+P}_{n\,times}$$ 

这次我们依然可以使用[翻倍累加算法](https://andrea.corbellini.name/2015/05/17/elliptic-curve-cryptography-a-gentle-introduction/#double-and-add)将乘法计算的时间复杂度控制在$O(\log n)$。

在$\mathbb{F}_p$域上的椭圆曲线进行乘法有一个有趣的性质。以曲线$y^2\equivx^3+2x+3(\mod\,97)$和点$P=(3,6)$为例，[计算](https://andrea.corbellini.name/ecc/interactive/modk-mul.html)$P$的所有乘积：
![$P=(3,6)$的乘积仅有5个离散点$(0,P,2P,3P,4P)$，然后他们会循环出现，显然，可以比较容易辨认出椭圆曲线上标量乘法计算规则与模运算上加法之间的相似性](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/ECCReview/cyclic-subgroup.png)

- $0P=0$
- $1P=(3,6)$
- $2P=(80,10)$
- $3P=(80,87)$
- $4P=(3,91)$
- $5P=0$
- $6P=(3,6)$
- $7P=(80,10)$
- $8P=(80,87)$
- $9P=(3,91)$
- ...

在此，我们可以确认两件事情：第一，$P$的乘积只有五种可能答案：椭圆曲线上面的其它的点决不会出现；第二，这五个点循环出现。我们可以这样写：

- $5kP=0$
- $(5k+1)P=P$
- $(5k+2)P=2P$
- $(5k+3)P=3P$
- $(5k+4)P=4P$

对于每一个整数$k$，上述5个方程可以借助模运算符压缩成一个方程：$kP=(k\mod\,5)P$

不仅如此，我们可以立刻确认这五个点在加法操作上面也是封闭的。这意味着：不管我是加$0,P,2P,3P,4P$中的哪一个，结果都是上述五个点之一，其它的点依然不会出现在结果当中。

不仅仅对于$P=(3,6)$，对于任何点都有这样的结果。如果我们假设一个通用的点$P$：
$$nP+mP=\underbrace{P+P+...+P}_{n\,times}+\underbrace{P+P+...+P}_{n\,times}=(n+m)P$$ 

这意味着：如果我们将两个$P$的乘积相加，我们将得到一个$P$的乘积，$P$的乘积在加法操作下是封闭的。

这足以证明$P$的乘积的集合是一个由椭圆曲线所组成的群的循环子群（cyclic subgroup）。

一个“子群”是指另外一个群的子集的群。而“循环子群”则是指子群中的元素循环地出现，就好像在前面的例子当中所示。点$P$被称为*发生器（generator）*或者*基点（base point）*。

循环子群是椭圆曲线密码学以及其它加密系统的基础。

# 子群的阶（Subgroup order）

我们可以自问一下：由一个点$P$产生的子群的阶（order）是多少，或者也可以称之为$P$的阶。回答这个问题无法使用`Schoof's algorithm`，因为该算法只有在整个椭圆曲线上面是有效的，在子群当中就无效了。在解决这个问题之前，我们需要了解以下几点：

- 我们已经对群的阶进行过定义：阶是一个群的点数。目前这个定义依然有效，但是在一个循环子群当中，我们可以给一个新的等价的定义：循环子群的阶是使得$nP=0$的最小正整数$n$。我们可以看之前那个例子，我们的子群有5个点，然后我们有$5P=0$
- [Lagrange's theorem](https://en.wikipedia.org/wiki/Lagrange%27s_theorem_(group_theory))，$P$的阶与椭圆曲线本身的阶有联系，一个子群的阶是父群阶的一个因子。换句话说，如果一个椭圆曲线有$N$个点，然后它的一个子群有$n$个点，那么$n$是 $N$的一个因子

以上两个有用的信息合在一起可以帮助我们找到基于特定几点$P$的子群的阶：

- 使用`Schoof's algorithm`找到椭圆曲线而阶$N$
- 找到$N$的所有因子
- 对$N$的每一个因子$n$，都计算$nP$
- 满足$nP=0$的最小正整数$n$，就是子群的阶

举个例子，曲线$y^2=x^3-x+3$在域$\mathbb{F}_37$上的阶为$N=42$，则其子群可能的阶为$n=1,2,3,6,7,14,21,42$。如果我们选取基点$P=(2,3)$，我们可以发现$P\neq 0,2P\neq 0,...,7P=0$，因此基点$P$的阶为$n=7$。

需要特别注意的是，选取最小的因子非常重要，而不是随机选取。如果随机选取，我们还可能选择$n=14$，虽然$n=14$是满足$nP=0$的，但是它并不是子群的阶，而且其中的一个乘数。

再举一个例子，曲线$y^2=x^3-x+3$在域$\mathbb{F}_29$上的阶为$N=37$，是一个素数，其子群可能的阶仅为$n=1,37$。不难猜到，当$n=1$时，子群只包含一个在无限远的点；当$n=N=37$时，子群包含椭圆曲线上面所有的点。

# 寻找一个基点（Finding a base point）

对于我们的椭圆曲线加密算法，我们需要一个尽量高阶的子群。通常来说，我们选择一条椭圆曲线，计算它的阶（$N$），确定一个比较大的因子作为子群的阶（$n$），然后据此寻找一个合适的基点。下面来看看我们是如何先确定子群的阶再匹配合适的基点，而不是先找基点再计算子群的阶的。

首先，需要再介绍一个概念。[Lagrange's theorem](https://en.wikipedia.org/wiki/Lagrange%27s_theorem_(group_theory))表明$h=N/n$一定是一个整数。$h$被称为子群的协因子（cofactor）。

对于椭圆曲线上面的每一个点，我们有$NP=0$，根据协因子的定义，我们有$n(hP)=0$。

现在假设$n$是一个素数，那么这个方程告诉我们点$G=hP$可以产出一个阶为$n$的子群。

综上所述，通过确定子群的阶，再据此寻找合适的基点的算法如下：

- 计算椭圆曲线的阶$N$
- 选择恰当的子群的阶$n$，为了使得这个算法能够正常工作，这个整数必须是素数，并且是$N$的一个因子
- 计算协因子$h=N/n$
- 再曲线上面选择一个随机点$P$
- 计算$G=hP$
- 如果$G$是0，则返回第四步，否则，我们就找到了一个阶为$n$且协因子为$h$的子群

需要指出的是该算法当且仅当$n$是素数的时候才能够正常工作，如果$n$不是一个素数，则$G$的阶会是$n$的一个因子。

# 离散对数（Discrete logarithm）

正如我们再之前那篇文章当中对连续的椭圆曲线所做的，对于定义在离散域当中的椭圆曲线，我们接下来讨论一下下面这个问题：如果已知$P$和 $Q$，如果求得满足$Q=kP$的 $k$呢？

这个问题，就是经典的椭圆曲线*离散对数问题*，通常来说是“hard”的问题，在经典的计算机上面是无法通过多项式级别的时间复杂度来解决这个问题的，尽管目前还没有严格的数学证明。

这个问题和其它加密系统当中使用的离散对数问题类似，比如`DSA`，`D-H`和`ElGamal`。这并不是一个巧合。不同的是，在这些算法当中，我们使用幂模运算来代替标量乘法。这些离散对数问题可以表示如下：
已知$a$和 $b$，求满足$b=a^k \mod p$

两个问题都是离散的，因为它只与有限的集合相关，更加精确地说，是循环子群。而当前椭圆曲线加密更为有趣是在于它比起其它类似的加密系统难题更难，可以使用更小的字节来表示整数$k$来获得的安全级别。

# 参考资料
- [扩展欧几里德算法（Extended Euclidean algorithm）](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm)
- [模运算（modular arithmetic）](http://en.wikipedia.org/wiki/Modular_arithmetic)
- [Khan Academy](https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/what-is-modular-arithmetic)
- [Elliptic Curve Cryptography: finite fields and discrete logarithms](https://andrea.corbellini.name/2015/05/23/elliptic-curve-cryptography-finite-fields-and-discrete-logarithms/)
- [有限域和离散对数问题(ECC椭圆曲线算法2)](https://blog.csdn.net/mrpre/article/details/72850598)

