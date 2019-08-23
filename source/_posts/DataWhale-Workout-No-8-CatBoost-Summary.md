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


# CatBoost的起源



# Categorical features
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

