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
函数 2：计算两向量的欧氏距离
函数 3：给数据集构建一个包含k个随机质心
函数 4：k均值算法
函数 5：二分 K-均值算法

常用函数：map
"""

from numpy import *
import os
os.chdir('F:\pydata\Machine Learning in Action\kMeans')

def loadDataSet(fileName):
    """
    函数 10.1：加载数据
    说明：将文本文件导入到矩阵中，文本文件为tab分隔的浮点数
    :param fileName: 文件名
    :return: 数据矩阵
    """
    dataMat = []
    fr = open(fileName)
    for line in fr.readlines():
        curLine = line.strip().split('\t')
        fltLine = list(map(float, curLine))  # 将每个元素转化成float
        dataMat.append(fltLine)
    dataMat = mat(dataMat)  # 转化为矩阵
    return dataMat
```

```python
dataSet = loadDataSet('testSet.txt')
print ("数据集为:",dataSet[:5])
print (u"\n数据集shape为:",dataSet.shape)
```

```python
def distEclud(vecA, vecB):
    """
    函数 10.2：计算两向量的欧氏距离
    :param vecA: 向量A
    :param vecB: 向量B
    :return: 欧式距离
    """
    return sqrt(sum(power(vecA - vecB, 2)))
```

```python
a = distEclud(mat([0,2]), mat([3,5]))
print (u"两点的欧氏距离为:",a)
```

```python
# 函数 3：
def randCent(dataSet, k):
    """
    函数 10.3：生成随机质心
    说明：给数据集构建一个包含k个随机质心的集合，确保大小不超出范围
    :param dataSet: 数据集
    :param k: 质心个数
    :return: 随机质心
    """
    n = shape(dataSet)[1]  # 列数
    centroids = mat(zeros((k, n)))  # k 个质心
    for j in range(n):
        minJ = min(dataSet[:, j])  # 每列的最小值
        maxJ = max(dataSet[:, j])
        rangeJ = float(maxJ - minJ)  # 每列最大值减去最小值
        centroids[:, j] = mat(minJ + rangeJ * random.rand(k, 1))  # 产生每列范围内的随机值
    return centroids
```

```python
dataSet = loadDataSet('F:/pydata/Machine Learning in Action/kMeans/testSet.txt')
centroids = randCent(dataSet, 3)
print(u"随机质心为:\n", centroids)
```

```python
# 函数 4：k 均值算法
"""
dataSet数据集，k质心个数

创建k个点作为起始质心（经常是随机选择）
当任意一个点的簇分配结果发生改变时
    对数据集中的每个数据点
        对每个质心
            计算质心与数据点之间的距离
        将数据点分配到距其最近的簇
    对每一个簇，计算簇中所有点的均值并将均值作为质心
"""


def kMeans(dataSet, k):
    m = shape(dataSet)[0]  # 数据集行数
    clusterAssment = mat(zeros((m, 2)))  # 准备簇分配结果矩阵，第一列存簇索引值，第二列存样本跟质心的距离
    centroids = randCent(dataSet, k)  # 调用自定义函数，创建质心
    clusterChanged = True  # 聚类结束标志
    while clusterChanged:
        clusterChanged = False

        # 对数据集中的每个数据点
        for i in range(m):  # 寻找每个样本的最近质心
            # 设置两个变量，分别存放数据点到质心的距离，及数据点属于哪个质心
            minDist = inf;
            minDistIndex = -1  # minDistIndex为 0-k

            # 对每个质心
            for j in range(k):
                distJI = distEclud(centroids[j, :], dataSet[i, :])  # 计算质心与数据点之间的距离
                if distJI < minDist:
                    minDist = distJI;
                    minDistIndex = j  # 寻找最小距离，并记录质心索引值

            # 将数据点分配到距其最近的簇
            if clusterAssment[i, 0] != minDistIndex:  # 簇分配结果发生变化，更新标志
                clusterChanged = True
            clusterAssment[i, :] = minDistIndex, minDist ** 2

        # 对每一个簇，计算簇中所有点的均值并将均值作为质心
        for cent in range(k):  # 重新计算质心，nonzero返回索引
            ptsInClust = dataSet[nonzero(clusterAssment[:, 0].A == cent)[0]]  # 取第一列等于cent的所有数据
            centroids[cent, :] = mean(ptsInClust, axis=0)  # 列方向求平均值
    return centroids, clusterAssment  # 返回质心，簇分配结果矩阵（簇索引值，存储误差）
```

```python
dataSet = loadDataSet('F:/pydata/Machine Learning in Action/kMeans/testSet.txt')
centroids, clusterAssment = kMeans(dataSet, 3)
print("质心为:\n", centroids)
print("\n误差矩阵为:\n", clusterAssment[:5])
```

```python
# 函数 5：二分 K-均值算法--------------------------------------------------------------------
"""
将所有样本点看成一个簇
当簇数目小于k时
    对于每一个簇
        计算总误差
        在给定的簇上面进行K-均值聚类（k=2）
        计算将该簇一分为二之后的总误差
    选择使得误差最小的那个簇进行划分操作
"""


def biKmeans(dataSet, k):
    m = shape(dataSet)[0]  # m=80
    clusterAssment = mat(zeros((m, 2)))  # 用于存储数据集中每个样本的簇分配结果和平方误差

    centroid = mean(dataSet, axis=0).tolist()[0]
    centList = [centroid]  # 创建初始簇，即质心，1个

    # 遍历每个样本，保存样本到每个簇质心的平方距离
    for j in range(m):
        clusterAssment[j, 1] = distEclud(mat(centroid), dataSet[j, :]) ** 2

    # 当簇数目小于k时
    while (len(centList) < k):
        print(u"\n当前簇数：", len(centList))
        lowestSSE = inf  # 初始误差平方和，无穷大
        # 对于每一个簇
        for i in range(len(centList)):
            # 在给定的簇上面进行K-均值聚类（k=2）
            # shape(centroidMat)=(2L,2L) shape(splitClustAss)=(80L,2L)
            ptsInCurrCluster = dataSet[nonzero(clusterAssment[:, 0].A == i)[0], :]  # 划分到该质心的所有数据
            centroidMat, splitClustAss = kMeans(ptsInCurrCluster, 2)  # 返回新的质心，误差矩阵

            # 计算将该簇一分为二之后的总误差
            sseSplit = sum(splitClustAss[:, 1])  # 计算SSE的大小，即新的簇所有误差相加
            sseNotSplit = sum(clusterAssment[nonzero(clusterAssment[:, 0].A != i)[0], 1])  #

            # 如果该划分的SSE值最小，则保存本次划分
            if (sseSplit + sseNotSplit) < lowestSSE:
                bestCentToSplit = i  # 新的簇索引
                bestNewCents = centroidMat  # 新的簇
                bestClustAss = splitClustAss.copy()  # 新的误差矩阵
                lowestSSE = sseSplit + sseNotSplit  # 新的总误差

        # 选择使得误差最小的那个簇进行划分操作，修改子误差矩阵中的簇编号
        # 将 kMeans 产生编号为0、1的结果簇编号修改为划分簇及新加簇的编号
        # 一个是 i 本身不变，另一个等于len(centList)
        # 顺序只能先把 1 换成len(centList) ，再把 0换成 bestCentToSplit
        bestClustAss[nonzero(bestClustAss[:, 0].A == 1)[0], 0] = len(centList)
        bestClustAss[nonzero(bestClustAss[:, 0].A == 0)[0], 0] = bestCentToSplit
        print(u"\n被划分索引：", bestCentToSplit)
        print(u"\n新增加索引：", len(centList))
        print(u"\n子误差矩阵：\n", bestClustAss)
        print(u"\n前误差矩阵：\n", clusterAssment)

        # 更新新的簇分配结果，质心添加到centList中，bestCentToSplit进行修改
        centList[bestCentToSplit] = bestNewCents[0, :].tolist()[0]
        centList.append(bestNewCents[1, :].tolist()[0])

        # 新划分的结果更新到clusterAssment中，簇索引为bestCentToSplit的替换成新的子误差矩阵
        clusterAssment[nonzero(clusterAssment[:, 0].A == bestCentToSplit)[0], :] = bestClustAss
        print(u"\n后误差矩阵：\n", clusterAssment)
    return mat(centList), clusterAssment  # 返回质心，分配结果
```

```python
dataSet=loadDataSet('F:/pydata/Machine Learning in Action/kMeans/testSet.txt')
centroids, clusterAssment = biKmeans(dataSet, 4)
```

```python

```
