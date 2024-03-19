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
import math
import operator
import matplotlib.pyplot as plt

%matplotlib inline
```

    函数 3.1：创建数据集
    函数 3.2：计算数据集的熵
    函数 3.3：按照给定特征划分数据集
    函数 3.4：计算出最佳的划分属性，调用 2、3
    函数 3.5 ：返回出现次数最多的分类类别
    函数 3.6：创建树，如：{'no surfacing': {0: 'no', 1: {'flippers': {0: 'no', 1: 'yes'}}}}
    函数 3.7：使用决策树的分类测试
    函数 3.8：使用pickle存储决策树
    函数 3.9：读取决策树

```python

```

```python
ID = 'ID3'  # ID等于'ID3'时，使用ID3算法，否则使用C4.5
```

## 函数 3.1：创建数据集

```python
def createDataSet():
    """
    函数 3.1：创建数据集
    第一列：'no surfacing'，浮出水面是否可以生存
    第二列：'flippers'，是否有脚蹼
    第三列：是否属于鱼类
    """
    dataSet = [[1, 1, 'yes'],
               [1, 1, 'yes'],
               [1, 0, 'no'],
               [0, 1, 'no'],
               [0, 1, 'no']]
    labels = ['no surfacing', 'flippers']
    return dataSet, labels
```

```python
dataSet, labels = createDataSet()
print(dataSet)
print(labels)
```

## 函数 3.2：计算数据集的熵

```python
def calcShannonEnt(dataSet):
    """
    函数 3.2：计算数据集的熵，
    参加周志华《机器学习》P75页，熵的计算公式 4.1
    根节点的熵，即标签，包含所有样本
    :param dataSet: 数据集
    :return: shannonEnt-熵
    """
    numEntries = len(dataSet)  # 数据集长度
    labelCounts = {}  # 为所有可能分类创造字典

    # 遍历每条数据集样本，如果字典里没有数据集中的类别，将此类别存入字典中，如果有，将此类别数目加1
    # 以下for循环里计算结果为labelCounts=['yes':2,'no':3]
    for featVec in dataSet:
        currentLabel = featVec[-1]  # 标签
        if currentLabel not in labelCounts.keys():
            labelCounts[currentLabel] = 0
        labelCounts[currentLabel] += 1
        # 写法二：
        # labelCounts[currentLabel] = labelCounts.get(currentLabel, 0) + 1
    # 计算熵
    shannonEnt = 0.0
    for key in labelCounts:  # 遍历上面生成的字典中的每一个特征类别，计算其中每个类别的熵值
        prob = float(labelCounts[key]) / numEntries  # 每个类别占比
        shannonEnt -= prob * math.log(prob, 2)  # -sum相加
    return shannonEnt
```

```python
# 测试信息熵计算函数
dataSet, labels = createDataSet()
shannonEnt = calcShannonEnt(dataSet)
print (u"该数据集的信息熵为：",shannonEnt)
```

## 函数 3.3：按照给定特征划分数据集

```python
def splitDataSet(dataSet, axis, value):
    """
    函数 3.3：按照给定特征划分数据集
    对数据集的某个属性的那个值划分，实际上是取出该值所在数据子集，但不包含该属性
    :param dataSet: 待划分的数据集
    :param axis: 划分特征所在列位置
    :param value: 该特征的值
    :return:
    """
    retDataSet = []  # 创建新列表对象，保证同一个数据集多次调用后，原始数据不被修改
    for featVec in dataSet:
        if featVec[axis] == value:
            reducedFeatVec = featVec[:axis]  # 取特征所在列的左侧数据
            reducedFeatVec.extend(featVec[axis + 1:])  # 取特征所在列的右侧数据
            retDataSet.append(reducedFeatVec)
    return retDataSet
```

```python
# 测试：
dataSet, labels = createDataSet()
print (u"数据集为：",dataSet)
retDataSet01 = splitDataSet(dataSet, 0, 1)
print (u"数据集第1个属性，值为 1 的划分结果为：",retDataSet01)

retDataSet00 = splitDataSet(dataSet, 0, 0)
print (u"数据集第1个属性，值为 0 的划分结果为",retDataSet00)
```

## 函数 3.4 计算出最佳的划分属性

```python
def chooseBestFeatureToSplit(dataSet, ID='ID3'):
    """
    函数 3.4 计算出最佳的划分属性
    调用函数 3.2：计算数据集的熵
    调用函数 3.3：按照给定特征划分数据集
    选择最好的数据集划分方式，即信息增益最大，返回最佳划分索引
    C4.5：先从候选划分中找出信息增益高于平均水平的属性，再从其中选择增益率最高的，本代码不严格
    :param dataSet:数据集
    :param ID: 算法选择，默认使用ID3算法，否则使用C4.5
    :return: 返回最佳划分索引
    """
    numFeatures = len(dataSet[0]) - 1  # 特征数，即列数减一
    baseEntropy = calcShannonEnt(dataSet)  # 调用函数02：计算总数据集的信息熵，即根节点信息熵
    bestInfoGain = 0.0  # 最大信息增益初始值
    bestFeature = -1  # 最佳划分特征索引
    for i in range(numFeatures):  # 遍历每一个特征
        # 创建唯一的分类标签列表
        featList = [example[i] for example in dataSet]  # 遍历每个特征的数据集,即所在列
        uniqueVals = set(featList)  # 第 i个特征取值集合，如果i=1，则uniqueVals={0,1}

        newEntropy = 0.0  # 初始信息熵
        newEntropyRatio = 0.0  # C4.5
        # 依据特征划分数据集，并计算每种划分方式的信息熵
        for value in uniqueVals:
            subDataSet = splitDataSet(dataSet, i, value)  # 调用函数03，划分数据集，子数据集
            # 计算子数据集的信息熵
            prob = len(subDataSet) / float(len(dataSet))  #
            newEntropy += prob * calcShannonEnt(subDataSet)  # 调用函数02：计算划分的信息熵，P77
            newEntropyRatio -= prob * log(prob, 2)  # C4.5 计算信息增益率分母,P78

        if (ID == 'ID3'):
            infoGain = baseEntropy - newEntropy  # 计算该划分信息增益 ID3
            # print (u"使用算法为：ID3")
        else:
            infoGain = (baseEntropy - newEntropy) / newEntropyRatio  # 计算该划分信息增益率
            # print (u"使用算法为：C4.5")

        # 选择最大信息增益或信息增益率的划分结果
        if (infoGain > bestInfoGain):
            bestInfoGain = infoGain  # 取最大信息增益
            bestFeature = i
    return bestFeature
```

```python
# 测试函数04：计算出最佳的划分属性
dataSet, labels = createDataSet()
print (u"数据集为：",dataSet)

ID='ID3'
bestFeature = chooseBestFeatureToSplit(dataSet,ID)
print (u"最佳属性索引为：",bestFeature)
```

## 函数 3.5 ：返回出现次数最多的标签类别

```python
def majorityCnt(classList):
    """
    函数 3.5 ：返回出现次数最多的标签类别
    如果数据集已经处理了所有的属性，但是类标签依然不是唯一的，
    此时通常采用多数表决的方法决定该叶子节点的分类
    :param classList:
    :return:
    """
    classCount = {}  # 计数字典
    for vote in classList:
        if vote not in classCount.keys():
            classCount[vote] = 0
        classCount[vote] += 1
    sortedClassCount = sorted(classCount.items(), key=operator.itemgetter(1), reverse=True)
    return sortedClassCount[0][0]
```

```python
# 测试:
classListMax = majorityCnt(['yes', 'yes','no','yes','no'])
print (u"不唯一的类别：",['yes', 'yes','no','yes','no'])
print (u"次数最多的类别为：",classListMax)
```

## 函数 3.6：创建树

```python
def createTree(dataSet, labels):
    """
    函数 3.6：创建树
    递归函数
    终止条件1：类别完全相同，表示就只有一个类别，则停止继续划分  返回标签-叶子节点
    终止条件2：无法将数据集划分成唯一类别时，采用多数表决法决定叶子的分类，调用函数05：返回出现次数最多的分类类别
    调用函数04：计算出最佳的划分属性（2、3）
    调用函数 03：按照给定特征划分数据集
    :param dataSet: 数据集,list
    :param labels: 数据集中每个特征的标签
    :return:
    """
    classList = [example[-1] for example in dataSet]  # 数据集所有标签列表

    # 终止条件1:类别完全相同，表示就只有一个类别，则停止继续划分  返回标签-叶子节点
    if classList.count(classList[0]) == len(classList):
        return classList[0]

    # 终止条件2：使用完所有属性，无法将数据集划分成唯一类别时，采用多数表决法决定叶子的分类
    if len(dataSet[0]) == 1:
        return majorityCnt(classList)  # 调用函数3.5，遍历完所有的特征时返回出现次数最多的

    # 开始创建树
    bestFeat = chooseBestFeatureToSplit(dataSet, ID)  # 调用函数3.4，得到最佳划分属性位置索引
    bestFeatLabel = labels[bestFeat]
    myTree = {bestFeatLabel: {}}  # 用上面得到的最好划分数据集特征建立一个空树（空字典）

    del (labels[bestFeat])  # 删除使用过的属性,此处修改了labels，对其它地方调用需重新读入
    featValues = [example[bestFeat] for example in dataSet]  # 取出最佳划分属性的属性值
    uniqueVals = set(featValues)  # 对最佳划分属性的属性值进行去重

    for value in uniqueVals:  # 遍历当前选择的特征包含的所有属性值
        subLabels = labels[:]  # 复制类标签
        # 递归调用构建树的过程，直到遍历完所有划分数据集属性，所有相同类别的数据均被分到同一个数据子集中
        subDataSet = splitDataSet(dataSet, bestFeat, value)  # 调用函数 3.3：按照给定特征划分数据集
        myTree[bestFeatLabel][value] = createTree(subDataSet, subLabels)  # *********************
    return myTree  # 如：{'no surfacing': {0: 'no', 1: {'flippers': {0: 'no', 1: 'yes'}}}}
```

```python
# 测试：
dataSet, labels = createDataSet()
print (u"数据集为：",dataSet)

myTree = createTree(dataSet, labels)
print (u"决策树：",myTree)
```

## 函数 3.7：使用决策树的分类测试

```python
def classify(inputTree, featLabels, testVec):
    """
    函数 3.7：使用决策树的分类测试
    递归函数
    寻找特征在数据集中的位置
    只用index方法查找匹配的位置
    决策树样例： {'no surfacing': {0: 'no', 1: {'flippers': {0: 'no', 1: 'yes'}}}}

    :param inputTree: 函数 3.6 createTree产生的决策树
    :param featLabels: 函数 3.1 createDataSet产生的 labels
    :param testVec: 测试样本
    :return:
    """
    # 寻找第一个特征属性：firstStr='no surfacing'
    firstSides = list(inputTree.keys())
    firstStr = firstSides[0]  # 找到输入的第一个元素
    # 除去第一个特征属性的字典：secondDict={0: 'no', 1: {'flippers': {0: 'no', 1: 'yes'}}}
    secondDict = inputTree[firstStr]  # 该特征属性的下层决策树
    featIndex = featLabels.index(firstStr)  # 寻找第一个特征属性在特征属性列表中的位置：featIndex=0

    # 遍历整棵树，比较待测特征与树节点的值，直到找到特征值完全匹配的叶子节点
    for key in secondDict.keys():
        if testVec[featIndex] == key:
            if type(secondDict[key]).__name__ == 'dict':
                classLabel = classify(secondDict[key], featLabels, testVec)
            else:
                classLabel = secondDict[key]
    return classLabel
```

```python
# 测试：
dataSet, labels = createDataSet()
print (u"数据集为：",dataSet)
print (u"数据集特征为：",labels)
inputTree = createTree(dataSet, labels)

dataSet, featLabels = createDataSet()  

testVec = [1,0]
classLabel = classify(inputTree, featLabels, testVec)
print (u"样本[1,0]的类别为",classLabel)
```

## 函数 3.8：使用pickle存储决策树

```python
def storeTree(inputTree, filename):
    """
    函数 3.8：使用pickle存储决策树
    :param inputTree:
    :param filename:
    :return:
    """
    import pickle
    fw = open(filename, 'wb')  # 以写的方式打开文件
    pickle.dump(inputTree, fw)  # 决策树序列化
    fw.close()
```

```python
# 测试：
dataSet, labels = createDataSet()
inputTree = createTree(dataSet, labels)
filename = './datasets/classifierStorage.txt'
storeTree(inputTree, filename)
```

## 函数 3.9 读取决策树

```python
def grabTree(filename):
    """
    函数 3.9 读取决策树
    :param filename: 决策树文件
    :return: 输出的决策树
    """
    import pickle
    fr = open(filename, 'rb')
    outputTree = pickle.load(fr)
    return outputTree
```

```python
# 测试:
filename = './datasets/classifierStorage.txt'
outputTree = grabTree(filename)
```

## 策树的绘制

```python
# 决策树的绘制===============================================================
# 定义文本框和箭头格式
decisionNode = dict(boxstyle="sawtooth", fc="0.8")
leafNode = dict(boxstyle="round4", fc="0.8")
arrow_args = dict(arrowstyle="<-")
```

### 函数 3.10 ：绘制带箭头的注解

```python
# 自定义函数
def plotNode(nodeTxt, centerPt, parentPt, nodeType):
    """
    函数 3.10 ：绘制带箭头的注解
    调用函数 3.16 主函数
    :param nodeTxt:
    :param centerPt:
    :param parentPt:
    :param nodeType:
    :return:
    """
    createPlot.ax1.annotate(nodeTxt, xy=parentPt, xycoords='axes fraction',
                            xytext=centerPt, textcoords='axes fraction',
                            va="center", ha="center", bbox=nodeType, arrowprops=arrow_args)

```

```python
# 绘制带箭头的注解
def createPlot():
    fig = plt.figure(1, facecolor='white')
    fig.clf()
    createPlot.ax1 = plt.subplot(111, frameon=False) #ticks for demo puropses
    plotNode('a decision node', (0.5, 0.1), (0.1, 0.5), decisionNode)
    plotNode('a leaf node', (0.8, 0.1), (0.3, 0.8), leafNode)
    plt.show()
```

### 函数 3.11：获取叶节点的数目

```python
def getNumLeafs(myTree):
    """
    函数 3.11：获取叶节点的数目
    :param myTree:
    :return: 叶节点数量
    """
    numLeafs = 0
    firstSides = list(myTree.keys())
    firstStr = firstSides[0]
    secondDict = myTree[firstStr]
    for key in secondDict.keys():
        if type(secondDict[key]).__name__ == 'dict':  # 测试节点的数据类型是否为字典
            numLeafs += getNumLeafs(secondDict[key])
        else:
            numLeafs += 1
    return numLeafs
```

### 函数 3.12：获取树的层数

```python
# 获取树的层数
def getTreeDepth(myTree):
    """
    函数 3.12：获取树的层数
    :param myTree:
    :return: 树的层数
    """
    maxDepth = 0
    firstSides = list(myTree.keys())
    firstStr = firstSides[0]
    secondDict = myTree[firstStr]
    for key in secondDict.keys():
        if type(secondDict[
                    key]).__name__ == 'dict':  # test to see if the nodes are dictonaires, if not they are leaf nodes
            thisDepth = 1 + getTreeDepth(secondDict[key])
        else:
            thisDepth = 1
        if thisDepth > maxDepth: maxDepth = thisDepth
    return maxDepth
```

### 函数 3.13：准备好树信息

```python
def retrieveTree(i):
    """
    函数 3.13：准备好树信息
    :param i:
    :return:
    """
    listOfTrees = [{'no surfacing': {0: 'no', 1: {'flippers': {0: 'no', 1: 'yes'}}}},
                   {'no surfacing': {0: 'no', 1: {'flippers': {0: {'head': {0: 'no', 1: 'yes'}}, 1: 'no'}}}}
                   ]
    return listOfTrees[i]
```

```python
# myTree=retrieveTree(0)
# getTreeDepth(myTree)
# getNumLeafs(myTree)
```

### 函数 3.14：在父子节点间填充文本信息

```python
def plotMidText(cntrPt, parentPt, txtString):
    """
    函数 3.14：在父子节点间填充文本信息
    :param cntrPt:
    :param parentPt:
    :param txtString:
    :return:
    """
    xMid = (parentPt[0] - cntrPt[0]) / 2.0 + cntrPt[0]
    yMid = (parentPt[1] - cntrPt[1]) / 2.0 + cntrPt[1]
    createPlot.ax1.text(xMid, yMid, txtString, va="center", ha="center", rotation=30)
```

### 函数 3.15：绘制决策树图

```python
def plotTree(myTree, parentPt, nodeTxt):
    """
    函数 3.15：绘制决策树图
    调用函数 3.14 plotMidText：在父子节点间填充文字
    调用函数 3.10 plotNode：
    :param myTree:
    :param parentPt:
    :param nodeTxt:
    :return:
    """
    numLeafs = getNumLeafs(myTree)  # 计算宽度
    depth = getTreeDepth(myTree)  # 计算深度
    firstSides = list(myTree.keys())
    firstStr = firstSides[0]
    cntrPt = (plotTree.xOff + (1.0 + float(numLeafs)) / 2.0 / plotTree.totalW, plotTree.yOff)
    plotMidText(cntrPt, parentPt, nodeTxt)  # 调用
    plotNode(firstStr, cntrPt, parentPt, decisionNode)  # 调用
    secondDict = myTree[firstStr]
    plotTree.yOff = plotTree.yOff - 1.0 / plotTree.totalD
    for key in secondDict.keys():
        if type(secondDict[
                    key]).__name__ == 'dict':  # test to see if the nodes are dictonaires, if not they are leaf nodes
            plotTree(secondDict[key], cntrPt, str(key))  # recursion
        else:  # it's a leaf node print the leaf node
            plotTree.xOff = plotTree.xOff + 1.0 / plotTree.totalW
            plotNode(secondDict[key], (plotTree.xOff, plotTree.yOff), cntrPt, leafNode)
            plotMidText((plotTree.xOff, plotTree.yOff), cntrPt, str(key))
    plotTree.yOff = plotTree.yOff + 1.0 / plotTree.totalD
```

### 函数 3.16：主函数

```python
def createPlot(inTree):
    """
    函数 3.16：主函数
    调用函数 3.15 plotTree：绘制决策树图
    :param inTree:
    :return:
    """
    fig = plt.figure(1, facecolor='white')
    fig.clf()
    axprops = dict(xticks=[], yticks=[])
    createPlot.ax1 = plt.subplot(111, frameon=False, **axprops)  # no ticks
    # createPlot.ax1 = plt.subplot(111, frameon=False) #ticks for demo puropses
    plotTree.totalW = float(getNumLeafs(inTree))
    plotTree.totalD = float(getTreeDepth(inTree))
    plotTree.xOff = -0.5 / plotTree.totalW;
    plotTree.yOff = 1.0
    plotTree(inTree, (0.5, 1.0), '')
    plt.show()
```

```python
# 测试：
inTree = retrieveTree(1) # 调用函数 
createPlot(inTree)
```

```python

```

```python

```
