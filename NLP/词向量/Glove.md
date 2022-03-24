# 概述

GloVe的全称叫Global Vectors for Word Representation，它是一个基于**全局词频统计**（count-based & overall statistics）的词表征（word representation）工具，它可以把一个单词表达成一个由实数组成的向量，这些向量**捕捉到了单词之间一些语义特性**，比如相似性（similarity）、类比性（analogy）等。我们通过对向量的运算，比如欧几里得距离或者cosine相似度，可以计算出两个单词之间的语义相似性。

# 统计共现矩阵

设共现矩阵为$X$，其元素为$X_{i,j}$。$X_{i,j}$的意义为在整个语料库中，单词$i$和单词$j$共同出现在一个窗口中的次数。

- **举个栗子**,设有语料库：
	- I like deep learning.
	- I like NLP.
	- I enjoy flying.

有以上三句话，设置滑窗为2，可以得到一个词典：

> {“I like”,“like deep”,“deep learning”,“I like”,“like NLP”,“I enjoy”,“enjoy flying”}。

我们可以得到一个**共现矩阵**(对称矩阵)：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N03-Glove-20201214-201036-471817.png)

中间的每个格子表示的是行和列组成的词组在词典中共同出现的次数，也就体现了**共现**的特性。

- **GloVe的共现矩阵**

根据语料库（corpus）构建一个共现矩阵（Co-ocurrence Matrix）X，矩阵中的**每一个元素 $X_{ij}$ 代表单词 i 和上下文单词 j 在特定大小的上下文窗口（context window）内共同出现的次数**。

一般而言，这个次数的最小单位是1，但是GloVe不这么认为：它根据两个单词在上下文窗口的距离 d，提出了一个**衰减函数**（decreasing weighting）：decay=1/d 用于计算权重，也就是说距离越远的两个单词所占总计数（total count）的权重越小。



# 使用GloVe模型训练词向量

## 词向量和共现矩阵的近似关系

构建词向量（Word Vector）和共现矩阵（Co-ocurrence Matrix）之间的近似关系，论文的作者提出以下的公式可以近似地表达两者之间的关系：
$$
v_i^T\tilde{v_j}+b_i+\tilde{b}_j=log(X_{ij})
$$
其中，$v_i^T$和$\tilde{v}_j$是我们最终要求解的词向量；$b_i$和$\tilde{b}_j$分别是两个词向量的bias term。当然你对这个公式一定有非常多的疑问，比如它到底是怎么来的，为什么要使用这个公式，为什么要构造两个词向量$v_i^T$和$\tilde{v}_j$。


## 损失函数

先看模型**损失函数**长这个样子：

$$
J=\sum_{i,j}^Nf(X_{i,j})(v_{i}^Tv_{j}+b_{i}+b_{j}-log(X_{i,j}))^2
$$
$v_{i}$，$v_{j}$是单词$i$和单词$j$的**词向量**，$b_{i}$，$b_{j}$是两个**标量**（作者定义的偏差项），$f$是**权重函数**，$N$是词汇表的大小（共现矩阵维度为$N*N$）。可以看到，GloVe模型没有使用神经网络的方法。

  

## 权重函数

那么我们希望：

- 这些单词的权重要大于那些很少在一起出现的单词（rare co-occurrences），所以这个函数要是**非递减函数**（non-decreasing）；
- 但我们也不希望这个权重过大（overweighted），当到达一定程度之后应该不再增加；
- 如果两个单词没有在一起出现，也就是$X_{ij}=0$，那么他们应该不参与到 loss function 的计算当中去，也就是f(x) 要满足 f(0)=0。
	

作者通过实验确定权重函数为：
$$
f(x) =\begin{cases}(x/x_{max})^{\alpha}, & \text{if $x < x_{max}$} \\1, & \text{if $x >= x_{max}$}\end{cases}
$$


这个函数图像如下所示：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N03-Glove-20201214-201036-466831.jpg)



## GloVe是如何训练的

虽然很多人声称GloVe是一种无监督（unsupervised learing）的学习方式（因为它确实不需要人工标注label），但其实它还是有label的，这个label就是公式2中的$log⁡(X_{ij})$，而公式2中的向量$v$和$\tilde{v}_j$就是要不断更新/学习的参数，所以本质上它的训练方式跟监督学习的训练方法没什么不一样，都是基于梯度下降的。

具体地，这篇论文里的实验是这么做的：**采用了AdaGrad的梯度下降算法，对矩阵$X$中的所有非零元素进行随机采样，学习曲率（learning rate）设为0.05，在vector size小于300的情况下迭代了50次，其他大小的vectors上迭代了100次，直至收敛**。

最终学习得到的是两个vector是$v$和$\tilde{v}_j$，因为$X$是对称的（symmetric），所以从原理上讲$v$和$\tilde{v}_j$是也是对称的，他们唯一的区别是初始化的值不一样，而导致最终的值不一样。所以这两者其实是等价的，都可以当成最终的结果来使用。**但是为了提高鲁棒性，我们最终会选择两者之和$v + \tilde{v}_j$作为最终的vector（两者的初始化不同相当于加了不同的随机噪声，所以能提高鲁棒性）**。在训练了400亿个token组成的语料后，得到的实验结果如下图所示：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N03-Glove-20201214-201036-488961.jpg)

这个图一共采用了三个指标：语义准确度，语法准确度以及总体准确度。那么我们不难发现Vector Dimension在300时能达到最佳，而context Windows size大致在6到10之间。

---



# 模型怎么来的

那么作者为什么这么构造模型呢？首先定义几个符号：

- $X_{ij}$表示单词$j$出现在单词$i$的上下文中的次数；
- $X_i$表示单词$i$的上下文中所有单词出现的总次数，即$X_{i}=\sum_{j=1}^NX_{i,j}$ ,其实就是矩阵单词$i$那一行的和；
- 条件概率$P_{i,k} = P(k|i) = X_{i,k}/X_{i}$，即**表示单词$k$出现在单词$i$的上下文中的概率**；
- **两个条件概率的比率**: $ratio_{i,j,k}=\dfrac{P_{i,k}}{P_{j,k}}$

$ratio_{i,j,k}$这个指标是有规律的，规律统计在下表：
| $ratio_{i,j,k}$的值 | 单词$j$,$k$相关 | 单词$j$,$k$不相关 |
| :-----------------: | :-------------: | :---------------: |
|  单词$i$, $k$相关   |      趋近1      |       很大        |
| 单词$i$, $k$不相关  |      很小       |       趋近1       |

很简单的规律，但是有用。有了这些定义之后，我们来看一个表格：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N03-Glove-20201214-201036-486912.png)

理解这个表格的重点在最后一行，它表示的是两个概率的比值（ratio），**我们可以使用它观察出两个单词$i$和$j$相对于单词$k$哪个更相关（relevant）。**

**比如**:
- ice和solid更相关，而stream和solid明显不相关，于是我们会发现$P(solid|ice)/P(solid|steam)$比1大更多。
- 同样的gas和steam更相关，而和ice不相关，那么$P(gas|ice)/P(gas|steam)$就远小于1；
- 当都有关（比如water）或者都无关(fashion)的时候，两者的比例接近于1；这个是很直观的。

因此，**以上推断可以说明通过概率的比例而不是概率本身去学习词向量可能是一个更恰当的方法**，因此下文所有内容都围绕这一点展开。



---

**思想**：假设我们已经得到了词向量，如果我们用词向量$v_{i}$、$v_{j}$、$v_{k}$通过某种函数计算$ratio_{i,j,k}$，能够同样得到这样的规律的话，就意味着我们词向量与共现矩阵具有很好的一致性，也就说明我们的词向量中蕴含了共现矩阵中所蕴含的信息。

设用词向量$v_{i}$、$v_{j}$、$v_{k}$计算$ratio_{i,j,k}$的函数为$g(v_{i},v_{j},v_{k})$（我们先不去管具体的函数形式），那么应该有：
$$
\dfrac{P_{i,k}}{P_{j,k}}=ratio_{i,j,k}=g(v_{i},v_{j},v_{k})
$$
即二者应该尽可能地接近；很容易想到用二者的差方来作为**代价函数**：
$$
J=\sum_{i,j,k}^N(\dfrac{P_{i,k}}{P_{j,k}}-g(v_{i},v_{j},v_{k}))^2
$$
但是仔细一看，模型中包含3个单词，这就意味着要在N\*N\*N的复杂度上进行计算，太复杂了，最好能再简单点。现在我们来仔细思考$g(v_{i},v_{j},v_{k})$，或许它能帮上忙；作者的脑洞是这样的：

1. 要考虑单词$i$和单词$j$之间的关系，那$g(v_{i},v_{j},v_{k})$中大概要有这么一项：$v_{i}-v_{j}$；在线性空间中考察两个向量的相似性，不失线性地考察，那么$v_{i}-v_{j}$大概是个合理的选择；
2. $ratio_{i,j,k}$是个标量，那么$g(v_{i},v_{j},v_{k})$最后应该是个标量啊，虽然其输入都是向量，那內积应该是合理的选择，于是应该有这么一项吧：$(v_{i}-v_{j})^Tv_{k}$。
3. 然后作者又往$(v_{i}-v_{j})^Tv_{k}$的外面套了一层指数运算$exp()$，得到最终的$g(v_{i},v_{j},v_{k})=exp((v_{i}-v_{j})^Tv_{k})$；

	

最关键的第3步，为什么套了一层$exp()$？套上之后，我们的目标是让以下公式尽可能地成立：
$$
\dfrac{P_{i,k}}{P_{j,k}}=exp((v_{i}-v_{j})^Tv_{k})
$$
即：
$$
\dfrac{P_{i,k}}{P_{j,k}}=exp(v_{i}^Tv_{k}-v_{j}^Tv_{k})
$$
即：
$$
\dfrac{P_{i,k}}{P_{j,k}}=\dfrac{exp(v_{i}^Tv_{k})}{exp(v_{j}^Tv_{k})}
$$
然后就发现找到简化方法了：只需要让上式分子对应相等，分母对应相等，即：


$$
P_{i,k}={exp(v_{i}^Tv_{k})}\\
P_{j,k}={exp(v_{j}^Tv_{k})}
$$

然而分子分母形式相同，就可以把两者统一考虑了，即：
$$
P_{i,j}={exp(v_{i}^Tv_{j})}
$$
两边取个对数：
$$
log(P_{i,j})=v_{i}^Tv_{j}
$$
那么代价函数就可以简化为：
$$
J=\sum_{i,j}^N(log(P_{i,j})-v_{i}^Tv_{j})^2
$$
现在只需要在N\*N的复杂度上进行计算，而不是N\*N\*N，现在关于为什么第3步中，外面套一层exp()就清楚了，正是因为套了一层exp()，才使得差形式变成商形式，进而等式两边分子分母对应相等，进而简化模型。

然而，出了点问题, 仔细看这两个式子：$log(P_{i,j})=v_{i}^Tv_{j}$和$log(P_{j,i})=v_{j}^Tv_{i}$, 其中 $log(P_{i,j})$不等于$log(P_{j,i})$,但是$v_{i}^Tv_{j}$等于$v_{j}^Tv_{i}$；即等式左侧不具有对称性，但是右侧具有对称性。

数学上出了问题, 补救一下。现将代价函数中的条件概率展开：
$$
\begin {aligned}
log(P_{i,j})&=log(\frac{X_{i,j}}{X_{i}}) \\
&= log(X_{i,j})-log(X_{i}) \\
&=v_{i}^Tv_{j}
\end {aligned}
$$
添了一个偏差项$b_{j}$，并将$log(X_{i})$吸收到偏差项$b_{i}$中,将其变为：
$$
log(X_{i,j})=v_{i}^Tv_{j}+b_{i}+b_{j}
$$
于是代价函数就变成了：
$$
J=\sum_{i,j}^N(v_{i}^Tv_{j}+b_{i}+b_{j}-log(X_{i,j}))^2
$$
然后基于出现频率越高的词对儿权重应该越大的原则，在代价函数中添加权重项，于是代价函数进一步完善：
$$
J=\sum_{i,j}^Nf(X_{i,j})(v_{i}^Tv_{j}+b_{i}+b_{j}-log(X_{i,j}))^2
$$

---





# Glove和skip-gram、CBOW模型对比

Cbow/Skip-Gram 是一个local context window的方法，比如使用NS来训练，**缺乏了整体的词和词的关系**，负样本采用sample的方式会缺失词的关系信息。另外，直接训练Skip-Gram类型的算法，很容易使得高曝光词汇得到过多的权重。

Global Vector融合了矩阵分解Latent Semantic Analysis (LSA)的全局统计信息和local context window优势。**融入全局的先验统计信息**，可以加快模型的训练速度，**又可以控制词的相对权重**。

我的理解是skip-gram、CBOW每次都是用一个窗口中的信息更新出词向量，但是Glove则是用了全局的信息（共线矩阵），也就是多个窗口进行更新。

# Glove与LSA、word2vec的比较

LSA（Latent Semantic Analysis）是一种比较早的count-based的词向量表征工具，它也是基于co-occurance matrix的，只不过采用了基于**奇异值分解（SVD）的矩阵分解技术对大矩阵进行降维**，而我们知道**SVD的复杂度是很高**的，所以它的计算代价比较大。还有一点是它对所有**单词的统计权重都是一致的**。而这些缺点在GloVe中被一一克服了。

而**word2vec最大的缺点则是没有充分利用所有的语料**，所以GloVe其实是把两者的优点结合了起来。从这篇论文给出的实验结果来看，GloVe的性能是远超LSA和word2vec的，但网上也有人说GloVe和word2vec实际表现其实差不多。



# 参考资料

1. http://www.fanyeong.com/tag/nlp/
2. https://blog.csdn.net/weixin_41510260/article/details/100049700
3. https://mp.weixin.qq.com/s/Ld7w7DneiiSLuICQSbA4IQ
4. https://github.com/hans/glove.py