---
title: GBDT算法梳理
date: 2019-08-08 14:32:27
categories: 机器学习
tags:
- 集成学习
- GBDT
- Gradient Boosting
- sklearn
description: DataWhale暑期学习小组-高级算法梳理第八期Task2。
---

GBDT（Gradient Boosting Decision Tree）是一种可用于处理分类（classification）和回归（regression）任务的机器学习集成算法，和其它Boosting族的算法类似地分步构建模型，然后通过对任意可微的损失函数（loss function）的优化来进行推广运用。

Gradient Boosting的思想起源于Leo Briman的评论：Boosting可以解释为一个基于合适的损失函数的优化算法。随后Friedman开发了显式回归梯度提升算法，同时部分学者从更通用的函数梯度下降（functional gradient descent）视角进行跟进，发表了将boosting算法作为迭代函数梯度下降算法（iterative functinal gradient descent algorithms）的观点。也就是说，GBDT是一种通过迭代选定的指向负梯度方向的函数（弱学习器）在函数空间对损失函数进行优化的算法。这种将boosting视为函数梯度的观点也推动了boosting族算法在回归和分类以外的其它机器（统计）学习领域的发展。

# 前向分布算法

考虑加法模型（additive model）

$$f(x)=\sum_{m=1}^M\beta_mb(x;\gamma_m)$$

其中，$b(x;\gamma_m)$为基函数，$\gamma_m$为基函数的参数，$\beta_m$为基函数的系数。

在给定训练数据以及损失函数$L(Y,f(x))$的条件下，学习加法模型$f(x)$成为经验风险极小化即损失函数极小化问题：

$$\mathop{\arg\min}_{\beta_m,\;\gamma_m}\sum_{i=1}^{N}L\left(y_i,\sum_{m=1}^{M}\beta_mb(x_i;\gamma_m)\right)$$

通常来说，这是一个复杂的优化问题，NP难。

而前向分步算法（forward stage-wise algorithm）求解这一优化问题采用的是贪心策略：

- 因为是加法模型，从前往后，每一步只学习一个基函数及其系数
- 通过迭代，逐步逼近优化目标函数，求局部最优解，达到简化优化的复杂度
- 每步只需优化的如下损失函数：

$$\mathop{\arg\min}_{\beta,\;\gamma}L\left(y_i,\sum_{i=1}^{N}\beta\;b(x_i;\gamma)\right)$$

前向分步算法的具体流程如下：

- **输入：**

	- 训练数据集$T=\{(x_1,y_1),(x_2,y_2),...,(x_N,y_N)\},x_i\in X\subseteq R^n,y_i \in Y=\{-1,+1\}$；损失函数 $L(Y,f(X))$；基函数集$\{b(x;\gamma)\}$

- **输出：**

	- 加法模型 $f(x)$

- 初始化 $f_0(x)$
- 对$m=1,2,...,M$
	- 极小化损失函数，得到参数$\beta_m,\,\gamma_m$
	$$(\beta_m,\,\gamma_m)=\mathop{\arg\min}_{\beta,\;\gamma}\sum_{i=1}^{N}L\left(y_i,\,f_{m-1}(x_i)+\beta\;b(x_i;\gamma)\right)$$
	- 更新
	$$f_m(x)=f_{m-1}(x)+\beta_mb(x;\gamma_m)$$
- 得到加法模型
$$f(x)=f_M(x)=\sum_{m=1}^M\beta_mb(x;\gamma_m)$$

这样，前向分步算法将同时求解从$m=1$到$M$所有参数$\beta_m,\,\gamma_m$的优化问题简化为逐次求解各个$\beta_m,\,\gamma_m$的优化问题。


# 负梯度拟合

负梯度拟合，顾名思义，就是在损失函数梯度的负方向上进行拟合，这个和梯度下降算法咋看起来非常类似，梯度下降是在参数空间沿着负梯度的方向进行拟合，而Gradient Boosting是在函数空间沿着负梯度的方向进行拟合。这一方法由Freidman最早提出，用损失函数的负梯度来拟合本轮损失的近似值，第$m$轮的第$i$个样本的损失函数的负梯度表示为：

$$r_{mi}=-[\frac{\partial L(y_i,\,f(x_i))}{\partial f(x_i)}]_{f(x)=f_{m-1}(x)}$$

那么问题来了，为什么要拟合负梯度？这就涉及到泰勒公式和梯度下降算法了。

## 泰勒公式

- 定义：泰勒公式是一个用函数在某点的信息描述其附近取值的近似公式，具有局部 有效性。

- 基本形式
$$f(x)=\sum_{n=0}^\infty\frac{f^{(n)}x_0}{n!}(x-x_o)^n$$
	- 一阶泰勒展开：
	$$f(x)\approx f(x_0)+f'(x_0)(x-x_0)$$
	- 二阶泰勒展开：
	$$f(x)\approx f(x_0)+f'(x_0)(x-x_0)+f''(x_0)\frac{(x-x_0)^2}{2}$$


- 迭代形式

假设$x^t=x^(t-1)+\Delta	x$，将$f(x^t)$在$x^{t-1}$处进行泰勒展开：
	$$
	\begin{align}
   f(x^t) &=f(x^{t-1}+\Delta x) \\ 
	& \approx f(x_0)+f'(x_0)(x-x_0)+f''(x_0)\frac{(x-x_0)^2}{2}
	\end{align}
$$
## 梯度下降法

在机器学习任务中，需要最小化损失函数 $L(\theta)$ ，其中 $\theta$是要求解的模型参数。梯度下降法常用来求解这种无约束最优化问题，它是一种迭代方法：选择初值 $\theta^0$，不断迭代更新 $\theta$ 的值，进行损失函数极小化。

- 迭代公式： $\theta^t=\theta^{t-1}+\Delta\theta$
- 将 $L(\theta^t)$ 在 $\theta^{t-1}$ 处进行一阶泰勒展开： $$
	\begin{align}
   L(\theta^t) &=L(\theta^{t-1}+\Delta \theta\,) \\ 
	& \approx L(\theta^{t-1})+L'(\theta^{t-1})\,\Delta\theta
	\end{align}
$$

- 要使得  $L(\theta^t) <L(\theta^{t-1}$ ，可取： $\Delta\theta=-\alpha L'(\theta^{t-1})$ ，则：  $\theta^t=\theta^{t-1}-\alpha L'(\theta^{t-1})$ ，这里 $\alpha$ 是步长，一般直接赋值一个小的数。


相对的，在函数空间里，有 $f^t(x)=f^{t-1}(x)+f_t(x)$

此处把 $L(f^t(x))$ 看成提升树算法的第 $t$ 步损失函数的值， $L(f^{t-1}(x))$为第 $t-1$ 步损失函数值，要使  $L(f^t(x))<L(f^{t-1}(x))$ ，则需要 $f_t(x)=-\alpha g_t(x)$ ，这里 $-g_t(x)$ 为当前模型的负梯度值，即第$t$步的回归树需要拟合的值。

# 损失函数

因为GBDT是通过拟合损失函数负梯度来进行学习的，所有损失函数的选择非常重要。这里我们对GBDT常用的损失函数再做一个总结。

## 分类问题

- 指数损失函数：

$$L(y,f(x))=e^{(-yf(x))}$$

- 对数似然损失函数（二分类）：

$$L(y,f(x))=log\left(1+e^{(-yf(x))}\right)$$

- 对数似然损失函数（多分类）：

$$L(y,f(x))=-\sum_{k=1}^Ky_k\,log\,p_k(x)$$

## 回归问题

- 平方损失函数：

$$L(y,f(x))=(y-f(x))^2$$

此时，负梯度正好与每一步迭代损失函数的残差相等，拟合负梯度也等同于拟合残差。

- 绝对损失函数：

$$L(y,f(x))=|(y-f(x))|$$

对应负梯度方向为：

$$sign(y_i-f(x_i))$$

- Huber损失，它是均方差和绝对损失的折中产物，对于远离中心的异常点，采用绝对损失误差，而对于靠近中心的点则采用平方损失。这个界限一般用分位数点度量。损失函数如下：

$$
L(y,f(x))=\begin{cases}
\frac{1}{2}(y-f(x))^2,\quad &|y-f(x)|\leq \delta \\\\
\delta\left(|y-f(x)|-\frac{\delta}{2}\right),\quad &|y-f(x)|>0
\end{cases}
$$

对应的负梯度误差为：

$$
r(y_i,f(x_i))=\begin{cases}
y_i-f(x_i),\quad &|y_i-f(x_i)|\leq \delta \\\\
sign(y_i-f(x_i)),\quad &|y_i-f(x_i)|>0
\end{cases}
$$

- 分位数损失，它对应的是分位数回归的损失函数，表达式为：

$$L(y,f(x))=\sum_{y\geq f(x)}\theta|y-f(x)|+\sum_{y<f(x)}(1-\theta)|y-f(x)|$$

其中$\theta$为分位数，需要我们再回归前制定。对应的负梯度误差为：

$$
r(y_i,f(x_i))=\begin{cases}
\theta, \quad &y_i\geq f(x_i) \\\\
\theta-1,\quad &y_i< f(x_i)
\end{cases}
$$

对于Huber损失和分位数损失，主要用于健壮回归，也就是减少异常点对损失函数的影响。

# 回归

有了损失函数和损失函数拟合策略，下面来看看GBDT的具体实现。考虑到回归问题处理负梯度相对简单，那么从回归问题开始讲。

- **输入：**

	- 训练数据集$T=\{(x_1,y_1),(x_2,y_2),...,(x_N,y_N)\},x_i\in X\subseteq R^n,y_i \in Y\subseteq R$；损失函数$L(Y,f(X))$；最大迭代次数 $M$。
- **输出：**

	- 回归树 $f(x)$

- 初始化弱学习器

$$f_0(x)=\mathop{\arg\min}_{c}\sum_{i=1}^{N}L(y_i,c)$$


- 对$m=1,2,...,M$
	- 对$i=1,2,...,N$，计算损失函数在当前模型的负梯度：


	$$r_{mi}=-[\frac{\partial L(y_i,\,f(x_i))}{\partial f(x_i)}]_{f(x)=f_{m-1}(x)}$$

	- 利用$(x_i,r_{mi})\,(i=1,2,...,N)$，拟合一棵CART树，得到第$m$棵树，其对应的叶子节点区域为$R_{mj},\,j=1,2,...,J$。其中$J$为树$m$的叶子节点的个数。	
	- 对$j=1,2,...,J$，在损失函数极小化条件下，估计出相应叶节点区域的最佳拟合值：
	$$c_{mj}=\mathop{\arg\min}_{c}\sum_{x_j\in R_{mj}}^{N}L(y_i,f_{m-1}(x_i)+c)$$


	- 更新强学习器：
	$$f_m(x)=f_{m-1}(x)+\sum_{j=1}^{J}c_{mj}\,I(x\in R_{mj})$$
- 得到强学习器$f(x)$的表达式：
$$f(x)=f_M(x)=f_0(x)+\sum_{m=1}^M\sum_{j=1}^{J}c_{mj}\,I(x\in R_{mj})$$

# 分类

下面再看看GBDT分类算法，GBDT的分类算法从思想上和GBDT的回归算法没有区别，但是由于样本输出不是连续的值，而是离散的类别，导致我们无法直接从输出类别去拟合类别输出的误差，好在GBDT可以根据学习任务灵活选择相应的损失函数。

为了解决这个问题，有两个方法，一个是用指数损失函数，此时GBDT退化为Adaboost算法。另一种方法用类似逻辑回归的对数似然函数的方法。也就是说，我们用的是类别的预测概率值和真实概率值的差来拟合损失。Adaboost算法已经在[随机森林算法梳理](http://datacruiser.io/2019/08/05/%E9%9A%8F%E6%9C%BA%E6%A3%AE%E6%9E%97%E7%AE%97%E6%B3%95%E6%A2%B3%E7%90%86/)涉及，此处仅讨论用对数似然函数的GBDT分类算法。并且，分布讨论采用对数似然损失函数的二元分类和多元分类的区别。

## 二分类

- **输入：**

	- 训练数据集$T=\{(x_1,y_1),(x_2,y_2),...,(x_N,y_N)\},x_i\in X\subseteq R^n,y_i \in Y=\{-1,+1\}$；损失函数$L(y,f(x))=log\left(1+e^{(-yf(x))}\right)$$；最大迭代次数 $M$。
- **输出：**

	- 分类树 $f(x)$

- 初始化弱学习器

$$f_0(x)=\mathop{\arg\min}_{c}\sum_{i=1}^{N}L(y_i,c)$$


- 对$m=1,2,...,M$
	- 对$i=1,2,...,N$，计算损失函数在当前模型的负梯度：


	$$r_{mi}=-[\frac{\partial L(y_i,\,f(x_i))}{\partial f(x_i)}]_{f(x)=f_{m-1}(x)}=\frac{y_i}{1+e^{(y_i\,f(x_i))}}$$

	- 利用$(x_i,r_{ti})\,(i=1,2,...,N)$，拟合一棵CART树，得到第$m$棵树，其对应的叶子节点区域为$R_{mj},\,j=1,2,...,J$。其中$J$为树$m$的叶子节点的个数。	
	- 对$j=1,2,...,J$，在损失函数极小化条件下，估计出相应叶节点区域的最佳拟合值：
	$$c_{mj}=\mathop{\arg\min}_{c}\sum_{x_j\in R_{mj}}^{N}log\left(1+e^{(-y_i(f_{t-1}(x_i)+c))}\right)$$

	- 由于上式比较难优化，我们一般使用近似值代替：
	$$c_{mj}=\sum_{x_j\in R_{mj}}/\sum_{x_j\in R_{mj}}|r_{mi}|(1-|r_{mi}|)$$


	- 更新强学习器：
	$$f_m(x)=f_{m-1}(x)+\sum_{j=1}^{J}c_{mj}\,I(x\in R_{mj})$$
- 得到强学习器$f(x)$的表达式：
$$f(x)=f_M(x)=f_0(x)+\sum_{m=1}^M\sum_{j=1}^{J}c_{mj}\,I(x\in R_{mj})$$

不难发现，除了负梯度计算和叶子节点的最佳负梯度拟合的线性搜索，二元GBDT分类和GBDT回归算法过程相同。

## 多分类

考虑到分类和回归算法的过程相似性，以下就阐述多分类GBDT算法的时候不再给出具体的流程，而仅仅列出差异的部分。

多分类GBDT比二分类GBDT复杂些，对应的是多元逻辑回归和二元逻辑回归的复杂度差别。假设类别数为$K$，则此时我们的对数似然损失函数为：

$$L(y,f(x))=-\sum_{k=1}^Ky_k\,log\,p_k(x)$$

其中如果样本输出类别为 $k$，则 $y_i$ =1，第 $k$ 类的概率 $p_k(x)$ 的表达式为：

$$p_k(x)=\frac{e^{f_k(x)}}{\sum_{l=1}^{K}e^{f_l(x)}}$$

集合上两式，我们可以计算出第 $m$ 轮的第 $i$ 个样本对应类别 $l$ 的负梯度误差为：

$$r_{mil}=-[\frac{\partial L(y_i,\,f(x_i))}{\partial f(x_i)}]_{f(x)=f_{l,\,m-1}(x)}=y_{il}-p_{l,m-1}(x_i)$$

观察上式可以看出，其实这里的误差就是样本 $i$ 对应类别 $l$ 的真实概率和 $t-1$ 轮预测概率的差值。

对于生成的决策树，我们各个叶子节点的最佳负梯度拟合值为：

$$c_{mjl}=\mathop{\arg\min}_{c_{jl}}\sum_{i=0}^{m}\sum_{k=1}^{K}L\left(y_k,\,f_{m-1,\,l}(x)+\sum_{j=0}^{J}c_{jl}\,I(x_i \in R_{mj})\right)$$

由于上式比较难优化，我们一般使用近似值代替:

$$c_{mjl}=\frac{K}{K-1}\frac{\sum_{x_i\in R_{mjl}}r_{mil}}{\sum_{x_i\in R_{mil}}|r_{mil}|(1-|r_{mil}|)}$$

除了负梯度计算和叶子节点的最佳负梯度拟合的线性搜索，多分类GBDT与二分类GBDT以及GBDT回归算法过程相同。

# 正则化

GBDT有非常快降低Loss的能力，这也会造成一个问题：Loss迅速下降，模型偏差（bias），方差（variance）高，造成过拟合。下面简单介绍GBDT中抵抗过拟合的方法：


- 限制树的复杂度，即对弱学习器CART树进行正则化剪枝，比如如控制树的最大深度、节点的最少样本数、最大叶子节点数、节点分支的最小样本数等
- Shrinkage，其思想认为，每次走一小步逐渐逼近结果的效果，要比每次迈一大步很快逼近结果的方式更容易避免过拟合。即它不完全信任每一个棵残差树，它认为每棵树只学到了真理的一小部分，累加的时候只累加一小部分，通过多学几棵树弥补不足。用方程来看更清晰，即给每棵数的输出结果乘上一个步长$\alpha$（learning rate）

对于前面的弱学习器的迭代：

$$f_m(x)=f_{m-1}(x)+T(x;\gamma_m)$$

加上正则化项，则有

$$f_m(x)=f_{m-1}(x)+\alpha T(x;\gamma_m)$$

此处，$\alpha$的取值范围为(0,1]。对于同样的训练集学习效果，较小$\alpha$的意味着需要更多的弱学习器的迭代次数。通常我们用步长和迭代最大次数一起决定算法的拟合效果。

下面是Sklearn的实现关于该参数设置的片段，XGBoost类似：


```python
#code snippets from sklearn.ensemble.gradient_boosting
class GradientBoostingClassifier(BaseGradientBoosting, ClassifierMixin):
    """Gradient Boosting for classification."""

    def __init__(self, ..., learning_rate=0.1, n_estimators=100, ...):
    """
    Parameters
    ----------
    learning_rate : float, optional (default=0.1)
        learning rate shrinks the contribution of each tree by `learning_rate`.
        There is a trade-off between learning_rate and n_estimators.
    n_estimators : int (default=100)
        The number of boosting stages to perform. Gradient boosting
        is fairly robust to over-fitting so a large number usually
        results in better performance
    """
```


- 子采样比例(subsample)，取值范围为(0,1]，GBDT这里的做法是在每一轮建树时，样本是从原始训练集中采用无放回随机抽样的方式产生，与随机森立的有放回抽样产生采样集的方式不同。若取值为1，则采用全部样本进行训练，若取值小于1，则不选取全部样本进行训练。选择小于1的比例可以减少方差，防止过拟合，但可能会增加样本拟合的偏差。取值要适中，推荐**[0.5,0.8]**
- Early stop，因为GBDT的可叠加性，我们使用的模型不一定是最终的ensemble，而根据测试集的测试情况，选择使用前若干棵树


# 优缺点


## 优点


- 可以灵活处理各种类型的数据，包括连续值和离散值
- 具有伸缩不变性，不用归一化特征
- 具有特征组合和特征选择的作用
- 可自然地处理缺失值
- 相对SVM而言，在相对较少的调参时间情况下，预测的准确率也比较高
- 在使用一些健壮的损失函数，对异常值得鲁棒性非常强。比如Huber损失函数和Quantile损失函数

## 缺点

- 由于弱学习器之间存在较强依赖关系，难以整体并行训练


# sklearn中的参数解释

在sklearn当中按学习任务的不同一共有两个与随机森林相关的类：[GradientBoostingClassifier](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.GradientBoostingClassifier.html#sklearn.ensemble.GradientBoostingClassifier)应用于分类学习任务，[GradientBoostingRegressor](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.GradientBoostingRegressor.html#sklearn.ensemble.GradientBoostingRegressor)应用于回归学习任务。

### GradientBoostingClassifier

#### 参数（parameters）

- **oss : {‘deviance’, ‘exponential’}, optional (default=’deviance’)**

	- 需要优化的损失函数


- **learning_rate : float, optional (default=0.1)**

	- 学习率（learning_rate），与`n_estimators`之间有个平衡

- **n_estimators : int (default=100)**

	- boosting迭代步数，Gradient boosting通常对于过拟合有鲁棒性，一个较大的数通常意味着更好的性能，整型，默认时100

- **subsample : float, optional (default=1.0)**

	- 用于训练基学习器的样本采样比例，小于1.0则等同于随机梯度提升（Stochasitc Gradient Boosting），与`n_estimators`相互作用，如果小于1则会减少方差，增加偏差

- **criterion : string, optional (default=”friedman_mse”)**

	- 衡量特征分裂质量的函数，这是一个与基学习器决策树相关的参数，字符串类型，可选项，默认是”friedman_mse”

- **min_samples_split : int, float, optional (default=2)**

    - 用于分裂一个内部结点的最小所需的样本数，整型或者浮点型，可选项，默认是2


- **min_samples_leaf : int, float, optional (default=1)**

    - 一个叶子结点所要求的最小样本个数，这个参数有平滑模型的作用，特别是回归的学习任务里面。整型或者浮点型，可选项，默认是1


- **min_weight_fraction_leaf : float, optional (default=0.)**

    - 一个叶子结点所有输入样本权重总和的最小权重分数，浮点型，可选项，默认为0.

- **max_depth : integer, optional (default=3)**

	- 单棵回归树的最大深度，需要进行调参来获得更好的性能

- **min_impurity_decrease : float, optional (default=0.)**

    - 最小不纯度减少值，结点将会继续分裂，如果这个分裂对于不纯度的减少能够大于或者等于该值。浮点型，可选项，默认为0.

- **min_impurity_split : float, (default=1e-7)**

    - 建树过程中早起停止的阈值。如果节点的不纯度大于该值将会继续分裂，否则停止，成为叶子结点。浮点型，默认为1e-7
    - 后续将会被`min_impurity_decrease`参数替代

- **init : estimator or ‘zero’, optional (default=None)**

    - 用来模型初始化的学习器对象，可以提供`fit`或者`predict`对象，如果是“zero”则初始预测为0

- **random_state : int, RandomState instance or None, optional (default=None)**

    - 随机状态，有以下三种方式
        - int, random_state is the seed used by the random number generator; 
        - RandomState instance, random_state is the random number generator; 
        - None, the random number generator is the RandomState instance used by np.random.

- **max_features : int, float, string or None, optional (default=”auto”)**

    - 寻找最优分裂时所考虑的特征个数，整型、浮点型、字符串或者None，可选项，默认是“auto”

        - int, then consider max_features features at each split.
        - float, then max_features is a fraction and int(max_features * n_features) features are considered at each split.
        - “auto”, then max_features=sqrt(n_features).
        - “sqrt”, then max_features=sqrt(n_features) (same as “auto”).
        - “log2”, then max_features=log2(n_features).
        - None, then max_features=n_features.

- **verbose : int, optional (default=0)**

    - 控制在学习和预测时是否输出中间结果，整型，可选项，默认是0

- **max_leaf_nodes : int or None, optional (default=None)**
    
    - 以最好的方式用`max_leaf_nodes`来建树，如果是Nonde的话则对叶子结点的个数不限制，整型或者Node，可选项，默认是Node

- **warm_start : bool, optional (default=False)**

    - 布尔型，可选项，默认为False，如果设置为True，将重复使用上一次调用的解来学习并加入更多的学习器到集成算法当中



- **presort : bool or ‘auto’, optional (default=’auto’)**

    - 在寻找最佳分裂时是否预排序。自动模式将对稠密数据进行预排序，对稀疏数据进行自然排序，对于稀疏数据采用预排序将会报错

- **validation_fraction : float, optional, default 0.1**

    - Early stopping时作为验证集的比例，只有在`n_iter_no_change`为整型时才起作用

- **n_iter_no_change : int, default None**

    - 在验证分数不再提高时用来决定是否采用early stopping来结束训练，整型，默认是None，不考虑early stopping

- **tol : float, optional, default 1e-4**

    - early stopping的容差（tolerance），在early stopping启用时，在经过`n_iter_no_change`步迭代的提升都没有超过`tol`时，则停止训练


#### 属性（attributes）

- **n_estimators_ : int**

    - 当early stopping启用时则是early stopping选定的学习器个数，否则等同于`n_estimators`


- **feature_importances_ : array, shape (n_features,)**

    - 特征重要性系数

- **oob_improvement_ : array, shape (n_estimators,)**

    - 包外样本相对于前一步迭代的损失提升，`oob_improvement_[0]`是第一步迭代相对于`init`学习器的损失提升

- **train_score_ : array, shape (n_estimators,)**

    - 第i个得分`train_score_[i]`是指模型第i步迭代时对包内样本的损失，如果`subsample == 1`，则是对所有训练集的损失

- **loss_ : LossFunction**

    - 损失函数对象

- **init_ : estimator**

    - 用于模型初始化的学习器对象


- **estimators_ : array of DecisionTreeRegressor, shape (n_estimators, 1)**

    - 拟合后的基学习器集合



#### 方法（methods）

 方法名称 | 方法解释 
:-: | :-:
apply(self, X)	|Apply trees in the ensemble to X, return leaf indices.
decision_function(self, X)|	Compute the decision function of X.
fit(self, X, y[, sample_weight, monitor])|	Fit the gradient boosting model.
get_params(self[, deep])|	Get parameters for this estimator.
predict(self, X)|	Predict class for X.
predict_log_proba(self, X)|	Predict class log-probabilities for X.
predict_proba(self, X)|	Predict class probabilities for X.
score(self, X, y[, sample_weight])|	Returns the mean accuracy on the given test data and labels.
set_params(self, \*\*params)|	Set the parameters of this estimator.
staged_decision_function(self, X)|	Compute decision function of X for each iteration.
staged_predict(self, X)|	Predict class at each stage for X.
staged_predict_proba(self, X)|	Predict class probabilities at each stage for X.

### GradientBoostingRegressor

#### 参数（parameters）

- **loss : {‘ls’, ‘lad’, ‘huber’, ‘quantile’}, optional (default=’ls’)**

	- 需要优化的损失函数


- **learning_rate : float, optional (default=0.1)**

	- 学习率（learning_rate），与`n_estimators`之间有个平衡

- **n_estimators : int (default=100)**

	- boosting迭代步数，Gradient boosting通常对于过拟合有鲁棒性，一个较大的数通常意味着更好的性能，整型，默认时100

- **subsample : float, optional (default=1.0)**

	- 用于训练基学习器的样本采样比例，小于1.0则等同于随机梯度提升（Stochasitc Gradient Boosting），与`n_estimators`相互作用，如果小于1则会减少方差，增加偏差

- **criterion : string, optional (default=”friedman_mse”)**

	- 衡量特征分裂质量的函数，这是一个与基学习器决策树相关的参数，字符串类型，可选项，默认是”friedman_mse”

- **min_samples_split : int, float, optional (default=2)**

    - 用于分裂一个内部结点的最小所需的样本数，整型或者浮点型，可选项，默认是2


- **min_samples_leaf : int, float, optional (default=1)**

    - 一个叶子结点所要求的最小样本个数，这个参数有平滑模型的作用，特别是回归的学习任务里面。整型或者浮点型，可选项，默认是1


- **min_weight_fraction_leaf : float, optional (default=0.)**

    - 一个叶子结点所有输入样本权重总和的最小权重分数，浮点型，可选项，默认为0.

- **max_depth : integer, optional (default=3)**

	- 单棵回归树的最大深度，需要进行调参来获得更好的性能

- **min_impurity_decrease : float, optional (default=0.)**

    - 最小不纯度减少值，结点将会继续分裂，如果这个分裂对于不纯度的减少能够大于或者等于该值。浮点型，可选项，默认为0.

- **min_impurity_split : float, (default=1e-7)**

    - 建树过程中早起停止的阈值。如果节点的不纯度大于该值将会继续分裂，否则停止，成为叶子结点。浮点型，默认为1e-7
    - 后续将会被`min_impurity_decrease`参数替代

- **init : estimator or ‘zero’, optional (default=None)**

    - 用来模型初始化的学习器对象，可以提供`fit`或者`predict`对象，如果是“zero”则初始预测为0

- **random_state : int, RandomState instance or None, optional (default=None)**

    - 随机状态，有以下三种方式
        - int, random_state is the seed used by the random number generator; 
        - RandomState instance, random_state is the random number generator; 
        - None, the random number generator is the RandomState instance used by np.random.

- **max_features : int, float, string or None, optional (default=”auto”)**

    - 寻找最优分裂时所考虑的特征个数，整型、浮点型、字符串或者None，可选项，默认是“auto”

        - int, then consider max_features features at each split.
        - float, then max_features is a fraction and int(max_features * n_features) features are considered at each split.
        - “auto”, then max_features=sqrt(n_features).
        - “sqrt”, then max_features=sqrt(n_features) (same as “auto”).
        - “log2”, then max_features=log2(n_features).
        - None, then max_features=n_features.

- **alpha : float (default=0.9)**

    - 当`loss='huber'`或者`loss='quantile'`时起作用，对应损失函数当中的参数

- **verbose : int, optional (default=0)**

    - 控制在学习和预测时是否输出中间结果，整型，可选项，默认是0

- **max_leaf_nodes : int or None, optional (default=None)**
    
    - 以最好的方式用`max_leaf_nodes`来建树，如果是Nonde的话则对叶子结点的个数不限制，整型或者Node，可选项，默认是Node

- **warm_start : bool, optional (default=False)**

    - 布尔型，可选项，默认为False，如果设置为True，将重复使用上一次调用的解来学习并加入更多的学习器到集成算法当中



- **presort : bool or ‘auto’, optional (default=’auto’)**

    - 在寻找最佳分裂时是否预排序。自动模式将对稠密数据进行预排序，对稀疏数据进行自然排序，对于稀疏数据采用预排序将会报错

- **validation_fraction : float, optional, default 0.1**

    - Early stopping时作为验证集的比例，只有在`n_iter_no_change`为整型时才起作用

- **n_iter_no_change : int, default None**

    - 在验证分数不再提高时用来决定是否采用early stopping来结束训练，整型，默认是None，不考虑early stopping

- **tol : float, optional, default 1e-4**

    - early stopping的容差（tolerance），在early stopping启用时，在经过`n_iter_no_change`步迭代的提升都没有超过`tol`时，则停止训练


#### 属性（attributes）


- **feature_importances_ : array, shape (n_features,)**

    - 特征重要性系数

- **oob_improvement_ : array, shape (n_estimators,)**

    - 包外样本相对于前一步迭代的损失提升，`oob_improvement_[0]`是第一步迭代相对于`init`学习器的损失提升

- **train_score_ : array, shape (n_estimators,)**

    - 第i个得分`train_score_[i]`是指模型第i步迭代时对包内样本的损失，如果`subsample == 1`，则是对所有训练集的损失

- **loss_ : LossFunction**

    - 损失函数对象

- **init_ : estimator**

    - 用于模型初始化的学习器对象


- **estimators_ : array of DecisionTreeRegressor, shape (n_estimators, 1)**

    - 拟合后的基学习器集合



#### 方法（methods）

 方法名称 | 方法解释 
:-: | :-:
apply(self, X)|	Apply trees in the ensemble to X, return leaf indices.
fit(self, X, y[, sample_weight, monitor])|	Fit the gradient boosting model.
get_params(self[, deep])	|Get parameters for this estimator.
predict(self, X)	|Predict regression target for X.
score(self, X, y[, sample_weight])|	Returns the coefficient of determination R^2 of the prediction.
set_params(self, \*\*params)	|Set the parameters of this estimator.
staged_predict(self, X)|	Predict regression target at each stage for X.



# 应用场景

GBDT应用场景广泛，几乎可用于所有回归问题（线性/非线性），相对logistic regression仅能用于线性回归，GBDT的适用面非常广。亦可用于二分类问题（设定阈值，大于阈值为正例，反之为负例）。

此外，GBDT能够起到特征组合和特征选择的作用，可以作为终端学习器的前置作为特征工程的工具之一，比如Facebook就利用GBDT的这一特性，在GBDT后面接一个LR模型构建CRT模型来预测广告点击率，具体参阅相关论文[Practical Lessons from Predicting Clicks on Ads at
Facebook](https://quinonero.net/Publications/predicting-clicks-facebook.pdf)。这也是GBDT在推荐系统场景的应用。

另外，在金融领域中的需求如欺诈检测、信用评级等，GBDT算法也能够发挥巨大的作用，有着大量基于GBDT算法的反欺诈模型、信用评分卡模型等。

# 参考

- [《机器学习》，周志华](https://book.douban.com/subject/26708119/)

- [《统计学习方法》（第二版），李航](https://book.douban.com/subject/33437381/)

- [Wiki Gradient Boosting](https://en.wikipedia.org/wiki/Gradient_boosting)


- [梯度提升树(GBDT)原理小结](https://www.cnblogs.com/pinard/p/6140514.html)

- [GBDT算法原理与系统设计简介](http://wepon.me/files/gbdt.pdf)


- [3.2.4.3.5. sklearn.ensemble.GradientBoostingClassifier](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.GradientBoostingClassifier.html#sklearn.ensemble.GradientBoostingClassifier)
- [3.2.4.3.6. sklearn.ensemble.GradientBoostingRegressor](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.GradientBoostingRegressor.html#sklearn.ensemble.GradientBoostingRegressor)

- [1.11. Ensemble methods](https://scikit-learn.org/stable/modules/ensemble.html#ensemble-methods)


- [Seeing the Forest for the Trees: An Introduction to Random Forest](https://community.alteryx.com/t5/Alteryx-Designer-Knowledge-Base/Seeing-the-Forest-for-the-Trees-An-Introduction-to-Random-Forest/ta-p/158062)
