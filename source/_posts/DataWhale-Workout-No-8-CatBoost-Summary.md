---
title: DataWhale Workout No.8 CatBoost Summary
date: 2019-08-19 08:18:37
categories: 机器学习
tags:
- 集成学习
- CatBoost
- Ordered boosting
- Prediction shift
- sklearn
description: 这是DataWhale暑期学习小组-高级算法梳理的补充，是对目前最新的开源Boost族算法CatBoost的介绍，结合相关论文以及笔者的使用经验，对CatBoost的算法特性和适用场景做一些小结。
---

# CatBoost

CatBoost是俄罗斯的搜索巨头Yandex在2017年开源的机器学习库，也是Boosting族算法的一种，同前面介绍过的XGBoost和LightGBM类似，依然是在GBDT算法框架下的一种改进实现，是一种基于对称决策树（oblivious trees）算法的参数少、支持类别型变量和高准确性的GBDT框架，主要说解决的痛点是高效合理地处理类别型特征，这个从它的名字就可以看得出来，Catboost是由catgorical和boost组成，另外是处理梯度偏差（Gradient bias）以及预测偏移（Prediction shift）问题，提高算法的准确性和泛化能力。

![集成学习](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/Catboost/%E9%9B%86%E6%88%90%E5%AD%A6%E4%B9%A0.png)

Catboost主要有以下五个特性：

- 无需调参即可获得较高的模型质量，采用默认参数就可以获得非常好的结果，减少在调参上面花的时间
- 支持类别型变量，无需对非数值型特征进行预处理
- 快速、可扩展的GPU版本，可以用基于GPU的梯度提升算法实现来训练你的模型，支持多卡并行
- 提高准确性，提出一种全新的梯度提升机制来构建模型以减少过拟合
- 快速预测，即便应对延时非常苛刻的任务也能够快速高效部署模型

Catboost的主要算法原理可以参照以下两篇论文：

- [Anna Veronika Dorogush, Andrey Gulin, Gleb Gusev, Nikita Kazeev, Liudmila Ostroumova Prokhorenkova, Aleksandr Vorobev "Fighting biases with dynamic boosting". arXiv:1706.09516, 2017](https://arxiv.org/pdf/1706.09516.pdf)


- [Anna Veronika Dorogush, Vasily Ershov, Andrey Gulin "CatBoost: gradient boosting with categorical features support". Workshop on ML Systems at NIPS 2017](http://learningsys.org/nips17/assets/papers/paper_11.pdf)


# Categorical features

所谓类别型变量（Categorical features）是指其值是离散的集合且相互比较并无意义的变量，比如用户的ID、产品ID、颜色等。因此，这些变量无法在二叉决策树当中直接使用。常规的做法是将这些类别变量通过预处理的方式转化成数值型变量再喂给模型，比如用一个或者若干个数值来代表一个类别型特征。

目前广泛用于**低势**（一个有限集的元素个数是一个自然数）类别特征的处理方法是`One-hot encoding`：将原来的特征删除，然后对于每一个类别加一个0/1的用来指示是否含有该类别的数值型特征。`One-hot encoding`可以在数据预处理时完成，也可以在模型训练的时候完成，从训练时间的角度，后一种方法的实现更为高效，Catboost对于低势类别特征也是采用后一种实现。

显然，在**高势**特征当中，比如 `user ID`，这种编码方式会产生大量新的特征，造成维度灾难。一种折中的办法是可以将类别分组成有限个的群体再进行 `One-hot encoding`。一种常被使用的方法是根据目标变量统计（Target Statistics，以下简称TS）进行分组，目标变量统计用于估算每个类别的目标变量期望值。甚至有人直接用TS作为一个新的数值型变量来代替原来的类别型变量。重要的是，可以通过对TS数值型特征的阈值设置，基于对数损失、基尼系数或者均方差，得到一个对于训练集而言将类别一分为二的所有可能划分当中最优的那个。在LightGBM当中，类别型特征用每一步梯度提升时的梯度统计（Gradient Statistics，以下简称GS）来表示。虽然为建树提供了重要的信息，但是这种方法有以下两个缺点：

- 增加计算时间，因为需要对每一个类别型特征，在迭代的每一步，都需要对GS进行计算；
- 增加存储需求，对于一个类别型变量，需要存储每一次分离每个节点的类别。

为了克服这些缺点，LightGBM以损失部分信息为代价将所有的长尾类别归位一类，作者声称这样处理高势特征时比起 `One-hot encoding`还是好不少。不过如果采用TS特征，那么对于每个类别只需要计算和存储一个数字。

如此看到，采用TS作为一个新的数值型特征是最有效、信息损失最小的处理类别型特征的方法。TS也被广泛采用，在点击预测任务当中，这个场景当中的类别特征有用户、地区、广告、广告发布者等。接下来我们着重讨论TS，暂时将`One-hot encoding`和GS放一边。

## Target statistics

一个有效和高效的处理类别型特征$i$的方式是用一个与某些TS相等的数值型变量$\hat{x}_k^i$来代替第$k$个训练样本的类别${x}_k^i$。通常用基于类别的目标变量$y$的期望来进行估算：$\hat{x}_k^i\approx\mathbb{E}(y|x^i={x}_k^i)$。

### Greedy TS

估算$\mathbb{E}(y|x^i={x}_k^i)$最直接的方式就是用训练样本当中相同类别$x_k^i$的目标变量$y$的平均值。
$$\hat{x}_k^i=\frac{\sum_{j=1}^n\mathbb{I}_{\{x_j^i={x}_k^i\}}\cdot y_i}{\sum_{j=1}^n\mathbb{I}_{\{x_j^i={x}_k^i\}}}$$
显然，这样的处理方式很容易引起过拟合。举个例子，假如在整个训练集当中所有样本的类别${x}_k^i$都互不相同，即$k$个样本有$k$个类别，那么新产生的数值型特征的值将与目标变量的值相同。某种程度上，这是一种目标穿越（target leakage），非常容易引起过拟合。比较好的一种做法是采用一个先验概率$p$进行平滑处理：
$$\hat{x}_k^i=\frac{\sum_{j=1}^n\mathbb{I}_{\{x_j^i={x}_k^i\}}\cdot y_i+a\,p}{\sum_{j=1}^n\mathbb{I}_{\{x_j^i={x}_k^i\}}+a}$$
其中$a>0$是先验概率$p$的权重，而对于先验概率，通常的做法是设置为数据集当中目标变量的平均值。

不过这样的平滑处理依然无法完全避免目标穿越：特征$\hat{x}_k^i$是通过自变量$X_k$的目标$y_k$计算所得。这将会导致条件偏移：对于训练集和测试集，$\hat{x}_k^i|y$的分布会有所不同。再举个例子，假设第$i$个特征为类别型特征，并且特征所有取值为无重复的集合，然后对于每一个类别$A$，对于一个分类任务，我们有$P(y=1|x^i=A)=0.5$。然后在训练集当中，$\hat{x}_k^i=\frac{y_k+a\,p}{1+a}$，于是用阈值$t=\frac{0.5+a\,p}{1+a}$就可以仅用一次分裂就训练集完美分开。但是，对于测试集，因为还无法判断此时目标变量的类别，所以这一项$\sum_{j=1}^n\mathbb{I}_{\{x_j^i={x}_k^i\}}=0$，最后得到的TS值为$p$，并且得到的模型在$p<t$时，预测目标为0，反之则为1，两种情况下的准确率都为0.5。总结一下，我们希望TS有以下的性质：
$${\rm{P1}\quad}\mathbb{E}(\hat{x}^i|y=v)=\mathbb{E}(\hat{x}_k^i|y_k=v)$$
其中，$(X_k, y_k)$是第$k$个训练样本。

在我们的例子当中，$\mathbb{E}(\hat{x}_k^i|y_k)=\frac{y_k+a\,p}{1+a}$，
$\mathbb{E}(\hat{x}_k^i|y)=p$，显然无法满足上述条件。

### Holdout TS

留出TS，就是将训练集一分为二：$\mathcal{D}=\hat{\mathcal{D}}_0 \sqcup\hat{\mathcal{D}}_1$，然后根据下式用$\mathcal{D}_k=\hat{\mathcal{D}}_0$来计算TS，并将$\hat{\mathcal{D}}_1$作为训练样本。
$$\hat{x}_k^i=\frac{\sum_{X_j \in {\mathcal{D}_k}}\mathbb{I}_{\{x_j^i={x}_k^i\}}\cdot y_i+a\,p}{\sum_{X_j \in {\mathcal{D}_k}}\mathbb{I}_{\{x_j^i={x}_k^i\}}+a}$$

这样处理能够满足同分布的问题，但是却大大减少了训练样本的数量。

### Leave-one-out TS

初看起来，留一TS（Leave-one-out TS）能够非常好地工作：

- 对于训练样本：$\mathcal{D}_k=\mathcal{D}\backslash X_k$
- 对于测试样本：$\mathcal{D}_k=\mathcal{D}$

但事实上，这并没有给预防target leakage带来多少益处。举个例子，考虑一个常数类别型特征：对于所有的样本，$x_k^i=A$，在二分类的条件下，让$n^+$表示$y=1$的样本数量，则有：

- $\hat{x}_k^i=\frac{n^{+}-y_k+a\,p}{n-1+a}$
- 对于测试样本：$\hat{x}^i=\frac{n^{+}+a\,p}{n+a}$

此时，同样可以用阈值$\hat{x}_k^i=\frac{n^{+}-0.5+a\,p}{n-1+a}$将训练集完美的分类。

### Ordered TS

从在线学习按照时间序列获得样本得到的启发，Catboost依靠排序原则，采用了一种更为有效的策略。主要有以下几个步骤：

- 产生一个随机排列顺序$\sigma$并对数据集进行编号
- 对于训练样本：$\mathcal{D}_k=\{X_j: \sigma(j)<\sigma(k)\}$
- 对于测试样本：$\mathcal{D}_k=\mathcal{D}$
- 根据带先验概率的Greedy TS计算$\hat{x}_k^i$

这样计算得到的 Ordered TS能够满足P1，同时也能够使用所有的训练样本。且比在线学习的划窗（sliding window）处理能够进一步减小$\hat{x}_k^i$的方差。需要注意的是，Catboost在不同的迭代上会采用不同的排列顺序。

下面是Ordered TS与其它各种TS在不同数据集上面在logloss/zero-one loss上面的效果比较：

![TS比较](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/Catboost/%2A%20Presentation%202019-08-26%2008-49-27%20TS%E6%AF%94%E8%BE%83.png)


## 特征组合

CatBoost的另外一项重要实现是将不同类别型特征的组合作为新的特征，以获得高阶依赖（high-order dependencies），比如在广告点击预测当中用户ID与广告话题之间的联合信息，又或者在音乐推荐引用当中，用户ID和音乐流派，如果有些用户更喜欢摇滚乐，那么将用户ID和音乐流派分别转换为数字特征时，这种用户内在的喜好信息就会丢失。然而，组合的数量会随着数据集中类别型特征的数量成指数增长，因此在算法中考虑所有组合是不现实的。为当前树构造新的分割点时，CatBoost会采用贪婪的策略考虑组合。对于树的第一次分割，不考虑任何组合。对于下一个分割，CatBoost将当前树的所有组合、类别型特征与数据集中的所有类别型特征相结合，并将新的组合类别型特征动态地转换为数值型特征。CatBoost还通过以下方式生成数值型特征和类别型特征的组合：树中选定的所有分割点都被视为具有两个值的类别型特征，并像类别型特征一样地被进行组合考虑。

# Gradient bias

CatBoost，和所有标准梯度提升算法一样，都是通过构建新树来拟合当前模型的梯度。然而，所有经典的提升算法都存在由有偏的点态梯度估计引起的过拟合问题。在每个步骤中使用的梯度都使用当前模型中的相同的数据点来估计，这导致估计梯度在特征空间的任何域中的分布与该域中梯度的真实分布相比发生了偏移，从而导致过拟合。为了解决这个问题，CatBoost对经典的梯度提升算法进行了一些改进，简要介绍如下：

在许多利用GBDT框架的算法（例如，XGBoost、LightGBM）中，构建下一棵树分为两个阶段：选择树结构和在树结构固定后计算叶子节点的值。为了选择最佳的树结构，算法通过枚举不同的分割，用这些分割构建树，对得到的叶子节点中计算值，然后对得到的树计算评分，最后选择最佳的分割。两个阶段叶子节点的值都是被当做梯度或牛顿步长的近似值来计算。在CatBoost中，第二阶段使用传统的GBDT框架执行，第一阶段使用修改后的版本。

既然原来的梯度估计是有偏的，那么能不能改成无偏估计呢？

设$F^i$为构建$i$棵树后的模型，$g^i(X_k,y_k)$为构建$i$棵树后第$k$个训练样本上面的梯度值。为了使得 $g^i(X_k,y_k)$无偏于模型 $F^i$，我们需要在没有$X_k$参与的情况下对模型$F^i$进行训练。由于我们需要对所有训练样本计算无偏的梯度估计，乍看起来对于$F^i$的训练不能使用任何样本，貌似无法实现的样子。我们运用下面这个技巧来处理这个问题：对于每一个样本$X_k$，我们训练一个单独的模型$M_k$，且该模型从不使用基于该样本的梯度估计进行更新。我们使用$M_k$来估计$X_k$上的梯度，并使用这个估计对结果树进行评分。用伪码描述如下，其中$Loss(y,a)$是需要优化的损失函数，$y$是标签值， $a$是公式计算值。

![Gradient bias](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/Catboost/%2A%20CatBoost-%20gradient%20boosting%20with%20categorical%20features%20support%202019-08-26%2011-19-34%20Gradient%20bias.png)

值得注意的是${M_{i}}$模型的建立并没有样本${X_{i}}$ 的参与，并且CatBoost中所有的树${M_{i}}$的共享同样的结构。

在CatBoost中，我们生成训练数据集的$s$个随机排列。采用多个随机排列是为了增强算法的鲁棒性，这在前面的Odered TS当中对于类别型特征的处理有介绍到：针对每一个随机排列，计算得到其梯度，为了与Ordered TS保持一致，这里的排列与用于计算Ordered TS时的排列相同。我们使用不同的排列来训练不同的模型，因此不会导致过拟合。对于每个排列$\sigma$，我们训练$n$个不同的模型${M_{i}}$，如上所示。这意味着为了构建一棵树，需要对每个排列存储并重新计算，其时间复杂度近似于$O(n^2)$：对于每个模型${M_{i}}$，我们必须更新${M_{1}}({X_{1}}),...,{M_{i}}({X_{i}})$。因此，时间复杂度变成$O(sn^2)$。当然，在具体实现当中，Catboost使用了其它的技巧，可以将构建一个树的时间复杂度降低到$O(sn)$。

# Prediction shift

预测偏移（Prediction shift）是由上一节所讨论的梯度偏差造成的。本节希望用数学语言严格地对预测偏差进行描述和分析。

首先来看下梯度提升的整体迭代过程：

- 对于梯度提升：$F^t = F^{t-1}+\alpha^t\,h^t,\,h^t=\underset{h \in H}{\mathrm{argmin}}\mathcal{L}(F^{t-1}+h)$
- $g^t(X,y):=\frac{\partial L(y,s)}{\partial s}|_{s=F^{t-1}(x)}$
- $\hat{h}^t=\underset{h \in H}{\mathrm{argmin}}\mathbb{E}{\left(-g^t(X,y)-h(X)\right)}^2$
- $h^t=\underset{h \in H}{\mathrm{argmin}}\frac{1}{n}\sum_{k=1}^n{\left(-g^t(X_k,y_k)-h(X_k)\right)}^2$

在这个过程当中，偏移是这样发生的：

- 根据$\mathbb{D} \backslash \{X_k\}$进行随机计算的条件分布$g^t(X_k,y_k)|X_k$与测试集的分布$g^t(X,y)|X$发生偏移
- 这样导致基学习器$h^t$与 $\hat{h}^t$产生偏差
- 最后影响模型$F^t$的泛化能力

下面以一个回归任务为例，从理论上分析计算偏差的值。

假设以下边界条件：

- 损失函数：$L(y,\hat{y})=(y-\hat{y})^2$
- 两个相互独立的特征$x^1,x^2$，随机变量，符合伯努利分布，先验概率$p=1/2$
- 目标函数：$y=f^*(x)=c_1\,x^1+c_2\,x^2$
- 梯度提升迭代次数为2
- 树深度为1
- 学习率：$\alpha=1$

最后得到的模型为：$F=F^2=h^1+h^2$，其中$h^1,h^2$分别基于$x^1$和 $x^2$。

区分数据集是否独立，我们有以下两个推论：

- 如果使用了规模为$n$的两个独立数据集$\mathcal{D}_1$和 $\mathcal{D}_2$来分别估算$h^1$ 和$h^2$，则对于任意$x \in {\{0,1\}}^2$，有：$\mathbb{E}_{\mathcal{D}_1,\mathcal{D}_2}\,F^2(X)=f^*(X)+O(\frac{1}{2^n})$
- 如果使用了相同的数据集$\mathcal{D}$来估算$h^1$ 和$h^2$，则有：$\mathbb{E}_{\mathcal{D}_1,\mathcal{D}_2}\,F^2(X)=f^*(X)+O(\frac{1}{2^n})-\frac{1}{n-1}c_2(x^2-\frac{1}{2}$

显然，偏差部分$\frac{1}{n-1}c_2(x^2-\frac{1}{2}$与数据集的规模$n$成反比，与映射关系$f^*$也有关系，在我们的例子当中，与$c_2$成正比。

# Ordered boosting

为了克服上一节所描述的预测偏移问题，我们提出了一种新的叫做Ordered boosting的算法。假设用$I$棵树来学习一个模型，为了确保$r^{I-1}(X_k,y_k)$无偏，需要确保模型$F^{I-1}$的训练没有用到样本$X_k$。由于我们需要对所有训练样本计算无偏的梯度估计，乍看起来对于$F^{I-1}$的训练不能使用任何样本，貌似无法实现的样子，但是事实上可以通过一些技巧来进行克服，具体的算法在前面已经有所描述，而且是作者较新的论文当中的描述，这里不再赘述。本节主要讲讲Ordered boosting的具体实现。

Ordered boosting算法好是好，但是在大部分的实际任务当中都不具备使用价值，因为需要训练$n$个不同的模型，大大增加的内存消耗和时间复杂度。在Catboost当中，我们实现了一个基于GBDT框架的修改版本。

前面提到过，在传统的GBDT框架当中，构建下一棵树分为两个阶段：选择树结构和在树结构固定后计算叶子节点的值。Catboost主要在第一阶段进行优化。

## First phase

在建树的阶段，Catboost有两种提升模式，Ordered和Plain。Plain模式是采用内建的ordered TS对类别型特征进行转化后的标准GBDT算法。Ordered则是对Ordered boosting算法的优化。


### Ordered boosting mode

一开始，Catboost对训练集产生$s+1$个独立的随机序列。序列$\sigma_1,...,\sigma_s$用来评估定义树结构的分裂，$\sigma_0$用来计算所得到的树的叶子节点的值。因为，在一个给定的序列当中，对于较短的序列，无论是TS的计算还是基于Ordered boosting的预测都会有较大的方差，所以仅仅用一个序列可能引起最终模型的方差，这里我们会有多个序列进行学习。

Catboost采用对称树作为基学习器，对称意味着在树的同一层，其分裂标准都是相同的。对称树具有平衡、不易过拟合并能够大大减少测试时间的特点。建树的具体算法如下伪码描述。

![Building a tree in CatBoost](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/Catboost/%2A%20CatBoost-%20unbiased%20boosting%20with%20categorical%20features%202019-08-26%2020-24-29%20Catboost%E5%BB%BA%E6%A0%91.png)

在Ordered boosting模式的学习过程当中，我们维持一个模型$M_{r,j}$，其中$M_{r,j}(i)$表示基于在序列$\sigma_r$当中的前$j$个样本学习得到的模型对于第$i$个样本的预测。在算法的每一次迭代$t$，我们从$\{\sigma_1,...,\sigma_s\}$当中抽样一个随机序列$\sigma_r$，并基于此构建第$t$步的学习树$T_t$。然后，基于$M_{r,j}(i)$，计算相应的梯度$grad_{r,j}(i)=\frac{\partial L(y_i,s)}{\partial s}|_{s=M_{r,j}(i)}$。接下来，我们会用余弦相似度来近似梯度$G$，其中对于每一个样本$i$，我们取梯度$grad_{r,\sigma(i)-1}(i)$。在候选分裂评估过程当中，第$i$个样本的叶子节点的值$\delta(i)$由与$i$同属一个叶子的$leaf_r(i)$的所有样本的前$p$个样本的梯度值$grad_{r,\sigma(i)-1}$求平均得到。需要注意的是，$leaf_r(i)$取决于选定的序列$\sigma_r$，因为$\sigma_r$会影响第$i$个样本的Ordered TS。当树$T_t$的结构确定以后，我们用它来提升所有的模型$M_{r^',j}$，我们需要强调下，一个相同的树结构$T_t$会被用于所有的模型，但是会根据$r^'$和 $j$的不同设置不同的叶子节点的值以后应用于不同的模型。

### Plain boosting mode 

Plain boosting模式的算法与标准GBDT流程类似，但是如果出现了类别型特征，它会基于$\sigma_1,...,\sigma_s$得到的TS维持$s$个支持模型$M_r$。


## Second phase

当所有的树结构确定以后，最终模型的叶子节点值的计算与标准梯度提升过程类似。第$i$个样本与叶子$leaf_0(i)$进行匹配，我们用$\sigma_0$来计算这里的TS。当最终模型$F$在测试期间应用于新的样本，我们采用整个训练集来计算TS.

# GPU加速
 


# sklearn参数

`sklearn`本身的文档当中并没有LightGBM的描述，[Github](https://github.com/microsoft/LightGBM/blob/master/python-package/lightgbm/sklearn.py)上面看到主要参数如下：

- `boosting_type` : 提升类型，字符串，可选项 (default=`gbdt`)
    - `gbdt`, 传统梯度提升树
    - `dart`, 带Dropout的MART
    - `goss`, 单边梯度采样
    - `rf`, 随机森林
- `num_leaves` : 基学习器的最大叶子树，整型，可选项 (default=31)
- `max_depth` : 基学习器的最大树深度，小于等于0表示没限制，整型，可选项 (default=-1)
- `learning_rate` : 提升学习率，浮点型，可选项 (default=0.1)
- `n_estimators` : 提升次数，整型，可选项 (default=100)
- `subsample_for_bin` : 构造分箱的样本个数，整型，可选项 (default=200000)
- `objective` : 指定学习任务和相应的学习目标或者用户自定义的需要优化的目标损失函数，字符串， 可调用的或者None, 可选项 (default=None)，若不为None，则有:
    - `regression` for LGBMRegressor
    -`binary` or `multiclass` for LGBMClassifier
    - `lambdarank` for LGBMRanker
- `class_weight` : 该参数仅在多分类的时候会用到，多分类的时候各个分类的权重，对于二分类任务，你可以使用``is_unbalance`` 或 ``scale_pos_weight``，字典数据, `balanced` or None, 可选项 (default=None)
- `min_split_gain` : 在叶子节点上面做进一步分裂的最小损失减少值，浮点型，可选项 (default=0.)
- `min_child_weight` : 在树的一个孩子或者叶子所需的最小样本权重和，浮点型，可选项 (default=1e-3)
- `min_child_samples` : 在树的一个孩子或者叶子所需的最小样本，整型，可选项 (default=20)
- `subsample` : 训练样本的子采样比例，浮点型，可选项 (default=1.)
- `subsample_freq` : 子采样频率，小于等于0意味着不可用，整型，可选项 (default=0)
- `colsample_bytree` : 构建单棵树时列采样比例，浮点型，可选项 (default=1.)
- `reg_alpha` : $L_1$正则项，浮点型，可选项 (default=0.)
- `reg_lambda` :$L_2$正则项，浮点型，可选项 (default=0.)
- `random_state` : 随机数种子，整型或者None, 可选项 (default=None)
- `n_jobs` : 线程数，整型，可选项 (default=-1)
- `silent` : 运行时是否打印消息，布尔型，可选项 (default=True)
- `importance_type` : 填入到`feature_importances_`的特征重要性衡量类型，如果是`split`，则以特征被用来分裂的次数，如果是`gain`，则以特征每次用于分裂的累积增益，字符串，可选项 (default=`split`)


除了以上参数，LightGBM原生接口当中参数众多，主要有以下八大类：

- 核心参数
- 学习控制参数
- IO参数
- 目标参数
- 度量参数
- 网络参数
- GPU参数
- 模型参数

如果有遗漏，具体可以参阅[LightGBM Parameters](https://lightgbm.readthedocs.io/en/latest/Parameters.html)

# 应用场景

作为GBDT框架内的算法，GBDT、XGBoost能够应用的场景LightGBM也都适用，并且考虑到其对于大数据、高维特征的诸多优化，在数据量非常大、维度非常多的场景更具优势。近来，有着逐步替代XGBoost成为各种数据挖掘比赛baseline的趋势。


# CatBoost（了解）

CatBoost也是Boosting族的算法，由俄罗斯科技公司Yandex于2017年提出，主要在两方面做了优化，一个是对于类别变量的处理，另外一个是对于预测偏移（prediction shift）的处理。

其中对于类别变量在传统的Greedy TBS方法的基础上添加先验分布项，这样可以减少减少噪声和低频率数据对于数据分布的影响：
$$\hat{x}_k^i=\frac{\sum_{j=1}^n I_{\{x_j^i=x_k^i\}}*y_j+a\,P}{\sum_{j=1}^n I_{\{x_j^i=x_k^i\}}+a}$$

其中 $P$ 是添加的先验项，$a$ 通常是大于 0 的权重系数。  

对于第二个问题，CatBoost采用了排序提升（Ordered Boosting）的方式，首先对所有的数据进行随机排列，然后在计算第 $i$ 步残差时候的模型只利用了随机排列中前 $i-1$ 个样本。具体算法描述请参阅论文[CatBoost: unbiased boosting with categorical features](https://papers.nips.cc/paper/7898-catboost-unbiased-boosting-with-categorical-features.pdf)

时间有限，下次有机会再详细消化下CatBoost的论文。

总之，CatBoost大大简化了前期数据处理过程，特别是类别特征的数值化，调参也相对容易。近来在数据竞赛领域已经大规模采用。



# 参考



- [《机器学习》，周志华](https://book.douban.com/subject/26708119/)
- [《统计学习方法》（第二版），李航](https://book.douban.com/subject/33437381/)
- [CatBoost Docs](https://catboost.ai/)
- [Catboost](https://github.com/catboost/catboost)
- [CatBoost: unbiased boosting with categorical features](https://papers.nips.cc/paper/7898-catboost-unbiased-boosting-with-categorical-features.pdf)
- [CatBoost: gradient boosting with categorical features support](http://learningsys.org/nips17/assets/papers/paper_11.pdf)
- [CatBoost: Python package training parameters](https://catboost.ai/docs/concepts/python-reference_parameters-list.html)
