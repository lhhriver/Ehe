# 10.1 词嵌入（word2vec）
> 注：个人觉得本节和下一节写得过于简洁，对于初学者来说可能比较难懂。所以强烈推荐读一读博客[Word2Vec-知其然知其所以然](https://www.zybuluo.com/Dounm/note/591752)。

自然语言是一套用来表达含义的复杂系统。在这套系统中，词是表义的基本单元。顾名思义，词向量是用来表示词的向量，也可被认为是词的特征向量或表征。把词映射为实数域向量的技术也叫词嵌入（word embedding）。近年来，词嵌入已逐渐成为自然语言处理的基础知识。


## 10.1.1 为何不采用one-hot向量

我们在6.4节（循环神经网络的从零开始实现）中使用one-hot向量表示词（字符为词）。回忆一下，假设词典中不同词的数量（词典大小）为$N$，每个词可以和从0到$N-1$的连续整数一一对应。这些与词对应的整数叫作词的索引。
假设一个词的索引为$i$，为了得到该词的one-hot向量表示，我们创建一个全0的长为$N$的向量，并将其第$i$位设成1。这样一来，每个词就表示成了一个长度为$N$的向量，可以直接被神经网络使用。

虽然one-hot词向量构造起来很容易，但通常并不是一个好选择。一个主要的原因是，one-hot词向量无法准确表达不同词之间的相似度，如我们常常使用的余弦相似度。对于向量$\boldsymbol{x}, \boldsymbol{y} \in \mathbb{R}^d$，它们的余弦相似度是它们之间夹角的余弦值

$$\frac{\boldsymbol{x}^\top \boldsymbol{y}}{\|\boldsymbol{x}\| \|\boldsymbol{y}\|} \in [-1, 1].$$

由于任何两个不同词的one-hot向量的余弦相似度都为0，多个不同词之间的相似度难以通过one-hot向量准确地体现出来。

word2vec工具的提出正是为了解决上面这个问题 [1]。它将每个词表示成一个定长的向量，并使得这些向量能较好地表达不同词之间的相似和类比关系。word2vec工具包含了两个模型，即跳字模型（skip-gram）[2] 和连续词袋模型（continuous bag of words，CBOW）[3]。接下来让我们分别介绍这两个模型以及它们的训练方法。


## 10.1.2 跳字模型

跳字模型假设基于某个词来生成它在文本序列周围的词。举个例子，假设文本序列是“the”“man”“loves”“his”“son”。以“loves”作为中心词，设背景窗口大小为2。如图10.1所示，跳字模型所关心的是，给定中心词“loves”，生成与它距离不超过2个词的背景词“the”“man”“his”“son”的条件概率，即

$$P(\textrm{``the"},\textrm{``man"},\textrm{``his"},\textrm{``son"}\mid\textrm{``loves"}).$$

假设给定中心词的情况下，背景词的生成是相互独立的，那么上式可以改写成

$$P(\textrm{``the"}\mid\textrm{``loves"})\cdot P(\textrm{``man"}\mid\textrm{``loves"})\cdot P(\textrm{``his"}\mid\textrm{``loves"})\cdot P(\textrm{``son"}\mid\textrm{``loves"}).$$


<div align=center>
<img width="300" src="../../img/chapter10/10.1_skip-gram.svg"/>
</div>
<div align=center>图10.1 跳字模型关心给定中心词生成背景词的条件概率</div>

在跳字模型中，每个词被表示成两个$d$维向量，用来计算条件概率。假设这个词在词典中索引为$i$，当它为中心词时向量表示为$\boldsymbol{v}_i\in\mathbb{R}^d$，而为背景词时向量表示为$\boldsymbol{u}_i\in\mathbb{R}^d$。设中心词$w_c$在词典中索引为$c$，背景词$w_o$在词典中索引为$o$，给定中心词生成背景词的条件概率可以通过对向量内积做softmax运算而得到：

$$P(w_o \mid w_c) = \frac{\text{exp}(\boldsymbol{u}_o^\top \boldsymbol{v}_c)}{ \sum_{i \in \mathcal{V}} \text{exp}(\boldsymbol{u}_i^\top \boldsymbol{v}_c)},$$

其中词典索引集$\mathcal{V} = \{0, 1, \ldots, |\mathcal{V}|-1\}$。假设给定一个长度为$T$的文本序列，设时间步$t$的词为$w^{(t)}$。假设给定中心词的情况下背景词的生成相互独立，当背景窗口大小为$m$时，跳字模型的似然函数即给定任一中心词生成所有背景词的概率

$$ \prod_{t=1}^{T} \prod_{-m \leq j \leq m,\ j \neq 0} P(w^{(t+j)} \mid w^{(t)}),$$

这里小于1和大于$T$的时间步可以忽略。

### 10.1.2.1 训练跳字模型

跳字模型的参数是每个词所对应的中心词向量和背景词向量。训练中我们通过最大化似然函数来学习模型参数，即最大似然估计。这等价于最小化以下损失函数：

$$ - \sum_{t=1}^{T} \sum_{-m \leq j \leq m,\ j \neq 0} \text{log}\, P(w^{(t+j)} \mid w^{(t)}).$$


如果使用随机梯度下降，那么在每一次迭代里我们随机采样一个较短的子序列来计算有关该子序列的损失，然后计算梯度来更新模型参数。梯度计算的关键是条件概率的对数有关中心词向量和背景词向量的梯度。根据定义，首先看到


$$\log P(w_o \mid w_c) =
\boldsymbol{u}_o^\top \boldsymbol{v}_c - \log\left(\sum_{i \in \mathcal{V}} \text{exp}(\boldsymbol{u}_i^\top \boldsymbol{v}_c)\right)$$

通过微分，我们可以得到上式中$\boldsymbol{v}_c$的梯度

$$
\begin{aligned}
\frac{\partial \text{log}\, P(w_o \mid w_c)}{\partial \boldsymbol{v}_c} 
&= \boldsymbol{u}_o - \frac{\sum_{j \in \mathcal{V}} \exp(\boldsymbol{u}_j^\top \boldsymbol{v}_c)\boldsymbol{u}_j}{\sum_{i \in \mathcal{V}} \exp(\boldsymbol{u}_i^\top \boldsymbol{v}_c)}\\
&= \boldsymbol{u}_o - \sum_{j \in \mathcal{V}} \left(\frac{\text{exp}(\boldsymbol{u}_j^\top \boldsymbol{v}_c)}{ \sum_{i \in \mathcal{V}} \text{exp}(\boldsymbol{u}_i^\top \boldsymbol{v}_c)}\right) \boldsymbol{u}_j\\ 
&= \boldsymbol{u}_o - \sum_{j \in \mathcal{V}} P(w_j \mid w_c) \boldsymbol{u}_j.
\end{aligned}
$$

它的计算需要词典中所有词以$w_c$为中心词的条件概率。有关其他词向量的梯度同理可得。

训练结束后，对于词典中的任一索引为$i$的词，我们均得到该词作为中心词和背景词的两组词向量$\boldsymbol{v}_i$和$\boldsymbol{u}_i$。在自然语言处理应用中，一般使用跳字模型的中心词向量作为词的表征向量。


## 10.1.3 连续词袋模型

连续词袋模型与跳字模型类似。与跳字模型最大的不同在于，连续词袋模型假设基于某中心词在文本序列前后的背景词来生成该中心词。在同样的文本序列“the”“man”“loves”“his”“son”里，以“loves”作为中心词，且背景窗口大小为2时，连续词袋模型关心的是，给定背景词“the”“man”“his”“son”生成中心词“loves”的条件概率（如图10.2所示），也就是

$$P(\textrm{``loves"}\mid\textrm{``the"},\textrm{``man"},\textrm{``his"},\textrm{``son"}).$$


<div align=center>
<img width="300" src="../../img/chapter10/10.1_cbow.svg"/>
</div>
<div align=center>图10.2 连续词袋模型关心给定背景词生成中心词的条件概率</div>

因为连续词袋模型的背景词有多个，我们将这些背景词向量取平均，然后使用和跳字模型一样的方法来计算条件概率。设$\boldsymbol{v_i}\in\mathbb{R}^d$和$\boldsymbol{u_i}\in\mathbb{R}^d$分别表示词典中索引为$i$的词作为背景词和中心词的向量（注意符号的含义与跳字模型中的相反）。设中心词$w_c$在词典中索引为$c$，背景词$w_{o_1}, \ldots, w_{o_{2m}}$在词典中索引为$o_1, \ldots, o_{2m}$，那么给定背景词生成中心词的条件概率

$$P(w_c \mid w_{o_1}, \ldots, w_{o_{2m}}) = \frac{\text{exp}\left(\frac{1}{2m}\boldsymbol{u}_c^\top (\boldsymbol{v}_{o_1} + \ldots + \boldsymbol{v}_{o_{2m}}) \right)}{ \sum_{i \in \mathcal{V}} \text{exp}\left(\frac{1}{2m}\boldsymbol{u}_i^\top (\boldsymbol{v}_{o_1} + \ldots + \boldsymbol{v}_{o_{2m}}) \right)}.$$

为了让符号更加简单，我们记$\mathcal{W}_o= \{w_{o_1}, \ldots, w_{o_{2m}}\}$，且$\bar{\boldsymbol{v}}_o = \left(\boldsymbol{v}_{o_1} + \ldots + \boldsymbol{v}_{o_{2m}} \right)/(2m)$，那么上式可以简写成

$$P(w_c \mid \mathcal{W}_o) = \frac{\exp\left(\boldsymbol{u}_c^\top \bar{\boldsymbol{v}}_o\right)}{\sum_{i \in \mathcal{V}} \exp\left(\boldsymbol{u}_i^\top \bar{\boldsymbol{v}}_o\right)}.$$

给定一个长度为$T$的文本序列，设时间步$t$的词为$w^{(t)}$，背景窗口大小为$m$。连续词袋模型的似然函数是由背景词生成任一中心词的概率

$$ \prod_{t=1}^{T}  P(w^{(t)} \mid  w^{(t-m)}, \ldots,  w^{(t-1)},  w^{(t+1)}, \ldots,  w^{(t+m)}).$$

### 10.1.3.1 训练连续词袋模型

训练连续词袋模型同训练跳字模型基本一致。连续词袋模型的最大似然估计等价于最小化损失函数

$$  -\sum_{t=1}^T  \text{log}\, P(w^{(t)} \mid  w^{(t-m)}, \ldots,  w^{(t-1)},  w^{(t+1)}, \ldots,  w^{(t+m)}).$$

注意到

$$\log\,P(w_c \mid \mathcal{W}_o) = \boldsymbol{u}_c^\top \bar{\boldsymbol{v}}_o - \log\,\left(\sum_{i \in \mathcal{V}} \exp\left(\boldsymbol{u}_i^\top \bar{\boldsymbol{v}}_o\right)\right).$$

通过微分，我们可以计算出上式中条件概率的对数有关任一背景词向量$\boldsymbol{v}_{o_i}$（$i = 1, \ldots, 2m$）的梯度

$$\frac{\partial \log\, P(w_c \mid \mathcal{W}_o)}{\partial \boldsymbol{v}_{o_i}} = \frac{1}{2m} \left(\boldsymbol{u}_c - \sum_{j \in \mathcal{V}} \frac{\exp(\boldsymbol{u}_j^\top \bar{\boldsymbol{v}}_o)\boldsymbol{u}_j}{ \sum_{i \in \mathcal{V}} \text{exp}(\boldsymbol{u}_i^\top \bar{\boldsymbol{v}}_o)} \right) = \frac{1}{2m}\left(\boldsymbol{u}_c - \sum_{j \in \mathcal{V}} P(w_j \mid \mathcal{W}_o) \boldsymbol{u}_j \right).$$

有关其他词向量的梯度同理可得。同跳字模型不一样的一点在于，我们一般使用连续词袋模型的背景词向量作为词的表征向量。

## 小结

* 词向量是用来表示词的向量。把词映射为实数域向量的技术也叫词嵌入。
* word2vec包含跳字模型和连续词袋模型。跳字模型假设基于中心词来生成背景词。连续词袋模型假设基于背景词来生成中心词。



## 参考文献

[1] word2vec工具。https://code.google.com/archive/p/word2vec/

[2] Mikolov, T., Sutskever, I., Chen, K., Corrado, G. S., & Dean, J. (2013). Distributed representations of words and phrases and their compositionality. In Advances in neural information processing systems (pp. 3111-3119).

[3] Mikolov, T., Chen, K., Corrado, G., & Dean, J. (2013). Efficient estimation of word representations in vector space. arXiv preprint arXiv:1301.3781.

-----------
> 注：本节与原书完全相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/word2vec.html)
# 10.2 近似训练

回忆上一节的内容。跳字模型的核心在于使用softmax运算得到给定中心词$w_c$来生成背景词$w_o$的条件概率

$$P(w_o \mid w_c) = \frac{\text{exp}(\boldsymbol{u}_o^\top \boldsymbol{v}_c)}{ \sum_{i \in \mathcal{V}} \text{exp}(\boldsymbol{u}_i^\top \boldsymbol{v}_c)}.$$

该条件概率相应的对数损失

$$-\log P(w_o \mid w_c) =
-\boldsymbol{u}_o^\top \boldsymbol{v}_c + \log\left(\sum_{i \in \mathcal{V}} \text{exp}(\boldsymbol{u}_i^\top \boldsymbol{v}_c)\right).$$


由于softmax运算考虑了背景词可能是词典$\mathcal{V}$中的任一词，以上损失包含了词典大小数目的项的累加。在上一节中我们看到，不论是跳字模型还是连续词袋模型，由于条件概率使用了softmax运算，每一步的梯度计算都包含词典大小数目的项的累加。对于含几十万或上百万词的较大词典，每次的梯度计算开销可能过大。为了降低该计算复杂度，本节将介绍两种近似训练方法，即负采样（negative sampling）或层序softmax（hierarchical softmax）。由于跳字模型和连续词袋模型类似，本节仅以跳字模型为例介绍这两种方法。



## 10.2.1 负采样

负采样修改了原来的目标函数。给定中心词$w_c$的一个背景窗口，我们把背景词$w_o$出现在该背景窗口看作一个事件，并将该事件的概率计算为

$$P(D=1\mid w_c, w_o) = \sigma(\boldsymbol{u}_o^\top \boldsymbol{v}_c),$$

其中的$\sigma$函数与sigmoid激活函数的定义相同：

$$\sigma(x) = \frac{1}{1+\exp(-x)}.$$

我们先考虑最大化文本序列中所有该事件的联合概率来训练词向量。具体来说，给定一个长度为$T$的文本序列，设时间步$t$的词为$w^{(t)}$且背景窗口大小为$m$，考虑最大化联合概率

$$ \prod_{t=1}^{T} \prod_{-m \leq j \leq m,\ j \neq 0} P(D=1\mid w^{(t)}, w^{(t+j)}).$$

然而，以上模型中包含的事件仅考虑了正类样本。这导致当所有词向量相等且值为无穷大时，以上的联合概率才被最大化为1。很明显，这样的词向量毫无意义。负采样通过采样并添加负类样本使目标函数更有意义。设背景词$w_o$出现在中心词$w_c$的一个背景窗口为事件$P$，我们根据分布$P(w)$采样$K$个未出现在该背景窗口中的词，即噪声词。设噪声词$w_k$（$k=1, \ldots, K$）不出现在中心词$w_c$的该背景窗口为事件$N_k$。假设同时含有正类样本和负类样本的事件$P, N_1, \ldots, N_K$相互独立，负采样将以上需要最大化的仅考虑正类样本的联合概率改写为


$$ \prod_{t=1}^{T} \prod_{-m \leq j \leq m,\ j \neq 0} P(w^{(t+j)} \mid w^{(t)}),$$

其中条件概率被近似表示为
$$ P(w^{(t+j)} \mid w^{(t)}) =P(D=1\mid w^{(t)}, w^{(t+j)})\prod_{k=1,\ w_k \sim P(w)}^K P(D=0\mid w^{(t)}, w_k).$$


设文本序列中时间步$t$的词$w^{(t)}$在词典中的索引为$i_t$，噪声词$w_k$在词典中的索引为$h_k$。有关以上条件概率的对数损失为

$$
\begin{aligned}
-\log P(w^{(t+j)} \mid w^{(t)})
=& -\log P(D=1\mid w^{(t)}, w^{(t+j)}) - \sum_{k=1,\ w_k \sim P(w)}^K \log P(D=0\mid w^{(t)}, w_k)\\
=&-  \log\, \sigma\left(\boldsymbol{u}_{i_{t+j}}^\top \boldsymbol{v}_{i_t}\right) - \sum_{k=1,\ w_k \sim P(w)}^K \log\left(1-\sigma\left(\boldsymbol{u}_{h_k}^\top \boldsymbol{v}_{i_t}\right)\right)\\
=&-  \log\, \sigma\left(\boldsymbol{u}_{i_{t+j}}^\top \boldsymbol{v}_{i_t}\right) - \sum_{k=1,\ w_k \sim P(w)}^K \log\sigma\left(-\boldsymbol{u}_{h_k}^\top \boldsymbol{v}_{i_t}\right).
\end{aligned}
$$

现在，训练中每一步的梯度计算开销不再与词典大小相关，而与$K$线性相关。当$K$取较小的常数时，负采样在每一步的梯度计算开销较小。


## 10.2.2 层序softmax

层序softmax是另一种近似训练法。它使用了二叉树这一数据结构，树的每个叶结点代表词典$\mathcal{V}$中的每个词。

<div align=center>
<img width="300" src="../../img/chapter10/10.2_hi-softmax.svg"/>
</div>
<div align=center>图10.3 层序softmax。二叉树的每个叶结点代表着词典的每个词</div>


假设$L(w)$为从二叉树的根结点到词$w$的叶结点的路径（包括根结点和叶结点）上的结点数。设$n(w,j)$为该路径上第$j$个结点，并设该结点的背景词向量为$\boldsymbol{u}_{n(w,j)}$。以图10.3为例，$L(w_3) = 4$。层序softmax将跳字模型中的条件概率近似表示为

$$P(w_o \mid w_c) = \prod_{j=1}^{L(w_o)-1} \sigma\left( [\![  n(w_o, j+1) = \text{leftChild}(n(w_o,j)) ]\!] \cdot \boldsymbol{u}_{n(w_o,j)}^\top \boldsymbol{v}_c\right),$$

其中$\sigma$函数与3.8节（多层感知机）中sigmoid激活函数的定义相同，$\text{leftChild}(n)$是结点$n$的左子结点：如果判断$x$为真，$[\![x]\!] = 1$；反之$[\![x]\!] = -1$。
让我们计算图10.3中给定词$w_c$生成词$w_3$的条件概率。我们需要将$w_c$的词向量$\boldsymbol{v}_c$和根结点到$w_3$路径上的非叶结点向量一一求内积。由于在二叉树中由根结点到叶结点$w_3$的路径上需要向左、向右再向左地遍历（图10.3中加粗的路径），我们得到

$$P(w_3 \mid w_c) = \sigma(\boldsymbol{u}_{n(w_3,1)}^\top \boldsymbol{v}_c) \cdot \sigma(-\boldsymbol{u}_{n(w_3,2)}^\top \boldsymbol{v}_c) \cdot \sigma(\boldsymbol{u}_{n(w_3,3)}^\top \boldsymbol{v}_c).$$

由于$\sigma(x)+\sigma(-x) = 1$，给定中心词$w_c$生成词典$\mathcal{V}$中任一词的条件概率之和为1这一条件也将满足：

$$\sum_{w \in \mathcal{V}} P(w \mid w_c) = 1.$$

此外，由于$L(w_o)-1$的数量级为$\mathcal{O}(\text{log}_2|\mathcal{V}|)$，当词典$\mathcal{V}$很大时，层序softmax在训练中每一步的梯度计算开销相较未使用近似训练时大幅降低。

## 小结

* 负采样通过考虑同时含有正类样本和负类样本的相互独立事件来构造损失函数。其训练中每一步的梯度计算开销与采样的噪声词的个数线性相关。
* 层序softmax使用了二叉树，并根据根结点到叶结点的路径来构造损失函数。其训练中每一步的梯度计算开销与词典大小的对数相关。



-----------
> 注：本节与原书完全相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/approx-training.html)
# 10.3 word2vec的实现

本节是对前两节内容的实践。我们以10.1节（词嵌入word2vec）中的跳字模型和10.2节（近似训练）中的负采样为例，介绍在语料库上训练词嵌入模型的实现。我们还会介绍一些实现中的技巧，如二次采样（subsampling）。

首先导入实验所需的包或模块。

``` python
import collections
import math
import random
import sys
import time
import os
import numpy as np
import torch
from torch import nn
import torch.utils.data as Data

sys.path.append("..") 
import d2lzh_pytorch as d2l
print(torch.__version__)
```

## 10.3.1 处理数据集

PTB（Penn Tree Bank）是一个常用的小型语料库 [1]。它采样自《华尔街日报》的文章，包括训练集、验证集和测试集。我们将在PTB训练集上训练词嵌入模型。该数据集的每一行作为一个句子。句子中的每个词由空格隔开。

确保`ptb.train.txt`已经放在了文件夹`../../data/ptb`下。
``` python
assert 'ptb.train.txt' in os.listdir("../../data/ptb")

with open('../../data/ptb/ptb.train.txt', 'r') as f:
    lines = f.readlines()
    # st是sentence的缩写
    raw_dataset = [st.split() for st in lines]

'# sentences: %d' % len(raw_dataset) # 输出 '# sentences: 42068'
```

对于数据集的前3个句子，打印每个句子的词数和前5个词。这个数据集中句尾符为"&lt;eos&gt;"，生僻词全用"&lt;unk&gt;"表示，数字则被替换成了"N"。

``` python
for st in raw_dataset[:3]:
    print('# tokens:', len(st), st[:5])
```
输出：
```
# tokens: 24 ['aer', 'banknote', 'berlitz', 'calloway', 'centrust']
# tokens: 15 ['pierre', '<unk>', 'N', 'years', 'old']
# tokens: 11 ['mr.', '<unk>', 'is', 'chairman', 'of']
```

### 10.3.1.1 建立词语索引

为了计算简单，我们只保留在数据集中至少出现5次的词。

``` python
# tk是token的缩写
counter = collections.Counter([tk for st in raw_dataset for tk in st])
counter = dict(filter(lambda x: x[1] >= 5, counter.items()))
```

然后将词映射到整数索引。

``` python
idx_to_token = [tk for tk, _ in counter.items()]
token_to_idx = {tk: idx for idx, tk in enumerate(idx_to_token)}
dataset = [[token_to_idx[tk] for tk in st if tk in token_to_idx]
           for st in raw_dataset]
num_tokens = sum([len(st) for st in dataset])
'# tokens: %d' % num_tokens # 输出 '# tokens: 887100'
```

### 10.3.1.2 二次采样

文本数据中一般会出现一些高频词，如英文中的“the”“a”和“in”。通常来说，在一个背景窗口中，一个词（如“chip”）和较低频词（如“microprocessor”）同时出现比和较高频词（如“the”）同时出现对训练词嵌入模型更有益。因此，训练词嵌入模型时可以对词进行二次采样 [2]。
具体来说，数据集中每个被索引词$w_i$将有一定概率被丢弃，该丢弃概率为

$$ 
P(w_i) = \max\left(1 - \sqrt{\frac{t}{f(w_i)}}, 0\right),
$$ 

其中 $f(w_i)$ 是数据集中词$w_i$的个数与总词数之比，常数$t$是一个超参数（实验中设为$10^{-4}$）。可见，只有当$f(w_i) > t$时，我们才有可能在二次采样中丢弃词$w_i$，并且越高频的词被丢弃的概率越大。

``` python
def discard(idx):
    return random.uniform(0, 1) < 1 - math.sqrt(
        1e-4 / counter[idx_to_token[idx]] * num_tokens)

subsampled_dataset = [[tk for tk in st if not discard(tk)] for st in dataset]
'# tokens: %d' % sum([len(st) for st in subsampled_dataset]) # '# tokens: 375875'
```

可以看到，二次采样后我们去掉了一半左右的词。下面比较一个词在二次采样前后出现在数据集中的次数。可见高频词“the”的采样率不足1/20。

``` python
def compare_counts(token):
    return '# %s: before=%d, after=%d' % (token, sum(
        [st.count(token_to_idx[token]) for st in dataset]), sum(
        [st.count(token_to_idx[token]) for st in subsampled_dataset]))

compare_counts('the') # '# the: before=50770, after=2013'
```

但低频词“join”则完整地保留了下来。

``` python
compare_counts('join') # '# join: before=45, after=45'
```

### 10.3.1.3 提取中心词和背景词

我们将与中心词距离不超过背景窗口大小的词作为它的背景词。下面定义函数提取出所有中心词和它们的背景词。它每次在整数1和`max_window_size`（最大背景窗口）之间随机均匀采样一个整数作为背景窗口大小。

``` python
def get_centers_and_contexts(dataset, max_window_size):
    centers, contexts = [], []
    for st in dataset:
        if len(st) < 2:  # 每个句子至少要有2个词才可能组成一对“中心词-背景词”
            continue
        centers += st
        for center_i in range(len(st)):
            window_size = random.randint(1, max_window_size)
            indices = list(range(max(0, center_i - window_size),
                                 min(len(st), center_i + 1 + window_size)))
            indices.remove(center_i)  # 将中心词排除在背景词之外
            contexts.append([st[idx] for idx in indices])
    return centers, contexts
```

下面我们创建一个人工数据集，其中含有词数分别为7和3的两个句子。设最大背景窗口为2，打印所有中心词和它们的背景词。

``` python
tiny_dataset = [list(range(7)), list(range(7, 10))]
print('dataset', tiny_dataset)
for center, context in zip(*get_centers_and_contexts(tiny_dataset, 2)):
    print('center', center, 'has contexts', context)
```
输出：
```
dataset [[0, 1, 2, 3, 4, 5, 6], [7, 8, 9]]
center 0 has contexts [1, 2]
center 1 has contexts [0, 2, 3]
center 2 has contexts [1, 3]
center 3 has contexts [2, 4]
center 4 has contexts [3, 5]
center 5 has contexts [3, 4, 6]
center 6 has contexts [4, 5]
center 7 has contexts [8]
center 8 has contexts [7, 9]
center 9 has contexts [7, 8]
```

实验中，我们设最大背景窗口大小为5。下面提取数据集中所有的中心词及其背景词。

``` python
all_centers, all_contexts = get_centers_and_contexts(subsampled_dataset, 5)
```

## 10.3.2 负采样

我们使用负采样来进行近似训练。对于一对中心词和背景词，我们随机采样$K$个噪声词（实验中设$K=5$）。根据word2vec论文的建议，噪声词采样概率$P(w)$设为$w$词频与总词频之比的0.75次方 [2]。

``` python
def get_negatives(all_contexts, sampling_weights, K):
    all_negatives, neg_candidates, i = [], [], 0
    population = list(range(len(sampling_weights)))
    for contexts in all_contexts:
        negatives = []
        while len(negatives) < len(contexts) * K:
            if i == len(neg_candidates):
                # 根据每个词的权重（sampling_weights）随机生成k个词的索引作为噪声词。
                # 为了高效计算，可以将k设得稍大一点
                i, neg_candidates = 0, random.choices(
                    population, sampling_weights, k=int(1e5))
            neg, i = neg_candidates[i], i + 1
            # 噪声词不能是背景词
            if neg not in set(contexts):
                negatives.append(neg)
        all_negatives.append(negatives)
    return all_negatives

sampling_weights = [counter[w]**0.75 for w in idx_to_token]
all_negatives = get_negatives(all_contexts, sampling_weights, 5)
```

## 10.3.3 读取数据

我们从数据集中提取所有中心词`all_centers`，以及每个中心词对应的背景词`all_contexts`和噪声词`all_negatives`。我们先定义一个`Dataset`类。
``` python
class MyDataset(torch.utils.data.Dataset):
    def __init__(self, centers, contexts, negatives):
        assert len(centers) == len(contexts) == len(negatives)
        self.centers = centers
        self.contexts = contexts
        self.negatives = negatives
        
    def __getitem__(self, index):
        return (self.centers[index], self.contexts[index], self.negatives[index])

    def __len__(self):
        return len(self.centers)
```

我们将通过随机小批量来读取它们。在一个小批量数据中，第$i$个样本包括一个中心词以及它所对应的$n_i$个背景词和$m_i$个噪声词。由于每个样本的背景窗口大小可能不一样，其中背景词与噪声词个数之和$n_i+m_i$也会不同。在构造小批量时，我们将每个样本的背景词和噪声词连结在一起，并添加填充项0直至连结后的长度相同，即长度均为$\max_i n_i+m_i$（`max_len`变量）。为了避免填充项对损失函数计算的影响，我们构造了掩码变量`masks`，其每一个元素分别与连结后的背景词和噪声词`contexts_negatives`中的元素一一对应。当`contexts_negatives`变量中的某个元素为填充项时，相同位置的掩码变量`masks`中的元素取0，否则取1。为了区分正类和负类，我们还需要将`contexts_negatives`变量中的背景词和噪声词区分开来。依据掩码变量的构造思路，我们只需创建与`contexts_negatives`变量形状相同的标签变量`labels`，并将与背景词（正类）对应的元素设1，其余清0。

下面我们实现这个小批量读取函数`batchify`。它的小批量输入`data`是一个长度为批量大小的列表，其中每个元素分别包含中心词`center`、背景词`context`和噪声词`negative`。该函数返回的小批量数据符合我们需要的格式，例如，包含了掩码变量。

``` python
def batchify(data):
    """用作DataLoader的参数collate_fn: 输入是个长为batchsize的list, 
    list中的每个元素都是Dataset类调用__getitem__得到的结果
    """
    max_len = max(len(c) + len(n) for _, c, n in data)
    centers, contexts_negatives, masks, labels = [], [], [], []
    for center, context, negative in data:
        cur_len = len(context) + len(negative)
        centers += [center]
        contexts_negatives += [context + negative + [0] * (max_len - cur_len)]
        masks += [[1] * cur_len + [0] * (max_len - cur_len)]
        labels += [[1] * len(context) + [0] * (max_len - len(context))]
    return (torch.tensor(centers).view(-1, 1), torch.tensor(contexts_negatives),
            torch.tensor(masks), torch.tensor(labels))
```

我们用刚刚定义的`batchify`函数指定`DataLoader`实例中小批量的读取方式，然后打印读取的第一个批量中各个变量的形状。

``` python
batch_size = 512
num_workers = 0 if sys.platform.startswith('win32') else 4

dataset = MyDataset(all_centers, 
                    all_contexts, 
                    all_negatives)
data_iter = Data.DataLoader(dataset, batch_size, shuffle=True,
                            collate_fn=batchify, 
                            num_workers=num_workers)
for batch in data_iter:
    for name, data in zip(['centers', 'contexts_negatives', 'masks',
                           'labels'], batch):
        print(name, 'shape:', data.shape)
    break
```
输出：
```
centers shape: torch.Size([512, 1])
contexts_negatives shape: torch.Size([512, 60])
masks shape: torch.Size([512, 60])
labels shape: torch.Size([512, 60])
```

## 10.3.4 跳字模型

我们将通过使用嵌入层和小批量乘法来实现跳字模型。它们也常常用于实现其他自然语言处理的应用。

### 10.3.4.1 嵌入层

获取词嵌入的层称为嵌入层，在PyTorch中可以通过创建`nn.Embedding`实例得到。嵌入层的权重是一个矩阵，其行数为词典大小（`num_embeddings`），列数为每个词向量的维度（`embedding_dim`）。我们设词典大小为20，词向量的维度为4。

``` python
embed = nn.Embedding(num_embeddings=20, embedding_dim=4)
embed.weight
```
输出：
```
Parameter containing:
tensor([[-0.4689,  0.2420,  0.9826, -1.3280],
        [-0.6690,  1.2385, -1.7482,  0.2986],
        [ 0.1193,  0.1554,  0.5038, -0.3619],
        [-0.0347, -0.2806,  0.3854, -0.8600],
        [-0.6479, -1.1424, -1.1920,  0.3922],
        [ 0.6334, -0.0703,  0.0830, -0.4782],
        [ 0.1712,  0.8098, -1.2208,  0.4169],
        [-0.9925,  0.9383, -0.3808, -0.1242],
        [-0.3762,  1.9276,  0.6279, -0.6391],
        [-0.8518,  2.0105,  1.8484, -0.5646],
        [-1.0699, -1.0822, -0.6945, -0.7321],
        [ 0.4806, -0.5945,  1.0795,  0.1062],
        [-1.5377,  1.0420,  0.4325,  0.1098],
        [-0.8438, -1.4104, -0.9700, -0.4889],
        [-1.9745, -0.3092,  0.6398, -0.4368],
        [ 0.0484, -0.8516, -0.4955, -0.1363],
        [-2.6301, -0.7091,  2.2116, -0.1363],
        [-0.2025,  0.8037,  0.4906,  1.5929],
        [-0.6745, -0.8791, -0.9220, -0.8125],
        [ 0.2450,  1.9456,  0.1257, -0.3728]], requires_grad=True)
```

嵌入层的输入为词的索引。输入一个词的索引$i$，嵌入层返回权重矩阵的第$i$行作为它的词向量。下面我们将形状为(2, 3)的索引输入进嵌入层，由于词向量的维度为4，我们得到形状为(2, 3, 4)的词向量。

``` python
x = torch.tensor([[1, 2, 3], [4, 5, 6]], dtype=torch.long)
embed(x)
```
输出：
```
tensor([[[-0.6690,  1.2385, -1.7482,  0.2986],
         [ 0.1193,  0.1554,  0.5038, -0.3619],
         [-0.0347, -0.2806,  0.3854, -0.8600]],

        [[-0.6479, -1.1424, -1.1920,  0.3922],
         [ 0.6334, -0.0703,  0.0830, -0.4782],
         [ 0.1712,  0.8098, -1.2208,  0.4169]]], grad_fn=<EmbeddingBackward>)
```

### 10.3.4.2 小批量乘法

我们可以使用小批量乘法运算`bmm`对两个小批量中的矩阵一一做乘法。假设第一个小批量中包含$n$个形状为$a\times b$的矩阵$\boldsymbol{X}_1, \ldots, \boldsymbol{X}_n$，第二个小批量中包含$n$个形状为$b\times c$的矩阵$\boldsymbol{Y}_1, \ldots, \boldsymbol{Y}_n$。这两个小批量的矩阵乘法输出为$n$个形状为$a\times c$的矩阵$\boldsymbol{X}_1\boldsymbol{Y}_1, \ldots, \boldsymbol{X}_n\boldsymbol{Y}_n$。因此，给定两个形状分别为($n$, $a$, $b$)和($n$, $b$, $c$)的`Tensor`，小批量乘法输出的形状为($n$, $a$, $c$)。

``` python
X = torch.ones((2, 1, 4))
Y = torch.ones((2, 4, 6))
torch.bmm(X, Y).shape
```
输出：
```
torch.Size([2, 1, 6])
```

### 10.3.4.3 跳字模型前向计算

在前向计算中，跳字模型的输入包含中心词索引`center`以及连结的背景词与噪声词索引`contexts_and_negatives`。其中`center`变量的形状为(批量大小, 1)，而`contexts_and_negatives`变量的形状为(批量大小, `max_len`)。这两个变量先通过词嵌入层分别由词索引变换为词向量，再通过小批量乘法得到形状为(批量大小, 1, `max_len`)的输出。输出中的每个元素是中心词向量与背景词向量或噪声词向量的内积。

``` python
def skip_gram(center, contexts_and_negatives, embed_v, embed_u):
    v = embed_v(center)
    u = embed_u(contexts_and_negatives)
    pred = torch.bmm(v, u.permute(0, 2, 1))
    return pred
```

## 10.3.5 训练模型

在训练词嵌入模型之前，我们需要定义模型的损失函数。


### 10.3.5.1 二元交叉熵损失函数

根据负采样中损失函数的定义，我们可以使用二元交叉熵损失函数,下面定义`SigmoidBinaryCrossEntropyLoss`。

``` python
class SigmoidBinaryCrossEntropyLoss(nn.Module):
    def __init__(self): # none mean sum
        super(SigmoidBinaryCrossEntropyLoss, self).__init__()
    def forward(self, inputs, targets, mask=None):
        """
        input – Tensor shape: (batch_size, len)
        target – Tensor of the same shape as input
        """
        inputs, targets, mask = inputs.float(), targets.float(), mask.float()
        res = nn.functional.binary_cross_entropy_with_logits(inputs, targets, reduction="none", weight=mask)
        return res.mean(dim=1)

loss = SigmoidBinaryCrossEntropyLoss()
```

值得一提的是，我们可以通过掩码变量指定小批量中参与损失函数计算的部分预测值和标签：当掩码为1时，相应位置的预测值和标签将参与损失函数的计算；当掩码为0时，相应位置的预测值和标签则不参与损失函数的计算。我们之前提到，掩码变量可用于避免填充项对损失函数计算的影响。

``` python
pred = torch.tensor([[1.5, 0.3, -1, 2], [1.1, -0.6, 2.2, 0.4]])
# 标签变量label中的1和0分别代表背景词和噪声词
label = torch.tensor([[1, 0, 0, 0], [1, 1, 0, 0]])
mask = torch.tensor([[1, 1, 1, 1], [1, 1, 1, 0]])  # 掩码变量
loss(pred, label, mask) * mask.shape[1] / mask.float().sum(dim=1)
```
输出：
```
tensor([0.8740, 1.2100])
```

作为比较，下面将从零开始实现二元交叉熵损失函数的计算，并根据掩码变量`mask`计算掩码为1的预测值和标签的损失。

``` python
def sigmd(x):
    return - math.log(1 / (1 + math.exp(-x)))

print('%.4f' % ((sigmd(1.5) + sigmd(-0.3) + sigmd(1) + sigmd(-2)) / 4)) # 注意1-sigmoid(x) = sigmoid(-x)
print('%.4f' % ((sigmd(1.1) + sigmd(-0.6) + sigmd(-2.2)) / 3))
```
输出：
```
0.8740
1.2100
```

### 10.3.5.2 初始化模型参数

我们分别构造中心词和背景词的嵌入层，并将超参数词向量维度`embed_size`设置成100。

``` python
embed_size = 100
net = nn.Sequential(
    nn.Embedding(num_embeddings=len(idx_to_token), embedding_dim=embed_size),
    nn.Embedding(num_embeddings=len(idx_to_token), embedding_dim=embed_size)
)
```

### 10.3.5.3 定义训练函数

下面定义训练函数。由于填充项的存在，与之前的训练函数相比，损失函数的计算稍有不同。

``` python
def train(net, lr, num_epochs):
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    print("train on", device)
    net = net.to(device)
    optimizer = torch.optim.Adam(net.parameters(), lr=lr)
    for epoch in range(num_epochs):
        start, l_sum, n = time.time(), 0.0, 0
        for batch in data_iter:
            center, context_negative, mask, label = [d.to(device) for d in batch]
            
            pred = skip_gram(center, context_negative, net[0], net[1])
            
            # 使用掩码变量mask来避免填充项对损失函数计算的影响
            l = (loss(pred.view(label.shape), label, mask) *
                 mask.shape[1] / mask.float().sum(dim=1)).mean() # 一个batch的平均loss
            optimizer.zero_grad()
            l.backward()
            optimizer.step()
            l_sum += l.cpu().item()
            n += 1
        print('epoch %d, loss %.2f, time %.2fs'
              % (epoch + 1, l_sum / n, time.time() - start))
```

现在我们就可以使用负采样训练跳字模型了。

``` python
train(net, 0.01, 10)
```
输出：
```
train on cpu
epoch 1, loss 1.97, time 74.53s
epoch 2, loss 0.62, time 81.85s
epoch 3, loss 0.45, time 74.49s
epoch 4, loss 0.39, time 72.04s
epoch 5, loss 0.37, time 72.21s
epoch 6, loss 0.35, time 71.81s
epoch 7, loss 0.34, time 72.00s
epoch 8, loss 0.33, time 74.45s
epoch 9, loss 0.32, time 72.08s
epoch 10, loss 0.32, time 72.05s
```

## 10.3.6 应用词嵌入模型

训练好词嵌入模型之后，我们可以根据两个词向量的余弦相似度表示词与词之间在语义上的相似度。可以看到，使用训练得到的词嵌入模型时，与词“chip”语义最接近的词大多与芯片有关。

``` python
def get_similar_tokens(query_token, k, embed):
    W = embed.weight.data
    x = W[token_to_idx[query_token]]
    # 添加的1e-9是为了数值稳定性
    cos = torch.matmul(W, x) / (torch.sum(W * W, dim=1) * torch.sum(x * x) + 1e-9).sqrt()
    _, topk = torch.topk(cos, k=k+1)
    topk = topk.cpu().numpy()
    for i in topk[1:]:  # 除去输入词
        print('cosine sim=%.3f: %s' % (cos[i], (idx_to_token[i])))
        
get_similar_tokens('chip', 3, net[0])
```
输出：
```
cosine sim=0.478: hard-disk
cosine sim=0.446: intel
cosine sim=0.440: drives
```

## 小结

* 可以使用PyTorch通过负采样训练跳字模型。
* 二次采样试图尽可能减轻高频词对训练词嵌入模型的影响。
* 可以将长度不同的样本填充至长度相同的小批量，并通过掩码变量区分非填充和填充，然后只令非填充参与损失函数的计算。


## 参考文献

[1] Penn Tree Bank. https://catalog.ldc.upenn.edu/LDC99T42

[2] Mikolov, T., Sutskever, I., Chen, K., Corrado, G. S., & Dean, J. (2013). Distributed representations of words and phrases and their compositionality. In Advances in neural information processing systems (pp. 3111-3119).


-----------
> 注：本节除代码外与原书基本相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/word2vec-gluon.html)# 10.4 子词嵌入（fastText）

英语单词通常有其内部结构和形成方式。例如，我们可以从“dog”“dogs”和“dogcatcher”的字面上推测它们的关系。这些词都有同一个词根“dog”，但使用不同的后缀来改变词的含义。而且，这个关联可以推广至其他词汇。例如，“dog”和“dogs”的关系如同“cat”和“cats”的关系，“boy”和“boyfriend”的关系如同“girl”和“girlfriend”的关系。这一特点并非为英语所独有。在法语和西班牙语中，很多动词根据场景不同有40多种不同的形态，而在芬兰语中，一个名词可能有15种以上的形态。事实上，构词学（morphology）作为语言学的一个重要分支，研究的正是词的内部结构和形成方式。

在word2vec中，我们并没有直接利用构词学中的信息。无论是在跳字模型还是连续词袋模型中，我们都将形态不同的单词用不同的向量来表示。例如，“dog”和“dogs”分别用两个不同的向量表示，而模型中并未直接表达这两个向量之间的关系。鉴于此，fastText提出了子词嵌入（subword embedding）的方法，从而试图将构词信息引入word2vec中的跳字模型 [1]。

在fastText中，每个中心词被表示成子词的集合。下面我们用单词“where”作为例子来了解子词是如何产生的。首先，我们在单词的首尾分别添加特殊字符“&lt;”和“&gt;”以区分作为前后缀的子词。然后，将单词当成一个由字符构成的序列来提取$n$元语法。例如，当$n=3$时，我们得到所有长度为3的子词：“&lt;wh&gt;”“whe”“her”“ere”“&lt;re&gt;”以及特殊子词“&lt;where&gt;”。

在fastText中，对于一个词$w$，我们将它所有长度在$3 \sim 6$的子词和特殊子词的并集记为$\mathcal{G}_w$。那么词典则是所有词的子词集合的并集。假设词典中子词$g$的向量为$\boldsymbol{z}_g$，那么跳字模型中词$w$的作为中心词的向量$\boldsymbol{v}_w$则表示成

$$
\boldsymbol{v}_w = \sum_{g\in\mathcal{G}_w} \boldsymbol{z}_g.
$$

fastText的其余部分同跳字模型一致，不在此重复。可以看到，与跳字模型相比，fastText中词典规模更大，造成模型参数更多，同时一个词的向量需要对所有子词向量求和，继而导致计算复杂度更高。但与此同时，较生僻的复杂单词，甚至是词典中没有的单词，可能会从同它结构类似的其他词那里获取更好的词向量表示。


## 小结

* fastText提出了子词嵌入方法。它在word2vec中的跳字模型的基础上，将中心词向量表示成单词的子词向量之和。
* 子词嵌入利用构词上的规律，通常可以提升生僻词表示的质量。



## 参考文献

[1] Bojanowski, P., Grave, E., Joulin, A., & Mikolov, T. (2016). Enriching word vectors with subword information. arXiv preprint arXiv:1607.04606.

-----------
> 注：本节与原书完全相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/fasttext.html)

# 10.5 全局向量的词嵌入（GloVe）

让我们先回顾一下word2vec中的跳字模型。将跳字模型中使用softmax运算表达的条件概率$P(w_j\mid w_i)$记作$q_{ij}$，即

$$
q_{ij}=\frac{\exp(\boldsymbol{u}_j^\top \boldsymbol{v}_i)}{ \sum_{k \in \mathcal{V}} \text{exp}(\boldsymbol{u}_k^\top \boldsymbol{v}_i)},
$$

其中$\boldsymbol{v}_i$和$\boldsymbol{u}_i$分别是索引为$i$的词$w_i$作为中心词和背景词时的向量表示，$\mathcal{V} = \{0, 1, \ldots, |\mathcal{V}|-1\}$为词典索引集。

对于词$w_i$，它在数据集中可能多次出现。我们将每一次以它作为中心词的所有背景词全部汇总并保留重复元素，记作多重集（multiset）$\mathcal{C}_i$。一个元素在多重集中的个数称为该元素的重数（multiplicity）。举例来说，假设词$w_i$在数据集中出现2次：文本序列中以这2个$w_i$作为中心词的背景窗口分别包含背景词索引$2,1,5,2$和$2,3,2,1$。那么多重集$\mathcal{C}_i = \{1,1,2,2,2,2,3,5\}$，其中元素1的重数为2，元素2的重数为4，元素3和5的重数均为1。将多重集$\mathcal{C}_i$中元素$j$的重数记作$x_{ij}$：它表示了整个数据集中所有以$w_i$为中心词的背景窗口中词$w_j$的个数。那么，跳字模型的损失函数还可以用另一种方式表达：

$$
-\sum_{i\in\mathcal{V}}\sum_{j\in\mathcal{V}} x_{ij} \log\,q_{ij}.
$$

我们将数据集中所有以词$w_i$为中心词的背景词的数量之和$\left|\mathcal{C}_i\right|$记为$x_i$，并将以$w_i$为中心词生成背景词$w_j$的条件概率$x_{ij}/x_i$记作$p_{ij}$。我们可以进一步改写跳字模型的损失函数为

$$
-\sum_{i\in\mathcal{V}} x_i \sum_{j\in\mathcal{V}} p_{ij} \log\,q_{ij}.
$$

上式中，$-\sum_{j\in\mathcal{V}} p_{ij} \log\,q_{ij}$计算的是以$w_i$为中心词的背景词条件概率分布$p_{ij}$和模型预测的条件概率分布$q_{ij}$的交叉熵，且损失函数使用所有以词$w_i$为中心词的背景词的数量之和来加权。最小化上式中的损失函数会令预测的条件概率分布尽可能接近真实的条件概率分布。

然而，作为常用损失函数的一种，交叉熵损失函数有时并不是好的选择。一方面，正如我们在10.2节（近似训练）中所提到的，令模型预测$q_{ij}$成为合法概率分布的代价是它在分母中基于整个词典的累加项。这很容易带来过大的计算开销。另一方面，词典中往往有大量生僻词，它们在数据集中出现的次数极少。而有关大量生僻词的条件概率分布在交叉熵损失函数中的最终预测往往并不准确。



## 10.5.1 GloVe模型

鉴于此，作为在word2vec之后提出的词嵌入模型，GloVe模型采用了平方损失，并基于该损失对跳字模型做了3点改动 [1]：

1. 使用非概率分布的变量$p'_{ij}=x_{ij}$和$q'_{ij}=\exp(\boldsymbol{u}_j^\top \boldsymbol{v}_i)$，并对它们取对数。因此，平方损失项是$\left(\log\,p'_{ij} - \log\,q'_{ij}\right)^2 = \left(\boldsymbol{u}_j^\top \boldsymbol{v}_i - \log\,x_{ij}\right)^2$。
2. 为每个词$w_i$增加两个为标量的模型参数：中心词偏差项$b_i$和背景词偏差项$c_i$。
3. 将每个损失项的权重替换成函数$h(x_{ij})$。权重函数$h(x)$是值域在$[0,1]$的单调递增函数。

如此一来，GloVe模型的目标是最小化损失函数

$$\sum_{i\in\mathcal{V}} \sum_{j\in\mathcal{V}} h(x_{ij}) \left(\boldsymbol{u}_j^\top \boldsymbol{v}_i + b_i + c_j - \log\,x_{ij}\right)^2.$$

其中权重函数$h(x)$的一个建议选择是：当$x < c$时（如$c = 100$），令$h(x) = (x/c)^\alpha$（如$\alpha = 0.75$），反之令$h(x) = 1$。因为$h(0)=0$，所以对于$x_{ij}=0$的平方损失项可以直接忽略。当使用小批量随机梯度下降来训练时，每个时间步我们随机采样小批量非零$x_{ij}$，然后计算梯度来迭代模型参数。这些非零$x_{ij}$是预先基于整个数据集计算得到的，包含了数据集的全局统计信息。因此，GloVe模型的命名取“全局向量”（Global Vectors）之意。

需要强调的是，如果词$w_i$出现在词$w_j$的背景窗口里，那么词$w_j$也会出现在词$w_i$的背景窗口里。也就是说，$x_{ij}=x_{ji}$。不同于word2vec中拟合的是非对称的条件概率$p_{ij}$，GloVe模型拟合的是对称的$\log\, x_{ij}$。因此，任意词的中心词向量和背景词向量在GloVe模型中是等价的。但由于初始化值的不同，同一个词最终学习到的两组词向量可能不同。当学习得到所有词向量以后，GloVe模型使用中心词向量与背景词向量之和作为该词的最终词向量。


## 10.5.2 从条件概率比值理解GloVe模型

我们还可以从另外一个角度来理解GloVe模型。沿用本节前面的符号，$P(w_j \mid w_i)$表示数据集中以$w_i$为中心词生成背景词$w_j$的条件概率，并记作$p_{ij}$。作为源于某大型语料库的真实例子，以下列举了两组分别以“ice”（冰）和“steam”（蒸汽）为中心词的条件概率以及它们之间的比值 [1]：

|$w_k$=|“solid”|“gas”|“water”|“fashion”|
|--:|:-:|:-:|:-:|:-:|
|$p_1=P(w_k\mid$ “ice” $)$|0.00019|0.000066|0.003|0.000017|
|$p_2=P(w_k\mid$ “steam” $)$|0.000022|0.00078|0.0022|0.000018|
|$p_1/p_2$|8.9|0.085|1.36|0.96|


我们可以观察到以下现象。

* 对于与“ice”相关而与“steam”不相关的词$w_k$，如$w_k=$“solid”（固体），我们期望条件概率比值较大，如上表最后一行中的值8.9；
* 对于与“ice”不相关而与“steam”相关的词$w_k$，如$w_k=$“gas”（气体），我们期望条件概率比值较小，如上表最后一行中的值0.085；
* 对于与“ice”和“steam”都相关的词$w_k$，如$w_k=$“water”（水），我们期望条件概率比值接近1，如上表最后一行中的值1.36；
* 对于与“ice”和“steam”都不相关的词$w_k$，如$w_k=$“fashion”（时尚），我们期望条件概率比值接近1，如上表最后一行中的值0.96。

由此可见，条件概率比值能比较直观地表达词与词之间的关系。我们可以构造一个词向量函数使它能有效拟合条件概率比值。我们知道，任意一个这样的比值需要3个词$w_i$、$w_j$和$w_k$。以$w_i$作为中心词的条件概率比值为${p_{ij}}/{p_{ik}}$。我们可以找一个函数，它使用词向量来拟合这个条件概率比值

$$
f(\boldsymbol{u}_j, \boldsymbol{u}_k, {\boldsymbol{v}}_i) \approx \frac{p_{ij}}{p_{ik}}.
$$

这里函数$f$可能的设计并不唯一，我们只需考虑一种较为合理的可能性。注意到条件概率比值是一个标量，我们可以将$f$限制为一个标量函数：$f(\boldsymbol{u}_j, \boldsymbol{u}_k, {\boldsymbol{v}}_i) = f\left((\boldsymbol{u}_j - \boldsymbol{u}_k)^\top {\boldsymbol{v}}_i\right)$。交换索引$j$和$k$后可以看到函数$f$应该满足$f(x)f(-x)=1$，因此一种可能是$f(x)=\exp(x)$，于是

$$f
(\boldsymbol{u}_j, \boldsymbol{u}_k, {\boldsymbol{v}}_i) = \frac{\exp\left(\boldsymbol{u}_j^\top {\boldsymbol{v}}_i\right)}{\exp\left(\boldsymbol{u}_k^\top {\boldsymbol{v}}_i\right)} \approx \frac{p_{ij}}{p_{ik}}.
$$

满足最右边约等号的一种可能是$\exp\left(\boldsymbol{u}_j^\top {\boldsymbol{v}}_i\right) \approx \alpha p_{ij}$，这里$\alpha$是一个常数。考虑到$p_{ij}=x_{ij}/x_i$，取对数后$\boldsymbol{u}_j^\top {\boldsymbol{v}}_i \approx \log\,\alpha + \log\,x_{ij} - \log\,x_i$。我们使用额外的偏差项来拟合$- \log\,\alpha + \log\,x_i$，例如，中心词偏差项$b_i$和背景词偏差项$c_j$：

$$
\boldsymbol{u}_j^\top \boldsymbol{v}_i + b_i + c_j \approx \log(x_{ij}).
$$

对上式左右两边取平方误差并加权，我们可以得到GloVe模型的损失函数。


## 小结

* 在有些情况下，交叉熵损失函数有劣势。GloVe模型采用了平方损失，并通过词向量拟合预先基于整个数据集计算得到的全局统计信息。
* 任意词的中心词向量和背景词向量在GloVe模型中是等价的。



## 参考文献

[1] Pennington, J., Socher, R., & Manning, C. (2014). Glove: Global vectors for word representation. In Proceedings of the 2014 conference on empirical methods in natural language processing (EMNLP) (pp. 1532-1543).


-----------
> 注：本节与原书完全相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/glove.html)


# 10.6 求近义词和类比词

在10.3节（word2vec的实现）中，我们在小规模数据集上训练了一个word2vec词嵌入模型，并通过词向量的余弦相似度搜索近义词。实际中，在大规模语料上预训练的词向量常常可以应用到下游自然语言处理任务中。本节将演示如何用这些预训练的词向量来求近义词和类比词。我们还将在后面两节中继续应用预训练的词向量。

## 10.6.1 使用预训练的词向量

基于PyTorch的关于自然语言处理的常用包有官方的[torchtext](https://github.com/pytorch/text)以及第三方的[pytorch-nlp](https://github.com/PetrochukM/PyTorch-NLP)等等。你可以使用`pip`很方便地按照它们，例如命令行执行
```
pip install torchtext
```
详情请参见其README。


本节我们使用torchtext进行练习。下面查看它目前提供的预训练词嵌入的名称。

``` python
import torch
import torchtext.vocab as vocab

vocab.pretrained_aliases.keys()
```
输出：
```
dict_keys(['charngram.100d', 'fasttext.en.300d', 'fasttext.simple.300d', 'glove.42B.300d', 'glove.840B.300d', 'glove.twitter.27B.25d', 'glove.twitter.27B.50d', 'glove.twitter.27B.100d', 'glove.twitter.27B.200d', 'glove.6B.50d', 'glove.6B.100d', 'glove.6B.200d', 'glove.6B.300d'])
```

下面查看查看该`glove`词嵌入提供了哪些预训练的模型。每个模型的词向量维度可能不同，或是在不同数据集上预训练得到的。

``` python
[key for key in vocab.pretrained_aliases.keys()
        if "glove" in key]
```
输出：
```
['glove.42B.300d',
 'glove.840B.300d',
 'glove.twitter.27B.25d',
 'glove.twitter.27B.50d',
 'glove.twitter.27B.100d',
 'glove.twitter.27B.200d',
 'glove.6B.50d',
 'glove.6B.100d',
 'glove.6B.200d',
 'glove.6B.300d']
```

预训练的GloVe模型的命名规范大致是“模型.（数据集.）数据集词数.词向量维度”。更多信息可以参考GloVe和fastText的项目网站[1,2]。下面我们使用基于维基百科子集预训练的50维GloVe词向量。第一次创建预训练词向量实例时会自动下载相应的词向量到`cache`指定文件夹（默认为`.vector_cache`），因此需要联网。

``` python
cache_dir = "/Users/tangshusen/Datasets/glove"
# glove = vocab.pretrained_aliases["glove.6B.50d"](cache=cache_dir)
glove = vocab.GloVe(name='6B', dim=50, cache=cache_dir) # 与上面等价
```
返回的实例主要有以下三个属性：
* `stoi`: 词到索引的字典：
* `itos`: 一个列表，索引到词的映射；
* `vectors`: 词向量。

打印词典大小。其中含有40万个词。

``` python
print("一共包含%d个词。" % len(glove.stoi))
```
输出：
```
一共包含400000个词。
```

我们可以通过词来获取它在词典中的索引，也可以通过索引获取词。

``` python
glove.stoi['beautiful'], glove.itos[3366] # (3366, 'beautiful')
```


## 10.6.2 应用预训练词向量

下面我们以GloVe模型为例，展示预训练词向量的应用。

### 10.6.2.1 求近义词

这里重新实现10.3节（word2vec的实现）中介绍过的使用余弦相似度来搜索近义词的算法。为了在求类比词时重用其中的求$k$近邻（$k$-nearest neighbors）的逻辑，我们将这部分逻辑单独封装在`knn`函数中。

``` python
def knn(W, x, k):
    # 添加的1e-9是为了数值稳定性
    cos = torch.matmul(W, x.view((-1,))) / (
        (torch.sum(W * W, dim=1) + 1e-9).sqrt() * torch.sum(x * x).sqrt())
    _, topk = torch.topk(cos, k=k)
    topk = topk.cpu().numpy()
    return topk, [cos[i].item() for i in topk]
```

然后，我们通过预训练词向量实例`embed`来搜索近义词。

``` python
def get_similar_tokens(query_token, k, embed):
    topk, cos = knn(embed.vectors,
                    embed.vectors[embed.stoi[query_token]], k+1)
    for i, c in zip(topk[1:], cos[1:]):  # 除去输入词
        print('cosine sim=%.3f: %s' % (c, (embed.itos[i])))
```

已创建的预训练词向量实例`glove_6b50d`的词典中含40万个词和1个特殊的未知词。除去输入词和未知词，我们从中搜索与“chip”语义最相近的3个词。

``` python
get_similar_tokens('chip', 3, glove)
```
输出：
```
cosine sim=0.856: chips
cosine sim=0.749: intel
cosine sim=0.749: electronics
```

接下来查找“baby”和“beautiful”的近义词。

``` python
get_similar_tokens('baby', 3, glove)
```
输出：
```
cosine sim=0.839: babies
cosine sim=0.800: boy
cosine sim=0.792: girl
```

``` python
get_similar_tokens('beautiful', 3, glove)
```
输出：
```
cosine sim=0.921: lovely
cosine sim=0.893: gorgeous
cosine sim=0.830: wonderful
```

### 10.6.2.2 求类比词

除了求近义词以外，我们还可以使用预训练词向量求词与词之间的类比关系。例如，“man”（男人）: “woman”（女人）:: “son”（儿子） : “daughter”（女儿）是一个类比例子：“man”之于“woman”相当于“son”之于“daughter”。求类比词问题可以定义为：对于类比关系中的4个词 $a : b :: c : d$，给定前3个词$a$、$b$和$c$，求$d$。设词$w$的词向量为$\text{vec}(w)$。求类比词的思路是，搜索与$\text{vec}(c)+\text{vec}(b)-\text{vec}(a)$的结果向量最相似的词向量。

``` python
def get_analogy(token_a, token_b, token_c, embed):
    vecs = [embed.vectors[embed.stoi[t]] 
                for t in [token_a, token_b, token_c]]
    x = vecs[1] - vecs[0] + vecs[2]
    topk, cos = knn(embed.vectors, x, 1)
    return embed.itos[topk[0]]
```

验证一下“男-女”类比。

``` python
get_analogy('man', 'woman', 'son', glove) # 'daughter'
```

“首都-国家”类比：“beijing”（北京）之于“china”（中国）相当于“tokyo”（东京）之于什么？答案应该是“japan”（日本）。

``` python
get_analogy('beijing', 'china', 'tokyo', glove) # 'japan'
```

“形容词-形容词最高级”类比：“bad”（坏的）之于“worst”（最坏的）相当于“big”（大的）之于什么？答案应该是“biggest”（最大的）。

``` python
get_analogy('bad', 'worst', 'big', glove) # 'biggest'
```

“动词一般时-动词过去时”类比：“do”（做）之于“did”（做过）相当于“go”（去）之于什么？答案应该是“went”（去过）。

``` python
get_analogy('do', 'did', 'go', glove) # 'went'
```

## 小结

* 在大规模语料上预训练的词向量常常可以应用于下游自然语言处理任务中。
* 可以应用预训练的词向量求近义词和类比词。



## 参考文献


[1] GloVe项目网站。 https://nlp.stanford.edu/projects/glove/

[2] fastText项目网站。 https://fasttext.cc/

-----------
> 注：本节除代码外与原书基本相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/similarity-analogy.html)
# 10.7 文本情感分类：使用循环神经网络

文本分类是自然语言处理的一个常见任务，它把一段不定长的文本序列变换为文本的类别。本节关注它的一个子问题：使用文本情感分类来分析文本作者的情绪。这个问题也叫情感分析，并有着广泛的应用。例如，我们可以分析用户对产品的评论并统计用户的满意度，或者分析用户对市场行情的情绪并用以预测接下来的行情。

同搜索近义词和类比词一样，文本分类也属于词嵌入的下游应用。在本节中，我们将应用预训练的词向量和含多个隐藏层的双向循环神经网络，来判断一段不定长的文本序列中包含的是正面还是负面的情绪。

在实验开始前，导入所需的包或模块。

``` python
import collections
import os
import random
import tarfile
import torch
from torch import nn
import torchtext.vocab as Vocab
import torch.utils.data as Data

import sys
sys.path.append("..") 
import d2lzh_pytorch as d2l

os.environ["CUDA_VISIBLE_DEVICES"] = "0"
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

DATA_ROOT = "/S1/CSCL/tangss/Datasets"
```

## 10.7.1 文本情感分类数据

我们使用斯坦福的IMDb数据集（Stanford's Large Movie Review Dataset）作为文本情感分类的数据集 [1]。这个数据集分为训练和测试用的两个数据集，分别包含25,000条从IMDb下载的关于电影的评论。在每个数据集中，标签为“正面”和“负面”的评论数量相等。

### 10.7.1.1 读取数据

首先[下载](http://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz)这个数据集到`DATA_ROOT`路径下，然后解压。

``` python
fname = os.path.join(DATA_ROOT, "aclImdb_v1.tar.gz")
if not os.path.exists(os.path.join(DATA_ROOT, "aclImdb")):
    print("从压缩包解压...")
    with tarfile.open(fname, 'r') as f:
        f.extractall(DATA_ROOT)
```

接下来，读取训练数据集和测试数据集。每个样本是一条评论及其对应的标签：1表示“正面”，0表示“负面”。

``` python
from tqdm import tqdm
# 本函数已保存在d2lzh_pytorch包中方便以后使用
def read_imdb(folder='train', data_root="/S1/CSCL/tangss/Datasets/aclImdb"): 
    data = []
    for label in ['pos', 'neg']:
        folder_name = os.path.join(data_root, folder, label)
        for file in tqdm(os.listdir(folder_name)):
            with open(os.path.join(folder_name, file), 'rb') as f:
                review = f.read().decode('utf-8').replace('\n', '').lower()
                data.append([review, 1 if label == 'pos' else 0])
    random.shuffle(data)
    return data

train_data, test_data = read_imdb('train'), read_imdb('test')
```

### 10.7.1.2 预处理数据

我们需要对每条评论做分词，从而得到分好词的评论。这里定义的`get_tokenized_imdb`函数使用最简单的方法：基于空格进行分词。

``` python
# 本函数已保存在d2lzh_pytorch包中方便以后使用
def get_tokenized_imdb(data):
    """
    data: list of [string, label]
    """
    def tokenizer(text):
        return [tok.lower() for tok in text.split(' ')]
    return [tokenizer(review) for review, _ in data]
```

现在，我们可以根据分好词的训练数据集来创建词典了。我们在这里过滤掉了出现次数少于5的词。

``` python
# 本函数已保存在d2lzh_pytorch包中方便以后使用
def get_vocab_imdb(data):
    tokenized_data = get_tokenized_imdb(data)
    counter = collections.Counter([tk for st in tokenized_data for tk in st])
    return Vocab.Vocab(counter, min_freq=5)

vocab = get_vocab_imdb(train_data)
'# words in vocab:', len(vocab)
```
输出：
```
('# words in vocab:', 46151)
```

因为每条评论长度不一致所以不能直接组合成小批量，我们定义`preprocess_imdb`函数对每条评论进行分词，并通过词典转换成词索引，然后通过截断或者补0来将每条评论长度固定成500。

``` python
# 本函数已保存在d2lzh_torch包中方便以后使用
def preprocess_imdb(data, vocab):
    max_l = 500  # 将每条评论通过截断或者补0，使得长度变成500

    def pad(x):
        return x[:max_l] if len(x) > max_l else x + [0] * (max_l - len(x))

    tokenized_data = get_tokenized_imdb(data)
    features = torch.tensor([pad([vocab.stoi[word] for word in words]) for words in tokenized_data])
    labels = torch.tensor([score for _, score in data])
    return features, labels
```

### 10.7.1.3 创建数据迭代器

现在，我们创建数据迭代器。每次迭代将返回一个小批量的数据。

``` python
batch_size = 64
train_set = Data.TensorDataset(*preprocess_imdb(train_data, vocab))
test_set = Data.TensorDataset(*preprocess_imdb(test_data, vocab))
train_iter = Data.DataLoader(train_set, batch_size, shuffle=True)
test_iter = Data.DataLoader(test_set, batch_size)
```

打印第一个小批量数据的形状以及训练集中小批量的个数。

``` python
for X, y in train_iter:
    print('X', X.shape, 'y', y.shape)
    break
'#batches:', len(train_iter)
```
输出：
```
X torch.Size([64, 500]) y torch.Size([64])
('#batches:', 391)
```

## 10.7.2 使用循环神经网络的模型

在这个模型中，每个词先通过嵌入层得到特征向量。然后，我们使用双向循环神经网络对特征序列进一步编码得到序列信息。最后，我们将编码的序列信息通过全连接层变换为输出。具体来说，我们可以将双向长短期记忆在最初时间步和最终时间步的隐藏状态连结，作为特征序列的表征传递给输出层分类。在下面实现的`BiRNN`类中，`Embedding`实例即嵌入层，`LSTM`实例即为序列编码的隐藏层，`Linear`实例即生成分类结果的输出层。

``` python
class BiRNN(nn.Module):
    def __init__(self, vocab, embed_size, num_hiddens, num_layers):
        super(BiRNN, self).__init__()
        self.embedding = nn.Embedding(len(vocab), embed_size)
        # bidirectional设为True即得到双向循环神经网络
        self.encoder = nn.LSTM(input_size=embed_size, 
                                hidden_size=num_hiddens, 
                                num_layers=num_layers,
                                bidirectional=True)
        # 初始时间步和最终时间步的隐藏状态作为全连接层输入
        self.decoder = nn.Linear(4*num_hiddens, 2)

    def forward(self, inputs):
        # inputs的形状是(批量大小, 词数)，因为LSTM需要将序列长度(seq_len)作为第一维，所以将输入转置后
        # 再提取词特征，输出形状为(词数, 批量大小, 词向量维度)
        embeddings = self.embedding(inputs.permute(1, 0))
        # rnn.LSTM只传入输入embeddings，因此只返回最后一层的隐藏层在各时间步的隐藏状态。
        # outputs形状是(词数, 批量大小, 2 * 隐藏单元个数)
        outputs, _ = self.encoder(embeddings) # output, (h, c)
        # 连结初始时间步和最终时间步的隐藏状态作为全连接层输入。它的形状为
        # (批量大小, 4 * 隐藏单元个数)。
        encoding = torch.cat((outputs[0], outputs[-1]), -1)
        outs = self.decoder(encoding)
        return outs
```

创建一个含两个隐藏层的双向循环神经网络。

``` python
embed_size, num_hiddens, num_layers = 100, 100, 2
net = BiRNN(vocab, embed_size, num_hiddens, num_layers)
```


### 10.7.2.1 加载预训练的词向量

由于情感分类的训练数据集并不是很大，为应对过拟合，我们将直接使用在更大规模语料上预训练的词向量作为每个词的特征向量。这里，我们为词典`vocab`中的每个词加载100维的GloVe词向量。

``` python
glove_vocab = Vocab.GloVe(name='6B', dim=100, cache=os.path.join(DATA_ROOT, "glove"))
```

然后，我们将用这些词向量作为评论中每个词的特征向量。注意，预训练词向量的维度需要与创建的模型中的嵌入层输出大小`embed_size`一致。此外，在训练中我们不再更新这些词向量。

``` python
# 本函数已保存在d2lzh_torch包中方便以后使用
def load_pretrained_embedding(words, pretrained_vocab):
    """从预训练好的vocab中提取出words对应的词向量"""
    embed = torch.zeros(len(words), pretrained_vocab.vectors[0].shape[0]) # 初始化为0
    oov_count = 0 # out of vocabulary
    for i, word in enumerate(words):
        try:
            idx = pretrained_vocab.stoi[word]
            embed[i, :] = pretrained_vocab.vectors[idx]
        except KeyError:
            oov_count += 0
    if oov_count > 0:
        print("There are %d oov words.")
    return embed

net.embedding.weight.data.copy_(
    load_pretrained_embedding(vocab.itos, glove_vocab))
net.embedding.weight.requires_grad = False # 直接加载预训练好的, 所以不需要更新它
```

### 10.7.2.2 训练并评价模型

这时候就可以开始训练模型了。

``` python
lr, num_epochs = 0.01, 5
# 要过滤掉不计算梯度的embedding参数
optimizer = torch.optim.Adam(filter(lambda p: p.requires_grad, net.parameters()), lr=lr)
loss = nn.CrossEntropyLoss()
d2l.train(train_iter, test_iter, net, loss, optimizer, device, num_epochs)
```
输出：
```
training on  cuda
epoch 1, loss 0.5759, train acc 0.666, test acc 0.832, time 250.8 sec
epoch 2, loss 0.1785, train acc 0.842, test acc 0.852, time 253.3 sec
epoch 3, loss 0.1042, train acc 0.866, test acc 0.856, time 253.7 sec
epoch 4, loss 0.0682, train acc 0.888, test acc 0.868, time 254.2 sec
epoch 5, loss 0.0483, train acc 0.901, test acc 0.862, time 251.4 sec
```

最后，定义预测函数。

``` python
# 本函数已保存在d2lzh_pytorch包中方便以后使用
def predict_sentiment(net, vocab, sentence):
    """sentence是词语的列表"""
    device = list(net.parameters())[0].device
    sentence = torch.tensor([vocab.stoi[word] for word in sentence], device=device)
    label = torch.argmax(net(sentence.view((1, -1))), dim=1)
    return 'positive' if label.item() == 1 else 'negative'
```

下面使用训练好的模型对两个简单句子的情感进行分类。

``` python
predict_sentiment(net, vocab, ['this', 'movie', 'is', 'so', 'great']) # positive
```

``` python
predict_sentiment(net, vocab, ['this', 'movie', 'is', 'so', 'bad']) # negative
```

## 小结

* 文本分类把一段不定长的文本序列变换为文本的类别。它属于词嵌入的下游应用。
* 可以应用预训练的词向量和循环神经网络对文本的情感进行分类。


## 参考文献

[1] Maas, A. L., Daly, R. E., Pham, P. T., Huang, D., Ng, A. Y., & Potts, C. (2011, June). Learning word vectors for sentiment analysis. In Proceedings of the 49th annual meeting of the association for computational linguistics: Human language technologies-volume 1 (pp. 142-150). Association for Computational Linguistics.


-----------
> 注：本节除代码外与原书基本相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/sentiment-analysis-rnn.html)
# 10.8 文本情感分类：使用卷积神经网络（textCNN）

在“卷积神经网络”一章中我们探究了如何使用二维卷积神经网络来处理二维图像数据。在之前的语言模型和文本分类任务中，我们将文本数据看作是只有一个维度的时间序列，并很自然地使用循环神经网络来表征这样的数据。其实，我们也可以将文本当作一维图像，从而可以用一维卷积神经网络来捕捉临近词之间的关联。本节将介绍将卷积神经网络应用到文本分析的开创性工作之一：textCNN [1]。

首先导入实验所需的包和模块。

``` python
import os
import torch
from torch import nn
import torchtext.vocab as Vocab
import torch.utils.data as Data
import  torch.nn.functional as F

import sys
sys.path.append("..") 
import d2lzh_pytorch as d2l

os.environ["CUDA_VISIBLE_DEVICES"] = "0"
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

DATA_ROOT = "/S1/CSCL/tangss/Datasets"
```

## 10.8.1 一维卷积层

在介绍模型前我们先来解释一维卷积层的工作原理。与二维卷积层一样，一维卷积层使用一维的互相关运算。在一维互相关运算中，卷积窗口从输入数组的最左方开始，按从左往右的顺序，依次在输入数组上滑动。当卷积窗口滑动到某一位置时，窗口中的输入子数组与核数组按元素相乘并求和，得到输出数组中相应位置的元素。如图10.4所示，输入是一个宽为7的一维数组，核数组的宽为2。可以看到输出的宽度为$7-2+1=6$，且第一个元素是由输入的最左边的宽为2的子数组与核数组按元素相乘后再相加得到的：$0\times1+1\times2=2$。

<div align=center>
<img width="500" src="../../img/chapter10/10.8_conv1d.svg"/>
</div>
<div align=center>图10.4 一维互相关运算</div>

下面我们将一维互相关运算实现在`corr1d`函数里。它接受输入数组`X`和核数组`K`，并输出数组`Y`。

``` python
def corr1d(X, K):
    w = K.shape[0]
    Y = torch.zeros((X.shape[0] - w + 1))
    for i in range(Y.shape[0]):
        Y[i] = (X[i: i + w] * K).sum()
    return Y
```

让我们复现图10.4中一维互相关运算的结果。

``` python
X, K = torch.tensor([0, 1, 2, 3, 4, 5, 6]), torch.tensor([1, 2])
corr1d(X, K)
```
输出：
```
tensor([ 2.,  5.,  8., 11., 14., 17.])
```

多输入通道的一维互相关运算也与多输入通道的二维互相关运算类似：在每个通道上，将核与相应的输入做一维互相关运算，并将通道之间的结果相加得到输出结果。图10.5展示了含3个输入通道的一维互相关运算，其中阴影部分为第一个输出元素及其计算所使用的输入和核数组元素：$0\times1+1\times2+1\times3+2\times4+2\times(-1)+3\times(-3)=2$。

<div align=center>
<img width="500" src="../../img/chapter10/10.8_conv1d-channel.svg"/>
</div>
<div align=center>图10.5 含3个输入通道的一维互相关运算</div>

让我们复现图10.5中多输入通道的一维互相关运算的结果。

``` python
def corr1d_multi_in(X, K):
    # 首先沿着X和K的第0维（通道维）遍历并计算一维互相关结果。然后将所有结果堆叠起来沿第0维累加
    return torch.stack([corr1d(x, k) for x, k in zip(X, K)]).sum(dim=0)

X = torch.tensor([[0, 1, 2, 3, 4, 5, 6],
              [1, 2, 3, 4, 5, 6, 7],
              [2, 3, 4, 5, 6, 7, 8]])
K = torch.tensor([[1, 2], [3, 4], [-1, -3]])
corr1d_multi_in(X, K)
```
输出：
```
tensor([ 2.,  8., 14., 20., 26., 32.])
```

由二维互相关运算的定义可知，多输入通道的一维互相关运算可以看作单输入通道的二维互相关运算。如图10.6所示，我们也可以将图10.5中多输入通道的一维互相关运算以等价的单输入通道的二维互相关运算呈现。这里核的高等于输入的高。图10.6中的阴影部分为第一个输出元素及其计算所使用的输入和核数组元素：$2\times(-1)+3\times(-3)+1\times3+2\times4+0\times1+1\times2=2$。

<div align=center>
<img width="500" src="../../img/chapter10/10.8_conv1d-2d.svg"/>
</div>
<div align=center>图10.6 单输入通道的二维互相关运算</div>

图10.4和图10.5中的输出都只有一个通道。我们在5.3节（多输入通道和多输出通道）一节中介绍了如何在二维卷积层中指定多个输出通道。类似地，我们也可以在一维卷积层指定多个输出通道，从而拓展卷积层中的模型参数。


## 10.8.2 时序最大池化层

类似地，我们有一维池化层。textCNN中使用的时序最大池化（max-over-time pooling）层实际上对应一维全局最大池化层：假设输入包含多个通道，各通道由不同时间步上的数值组成，各通道的输出即该通道所有时间步中最大的数值。因此，时序最大池化层的输入在各个通道上的时间步数可以不同。

为提升计算性能，我们常常将不同长度的时序样本组成一个小批量，并通过在较短序列后附加特殊字符（如0）令批量中各时序样本长度相同。这些人为添加的特殊字符当然是无意义的。由于时序最大池化的主要目的是抓取时序中最重要的特征，它通常能使模型不受人为添加字符的影响。

由于PyTorch没有自带全局的最大池化层，所以类似5.8节我们可以通过普通的池化来实现全局池化。
``` python
class GlobalMaxPool1d(nn.Module):
    def __init__(self):
        super(GlobalMaxPool1d, self).__init__()
    def forward(self, x):
         # x shape: (batch_size, channel, seq_len)
         # return shape: (batch_size, channel, 1)
        return F.max_pool1d(x, kernel_size=x.shape[2])
```

## 10.8.3 读取和预处理IMDb数据集

我们依然使用和上一节中相同的IMDb数据集做情感分析。以下读取和预处理数据集的步骤与上一节中的相同。

``` python
batch_size = 64
train_data = d2l.read_imdb('train', data_root=os.path.join(DATA_ROOT, "aclImdb"))
test_data = d2l.read_imdb('test', data_root=os.path.join(DATA_ROOT, "aclImdb"))
vocab = d2l.get_vocab_imdb(train_data)
train_set = Data.TensorDataset(*d2l.preprocess_imdb(train_data, vocab))
test_set = Data.TensorDataset(*d2l.preprocess_imdb(test_data, vocab))
train_iter = Data.DataLoader(train_set, batch_size, shuffle=True)
test_iter = Data.DataLoader(test_set, batch_size)
```

## 10.8.4 textCNN模型

textCNN模型主要使用了一维卷积层和时序最大池化层。假设输入的文本序列由$n$个词组成，每个词用$d$维的词向量表示。那么输入样本的宽为$n$，高为1，输入通道数为$d$。textCNN的计算主要分为以下几步。

1. 定义多个一维卷积核，并使用这些卷积核对输入分别做卷积计算。宽度不同的卷积核可能会捕捉到不同个数的相邻词的相关性。
2. 对输出的所有通道分别做时序最大池化，再将这些通道的池化输出值连结为向量。
3. 通过全连接层将连结后的向量变换为有关各类别的输出。这一步可以使用丢弃层应对过拟合。

图10.7用一个例子解释了textCNN的设计。这里的输入是一个有11个词的句子，每个词用6维词向量表示。因此输入序列的宽为11，输入通道数为6。给定2个一维卷积核，核宽分别为2和4，输出通道数分别设为4和5。因此，一维卷积计算后，4个输出通道的宽为$11-2+1=10$，而其他5个通道的宽为$11-4+1=8$。尽管每个通道的宽不同，我们依然可以对各个通道做时序最大池化，并将9个通道的池化输出连结成一个9维向量。最终，使用全连接将9维向量变换为2维输出，即正面情感和负面情感的预测。

<div align=center>
<img width="500" src="../../img/chapter10/10.8_textcnn.svg"/>
</div>
<div align=center>图10.7 textCNN的设计</div>


下面我们来实现textCNN模型。与上一节相比，除了用一维卷积层替换循环神经网络外，这里我们还使用了两个嵌入层，一个的权重固定，另一个则参与训练。

``` python
class TextCNN(nn.Module):
    def __init__(self, vocab, embed_size, kernel_sizes, num_channels):
        super(TextCNN, self).__init__()
        self.embedding = nn.Embedding(len(vocab), embed_size)
        # 不参与训练的嵌入层
        self.constant_embedding = nn.Embedding(len(vocab), embed_size)
        self.dropout = nn.Dropout(0.5)
        self.decoder = nn.Linear(sum(num_channels), 2)
        # 时序最大池化层没有权重，所以可以共用一个实例
        self.pool = GlobalMaxPool1d()
        self.convs = nn.ModuleList()  # 创建多个一维卷积层
        for c, k in zip(num_channels, kernel_sizes):
            self.convs.append(nn.Conv1d(in_channels = 2*embed_size, 
                                        out_channels = c, 
                                        kernel_size = k))

    def forward(self, inputs):
        # 将两个形状是(批量大小, 词数, 词向量维度)的嵌入层的输出按词向量连结
        embeddings = torch.cat((
            self.embedding(inputs), 
            self.constant_embedding(inputs)), dim=2) # (batch, seq_len, 2*embed_size)
        # 根据Conv1D要求的输入格式，将词向量维，即一维卷积层的通道维(即词向量那一维)，变换到前一维
        embeddings = embeddings.permute(0, 2, 1)
        # 对于每个一维卷积层，在时序最大池化后会得到一个形状为(批量大小, 通道大小, 1)的
        # Tensor。使用flatten函数去掉最后一维，然后在通道维上连结
        encoding = torch.cat([self.pool(F.relu(conv(embeddings))).squeeze(-1) for conv in self.convs], dim=1)
        # 应用丢弃法后使用全连接层得到输出
        outputs = self.decoder(self.dropout(encoding))
        return outputs
```

创建一个`TextCNN`实例。它有3个卷积层，它们的核宽分别为3、4和5，输出通道数均为100。

``` python
embed_size, kernel_sizes, nums_channels = 100, [3, 4, 5], [100, 100, 100]
net = TextCNN(vocab, embed_size, kernel_sizes, nums_channels)
```

### 10.8.4.1 加载预训练的词向量

同上一节一样，加载预训练的100维GloVe词向量，并分别初始化嵌入层`embedding`和`constant_embedding`，前者参与训练，而后者权重固定。

``` python
glove_vocab = Vocab.GloVe(name='6B', dim=100,
                        cache=os.path.join(DATA_ROOT, "glove"))
net.embedding.weight.data.copy_(
    d2l.load_pretrained_embedding(vocab.itos, glove_vocab))
net.constant_embedding.weight.data.copy_(
    d2l.load_pretrained_embedding(vocab.itos, glove_vocab))
net.constant_embedding.weight.requires_grad = False
```

### 10.8.4.2 训练并评价模型

现在就可以训练模型了。

``` python
lr, num_epochs = 0.001, 5
optimizer = torch.optim.Adam(filter(lambda p: p.requires_grad, net.parameters()), lr=lr)
loss = nn.CrossEntropyLoss()
d2l.train(train_iter, test_iter, net, loss, optimizer, device, num_epochs)
```
输出：
```
training on  cuda
epoch 1, loss 0.4858, train acc 0.758, test acc 0.832, time 42.8 sec
epoch 2, loss 0.1598, train acc 0.863, test acc 0.868, time 42.3 sec
epoch 3, loss 0.0694, train acc 0.917, test acc 0.876, time 42.3 sec
epoch 4, loss 0.0301, train acc 0.956, test acc 0.871, time 42.4 sec
epoch 5, loss 0.0131, train acc 0.979, test acc 0.865, time 42.3 sec
```

下面，我们使用训练好的模型对两个简单句子的情感进行分类。

``` python 
d2l.predict_sentiment(net, vocab, ['this', 'movie', 'is', 'so', 'great']) # positive
```

``` python
d2l.predict_sentiment(net, vocab, ['this', 'movie', 'is', 'so', 'bad']) # negative
```

## 小结

* 可以使用一维卷积来表征时序数据。
* 多输入通道的一维互相关运算可以看作单输入通道的二维互相关运算。
* 时序最大池化层的输入在各个通道上的时间步数可以不同。
* textCNN主要使用了一维卷积层和时序最大池化层。


## 参考文献

[1] Kim, Y. (2014). Convolutional neural networks for sentence classification. arXiv preprint arXiv:1408.5882.


-----------
> 注：本节除代码外与原书基本相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/sentiment-analysis-cnn.html)
# 10.9 编码器—解码器（seq2seq）

我们已经在前两节中表征并变换了不定长的输入序列。但在自然语言处理的很多应用中，输入和输出都可以是不定长序列。以机器翻译为例，输入可以是一段不定长的英语文本序列，输出可以是一段不定长的法语文本序列，例如

> 英语输入：“They”、“are”、“watching”、“.”

> 法语输出：“Ils”、“regardent”、“.”

当输入和输出都是不定长序列时，我们可以使用编码器—解码器（encoder-decoder）[1] 或者seq2seq模型 [2]。这两个模型本质上都用到了两个循环神经网络，分别叫做编码器和解码器。编码器用来分析输入序列，解码器用来生成输出序列。

图10.8描述了使用编码器—解码器将上述英语句子翻译成法语句子的一种方法。在训练数据集中，我们可以在每个句子后附上特殊符号“&lt;eos&gt;”（end of sequence）以表示序列的终止。编码器每个时间步的输入依次为英语句子中的单词、标点和特殊符号“&lt;eos&gt;”。图10.8中使用了编码器在最终时间步的隐藏状态作为输入句子的表征或编码信息。解码器在各个时间步中使用输入句子的编码信息和上个时间步的输出以及隐藏状态作为输入。我们希望解码器在各个时间步能正确依次输出翻译后的法语单词、标点和特殊符号"&lt;eos&gt;"。需要注意的是，解码器在最初时间步的输入用到了一个表示序列开始的特殊符号"&lt;bos&gt;"（beginning of sequence）。

<div align=center>
<img width="500" src="../../img/chapter10/10.9_seq2seq.svg"/>
</div>
<div align=center>图10.8 使用编码器—解码器将句子由英语翻译成法语。编码器和解码器分别为循环神经网络</div>


接下来，我们分别介绍编码器和解码器的定义。

## 10.9.1 编码器

编码器的作用是把一个不定长的输入序列变换成一个定长的背景变量$\boldsymbol{c}$，并在该背景变量中编码输入序列信息。常用的编码器是循环神经网络。

让我们考虑批量大小为1的时序数据样本。假设输入序列是$x_1,\ldots,x_T$，例如$x_i$是输入句子中的第$i$个词。在时间步$t$，循环神经网络将输入$x_t$的特征向量$\boldsymbol{x}_t$和上个时间步的隐藏状态$\boldsymbol{h}_{t-1}$变换为当前时间步的隐藏状态$\boldsymbol{h}_t$。我们可以用函数$f$表达循环神经网络隐藏层的变换：

$$
\boldsymbol{h}_t = f(\boldsymbol{x}_t, \boldsymbol{h}_{t-1}).
$$

接下来，编码器通过自定义函数$q$将各个时间步的隐藏状态变换为背景变量

$$
\boldsymbol{c} =  q(\boldsymbol{h}_1, \ldots, \boldsymbol{h}_T).
$$

例如，当选择$q(\boldsymbol{h}_1, \ldots, \boldsymbol{h}_T) = \boldsymbol{h}_T$时，背景变量是输入序列最终时间步的隐藏状态$\boldsymbol{h}_T$。

以上描述的编码器是一个单向的循环神经网络，每个时间步的隐藏状态只取决于该时间步及之前的输入子序列。我们也可以使用双向循环神经网络构造编码器。在这种情况下，编码器每个时间步的隐藏状态同时取决于该时间步之前和之后的子序列（包括当前时间步的输入），并编码了整个序列的信息。


## 10.9.2 解码器

刚刚已经介绍，编码器输出的背景变量$\boldsymbol{c}$编码了整个输入序列$x_1, \ldots, x_T$的信息。给定训练样本中的输出序列$y_1, y_2, \ldots, y_{T'}$，对每个时间步$t'$（符号与输入序列或编码器的时间步$t$有区别），解码器输出$y_{t'}$的条件概率将基于之前的输出序列$y_1,\ldots,y_{t'-1}$和背景变量$\boldsymbol{c}$，即$P(y_{t'} \mid y_1, \ldots, y_{t'-1}, \boldsymbol{c})$。

为此，我们可以使用另一个循环神经网络作为解码器。在输出序列的时间步$t^\prime$，解码器将上一时间步的输出$y_{t^\prime-1}$以及背景变量$\boldsymbol{c}$作为输入，并将它们与上一时间步的隐藏状态$\boldsymbol{s}_{t^\prime-1}$变换为当前时间步的隐藏状态$\boldsymbol{s}_{t^\prime}$。因此，我们可以用函数$g$表达解码器隐藏层的变换：

$$
\boldsymbol{s}_{t^\prime} = g(y_{t^\prime-1}, \boldsymbol{c}, \boldsymbol{s}_{t^\prime-1}).
$$

有了解码器的隐藏状态后，我们可以使用自定义的输出层和softmax运算来计算$P(y_{t^\prime} \mid y_1, \ldots, y_{t^\prime-1}, \boldsymbol{c})$，例如，基于当前时间步的解码器隐藏状态 $\boldsymbol{s}_{t^\prime}$、上一时间步的输出$y_{t^\prime-1}$以及背景变量$\boldsymbol{c}$来计算当前时间步输出$y_{t^\prime}$的概率分布。


## 10.9.3 训练模型

根据最大似然估计，我们可以最大化输出序列基于输入序列的条件概率

$$
\begin{aligned}
P(y_1, \ldots, y_{T'} \mid x_1, \ldots, x_T)
&= \prod_{t'=1}^{T'} P(y_{t'} \mid y_1, \ldots, y_{t'-1}, x_1, \ldots, x_T)\\
&= \prod_{t'=1}^{T'} P(y_{t'} \mid y_1, \ldots, y_{t'-1}, \boldsymbol{c}),
\end{aligned}
$$

并得到该输出序列的损失

$$
-\log P(y_1, \ldots, y_{T'} \mid x_1, \ldots, x_T) = -\sum_{t'=1}^{T'} \log P(y_{t'} \mid y_1, \ldots, y_{t'-1}, \boldsymbol{c}),
$$

在模型训练中，所有输出序列损失的均值通常作为需要最小化的损失函数。在图10.8所描述的模型预测中，我们需要将解码器在上一个时间步的输出作为当前时间步的输入。与此不同，在训练中我们也可以将标签序列（训练集的真实输出序列）在上一个时间步的标签作为解码器在当前时间步的输入。这叫作强制教学（teacher forcing）。


## 小结

* 编码器-解码器（seq2seq）可以输入并输出不定长的序列。
* 编码器—解码器使用了两个循环神经网络。
* 在编码器—解码器的训练中，可以采用强制教学。



## 参考文献

[1] Cho, K., Van Merriënboer, B., Gulcehre, C., Bahdanau, D., Bougares, F., Schwenk, H., & Bengio, Y. (2014). Learning phrase representations using RNN encoder-decoder for statistical machine translation. arXiv preprint arXiv:1406.1078.

[2] Sutskever, I., Vinyals, O., & Le, Q. V. (2014). Sequence to sequence learning with neural networks. In Advances in neural information processing systems (pp. 3104-3112).

-----------
> 注：本节与原书基本相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/seq2seq.html)
# 10.10 束搜索

上一节介绍了如何训练输入和输出均为不定长序列的编码器—解码器。本节我们介绍如何使用编码器—解码器来预测不定长的序列。

上一节里已经提到，在准备训练数据集时，我们通常会在样本的输入序列和输出序列后面分别附上一个特殊符号"&lt;eos&gt;"表示序列的终止。我们在接下来的讨论中也将沿用上一节的全部数学符号。为了便于讨论，假设解码器的输出是一段文本序列。设输出文本词典$\mathcal{Y}$（包含特殊符号"&lt;eos&gt;"）的大小为$\left|\mathcal{Y}\right|$，输出序列的最大长度为$T'$。所有可能的输出序列一共有$\mathcal{O}(\left|\mathcal{Y}\right|^{T'})$种。这些输出序列中所有特殊符号"&lt;eos&gt;"后面的子序列将被舍弃。


## 10.10.1 贪婪搜索

让我们先来看一个简单的解决方案：贪婪搜索（greedy search）。对于输出序列任一时间步$t'$，我们从$|\mathcal{Y}|$个词中搜索出条件概率最大的词

$$
y _ { t ^ { \prime } } = \underset { y \in \mathcal { Y } } { \operatorname { argmax } } P \left( y | y _ { 1 } , \ldots , y _ { t ^ { \prime } - 1 } , c \right)
$$

作为输出。一旦搜索出"&lt;eos&gt;"符号，或者输出序列长度已经达到了最大长度$T'$，便完成输出。

我们在描述解码器时提到，基于输入序列生成输出序列的条件概率是$\prod_{t'=1}^{T'} P(y_{t'} \mid y_1, \ldots, y_{t'-1}, \boldsymbol{c})$。我们将该条件概率最大的输出序列称为最优输出序列。而贪婪搜索的主要问题是不能保证得到最优输出序列。

下面来看一个例子。假设输出词典里面有“A”“B”“C”和“&lt;eos&gt;”这4个词。图10.9中每个时间步下的4个数字分别代表了该时间步生成“A”“B”“C”和“&lt;eos&gt;”这4个词的条件概率。在每个时间步，贪婪搜索选取条件概率最大的词。因此，图10.9中将生成输出序列“A”“B”“C”“&lt;eos&gt;”。该输出序列的条件概率是$0.5\times0.4\times0.4\times0.6 = 0.048$。

<div align=center>
<img width="200" src="../../img/chapter10/10.10_s2s_prob1.svg"/>
</div>
<div align=center>图10.9 在每个时间步，贪婪搜索选取条件概率最大的词</div>


接下来，观察图10.10演示的例子。与图10.9中不同，图10.10在时间步2中选取了条件概率第二大的词“C”。由于时间步3所基于的时间步1和2的输出子序列由图10.9中的“A”“B”变为了图10.10中的“A”“C”，图10.10中时间步3生成各个词的条件概率发生了变化。我们选取条件概率最大的词“B”。此时时间步4所基于的前3个时间步的输出子序列为“A”“C”“B”，与图10.9中的“A”“B”“C”不同。因此，图10.10中时间步4生成各个词的条件概率也与图10.9中的不同。我们发现，此时的输出序列“A”“C”“B”“&lt;eos&gt;”的条件概率是$0.5\times0.3\times0.6\times0.6=0.054$，大于贪婪搜索得到的输出序列的条件概率。因此，贪婪搜索得到的输出序列“A”“B”“C”“&lt;eos&gt;”并非最优输出序列。

<div align=center>
<img width="200" src="../../img/chapter10/10.10_s2s_prob2.svg"/>
</div>
<div align=center>图10.10 在时间步2选取条件概率第二大的词“C”</div>


## 10.10.2 穷举搜索

如果目标是得到最优输出序列，我们可以考虑穷举搜索（exhaustive search）：穷举所有可能的输出序列，输出条件概率最大的序列。

虽然穷举搜索可以得到最优输出序列，但它的计算开销$\mathcal{O}(\left|\mathcal{Y}\right|^{T'})$很容易过大。例如，当$|\mathcal{Y}|=10000$且$T'=10$时，我们将评估$10000^{10} = 10^{40}$个序列：这几乎不可能完成。而贪婪搜索的计算开销是$\mathcal{O}(\left|\mathcal{Y}\right|T')$，通常显著小于穷举搜索的计算开销。例如，当$|\mathcal{Y}|=10000$且$T'=10$时，我们只需评估$10000\times10=10^5$个序列。


## 10.10.3 束搜索

束搜索（beam search）是对贪婪搜索的一个改进算法。它有一个束宽（beam size）超参数。我们将它设为$k$。在时间步1时，选取当前时间步条件概率最大的$k$个词，分别组成$k$个候选输出序列的首词。在之后的每个时间步，基于上个时间步的$k$个候选输出序列，从$k\left|\mathcal{Y}\right|$个可能的输出序列中选取条件概率最大的$k$个，作为该时间步的候选输出序列。最终，我们从各个时间步的候选输出序列中筛选出包含特殊符号“&lt;eos&gt;”的序列，并将它们中所有特殊符号“&lt;eos&gt;”后面的子序列舍弃，得到最终候选输出序列的集合。

<div align=center>
<img width="500" src="../../img/chapter10/10.10_beam_search.svg"/>
</div>
<div align=center>图10.11 束搜索的过程。束宽为2，输出序列最大长度为3。候选输出序列有A、C、AB、CE、ABD和CED</div>

图10.11通过一个例子演示了束搜索的过程。假设输出序列的词典中只包含5个元素，即$\mathcal{Y} = \{A, B, C, D, E\}$，且其中一个为特殊符号“&lt;eos&gt;”。设束搜索的束宽等于2，输出序列最大长度为3。在输出序列的时间步1时，假设条件概率$P(y_1 \mid \boldsymbol{c})$最大的2个词为$A$和$C$。我们在时间步2时将对所有的$y_2 \in \mathcal{Y}$都分别计算$P(y_2 \mid A, \boldsymbol{c})$和$P(y_2 \mid C, \boldsymbol{c})$，并从计算出的10个条件概率中取最大的2个，假设为$P(B \mid A, \boldsymbol{c})$和$P(E \mid C, \boldsymbol{c})$。那么，我们在时间步3时将对所有的$y_3 \in \mathcal{Y}$都分别计算$P(y_3 \mid A, B, \boldsymbol{c})$和$P(y_3 \mid C, E, \boldsymbol{c})$，并从计算出的10个条件概率中取最大的2个，假设为$P(D \mid A, B, \boldsymbol{c})$和$P(D \mid C, E, \boldsymbol{c})$。如此一来，我们得到6个候选输出序列：（1）$A$；（2）$C$；（3）$A$、$B$；（4）$C$、$E$；（5）$A$、$B$、$D$和（6）$C$、$E$、$D$。接下来，我们将根据这6个序列得出最终候选输出序列的集合。



在最终候选输出序列的集合中，我们取以下分数最高的序列作为输出序列：

$$ \frac{1}{L^\alpha} \log P(y_1, \ldots, y_{L}) = \frac{1}{L^\alpha} \sum_{t'=1}^L \log P(y_{t'} \mid y_1, \ldots, y_{t'-1}, \boldsymbol{c}),$$

其中$L$为最终候选序列长度，$\alpha$一般可选为0.75。分母上的$L^\alpha$是为了惩罚较长序列在以上分数中较多的对数相加项。分析可知，束搜索的计算开销为$\mathcal{O}(k\left|\mathcal{Y}\right|T')$。这介于贪婪搜索和穷举搜索的计算开销之间。此外，贪婪搜索可看作是束宽为1的束搜索。束搜索通过灵活的束宽$k$来权衡计算开销和搜索质量。


## 小结

* 预测不定长序列的方法包括贪婪搜索、穷举搜索和束搜索。
* 束搜索通过灵活的束宽来权衡计算开销和搜索质量。



-----------
> 注：本节与原书基本相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/beam-search.html)

# 10.11 注意力机制

在10.9节（编码器—解码器（seq2seq））里，解码器在各个时间步依赖相同的背景变量来获取输入序列信息。当编码器为循环神经网络时，背景变量来自它最终时间步的隐藏状态。

现在，让我们再次思考那一节提到的翻译例子：输入为英语序列“They”“are”“watching”“.”，输出为法语序列“Ils”“regardent”“.”。不难想到，解码器在生成输出序列中的每一个词时可能只需利用输入序列某一部分的信息。例如，在输出序列的时间步1，解码器可以主要依赖“They”“are”的信息来生成“Ils”，在时间步2则主要使用来自“watching”的编码信息生成“regardent”，最后在时间步3则直接映射句号“.”。这看上去就像是在解码器的每一时间步对输入序列中不同时间步的表征或编码信息分配不同的注意力一样。这也是注意力机制的由来 [1]。

仍然以循环神经网络为例，注意力机制通过对编码器所有时间步的隐藏状态做加权平均来得到背景变量。解码器在每一时间步调整这些权重，即注意力权重，从而能够在不同时间步分别关注输入序列中的不同部分并编码进相应时间步的背景变量。本节我们将讨论注意力机制是怎么工作的。


在10.9节（编码器—解码器（seq2seq））里我们区分了输入序列或编码器的索引$t$与输出序列或解码器的索引$t'$。该节中，解码器在时间步$t'$的隐藏状态$\boldsymbol{s}_{t'} = g(\boldsymbol{y}_{t'-1}, \boldsymbol{c}, \boldsymbol{s}_{t'-1})$，其中$\boldsymbol{y}_{t'-1}$是上一时间步$t'-1$的输出$y_{t'-1}$的表征，且任一时间步$t'$使用相同的背景变量$\boldsymbol{c}$。但在注意力机制中，解码器的每一时间步将使用可变的背景变量。记$\boldsymbol{c}_{t'}$是解码器在时间步$t'$的背景变量，那么解码器在该时间步的隐藏状态可以改写为

$$\boldsymbol{s}_{t'} = g(\boldsymbol{y}_{t'-1}, \boldsymbol{c}_{t'}, \boldsymbol{s}_{t'-1}).$$

这里的关键是如何计算背景变量$\boldsymbol{c}_{t'}$和如何利用它来更新隐藏状态$\boldsymbol{s}_{t'}$。下面将分别描述这两个关键点。


## 10.11.1 计算背景变量

我们先描述第一个关键点，即计算背景变量。图10.12描绘了注意力机制如何为解码器在时间步2计算背景变量。首先，函数$a$根据解码器在时间步1的隐藏状态和编码器在各个时间步的隐藏状态计算softmax运算的输入。softmax运算输出概率分布并对编码器各个时间步的隐藏状态做加权平均，从而得到背景变量。

<div align=center>
<img width="500" src="../../img/chapter10/10.11_attention.svg"/>
</div>
<div align=center>图10.12 编码器—解码器上的注意力机制</div>


具体来说，令编码器在时间步$t$的隐藏状态为$\boldsymbol{h}_t$，且总时间步数为$T$。那么解码器在时间步$t'$的背景变量为所有编码器隐藏状态的加权平均：

$$
\boldsymbol{c}_{t'} = \sum_{t=1}^T \alpha_{t' t} \boldsymbol{h}_t,
$$

其中给定$t'$时，权重$\alpha_{t' t}$在$t=1,\ldots,T$的值是一个概率分布。为了得到概率分布，我们可以使用softmax运算:

$$
\alpha_{t' t} = \frac{\exp(e_{t' t})}{ \sum_{k=1}^T \exp(e_{t' k}) },\quad t=1,\ldots,T.
$$

现在，我们需要定义如何计算上式中softmax运算的输入$e_{t' t}$。由于$e_{t' t}$同时取决于解码器的时间步$t'$和编码器的时间步$t$，我们不妨以解码器在时间步$t'-1$的隐藏状态$\boldsymbol{s}_{t' - 1}$与编码器在时间步$t$的隐藏状态$\boldsymbol{h}_t$为输入，并通过函数$a$计算$e_{t' t}$：

$$
e_{t' t} = a(\boldsymbol{s}_{t' - 1}, \boldsymbol{h}_t).
$$


这里函数$a$有多种选择，如果两个输入向量长度相同，一个简单的选择是计算它们的内积$a(\boldsymbol{s}, \boldsymbol{h})=\boldsymbol{s}^\top \boldsymbol{h}$。而最早提出注意力机制的论文则将输入连结后通过含单隐藏层的多层感知机变换 [1]：

$$
a(\boldsymbol{s}, \boldsymbol{h}) = \boldsymbol{v}^\top \tanh(\boldsymbol{W}_s \boldsymbol{s} + \boldsymbol{W}_h \boldsymbol{h}),
$$

其中$\boldsymbol{v}$、$\boldsymbol{W}_s$、$\boldsymbol{W}_h$都是可以学习的模型参数。

### 10.11.1.1 矢量化计算

我们还可以对注意力机制采用更高效的矢量化计算。广义上，注意力机制的输入包括查询项以及一一对应的键项和值项，其中值项是需要加权平均的一组项。在加权平均中，值项的权重来自查询项以及与该值项对应的键项的计算。

在上面的例子中，查询项为解码器的隐藏状态，键项和值项均为编码器的隐藏状态。
让我们考虑一个常见的简单情形，即编码器和解码器的隐藏单元个数均为$h$，且函数$a(\boldsymbol{s}, \boldsymbol{h})=\boldsymbol{s}^\top \boldsymbol{h}$。假设我们希望根据解码器单个隐藏状态$\boldsymbol{s}_{t' - 1} \in \mathbb{R}^{h}$和编码器所有隐藏状态$\boldsymbol{h}_t \in \mathbb{R}^{h}, t = 1,\ldots,T$来计算背景向量$\boldsymbol{c}_{t'}\in \mathbb{R}^{h}$。
我们可以将查询项矩阵$\boldsymbol{Q} \in \mathbb{R}^{1 \times h}$设为$\boldsymbol{s}_{t' - 1}^\top$，并令键项矩阵$\boldsymbol{K} \in \mathbb{R}^{T \times h}$和值项矩阵$\boldsymbol{V} \in \mathbb{R}^{T \times h}$相同且第$t$行均为$\boldsymbol{h}_t^\top$。此时，我们只需要通过矢量化计算

$$\text{softmax}(\boldsymbol{Q}\boldsymbol{K}^\top)\boldsymbol{V}$$

即可算出转置后的背景向量$\boldsymbol{c}_{t'}^\top$。当查询项矩阵$\boldsymbol{Q}$的行数为$n$时，上式将得到$n$行的输出矩阵。输出矩阵与查询项矩阵在相同行上一一对应。



## 10.11.2 更新隐藏状态

现在我们描述第二个关键点，即更新隐藏状态。以门控循环单元为例，在解码器中我们可以对6.7节（门控循环单元（GRU））中门控循环单元的设计稍作修改，从而变换上一时间步$t'-1$的输出$\boldsymbol{y}_{t'-1}$、隐藏状态$\boldsymbol{s}_{t' - 1}$和当前时间步$t'$的含注意力机制的背景变量$\boldsymbol{c}_{t'}$ [1]。解码器在时间步$t'$的隐藏状态为

$$\boldsymbol{s}_{t'} = \boldsymbol{z}_{t'} \odot \boldsymbol{s}_{t'-1}  + (1 - \boldsymbol{z}_{t'}) \odot \tilde{\boldsymbol{s}}_{t'},$$

其中的重置门、更新门和候选隐藏状态分别为

$$
\begin{aligned}
\boldsymbol{r}_{t'} &= \sigma(\boldsymbol{W}_{yr} \boldsymbol{y}_{t'-1} + \boldsymbol{W}_{sr} \boldsymbol{s}_{t' - 1} + \boldsymbol{W}_{cr} \boldsymbol{c}_{t'} + \boldsymbol{b}_r),\\
\boldsymbol{z}_{t'} &= \sigma(\boldsymbol{W}_{yz} \boldsymbol{y}_{t'-1} + \boldsymbol{W}_{sz} \boldsymbol{s}_{t' - 1} + \boldsymbol{W}_{cz} \boldsymbol{c}_{t'} + \boldsymbol{b}_z),\\
\tilde{\boldsymbol{s}}_{t'} &= \text{tanh}(\boldsymbol{W}_{ys} \boldsymbol{y}_{t'-1} + \boldsymbol{W}_{ss} (\boldsymbol{s}_{t' - 1} \odot \boldsymbol{r}_{t'}) + \boldsymbol{W}_{cs} \boldsymbol{c}_{t'} + \boldsymbol{b}_s),
\end{aligned}
$$

其中含下标的$\boldsymbol{W}$和$\boldsymbol{b}$分别为门控循环单元的权重参数和偏差参数。



## 10.11.3 发展

本质上，注意力机制能够为表征中较有价值的部分分配较多的计算资源。这个有趣的想法自提出后得到了快速发展，特别是启发了依靠注意力机制来编码输入序列并解码出输出序列的变换器（Transformer）模型的设计 [2]。变换器抛弃了卷积神经网络和循环神经网络的架构。它在计算效率上比基于循环神经网络的编码器—解码器模型通常更具明显优势。含注意力机制的变换器的编码结构在后来的BERT预训练模型中得以应用并令后者大放异彩：微调后的模型在多达11项自然语言处理任务中取得了当时最先进的结果 [3]。不久后，同样是基于变换器设计的GPT-2模型于新收集的语料数据集预训练后，在7个未参与训练的语言模型数据集上均取得了当时最先进的结果 [4]。除了自然语言处理领域，注意力机制还被广泛用于图像分类、自动图像描述、唇语解读以及语音识别。


## 小结

* 可以在解码器的每个时间步使用不同的背景变量，并对输入序列中不同时间步编码的信息分配不同的注意力。
* 广义上，注意力机制的输入包括查询项以及一一对应的键项和值项。
* 注意力机制可以采用更为高效的矢量化计算。



## 参考文献

[1] Bahdanau, D., Cho, K., & Bengio, Y. (2014). Neural machine translation by jointly learning to align and translate. arXiv preprint arXiv:1409.0473.

[2] Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A. N., ... & Polosukhin, I. (2017). Attention is all you need. In Advances in Neural Information Processing Systems (pp. 5998-6008).

[3] Devlin, J., Chang, M. W., Lee, K., & Toutanova, K. (2018). Bert: Pre-training of deep bidirectional transformers for language understanding. arXiv preprint arXiv:1810.04805.

[4] Radford, A., Wu, J., Child, R., Luan, D., Amodei, D., Sutskever I. (2019). Language Models are Unsupervised Multitask Learners. OpenAI.


-----------
> 注：本节与原书基本相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/attention.html)

# 10.12 机器翻译

机器翻译是指将一段文本从一种语言自动翻译到另一种语言。因为一段文本序列在不同语言中的长度不一定相同，所以我们使用机器翻译为例来介绍编码器—解码器和注意力机制的应用。

## 10.12.1 读取和预处理数据

我们先定义一些特殊符号。其中“&lt;pad&gt;”（padding）符号用来添加在较短序列后，直到每个序列等长，而“&lt;bos&gt;”和“&lt;eos&gt;”符号分别表示序列的开始和结束。

``` python
import collections
import os
import io
import math
import torch
from torch import nn
import torch.nn.functional as F
import torchtext.vocab as Vocab
import torch.utils.data as Data

import sys
sys.path.append("..") 
import d2lzh_pytorch as d2l

PAD, BOS, EOS = '<pad>', '<bos>', '<eos>'
os.environ["CUDA_VISIBLE_DEVICES"] = "0"
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
```

接着定义两个辅助函数对后面读取的数据进行预处理。

``` python
# 将一个序列中所有的词记录在all_tokens中以便之后构造词典，然后在该序列后面添加PAD直到序列
# 长度变为max_seq_len，然后将序列保存在all_seqs中
def process_one_seq(seq_tokens, all_tokens, all_seqs, max_seq_len):
    all_tokens.extend(seq_tokens)
    seq_tokens += [EOS] + [PAD] * (max_seq_len - len(seq_tokens) - 1)
    all_seqs.append(seq_tokens)

# 使用所有的词来构造词典。并将所有序列中的词变换为词索引后构造Tensor
def build_data(all_tokens, all_seqs):
    vocab = Vocab.Vocab(collections.Counter(all_tokens),
                        specials=[PAD, BOS, EOS])
    indices = [[vocab.stoi[w] for w in seq] for seq in all_seqs]
    return vocab, torch.tensor(indices)
```

为了演示方便，我们在这里使用一个很小的法语—英语数据集。在这个数据集里，每一行是一对法语句子和它对应的英语句子，中间使用`'\t'`隔开。在读取数据时，我们在句末附上“&lt;eos&gt;”符号，并可能通过添加“&lt;pad&gt;”符号使每个序列的长度均为`max_seq_len`。我们为法语词和英语词分别创建词典。法语词的索引和英语词的索引相互独立。

``` python
def read_data(max_seq_len):
    # in和out分别是input和output的缩写
    in_tokens, out_tokens, in_seqs, out_seqs = [], [], [], []
    with io.open('../../data/fr-en-small.txt') as f:
        lines = f.readlines()
    for line in lines:
        in_seq, out_seq = line.rstrip().split('\t')
        in_seq_tokens, out_seq_tokens = in_seq.split(' '), out_seq.split(' ')
        if max(len(in_seq_tokens), len(out_seq_tokens)) > max_seq_len - 1:
            continue  # 如果加上EOS后长于max_seq_len，则忽略掉此样本
        process_one_seq(in_seq_tokens, in_tokens, in_seqs, max_seq_len)
        process_one_seq(out_seq_tokens, out_tokens, out_seqs, max_seq_len)
    in_vocab, in_data = build_data(in_tokens, in_seqs)
    out_vocab, out_data = build_data(out_tokens, out_seqs)
    return in_vocab, out_vocab, Data.TensorDataset(in_data, out_data)
```

将序列的最大长度设成7，然后查看读取到的第一个样本。该样本分别包含法语词索引序列和英语词索引序列。

``` python
max_seq_len = 7
in_vocab, out_vocab, dataset = read_data(max_seq_len)
dataset[0]
```
输出：
```
(tensor([ 5,  4, 45,  3,  2,  0,  0]), tensor([ 8,  4, 27,  3,  2,  0,  0]))
```

## 10.12.2 含注意力机制的编码器—解码器

我们将使用含注意力机制的编码器—解码器来将一段简短的法语翻译成英语。下面我们来介绍模型的实现。

### 10.12.2.1 编码器

在编码器中，我们将输入语言的词索引通过词嵌入层得到词的表征，然后输入到一个多层门控循环单元中。正如我们在6.5节（循环神经网络的简洁实现）中提到的，PyTorch的`nn.GRU`实例在前向计算后也会分别返回输出和最终时间步的多层隐藏状态。其中的输出指的是最后一层的隐藏层在各个时间步的隐藏状态，并不涉及输出层计算。注意力机制将这些输出作为键项和值项。

``` python
class Encoder(nn.Module):
    def __init__(self, vocab_size, embed_size, num_hiddens, num_layers,
                 drop_prob=0, **kwargs):
        super(Encoder, self).__init__(**kwargs)
        self.embedding = nn.Embedding(vocab_size, embed_size)
        self.rnn = nn.GRU(embed_size, num_hiddens, num_layers, dropout=drop_prob)

    def forward(self, inputs, state):
        # 输入形状是(批量大小, 时间步数)。将输出互换样本维和时间步维
        embedding = self.embedding(inputs.long()).permute(1, 0, 2) # (seq_len, batch, input_size)
        return self.rnn(embedding, state)

    def begin_state(self):
        return None # 隐藏态初始化为None时PyTorch会自动初始化为0
```

下面我们来创建一个批量大小为4、时间步数为7的小批量序列输入。设门控循环单元的隐藏层个数为2，隐藏单元个数为16。编码器对该输入执行前向计算后返回的输出形状为(时间步数, 批量大小, 隐藏单元个数)。门控循环单元在最终时间步的多层隐藏状态的形状为(隐藏层个数, 批量大小, 隐藏单元个数)。对于门控循环单元来说，`state`就是一个元素，即隐藏状态；如果使用长短期记忆，`state`是一个元组，包含两个元素即隐藏状态和记忆细胞。

``` python
encoder = Encoder(vocab_size=10, embed_size=8, num_hiddens=16, num_layers=2)
output, state = encoder(torch.zeros((4, 7)), encoder.begin_state())
output.shape, state.shape # GRU的state是h, 而LSTM的是一个元组(h, c)
```
输出：
```
(torch.Size([7, 4, 16]), torch.Size([2, 4, 16]))
```

### 10.12.2.2 注意力机制

我们将实现10.11节（注意力机制）中定义的函数$a$：将输入连结后通过含单隐藏层的多层感知机变换。其中隐藏层的输入是解码器的隐藏状态与编码器在所有时间步上隐藏状态的一一连结，且使用tanh函数作为激活函数。输出层的输出个数为1。两个`Linear`实例均不使用偏差。其中函数$a$定义里向量$\boldsymbol{v}$的长度是一个超参数，即`attention_size`。

``` python
def attention_model(input_size, attention_size):
    model = nn.Sequential(nn.Linear(input_size, 
                                    attention_size, bias=False),
                          nn.Tanh(),
                          nn.Linear(attention_size, 1, bias=False))
    return model
```

注意力机制的输入包括查询项、键项和值项。设编码器和解码器的隐藏单元个数相同。这里的查询项为解码器在上一时间步的隐藏状态，形状为(批量大小, 隐藏单元个数)；键项和值项均为编码器在所有时间步的隐藏状态，形状为(时间步数, 批量大小, 隐藏单元个数)。注意力机制返回当前时间步的背景变量，形状为(批量大小, 隐藏单元个数)。

``` python 
def attention_forward(model, enc_states, dec_state):
    """
    enc_states: (时间步数, 批量大小, 隐藏单元个数)
    dec_state: (批量大小, 隐藏单元个数)
    """
    # 将解码器隐藏状态广播到和编码器隐藏状态形状相同后进行连结
    dec_states = dec_state.unsqueeze(dim=0).expand_as(enc_states)
    enc_and_dec_states = torch.cat((enc_states, dec_states), dim=2)
    e = model(enc_and_dec_states)  # 形状为(时间步数, 批量大小, 1)
    alpha = F.softmax(e, dim=0)  # 在时间步维度做softmax运算
    return (alpha * enc_states).sum(dim=0)  # 返回背景变量
```

在下面的例子中，编码器的时间步数为10，批量大小为4，编码器和解码器的隐藏单元个数均为8。注意力机制返回一个小批量的背景向量，每个背景向量的长度等于编码器的隐藏单元个数。因此输出的形状为(4, 8)。

``` python
seq_len, batch_size, num_hiddens = 10, 4, 8
model = attention_model(2*num_hiddens, 10) 
enc_states = torch.zeros((seq_len, batch_size, num_hiddens))
dec_state = torch.zeros((batch_size, num_hiddens))
attention_forward(model, enc_states, dec_state).shape # torch.Size([4, 8])
```

### 10.12.2.3 含注意力机制的解码器

我们直接将编码器在最终时间步的隐藏状态作为解码器的初始隐藏状态。这要求编码器和解码器的循环神经网络使用相同的隐藏层个数和隐藏单元个数。

在解码器的前向计算中，我们先通过刚刚介绍的注意力机制计算得到当前时间步的背景向量。由于解码器的输入来自输出语言的词索引，我们将输入通过词嵌入层得到表征，然后和背景向量在特征维连结。我们将连结后的结果与上一时间步的隐藏状态通过门控循环单元计算出当前时间步的输出与隐藏状态。最后，我们将输出通过全连接层变换为有关各个输出词的预测，形状为(批量大小, 输出词典大小)。

``` python
class Decoder(nn.Module):
    def __init__(self, vocab_size, embed_size, num_hiddens, num_layers,
                 attention_size, drop_prob=0):
        super(Decoder, self).__init__()
        self.embedding = nn.Embedding(vocab_size, embed_size)
        self.attention = attention_model(2*num_hiddens, attention_size)
        # GRU的输入包含attention输出的c和实际输入, 所以尺寸是 2*embed_size
        self.rnn = nn.GRU(2*embed_size, num_hiddens, num_layers, dropout=drop_prob)
        self.out = nn.Linear(num_hiddens, vocab_size)

    def forward(self, cur_input, state, enc_states):
        """
        cur_input shape: (batch, )
        state shape: (num_layers, batch, num_hiddens)
        """
        # 使用注意力机制计算背景向量
        c = attention_forward(self.attention, enc_states, state[-1])
        # 将嵌入后的输入和背景向量在特征维连结
        input_and_c = torch.cat((self.embedding(cur_input), c), dim=1) # (批量大小, 2*embed_size)
        # 为输入和背景向量的连结增加时间步维，时间步个数为1
        output, state = self.rnn(input_and_c.unsqueeze(0), state)
        # 移除时间步维，输出形状为(批量大小, 输出词典大小)
        output = self.out(output).squeeze(dim=0)
        return output, state

    def begin_state(self, enc_state):
        # 直接将编码器最终时间步的隐藏状态作为解码器的初始隐藏状态
        return enc_state
```

## 10.12.3 训练模型

我们先实现`batch_loss`函数计算一个小批量的损失。解码器在最初时间步的输入是特殊字符`BOS`。之后，解码器在某时间步的输入为样本输出序列在上一时间步的词，即强制教学。此外，同10.3节（word2vec的实现）中的实现一样，我们在这里也使用掩码变量避免填充项对损失函数计算的影响。

``` python
def batch_loss(encoder, decoder, X, Y, loss):
    batch_size = X.shape[0]
    enc_state = encoder.begin_state()
    enc_outputs, enc_state = encoder(X, enc_state)
    # 初始化解码器的隐藏状态
    dec_state = decoder.begin_state(enc_state)
    # 解码器在最初时间步的输入是BOS
    dec_input = torch.tensor([out_vocab.stoi[BOS]] * batch_size)
    # 我们将使用掩码变量mask来忽略掉标签为填充项PAD的损失
    mask, num_not_pad_tokens = torch.ones(batch_size,), 0
    l = torch.tensor([0.0])
    for y in Y.permute(1,0): # Y shape: (batch, seq_len)
        dec_output, dec_state = decoder(dec_input, dec_state, enc_outputs)
        l = l + (mask * loss(dec_output, y)).sum()
        dec_input = y  # 使用强制教学
        num_not_pad_tokens += mask.sum().item()
        # 将PAD对应位置的掩码设成0, 原文这里是 y != out_vocab.stoi[EOS], 感觉有误
        mask = mask * (y != out_vocab.stoi[PAD]).float()
    return l / num_not_pad_tokens
```

在训练函数中，我们需要同时迭代编码器和解码器的模型参数。

``` python
def train(encoder, decoder, dataset, lr, batch_size, num_epochs):
    enc_optimizer = torch.optim.Adam(encoder.parameters(), lr=lr)
    dec_optimizer = torch.optim.Adam(decoder.parameters(), lr=lr)

    loss = nn.CrossEntropyLoss(reduction='none')
    data_iter = Data.DataLoader(dataset, batch_size, shuffle=True)
    for epoch in range(num_epochs):
        l_sum = 0.0
        for X, Y in data_iter:
            enc_optimizer.zero_grad()
            dec_optimizer.zero_grad()
            l = batch_loss(encoder, decoder, X, Y, loss)
            l.backward()
            enc_optimizer.step()
            dec_optimizer.step()
            l_sum += l.item()
        if (epoch + 1) % 10 == 0:
            print("epoch %d, loss %.3f" % (epoch + 1, l_sum / len(data_iter)))
```

接下来，创建模型实例并设置超参数。然后，我们就可以训练模型了。

``` python
embed_size, num_hiddens, num_layers = 64, 64, 2
attention_size, drop_prob, lr, batch_size, num_epochs = 10, 0.5, 0.01, 2, 50
encoder = Encoder(len(in_vocab), embed_size, num_hiddens, num_layers,
                  drop_prob)
decoder = Decoder(len(out_vocab), embed_size, num_hiddens, num_layers,
                  attention_size, drop_prob)
train(encoder, decoder, dataset, lr, batch_size, num_epochs)
```
输出：
```
epoch 10, loss 0.441
epoch 20, loss 0.183
epoch 30, loss 0.100
epoch 40, loss 0.046
epoch 50, loss 0.025
```

## 10.12.4 预测不定长的序列

在10.10节（束搜索）中我们介绍了3种方法来生成解码器在每个时间步的输出。这里我们实现最简单的贪婪搜索。

``` python
def translate(encoder, decoder, input_seq, max_seq_len):
    in_tokens = input_seq.split(' ')
    in_tokens += [EOS] + [PAD] * (max_seq_len - len(in_tokens) - 1)
    enc_input = torch.tensor([[in_vocab.stoi[tk] for tk in in_tokens]]) # batch=1
    enc_state = encoder.begin_state()
    enc_output, enc_state = encoder(enc_input, enc_state)
    dec_input = torch.tensor([out_vocab.stoi[BOS]])
    dec_state = decoder.begin_state(enc_state)
    output_tokens = []
    for _ in range(max_seq_len):
        dec_output, dec_state = decoder(dec_input, dec_state, enc_output)
        pred = dec_output.argmax(dim=1)
        pred_token = out_vocab.itos[int(pred.item())]
        if pred_token == EOS:  # 当任一时间步搜索出EOS时，输出序列即完成
            break
        else:
            output_tokens.append(pred_token)
            dec_input = pred
    return output_tokens
```

简单测试一下模型。输入法语句子“ils regardent.”，翻译后的英语句子应该是“they are watching.”。

``` python
input_seq = 'ils regardent .'
translate(encoder, decoder, input_seq, max_seq_len)
```
输出：
```
['they', 'are', 'watching', '.']
```

## 10.12.5 评价翻译结果

评价机器翻译结果通常使用BLEU（Bilingual Evaluation Understudy）[1]。对于模型预测序列中任意的子序列，BLEU考察这个子序列是否出现在标签序列中。

具体来说，设词数为$n$的子序列的精度为$p_n$。它是预测序列与标签序列匹配词数为$n$的子序列的数量与预测序列中词数为$n$的子序列的数量之比。举个例子，假设标签序列为$A$、$B$、$C$、$D$、$E$、$F$，预测序列为$A$、$B$、$B$、$C$、$D$，那么$p_1 = 4/5,\ p_2 = 3/4,\ p_3 = 1/3,\ p_4 = 0$。设$len_{\text{label}}$和$len_{\text{pred}}$分别为标签序列和预测序列的词数，那么，BLEU的定义为

$$ \exp\left(\min\left(0, 1 - \frac{len_{\text{label}}}{len_{\text{pred}}}\right)\right) \prod_{n=1}^k p_n^{1/2^n},$$

其中$k$是我们希望匹配的子序列的最大词数。可以看到当预测序列和标签序列完全一致时，BLEU为1。

因为匹配较长子序列比匹配较短子序列更难，BLEU对匹配较长子序列的精度赋予了更大权重。例如，当$p_n$固定在0.5时，随着$n$的增大，$0.5^{1/2} \approx 0.7, 0.5^{1/4} \approx 0.84, 0.5^{1/8} \approx 0.92, 0.5^{1/16} \approx 0.96$。另外，模型预测较短序列往往会得到较高$p_n$值。因此，上式中连乘项前面的系数是为了惩罚较短的输出而设的。举个例子，当$k=2$时，假设标签序列为$A$、$B$、$C$、$D$、$E$、$F$，而预测序列为$A$、$B$。虽然$p_1 = p_2 = 1$，但惩罚系数$\exp(1-6/2) \approx 0.14$，因此BLEU也接近0.14。

下面来实现BLEU的计算。

``` python
def bleu(pred_tokens, label_tokens, k):
    len_pred, len_label = len(pred_tokens), len(label_tokens)
    score = math.exp(min(0, 1 - len_label / len_pred))
    for n in range(1, k + 1):
        num_matches, label_subs = 0, collections.defaultdict(int)
        for i in range(len_label - n + 1):
            label_subs[''.join(label_tokens[i: i + n])] += 1
        for i in range(len_pred - n + 1):
            if label_subs[''.join(pred_tokens[i: i + n])] > 0:
                num_matches += 1
                label_subs[''.join(pred_tokens[i: i + n])] -= 1
        score *= math.pow(num_matches / (len_pred - n + 1), math.pow(0.5, n))
    return score
```

接下来，定义一个辅助打印函数。

``` python
def score(input_seq, label_seq, k):
    pred_tokens = translate(encoder, decoder, input_seq, max_seq_len)
    label_tokens = label_seq.split(' ')
    print('bleu %.3f, predict: %s' % (bleu(pred_tokens, label_tokens, k),
                                      ' '.join(pred_tokens)))
```

预测正确则分数为1。

``` python
score('ils regardent .', 'they are watching .', k=2)
```
输出：
```
bleu 1.000, predict: they are watching .
```

测试一个不在训练集中的样本。

``` python
score('ils sont canadiens .', 'they are canadian .', k=2)
```
输出：
```
bleu 0.658, predict: they are russian .
```

## 小结

* 可以将编码器—解码器和注意力机制应用于机器翻译中。
* BLEU可以用来评价翻译结果。


## 参考文献

[1] Papineni, K., Roukos, S., Ward, T., & Zhu, W. J. (2002, July). BLEU: a method for automatic evaluation of machine translation. In Proceedings of the 40th annual meeting on association for computational linguistics (pp. 311-318). Association for Computational Linguistics.

[2] WMT. http://www.statmt.org/wmt14/translation-task.html

[3] Tatoeba Project. http://www.manythings.org/anki/


-----------
> 注：本节除代码外与原书基本相同，[原书传送门](https://zh.d2l.ai/chapter_natural-language-processing/machine-translation.html)

