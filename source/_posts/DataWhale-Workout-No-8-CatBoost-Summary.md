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

不过这样的平滑处理依然无法完全避免目标穿越：特征$\hat{x}_k^i$是通过自变量$X_k$的目标$y_k$计算所得。这将会导致条件偏移：对于训练集和测试集，$\hat{x}_k^i|y$的分布会有所不同。再举个例子，假设第$i$个特征为类别型特征，并且特征所有取值为无重复的集合，然后对于每一个类别$A$，对于一个分类任务，我们有$P(y=1|x^i=A)=0.5$。然后在训练集当中，$\hat{x}_k^i=\frac{y_k+a\,p}{1+a}$，于是用阈值$t=\frac{0.5+a\,p}{1+a}$就可以仅用一次分裂就训练集完美分开。但是，对于测试集，因为$\sum_{j=1}^n\mathbb{I}_{\{x_j^i={x}_k^i\}}=0$，所以得到的TS值为$p$，并且得到的模型在$p<t$时，预测目标为0，反之则为1，两种情况下的准确率都为0.5。总结一下，我们希望TS有以下的性质：
$${\rm{P1}\quad}\mathbb{E}(\hat{x}^i|y=v)=\mathbb{E}(\hat{x}_k^i|y_k=v)$$
其中，$(X_k, y_k)$是第$k$个训练样本。

在我们的例子当中，$\mathbb{E}(\hat{x}_k^i|y_k)=\frac{y_k+a\,p}{1+a}$，$\mathbb{E}(\hat{x}_k^i|y)=p$，显然无法满足上述条件。

### Holdout TS

留出TS，就是将训练集一分为二：$\mathcal{D}=\hat{\mathcal{D}}_0 \sqcup\hat{\mathcal{D}}_1$，然后根据下式用$\mathcal{D}_k=\hat{\mathcal{D}}_0$来计算TS，并将$\hat{\mathcal{D}}_1$作为训练集。
$$\hat{x}_k^i=\frac{\sum_{X_j \in {\mathcal{D}_k}}\mathbb{I}_{\{x_j^i={x}_k^i\}}\cdot y_i+a\,p}{\sum_{X_j \in {\mathcal{D}_k}}\mathbb{I}_{\{x_j^i={x}_k^i\}}+a}$$

这样处理能够满足同分布的问题，但是却大大减少了训练集的数量。

### Leave-one-out TS




# Gradient bias
# Prediction shift
# Ordered boosting
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

