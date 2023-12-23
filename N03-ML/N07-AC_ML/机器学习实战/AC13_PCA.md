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
from numpy import *
import os

os.chdir('D:\pydata\Machine Learning in Action\PCA')


def loadDataSet(fileName, delim='\t'):
    """
    函数 13.1：加载数据
    :param fileName:
    :param delim:
    :return:
    """
    fr = open(fileName)
    stringArr = [line.strip().split(delim) for line in fr.readlines()]
    datArr = [list(map(float, line)) for line in stringArr]
    datMat = mat(datArr)
    return datMat


"""
测试：
datMat = loadDataSet('testSet.txt', delim='\t')
"""


def pca(dataMat, topNfeat=9999999):
    """
    函数 13.2：pca降维
    :param dataMat: 矩阵型原始数据
    :param topNfeat:保留的特征个数
    :return: lowDDataMat 降维之后的数据集, reconMat 重构原始数据集
    """
    meanVals = mean(dataMat, axis=0)  # 均值
    meanRemoved = dataMat - meanVals  # 减去平均值
    covMat = cov(meanRemoved, rowvar=0)  # 计算协方差矩阵
    eigVals, eigVects = linalg.eig(mat(covMat))  # 计算特征值、特征向量

    # 从小到大对特征值排序，得到topNfeat个最大的特征向量
    eigValInd = argsort(eigVals)  # 从小到大排序，并得到对应的位置索引
    eigValInd = eigValInd[:-(topNfeat + 1):-1]  # 保留topNfeat个特征值
    redEigVects = eigVects[:, eigValInd]  # 根据特征值得到topNfeat个最大的特征向量

    # 将数据转换到新的空间
    lowDDataMat = meanRemoved * redEigVects

    # 重构原始数据集,得到将为后的数据
    reconMat = (lowDDataMat * redEigVects.T) + meanVals
    return lowDDataMat, reconMat


"""
测试：
dataMat = loadDataSet('testSet.txt', delim='\t')
lowDMat, reconMat = pca(dataMat, 1)
"""


def scatter(dataMata, reconMat):
    """
    函数 13.2：将降维后的数据和原始数据一起绘制出来
    :param dataMata:
    :param reconMat:
    :return:
    """

    import matplotlib
    import matplotlib.pyplot as plt
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.scatter(dataMata[:, 0].flatten().A[0], dataMata[:, 1].flatten().A[0], marker='^', s=90)
    ax.scatter(reconMat[:, 0].flatten().A[0], reconMat[:, 1].flatten().A[0], marker='o', s=50, c='red')
    plt.show()


"""
测试：
dataMat = loadDataSet('testSet.txt', delim='\t')
lowDMat, reconMat = pca(dataMat, 1)
scatter(dataMat,reconMat)
"""


# *******************************************************************
def replaceNanWithMean():
    """
    函数：将NaN替换成平均值
    """
    datMat = loadDataSet('secom.data', ' ')  # 半导体数据
    numFeat = shape(datMat)[1]
    for i in range(numFeat):
        meanVal = mean(datMat[nonzero(~isnan(datMat[:, i].A))[0], i])  # 某特征 非缺失值的均值
        datMat[nonzero(isnan(datMat[:, i].A))[0], i] = meanVal  # # 缺失值用上述均值替代
    return datMat


"""
测试：
datMat = replaceNanWithMean()
"""


# 实验
def secomTest():
    datMat = replaceNanWithMean()
    meanVals = mean(datMat, axis=0)  # 每个样本的平均值 一行
    meanRemoved = datMat - meanVals  # 减去平均值
    covMat = cov(meanRemoved, rowvar=0)  # 计算协方差矩阵
    eigVals, eigVects = linalg.eig(mat(covMat))  # 计算协方差矩阵的特征值 和特征向量
    print("特征值：", eigVals)

    lowDMat1, reconMat1 = pca(datMat, 1)  # 降维成1维矩阵  前一个主成份
    lowDMat2, reconMat2 = pca(datMat, 2)  # 降维成2维矩阵  前两个主成份
    lowDMat3, reconMat3 = pca(datMat, 3)  # 降维成3维矩阵  前三个主成份
    lowDMat6, reconMat6 = pca(datMat, 6)  # 降维成6维矩阵  前六个主成份
    print("原数据维度: ", shape(datMat))
    print("降维后数据维度1: ", shape(lowDMat1))
    print("降维后数据维度2: ", shape(lowDMat2))
    print("降维后数据维度3: ", shape(lowDMat3))
    print("降维后数据维度6: ", shape(lowDMat6))


"""
测试：
secomTest()
"""

```
