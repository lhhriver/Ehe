`Embeddings from Language Models`

AllenNLP 和华盛顿大学 2018 年的论文《Deep contextualized word representations》，是 NAACL 2018 best paper。这篇论文提出的 ELMo 模型是 2013 年以来 Embedding 领域非常精彩的转折点，并在 2018 年及以后的很长一段时间里掀起了迁移学习在 NLP 领域的风潮。

**ELMo 是一种基于语境的深度词表示模型（Word Representation Model），它可以捕获单词的复杂特征（词性句法），也可以解决同一个单词在不同语境下的不同表示（语义）**。

# Introduction

以 Word2Vec 和 GloVe 为代表的词表示模型通过训练为每个单词训练出固定大小的词向量，这在以往的 NLP 任务中都取得了不错的效果，但是他们都存在两个问题：

1. 没法处理复杂的单词用法，即**语法问题**。
2. 没办法结合语境给出正确词向量，即**一词多义**。

区别于传统模型生成的固定单词映射表的形式（为每个单词生成一个固定的词向量），ELMo使用了**预训练的语言模型**（Language Model），模型会扫面句子结构，并更新内部状态，从而为句子中的每个单词都生成一个**基于当前的句子的词向量（Embedding）**。这也是就是 ELMo 取名的由来：Embeddings from Language Models。 

此外，ELMo**采用字符级的多层 Bi-LM 模型**作为语言模型，**高层**的网络能够捕获基于语境的词特征（例如主题情感），而**底层**的LSTM 可以学到语法层次的信息（例如词性句法）。前者可以处理一词多义，后者可以被用作词性标注，作者通过线性组合多层 LSTM 的内部状态来丰富单词的表示。



# ELMo

ELMo 是一种称为Bi-LM的特殊类型的语言模型，它是两个方向上的LM的组合，如下图所示：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-508085.webp)

ELMo 利用**正向**和**反向**扫描句子计算单词的词向量，并通过级联的方式产生一个中间向量（下面会给出具体的级联方式）。通过这种方式得到的词向量它可以了解到当前句子的结构和该单词的使用方式。

值得注意是，ELMo 使用的**Bi-LM与Bi-LSTM不同，使用两个单向LSTM代替一个双向LSTM**。虽说Elmo用了双向LSTM，但是这是个`伪双向`，因为它**只是把两个方向的信息拼接起来，并非同时获取前后信息**。

虽然长得相似，但是Bi-LM是两个LM模型的串联，一个向前，一个向后；而 Bi-LSTM 不仅仅是两个 LSTM 串联，**Bi-LSTM 模型中来自两个方向的内部状态在被送到下层时进行级联（注意下图的 out 部分，在 out 中进行级联），而在 Bi-LM 中，两个方向的内部状态仅从两个独立训练的 LM 中进行级联。**

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-522019.webp)



## **Bi-LM**

设一个序列有 N 个 token （这里说 token 是为了兼容字符和单词，EMLo 使用的是字符级别的 Embedding）

对于一个**前向语言模型**来说，是基于先前的序列来预测当前 token：

$$
p\left(t_{1}, t_{2}, \ldots, t_{N}\right)=\prod_{k=1}^{N} p\left(t_{k} | t_{1}, t_{2}, \ldots, t_{k-1}\right)
$$
而对于一个**后向语言模型**来说，是基于后面的序列来预测当前 token：

$$
p\left(t_{1}, t_{2}, \ldots, t_{N}\right)=\prod_{k=1}^{N} p\left(t_{k} | t_{k+1}, t_{k+2}, \ldots, t_{N}\right)
$$
可以用$\overrightarrow{h_{k, j}}$ 和$\overleftarrow{h_{k, j}}$分别表示前向和后向语言模型。

ELMo 用的是多层双向的 LSTM，所以我们联合前向模型和后向模型给出**对数似然估计**：

$$
\sum_{k=1}^{N}\left(\log p(t_{k} | t_{1}, \ldots, t_{k-1} ; \Theta_{x}, \vec{\Theta}_{L S T M}, \Theta_{s})+\log p(t_{k} | t_{k+1}, \ldots, t_{N} ; \Theta_{x}, \overleftarrow{\Theta}_{L S T M}, \Theta_{s})\right)
$$
其中， $\Theta_{x}$表示 token 的向量， $\Theta_{s}$表示 Softmax 层对的参数， $\vec{\Theta}_{LSTM}$和 $\overleftarrow{\Theta}_{LSTM}$表示前向和后向的 LSTM 的参数。

我们刚说ELMo通过**级联**的方式给出**中间向量**（这边要注意两个地方：一个是**级联**，一个是**中间向量**），现在给出符号定义：

对每一个 token $t_k$来说，一个 L 层的 ELMo 的 2L + 1 个表征：

$$
R_{k}=\left\{x_{k}^{L M}, \overrightarrow{h_{k, j}}, \overleftarrow{h_{k, j}} | j=1, \ldots, L\right\}=\left\{h_{k, j} | j=0, \ldots, L\right\}
$$
其中， $\overrightarrow{h_{k, 0}}$表示输入层，$h_{k, j}=[\overrightarrow{h_{k, j}} ; \overleftarrow{h_{k, j}}]$ 。（之所以是 2L + 1 是因为把输入层加了进来）

对于下游任务来说，ELMo 会将所有的表征加权合并为一个**中间向量**：

$$
E L M o_{k}=E\left(R_{k} ; \Theta\right)=\gamma \sum_{j=0}^{L} s_{j} h_{k, j}^{L M}
$$
其中， $s$ 是 Softmax 的结果，用作权重； $\gamma$ 是常量参数，允许模型缩放整个 ELMo 向量，考虑到各个Bi-LSTM层分布不同，某些情况下对网络的 Layer Normalization 会有帮助。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-529010.jpg)



## **Supervised NLP task**

我们来看下 ELMo 在有监督学习中应用，这里假设 ELMo 模型已经完成预训练。

对于给定的一个监督学习 NLP 任务，我们只需为每个句子中的单词记录下 ELMo 各层的词表征，然后用端到端的任务来学习这些表示的线性组合（**学习向量的权重**）。

对于大多数 NLP 任务而言，**靠近输入端的结构所含信息基本一致**（例如词法句法，想象下 CV 浅层网络的可视化都是一些线条），所以这就允许我们直接把训练好的 ELMo 加到现有的 NLP 的监督任务模型中（因为底层结构相似，所以直接用 ELMo 提取上下文的浅层信息也可以）。

通常来说，会使用预训练的 Word Embedding（或者是字符级别的 Embedding）来为每个位置**生成一个上下文无关的词表示 ，然后拼接 ELMo 后会生成一个上下文相关的词表示**（即通过 ELMo 提取单词及周围的上下文信息，然后拼接原本的单词向量）。

为了将 ELMo 加到监督学习的模型中，我们有两种拼接方式：

1. 固定 BiLM 的权重，并用$x_k$拼接 ELMo 的向量$ELMo_k$，使用拼接后的向量$\left[x_{k} ; E L M o_{k}\right]$传递给下游任务；
2. 或者利用模型的隐藏输出层，比如 RNN 的$h_k$来和$ELMo_k$拼接$\left[h_{k} ; E L M o_{k}\right]$。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-560585.png)

最后，对 ELMo 适当加入一些 Dropout，或者在某些情况下在损失函数中加入$\lambda\|w\|^{2}$ ，都有可能带来效果提升。



## **Pre-trained**

预训练的架构采用类似下图 c  的架构，下图来自《Exploring the Limits of Language Modeling》。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-511247.webp)

简单解释下这张图:

- a 是普通的基于 LSTM 的语言模型
- b 是用字符级别的 CNN 来代替原本的输入和 Softmax 层
- c 是用 LSTM 层代替 CNN Softmax 层并预测下一个单词。（这里的 CNN Softmax 层区别于 Word2Vec 中的 Softmax，并不是直接预测词汇表，而是计算$z_w = h^Te_w$的 Logistic 值，其中 h 为单词上下文向量，$e_w = CNN(char \quad s_w)$）

作者在论文中指出：ELMo 使用 CNN-BIG-LSTM 的架构进行预训练（这里的BIG只是想说多很多LSTM），并且为了平衡LM的复杂度、模型大小和下游任务的计算需求，同时保持纯粹基于字符的输入表示，ELMo只使用了两层的LSTM层，每层4096个隐藏单元和512维的词向量大小，以及跨一层的残差连接。

而在提取静态字符时，使用两层具有 2048 个卷积过滤器的 highway layer 和一个含有 512 个隐藏单元的 linear projection layer。

这里的 highway layer 由《Training Very Deep Networks》论文中给出，可以简单理解为该网络层只处理一部分输入，而另外一部分直接通过。所以相比于传统的网络，HighwayNet 可以有更深的网络，而试验结果也表明其更容易训练。

相比其他模型只提供一层 Representation 而言，作者提供了三层 Representations：

- 单词**原始的 Embedding**
- 第一层双向 LSTM 中对应单词位置的 Embedding （包含句法信息）
- 第二层双向 LSTM 中对应单词位置的 Embedding（包含语义信息）

下面这张图看的可能更清楚一点。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-593785.png)

在训练了 10 个 epochs 后，前向和后向的平均困惑度（perplexities）分别是 39.7，而 CNN-BIG-LSTM 的困惑度为 30.0。总体看前向和后向困惑度相当，后向稍微低一些。

---

**困惑度（perplexities）**：如果每个时间步都根据语言模型计算的概率分布随机挑词，那么平均情况下，挑多少个词才能挑到正确的那个。显然，困惑度越小越好。

完成预训练后可以得到训练好的 Bi-LM 模型和单词的 Embedding 向量。对于下游任务来说可以对 Bi-LM 进行微调，也可以直接使用。

# Experience

简单看下实验，下图显示了不同任务下，ELMo 相对 baseline 的提升程度：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-532726.webp)

正则化系数的影响：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-524996.webp)

模型训练效率：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-505095.webp)

# Conclusion

**总结**：ELMo 采用预训练的方式得到原始Embedding向量和双层 Bi-LSTM 模型，同时 ELMo 会为每个单词提供三个 Embedding 向量并学习具体任务下线性组合后的中间向量，与原始向量拼接后即可为下游任务提供基于语境的 Word Embedding。

第一次看 ELMo 时的想法是：为什么要用 LSTM 而不用类似 Transformer 的结构？毕竟 Transformer 在发表于 2017 年，早于 ELMo；

其次，ELMo 采用的并不是真正的双向 LSTM，而是两个独立的 LSTM 分别训练，并且只是在 Loss Function 中通过简单相加进行约束，只能一定程度上学习到单词两边句子的特征。



# 试题

## ELMO的结构是怎么样的？

ELMO 由一层input层 和 两层双向LSTM 组合而成的

注：input层可看为embedding层，不过ELMO是通过字符卷积来得到embedding的，不是矩阵相乘；用两个单向LSTM替代一个双向LSTM。

**如图：**

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-613865.jpg)

## ELMO到底在解决一个什么问题？

ELMO解决了大部分问题，其中最重要的一个是：它解决了**一词多义**的问题。

拿word2vector来说，字与vector是一一对应的，输入句子，然后输出句子中每个字对应vector，可以看成查表的过程。

**如：**输入画画 ，word2vec就会输出两个一样的vector，但是第一个画是动词、第二个画是名词，他们的vector应该是不一样的，但word2vec并不能区分。即使在训练过程中对embedding矩阵进行更新，它依旧还是一一对应的关系。

向ELMO输入画画 ，输出的两个向量是经过2层LSTM后的结果，它们是不同的。这是ELMO根据输入句子的语境得到的结果。



## ELMO什么怎么进行预训练的呢？如何使用它呢？

论文这么说到：

> The top layer LSTM output, is used to predict the next token with a Softmax layer.

即，将ELMO输出的向量映射到 vocab_size的长度，softmax后，取出概率最大的元素对应的下标，作为对下一个字的预测。相当于做一个分类，类别数量是词表大小，类似自回归。

label相对于input错位一个字，如：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-610891.jpg)

**使用：**

ELMO有三层，每一层都有一个输出，将这三层的输出按比例相加后即为所得vector。这个比例是模型学习得到的。得到加权后的向量后，如何使用取决于任务的效果。



## 为什么ELMO用两个单向的LSTM代替一个双向的LSTM呢？

用双向的模型结构去训练语言模型会导致“看到自己”或“看到答案”的问题。后来的预训练语言模型也都在避免或解决这个问题，解决的程度也影响着模型效果。

**以下是几个模型的解决方法：**

**ELMO**：使用两个单向LSTM代替一个双向LSTM。

**GPT** ：通过**mask得分矩阵**避免当前字看到之后所要预测的字，所以GPT是只有正向的，缺失了反向信息。

**BERT**：将所要预测的字**用[MASK]字符代替**，无论你是正向的还是反向的，你都不知道[MASK]这个字符原来的字是什么，只有结合[MASK]左右两边的词语信息来预测。这就达到了用双向模型训练的目的，但也**引入了 预训练-微调 不一致的问题**。

**XLNet**：不用[MASK]字符，结合GPT和BERT的思想，即：**用mask得分矩阵的方法来替代[MASK]这个字符**。

**可以看出，如果不考虑训练数据大小的影响，谁更好的解决“如何将双向融入语言模型”这个问题，谁效果就更好。**



**现在来说一下为什么双向LSTM会导致看见答案的问题：**

如图所示的正向LSTM，"克"是根据“扑”这个字 和 隐藏向量h2 来预测出来的。h2包含了<start>和打 这两个字的信息，所以预测“克”这个字时，是根据前面所有的字来预测的。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-616747.jpg)

**但如果加上反向LSTM呢？**

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-ELMO-20201214-201036-607158.jpg)

反向的话，“克”就是根据 “扑”和 h1 来预测的，但是 h1 包含了“克”的信息，所以反向的话会导致模型看到答案。

**这就是双向LSTM带来的“看见答案”的问题。**



# Reference

1.  [微信文章](https://mp.weixin.qq.com/s/19uJh6GKKJboSJf65T-GnA)
2.  https://zhuanlan.zhihu.com/p/72839501
3.  《Deep contextualized word representations》
4.  《Exploring the Limits of Language Modeling》
5.  《Training Very Deep Networks》
6.  《A Review of Deep Contextualized Word Representations (Peters+, 2018)》
7.  《The Illustrated BERT, ELMo, and co. (How NLP Cracked Transfer Learning)》
8.  《NAACL2018 一种新的embedding方法--原理与实验 Deep contextualized word representations (ELMo)》
9.  《Improving a Sentiment Analyzer using ELMo — Word Embeddings on Steroids》