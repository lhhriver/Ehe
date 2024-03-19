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
#!use/bin/env python
# -*- coding:utf-8 -*-


"""
1. 弱分类器训练(本文使用的是单层决策树)
2. 弱分类器合并成强分类器
    弱分类器的训练是串行进行的, 前面分类器的训练结果会影响后面的分类器
    (1) 训练集中的每个样本都赋一个权重, 这些权重合成向量 D;
    (2) D 全部初化为 1/m, m为样本数
    (3) 以 D 为参数对训练集进行训练, 得到一个弱分类器 (包含最佳划分规则, 最低错误率等)
    (4) 根据错误率计算出分类器权重 α, 再根据 α 调整 D
    (5) 循环 (3)->(4), 直至最低错误率为 0, 或达到设定的迭代次数
    (6) 分类时, 由于每个分类器都有自己的分类结果, 及权重 α, 按以下公式得到新样本所属分类
"""
```

```python
import numpy as np
```

```python
# 生成数据
def loadSimpData():
    datMat = np.matrix([[1., 2.1],
                     [2., 1.1],
                     [1.3, 1.],
                     [1., 1.],
                     [2., 1.]])
    classLabels = [1.0, 1.0, -1.0, -1.0, 1.0]
    return datMat, classLabels
```

```python
dataMat , classLables = loadSimpData()
print (u"数据集为：\n",dataMat)
print (u"\n标签为：\n",classLables)
```

```python
def stumpClassify(dataMatrix, dimen, threshVal, threshIneq):
    '''
    just classify the data
    概述：根据阈值、'lt','gt'对数据进行分类
    :param dataMatrix: 数据矩阵
    :param dimen: 列号
    :param threshVal: 阈值
    :param threshIneq: 'lt','gt'
    :return:
    '''

    retArray = np.ones((np.shape(dataMatrix)[0], 1))  # 先全部初始化为 1, 后面只要对需要设置 -1 的部分进行设置即可
    if threshIneq == 'lt':
        retArray[dataMatrix[:, dimen] <= threshVal] = -1.0
    else:
        retArray[dataMatrix[:, dimen] > threshVal] = -1.0
    return retArray
```

```python
def buildStump(dataArr, classLabels, D):  # 数据、标签、初始权重
    '''
    概述：根据固定步长，阈值，大于、小于遍历所有列，得出最佳单层决策树
    :param dataArr: 数据
    :param classLabels: 标签
    :param D: 初始权重
    :return:
    输出：bestStump：错误率最小的单层决策树,
            minError：最小权重错误率,
            bestClasEst：估计的类别向量

    '''
    dataMatrix = np.mat(dataArr)  # 数据
    labelMat = np.mat(classLabels).T  # 标签
    m, n = np.shape(dataMatrix)  # 行数，列数
    numSteps = 10.0  # 步数
    bestStump = {}  # 用于存储给定权重向量D时所得到的最佳单层决策树的相关信息
    bestClasEst = np.mat(np.zeros((m, 1)))  # 估计的类别向量
    minError = np.inf  # 最小错误率初始化为正无穷

    for i in range(n):  # 遍历所有列, 即所有属性值
        rangeMin = dataMatrix[:, i].min()  # 取第 i 列的最小值
        rangeMax = dataMatrix[:, i].max()  # 取第 i 列的最大值
        stepSize = (rangeMax - rangeMin) / numSteps  # 计算步长

        for j in range(-1, int(numSteps) + 1):  # 对当前列(属性值), 逐个步长进行遍历
            for inequal in ['lt', 'gt']:  # 大于和小于当前阈值都要进行考虑,'lt' 表示 less than, 'gt' 表示 greater than
                threshVal = (rangeMin + float(j) * stepSize)  # 当前阈值
                # 根据当前阈值划分(按大于/小于), 满足(大于/小于) 的就置为 1
                predictedVals = stumpClassify(dataMatrix, i, threshVal, inequal)  # 调用函数stumpClassify

                # 与真正类别检签值相一致的设为 0, 不一致的设为 1
                errArr = np.mat(np.ones((m, 1)))
                errArr[predictedVals == labelMat] = 0

                # 计算加权错误率, 并保存错误率最小时的 dim, thresh, ineq
                weightedError = D.T * errArr  # calc total error multiplied by D
                print(u"划分: 列 %d, 阈值 %.2f, 阈值判别: %s, 加权错误率 %.3f " % (i, threshVal, inequal, weightedError))
                if weightedError < minError:
                    minError = weightedError
                    bestClasEst = predictedVals.copy()
                    bestStump['dim'] = i  # 第 i列
                    bestStump['thresh'] = threshVal  # 阈值
                    bestStump['ineq'] = inequal  # 划分依据，'lt', 'gt'
    return bestStump, minError, bestClasEst  # 错误率最小的单层决策树、最小错误率、估计的类别向量
```

```python
D = np.mat(np.ones((5,1))/5)
dataMat , classLables = loadSimpData()
bestStump, minError, bestClasEst = buildStump(dataMat, classLables, D)
```

```python
def adaBoostTrainDS(dataArr, classLabels, numIt=40):
    '''
    概述：基于单层决策树的Adaboost训练过程
    :param dataArr: 数据
    :param classLabels: 标签
    :param numIt: 循环最大次数
    :return: weakClassArr：弱分类器, aggClassEst：类别看估计累计值
    '''
    weakClassArr = []  # 初始化弱分类器
    m = np.shape(dataArr)[0]  # 行数
    D = np.mat(np.ones((m, 1)) / m)  # D为样本权重，和为1
    aggClassEst = np.mat(np.zeros((m, 1)))  # 记录每个数据点的类别估计累计值

    for i in range(numIt):
        bestStump, error, classEst = buildStump(dataArr, classLabels, D)  # 返回错误率最小的单层决策树、最小错误率、估计的类别向量

        # 计算分类器权重alpha，更新样本权重D
        alpha = float(0.5 * np.log((1.0 - error) / max(error, 1e-16)))  # max确保没有错误时不会除以0溢出
        bestStump['alpha'] = alpha  # 存入字典中
        weakClassArr.append(bestStump)  # 以数组形式存储弱分类器

        # 正确分类，mat(classLabels).T, classEst)为正，错误分类则为负
        expon = np.multiply(-1 * alpha * np.mat(classLabels).T, classEst)  # multiply矩阵点乘，若是矩阵和向量，则矩阵每行与向量点乘得到新矩阵
        D = np.multiply(D, np.exp(expon))  # 计算新的样本权重 D
        D = D / D.sum()  # 得到新的 D，用于下次计算

        # 计算所有分类器的训练误差---累计误差
        aggClassEst += alpha * classEst  # 累计预测类
        print(u"类别估计累计值: ", aggClassEst.T)

        aggErrors = np.multiply(np.sign(aggClassEst) != np.mat(classLabels).T, np.ones((m, 1)))  # sign(aggClassEst)即为预测的类别，等于真实值
        errorRate = aggErrors.sum() / m  # 计算总误差
        print(u"累计总误差为: ", errorRate)
        if errorRate == 0.0:  # 如误差为 0，跳出循环，分类结束
            break
    return weakClassArr, aggClassEst  # 分类器，累计预测类别
```

```python
dataMat , classLables = loadSimpData()
weakClassArr, aggClassEst = adaBoostTrainDS(dataMat, classLables, 30)
```

```python
def adaClassify(datToClass, classifierArr):
    '''
    AdaBoost分类函数
    :param datToClass: 测试数据集
    :param classifierArr: 分类器
    :return:
    '''
    dataMatrix = np.mat(datToClass)  # do stuff similar to last aggClassEst in adaBoostTrainDS
    m = np.shape(dataMatrix)[0]
    aggClassEst = np.mat(np.zeros((m, 1)))  # 累计预测类别
    for i in range(len(classifierArr)):
        classEst = stumpClassify(dataMatrix, classifierArr[i]['dim'], \
                                 classifierArr[i]['thresh'], \
                                 classifierArr[i]['ineq'])  # call stump classify
        aggClassEst += classifierArr[i]['alpha'] * classEst
        print(aggClassEst)
    return np.sign(aggClassEst)  # sign 为符号函数, 即 aggClassEst 为正数, 则返回 1, 否则返回 -1
```

```python
dataMat , classLables = loadSimpData()
weakClassArr, aggClassEst = adaBoostTrainDS(dataMat, classLables, 30)
adaClassify([[5,5],[0,0]], weakClassArr)
```

```python
# 在一个难数据集上的应用-----------------------------------------------------
# 加载数据
def loadDataSet(fileName):  # general function to parse tab -delimited floats
    numFeat = len(open(fileName).readline().split('\t'))  # get number of fields
    dataMat = []
    labelMat = []
    fr = open(fileName)
    for line in fr.readlines():
        lineArr = []
        curLine = line.strip().split('\t')
        for i in range(numFeat - 1):
            lineArr.append(float(curLine[i]))
        dataMat.append(lineArr)  # 数据
        labelMat.append(float(curLine[-1]))  # 标签
    return dataMat, labelMat
```

```python
dataArr , labelArr = loadDataSet('datasets/horseColicTraining2.txt')
weakClassArr, aggClassEst = adaBoostTrainDS(dataArr, labelArr, 30)

testArr , testLabelArr = loadDataSet('datasets/horseColicTest2.txt')
prediction = adaClassify(testArr, weakClassArr)
```

# 绘制ROC曲线及AUC计算

```python
def plotROC(predStrengths, classLabels):
    import matplotlib.pyplot as plt
    %matplotlib inline
    
    cur = (1.0, 1.0)  # cursor
    ySum = 0.0  # variable to calculate AUC
    numPosClas = sum(np.array(classLabels) == 1.0)
    yStep = 1 / float(numPosClas)
    xStep = 1 / float(len(classLabels) - numPosClas)
    sortedIndicies = predStrengths.argsort()  # get sorted index, it's reverse
    fig = plt.figure(figsize=(12,8))
    fig.clf()
    ax = plt.subplot(111)
    # loop through all the values, drawing a line segment at each point
    for index in sortedIndicies.tolist()[0]:
        if classLabels[index] == 1.0:
            delX = 0
            delY = yStep
        else:
            delX = xStep
            delY = 0
            ySum += cur[1]
        # draw line from cur to (cur[0]-delX,cur[1]-delY)
        ax.plot([cur[0], cur[0] - delX], [cur[1], cur[1] - delY], c='r')
        cur = (cur[0] - delX, cur[1] - delY)
        
    ax.plot([0, 1], [0, 1], 'b--')
    plt.xlabel('False positive rate')
    plt.ylabel('True positive rate')
    plt.title('ROC curve for AdaBoost horse colic detection system')
    ax.axis([0, 1, 0, 1])
    plt.show()
    return ySum * xStep
```

```python
dataArr , labelArr = loadDataSet('datasets/horseColicTraining2.txt')
weakClassArr, aggClassEst = adaBoostTrainDS(dataArr, labelArr, 30)
```

```python
auc = plotROC(aggClassEst.T, labelArr)
print("the Area Under the Curve is: ", auc)
```

```python

```
