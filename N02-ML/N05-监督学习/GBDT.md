本文就对Boosting家族中另一个重要的算法梯度提升树(Gradient Boosting Decison Tree, 以下简称GBDT)做一个总结。 

GBDT有很多简称，有GBT（Gradient Boosting Tree）, GTB（Gradient Tree Boosting ）， GBRT（Gradient Boosting Regression Tree）, MART(Multiple Additive Regression Tree)，其实都是指的同一种算法，本文统一简称GBDT。 

GBDT在BAT大厂中也有广泛的应用，假如要选择3个最重要的机器学习算法的话，个人认为GBDT应该占一席之地。

# GBDT概述

GBDT也是集成学习Boosting家族的成员，但是却和传统的Adaboost有很大的不同。回顾下Adaboost，我们是利用前一轮迭代弱学习器的误差率来更新训练集的权重，这样一轮轮的迭代下去。GBDT也是迭代，使用了前向分布算法，但是**弱学习器限定了只能使用CART回归树模型，同时迭代思路和Adaboost也有所不同**。

在GBDT的迭代中，假设我们前一轮迭代得到的强学习器是$f_{t-1}(x)$, 损失函数是$L(y, f_{t-1}(x))$, 我们本轮迭代的目标是找到一个CART回归树模型的弱学习器$h_t(x)$，**让本轮的损失函数$L(y, f_{t}(x) =L(y, f_{t-1}(x)+ h_t(x))$最小。也就是说，本轮迭代找到决策树，要让样本的损失尽量变得更小。**

GBDT的思想可以用一个通俗的例子解释，假如有个人30岁，我们首先用20岁去拟合，发现损失有10岁，这时我们用6岁去拟合剩下的损失，发现差距还有4岁，第三轮我们用3岁拟合剩下的差距，差距就只有一岁了。如果我们的迭代轮数还没有完，可以继续迭代下面，每一轮迭代，拟合的岁数误差都会减小。

从上面的例子看这个思想还是蛮简单的，但是有个问题是这个损失的拟合不好度量，损失函数各种各样，怎么找到一种通用的拟合方法呢？



# GBDT的负梯度拟合

在上一节中，我们介绍了GBDT的基本思路，但是没有解决损失函数拟合方法的问题。针对这个问题，大牛Freidman提出了**用损失函数的负梯度来拟合本轮损失的近似值**，进而拟合一个CART回归树。第$t$轮的第$i$个样本的**损失函数的负梯度**表示为
$$
r_{ti} = -\bigg[\frac{\partial L(y_i, f(x_i))}{\partial f(x_i)}\bigg]_{f(x) = f_{t-1}\;\; (x)}
$$


 利用$(x_i,r_{ti})\;\; (i=1,2,..m)$, 我们可以拟合一颗CART回归树，得到了第$t$颗回归树，其对应的**叶节点区域**$R_{tj}, j =1,2,..., J$。其中$J$为叶子节点的个数。

针对每一个叶子节点里的样本，我们求出使损失函数最小，也就是拟合叶子节点最好的的输出值$c_{tj}$如下：
$$
c_{tj} = \underbrace{arg\; min}_{c}\sum\limits_{x_i \in R_{tj}} L(y_i,f_{t-1}(x_i) +c)
$$

 这样我们就得到了本轮的决策树**拟合函数**如下：
$$
h_t(x) = \sum\limits_{j=1}^{J}c_{tj}I(x \in R_{tj})
$$

 从而本轮最终得到的强学习器的表达式如下：
$$
f_{t}(x) = f_{t-1}(x) + \sum\limits_{j=1}^{J}c_{tj}I(x \in R_{tj})​
$$

通过损失函数的负梯度来拟合，我们找到了一种通用的拟合损失误差的办法，这样无轮是分类问题还是回归问题，我们通过其损失函数的负梯度的拟合，就可以用GBDT来解决我们的分类回归问题。区别仅仅在于损失函数不同导致的负梯度不同而已。

需要注意的是，**GBDT无论是用于分类和回归，采用的都是回归树**，分类问题最终是将拟合值转换为概率来进行分类的。



# GBDT回归算法

好了，有了上面的思路，下面我们总结下GBDT的回归算法。为什么没有加上分类算法一起？那是因为分类算法的输出是不连续的类别值，需要一些处理才能使用负梯度，我们在下一节讲。

- 输入是训练集样本$T=\{(x_,y_1),(x_2,y_2), ...(x_m,y_m)\}$， 最大迭代次数$T$, 损失函数$L$。
- 输出是强学习器$f(x)$

1. 初始化弱学习器
$$
f_0(x) = \underbrace{arg\; min}_{c}\sum\limits_{i=1}^{m}L(y_i, c)
$$

2. 对迭代轮数$t=1,2,...T$有：

**a)** 对样本$i=1,2，...m$，计算负梯度
$$
r_{ti} = -\bigg[\frac{\partial L(y_i, f(x_i)))}{\partial f(x_i)}\bigg]_{f(x) = f_{t-1}\;\; (x)}
$$

**b)** 利用$(x_i,r_{ti})\;\; (i=1,2,..m)$, 拟合一颗CART回归树,得到第$t$颗回归树，其对应的叶子节点区域为$R_{tj}, j =1,2,..., J$。其中$J$为回归树$t$的叶子节点的个数。

**c)** 对叶子区域$j =1,2,..J$,计算最佳拟合值
$$
c_{tj} = \underbrace{arg\; min}_{c}\sum\limits_{x_i \in R_{tj}} L(y_i,f_{t-1}(x_i) +c)
$$

**d)** 更新强学习器
$$
f_{t}(x) = f_{t-1}(x) + \sum\limits_{j=1}^{J}c_{tj}I(x \in R_{tj})
$$

3. 得到强学习器$f(x)$的表达式

$$
f(x) = f_T(x) =f_0(x) + \sum\limits_{t=1}^{T}\sum\limits_{j=1}^{J}c_{tj}I(x \in R_{tj})
$$



# GBDT分类算法

这里我们再看看GBDT分类算法，GBDT的分类算法从思想上和GBDT的回归算法没有区别，但是由于样本输出不是连续的值，而是离散的类别，导致我们无法直接从输出类别去拟合类别输出的误差。

为了解决这个问题，主要有两个方法，一个是用**指数损失函数**，此时GBDT退化为Adaboost算法。另一种方法是用类似于逻辑回归的**对数似然损失函数**的方法。也就是说，我们用的是**类别的预测概率值和真实概率值的差来拟合损失**。本文仅讨论用对数似然损失函数的GBDT分类。而对于对数似然损失函数，我们又有二元分类和多元分类的区别。



## 二元GBDT分类算法

对于二元GBDT，如果用类似于逻辑回归的对数似然损失函数，则损失函数为：
$$
L(y, f(x)) = log(1+ exp(-yf(x)))
$$

其中$y \in\{-1, +1\}$。则$f(x)=log[\frac{Pr(y=1|x)}{Pr(y=-1|x)}]$, $f(x)$是一个对数几率，当样本为正的概率大于样本为负的概率时，$f(x)$函数值大于0，否则小于0。此时的负梯度误差为
$$
r_{ti} = -\bigg[\frac{\partial L(y, f(x_i)))}{\partial f(x_i)}\bigg]_{f(x) = f_{t-1}\;\; (x)} = y_i/(1+exp(y_if(x_i)))
$$

对于生成的决策树，我们各个叶子节点的最佳负梯度拟合值为
$$
c_{tj} = \underbrace{arg\; min}_{c}\sum\limits_{x_i \in R_{tj}} log(1+exp(-y_i(f_{t-1}(x_i) +c)))
$$

由于上式比较难优化，我们一般使用近似值代替
$$
c_{tj} = \sum\limits_{x_i \in R_{tj}}r_{ti}\bigg /  \sum\limits_{x_i \in R_{tj}}|r_{ti}|(1-|r_{ti}|)
$$

除了负梯度计算和叶子节点的最佳负梯度拟合的线性搜索，二元GBDT分类和GBDT回归算法过程相同。



## 多元GBDT分类算法

多元GBDT要比二元GBDT复杂一些，对应的是多元逻辑回归和二元逻辑回归的复杂度差别。假设类别数为$K$，则此时我们的对数似然损失函数为：
$$
L(y, f(x)) = -  \sum\limits_{k=1}^{K}y_klog\;p_k(x)
$$

其中如果样本输出类别为$k$，则$y_k=1$。第$k$类的概率$p_k(x)$的表达式为：
$$
p_k(x) = exp(f_k(x)) \bigg / \sum\limits_{l=1}^{K} exp(f_l(x))
$$

集合上两式，我们可以计算出第$t$轮的第$i$个样本对应类别$l$的负梯度误差为
$$
r_{til} = -\bigg[\frac{\partial L(y_i, f(x_i)))}{\partial f(x_i)}\bigg]_{f_k(x) = f_{l, t-1}\;\; (x)} = y_{il} - p_{l, t-1}(x_i)
$$

观察上式可以看出，其实这里的误差就是样本$i$对应类别$l$的真实概率和$t−1$轮预测概率的差值。

对于生成的决策树，我们各个叶子节点的最佳负梯度拟合值为
$$
c_{tjl} = \underbrace{arg\; min}_{c_{jl}}\sum\limits_{i=0}^{m}\sum\limits_{k=1}^{K} L(y_k, f_{t-1, l}(x) + \sum\limits_{j=0}^{J}c_{jl} I(x_i \in R_{tj}))
$$

由于上式比较难优化，我们一般使用近似值代替
$$
c_{tjl} =  \frac{K-1}{K} \; \frac{\sum\limits_{x_i \in R_{tjl}}r_{til}}{\sum\limits_{x_i \in R_{til}}|r_{til}|(1-|r_{til}|)}
$$

除了负梯度计算和叶子节点的最佳负梯度拟合的线性搜索，多元GBDT分类和二元GBDT分类以及GBDT回归算法过程相同。



# GBDT常用损失函数

## 分类算法

这里我们再对常用的GBDT损失函数做一个总结。

对于分类算法，其损失函数一般有对数损失函数和指数损失函数两种:

a) 如果是指数损失函数，则损失函数表达式为
$$
L(y, f(x)) = exp(-yf(x))
$$

其负梯度计算和叶子节点的最佳负梯度拟合参见Adaboost原理篇。

b) 如果是对数损失函数，分为二元分类和多元分类两种，参见4.1节和4.2节。



## 回归算法

对于回归算法，常用损失函数有如下4种:

a) **均方差**，这个是最常见的回归损失函数了
$$
L(y, f(x)) =(y-f(x))^2
$$

b) **绝对损失**，这个损失函数也很常见
$$
L(y, f(x)) =|y-f(x)|
$$

对应负梯度误差为：
$$
sign(y_i-f(x_i))
$$

c) **Huber损失**，它是均方差和绝对损失的折衷产物，对于远离中心的异常点，采用绝对损失，而中心附近的点采用均方差。这个界限一般用分位数点度量。损失函数如下：
$$
L(y, f(x))= \begin{cases} \frac{1}{2}(y-f(x))^2& {|y-f(x)| \leq \delta}\\ \delta(|y-f(x)| - \frac{\delta}{2})& {|y-f(x)| > \delta} \end{cases}
$$

对应的负梯度误差为：
$$
r(y_i, f(x_i))= \begin{cases} y_i-f(x_i)& {|y_i-f(x_i)| \leq \delta}\\ \delta sign(y_i-f(x_i))& {|y_i-f(x_i)| > \delta} \end{cases}
$$

d) **分位数损失**。它对应的是分位数回归的损失函数，表达式为
$$
L(y, f(x)) =\sum\limits_{y \geq f(x)}\theta|y - f(x)| + \sum\limits_{y < f(x)}(1-\theta)|y - f(x)|
$$

其中$\theta$为分位数，需要我们在回归前指定。对应的负梯度误差为：
$$
r(y_i, f(x_i))= \begin{cases} \theta& { y_i \geq f(x_i)}\\ \theta - 1 & {y_i < f(x_i) } \end{cases}
$$

对于Huber损失和分位数损失，主要用于健壮回归，也就是减少异常点对损失函数的影响。



# GBDT的正则化

和Adaboost一样，我们也需要对GBDT进行正则化，防止过拟合。GBDT的正则化主要有三种方式。

第一种是和Adaboost类似的正则化项，即**步长(learning rate)**。定义为$\nu$,对于前面的弱学习器的迭代
$$
f_{k}(x) = f_{k-1}(x) + h_k(x)
$$

如果我们加上了正则化项，则有
$$
f_{k}(x) = f_{k-1}(x) + \nu h_k(x)
$$

$\nu$的取值范围为$0 < \nu \leq 1$。对于同样的训练集学习效果，较小的$\nu$意味着我们需要更多的弱学习器的迭代次数。通常我们用步长和迭代最大次数一起来决定算法的拟合效果。

第二种正则化的方式是通过**子采样比例（subsample）**。取值为(0,1]。注意这里的子采样和随机森林不一样，随机森林使用的是放回抽样，而这里是不放回抽样。如果取值为1，则全部样本都使用，等于没有使用子采样。如果取值小于1，则只有一部分样本会去做GBDT的决策树拟合。选择小于1的比例可以减少方差，即防止过拟合，但是会增加样本拟合的偏差，因此取值不能太低。推荐在[0.5, 0.8]之间。 

使用了子采样的GBDT有时也称作**随机梯度提升树**(Stochastic Gradient Boosting Tree, SGBT)。由于使用了子采样，程序可以通过采样分发到不同的任务去做boosting的迭代过程，最后形成新树，从而减少弱学习器难以并行学习的弱点。

第三种是对于弱学习器即CART回归树进行**正则化剪枝**。在决策树原理篇里我们已经讲过，这里就不重复了。



# GBDT小结

GBDT终于讲完了，GDBT本身并不复杂，不过要吃透的话需要对集成学习的原理，决策树原理和各种损失函树有一定的了解。由于GBDT的卓越性能，只要是研究机器学习都应该掌握这个算法，包括背后的原理和应用调参方法。目前GBDT的算法比较好的库是xgboost。当然scikit-learn也可以。

> GBDT的优点

1. 可以灵活处理各种类型的数据，包括连续值和离散值。
2. 在相对少的调参时间情况下，预测的准确率也可以比较高。这个是相对SVM来说的。
3. 使用一些健壮的损失函数，对异常值的鲁棒性非常强。比如 Huber损失函数和Quantile损失函数。



> GBDT的缺点

1. 由于弱学习器之间存在依赖关系，难以并行训练数据。不过可以通过自采样的SGBT来达到部分并行。



# scikit-learn 梯度提升树(GBDT)调参

## scikit-learn GBDT类库概述

在sacikit-learn中，GradientBoostingClassifier为GBDT的分类类， 而GradientBoostingRegressor为GBDT的回归类。两者的参数类型完全相同，当然有些参数比如损失函数loss的可选择项并不相同。这些参数中，类似于Adaboost，我们把重要参数分为两类，第一类是Boosting框架的重要参数，第二类是弱学习器即CART回归树的重要参数。

下面我们就从这两个方面来介绍这些参数的使用。



## GBDT类库boosting框架参数

首先，我们来看boosting框架相关的重要参数。由于GradientBoostingClassifier和GradientBoostingRegressor的参数绝大部分相同，我们下面会一起来讲，不同点会单独指出。

1. n_estimators: 也就是**弱学习器的最大迭代次数**，或者说最大的弱学习器的个数。一般来说n_estimators太小，容易欠拟合，n_estimators太大，又容易过拟合，一般选择一个适中的数值。默认是100。在实际调参的过程中，我们常常将n_estimators和下面介绍的参数learning_rate一起考虑。
2. learning_rate: 即**每个弱学习器的权重缩减系数ν，也称作步长**，在原理篇的正则化章节我们也讲到了，加上了正则化项，我们的强学习器的迭代公式为fk(x)=fk−1(x)+νhk(x)。ν的取值范围为0<ν≤1。对于同样的训练集拟合效果，较小的ν意味着我们需要更多的弱学习器的迭代次数。通常我们用步长和迭代最大次数一起来决定算法的拟合效果。所以这两个参数n_estimators和learning_rate要一起调参。一般来说，可以从一个小一点的ν开始调参，默认是1。
3. subsample: 即我们在原理篇的正则化章节讲到的**子采样**，取值为(0,1]。注意这里的子采样和随机森林不一样，随机森林使用的是放回抽样，而这里是不放回抽样。如果取值为1，则全部样本都使用，等于没有使用子采样。如果取值小于1，则只有一部分样本会去做GBDT的决策树拟合。选择小于1的比例可以减少方差，即防止过拟合，但是会增加样本拟合的偏差，因此取值不能太低。推荐在[0.5, 0.8]之间，默认是1.0，即不使用子采样。
4. init: 即我们的**初始化的时候的弱学习器**，拟合对应原理篇里面的f0(x)，如果不输入，则用训练集样本来做样本集的初始化分类回归预测。否则用init参数提供的学习器做初始化分类回归预测。一般用在我们对数据有先验知识，或者之前做过一些拟合的时候，如果没有的话就不用管这个参数了。
5. loss: 即我们GBDT算法中的**损失函数**。分类模型和回归模型的损失函数是不一样的。
    - 对于**分类模型**，有对数似然损失函数"deviance"和指数损失函数"exponential"两者输入选择。默认是对数似然损失函数"deviance"。在原理篇中对这些分类损失函数有详细的介绍。一般来说，推荐使用默认的"deviance"。它对二元分离和多元分类各自都有比较好的优化。而指数损失函数等于把我们带到了Adaboost算法。
    - 对于**回归模型**，有均方差"ls", 绝对损失"lad", Huber损失"huber"和分位数损失"quantile"。默认是均方差"ls"。一般来说，如果数据的噪音点不多，用默认的均方差"ls"比较好。如果是噪音点较多，则推荐用抗噪音的损失函数"huber"。而如果我们需要对训练集进行分段预测的时候，则采用"quantile”。
6. alpha：这个参数只有GradientBoostingRegressor有，当我们使用Huber损失"huber"和分位数损失"quantile"时，需要指定分位数的值。默认是0.9，如果噪音点较多，可以适当降低这个分位数的值。



## GBDT类库弱学习器参数

这里我们再对GBDT的类库弱学习器的重要参数做一个总结。由于GBDT使用了CART回归决策树，因此它的参数基本来源于决策树类，也就是说，和DecisionTreeClassifier和DecisionTreeRegressor的参数基本类似。如果你已经很熟悉决策树算法的调参，那么这一节基本可以跳过。不熟悉的朋友可以继续看下去。

1. 划分时考虑的最大特征数max_features: 可以使用很多种类型的值，默认是"None",意味着划分时考虑所有的特征数；如果是"log2"意味着划分时最多考虑log2N个特征；如果是"sqrt"或者"auto"意味着划分时最多考虑N−−√个特征。如果是整数，代表考虑的特征绝对数。如果是浮点数，代表考虑特征百分比，即考虑（百分比xN）取整后的特征数。其中N为样本总特征数。一般来说，如果样本特征数不多，比如小于50，我们用默认的"None"就可以了，如果特征数非常多，我们可以灵活使用刚才描述的其他取值来控制划分时考虑的最大特征数，以控制决策树的生成时间。
2. 决策树最大深度max_depth: 默认可以不输入，如果不输入的话，默认值是3。一般来说，数据少或者特征少的时候可以不管这个值。如果模型样本量多，特征也多的情况下，推荐限制这个最大深度，具体的取值取决于数据的分布。常用的可以取值10-100之间。
3. 内部节点再划分所需最小样本数min_samples_split: 这个值限制了子树继续划分的条件，如果某节点的样本数少于min_samples_split，则不会继续再尝试选择最优特征来进行划分。 默认是2.如果样本量不大，不需要管这个值。如果样本量数量级非常大，则推荐增大这个值。
4. 叶子节点最少样本数min_samples_leaf: 这个值限制了叶子节点最少的样本数，如果某叶子节点数目小于样本数，则会和兄弟节点一起被剪枝。 默认是1,可以输入最少的样本数的整数，或者最少样本数占样本总数的百分比。如果样本量不大，不需要管这个值。如果样本量数量级非常大，则推荐增大这个值。
5. 叶子节点最小的样本权重和min_weight_fraction_leaf：这个值限制了叶子节点所有样本权重和的最小值，如果小于这个值，则会和兄弟节点一起被剪枝。 默认是0，就是不考虑权重问题。一般来说，如果我们有较多样本有缺失值，或者分类树样本的分布类别偏差很大，就会引入样本权重，这时我们就要注意这个值了。
6. 最大叶子节点数max_leaf_nodes: 通过限制最大叶子节点数，可以防止过拟合，默认是"None”，即不限制最大的叶子节点数。如果加了限制，算法会建立在最大叶子节点数内最优的决策树。如果特征不多，可以不考虑这个值，但是如果特征分成多的话，可以加以限制，具体的值可以通过交叉验证得到。
7. 节点划分最小不纯度min_impurity_split:  这个值限制了决策树的增长，如果某节点的不纯度(基于基尼系数，均方差)小于这个阈值，则该节点不再生成子节点。即为叶子节点 。一般不推荐改动默认值1e-7。



## GBDT调参实例


```python
import pandas as pd
import numpy as np
from sklearn.ensemble import GradientBoostingClassifier
# from sklearn import cross_validation, metrics
from sklearn import metrics
from sklearn.model_selection import GridSearchCV

import matplotlib.pylab as plt
%matplotlib inline
```


```python
# 接着，我们把解压的数据用下面的代码载入，顺便看看数据的类别分布。
train = pd.read_csv('./train_modified.csv')
target='Disbursed' # Disbursed的值就是二元分类的输出
IDcol = 'ID'
train['Disbursed'].value_counts() 
```




    0    19680
    1      320
    Name: Disbursed, dtype: int64



可以看到类别输出如下，也就是类别0的占大多数。


```python
# 现在我们得到我们的训练集。最后一列Disbursed是分类输出。前面的所有列（不考虑ID列）都是样本特征
x_columns = [x for x in train.columns if x not in [target, IDcol]]
X = train[x_columns]
y = train['Disbursed']
```


```python
# 不管任何参数，都用默认的，我们拟合下数据看看：
gbm0 = GradientBoostingClassifier(random_state=10)
gbm0.fit(X,y)
y_pred = gbm0.predict(X)
y_predprob = gbm0.predict_proba(X)[:,1]
print("Accuracy : %.4g" % metrics.accuracy_score(y.values, y_pred))
print("AUC Score (Train): %f" % metrics.roc_auc_score(y, y_predprob))
```

    Accuracy : 0.9852
    AUC Score (Train): 0.900531


>我们下面看看怎么通过调参提高模型的泛化能力。

　首先我们从步长(learning rate)和迭代次数(n_estimators)入手。一般来说,开始选择一个较小的步长来网格搜索最好的迭代次数。这里，我们将步长初始值设置为0.1。对于迭代次数进行网格搜索如下：


```python
param_test1 = {'n_estimators': range(20, 81, 10)}
gsearch1 = GridSearchCV(
    estimator=GradientBoostingClassifier(
        learning_rate=0.1,
        min_samples_split=300,
        min_samples_leaf=20,
        max_depth=8,
        max_features='sqrt',
        subsample=0.8,
        random_state=10),
    param_grid=param_test1,
    scoring='roc_auc',
    iid=False,
    cv=5)
gsearch1.fit(X, y)
# gsearch1.grid_scores_, gsearch1.best_params_, gsearch1.best_score_
```




    GridSearchCV(cv=5, error_score='raise',
           estimator=GradientBoostingClassifier(criterion='friedman_mse', init=None,
                  learning_rate=0.1, loss='deviance', max_depth=8,
                  max_features='sqrt', max_leaf_nodes=None,
                  min_impurity_decrease=0.0, min_impurity_split=None,
                  min_samples_leaf=20, min_samples_split=300,
                  min_weight_fraction_leaf=0.0, n_estimators=100,
                  presort='auto', random_state=10, subsample=0.8, verbose=0,
                  warm_start=False),
           fit_params=None, iid=False, n_jobs=1,
           param_grid={'n_estimators': range(20, 81, 10)},
           pre_dispatch='2*n_jobs', refit=True, return_train_score=True,
           scoring='roc_auc', verbose=0)




```python
gsearch1.cv_results_['mean_test_score']
```




    array([0.81284735, 0.81437929, 0.81451108, 0.81618196, 0.81778932,
           0.81533362, 0.81321535])




```python
gsearch1.cv_results_['params']
```




    [{'n_estimators': 20},
     {'n_estimators': 30},
     {'n_estimators': 40},
     {'n_estimators': 50},
     {'n_estimators': 60},
     {'n_estimators': 70},
     {'n_estimators': 80}]




```python
gsearch1.best_params_
```




    {'n_estimators': 60}




```python
gsearch1.best_score_
```




    0.8177893165650406



找到了一个合适的迭代次数，现在我们开始对决策树进行调参。首先我们对决策树最大深度max_depth和内部节点再划分所需最小样本数min_samples_split进行网格搜索。


```python
param_test2 = {
    'max_depth': list(range(3, 14, 2)),
    'min_samples_split': list(range(100, 801, 200))
}
gsearch2 = GridSearchCV(
    estimator=GradientBoostingClassifier(
        learning_rate=0.1,
        n_estimators=60,
        min_samples_leaf=20,
        max_features='sqrt',
        subsample=0.8,
        random_state=10),
    param_grid=param_test2,
    scoring='roc_auc',
    iid=False,
    cv=5)
gsearch2.fit(X, y)
```




    GridSearchCV(cv=5, error_score='raise',
           estimator=GradientBoostingClassifier(criterion='friedman_mse', init=None,
                  learning_rate=0.1, loss='deviance', max_depth=3,
                  max_features='sqrt', max_leaf_nodes=None,
                  min_impurity_decrease=0.0, min_impurity_split=None,
                  min_samples_leaf=20, min_samples_split=2,
                  min_weight_fraction_leaf=0.0, n_estimators=60,
                  presort='auto', random_state=10, subsample=0.8, verbose=0,
                  warm_start=False),
           fit_params=None, iid=False, n_jobs=1,
           param_grid={'max_depth': [3, 5, 7, 9, 11, 13], 'min_samples_split': [100, 300, 500, 700]},
           pre_dispatch='2*n_jobs', refit=True, return_train_score=True,
           scoring='roc_auc', verbose=0)




```python
gsearch2.cv_results_['mean_test_score']
```




    array([0.81198869, 0.81267388, 0.81237654, 0.80924956, 0.81845981,
           0.81630145, 0.81314548, 0.81261631, 0.8180676 , 0.82137243,
           0.8170295 , 0.81383067, 0.81107287, 0.80944487, 0.81476158,
           0.81600927, 0.81100776, 0.81309427, 0.81712994, 0.81346505,
           0.81483581, 0.8082464 , 0.81923074, 0.81382074])




```python
gsearch2.cv_results_['params']
```




    [{'max_depth': 3, 'min_samples_split': 100},
     {'max_depth': 3, 'min_samples_split': 300},
     {'max_depth': 3, 'min_samples_split': 500},
     {'max_depth': 3, 'min_samples_split': 700},
     {'max_depth': 5, 'min_samples_split': 100},
     {'max_depth': 5, 'min_samples_split': 300},
     {'max_depth': 5, 'min_samples_split': 500},
     {'max_depth': 5, 'min_samples_split': 700},
     {'max_depth': 7, 'min_samples_split': 100},
     {'max_depth': 7, 'min_samples_split': 300},
     {'max_depth': 7, 'min_samples_split': 500},
     {'max_depth': 7, 'min_samples_split': 700},
     {'max_depth': 9, 'min_samples_split': 100},
     {'max_depth': 9, 'min_samples_split': 300},
     {'max_depth': 9, 'min_samples_split': 500},
     {'max_depth': 9, 'min_samples_split': 700},
     {'max_depth': 11, 'min_samples_split': 100},
     {'max_depth': 11, 'min_samples_split': 300},
     {'max_depth': 11, 'min_samples_split': 500},
     {'max_depth': 11, 'min_samples_split': 700},
     {'max_depth': 13, 'min_samples_split': 100},
     {'max_depth': 13, 'min_samples_split': 300},
     {'max_depth': 13, 'min_samples_split': 500},
     {'max_depth': 13, 'min_samples_split': 700}]




```python
gsearch2.best_params_
```




    {'max_depth': 7, 'min_samples_split': 300}




```python
gsearch2.best_score_
```




    0.8213724275914632



由于决策树深度7是一个比较合理的值，我们把它定下来，对于内部节点再划分所需最小样本数min_samples_split，我们暂时不能一起定下来，因为这个还和决策树其他的参数存在关联。下面我们再对内部节点再划分所需最小样本数min_samples_split和叶子节点最少样本数min_samples_leaf一起调参。


```python
param_test3 = {
    'min_samples_split': range(800, 1900, 200),
    'min_samples_leaf': range(60, 101, 10)
}
gsearch3 = GridSearchCV(
    estimator=GradientBoostingClassifier(
        learning_rate=0.1,
        n_estimators=60,
        max_depth=7,
        max_features='sqrt',
        subsample=0.8,
        random_state=10),
    param_grid=param_test3,
    scoring='roc_auc',
    iid=False,
    cv=5)
gsearch3.fit(X, y)
```




    GridSearchCV(cv=5, error_score='raise',
           estimator=GradientBoostingClassifier(criterion='friedman_mse', init=None,
                  learning_rate=0.1, loss='deviance', max_depth=7,
                  max_features='sqrt', max_leaf_nodes=None,
                  min_impurity_decrease=0.0, min_impurity_split=None,
                  min_samples_leaf=1, min_samples_split=2,
                  min_weight_fraction_leaf=0.0, n_estimators=60,
                  presort='auto', random_state=10, subsample=0.8, verbose=0,
                  warm_start=False),
           fit_params=None, iid=False, n_jobs=1,
           param_grid={'min_samples_split': range(800, 1900, 200), 'min_samples_leaf': range(60, 101, 10)},
           pre_dispatch='2*n_jobs', refit=True, return_train_score=True,
           scoring='roc_auc', verbose=0)




```python
gsearch3.cv_results_['mean_test_score']
```




    array([0.81827919, 0.81731255, 0.8222033 , 0.8144698 , 0.81495371,
           0.81528439, 0.81590487, 0.81572702, 0.82021405, 0.81512044,
           0.81395095, 0.81586914, 0.82063564, 0.81489972, 0.82009218,
           0.81850308, 0.81855231, 0.81665754, 0.81960231, 0.81560198,
           0.81936055, 0.81361749, 0.81429473, 0.81299027, 0.81999889,
           0.82209294, 0.81820535, 0.81921804, 0.81544596, 0.8170426 ])




```python
gsearch3.cv_results_['params']
```




    [{'min_samples_leaf': 60, 'min_samples_split': 800},
     {'min_samples_leaf': 60, 'min_samples_split': 1000},
     {'min_samples_leaf': 60, 'min_samples_split': 1200},
     {'min_samples_leaf': 60, 'min_samples_split': 1400},
     {'min_samples_leaf': 60, 'min_samples_split': 1600},
     {'min_samples_leaf': 60, 'min_samples_split': 1800},
     {'min_samples_leaf': 70, 'min_samples_split': 800},
     {'min_samples_leaf': 70, 'min_samples_split': 1000},
     {'min_samples_leaf': 70, 'min_samples_split': 1200},
     {'min_samples_leaf': 70, 'min_samples_split': 1400},
     {'min_samples_leaf': 70, 'min_samples_split': 1600},
     {'min_samples_leaf': 70, 'min_samples_split': 1800},
     {'min_samples_leaf': 80, 'min_samples_split': 800},
     {'min_samples_leaf': 80, 'min_samples_split': 1000},
     {'min_samples_leaf': 80, 'min_samples_split': 1200},
     {'min_samples_leaf': 80, 'min_samples_split': 1400},
     {'min_samples_leaf': 80, 'min_samples_split': 1600},
     {'min_samples_leaf': 80, 'min_samples_split': 1800},
     {'min_samples_leaf': 90, 'min_samples_split': 800},
     {'min_samples_leaf': 90, 'min_samples_split': 1000},
     {'min_samples_leaf': 90, 'min_samples_split': 1200},
     {'min_samples_leaf': 90, 'min_samples_split': 1400},
     {'min_samples_leaf': 90, 'min_samples_split': 1600},
     {'min_samples_leaf': 90, 'min_samples_split': 1800},
     {'min_samples_leaf': 100, 'min_samples_split': 800},
     {'min_samples_leaf': 100, 'min_samples_split': 1000},
     {'min_samples_leaf': 100, 'min_samples_split': 1200},
     {'min_samples_leaf': 100, 'min_samples_split': 1400},
     {'min_samples_leaf': 100, 'min_samples_split': 1600},
     {'min_samples_leaf': 100, 'min_samples_split': 1800}]




```python
gsearch3.best_params_
```




    {'min_samples_leaf': 60, 'min_samples_split': 1200}



可见这个min_samples_split在边界值，还有进一步调试小于边界60的必要。由于这里只是例子，所以大家可以自己下来用包含小于60的网格搜索来寻找合适的值。


```python
gsearch3.best_score_
```




    0.8222032996697154



调了这么多参数了，终于可以都放到GBDT类里面去看看效果了。现在我们用新参数拟合数据：


```python
gbm1 = GradientBoostingClassifier(
    learning_rate=0.1,
    n_estimators=60,
    max_depth=7,
    min_samples_leaf=60,
    min_samples_split=1200,
    max_features='sqrt',
    subsample=0.8,
    random_state=10)
gbm1.fit(X, y)
y_pred = gbm1.predict(X)
y_predprob = gbm1.predict_proba(X)[:, 1]
print("Accuracy : %.4f" % metrics.accuracy_score(y.values, y_pred))
print("AUC Score (Train): %f" % metrics.roc_auc_score(y, y_predprob))
```

    Accuracy : 0.9840
    AUC Score (Train): 0.908099


对比我们最开始完全不调参的拟合效果，可见精确度稍有下降，主要原理是我们使用了0.8的子采样，20%的数据没有参与拟合。

现在我们再对最大特征数max_features进行网格搜索。


```python
param_test4 = {'max_features': range(7, 20, 2)}
gsearch4 = GridSearchCV(
    estimator=GradientBoostingClassifier(
        learning_rate=0.1,
        n_estimators=60,
        max_depth=7,
        min_samples_leaf=60,
        min_samples_split=1200,
        subsample=0.8,
        random_state=10),
    param_grid=param_test4,
    scoring='roc_auc',
    iid=False,
    cv=5)
gsearch4.fit(X, y)
```




    GridSearchCV(cv=5, error_score='raise',
           estimator=GradientBoostingClassifier(criterion='friedman_mse', init=None,
                  learning_rate=0.1, loss='deviance', max_depth=7,
                  max_features=None, max_leaf_nodes=None,
                  min_impurity_decrease=0.0, min_impurity_split=None,
                  min_samples_leaf=60, min_samples_split=1200,
                  min_weight_fraction_leaf=0.0, n_estimators=60,
                  presort='auto', random_state=10, subsample=0.8, verbose=0,
                  warm_start=False),
           fit_params=None, iid=False, n_jobs=1,
           param_grid={'max_features': range(7, 20, 2)},
           pre_dispatch='2*n_jobs', refit=True, return_train_score=True,
           scoring='roc_auc', verbose=0)




```python
gsearch4.cv_results_['mean_test_score']
```




    array([0.8222033 , 0.82241251, 0.82108184, 0.82064239, 0.82198258,
           0.81354802, 0.81876866])




```python
gsearch4.cv_results_['params']
```




    [{'max_features': 7},
     {'max_features': 9},
     {'max_features': 11},
     {'max_features': 13},
     {'max_features': 15},
     {'max_features': 17},
     {'max_features': 19}]




```python
gsearch4.best_params_
```




    {'max_features': 9}




```python
gsearch4.best_score_
```




    0.822412506351626



现在我们再对子采样的比例进行网格搜索：


```python
param_test5 = {'subsample': [0.6, 0.7, 0.75, 0.8, 0.85, 0.9]}
gsearch5 = GridSearchCV(
    estimator=GradientBoostingClassifier(
        learning_rate=0.1,
        n_estimators=60,
        max_depth=7,
        min_samples_leaf=60,
        min_samples_split=1200,
        max_features=9,
        random_state=10),
    param_grid=param_test5,
    scoring='roc_auc',
    iid=False,
    cv=5)
gsearch5.fit(X, y)
```




    GridSearchCV(cv=5, error_score='raise',
           estimator=GradientBoostingClassifier(criterion='friedman_mse', init=None,
                  learning_rate=0.1, loss='deviance', max_depth=7,
                  max_features=9, max_leaf_nodes=None,
                  min_impurity_decrease=0.0, min_impurity_split=None,
                  min_samples_leaf=60, min_samples_split=1200,
                  min_weight_fraction_leaf=0.0, n_estimators=60,
                  presort='auto', random_state=10, subsample=1.0, verbose=0,
                  warm_start=False),
           fit_params=None, iid=False, n_jobs=1,
           param_grid={'subsample': [0.6, 0.7, 0.75, 0.8, 0.85, 0.9]},
           pre_dispatch='2*n_jobs', refit=True, return_train_score=True,
           scoring='roc_auc', verbose=0)




```python
gsearch5.cv_results_['mean_test_score']
```




    array([0.8182768 , 0.8234379 , 0.81673217, 0.82241251, 0.8228468 ,
           0.81738003])




```python
gsearch5.cv_results_['params']
```




    [{'subsample': 0.6},
     {'subsample': 0.7},
     {'subsample': 0.75},
     {'subsample': 0.8},
     {'subsample': 0.85},
     {'subsample': 0.9}]




```python
gsearch5.best_params_
```




    {'subsample': 0.7}




```python
gsearch5.best_score_
```




    0.8234378969766262



现在我们基本已经得到我们所有调优的参数结果了。这时我们可以减半步长，最大迭代次数加倍来增加我们模型的泛化能力。再次拟合我们的模型：


```python
gbm2 = GradientBoostingClassifier(
    learning_rate=0.05,
    n_estimators=120,
    max_depth=7,
    min_samples_leaf=60,
    min_samples_split=1200,
    max_features=9,
    subsample=0.7,
    random_state=10)
gbm2.fit(X, y)
y_pred = gbm2.predict(X)
y_predprob = gbm2.predict_proba(X)[:, 1]
print("Accuracy : %.4g" % metrics.accuracy_score(y.values, y_pred))
print("AUC Score (Train): %f" % metrics.roc_auc_score(y, y_predprob))
```

    Accuracy : 0.984
    AUC Score (Train): 0.905324


可以看到AUC分数比起之前的版本稍有下降，这个原因是我们为了增加模型泛化能力，为防止过拟合而减半步长，最大迭代次数加倍，同时减小了子采样的比例，从而减少了训练集的拟合程度。

下面我们继续将步长缩小5倍，最大迭代次数增加5倍，继续拟合我们的模型：


```python
gbm3 = GradientBoostingClassifier(
    learning_rate=0.01,
    n_estimators=600,
    max_depth=7,
    min_samples_leaf=60,
    min_samples_split=1200,
    max_features=9,
    subsample=0.7,
    random_state=10)
gbm3.fit(X, y)
y_pred = gbm3.predict(X)
y_predprob = gbm3.predict_proba(X)[:, 1]
print("Accuracy : %.4g" % metrics.accuracy_score(y.values, y_pred))
print("AUC Score (Train): %f" % metrics.roc_auc_score(y, y_predprob))
```

    Accuracy : 0.984
    AUC Score (Train): 0.908581


可见减小步长增加迭代次数可以在保证泛化能力的基础上增加一些拟合程度。

最后我们继续步长缩小一半，最大迭代次数增加2倍，拟合我们的模型：


```python
gbm4 = GradientBoostingClassifier(
    learning_rate=0.005,
    n_estimators=1200,
    max_depth=7,
    min_samples_leaf=60,
    min_samples_split=1200,
    max_features=9,
    subsample=0.7,
    random_state=10)
gbm4.fit(X, y)
y_pred = gbm4.predict(X)
y_predprob = gbm4.predict_proba(X)[:, 1]
print("Accuracy : %.4g" % metrics.accuracy_score(y.values, y_pred))
print("AUC Score (Train): %f" % metrics.roc_auc_score(y, y_predprob))
```

    Accuracy : 0.984
    AUC Score (Train): 0.908232


此时由于步长实在太小，导致拟合效果反而变差，也就是说，步长不能设置的过小。





# 试题

## 讲一下GBDT算法？





## GBDT为什么可以用负梯度代替残差，如何用平方损失函数做简单的说明