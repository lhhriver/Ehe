# 注意力机制的由来

在深度学习领域，注意力机制模仿的是人类认知的过程。当人看到如下“美女伤心流泪”图时，细细想一下，人在做出图片中美女是在伤心流泪的过程，应该是先整体扫描该图片；然后将视觉注意力集中到美女的脸部；集中到脸部之后，再进一步将视觉注意力集中到眼睛部位。最后发现了眼泪，得出美女是在伤心流泪的结论。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-832160.png)

人类在对信息进行处理的过程中，注意力不是平均分散的，而是有重点的分布。受此启发，做计算机视觉的朋友，开始在视觉处理过程中加入注意力机制(Attention)。随后，做自然语言处理的朋友们，也开始引入这个机制。在NLP的很多任务中，加入注意力机制后，都取得了非常好的效果。

那么，在NLP中，Attention机制是什么呢？ 从直觉上来说，与人类的注意力分配过程类似，就是在信息处理过程中，对不同的内容分配不同的注意力权重。下面我们详细看看，在自然语言处理中，注意力机制是怎么实现的。

# seq2seq结构及其中的Attention

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-844386.png)

如上图所示，是标准的编解码(seq2seq)机制的结构图，在机器翻译、生成式聊天机器人、文本摘要等任务中均有应用。其处理流程是通过编码器对输入序列进行编码，生成一个**中间的语义编码向量C**，然后在解码器中，对语义编码向量C进行解码，得到想要的输出。例如，在中英文翻译的任务中，编码器的输入是中文序列，解码器的输出就是翻译出来的英文序列。


可以看出，这个结构很"干净"，对于解码器来说，在解码出$y_1$,$y_2$,$y_3$时，**语义编码向量均是固定的**。我们来分析下这样是否合理。


假设输入的是"小明/喜欢/小红"，则翻译结果应该是"XiaoMing likes XiaoHong"。根据上述架构，在解码得到"XiaoMing", "likes", " XiaoHong"时，引入的语义编码向量是相同的，也就是"小明"，"喜欢"，"小红"在翻译时对得到"XiaoMing", "likes", " XiaoHong"的作用是相同的。这显然不合理，在解码得到"XiaoMing"时，"小明"的作用应该最大才对。


鉴于此，机智的NLP研究者们，认为应该在编解码器之间加入一种对齐机制，也就是在解码"XiaoMing"时应该对齐到"小明"。在《Neural Machine Translation By Jointly Learning To Align And Translate》中首次将这种对齐机制引入到机器翻译中。我们来看看，这是怎样的一种**对齐机制**。


我们先回顾一下刚才的编解码结构，其语义**编码向量**和**解码器状态**，通过如下的公式得到：
$$
\begin{array}{l}{\mathrm{h}=\mathrm{F}\left(x_{1}, x_{2}, \ldots, x_{n}\right)} \\ {\mathrm{s}_{i}=G\left(\mathrm{s}_{i-1}, h\right)}\end{array}
$$
通常在解码时语义编码向量是固定的。**若要实现对齐机制，在解码时语义编码向量应该随着输入动态的变化**。鉴于此，《Neural Machine Translation By Jointly Learning To Align And Translate》提出来一种对齐机制，也就是**Attention机制**。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-853156.png)

如上图示，论文中采用双向RNN来进行语义的编码，这不是重点，我们先不关注。其对齐机制整体思想是：**编码时，记下来每一个时刻的RNN编码输出$(h_1,h_2,h_3,..h_n)$；解码时，根据前一时刻的解码状态，即$y_{i-1}$，计算出来一组权重$(a_1,a_2,..a_n)$，这组权重决定了在当前的解码时刻，$(h_1,h_2,h_3,..h_n)$分别对解码的贡献。这样就实现了，编解码的对齐。**


下面我们用数学语言描述一下上面的过程。


首先，进行编码计算$(h_1,h_2,h_3,..h_n)$，$i$ 时刻的编码状态计算公式如下：
$$
\mathbf{h}_{\mathbf{i}}=F\left(x_{i}, h_{i-1}\right)
$$

$a_{ij}$是对不同时刻的编码状态取的权重值。由此可见，$i$ 时刻的**语义编码向量由不同时刻的编码状态加权求和得到**。

下面看看，如何取得权重向量$a$：
$$
\begin{array}
{c}{\mathrm{a}_{\mathfrak{i}, \mathrm{j}}=\frac{e_{i, j}}{\sum_{k=1}^{n} e_{i, k}}} \\ 
{\mathrm{e}_{\mathrm{i}, \mathrm{j}}=G\left(s_{i-1}, h_{j}\right)}
\end{array}
$$

权重向量$a_i$通过加入解码器前一个时刻的状态进行计算得到。$e_{ij}$表示在计算$C_i$时$h_j$的绝对权重。通过对其使用$softmax$函数得到$a_{ij}$。$a_{ij}$就是在计算$C_i$时，$h_j$编码状态的权重值。


得到权重向量$a_i$及语义编码向量$C_i$后，就可以计算当前时刻的解码状态了：
$$
\mathrm{s}_{i}=G\left(\mathrm{s}_{i-1}, \mathrm{c}_{i}\right)
$$

这就是编解码机制中注意力机制的基本内容了，**本质上就是为了实现编解码之间的对齐，在解码时根据前一时刻的解码状态，获取不同时刻编码状态的权重值并加权求和，进而获得该时刻语义编码向量**。

那么，抽离编解码机制，Attention机制的本质是什么呢？我们下面来看看。

# Attention机制的本质

我们回想一下，引入Attention机制的本意，是为了在信息处理的时候，恰当的分配好”注意力“资源。那么，要分配好注意力资源，就需要给每个资源以不同的权重，Attention机制就是计算权重的过程。

如下图所示:

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-857162.png)



如上图所示，我们由资源Value，需要根据当前系统的其他状态Key和Querry来计算权重用以分配资源Value。

也就是，可以用如下的数学公式来描述Attention机制：
$$
Attention(souce,Query) = \sum_{i=1}^{n}F(Query,Key_i)*Value_i
$$
F函数可以有很多，在Transformer中用的是点积。

# 图解 Attention

[本文翻译自](https://jalammar.github.io/visualizing-neural-machine-translation-mechanics-of-seq2seq-models-with-attention/)，[原文](https://blog.zhangxiann.com/202009012011/)

Attention 被广泛用于序列到序列（seq2seq）模型，这是一种深度学习模型，在很多任务上都取得了成功，如：机器翻译、文本摘要、图像描述生成。谷歌翻译在 2016 年年末开始使用这种模型。有 2 篇开创性的论文([Sutskever et al., 2014](https://papers.nips.cc/paper/5346-sequence-to-sequence-learning-with-neural-networks.pdf), [Cho et al., 2014](http://emnlp2014.org/papers/pdf/EMNLP2014179.pdf))对这些模型进行了解释。

然而，我发现，想要充分理解模型并实现它，需要深入理解一系列概念，而这些概念是层层递进的。我认为，如果能够把这些概念进行可视化，会更加有助于理解。这就是这篇文章的目标。当然你需要先了解一些深度学习的知识，才能读懂这篇文章。我希望这篇文章，可以对你理解上面提到的 2 篇论文有帮助。

一个典型的序列到序列（seq2seq）模型，接收的输入是一个（单词、字母、图像特征）序列，输出是另外一个序列。一个训练好的模型如下图所示：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-921248.gif)

在神经机器翻译中，一个输入序列是指一连串的单词。类似地，输出也是一连串单词。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-939898.gif)

## 进一步理解细节

模型是由编码器（Encoder）和解码器（Decoder）组成的。其中，编码器会处理输入序列中的每个元素，把这些信息转换为一个向量（称为上下文（context））。当我们处理完整个输入序列后，编码器把上下文（context）发送给解码器，解码器开始逐项生成输出序列中的元素。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-967962.gif)

这种机制，同样适用于机器翻译。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-990948.gif)

在机器翻译任务中，上下文（context）是一个向量（基本上是由数字组成的数组）。编码器和解码器一般都是循环神经网络（你可以看看 Luis Serrano写 的 [一篇关于循环神经网络](https://www.youtube.com/watch?v=UNmqTiOnRfg) 的精彩介绍）。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-789818.png)

上下文是一个浮点数向量。在下面，我们会可视化这些向量，使用更明亮的色彩来表示更大的值。

你可以在设置模型的时候设置上下文向量的长度。这个长度就是编码器 RNN 的隐藏层神经元的数量。上图的上下文向量长度为 4，但在实际应用中，上下文向量的长度可能是 256，512 或者 1024。

根据设计，RNN 在每个时间步接受 2 个输入，包括：

- 输入序列中的一个元素（在解码器的例子中，输入是指句子中的一个单词）
- 一个 hidden state（隐藏层状态）

这里提到的单词都需要表示为一个向量。为了把一个词转换为一个向量，我们使用一类称为**词嵌入**（Word Embedding） 的方法。这类方法把单词转换到一个向量空间，这种表示形式能够捕捉大量的单词的语义信息（例如，[king - man + woman = queen](http://p.migdal.pl/2017/01/06/king-man-woman-queen-why.html)）。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-808973.png)

我们在处理单词之前，需要把他们转换为向量。这个转换过程是使用 Word Embedding 算法来完成的。我们可以使用预训练好的词嵌入向量，或者在我们的数据集上训练自己的词嵌入向量。通常词嵌入向量长度是 200 或者 300，为了简单起见，我们这里的向量长度是 4。

现在，我们已经介绍完了向量/张量的基础知识，让我们回顾一下 RNN 的运行机制，并可视化这些 RNN 模型：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-909003.gif)

RNN 在每个时间步，采用上一个时间步的 hidden state（隐藏层状态） 和当前时间步的输入向量，来得到输出。在下文，我们会使用类似的动画，来说明这些向量在神经机器翻译模型里的运作机制。

在下面的动画中，编码器和解码器在每个时间步处理输入，并得到输出。由于编码器和解码器都是RNN，RNN 会根据当前时间步的输入，和前一个时间步的 hidden state（隐藏层状态），更新当前时间步的 hidden state（隐藏层状态）。

让我们看下编码器的 hidden state（隐藏层状态）。注意，最后一个 hidden state（隐藏层状态）实际上是我们传给解码器的上下文（context）。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201033-012252.gif)

同样地，解码器也持有 hidden state（隐藏层状态），而且也需要把 hidden state（隐藏层状态）从一个时间步传递到下一个时间步。我们现在关注的是 RNN 的主要处理过程，因此没有在上图中可视化解码器的 hidden state，因为这个过程和解码器是类似的。

现在让我们用另一种方式来可视化序列到序列（seq2seq）模型。下面的动画会让我们更加容易理解模型。这种方法称为展开视图。其中，我们不只是显示一个解码器，而是在时间上展开，每个时间步都显示一个解码器。通过这种方式，我们可以看到每个时间步的输入和输出。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201033-053998.gif)



## Attention 讲解

虽然我们将编码器的上下文向量传给解码器。但实际上，上下文向量是这类模型的瓶颈。因为这使得模型在处理长文本时面临非常大的挑战。

在 [Bahdanau et al., 2014](https://arxiv.org/abs/1409.0473) 和 [Luong et al., 2015](https://arxiv.org/abs/1508.04025) 两篇论文中，提出了一种解决方法。这 2 篇论文提出并改进了一种叫做注意力（Attention）的技术，它极大地提高了机器翻译的效果。注意力使得模型可以根据需要，关注到输入序列的相关部分。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-820334.png)



在上图中，在第 7 个时间步，注意力机制使得解码器在产生英语翻译之前，可以将注意力集中在 "étudiant" 这个词（在法语里，是 "student" 的意思）。这种从输入序列聚焦相关部分的能力，使得注意力模型，比没有注意力的模型，产生更好的结果。

让我们继续从高层次整体来理解注意力模型。一个注意力模型和经典的序列到序列（seq2seq）模型相比，主要有 2 点不同：

**首先**，编码器会把更多的数据传递给解码器。编码器把所有时间步的 hidden state（隐藏层状态）传递给解码器，而不是只传递最后一个 hidden state（隐藏层状态）。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201033-076929.gif)



**第二**，注意力模型的解码器在产生输出之前，会做一些额外的处理。为了把注意力集中在与该时间步相关的那些输入部分。解码器做了如下的处理：

1. 查看所有接收到的编码器的 hidden state（隐藏层状态）。其中，编码器中每个 hidden state（隐藏层状态）都对应到输入句子中一个单词。
2. 给每个 hidden state（隐藏层状态）打一个分数（我们先不说明这个分数的计算过程）。
3. 将每个 hidden state（隐藏层状态）乘以经过 softmax 归一化的对应分数，从而使得，得分高对应的 hidden state（隐藏层状态）会被放大，而得分低对应的 hidden state（隐藏层状态）会被缩小弱化。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-862126.gif)



这个加权平均的步骤，会发生在解码器的每个时间步。

现在，让我们把所有内容都融合到下面的图中，来看看注意力模型的整个过程：

1. 注意力模型的解码器 RNN 的输入包括：一个 <END> 的词嵌入向量，和一个经过初始化的解码器 hidden state（隐藏层状态）。
2. RNN 处理上述的 2 个输入，产生一个输出（注意这里的输出会被忽略）和一个新的 hidden state（隐藏层状态向量，图中表示为 h4）。
3. 注意力的计算步骤：我们使用编码器的 hidden state（隐藏层状态）和 h4 向量来计算这个时间步的上下文向量（C4）。
4. 我们把 h4 和 C4 拼接起来，得到一个向量。
5. 我们把这个向量输入一个前馈神经网络（这个网络是和整个模型一起训练的）。
6. 前馈神经网络的产生的输出表示这个时间步输出的单词。
7. 在下一个时间步重复这个步骤。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-881731.gif)


下图，我们使用另一种方式来可视化注意力，看看在每个解码的时间步中关注输入句子的哪些部分：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201033-104103.gif)


请注意，注意力模型不是盲目地把输出的第一个单词对应到输入的第一个单词。实际上，它从训练阶段学习到了如何在两种语言中，找到对应单词的关系（在我们的例子中，是法语和英语）。下图展示了注意力机制的准确程度（图片来自于上面提到的论文）：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/Attention-20201214-201032-830030.png)



在上图中，你可以看到模型在输出 "European Economic Area" 时，注意力分数的分布情况。对于"européenne économique zone"这个词组，法语相对于英语的词序是相反的。而其他单词在两种语言中的顺序是类似的。

如果你觉得你准备好来学习注意力机制的代码实现，可以看看基于 TensorFlow 的 [神经机器翻译 (seq2seq) 指南](https://github.com/tensorflow/nmt)

我希望这篇文章会对你有帮助，文中的可视化的图片，来自于 Udacity 自然语言处理纳米课程](https://www.udacity.com/course/natural-language-processing-nanodegree--nd892)。在这门课里，我们会深入讨论更多细节，包括应用方面，并且会涉及到最近的注意力新方法，如来自于 [Attention Is All You Need](https://arxiv.org/abs/1706.03762) 的 Transformer。