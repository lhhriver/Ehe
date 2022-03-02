**我个人觉得这里面要弄清楚的问题包括：**

> 1、如果涉及NLP，比较重要的算法有EM，这个估计HMM参数时会用到的，要会写一个KMeans的代码来举例说明。
>
> 2、说到了HMM，还想提一下HMM中有一个viterbi算法，我个人觉得也是应该掌握的，要可以把代码写出来，熟悉动态规划的同学，一眼就看明白了，并不复杂。我觉得大家对熟悉BFS、DFS、DP应该理解上不会有偏差。
>
> 3、还有一点我想提的就是，NLP中的标注问题是怎么做的，从HMM到MEMM，再到CRF，两个假设条件是怎么被一步步去掉的，能不能举例把标注偏置说清楚。

对基本的分类和回归算法，我自己都在titanic和Boston housing price的数据集上试过，kaggle上也有两个相关的投票特别高的notebook，我建议大家看一下，运行一遍不会吃亏的。

深度学习的部分，我自己选的NLP，所以我想重点说NLP了，在说NLP之前，默认大家已经对BP算法的推导，CNN典型网络的结构以及里面的计算方式都特别清楚了，能清楚的表达里面每一层的参数有哪些，权重参数代表了什么，因为在NLP里面也有一个textCNN。



**NLP部分需要背诵、理解并默写的内容有：**

> 1、RNN的结构，LSTM的推导（图和六个公式），GRU的推导和公式，如果能把LSTM和GRU的推导和公式写出来，相信你也已经可以把他们的联系和区别说明白了。
>
> 
>
> 2、LSTM中为什么有sigmoid和tanh两种激活函数，他们的导数形式是什么样的。和梯度消失有什么关系。
>
> 
>
> 3、从RNN开始，是怎么一步一步解决梯度消失的问题的（RNN-LSTM-attention / self attention），大家了解一下seq2seq的结构，看看Luong关于attention的论文吧。
>
> 
>
> 4、Word2Vec 部分我建议后面参加集训营的同学看一下XinRong写的那篇论文。在读这个之前，你要确保自己已经非常熟悉BP和网上那篇通俗的博客 illustrated-word2vec。
>
> 
>
> 5、我还想再提一下self attention，因为真的太重要了，基本上面试必问的就是transformer和self-attention了，也建议大家把havard NLP的那个the annotated transformer的notebook跑通，知道里面的self-attention怎么计算的，原始输入包含哪几部分，两个mask有什么不同，用在什么时候，解码部分除了self-attention，还有一个encoder-decoder attention，到底是怎么回事，encoder传了什么东西给decoder。
>
> 当你对这些都清楚了之后，transformer论文里面的那张著名的结构图你也可以画出来了，你会发现每个箭头都是有意义的。
>
> 如果最开始感觉havard-nlp的这个比较难，或者内容比较多，也可以运行七月推荐的那个简易版的。最后顺着简易版，找到代码仓库，把仓库里的代码也都跑一遍吧。
>
> 
>
> 6、其实搞完了transformer之后，就会发现名动江湖的bert已经不再神秘了，多读几遍论文把里面的调过的参数记一下。bert之后的模型我也虽然自己看的少，但是还是建议大家熟悉一下，特别是XLNET，把相对位置编码和permutation了解一下。
>
> 提到permutation，你要是不能用DFS把N-Queen和array permutation写出来，会不会感觉特别不好意思。

我想说一下项目部分，同学们做完简历后拿给老师看看，他们会告诉你工业上常用的模型是什么样的，你写的是不是合适。

> 1、如果你写了分类相关的任务，你至少可以把textCNN，LSTM， LSTM + attention，fasttext，transformer，bert这些说明白，输入输出是什么样的，在LSTM+attention的模型中score或者weight是如何计算的，transformer模型的输出层是什么样的，bert调了哪些参数，对效果有什么提升。
>
> 
>
> 2、如果是生成式对话的任务，要可以把seq2seq的结构说清楚，attention和self-attention说哪几点大家可以在模拟面的时候和老师沟通一下。beam-search的代码大家github上搜一搜，或者就直接去transformers库里面找好了。
>
> 这里我不多说beam-search和BFS的关系了，觉得各位都懂，反正你要是被问到了写不出来level-order-traversal，面试结果你瞬间就知道了。
>
> 
>
> 3、此外，还有tf-idf （代码必须得会，要不然别人会觉得面你是浪费时间），doc2vec，标注等各类任务或者技术，大家结合着自己的项目准备吧。



------

其实，我和大家说的好多都是一路走来，自己受过的挫折。我被要求现场写KMean算法的就有两次，要求我写汉诺塔的两次，sqrt的若干次，在蜻蜓FM面试被问到LSTM里面有哪些参数，我回答的特别不好。

我没有通过阿里的电话面试，滴滴和百度的数据分析面试也是一轮游。后来，我暗暗地把需要的知识和技能都补上了。所以我也不建议大家从零开始参加集训的，**在来之前，我觉得应该先好好熟悉一下要预习的内容。**