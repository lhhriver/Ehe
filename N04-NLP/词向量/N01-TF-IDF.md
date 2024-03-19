# 简述

**TF-IDF**(Term Frequency -  Inverse Document Frequency)。
$$
\begin{align}
TF-IDF(x)=TF(x) * IDF(x)
\end{align}
$$
**TF(x)**指词x在当前文本中的**词频**。

**IDF(x)**即`逆文本频率`， IDF**反应了一个词在所有文本中出现的频率**。
$$
\begin{align}
IDF(x)=log \frac{N}{N(x)}
\end{align}
$$
其中，$N$代表语料库中文本的总数，而$N(x)$代表语料库中包含词$x$的文本总数, 即$\frac{N}{N(x)} >= 1$，$log \frac{N}{N(x)} >=0$。**意味着$N(x)$越大，$IDF(x)$值越小**。



# 文本向量化特征的不足


```python
corpus = ["I come to China to travel",
          "This is a car polupar in China",
          "I love tea and Apple ",
          "The work is to write some papers in science"]
```


```python
# 不考虑停用词，处理后得到的词向量如下：
'''
[[0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 2 1 0 0]
 [0 0 1 1 0 1 1 0 0 1 0 0 0 0 1 0 0 0 0]
 [1 1 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0]
 [0 0 0 0 0 1 1 0 1 0 1 1 0 1 0 1 0 1 1]]
 '''
```

如果我们直接将统计词频后的19维特征做为文本分类的输入，会发现有一些问题。

比如第一个文本，我们发现"come","China"和“Travel”各出现1次，而“to“出现了两次。似乎看起来这个文本与”to“这个特征更关系紧密。但是实际上”to“是一个非常普遍的词，几乎所有的文本都会用到，因此虽然它的词频为2，但是重要性却比词频为1的"China"和“Travel”要低的多。

如果我们的向量化特征仅仅用词频表示就无法反应这一点。因此我们需要进一步的预处理来反应文本的这个特征，而这个预处理就是TF-IDF。



# TF-IDF概述

1. **TF-IDF**是Term Frequency -  Inverse Document Frequency的缩写，即“词频-逆文本频率”。

2. **TF**即`词频`，**文本中各个词的出现频率统计**。

3. **IDF**即`逆文本频率`， IDF**反应了一个词在所有文本中出现的频率**。

	- 如果一个词在很多的文本中出现，那么它的IDF值应该低，比如上文中的“to”。
	- 如果一个词在比较少的文本中出现，那么它的IDF值应该高。比如一些专业的名词如“Machine Learning”。这样的词IDF值应该高。
	- 一个极端的情况，如果一个词在所有的文本中都出现，那么它的IDF值应该为0。

	

## 基本公式

1. 一个词 x 的基本IDF公式如下：

$$
\begin{align}
IDF(x)=log \frac{N}{N(x)}
\end{align}
$$

其中，$N$代表语料库中文本的总数，而$N(x)$代表语料库中包含词$x$的文本总数, 即$\frac{N}{N(x)} >= 1$，$log \frac{N}{N(x)} >=0$且$N(x)$。**意味着$N(x)$越大，$IDF(x)$值越小**。

2. 特殊情况：

比如某一个生僻词在语料库中没有，这样我们的分母为0， IDF没有意义了。所以常用的IDF我们需要做一些**平滑**，最常见的IDF平滑后的公式之一为：
$$
\begin{align}
IDF(x)=log \frac{N+1}{N(x)+1} +1
\end{align}
$$

3. 有了IDF的定义，我们就可以计算某一个词的TF-IDF值了：

$$
\begin{align}
TF-IDF(x)=TF(x) * IDF(x)
\end{align}
$$

其中$TF(x)$指词x在当前文本中的词频。



# 用scikit-learn进行TF-IDF预处理


```python
# 第一种方法是在用CountVectorizer类向量化之后，再调用TfidfTransformer类进行预处理。
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.feature_extraction.text import CountVectorizer

corpus = ["I come to China to travel",
          "This is a car polupar in China",
          "I love tea and Apple ",
          "The work is to write some papers in science"]

vectorizer = CountVectorizer()

transformer = TfidfTransformer()
tfidf = transformer.fit_transform(vectorizer.fit_transform(corpus))
print("各个文本各个词的TF-IDF值如下:\n", tfidf)
```

    各个文本各个词的TF-IDF值如下:
      (0, 16)	0.4424621378947393
      (0, 15)	0.697684463383976
      (0, 4)	0.4424621378947393
      (0, 3)	0.348842231691988
      (1, 14)	0.45338639737285463
      (1, 9)	0.45338639737285463
      (1, 6)	0.3574550433419527
      (1, 5)	0.3574550433419527
      (1, 3)	0.3574550433419527
      (1, 2)	0.45338639737285463
      (2, 12)	0.5
      (2, 7)	0.5
      (2, 1)	0.5
      (2, 0)	0.5
      (3, 18)	0.3565798233381452
      (3, 17)	0.3565798233381452
      (3, 15)	0.2811316284405006
      (3, 13)	0.3565798233381452
      (3, 11)	0.3565798233381452
      (3, 10)	0.3565798233381452
      (3, 8)	0.3565798233381452
      (3, 6)	0.2811316284405006
      (3, 5)	0.2811316284405006



```python
# 第二种方法是直接用TfidfVectorizer完成向量化与TF-IDF预处理。
from sklearn.feature_extraction.text import TfidfVectorizer

tfidf2 = TfidfVectorizer()
tfidf = tfidf2.fit_transform(corpus)
print ("各个文本各个词的TF-IDF值如下:\n", tfidf)
```

    各个文本各个词的TF-IDF值如下:
      (0, 4)	0.4424621378947393
      (0, 15)	0.697684463383976
      (0, 3)	0.348842231691988
      (0, 16)	0.4424621378947393
      (1, 3)	0.3574550433419527
      (1, 14)	0.45338639737285463
      (1, 6)	0.3574550433419527
      (1, 2)	0.45338639737285463
      (1, 9)	0.45338639737285463
      (1, 5)	0.3574550433419527
      (2, 7)	0.5
      (2, 12)	0.5
      (2, 0)	0.5
      (2, 1)	0.5
      (3, 15)	0.2811316284405006
      (3, 6)	0.2811316284405006
      (3, 5)	0.2811316284405006
      (3, 13)	0.3565798233381452
      (3, 17)	0.3565798233381452
      (3, 18)	0.3565798233381452
      (3, 11)	0.3565798233381452
      (3, 8)	0.3565798233381452
      (3, 10)	0.3565798233381452

- TF-IDF是非常常用的文本挖掘预处理基本步骤，但是如果预处理中使用了Hash Trick，则一般就无法使用TF-IDF了，因为Hash Trick后我们已经无法得到哈希后的各特征的IDF的值。
- 使用了TF-IDF并标准化以后，我们就可以使用各个文本的词特征向量作为文本的特征，进行分类或者聚类分析。
- 当然TF-IDF不光可以用于文本挖掘，在信息检索等很多领域都有使用。因此值得好好的理解这个方法的思想。

- 参考资料：https://www.cnblogs.com/pinard/p/6693230.html



# 代码实现


```python
import math

# 文档
corpus = ["I come to China to travel",
          "This is a car polupar in China",
          "I love tea and Apple ",
          "The work is to write some papers in science"]

# 文章
text = "I love my working very much"

# idf值统计方法
def train_idf(doc_list):
    """
    doc_list：文档
    """
    idf_dic = {}
    # 总文档数
    tt_count = len(doc_list)

    # 每个词出现的文档数，每个文档只算一次
    for doc in doc_list:
        for word in set(doc.split()):
            idf_dic[word] = idf_dic.get(word, 0.0) + 1.0

    # 按公式转换为idf值，分母加1进行平滑处理
    for k, v in idf_dic.items():
        idf_dic[k] = math.log(tt_count / (1.0 + v))

    # 对于没有在字典中的词，默认其仅在一个文档出现，得到默认idf值
    default_idf = math.log(tt_count / (1.0))
    return idf_dic, default_idf

def tfidf_extract(text, idf_dic, default_idf):
    """
    text：输入的文章 
    idf_dic, default_idf：逆文档频率，默认频率
    """

    tf_dic = {} # tf值
    text = text.split()
    for word in text:
        tf_dic[word] = tf_dic.get(word, 0.0) + 1.0

    tt_count = len(text)
    for k, v in tf_dic.items():
        tf_dic[k] = float(v) / tt_count

    tf_idf = {}
    for word in text:
        idf = idf_dic.get(word, default_idf)
        tf = tf_dic.get(word, 0)

        tfidf = tf * idf
        tf_idf[word] = tfidf

    # 根据tf-idf排序，去排名前keyword_num的词作为关键词
    tf_idf = sorted(tf_idf.items(), key=lambda x: x[1], reverse=True)
    return tf_idf


idf_dic, default_idf = train_idf(corpus)
tf_idf = tfidf_extract(text, idf_dic, default_idf)
print(idf_dic)
print(tf_idf)
```




    {'to': 0.28768207245178085,
     'China': 0.28768207245178085,
     'I': 0.28768207245178085,
     'travel': 0.6931471805599453,
     'come': 0.6931471805599453,
     'This': 0.6931471805599453,
     'a': 0.6931471805599453,
     'in': 0.28768207245178085,
     'car': 0.6931471805599453,
     'polupar': 0.6931471805599453,
     'is': 0.28768207245178085,
     'tea': 0.6931471805599453,
     'love': 0.6931471805599453,
     'and': 0.6931471805599453,
     'Apple': 0.6931471805599453,
     'science': 0.6931471805599453,
     'The': 0.6931471805599453,
     'some': 0.6931471805599453,
     'work': 0.6931471805599453,
     'papers': 0.6931471805599453,
     'write': 0.6931471805599453}




    [('my', 0.23104906018664842),
     ('working', 0.23104906018664842),
     ('very', 0.23104906018664842),
     ('much', 0.23104906018664842),
     ('love', 0.11552453009332421),
     ('I', 0.04794701207529681)]



# 案例实战

1. [搜狐新闻分类.ipynb](搜狐新闻分类.ipynb)