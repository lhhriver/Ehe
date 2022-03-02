<center><font color=steel size=14>word2vec</font></center>

# 简述

word2vec是google在2013年推出的一个NLP工具，它的特点是将所有的词向量化，这样词与词之间就可以定量的去度量他们之间的关系，挖掘词之间的联系。

传统的One hot representation用来表示词向量非常简单，但是却有很多问题。最大的问题是我们的词汇表一般都非常大，比如达到百万级别，这样每个词都用百万维的向量来表示简直是内存的灾难。这样的向量其实除了一个位置是1，其余的位置全部都是0，表达的效率不高。Distributed representation可以解决One hot representation的问题，它的思路是通过训练，将每个词都**映射到一个较短的词向量上**。

在word2vec出现之前，已经有用神经网络DNN来用训练词向量进而处理词与词之间的关系了。采用的方法一般是一个三层的神经网络结构（当然也可以多层），分为输入层，隐藏层和输出层(softmax层)。一般分为**CBOW**(Continuous Bag-of-Words) 与**Skip-Gram**两种模型。

- **CBOW模型**的训练输入是某一个特征词的上下文相关的词对应的词向量，而输出就是这特定的一个词的词向量。
- **Skip-Gram模型**和CBOW的思路是反着来的，即输入是特定的一个词的词向量，而输出是特定词对应的上下文词向量。

word2vec没有使用传统的DNN模型，最主要的问题是DNN模型的这个处理过程非常耗时。我们的词汇表一般在百万级别以上，这意味着我们DNN的输出层需要进行softmax计算各个词的输出概率的的计算量很大。

word2vec也使用了CBOW与Skip-Gram来训练模型与得到词向量，但是并没有使用传统的DNN模型。最先优化的是**使用霍夫曼树来代替隐藏层和输出层的神经元**。**霍夫曼树的叶子节点起到输出层神经元的作用，叶子节点的个数即为词汇表的小大。 而内部节点则起到隐藏层神经元的作用。**

一般得到霍夫曼树后我们会对叶子节点进行**霍夫曼编码**，由于权重高的叶子节点越靠近根节点，而权重低的叶子节点会远离根节点，这样我们的**高权重节点编码值较短，而低权重值编码值较长**。这保证的树的带权路径最短，也符合我们的信息论，即我们希望越常用的词拥有更短的编码。

一般对于一个霍夫曼树的节点（根节点除外），可以约定左子树编码为0，右子树编码为1。在word2vec中，**约定编码方式和上面的例子相反**，即约定左子树编码为1，右子树编码为0，同时约定左子树的权重不小于右子树的权重。

使用霍夫曼树来代替传统的神经网络，可以提高模型训练的效率。但是如果我们的训练样本里的中心词$w$是一个**很生僻的词**，那么就得在霍夫曼树中辛苦的向下走很久了。**Negative Sampling**就是这么一种求解word2vec模型的方法，它摒弃了霍夫曼树，采用了**Negative Sampling（负采样）**的方法来求解。

 **通过Negative Sampling采样，我们得到$neg$个和$w$不同的中心词$w_i,i=1,2,..neg$，这样context($w$)和$w_i$就组成了$neg$个并不真实存在的负例**。



# 词向量基础

## one hot representation

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N02-Word2vec-20201214-201036-299732.png)

最早的词向量是很冗长的，它使用是词向量维度大小为整个词汇表的大小，对于每个具体的词汇表中的词，将对应的位置置为1。

比如我们有下面的5个词组成的词汇表，词"Queen"的序号为2， 那么它的词向量就是(0,1,0,0,0)。

这种词向量的编码方式我们一般叫做**1-of-N representation**或者**one hot representation**。

One hot representation用来表示词向量非常简单，但是却有很多问题。最大的问题是我们的词汇表一般都非常大，比如达到百万级别，这样每个词都用百万维的向量来表示简直是内存的灾难。这样的向量其实除了一个位置是1，其余的位置全部都是0，表达的效率不高，能不能把词向量的维度变小呢？



## Distributed representation

Distributed representation可以解决One hot representation的问题，它的思路是通过训练，将每个词都**映射到一个较短的词向量上**。所有的这些词向量就构成了向量空间，进而可以用普通的统计学的方法来研究词与词之间的关系。这个较短的词向量维度是多大呢？这个一般需要我们在训练时自己来指定。

比如下图我们将词汇表里的词用"Royalty", "Masculinity",  "Femininity"和"Age"4个维度来表示，King这个词对应的词向量可能是(0.99, 0.99, 0.05, 0.7)。

当然在实际情况中，我们并不能对词向量的每个维度做一个很好的解释。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N02-Word2vec-20201214-201036-317413.png)

有了用Distributed Representation表示的较短的词向量，我们就可以较容易的分析词之间的关系了，比如我们将词的维度降维到2维，有一个有趣的研究表明，用下图的词向量表示我们的词时，我们可以发现：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N02-Word2vec-20201214-201036-330303.png)
$$
\begin{align}
\vec {King} - \vec {Man} + \vec {Woman} = \vec {Queen}
\end{align}
$$
可见我们只要得到了词汇表里所有词对应的词向量，那么我们就可以做很多有趣的事情了。不过，怎么训练得到合适的词向量呢？一个很常见的方法是使用神经网络语言模型。



# CBOW与Skip-Gram用于神经网络语言模型

在word2vec出现之前，已经有用神经网络DNN来用训练词向量进而处理词与词之间的关系了。采用的方法一般是一个三层的神经网络结构（当然也可以多层），分为输入层，隐藏层和输出层(softmax层)。

这个模型是如何定义数据的输入和输出呢？一般分为**CBOW**(Continuous Bag-of-Words) 与**Skip-Gram**两种模型。



## CBOW

CBOW模型的训练输入是某一个特征词的上下文相关的词对应的词向量，而输出就是这特定的一个词的词向量。

比如下面这段话，我们的上下文大小取值为4，特定的这个词是"Learning"，也就是我们需要的输出词向量,上下文对应的词有8个，前后各4个，这8个词是我们模型的输入。由于CBOW使用的是**词袋模型**，因此这8个词都是平等的，也就是**不考虑他们和我们关注的词之间的距离大小，只要在我们上下文之内即可**。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N02-Word2vec-20201214-201036-346334.png)

这样我们这个CBOW的例子里，我们的输入是8个词向量，**输出是所有词的softmax概率**（训练的目标是期望训练样本特定词对应的softmax概率最大）　

对应的CBOW神经网络模型输入层有8个神经元，**输出层有词汇表大小个神经元**。

隐藏层的神经元个数我们可以自己指定。**通过DNN的反向传播算法，我们可以求出DNN模型的参数，同时得到所有的词对应的词向量。**

这样当我们有新的需求，要求出某8个词对应的最可能的输出中心词时，我们可以通过一次DNN前向传播算法并通过softmax激活函数找到概率最大的词对应的神经元即可。



## Skip-Gram

Skip-Gram模型和CBOW的思路是反着来的，即输入是特定的一个词的词向量，而输出是特定词对应的上下文词向量。还是上面的例子，我们的上下文大小取值为4， 特定的这个词"Learning"是我们的输入，而这8个上下文词是我们的输出。

**输入是特定词， 输出是softmax概率排前8的8个词，对应的Skip-Gram神经网络模型输入层有1个神经元，输出层有词汇表大小个神经元。**

隐藏层的神经元个数我们可以自己指定。**通过DNN的反向传播算法，我们可以求出DNN模型的参数，同时得到所有的词对应的词向量。**

这样当我们有新的需求，要求出某1个词对应的最可能的8个上下文词时，我们可以通过一次DNN前向传播算法得到概率大小排前8的softmax概率对应的神经元所对应的词即可。

---

以上就是神经网络语言模型中如何用CBOW与Skip-Gram来训练模型与得到词向量的大概过程。但是这和word2vec中用CBOW与Skip-Gram来训练模型与得到词向量的过程有很多的不同。

word2vec为什么不用现成的DNN模型，要继续优化出新方法呢？最主要的问题是DNN模型的这个处理过程**非常耗时**。我们的词汇表一般在百万级别以上，这意味着我们DNN的输出层需要进行softmax计算各个词的输出概率的的计算量很大。有没有简化一点点的方法呢？



# word2vec基础之霍夫曼树

word2vec也使用了CBOW与Skip-Gram来训练模型与得到词向量，但是并没有使用传统的DNN模型。最先优化的是**使用霍夫曼树来代替隐藏层和输出层的神经元**。

**霍夫曼树的叶子节点起到输出层神经元的作用，叶子节点的个数即为词汇表的小大。 而内部节点则起到隐藏层神经元的作用。**

## 霍夫曼树的建立过程

霍夫曼树的建立其实并不难，过程如下：

**输入**：权值为$(w_1,w_2,...w_n)$的n个节点

**输出**：对应的霍夫曼树

1. 将$(w_1,w_2,...w_n)$看做是有$n$棵树的森林，每个树仅有一个节点。

2. 在森林中选择根节点权值最小的两棵树进行合并，得到一个新的树，这两颗树分布作为新树的左右子树。新树的根节点权重为左右子树的根节点权重之和。

3. 将之前的根节点权值最小的两棵树从森林删除，并把新树加入森林。

4. 重复步骤2和3直到森林里只有一棵树为止。



下面我们用一个具体的例子来说明霍夫曼树建立的过程，我们有(a,b,c,d,e,f)共6个节点，节点的权值分布是(20, 4, 8, 6, 16, 3)。首先是最小的b和f合并，得到的新树根节点权重是7。此时森林里5棵树，根节点权重分别是20,8,6,16,7。此时根节点权重最小的6,7合并，得到新子树，依次类推，最终得到下面的霍夫曼树。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N02-Word2vec-20201214-201036-362110.png)

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N02-Word2vec-20201214-201036-368127.png)

## 霍夫曼树有什么好处

一般得到霍夫曼树后我们会对叶子节点进行霍夫曼编码，由于权重高的叶子节点越靠近根节点，而权重低的叶子节点会远离根节点，这样我们的**高权重节点编码值较短，而低权重值编码值较长**。这保证的树的带权路径最短，也符合我们的信息论，即我们希望越常用的词拥有更短的编码。

如何编码呢？一般对于一个霍夫曼树的节点（根节点除外），可以约定左子树编码为0，右子树编码为1.

在word2vec中，**约定编码方式和上面的例子相反**，即约定左子树编码为1，右子树编码为0，同时约定左子树的权重不小于右子树的权重。

---

现在我们开始关注word2vec的语言模型如何改进传统的神经网络的方法。由于word2vec有两种改进方法，一种是基于**Hierarchical Softmax**的，另一种是基于**Negative Sampling**的。



# Hierarchical Softmax的模型

## 传统的神经网络模型

我们先回顾下传统的神经网络词向量语言模型，里面一般有三层，输入层（词向量），隐藏层和输出层（softmax层）。里面最大的问题在于从隐藏层到输出的softmax层的计算量很大，因为要计算所有词的softmax概率，再去找概率最大的值。

这个模型如下图所示,其中$V$是词汇表的大小。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N02-Word2vec-20201214-201036-386659.png)



## Hierarchical Softmax改进点

1. 改进一

word2vec对这个模型做了改进，首先，对于从输入层到隐藏层的映射，没有采取神经网络的线性变换加激活函数的方法，而是采用简单的对所有输入词向量**求和并取平均**的方法。

比如输入的是三个4维词向量：(1,2,3,4), (9,6,11,8), (5,10,7,12),那么我们word2vec映射后的词向量就是(5,6,7,8)。由于这里是从多个词向量变成了一个词向量。

2. 改进二

第二个改进就是从隐藏层到输出的softmax层这里的计算量个改进。为了避免计算所有词的softmax概率，word2vec采样了**霍夫曼树来代替从隐藏层到输出softmax层的映射。**如何映射呢？这里就是理解word2vec的关键所在了。



## Hierarchical Softmax

由于我们把之前所有都要计算的从输出softmax层的概率计算变成了一颗二叉霍夫曼树，那么我们的softmax概率计算只需要沿着树形结构进行就可以了。如下图所示，我们可以沿着霍夫曼树从根节点一直走到我们的叶子节点的词$w_2$。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N02-Word2vec-20201214-201036-389774.png)

和之前的神经网络语言模型相比，我们的霍夫曼树的所有**内部节点就类似之前神经网络隐藏层的神经元**。其中，**根节点的词向量对应我们的投影后的词向量**。而所有**叶子节点就类似于之前神经网络softmax输出层的神经元**，叶子节点的个数就是词汇表的大小。在霍夫曼树中，隐藏层到输出层的softmax映射不是一下子完成的，而是沿着霍夫曼树一步步完成的，因此这种softmax取名为`Hierarchical Softmax`。



## 如何沿着霍夫曼树一步步完成?

在word2vec中，我们采用了**二元逻辑回归**的方法。即规定沿着左子树走，那么就是负类(霍夫曼树编码1)，沿着右子树走，那么就是正类(霍夫曼树编码0)。  

判别正类和负类的方法是使用sigmoid函数，即：
$$
P(+) = \sigma(x_w^T\theta) = \frac{1}{1+e^{-x_w^T\theta}}
$$
其中$x_w$是当前内部节点的词向量，而$\theta$则是我们需要从训练样本求出的逻辑回归的模型参数。



## 使用霍夫曼树有什么好处呢

1. 首先，由于是二叉树，之前计算量为$V$,现在变成了$log_2V$。
2. 第二，由于使用霍夫曼树是高频的词靠近树根，这样高频词需要更少的时间会被找到，这符合我们的**贪心优化**思想。
3. 容易理解，被划分为左子树而成为负类的概率为$P(−)=1−P(+)$。
4. 在某一个内部节点，要判断是沿左子树还是右子树走的标准就是看$P(−)$,$P(+)$谁的概率值大。
5. 而控制$P(−)$,$P(+)$谁的概率值大的因素一个是当前节点的词向量，另一个是当前节点的模型参数$\theta$。

对于上图中的$w_2$，如果它是一个训练样本的输出，那么我们期望对于里面的隐藏节点$n(w_2,1)$的$P(−)$概率大，$n(w_2,2)$的$P(−)$概率大，$n(w2,3)$的$P(+)$概率大。

回到基于Hierarchical Softmax的word2vec本身，我们的**目标就是找到合适的所有节点的词向量和所有内部节点$\theta$, 使训练样本达到最大似然**。那么如何达到最大似然呢？



# 基于Hierarchical Softmax的模型

## 基于Hierarchical Softmax的模型梯度计算

我们使用最大似然法来寻找所有节点的词向量和所有内部节点$\theta$。先拿上面的$w_2$例子来看，我们期望最大化下面的似然函数：
$$
\prod_{i=1}^3P(n(w_i),i) = (1- \frac{1}{1+e^{-x_w^T\theta_1}})(1- \frac{1}{1+e^{-x_w^T\theta_2}})\frac{1}{1+e^{-x_w^T\theta_3}}
$$
对于所有的训练样本，我们期望最大化所有样本的似然函数乘积。

---



1. 为了便于我们后面一般化的描述，我们定义输入的词为$w$, 其从输入层词向量求和平均后的霍夫曼树根节点词向量为$x_w$。

2. 从根节点到$w$所在的叶子节点，包含的节点总数为$l_w$。

3. $w$在霍夫曼树中从根节点开始，经过的第$i$个节点表示为$p^w_i$,对应的霍夫曼编码为$d^w_i∈{0,1}$,其中$i=2,3,...l_w$。而该节点对应的模型参数表示为$\theta^w_i$, 其中$i=1,2,...l_w−1$，没有$i=l_w$是因为模型参数仅仅针对于霍夫曼树的内部节点。

4. 定义$w$经过的霍夫曼树某一个节点 $j$ 的逻辑回归概率为$P(d_j^w|x_w, \theta_{j-1}^w)$，其表达式为：
    $$
    P(d_j^w|x_w, \theta_{j-1}^w)= \begin{cases}  \sigma(x_w^T\theta_{j-1}^w)& {d_j^w=0}\\ 1-  \sigma(x_w^T\theta_{j-1}^w) & {d_j^w = 1} \end{cases}
    $$

5. 那么对于某一个目标输出词$w$, 其**最大似然**为：
    $$
    \prod_{j=2}^{l_w}P(d_j^w|x_w, \theta_{j-1}^w) = \prod_{j=2}^{l_w} [\sigma(x_w^T\theta_{j-1}^w)] ^{1-d_j^w}[1-\sigma(x_w^T\theta_{j-1}^w)]^{d_j^w}
    $$

6. 在word2vec中，由于使用的是随机梯度上升法，所以并没有把所有样本的似然乘起来得到真正的训练集最大似然，仅仅**每次只用一个样本更新梯度**，这样做的目的是减少梯度计算量。这样我们可以得到w的对数似然函数L如下：

$$
\begin{align} \frac{\partial L}{\partial \theta_{j-1}^w} & = (1-d_j^w)\frac{(\sigma(x_w^T\theta_{j-1}^w)(1-\sigma(x_w^T\theta_{j-1}^w)}{\sigma(x_w^T\theta_{j-1}^w)}x_w - d_j^w \frac{(\sigma(x_w^T\theta_{j-1}^w)(1-\sigma(x_w^T\theta_{j-1}^w)}{1- \sigma(x_w^T\theta_{j-1}^w)}x_w  \\ & =  (1-d_j^w)(1-\sigma(x_w^T\theta_{j-1}^w))x_w -  d_j^w\sigma(x_w^T\theta_{j-1}^w)x_w \\& = (1-d_j^w-\sigma(x_w^T\theta_{j-1}^w))x_w \end{align}
$$

7. 同样的方法，可以求出$x_w$的梯度表达式如下：
    $$
    \frac{\partial L}{\partial x_w} = \sum\limits_{j=2}^{l_w}(1-d_j^w-\sigma(x_w^T\theta_{j-1}^w))\theta_{j-1}^w
    $$

8. 有了梯度表达式，我们就可以用梯度上升法进行迭代来一步步的求解我们需要的所有的$\theta_{j-1}^w$和$x_w$。



***

## 基于Hierarchical Softmax的CBOW模型

首先我们要定义词向量的维度大小$M$，以及CBOW的上下文大小$2c$,这样我们对于训练样本中的每一个词，其前面的$c$个词和后面的$c$个词作为了CBOW模型的输入,该词本身作为样本的输出，期望softmax概率最大。

在做CBOW模型前，我们需要先将词汇表建立成一颗霍夫曼树。

对于从输入层到隐藏层（投影层），这一步比较简单，就是对$w$周围的$2c$个词向量**求和取平均**即可，即：
$$
x_w = \frac{1}{2c}\sum\limits_{i=1}^{2c}x_i
$$
第二步，通过梯度上升法来更新我们的$\theta^w_{j−1}$和$x_w$，注意这里的$x_w$是由$2c$个词向量相加而成，我们做梯度更新完毕后会用梯度项直接更新原始的各个$x_i(i=1,2,,,,2c)$，即：
$$
\theta_{j-1}^w = \theta_{j-1}^w + \eta  (1-d_j^w-\sigma(x_w^T\theta_{j-1}^w))x_w
$$

$$
x_w= x_w +\eta  \sum\limits_{j=2}^{l_w}(1-d_j^w-\sigma(x_w^T\theta_{j-1}^w))\theta_{j-1}^w \;(i =1,2..,2c)
$$

其中$\eta$为梯度上升法的步长。



## 基于Hierarchical Softmax的CBOW模型算法流程

**输入**：基于CBOW的语料训练样本，词向量的维度大小$M$，CBOW的上下文大小$2c$,步长$\eta$ 。

**输出**：霍夫曼树的内部节点模型参数$\theta$，所有的词向量$w$ 。

1. 基于语料训练样本建立霍夫曼树。

2. 随机初始化所有的模型参数$\theta$，所有的词向量$w$

3. 进行梯度上升迭代过程，对于训练集中的每一个样本(context($w$),$w$)做如下处理：

    a)  $e=0$， 计算$$x_w= \frac{1}{2c}\sum\limits_{i=1}^{2c}x_i$$
    b)  $for \ j = 2 \ to \ l_w$, 计算：
    $$
    \begin{align}&f = \sigma(x_w^T\theta_{j-1}^w)\\&
    g = (1-d_j^w-f)\eta\\&
    e = e + g\theta_{j-1}^w\\&
    \theta_{j-1}^w= \theta_{j-1}^w + gx_w\end{align}
    $$

    c) 对于context($w$)中的每一个词向量$x_i$(共$2c$个)进行更新：$x_i = x_i + e$

    d) 如果梯度收敛，则结束梯度迭代，否则回到步骤3继续迭代。
    


## 基于Hierarchical Softmax的Skip-Gram模型

现在我们先看看基于Skip-Gram模型时， Hierarchical Softmax如何使用。此时输入的只有一个词$w$,输出的为$2c$个词向量context($w$)。

我们对于训练样本中的每一个词，该词本身作为样本的输入， 其前面的$c$个词和后面的$c$个词作为了Skip-Gram模型的输出,，期望这些词的softmax概率比其他的词大。

Skip-Gram模型和CBOW模型其实是反过来的，在做CBOW模型前，我们需要先将词汇表建立成一颗霍夫曼树。对于从输入层到隐藏层（投影层），这一步比CBOW简单，由于只有一个词，所以，即$x_w$就是词$w$对应的词向量。

第二步，通过梯度上升法来更新我们的$w_{j−1}$和$x_w$，注意这里的$x_w$周围有$2c$个词向量，此时如果我们期望$P(x_i|x_w),i=1,2...2c$最大。此时我们注意到由于**上下文是相互**的，在期望$P(x_i|x_w),i=1,2...2c$最大化的同时，反过来我们也期望$P(x_w|x_i),i=1,2...2c$最大。  

那么是使用$P(x_i|x_w)$好还是$P(x_w|x_i)$好呢，word2vec使用了后者，这样做的好处就是在一个迭代窗口内，我们不是只更新$x_w$一个词，而是$x_i,i=1,2...2c$共$2c$个词。这样整体的迭代会更加的均衡。 

因为这个原因，**Skip-Gram模型并没有和CBOW模型一样对输入进行迭代更新，而是对2c个输出进行迭代更新**。  



## 基于Hierarchical Softmax的Skip-Gram模型算法流程

**输入**：基于Skip-Gram的语料训练样本，词向量的维度大小$M$，Skip-Gram的上下文大小$2c$, 步长$\eta$ 。

**输出**：霍夫曼树的内部节点模型参数$\theta$，所有的词向量$w$。

1. 基于语料训练样本建立霍夫曼树。
2. 随机初始化所有的模型参数θ，所有的词向量w。
3. 进行梯度上升迭代过程，对于训练集中的每一个样本($w$,context($w$))做如下处理：
    -  a)  $for \ i = 2 \ to \ 2c$ :
        - i) $e=0 $   
        - ii)$for \ j = 2 \ to \ l_w$, 计算：
        $$\begin{align}&f = \sigma(x_i^T\theta_{j-1}^w)\\&
        g = (1-d_j^w-f)\eta\\&
        e = e + g\theta_{j-1}^w\\&
        \theta_{j-1}^w= \theta_{j-1}^w+ gx_i\end{align}$$ 
        - iii) $x_i = x_i + e$   
    - b) 如果梯度收敛，则结束梯度迭代，算法结束，否则回到步骤a继续迭代。



# 基于Negative Sampling的模型

## Hierarchical Softmax的缺点与改进

在讲基于Negative Sampling的word2vec模型前，我们先看看Hierarchical Softmax的的缺点。的确，使用霍夫曼树来代替传统的神经网络，可以提高模型训练的效率。但是如果我们的训练样本里的中心词$w$是一个**很生僻的词**，那么就得在霍夫曼树中辛苦的向下走很久了。能不能不用搞这么复杂的一颗霍夫曼树，将模型变的更加简单呢？

Negative Sampling就是这么一种求解word2vec模型的方法，它摒弃了霍夫曼树，采用了**Negative Sampling（负采样）**的方法来求解，下面我们就来看看Negative Sampling的求解思路。

## 基于Negative Sampling的模型概述

既然名字叫Negative Sampling（负采样），那么肯定使用了采样的方法。采样的方法有很多种，比如之前讲到的大名鼎鼎的MCMC。我们这里的Negative Sampling采样方法并没有MCMC那么复杂。

比如我们有一个训练样本，中心词是$w$,它周围上下文共有$2c$个词，记为context($w$)。由于这个中心词$w$, 的确和context($w$)相关存在，因此它是一个真实的正例。**通过Negative Sampling采样，我们得到$neg$个和$w$不同的中心词$w_i,i=1,2,..neg$，这样context($w$)和$w_i$就组成了$neg$个并不真实存在的负例**。利用这一个正例和$neg$个负例，我们进行二元逻辑回归，得到负采样对应每个词$w_i$对应的模型参数$\theta_{i}$，和每个词的词向量。

从上面的描述可以看出，Negative Sampling由于没有采用霍夫曼树，每次只是通过采样$neg$个不同的中心词做负例，就可以训练模型，因此整个过程要比Hierarchical Softmax简单。

不过有两个问题还需要弄明白：

1. 如果通过一个正例和$neg$个负例进行二元逻辑回归呢？ 如何进行负采样呢？

## 基于Negative Sampling的模型梯度计算

Negative Sampling也是采用了二元逻辑回归来求解模型参数，通过负采样，我们得到了$neg$个负例$(context(w),w_i) \ i=1,2,..neg$。为了统一描述，我们将正例定义为$w_0$。

在逻辑回归中，我们的正例应该期望满足：
$$
P(context(w_0), w_i) = \sigma(x_{w_0}^T\theta^{w_i}) ,y_i=1, i=0
$$
我们的负例期望满足：
$$
P(context(w_0), w_i) =1-  \sigma(x_{w_0}^T\theta^{w_i}), y_i = 0, i=1,2,..neg
$$
我们期望可以最大化下式：
$$
\prod_{i=0}^{neg}P(context(w_0), w_i) = \sigma(x_{w_0}^T\theta^{w_0})\prod_{i=1}^{neg}(1-  \sigma(x_{w_0}^T\theta^{w_i}))
$$
利用逻辑回归和上一节的知识，我们容易写出此时模型的似然函数为：
$$
\prod_{i=0}^{neg} \sigma(x_{w_0}^T\theta^{w_i})^{y_i}(1-  \sigma(x_{w_0}^T\theta^{w_i}))^{1-y_i}
$$
此时对应的对数似然函数为：
$$
L = \sum\limits_{i=0}^{neg}y_i log(\sigma(x_{w_0}^T\theta^{w_i})) + (1-y_i) log(1-  \sigma(x_{w_0}^T\theta^{w_i}))
$$
和Hierarchical Softmax类似，我们采用随机梯度上升法，仅仅每次只用一个样本更新梯度，来进行迭代更新得到我们需要的$x_{wi},\theta_{wi},i=0,1,..neg$, 这里我们需要求出$x_{w0},\theta_{wi},i=0,1,..neg$的梯度。

首先我们计算$x_{wi}$的梯度：
$$
\begin{align} \frac{\partial L}{\partial \theta^{w_i} } &= y_i(1-  \sigma(x_{w_0}^T\theta^{w_i}))x_{w_0}-(1-y_i)\sigma(x_{w_0}^T\theta^{w_i})x_{w_0} \\ & = (y_i -\sigma(x_{w_0}^T\theta^{w_i})) x_{w_0} \end{align}
$$
同样的方法，我们可以求出$x_{w0}$的梯度如下：
$$
\frac{\partial L}{\partial x^{w_0} } = \sum\limits_{i=0}^{neg}(y_i -\sigma(x_{w_0}^T\theta^{w_i}))\theta^{w_i}
$$
有了梯度表达式，我们就可以用梯度上升法进行迭代来一步步的求解我们需要的$x_{w0},\theta_{wi},i=0,1,..neg$。



## Negative Sampling负采样方法

现在我们来看看如何进行负采样，得到$neg$个负例。word2vec采样的方法并不复杂，如果词汇表的大小为$V$,那么我们就将一段长度为$1$的线段分成$V$份，每份对应词汇表中的一个词。当然每个词对应的线段长度是不一样的，高频词对应的线段长，低频词对应的线段短。每个词$w$的线段长度由下式决定：
$$
len(w) = \frac{count(w)}{\sum\limits_{u \in vocab} count(u)}
$$


在word2vec中，分子和分母都取了3/4次幂如下：
$$
len(w) = \frac{count(w)^{3/4}}{\sum\limits_{u \in vocab} count(u)^{3/4}}
$$

在采样前，我们将这段长度为$1$的线段划分成$M$等份，这里$M>>V$，这样可以保证每个词对应的线段都会划分成对应的小块。而$M$份中的每一份都会落在某一个词对应的线段上。在采样的时候，我们只需要从$M$个位置中采样出$neg$个位置就行，此时采样到的每一个位置对应到的线段所属的词就是我们的负例词。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N02-Word2vec-20201214-201036-392683.png)

在word2vec中，M取值默认为$10^8$。



# 基于Negative Sampling的CBOW模型

有了上面Negative Sampling负采样的方法和逻辑回归求解模型参数的方法，我们就可以总结出基于Negative Sampling的CBOW模型算法流程了。梯度迭代过程使用了随机梯度上升法：

**输入**：基于CBOW的语料训练样本，词向量的维度大小$Mcount$，CBOW的上下文大小$2c$,步长$\eta$, 负采样的个数$neg$。  

**输出**：词汇表每个词对应的模型参数$\theta$，所有的词向量$x_w$。

1.  随机初始化所有的模型参数$\theta$，所有的词向量$w$。

2. 对于每个训练样本$(context(w_0),w_0)$,负采样出$neg$个负例中心词$w_i,i=1,2,...neg$。

3. 进行梯度上升迭代过程，对于训练集中的每一个样本$(context(w_0),w_0,w_1,...w_{neg})$做如下处理：

    - a)  $e=0$， 计算$x_{w_0}= \frac{1}{2c}\sum\limits_{i=1}^{2c}x_i$

    - b)   $for \ i = 0 \ to \ neg$, 计算：
        $$
        \begin{align}&f = \sigma(x_{w_0}^T\theta^{w_i})\\&
        g = (y_i-f)\eta\\&
        e = e + g\theta^{w_i}\\&
\theta^{w_i}= \theta^{w_i} + gx_{w_0}\end{align}
        $$
        
    - c) 对于$context(w)$中的每一个词向量$x_k$(共$2c$个)进行更新：
        $$
    x_k = x_k + e
        $$

    - d) 如果梯度收敛，则结束梯度迭代，否则回到步骤3继续迭代。
    
    

# 基于Negative Sampling的Skip-Gram模型

有了上一节CBOW的基础和上一篇基于Hierarchical Softmax的Skip-Gram模型基础，我们也可以总结出基于Negative Sampling的Skip-Gram模型算法流程了。梯度迭代过程使用了随机梯度上升法：

**输入：**基于Skip-Gram的语料训练样本，词向量的维度大小$Mcount$，Skip-Gram的上下文大小$2c$, 步长$\eta$, 负采样的个数$neg$。 

**输出：**词汇表每个词对应的模型参数$\theta$，所有的词向量$x_w$。

1.  随机初始化所有的模型参数$\theta$，所有的词向量$w$
2. 对于每个训练样本$(context(w_0),w_0)$,负采样出$neg$个负例中心词$w_i,i=1,2,...neg$
3. 进行梯度上升迭代过程，对于训练集中的每一个样本$(context(w_0),w_0,w_1,...w_{neg})$做如下处理：
    - a)  $for \ i = 1 \ to \ 2c$:
        - i)  $e=0$
        - ii)  $for \ j= 0 \ to \  neg$, 计算：
        $$
        \begin{align}&f = \sigma(x_{w_{0i}}^T\theta^{w_j})\\&
        g = (y_j-f)\eta\\&
        e = e + g\theta^{w_j}\\&
        \theta^{w_j}= \theta^{w_j} + gx_{w_{0i}}\end{align}
        $$
        - iii)  词向量更新：$x_{w_{0i}} = x_{w_{0i}} + e$
    - b)如果梯度收敛，则结束梯度迭代，算法结束，否则回到步骤a继续迭代。



# 用gensim学习word2vec

## gensim word2vec API概述

在gensim中，word2vec 相关的API都在包gensim.models.word2vec中。和算法有关的参数都在类gensim.models.word2vec.Word2Vec中。算法需要注意的参数有：

1. **sentences: 我们要分析的语料**，可以是一个列表，或者从文件中遍历读出。
2. **size: 词向量的维度，默认值是100**。这个维度的取值一般与我们的语料的大小相关，如果是不大的语料，比如小于100M的文本语料，则使用默认值一般就可以了。如果是超大的语料，建议增大维度。
3. **window：即词向量上下文最大距离**。这个参数在我们的算法原理篇中标记为c，window越大，则和某一词较远的词也会产生上下文关系。默认值为5。在实际使用中，可以根据实际的需求来动态调整这个window的大小。如果是小语料则这个值可以设的更小。对于一般的语料这个值推荐在[5,10]之间。
4. **sg: 即我们的word2vec两个模型的选择了**。如果是0， 则是CBOW模型，是1则是Skip-Gram模型，默认是0即CBOW模型。
5. **hs: 即我们的word2vec两个解法的选择了**。如果是0， 则是Negative Sampling。如果是1的话并且负采样个数negative大于0， 则是Hierarchical Softmax。默认是0即Negative Sampling。
6. **negative: 即使用Negative Sampling时负采样的个数，默认是5**。推荐在[3,10]之间。这个参数在我们的算法原理篇中标记为neg。
7. **cbow_mean: 仅用于CBOW在做投影的时候，为0，则算法中的xw为上下文的词向量之和，为1则为上下文的词向量的平均值**。在我们的原理篇中，是按照词向量的平均值来描述的。个人比较喜欢用平均值来表示$x_{w}$,默认值也是1,不推荐修改默认值。
8. **min_count: 需要计算词向量的最小词频**。这个值可以去掉一些很生僻的低频词，默认是5。如果是小语料，可以调低这个值。
9. **iter: 随机梯度下降法中迭代的最大次数，默认是5**。对于大语料，可以增大这个值。
10. **alpha: 在随机梯度下降法中迭代的初始步长**。算法原理篇中标记为$η$，默认是0.025。
11. **min_alpha: 由于算法支持在迭代的过程中逐渐减小步长，min_alpha给出了最小的迭代步长值**。随机梯度下降中每轮的迭代步长可以由iter，alpha， min_alpha一起得出。这部分由于不是word2vec算法的核心内容，因此在原理篇我们没有提到。对于大语料，需要对alpha, min_alpha,iter一起调参，来选择合适的三个值。

>以上就是gensim word2vec的主要的参数，下面我们用一个实际的例子来学习word2vec。



## 分词


```python
# -*- coding: utf-8 -*-

import jieba
import jieba.analyse
# 加入下面的一串人名是为了结巴分词能更准确的把人名分出来。
jieba.suggest_freq('沙瑞金', True)
jieba.suggest_freq('田国富', True)
jieba.suggest_freq('高育良', True)
jieba.suggest_freq('侯亮平', True)
jieba.suggest_freq('钟小艾', True)
jieba.suggest_freq('陈岩石', True)
jieba.suggest_freq('欧阳菁', True)
jieba.suggest_freq('易学习', True)
jieba.suggest_freq('王大路', True)
jieba.suggest_freq('蔡成功', True)
jieba.suggest_freq('孙连城', True)
jieba.suggest_freq('季昌明', True)
jieba.suggest_freq('丁义珍', True)
jieba.suggest_freq('郑西坡', True)
jieba.suggest_freq('赵东来', True)
jieba.suggest_freq('高小琴', True)
jieba.suggest_freq('赵瑞龙', True)
jieba.suggest_freq('林华华', True)
jieba.suggest_freq('陆亦可', True)
jieba.suggest_freq('刘新建', True)
jieba.suggest_freq('刘庆祝', True)

with open('./in_the_name_of_people.txt', encoding="utf-8") as f:
    document = f.read()
    #document_decode = document.decode('GBK')
    document_cut = jieba.cut(document)
#     print(' '.join(jieba_cut)) // 如果打印结果，则分词效果消失，后面的result无法显示
    result = ' '.join(document_cut)
    result = result.encode('utf-8')
    with open('./in_the_name_of_people_segment.txt', 'wb') as f2:
        f2.write(result)
f.close()
f2.close()
```

拿到了分词后的文件，在一般的NLP处理中，会需要去停用词。由于word2vec的算法依赖于上下文，而上下文有可能就是停词。因此对于word2vec，我们可以不用去停词。

现在我们可以直接读分词后的文件到内存。这里使用了word2vec提供的LineSentence类来读文件，然后套用word2vec的模型。这里只是一个示例，因此省去了调参的步骤，实际使用的时候，你可能需要对我们上面提到一些参数进行调参。

## 模型训练


```python
# import modules & set up logging
import logging
import os
from gensim.models import word2vec

logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)
sentences = word2vec.LineSentence('./in_the_name_of_people_segment.txt')
model = word2vec.Word2Vec(sentences, hs=1, min_count=1, window=3, size=100)
```



> 输出

    2019-01-23 09:11:41,461 : INFO : collecting all words and their counts
    2019-01-23 09:11:41,463 : INFO : PROGRESS: at sentence #0, processed 0 words, keeping 0 word types
    2019-01-23 09:11:41,526 : INFO : collected 17878 word types from a corpus of 161343 raw words and 2311 sentences
    2019-01-23 09:11:41,527 : INFO : Loading a fresh vocabulary
    2019-01-23 09:11:41,556 : INFO : effective_min_count=1 retains 17878 unique words (100% of original 17878, drops 0)
    2019-01-23 09:11:41,557 : INFO : effective_min_count=1 leaves 161343 word corpus (100% of original 161343, drops 0)
    ···


## 寻找近义词

模型出来了，我们可以用来做什么呢？这里给出三个常用的应用。

第一个是最常用的，找出某一个词向量最相近的词集合，代码如下：


```python
req_count = 5
for key in model.wv.similar_by_word('沙瑞金', topn =100):
    if len(key[0])==3:
        req_count -= 1
        print(key[0], key[1])
        if req_count == 0:
            break
```

> 输出


    高育良 0.9689289331436157
    李达康 0.9501643180847168
    易学习 0.9481648802757263
    侯亮平 0.9373587965965271
    祁同伟 0.9338144063949585




## 相识度

第二个应用是看两个词向量的相近程度，这里给出了书中两组人的相似程度：


```python
print(model.wv.similarity('沙瑞金', '高育良'))
print(model.wv.similarity('李达康', '王大路'))
```

    0.96892905
    0.95336753

## 主题分类

第三个应用是找出不同类的词，这里给出了人物分类题：


```python
print(model.wv.doesnt_match("沙瑞金 高育良 李达康 刘庆祝".split()))
```

> 输出

    刘庆祝

