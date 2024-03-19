# KNN

```python
# -*- coding: utf-8 -*-

import numpy as np
import operator
```

## KNN算法的优缺点

**优点**:  

- 精度高  
- 对异常值不敏感  
- 没有对数据的分布假设  

**缺点**:  

- 计算复杂度高  
- 在高维情况下，会遇到『维数诅咒』的问题


```text
    k-近邻算法:给定一个训练数据集，对新的输入实例，
    在训练数据集中找到与该实例最邻近的K个实例（也就是上面所说的K个邻居），
    这K个实例的多数属于某个类，就把该输入实例分类到这个类中。

    ---> K的选择
    K近邻算法对K的选择非常敏感。K值越小意味着模型复杂度越高，从而容易产生过拟合；
    K值越大则意味着整体的模型变得简单，学习的近似近似误差会增大。
    在实际的应用中，一般采用一个比较小的K值。并采用交叉验证的方法，选取一个最优的K值。

    --->距离度量
    距离度量一般采用欧式距离。也可以根据需要采用LpLp距离或明氏距离。

    --->分类决策规则
    K近邻算法中的分类决策多采用多数表决的方法进行。它等价于寻求经验风险最小化。
    但这个规则存在一个潜在的问题：有可能多个类别的投票数同为最高。这个时候，
    究竟应该判为哪一个类别？可以通过以下几个途径解决该问题：
        1.从投票数相同的最高类别中随机地选择一个；
        2.通过距离来进一步给票数加权；
        3.减少K的个数，直到找到一个唯一的最高票数标签。

    ---> 函数列表
    函数 2.1： k-近邻算法
    函数 2.2：将文本记录转换为 Numpy的解析程序
    函数 2.3：归一化特征值
    函数 2.4：分类器针对约会网站的测试代码,调用函数1、2、3
    函数 2.5：约会网站预测函数,调用函数1、2、3
```


## 函数 2.1： k-近邻算法

```python
def classify(inX, dataSet, labels, k):
    """
    函数 2.1： k-近邻算法
    :param inX: 待分类的输入向量
    :param dataSet: 输入的训练样本集
    :param labels: 标签向量
    :param k: 取最近的 k个样本
    :return: 预测结果
    """
    dataSetSize = dataSet.shape[0]  # dataSetSize数据集行数,shape[1] 为列数

    # 求欧氏距离
    diffMat = np.tile(inX, (dataSetSize, 1)) - dataSet  # 相减，tile 生成相同的行数，相当于复制
    sqDiffMat = diffMat ** 2  # 平方
    sqDistances = sqDiffMat.sum(axis=1)  # sum(axis=1)是将每一行向量相加
    distances = sqDistances ** 0.5  # 开方

    # 计数
    sortedDistIndicies = distances.argsort()  # argsort，返回从小到大值位置索引
    classCount = {}  # 字典，用到get、items行数
    
    for i in range(k):
        voteIlabel = labels[sortedDistIndicies[i]]  # 样本对应类别，sortedDistIndicies[i]为距离最近的K个样本位置
        # 距离最近的k个类别计数，存在就+1，没有就从1开始
        classCount[voteIlabel] = classCount.get(voteIlabel, 0) + 1  # get() 函数返回指定键的值，如果值不在字典中返回默认值

    # 按第二个元素的次序对元祖进行排序，逆序，从大到小
    # items 将字典分解为元祖列表
    # operator.itemgetter(1) 定义的是一个函数，获取第二个元素，即类别对应的个数
    sortedClassCount = sorted(classCount.items(), key=operator.itemgetter(1), reverse=True)
    return sortedClassCount[0][0]
```

```python
#测试: k-近邻算法
inX = [0,0]
dataSet = np.array([[1.0,1.1],[1.0,1.0],[0,0],[0,0.1]])
labels = ['A','A','B','B']
k = 3
Class=classify(inX, dataSet, labels, k)
print (u"样本[0,0]的类别为：",Class)
```

## 函数 2.2：将文本记录转换为 Numpy的解析程序

```python
def file2matrix(filename):
    """
    函数 2.2：将文本记录转换为 Numpy的解析程序
    说明：本程序中filename，为1000*4，最后一列为类别
    :param filename: 文本
    :return: returnMat 数据矩阵, classLabelVector 标签
    """
    fr = open(filename)
    arrayOlines = fr.readlines()  # 读取全部行
    numberOfLines = len(arrayOlines)  # 行数
    returnMat = np.zeros((numberOfLines, 3))  # 准备数据返回矩阵，3列
    classLabelVector = []  # 准备标签返回列表

    index = 0
    for line in arrayOlines:
        line = line.strip()  # 截取掉回车字符
        listFromLine = line.split('\t')  # 将整行数据分割成一个元素列表
        returnMat[index, :] = listFromLine[0:3]  # 取前三个元素
        classLabelVector.append(int(listFromLine[-1]))  # 取最后一列元素
        index += 1
    return returnMat, classLabelVector
```

```python
#测试:
filename =  'datasets/datingTestSet.txt'
datingDataMat, datingLabels = file2matrix(filename)

print (u"返回矩阵为：\n",datingDataMat)
print("*"*100)
print (u"返回标签为：\n",datingLabels)
```

## 函数 2.3：数据归一化

```python
def autoNorm(dataSet):
    """
    函数 2.3：数据归一化
    说明：将数据归一化处理, 每列的数据减去该列的最小值，再除以该列的极差
    :param dataSet: 数据集
    :return: normDataSet 归一化后数据集, ranges 极差, minVals 最小值
    """

    minVals = dataSet.min(axis=0)  # 列的最小值
    maxVals = dataSet.max(axis=0)  # 列的最大值
    ranges = maxVals - minVals

    normDataSet = np.zeros(np.shape(dataSet))  # 准备矩阵
    m = dataSet.shape[0]  # 行数
    normDataSet = dataSet - np.tile(minVals, (m, 1))   # 行方向m次，列方向1次
    normDataSet = normDataSet / np.tile(ranges, (m, 1))
    return normDataSet, ranges, minVals
```

```python
# 测试:
dataSet, datingLabels = file2matrix('datasets/datingTestSet.txt')
print(u"原始数据为：\n",dataSet)
print("*"*100)
normDataSet, ranges, minVals = autoNorm(dataSet)
print(u"归一化后数据为：\n",normDataSet)
```

## 函数 2.4：分类器针对约会网站的测试代码

```python
def datingClassTest():
    """
    函数 2.4：分类器针对约会网站的测试代码
    说明：调用函数1、2、3
    :return:
    """

    hoRatio = 0.10  # 数据用于测试的比例

    # 调用函数 2 file2matrix 读取数据
    datingDataMat, datingLabels = file2matrix( 'datasets/datingTestSet.txt')

    # 调用函数3 autoNorm 归一化
    normMat, ranges, minVals = autoNorm(datingDataMat)

    m = normMat.shape[0]
    numTestVecs = int(m * hoRatio)  # 用于测试数据的行数
    errorCount = 0.0  # 错误计数

    # 前numTestVecs用于测试，后面的用于训练
    for i in range(numTestVecs):
        # 调用函数 1 classify
        # 测试数据 normMat[i, :]
        # 训练数据 normMat[numTestVecs:m, :]
        # 训练数据标签 datingLabels[numTestVecs:m]
        # k=3
        classifierResult = classify(normMat[i, :], normMat[numTestVecs:m, :], datingLabels[numTestVecs:m], 3) 
        print(u"kNN分类器返回结果: %d, 真实结果: %d" % (classifierResult, datingLabels[i]))

        if (classifierResult != datingLabels[i]):
            errorCount += 1.0
    print(u"错误个数: %d" % errorCount)
    print(u"错误率: %.2f" % (errorCount / float(numTestVecs)))
```

```python
# 测试:
print(u"分类器针对约会网站的测试代码:")
datingClassTest()
```

## 函数 2.5：约会网站预测函数

```python
def classifyPerson():
    """
    函数 2.5：约会网站预测函数
    调用函数1、2、3
    "每年获得的飞行常客里程数"、"每周消耗的冰激凌公升数"、"玩视频游戏所耗时间百分比"、"标签"
    datingLabels ：为 0,1,2
    """
    resultList = ['0-not at all', '1-in small doses', '2-in large doses']

    ffMiles = float(input(u"每年获得的飞行常客里程数："))
    iceCream = float(input(u"每周消耗的冰激凌公升数："))
    percentTats = float(input(u"玩视频游戏所耗时间百分比："))

    datingDataMat, datingLabels = file2matrix('datasets/datingTestSet.txt')
    normMat, ranges, minVals = autoNorm(datingDataMat)
    inArr = np.array([ffMiles, iceCream, percentTats])
    classifierResult = classify((inArr - minVals) / ranges, normMat, datingLabels, 3)

    print(u"\n\n你对此人的喜欢程度预测值: ", resultList[classifierResult])

```

```python
# 测试:
classifyPerson()
```

## 补充：使用鸢尾花数据集进行测试

```python
from sklearn import datasets

# 数据集准备
iris = datasets.load_iris()
datingDataMat, datingLabels = iris.data, iris.target
```

```python
def datingClassTest():
    np.random.seed(9)
    randomIndex = np.random.randint(0, 150, 30)  # 产生0到150之间的30个随机整数

    # 调用自定义函数 autoNorm 归一化
    normMat, ranges, minVals = autoNorm(datingDataMat)

    errorCount = 0  # 错误计数
    for i in randomIndex:
        classifierResult = classify(normMat[i, :], normMat, datingLabels, 3)
        print(u"kNN分类器返回结果: %d, 真实结果: %d" % (classifierResult, datingLabels[i]))

        if (classifierResult != datingLabels[i]):
            errorCount += 1
    print(u"错误个数: %d" % errorCount)
    print(u"准确率: %.4f" % (1 - errorCount / float(150)))
```

```python
# 测试：
print (u"分类器针对iris的测试:")
datingClassTest()
```

## 补充：手写数字识别部分

```python
import os
```

```python
# 手写数字测试数据，文件名如 5_12.txt，数字5的第12个样本，每个样本为 32*32
# ----------------样本32*32 转化为1*1024----------------------------
def img2vector(filename):
    """
    :param filename:
    :return:
    """
    returnVect = np.zeros((1, 1024))
    fr = open(filename)
    for i in range(32):
        lineStr = fr.readline()  # readline 每次只读取一行
        for j in range(32):
            returnVect[0, 32 * i + j] = int(lineStr[j])
    return returnVect
```

```python
# img2vector函数的另一种写法
def img2vector2(filename):
    returnVect = np.zeros((1, 1024))
    fr = open(filename)
    lineStr = fr.readlines()  # readlines 读取全部行
    for i in range(32):
        for j in range(32):
            returnVect[0, 32 * i + j] = int(lineStr[i][j])
    return returnVect
```

```python
# 测试：
trainingFileList = os.listdir('datasets/trainingDigits')  # 文件名读成列表
fileNameStr = trainingFileList[0]  # 读取一行测试，即一个文件名
a = open('datasets/trainingDigits/%s' % fileNameStr).read()
b = img2vector('datasets/trainingDigits/%s' % fileNameStr)  # 训练样本
print(u"样本转换前为：\n",a)
```

```python
print(u"\n样本转换前的长度为：",len(a))
```

```python
print(u"样本转换后为：\n",b)
```

```python
print(u"\n样本转换后的shape为：",np.shape(b))
```

## 手写数字识别系统的测试代码

```python
# ------------手写数字识别系统的测试代码------------------------------
def handwritingClassTest():
    hwLabels = []  # 标签
    trainingFileList = os.listdir('datasets/trainingDigits')  # 文件名读成列表
    m = len(trainingFileList)
    trainingMat = np.zeros((m, 1024))  # 准备矩阵，用于存放训练数据

    # 将文件名 如 3_12.txt，转化为标签 3，并读取数据为行 1024
    for i in range(m):
        fileNameStr = trainingFileList[i]  # 文件名列表
        fileStr = fileNameStr.split('.')[0]  # 3_12.txt，去掉 ".txt"
        classNumStr = int(fileStr.split('_')[0])  # 真实类别 3,去掉 “_12”
        hwLabels.append(classNumStr)  # 标签
        trainingMat[i, :] = img2vector('datasets/trainingDigits/%s' % fileNameStr)  # 训练样本

    testFileList = os.listdir('datasets/testDigits')
    errorCount = 0.0
    mTest = len(testFileList)
    for i in range(mTest):
        fileNameStr = testFileList[i]
        fileStr = fileNameStr.split('.')[0]
        classNumStr = int(fileStr.split('_')[0])  # 真实类别
        vectorUnderTest = img2vector('datasets/testDigits/%s' % fileNameStr)  # 待测试样本
        classifierResult = classify(vectorUnderTest, trainingMat, hwLabels, 3)  # 分类结果

        print(u"分类器返回结果: %d, 真实类别: %d" % (classifierResult, classNumStr))
        if (classifierResult != classNumStr):
            errorCount += 1.0
    return errorCount,mTest
```

```python
# 测试：
errorCount,mTest = handwritingClassTest()
```

```python
print(u"\n分类错误总数: %d" % errorCount)
print(u"\n分类错误率为: %.4f" % (errorCount / float(mTest)))
```

```python

```
