---
title: 生产环境下的信用评分卡实践（R语言）
date: 2018-02-25 07:53:11
categories: 数据挖掘
tags:
- 信用评分卡
- 数据挖掘
- R
- 行为分析
- WOE
- IV
- 随机森林
description: [本文主要将作者2个月来用R进行数据挖掘构建信用评分卡的工作实践作一个记录，与网上目前可以搜到的各种教程有所不同的是将更加关注生产环境下的一些实际问题，比如取数据的一些坑、目标变量Y值定义的一些坑、以及数据清洗降温、维最后建模过程中的一些坑。当然，因为来源于生产环境，出于保密的原因，主要讲一些大的原则和对应的处理方法，不会事无巨细地给出每一个细节，也无法给出全部的代码。无论如何，希望对有缘看到的人能够有所帮助……]
---

入职将近两个月，在领导和同事的关心和帮助下，基本上顺利地完成了角色转变，平稳地度过了过度期：从一个火力发电厂热力系统设计工程师以及能源项目规划师以及海外电站项目开发经理华丽转身为互联网金融风控业务的数据挖掘工程师。

在这段时间当中，主要的工作内容就是根据公司目前积累的数据以及从第三方平台接入的数据构建用户信用评分卡，包括申请评分和行为评分，以下结合本人主要参与的行为评分卡建模，分享一些这段时间遇到的一些问题以及对应的解决方案。
# Mac系统下R的安装和配置

工欲善其事，必先利其器，首先要将**R**以及**RStudio**在**Mac**系统上面安装并配置好。

## R的安装

Mac系统下安装有很多种方法，可以使用[**HomeBrew**](https://brew.sh/index_zh-cn)进行安装。

**HomeBrew**是**Mac**系统下的一个包管理工具，类似**Debian**系统下的**apt-get**命令，不过通常不是默认安装的，需要用以下命令进行安装：

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```



然后安装**R**的命令如下：




```bash
brew install R
```


另外也可以直接去**R**的官方网站直接下载安装包进行安装，并且同步安装**GUI**工具，虽然比较鸡肋。针对**Mac**系统主要相关的下载及文档如下：

- **R**安装包：[R for Mac OS X](https://cran.r-project.org/bin/macosx/)
- **R for Mac-FAQ**： [R Mac OS X-FAQ](https://cran.r-project.org/bin/macosx/RMacOSX-FAQ.html)
- 画图所需要的**xquartz**软件包：[Xquartz](https://www.xquartz.org/)



## R的配置--替换BLAS库
参考[替换R自带的BLAS库来加速](http://xiaoweiz.github.io/posts/2014/Aug/R-blas/)的描述：

> 矩阵运算是科学计算（包括统计）中最重要的组成部分，而科学计算软件包（R/Matlab/Numpy/Julia等）的矩阵运算都是通过调用经过BLAS库（Basic Linear Algebra Subprograms）来实现的，所以一个好的BLAS库自然对于加速科学计算有着根本性的作用。现在公认最好的BLAS库是Intel公司的[MKL](https://software.intel.com/en-us/mkl)，收费很高；而开源世界中的[OpenBLAS](http://www.openblas.net/)基本能达到MKL的速度；另外就是OS X自带的Accelerate framework对于Mac用户来说简直就是一大福音，让我们不用再费脑筋去自己编译OpenBLAS。

为了提高**R**的运算速度，非常有必要将替换默认的**BLAS**库。

首先进入到R自带的BLAS库的所在文件夹


```bash
cd /Library/Frameworks/R.framework/Resources/lib
```
找到文件**libRblas.dylib**，它是一个**symlink**，默认指向同文件夹中的**libRblas.0.dylib**，这个就是**R**自带的**BLAS**库文件了。我们现在需要做的就是把这个**symlink**文件指向其他的**BLAS**库文件(**Accelerate framework**或者**OpenBLAS**)：


```bash
## 指向Accelerate framework
ln -sf /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/Versions/Current/libBLAS.dylib libRblas.dylib
## 指向OpenBLAS
### 添加homebrew科学库
brew tap homebrew/science
## 使用brew 安装openblas包
brew install openblas
cd /Library/Frameworks/R.framework/Resources/lib
## openblas具体安装路径会随着版本略有不同
ln -sf /usr/local/Cellar/openblas/0.2.20_1//lib/libopenblas.dylib libRblas.dylib

```

## R包的安装

**R**包的安装在**Mac**系统下面通常有三种方法：

- 最常规的方法就是在**R**的**console**窗口下面调用**install.packages()**命令，比如要安装**ggplot2**包则命令如下：

```r
> install.packages("ggplot2")
trying URL 'https://mirrors.ustc.edu.cn/CRAN/bin/macosx/el-capitan/contrib/3.4/ggplot2_2.2.1.tgz'
Content type 'application/octet-stream' length 2792414 bytes (2.7 MB)
==================================================
downloaded 2.7 MB


The downloaded binary packages are in
	/var/folders/t0/csmkjx2s3cn0dgsd2t4zmf_w0000gn/T//RtmpTVfycx/downloaded_packages
> 
```
**install.packages()**命令会默认从你设定好的**CRAN**镜像地址下载已经被收录的包，比如上面[The Comprehensive R Archive Network](https://mirrors.ustc.edu.cn/CRAN)就是我设定的镜像地址。


- 在实际的工作中，也许我们还会用到还没有被**CRAN**收入的包，比如来自**Github**的包，这就需要用到**devtools**包了，**devtools**包提供了从**CRAN**以外安装**R**的工作命令，以下以构建评分卡中关键的分箱步骤所需要用到的**WOE**包为例演示下**devtools**包的使用方法。

```r
#首先需要安装载入devtools包
> install.packages("devtools")
trying URL 'https://mirrors.ustc.edu.cn/CRAN/bin/macosx/el-capitan/contrib/3.4/devtools_1.13.5.tgz'
Content type 'application/octet-stream' length 439289 bytes (428 KB)
==================================================
downloaded 428 KB


The downloaded binary packages are in
	/var/folders/t0/csmkjx2s3cn0dgsd2t4zmf_w0000gn/T//RtmpTVfycx/downloaded_packages
> library(devtools)
> install_github(repo="riv",username="tomasgreif")  
Downloading GitHub repo tomasgreif/riv@master
from URL https://api.github.com/repos/tomasgreif/riv/zipball/master
Installing woe
'/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file --no-environ --no-save --no-restore  \
  --quiet CMD INSTALL  \
  '/private/var/folders/t0/csmkjx2s3cn0dgsd2t4zmf_w0000gn/T/RtmpTVfycx/devtoolsae3d6bf947d/tomasgreif-woe-43fcf26'  \
  --library='/Library/Frameworks/R.framework/Versions/3.4/Resources/library' --install-tests 

* installing *source* package ‘woe’ ...
** R
** data
*** moving datasets to lazyload DB
** demo
** preparing package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded
* DONE (woe)
Warning message:
Username parameter is deprecated. Please use tomasgreif/riv 
> library(woe)
> 
```

- 在**Mac**系统下面还有一种在命令行下面直接从源代码安装的方法，首先从**CRAN**下载打包后的源代码，比如你要安装**foo_0.1.tar.gz**包，可以用以下命令：

```bash
R CMD INSTALL foo_0.1.tar.gz
```

## RStudio的安装

**RStudio**作为一个**IDE**，极大地增加使用**R**的便利性，直接去官网下载免费版本即可，**RStudio**可以自动识别系统已经安装的**R**。

# 数据抽取

巧妇难为无米之炊，数据是源头。通常数据都保存在结构化数据库当中，并且以**MySQL**居多，这就要求有一定的**SQL**代码能力。会写简单的子查询并会跨表查询并合并。

行为评分当中最关键也是在我实践过程当中出现问题最多次的是对**Y**值的定义逻辑，以及如何把这个逻辑转化为**SQL**代码并将数据准确无误地取出来。正确地定义并获得**Y**也是后面数据清洗、转化、特征工程、建模等工作的基础，如果**Y**都定义不对，后面模型建的再漂亮都是徒劳的。

下面这张图主要是想说明行为评分当中用户行为数据的统计时间段。从行为评分的目的来看，我们是想根据用户以往的行为数据以及实际的逾期情况来预测用户未来的逾期概率，但是这里有一个问题，因为未来还没有到来，实际上我们无法将还未发生的事情来放到模型里面去进行训练，也就是说，在当前的时间点来看，在训练模型之前，我们无法知道用户是否会逾期，因此，我们在训练模型的时候只能使用已经发生并且确定的事情，这里有一个小技巧，通常将截止当前时间节点的最后一笔订单逾期情况作为训练模型的**Y**，然后用倒数第二笔订单之前的所有用户行为统计情况作为自变量，最后得到可以用来预测未来用户逾期情况的模型，示意图如下：

![行为评分Y值确定逻辑时间节点示意图](http://p1rl2jm2z.bkt.clouddn.com/for%20R%20practice%202018-03-03%2015-52-16.png) 

需要特别注意的是：在统计用户行为数据的时候的当前时间点是倒数第二笔订单的还款时间，不要牵扯到最后一笔订单相关的任何情况，*不要牵扯到最后一笔订单相关的任何情况*，**不要牵扯到最后一笔订单相关的任何情况**，重要的事情说三遍！否则会使你的某些因变量的**IV**值高得异常，模型也就失去意义。

逻辑上很好理解，因为对于最后一笔订单的任何情况，在倒数第二笔订单还款时间这个节点上都是未知的，如果在统计用户行为数据牵涉到了最后一笔订单的情况，势必会导致一种用已知去预测已知的情况，这种模型是无法使用的。

如果模型中待预测的最后一笔订单无逾期为**0**的话，通常会把逾期天数达到一定数目以上的定为**1**。而这个**逾期天数**可能因人而已，传统银行业通常将**90**天以上定位**1**。比如这里将逾期天数设为**20**天，为了减少模型的干扰，那些逾期了，但是逾期天数在**20**天以内的样本将会被剔除。

这里有个坑，就是在写**SQL**代码的时候在剔除逾期且逾期天数在**20**天以内的样本时要特别注意那些曾经逾期过且逾期天数在**20**天以内，但是最后一笔订单已还款的用户样本要保留。

# 数据清洗

数据清洗的主要目的是将从各个不同数据库中取得的数据进行整合处理，并对特征进行初步筛选，可分为以下主要步骤：

## 数据读入

这里强烈建议使用**tidyverse**包中的一些组件，假设因变量和自变量的数据文件名分别为`data.csv`和`default.csv`，则数据读入代码如下：

```r
#默认文件存储在项目根目录当中
data_df <- read_csv("data.csv", na = c("", "NA", "NULL", "未知"))
default_df <- read_csv("default.csv", na = c("", "NA", "NULL", "未知"))
#na = 这个参数可以自定义原数据当中需要在**R**中要以**NA**来表示的字符
#数据合并
df <- data_df %>% 
      inner_join(default_df, by = "id")
```
## 缺失值处理

缺失值处理一般两个原则，缺失值比例很高的变量直接剔除，缺失值比较低的进行插补，这里用**mice**包，并采用**cart**方法。不过在此之前需要识别缺失值。

```r
#识别缺失值
#统计所有变量的缺失值
temp <- sapply(df, function(x) sum(is.na(x)))

#按照缺失率排序
miss <- sort(temp, decreasing = T)

#查看含有缺失值的变量概括
miss[miss>0]
summary(df[,names(miss)[miss>0]])

#mice插补
用mice包插补缺失值，采用分类回归树算法 cart
imp <- mice(df,met="cart",m=1)
df_imp <- complete(imp)
```
## 分箱及降维

分箱是将连续的变量离散化，增加粒度，去除噪音，同时在评分卡模型当中用变量的**WOE**值来代替离散化后的各个经过分箱处理的原变量，这是一种传统而有效的方法。按照分箱标准的不同可有**等深分箱**，**等宽分箱**，**最优分箱**，**用户自定义区间**。前面已经安装并加载了**WOE**包，采用**最优分箱**算法，可以比较简便地进行**WOE**和**IV**的计算，不过这个包已经多年没有维护了，有一些**bug**，有兴趣的可以到下面的地址查看源码：


* [tomasgreif/woe](https://github.com/tomasgreif/woe)

另，**WOE**和**IV**的具体定义可以参考以下链接：


* [数据挖掘模型中的IV和WOE详解](http://blog.csdn.net/kevin7658/article/details/50780391)

在载入**WOE**包以后**IV**计算代码如下：

```r
#计算各变量IV值并排序（在调用iv.mult()函数之前必须将行名排序）
row.names(df_imp) <- 1:nrow(df_imp) 
#假设Y值的变量名为default
IV <- iv.mult(df_imp, "default", TRUE)
#剔除IV值在0.02以下的变量
IVcols <- filter(IV, IV$InformationValue>0.02)[1]
IVcols <- c("default", IVcols$Variable)
#将待训练样本降维
df_imp <- df_imp[,IVcols]
```
经过**IV**值的大小淘汰一部分对于因变量预测价值不大的变量，然后将降维后的数据进入随机森林进一步筛选变量，随机森林的代码如下：

```r
set.seed(4321)
crf <- cforest(default~.,control = cforest_unbiased(mtry = 20, ntree = 500), data = df_imp)
varimpt <- data.frame(varimp(crf))
c <- as.data.frame(varimpt)
```

* **mtry**是指定节点中用于二叉树的变量个数，默认情况下数据集变量个数的二次方根（分类模型）或三分之一（预测模型）。一般是需要进行人为的逐次挑选，确定最佳的**m**值；

* **ntree**是指定随机森林所包含的决策树数目，默认为500，通常在性能允许的情况下越大越好。

事实上，比较好的做法是先用随机森林，再用**IV**，因为后者的算法更具解释下，更加可控。但是考虑到随机森林的计算复杂性，一开始太多的维度并且样本已经**10**万以上，普通的**PC**机会有些吃不消。

# 逻辑回归建模
## 逻辑回归主要原理
### 逻辑回归

逻辑回归(logistic regression)在信用评分卡开发中起到核心作用。逻辑回归通过sigmoid函数 $y=1/(1+e^{-z})$ 将线性回归模型 $z=\boldsymbol{w}^T\boldsymbol{x}+b$ 产生的预测值转换为一个接近0或1的拟合值 $\widehat{y}$ ：
$$\begin{eqnarray} \widehat{y}&=&\frac{1}{1+e^{-z}} =&\frac{1}{1+e^{-(\boldsymbol{w}^T\boldsymbol{x}+b)}} \end{eqnarray}$$
上式的 $\widehat{y}$ 可视为事件发生的概率 $p(y=1|\boldsymbol{x})$ ，变换后得到： $$\ln\frac{p}{1-p}=z=\boldsymbol{w}^T\boldsymbol{x}+b$$ 其中， $p/(1-p)$ 为比率(odds)，即违约概率与正常概率的比值。 $\ln{p/(1-p)}$ 为logit函数，即比率的自然对数。因此，逻辑回归实际上是用比率的自然对数作为因变量的线性回归模型。

### 逻辑回归代价函数(cost function)
单个样本的损失函数(loss function): $$\ell(\widehat{y},y)=-(y\ln{\widehat{y}} + (1-y)\ln{(1-\widehat{y})})$$ 对于整个训练集的代价函数(cost function): $$\begin{eqnarray} J(\boldsymbol{w},b)&=&\frac{1}{m}\sum_i{\ell(\widehat{y}^{(i)},y^{(i)})} \&=&-\frac{1}{m}\sum_i{[y^{(i)}\ln{\widehat{y}^{(i)}}+(1-y^{(i)})\ln{(1-\widehat{y}^{(i)})}]} \end{eqnarray}$$ 其中, $\hat{y}$ 为拟合值, $y$ 为实际标签, $m$ 为样本数量

使用`梯度下降(gradient descent)`, 找到合适的参数 $(\boldsymbol{w}, b)$ , 使得 $J(\boldsymbol{w},b)$ 尽可能小。

### 正则化(regulation)
在使得代价函数最小时，尤其当样本特征很多时，容易陷入过拟合问题。为了改善过拟合，通常在代价函数中引入正则化项： $$\min{J(\boldsymbol{w},b)}+\frac{\lambda}{m}(\alpha||\boldsymbol{w}||_1+\frac{1}{2}(1-\alpha)||\boldsymbol{w}||_2^2)$$ 其中，正则化参数 $\lambda>0$ ; $||\boldsymbol{w}||_1=\sum_j{|w_j|}$ 与 $||\boldsymbol{w}||_2^2=\sum_j{w_j^2}=\boldsymbol{w}^T\boldsymbol{w}$ 分别为**L1**与**L2**范数正则化，也分别称为`LASSO(Least Absolute Shrinkage and Selection Operator)`与`岭回归(ridge regression)`。**L1**与**L2**范数正则化都有助于降低过拟合风险，但前者更易于获得稀疏解，即求得的 $\boldsymbol{w}$ 会有更少的非零分量。

### 基于AIC筛选变量
在R的逐步回归当中会采用基于AIC这个指标来进行筛选变量。

## 逻辑回归R实践

**R**的包非常丰富，建模本身还是相对简单的，但是通常不是一蹴而就的，需要不断地迭代、替换变量。需要从以下几个方面进行考虑：

* 变量的**WOE**值最好是单调的，递减要么递增，不宜有太大的波动性，另外用来解释因变量的逻辑应该符合常理，举个例子，在以往的行为当中逾期越多的人接下来的逾期概率应该是越大才对；
* 查看模型的**VIF**（方差膨胀因子，定义如下），两两之间存在多重共线性的变量仅保留一个，为了得到更好的效果，可以保留**IV**值较大的那个；

> 方差膨胀因子（Variance Inflation Factor，VIF）：是指解释变量之间存在多重共线性时的方差与不存在多重共线性时的方差之比。容忍度的倒数，VIF越大，显示共线性越严重。经验判断方法表明：当0<VIF<10，不存在多重共线性；当10≤VIF<100，存在较强的多重共线性；当VIF≥100，存在严重多重共线性。

* 然后是检验变量的**显著性指标**，就是*p*值；
* 最后将最终的变量控制在**15**个以内。

随机森林以后的变量可能还有**50～60**个，这时候可以直接放到罗辑回归当中建模，建模以后利用逐步回归进一步筛选变量。核心代码如下：

```r
#逻辑回归初步
lg.full <- glm(default ~.,family = binomial(link='logit'), data = train)
#查看模型
summary(lg.full)
#逐步回归
lg_both <- step(lg.full, direction = "both")
#查看逐步回归后模型
summary(lg_both)
#查看vif
vif(lg_both)
#将vif结果保留
write.csv(vif(lg_both), "vif.csv")

```
这里再分享一个技巧，可以构造一个字符型的数组用来存储最终进入模型的变量名，然后用这个数组变量来索引要进行训练的变量。这样有以下两个好处：

1. 首先是比较直观地能够知道哪些变量进入了模型，不管是你自己回过头来看还是与别人分享都能够一眼看出哪些变量，比起用数字来索引也不容易出错；
2. 另外一个是考虑到最后细筛变量是要看**VIF**和**WOE**结果的，需要将相关的结果输出保存到磁盘中，以字符型的数组作为自定义函数的参数也更加的方便。

举个例子，如果`df`为保存自变量和因变量数据的数据框，`featurecols`为保存自变量变量名的字符型数组，自定义函数代码如下：

```r
MyivPlot <- function(df,variableName){
  ivmatrix <- as.data.frame(iv.mult(df,"default",vars = variableName))
  ivmatrixname <- paste(variableName, "_woe.csv", sep = "")
  woeoutputpath <- str_c(projectPath, "output", "woe", ivmatrixname, sep = "/")
  print(woeoutputpath)
  #保存woe结果
  write_csv(ivmatrix, woeoutputpath)
  IVplot <- iv.plot.woe(iv.mult(df,"default",vars = variableName, summary=FALSE))
  plotname <- paste(variableName,".jpg",sep = "")
  IVplotoutputpath <- str_c(projectPath,"output","IVplot", plotname, sep="/")
  print(IVplotoutputpath)
  #保存woe图
  ggsave(filename = IVplotoutputpath, plot = IVplot)
  IVplot
}

```

则遍历整个数组，保存所有变量的**WOE**结果和图的代码如下：

```r
for (i in 2:length(reducecols)) {
  variableName <- str_sub(reducecols[i], 1, -5)
  MyivPlot(as.data.frame(df), variableName)
}

```

注意下，原来`reducecols`数组当中的变量是编码过后的带`_woe`后缀的，但是`iv.mult()`函数本身的`vars`参数要求的是原变量名，所以在这个过程当中需要借助**stringr**包中的一些函数，比如`str_sub()`以及`str_c()`等函数对变量名进行处理。

# 评分卡计算


- 评分卡的分值刻度通过将分值表示为比率对数的线性表达式: $$score = A - B\ln(odds)$$ 其中， **A**与**B**是常数, 坏好比率 $odds=p/(1-p)$ 为一个客户违约的估计概率与正常的估计概率的比率, $\ln(odds)$ 为逻辑回归的因变量，即 $\ln(odds)=\boldsymbol{w}^T\boldsymbol{x}+b$

- 常数**A**和**B**的值可以通过两个假设代入上式计算得到：

	- `基准坏好比率(odds0)`对应`基准分值(points0)`

		- $points0=A-B\ln(odds0)$
	- 坏好比率翻倍的分数`PDO(Points to Double the Odds)`

		- $points0-PDO=A-B\ln(2odds0)$
	- 解上述两方程，可以得到：

		- $B=PDO/\ln(2)$
		- $A=points0+B\ln(odds0)$
- 分值分配。将逻辑回归公式代入评分卡分值公式，可以得到 $$\begin{eqnarray} score &=& A-B\ln(odds) = A-B(\boldsymbol{w}^T\boldsymbol{x}+b) \ &=& (A-Bb) - Bw_1x_1 - Bw_2x_2 \cdots - Bw_mx_m \end{eqnarray}$$ 其中， $x_1\cdots x_m$ 为最终进入模型的自变量且已经转换为**WOE**值, $w_i$ 为逻辑回归的变量系数, $b$ 为逻辑回归的截距, $A, B$ 为上页求得的刻度因子。 $Bw_ix_i$ 为变量 $x_i$ 对应的评分， $(A-Bb)$ 为基础分(也可将基础分值平均分配给各个变量)。

- **R**中代码实现：


```r
#逻辑回归建模
fit <- glm(default~.,family=binomial(link='logit'),data=train)

#将变量参数赋给coe
coe = fit$coefficients

#A，B初始化及基础分计算
A = 500
B = 30/log(2)
base_score = A-B*coe[1]

#特定变量分值计算，假定变量名为Zhima，且为模型当中的第一个变量,此时取的是coe数组当中的第二个数值
Zhima_score <- (-1)*B*Zhima_woe*coe[2]
...
#总分计算,将所有变量的分值以及基础分累加
total_score <- base_score + Zhima_score + ...
```

# 用户分层
最后一步，按照一定信用分的区间来统计样本中的好坏用户的分布，然后根据分布的情况可以看出模型对好坏用户的区分度，以及根据业务情况设定理论要拒绝的坏用户比例，以及相应要拒绝的总用户数。

# 参考文献
- [使用R语言开发评分卡模型](https://github.com/ShichenXie/shichenxie.github.io/blob/master/slide/20171115scorecard/index.Rmd)

# 后记
回过头来看，这篇文章写了将近一个月，实在拖拉。

转眼转行已经三个多月，本人试用期也已经完成，顺利转正。

仅以这篇文章总结下这段时间的工作，后面的挑战还有更多，不断克服，且行且探索！