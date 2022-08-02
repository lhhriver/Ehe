---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.7.1
  kernelspec:
    display_name: Python 3
    language: python
    name: python3
---

```python

```

```python
# -*- coding: utf-8 -*-

"""
函数 4.1：生成数据
函数 4.2：将文档中所有单词组成一个不重复的列表
函数 4.3：词集模型，将文档转换成文档向量
函数 4.4：朴素贝叶斯分类器训练函数
函数 4.5：朴素贝叶斯分类函数
函数 4.6：朴素贝叶斯词袋模型，跟 4.3不同
---------------------------------------
函数 4.7：文件解析
函数 4.8：完整的垃圾邮件测试函数
-----------------------------------------
积累：
常用：
"""
```

```python
import numpy as np 

path = "D:\Pr_Anchor\Part01-Stu\Ch04-PA\Ch03-机器学习实战"
```

# 生成数据-loadDataSet

```python
def loadDataSet():
    """
    函数 4.1：生成数据
    说明：文档内容来自斑点犬爱好者留言板
    :return: postingList 数据集,classVec 类别标签
    """
    postingList = [['my', 'dog', 'has', 'flea', 'problems', 'help', 'please'],
                   ['maybe', 'not', 'take', 'him', 'to', 'dog', 'park', 'stupid'],
                   ['my', 'dalmation', 'is', 'so', 'cute', 'I', 'love', 'him'],
                   ['stop', 'posting', 'stupid', 'worthless', 'garbage'],
                   ['mr', 'licks', 'ate', 'my', 'steak', 'how', 'to', 'stop', 'him'],
                   ['quit', 'buying', 'worthless', 'dog', 'food', 'stupid']]
    classVec = [0, 1, 0, 1, 0, 1]  # 1 代表侮辱性文字, 0 代表正常言论
    return postingList, classVec
```

```python
# postingList, classVec = loadDataSet()
# print (u"处理后的文档词条：\n" ,postingList)
# print (u"类别标签为：\n", classVec)
```

# 生成单词表-createVocabList

```python
def createVocabList(dataSet):
    """
    函数 4.2：生成单词表
    说明：将文档中所有单词组成一个不重复的列表
    :param dataSet: 数据集
    :return: 单词表
    """
    vocabSet = set([])
    for document in dataSet:
        vocabSet = vocabSet | set(document)  # 求并集
    return list(vocabSet)
```

```python
# dataSet, classVec = loadDataSet()
# print (u"处理后的文档词条：\n" ,dataSet)

# myVocabList = createVocabList(dataSet)
# print (u"\n无重复的单词列表：\n" ,myVocabList)
```

# 词集模型-setOfWords2Vec

```python
def setOfWords2Vec(vocabList, inputSet):
    """
    函数 4.3：词集模型
    说明：将单行字符串转换成文档向量
    :param vocabList: 词汇表
    :param inputSet: 文档的一行
    :return: 这行文档的向量
    """

    returnVec = [0] * len(vocabList)  # 生成跟词汇表相同长度的列表，初始值为0
    for word in inputSet:
        if word in vocabList:
            returnVec[vocabList.index(word)] = 1  # 索引的使用
        else:
            print("the word: %s is not in my Vocabulary!" % word)
    return returnVec
```

```python
# postingList, classVec = loadDataSet()
# print(u"处理后的文档词条：\n", postingList)

# myVocabList = createVocabList(postingList)
# print(u"\n无重复的单词列表：\n", myVocabList)

# returnVec = setOfWords2Vec(myVocabList, postingList[3])
# print(u"\n文档向量为：\n", returnVec)
```

# 训练函数-trainNB0

```python
def trainNB0(trainMatrix, trainCategory):
    """
    函数 4.4：朴素贝叶斯分类器训练函数
    说明：将以转换成向量的文档进行统计，得出不同类别的文档中，单词出现的概率等
    :param trainMatrix: 文档向量
    :param trainCategory: 文档类别标签
    :return: p0Vect-正常文档中，每个单词出现的概率
             p1Vect-侮辱性文档中，每个单词出现的概率
             pAbusive-所有文档中，侮辱性文档的比例
    """
    numTrainDocs = len(trainMatrix)  # 文档行数
    numWords = len(trainMatrix[0])  # 每行单词数

    # 文档矩阵中属于侮辱性文档的概率
    pAbusive = sum(trainCategory) / float(numTrainDocs)

    """
    p0Num = zeros(numWords)  # 类别 0，单词个数初始值
    p0Denom = 0.0            # 单词总个数
    p1Num = zeros(numWords)  # 类别 1，单词个数初始值
    p1Denom = 0.0
    """

    # 避免一个概率为零，最后乘积为零，将zeros改成ones，分母初始化为 2
    p0Num = np.ones(numWords)  # 类别 0，单词个数初始值
    p0Denom = 2.0  # 单词总个数初始值

    p1Num = np.ones(numWords)  # 类别 1，单词个数初始值
    p1Denom = 2.0  # 单词总个数初始值

    for i in range(numTrainDocs):  # 遍历每篇文档，逐行处理
        if trainCategory[i] == 1:  # 遍历每篇文档中词类别，是1还是0
            p1Num += trainMatrix[i]  # 每个单词出现的次数
            p1Denom += sum(trainMatrix[i])  # 总单词数
        else:
            p0Num += trainMatrix[i]  # 每个单词出现的次数
            p0Denom += sum(trainMatrix[i])  # 总单词数

    # 计算p(w0|ci),...,p(wn|ci)
    """
    p0Vect = p0Num / p0Denom  #类别 0 的条件概率
    p1Vect = p1Num / p1Denom  #类别 1 的条件概率
    """
    # 避免结果太小，程序下溢或得不到正确的结果，取对数
    p0Vect = np.log(p0Num / p0Denom)  # 类别 0 的条件概率的对数
    p1Vect = np.log(p1Num / p1Denom)  # 类别 1 的条件概率的对数
    return p0Vect, p1Vect, pAbusive
```

```python
dataSet, trainCategory = loadDataSet()
vocabList = createVocabList(dataSet)
print(u"\n无重复的单词列表：\n", vocabList)

trainMatrix = []
for inputSet in dataSet:
    trainMatrix.append(setOfWords2Vec(vocabList, inputSet))

p0Vect, p1Vect, pAbusive = trainNB0(trainMatrix, trainCategory)

print(u"\n属于侮辱性词条的概率：\n", pAbusive)
print(u"\n正常文档中，词汇表中每个单词出现的概率：\n", p0Vect)
print(u"\n侮辱性文档中，词汇表中每个单词出现的概率：\n", p1Vect)
```

# 分类函数-classifyNB

```python
def classifyNB(vec2Classify, p0Vec, p1Vec, pClass1):
    """
    函数 4.5：朴素贝叶斯分类函数
    说明：将分类样本向量跟训练结果中不同类别的单词概率相乘，再求和，将样本判为大的那一类
    :param vec2Classify: 待分类向量
    :param p0Vec: 正常文档中，词汇表中每个单词出现的概率
    :param p1Vec: 侮辱性文档中，词汇表中每个单词出现的概率
    :param pClass1: 属于侮辱性词条的概率
    :return: 文档类别，0 正常，1侮辱
    """
    p1 = sum(vec2Classify * p1Vec) + np.log(pClass1)  # 原本是相乘，取对数后变成相加
    p0 = sum(vec2Classify * p0Vec) + np.log(1.0 - pClass1)
    if p1 > p0:
        return 1
    else:
        return 0
```

# 测试

```python
# 测试：
postingList, classVec = loadDataSet()
myVocabList = createVocabList(postingList)  # 词汇表

trainMatrix=[]
for postinDoc in postingList:
    trainMatrix.append(setOfWords2Vec(myVocabList, postinDoc))  # 将训练集转化成向量

p0Vect, p1Vect, pAbusive = trainNB0(trainMatrix, classVec)  # 计算概率
```

```python
# 测试1
testEntry = ['love', 'my', 'dalmation']
thisDoc = np.array(setOfWords2Vec(myVocabList, testEntry))  # 将输入样本转换成向量
print (testEntry, '\nclassified as: ', classifyNB(thisDoc, p0Vect, p1Vect, pAbusive))

```

```python
# 测试2
testEntry = ['stupid', 'garbage']
thisDoc = np.array(setOfWords2Vec(myVocabList, testEntry))
print (testEntry, '\nclassified as: ', classifyNB(thisDoc, p0Vect, p1Vect, pAbusive))
```

***
***
***


# 词袋模型-bagOfWords2VecMN

```python
def bagOfWords2VecMN(vocabList, inputSet):
    """
    函数4.6：朴素贝叶斯词袋模型
    说明：跟4.3的词集模型不同，单词出现次数可以大于1
    词袋模型中，每个单词可以出现多次，多次计数
    词集模型中，每个词只能出现一次
    :param vocabList: 词汇表
    :param inputSet: 一行数据集
    :return:
    """
    returnVec = [0] * len(vocabList)
    for word in inputSet:
        if word in vocabList:
            returnVec[vocabList.index(word)] += 1  # 跟 4.3不同
    return returnVec
```

```python
postingList, classVec = loadDataSet()
print (u"处理后的文档词条：\n" ,postingList)

myVocabList = createVocabList(postingList)
print (u"\n无重复的单词列表：\n" ,myVocabList)

returnVec = bagOfWords2VecMN(myVocabList, postingList[3])
print (u"\n文档向量为：\n" ,returnVec)
```

# 文本解析

```python
def textParse(bigString):
    """
    函数 4.7：文本解析
    说明：读取文本，去掉符号，并将长度大于2的筛选出来进行lower处理
    :param bigString: 字符串
    :return: 单词列表
    """
    import re  # 正则表达式
    listOfTokens = re.split(r'\W*', bigString)  # 去掉符号
    return [tok.lower() for tok in listOfTokens if len(tok) > 2]  # 统一成小写，筛选出长度大于2的单词

```

```python
bigString = 'This book is the best book on python or M.L. I have ever laid eyes upon.'
textParse(bigString)
```

# 垃圾邮件分类

```python
import os
path = os.getcwd()
path
```

```python
def spamTest():
    """
    函数 3.8：完整的垃圾邮件测试函数
    调用函数 4.7：文件解析
    调用函数 4.2：将文档中所有单词组成一个不重复的列表
    调用函数 4.6：朴素贝叶斯词袋模型
    调用函数 4.4：朴素贝叶斯分类器训练函数
    调用函数 4.5：分类器函数
    :return:
    """
    docList = []  # 数据集
    classList = []  # 类别标签
    fullText = []  # 全部邮件
    # 将邮件转化成向量，docList 数据，classList 标签

    for i in range(1, 26):  # 共 50个邮件，各25个，将邮件读到词条文档中****
        fw = open('datasets/email/spam/%d.txt' % i, 'r', errors="ignore").read()
        wordList = textParse(fw)  # 调用函数4.7进行文本解析
        docList.append(wordList)
        classList.append(1)

        fw = open('datasets/email/ham/%d.txt' % i, 'r', errors="ignore").read()
        wordList = textParse(fw)
        docList.append(wordList)
        classList.append(0)

    vocabList = createVocabList(docList)  # 调用函数 2，词汇表

    trainingSet = list(range(50))  # 共50个邮件
    testSet = []
    for i in range(10):  # 随机选取10个邮件用于测试，其余40个用于训练
        randIndex = int(np.random.uniform(0, len(trainingSet)))  # 0到50之间随机数
        testSet.append(trainingSet[randIndex])  # 测试数据集编号
        del (trainingSet[randIndex])  # 剩下的trainingSet用作训练数据集

    #
    trainMat = []  # 初始化训练集
    trainClasses = []  # 初始化标签
    for docIndex in trainingSet:
        trainMat.append(bagOfWords2VecMN(vocabList, docList[docIndex]))  # 调用函数4.6，转化成向量
        trainClasses.append(classList[docIndex])

    p0V, p1V, pSpam = trainNB0(np.array(trainMat), np.array(trainClasses))  # 调用函数4.4，计算概率

    errorCount = 0
    for docIndex in testSet:  # 分类测试
        wordVector = bagOfWords2VecMN(vocabList, docList[docIndex])  # 调用函数4.6，将测试集转化为向量
        if classifyNB(np.array(wordVector), p0V, p1V, pSpam) != classList[docIndex]:  # 调用函数4.5，贝叶斯分类函数
            errorCount += 1
            print("classification error", docList[docIndex])
    print('the error rate is: ', float(errorCount) / len(testSet))
```

```python
spamTest()
```

```python

```
