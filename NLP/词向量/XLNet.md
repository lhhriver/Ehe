<center><font color=steel size=14 face=雅黑>XLNET</font></center>

谷歌大脑和 CMU 的论文《XLNet: Generalized Autoregressive Pretraining for Language Understanding》，于 2019 年发表于 NIPS，目前引用超 300 次。

XLNet 是一个广义自回归预语言模型，它在 Transformer-XL 的基础上引入了**排列语言模型**（Permutation Language Model，以下简写 PLM），该方法可以很好解决自回归预编无法处理上下文建模的问题，最后用三倍于 BERT 的语料库进行预训练，并在 20 个 NLP 任务中屠榜。

# Introduction

XLNet 采用了**二阶训练**的方式，先在大规模语料库中进行无监督的预训练，然后针对下游任务进行微调。

XLNet 也是一个类似于 BERT 的模型，但是其和 BERT 的最大区别在于：**XLNet 采用的是自回归（autoregressive）的预训练方法，而 BERT 采用的是自编码（autoencoding）的预训练方法。**

我们先来介绍下自回归和自编码： 

## Autoregressive

**自回归语言模型**（Autoregressive Language Model）是利用上文预测下文或下文预测上文，要么向前，要么向后，不能同时联系上下文信息进行建模，比较经典的模型代表有：ELMo、GPT、GPT2等。ELMo 虽然是联系了两个方向进行计算，但因为其是独立计算，所以 ELMo 还是自回归语言模型。

AR语言模型的**缺点**:

1. 在于只能利用单向信息进行建模，而不能同时利用上下文。

AR语言模型的**优点**:

1. 在于因为使用了单向的语言模型，所以其在文本生成之类（向前的方向）的 NLP 任务中便能取得不错的效果。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N09-XLNet-20201214-201043-605224.webp)

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N09-XLNet-20201214-201043-638986.webp)



## Autoencoding

**自编码语言模型**（Autoencoding Language Model）是利用上下文来建模，比较经典的模型有 BERT，其做法为用 [MASK] 代替一部分的数据，然后利用上下文来预测被 [MASK] 的数据。

AE 语言模型的**优点**：

1. 在于利用了上下文建模；

AE 语言模型的**缺点**：

1. 在于预训练中的 [MASK] token 不存在于下游的微调任务中，从而**导致了预训练与微调之间的差异**。
2. 此外，[MASK] 的**另一个缺点**在于，对于给定了 [MASK] token，**模型假定其彼此相互独立**，这时就会出现一个问题，比如说 '2008 年全球金融危机'，假如我们 MASK 了金融和危机，AE 模型在预测时会假设两个 [MASK] 之间相互独立，但我们知道，这两个 [MASK] token 之间是有相关性的。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N09-XLNet-20201214-201043-741170.png)

而本文介绍的 XLNet 是一种新的 AR 语言模型，其既能学习上下文信息，又能避免了 AE 语言模型的缺点。



# XLNet

## **AR & AE Language Model**

我们先给出 AE 和 AR 模型的数学表达式。

首先 **AR 模型**是利用上文预测下文，通过最大似然来进行预训练：
$$
\max \log p_{\theta}(x)=\sum_{t=1}^{T} \log p_{\theta}\left(x_{t} | \mathbf{x}_{< t}\right)
$$
**如：**x = {阳 新 是 我 的 家 乡}， p(x) = p(阳) * p(新|阳) * p(是|阳新) ···，   当t = 4时，log p(我|阳新是)

---

而 **AE 模型**是重构 [MASK] 的 token：
$$
\max \log p_{\theta}(\bar{x} | \hat{\mathbf{x}}) \approx \sum_{t=1}^{T} m_{t} \log p_{\theta}\left(x_{t} | \hat{\mathrm{x}}\right)
$$
其中， $\bar{x}$表示被 mask 的 token，$\hat{\mathrm{x}}$ 表示 mask 后的序列（没有被 mask 的 token）， $m_t = 1$表示$x_t$ 被 mask 了。用**约等于**是因为 BERT 是基于**独立性假设**的，masked token 是分别重建的。**如**：p(阳 新 | 是 我 家) = p(阳 | 是 我 家) * p(新 | 是 我 家)



## **Permutation Language Model**

作者提出了**全排列语言建模**（Permutation Language Model），不仅保留了 AR 模型的优点，而且允许模型捕获双向上下文。从名字中我们也可以看出，其利用全排列的思想：对于长度为 T 的序列，共有 $T !$个不同排序方式。

我们以长度为 4 的序列为例，那么就有 24 种可能，假设我们要预测 $x_3$，$x_3$ 的位置可以放在四个位置上，下图是其中几个排列：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N09-XLNet-20201214-201043-666400.png)

很直观地可以看到，即使是使用单向模型也可以获得 $x_3$ 的上下文信息。我们可以用公式表示**目标函数**：

$$
\max \quad \mathbb{E}_{z \sim Z_{T}}\left[\sum_{t=1}^{T} \log p_{\theta}\left(x_{z_{t}} | \mathbf{x}_{z<t}\right)\right]
$$
其中， $Z_{T}$是长度为$T$的序列的所有可能排列的集合, **抽样求期望**。

当然我们不会真的去调整他们的顺序，而是分为**原本序列顺序**和**分解顺序**（Factorization Order）。我们只影响分解顺序，而不影响序列的顺序：预测的都是x3，第一个3之前没有，第二个3之前有2、4，所有连接2和4，第三个前面有1、4、2，.....同理。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N09-XLNet-20201214-201043-619218.png)

这样做的原因是因为在下游的微调阶段，模型训练的数据是有序的，所以我们还是需要保持原序列的顺序使得其可以和原本的位置编码一一对应。 

但是具体该怎么实现呢？在保证原序列不变的情况下，还能有全排列的效果。



## **Two-Stream Self-Attention**

为了实现上面全排列的目标，作者设计一个**双流自注意力机制**（Two-Stream Self-Attention），这里的双流是指**内容流（Content Stream）**和**查询流（Query Stream）**：h包含内容和位置，g只包含位置。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N09-XLNet-20201214-201043-716322.png)

假设现在我们有一个分解顺序$\left[x_{3}, x_{2}, x_{4}, x_{1}\right]$ 。

左上角是计算**内容表示**（Content Representation），如果我们想预测 $x_1$的内容表示，我们会利用所有的 token 的内容表示（因为 $x_1$ 在最后面），而如果要预测 $x_2$ 的话，就只能看到 $x_3, x_2$，计算过程是和标准 Attention 一致的，但是我们通过 mask 的方式定义了一个新的顺序。

左下角是计算**查询表示**（Query Representation），如果我们要预测 $x_1$ 的查询表示，就不能看到 $x_1$ 的内容表示。XLNet 的特殊之处在于引入了 Query 流，Query 流的作用类似于 BERT 的 mask，起到屏蔽的作用，但是又没有像 BERT 一样引入了 [MASK] 这个 token 记号。

右边是整个**计算过程**，从下到上首先将内容表示 h 和查询表示 g 初始化并进行 mask 分别得到**内容编码** e(x) 和**查询编码** w。然后将这两个流的通过 Attention 后进行输出。

这里要注意内容掩码和查询掩码都是矩阵，内容掩码和查询掩码的第 $i$ 行代表 $x_i$能看到的其它的 token。内容掩码和查询掩码之间的唯一区别是查询掩码中的对角元素为 0，即 token 看不到自己。图中，红色标记是起作用的，白色部分是不起作用的。

总的来说，**输入句子只有一个顺序，但是我们可以利用不同的 Attention Mask 来实现不同的分解顺序**。



## **Incorporating Ideas from Transformer-XL**

由于 XLNet 适合 AR 语言模型，所以作者将最新的 Transformer-XL 整合到预训练框架中。

Transformer-XL 有两个关键部分：**相对位置编码方案**和**分段递归机制**。相对位置编码很方便融合，而对于分段递归机制来说，就是要重用先前的隐藏状态。这个也很好解决，我们可以回头看下这张图，其中的 mem 就是分段递归机制中的 Memory，存放着先前片段的隐藏层状态。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N09-XLNet-20201214-201043-644007.png)

## **Discussion**

这里我们讨论下 BERT 的独立性假设带来的问题（mask 间相互独立），为了更好的了解其差异，我们以 [New, York, is, a, city] 为例。假设两个模型都 mask 了 New 和 York，BERT 和 XLNet 的目标函数如下：

$$
\begin{array}{c}
\mathcal{J}_{\mathrm{BERT}}=\log p(\mathrm{New} | \text { is a city })+\log p(\text { York } | \text { is a city }) \\
\mathcal{J}_{\mathrm{XLNet}}=\log p(\mathrm{New} | \text { is a city })+\log p(\text { York } | \mathrm{new}, \mathrm{is} \text { a ciry })
\end{array}
$$
可以看到，XLNet 可以捕捉到（New，York）之间的依赖关系，而 BERT 捕捉不到。尽管 BERT 学习了一些依赖对，例如（New，city）和（York，city），但很明显，XLNet 可以学到更多的依赖对。



# Experiments

简单看一下的实验。

与 BERT 的单挑：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N09-XLNet-20201214-201043-712979.png)

单挑其他模型：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N09-XLNet-20201214-201043-731453.png)

# Conclusion

`总结`：**XLNet 是一种通用的 AR 语言模型架构的预训练方法，它使用 Permutation Language Model 建模结合了 AR 和 AE 方法的优点，并采用 Two-Stream Self-Attention 避开了 BERT 的 [MASK] 所带来的影响。此外，XLNet 还集成了 Transformer-XL 的优点，这使得 XLNet 在诸多 NLP 任务中都获得了不错的效果。**



# Reference

1. https://mp.weixin.qq.com/s/K4rII1Vx7bMJMPp5bDI3vw
2. 《XLNet: Generalized Autoregressive Pretraining for Language Understanding》
3. 《What is XLNet and why it outperforms BERT》
4. 《What is Two-Stream Self-Attention in XLNet》