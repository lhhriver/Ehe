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
# -*- coding: utf-8 -*-
"""
函数 1：加载数据
函数 2：Sigmoid 函数
函数 3：Logistic 回归分类函数
函数 4：梯度上升算法
函数 5：随机梯度上升算法
函数 6：改进的随机梯度上升算法
函数 7：测试函数：预测马的死亡率
函数 8：重复多次求平均值
函数 9：画出数据集和Logistic回归最佳拟合直线的函数
"""
```

```python
import numpy as np
from numpy.random import normal
```

# 函数 5.1：加载数据

```python
def loadDataSet():
    """
    函数 5.1：加载数据
    说明：原始数据示例 '0.197445\t9.744638\t0\n'
    :return: dataMat - 数据, labelMat - 标签
    """
    dataMat = []
    labelMat = []
    fr = open('datasets/testSet.txt')
    for line in fr.readlines():
        lineArr = line.strip().split()
        # 第一列为 1,直线方程 a+bx+cy=0
        dataMat.append([1.0, float(lineArr[0]), float(lineArr[1])])
        labelMat.append(int(lineArr[2]))  # 标签
    fr.close()
    return dataMat, labelMat
```

```python
dataMat, labelMat = loadDataSet()

print ("数据的shape为：",np.shape(dataMat))
print ("数据的shape为：",np.shape(labelMat))
```

## 函数 5.2：Sigmoid 函数

```python
def sigmoid(X):
    """
    函数 5.2：Sigmoid 函数
    说明：Sigmoid 函数值域为 (0,1)
    :param X: 输入变量 x
    :return: 对应的Sigmoid函数值
    """
    return 1.0 / (1 + np.exp(-X))
```

```python
sigmoid(0)
```

## 函数 5.3：Logistic 回归分类函数

```python
def classifyVector(inX, weights):
    """
    函数 5.3：Logistic 回归分类函数
    说明：
    :param inX: 输入变量 inx
    :param weights: 权重
    :return: 类别 0 或 1
    """
    prob = sigmoid(sum(inX * weights))
    if prob > 0.5:
        return 1.0
    else:
        return 0.0
```

```python
a = classifyVector(np.random.rand(5), normal(5))
print (u"样本的类别为：\n",a)
```

## 函数 5.4：梯度上升算法求最佳权值

```python
def gradAscent(dataMatIn, classLabels):
    """
    函数 5.4：梯度上升算法求最佳权值
    说明：计算该样本的梯度，使用alpha * gradient更新回归系数值
         直线方程 a+bx+cy=0
         直线方程：y = (-weights[0] - weights[1] * x) / weights[2]
    :param dataMatIn: 数据集
    :param classLabels: 标签
    :return: 最佳权值
    """
    dataMatrix = np.mat(dataMatIn)  # 将列表数据转换成矩阵
    labelMat = np.mat(classLabels).transpose()  # 标签转置，转换成列向量
    m, n = np.shape(dataMatrix)
    alpha = 0.001  # 向目标移动的步长，也就是学习速率，控制更新的幅度
    maxCycles = 500  # 迭代次数
    weights = np.ones((n, 1))  # 初始权值都为1

    # 梯度下降法计算公式有严格推导过程*****
    for k in range(maxCycles):
        h = sigmoid(dataMatrix * weights)   # 一个列向量
        error = (labelMat - h)  # 向量
        weights = weights + alpha * dataMatrix.transpose() * error  # 梯度下降法计算公式
    return weights
```

```python
dataMatIn, classLabels=loadDataSet()
weights = gradAscent(dataMatIn, classLabels)
print (u"最佳权值为：\n",weights)
```

## 函数 5.5：随机梯度上升算法求最佳权值

```python
def stocGradAscent0(dataMatrix, classLabels):
    """
    函数 5.5：随机梯度上升算法求最佳权值
    说明：对函数5.4的改进，一次仅用一个样本点来更新回归系数，不需要遍历整个数据集
    :param dataMatrix: 数据集
    :param classLabels: 标签
    :return: 权值
    """
    m, n = np.shape(dataMatrix)
    alpha = 0.01
    weights = np.ones(n)  # 初始权值
    
    for i in range(m):
        h = sigmoid(sum(dataMatrix[i] * weights))  # 数值
        error = classLabels[i] - h  # 数值
        weights = weights + alpha * dataMatrix[i] * error
    return weights
```

```python
dataMatIn, classLabels=loadDataSet()
weights = stocGradAscent0(np.array(dataMatIn), classLabels)
print (u"最佳权值为：\n", weights)
```

## 函数 5.6：改进的随机梯度上升算法

```python
def stocGradAscent1(dataMatrix, classLabels, numIter=150):
    """
    函数 5.6：改进的随机梯度上升算法
    说明：
    :param dataMatrix: 矩阵
    :param classLabels: 标签
    :param numIter: 迭代次数
    :return: 权值
    """
    m, n = np.shape(dataMatrix)
    weights = np.ones(n)  # 初始化权值
    
    for j in range(numIter):  # 迭代次数
        dataIndex = list(range(m))  # 0、1、2...m
        for i in range(m):
            alpha = 4 / (1.0 + j + i) + 0.0001  # 改进1：alpha 每次迭代都发生变化，可以缓解回归系数的波动性
            randIndex = int(np.random.uniform(0, len(dataIndex)))  # 随机索引
            h = sigmoid(sum(dataMatrix[randIndex] * weights))   # 改进2：随机选取样本来更新回归系数
            error = classLabels[randIndex] - h
            weights = weights + alpha * error * dataMatrix[randIndex]
            del (dataIndex[randIndex])  # 删除计算过的样本
    return weights
```

```python
dataMatIn, classLabels=loadDataSet()
weights = stocGradAscent1(np.array(dataMatIn), classLabels)
print (u"最佳权值为：\n", weights)
```

# 函数 5.7：预测马的死亡率

```python
def colicTest():
    """
    函数 5.7：预测马的死亡率
    说明：
    :return:
    """
    frTrain = open('datasets/horseColicTraining.txt')
    frTest = open('datasets/horseColicTest.txt')
    trainingSet = []
    trainingLabels = []
    for line in frTrain.readlines():
        currLine = line.strip().split('\t')
        lineArr = []
        for i in range(21):  # 20+1，最后一列为标签
            lineArr.append(float(currLine[i]))
        trainingSet.append(lineArr)  # 样本
        trainingLabels.append(float(currLine[21]))  # 标签

    # 调用stocGradAscent1返回权值
    trainWeights = stocGradAscent1(np.array(trainingSet), trainingLabels, 1000)

    errorCount = 0  # 错误分类个数
    numTestVec = 0.0  # 测试样本数
    for line in frTest.readlines():
        numTestVec += 1.0
        currLine = line.strip().split('\t')
        lineArr = []
        for i in range(21):
            lineArr.append(float(currLine[i]))
        # 计算错误分类个数
        if int(classifyVector(np.array(lineArr), trainWeights)) != int(currLine[21]):
            errorCount += 1
    errorRate = (float(errorCount) / numTestVec)
    print("the error rate of this test is: %f" % errorRate)
    return errorRate
```

```python
colicTest()
```

## 函数 5.8：重复多次求平均值

```python
def multiTest():
    """
    函数 5.8：重复多次求平均值
    :return:
    """
    numTests = 20
    errorSum = 0.0
    for k in range(numTests):
        errorSum += colicTest()
    print("after %d iterations the average error rate is: %f" % (numTests, errorSum / float(numTests)))
```

```python
multiTest()
print (u"最佳权值为：\n", weights)
```

# 函数 5.9：画出数据集和Logistic回归最佳拟合直线的函数

```python
def plotBestFit(weights, dataMatIn, classLabels):
    """
    函数 5.9：画出数据集和Logistic回归最佳拟合直线的函数
    :param weights: 权重
    :param dataMatIn: 输入数据集
    :param classLabels: 标签
    :return:
    """
    import matplotlib.pyplot as plt
    %matplotlib inline
    
    weights = weights.getA()  # 将矩阵转换为数组
    dataArr = np.array(dataMatIn)
    n = np.shape(dataArr)[0]  # 行数

    # 训练集根据标签分组
    xcord1 = [];    ycord1 = []     # 类别 1
    xcord2 = [];    ycord2 = []     # 类别 0

    for i in range(n):
        if int(classLabels[i]) == 1:
            xcord1.append(dataArr[i, 1])
            ycord1.append(dataArr[i, 2])
        else:
            xcord2.append(dataArr[i, 1])
            ycord2.append(dataArr[i, 2])
    fig = plt.figure()
    ax = fig.add_subplot(111)
    # 画出样本点
    ax.scatter(xcord1, ycord1, s=30, c='red', marker='s')
    ax.scatter(xcord2, ycord2, s=30, c='green')
    # 画出直线
    x = np.arange(-3.0, 3.0, 0.1)
    y = (-weights[0] - weights[1] * x) / weights[2]  # 直线方程 a+bx+cy=0
    ax.plot(x, y)
    plt.xlabel('X1')
    plt.ylabel('X2')
    plt.show()
```

```python
dataMatIn, classLabels=loadDataSet()
weights=gradAscent(dataMatIn, classLabels)
plotBestFit(weights,dataMatIn,classLabels)
```

```python

```
