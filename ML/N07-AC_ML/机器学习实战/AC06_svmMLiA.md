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
'''
函数 6.1：读取数据
函数 6.2：数据可视化
'''
import numpy as np
import matplotlib.pyplot as plt
%matplotlib inline

from time import sleep
```

# 函数 6.1：读取数据

```python
def loadDataSet(fileName):
    """
    函数 6.1：读取数据
    :param fileName: 文件名
    :return: dataMat 数据矩阵, labelMat 数据标签
    """
    dataMat = []
    labelMat = []
    fr = open(fileName)
    for line in fr.readlines():
        lineArr = line.strip().split('\t')
        dataMat.append([float(lineArr[0]), float(lineArr[1])])  # 添加数据
        labelMat.append(float(lineArr[2]))  # 添加标签
    return dataMat, labelMat
```

```python
dataMat, labelMat = loadDataSet('datasets/testSet2.txt')
```

# 函数 6.2：数据可视化

```python
def showDataSet(dataMat, labelMat):
    """
    函数 6.2：数据可视化
    :param dataMat: 数据矩阵
    :param labelMat: 标签
    :return:
    """

    data_plus = []  #正样本
    data_minus = []  #负样本
    for i in range(len(dataMat)):
        if labelMat[i] > 0:
            data_plus.append(dataMat[i])
        else:
            data_minus.append(dataMat[i])
    data_plus_np = np.array(data_plus)  #转换为numpy矩阵
    data_minus_np = np.array(data_minus)  #转换为numpy矩阵
    plt.scatter(np.transpose(data_plus_np)[0],
                np.transpose(data_plus_np)[1])  #正样本散点图
    plt.scatter(
        np.transpose(data_minus_np)[0],
        np.transpose(data_minus_np)[1])  #负样本散点图
    plt.show()
```

```python
dataMat, labelMat = loadDataSet('datasets/testSet2.txt')
showDataSet(dataMat, labelMat)
```

# 辅助函数 6.3：随机选择alpha

```python
def selectJrand(i, m):
    """
    辅助函数 6.3：随机选择alpha
    :param i: 第一个alpha的下标
    :param m: alpha参数个数
    :return: j
    """
    j = i
    while (j == i):  # 只要输入函数值不等于i，函数就会进行随机选择
        j = int(random.uniform(0, m))
    return j
```

```python
i = 3
m = 5
selectJrand(i, m)
```

# 辅助函数 6.4：修剪alpha

```python
def clipAlpha(aj, H, L):
    """
    辅助函数 6.4：修剪alpha
    说明：用于调整大于H，小于L的alpha值，将大于H的调整为H，将小于L的调整为L
    :param aj: alpha值
    :param H: alpha上限
    :param L: alpha下限
    :return: alpah值
    """
    if aj > H:
        aj = H
    if L > aj:
        aj = L
    return aj
```

# 函数 6.5 ：简化版SMO算法

```python
def smoSimple(dataMatIn, classLabels, C, toler, maxIter):
    """
    函数 6.5 ：简化版SMO算法
    说明：http://blog.csdn.net/c406495762/article/details/78072313
        SMO算法是将大优化问题分解为多个小优化问题来求解的。
        这些小优化问题往往很容易求解，并且对它们进行顺序求解的结果与将它们作为整体来求解的结果完全一致的。
        在结果完全相同的同时，SMO算法的求解时间短很多。

        SMO算法的目标是求出一系列alpha和b，一旦求出了这些alpha，就很容易计算出权重向量w并得到分隔超平面。

    ---->SMO算法的工作原理：
        每次循环中选择两个alpha进行优化处理。一旦找到了一对合适的alpha，那么就增大其中一个同时减小另一个。
        alpha必须符合以下两个条件：
            1.两个alpha必须要在间隔边界之外，
            2.这两个alpha还没有进进行过区间化处理或者不在边界上。

    ---->SMO算法的步骤
            步骤1：计算误差：
            步骤2：计算上下界L和H：
            步骤3：计算 学习速率η：
            步骤4：更新 αj：
            步骤5：根据取值范围修剪 αj：
            步骤6：更新 αi：
            步骤7：更新 b1和 b2：
            步骤8：根据 b1和 b2更新 b：
    :param dataMatIn:数据矩阵
    :param classLabels:数据标签
    :param C:松弛变量
    :param toler:容错率
    :param maxIter:最大迭代次数
    :return:
    """
    # 转换为numpy的mat存储
    dataMatrix = mat(dataMatIn)
    labelMat = mat(classLabels).transpose()

    # 初始化b参数，统计dataMatrix的维度
    b = 0
    m, n = shape(dataMatrix)

    # 初始化alpha参数，设为0
    alphas = mat(zeros((m, 1)))
    iter = 0  # 初始化迭代次数,记录没有任何alpha改变的情况下遍历数据集的次数
    while (iter < maxIter):  #最多迭代matIter次
        alphaPairsChanged = 0  # 记录alpha是否已经进行优化
        for i in range(m):
            # 步骤1：计算误差Ei*********************************
            # fXi预测的类别，见论文公式 3.14
            fXi = float(
                multiply(alphas, labelMat).T *
                (dataMatrix * dataMatrix[i, :].T)) + b
            Ei = fXi - float(labelMat[i])  # 预测结果与真实结果比对，计算误差Ei

            # if checks if an example violates KKT conditions
            # 如果误差很大，那么可对该数据实例所对应的alpha值进行优化，分别对正间隔和负间隔做了测试，
            # 并且检查了alpha值，保证其不能等于0或者C，由于后面alpha小于0或者大于C时将被调整为0或C，
            # 所以一旦该if语句中它们等于这两个值得话，那么它们就已经在“边界”上了，因而不再能够减小或增大，
            # 因此也就不值得对它们进行优化
            # 优化alpha，更设定一定的容错率
            if ((labelMat[i] * Ei < -toler) and
                (alphas[i] < C)) or ((labelMat[i] * Ei > toler) and
                                     (alphas[i] > 0)):
                # 利用辅助函数，随机选择另一个与alpha_i成对优化的alpha_j
                j = selectJrand(i, m)  # 返回一个0到 m，不等于i的数

                # 步骤1：计算误差Ej****************************************
                fXj = float(
                    multiply(alphas, labelMat).T *
                    (dataMatrix * dataMatrix[j, :].T)) + b
                Ej = fXj - float(labelMat[j])

                # 保存更新前的aplpha值，使用深拷贝
                alphaIold = alphas[i].copy()  # 两个alpha
                alphaJold = alphas[j].copy()

                # 步骤2：计算上下界L和H************************************
                # L和 H用于将alphas[j]调整到0-C之间，更新上下限
                if (labelMat[i] != labelMat[j]):
                    L = max(0, alphas[j] - alphas[i])
                    H = min(C, C + alphas[j] - alphas[i])
                else:
                    L = max(0, alphas[j] + alphas[i] - C)
                    H = min(C, alphas[j] + alphas[i])

                if L == H:  # 如果L==H，就不做任何改变，直接执行continue语句
                    print('L==H')
                    continue

                # 步骤3：计算eta ***************************************************
                # eta是alphas[j]的最优修改量，如果eta==0，需要退出for循环的当前迭代过程
                eta = 2.0 * dataMatrix[i, :] * dataMatrix[j, :].T - \
                      dataMatrix[i, :] * dataMatrix[i, :].T - \
                      dataMatrix[j, :] * dataMatrix[j, :].T

                if eta >= 0:
                    print('eta>=0')
                    continue

                # 步骤4：更新alpha_j**********************************
                # 计算出一个新的alphas[j]值
                alphas[j] -= labelMat[j] * (Ei - Ej) / eta

                # 步骤5：修剪alpha_j*******************************
                # 并使用辅助函数，以及L和H对其进行调整
                alphas[j] = clipAlpha(alphas[j], H, L)

                # 检查alphas[j]是否有轻微改变，如果是的话，退出for循环
                if (abs(alphas[j] - alphaJold) < 0.00001):
                    print("alpha_j变化太小")
                    continue

                # 步骤6：更新alpha_i**********************************
                # 然后alphas[i]和alphas[j]同样进行改变，虽然改变的大小一样，但是改变的方向正好相反
                alphas[i] += labelMat[j] * labelMat[i] * (alphaJold -
                                                          alphas[j])

                # 步骤7：更新b_1和b_2********************************************
                # 在对alphas[i]和alphas[j]进行优化后，给这两个alpha值设置一个常数项b
                b1 = b - Ei - labelMat[i] * (alphas[i] - alphaIold) * dataMatrix[i, :] * dataMatrix[i, :].T - \
                     labelMat[j] * (alphas[j] - alphaJold) * dataMatrix[i, :] * dataMatrix[j, :].T

                b2 = b - Ej - labelMat[i] * (alphas[i] - alphaIold) * dataMatrix[i, :] * dataMatrix[j, :].T - \
                     labelMat[j] * (alphas[j] - alphaJold) * dataMatrix[j, :] * dataMatrix[j, :].T

                # 步骤8：根据b_1和b_2更新b*****************************************
                if (0 < alphas[i]) and (C > alphas[i]):
                    b = b1
                elif (0 < alphas[j]) and (C > alphas[j]):
                    b = b2
                else:
                    b = (b1 + b2) / 2.0
                alphaPairsChanged += 1  #统计优化次数
                print("第%d次迭代样本:%d, alpha优化次数:%d" %
                      (iter, i, alphaPairsChanged))

        # 更新迭代次数
        if (alphaPairsChanged == 0):
            iter += 1
        else:
            iter = 0
        print("迭代次数: %d" % iter)
    return b, alphas
```

```python
dataMat, labelMat = loadDataSet('datasets/testSet2.txt')
b, alphas = smoSimple(dataMat, labelMat, 0.6, 0.001, 40)
```

# 完整版Platt SMO的支持函数

```python
class optStructK:
    """
    完整版Platt SMO的支持函数,实现成员变量的填充
    """
    def __init__(self, dataMatIn, classLabels, C, toler):  # Initialize the structure with the parameters
        self.X = dataMatIn
        self.labelMat = classLabels
        self.C = C
        self.tol = toler
        self.m = shape(dataMatIn)[0]
        self.alphas = mat(zeros((self.m, 1)))
        self.b = 0
        self.eCache = mat(zeros((self.m, 2)))  # first column is valid flag
```

# 辅助函数

```python
def calcEk(oS, k):
    fXk = float(multiply(oS.alphas, oS.labelMat).T * oS.K[:, k] + oS.b)
    Ek = fXk - float(oS.labelMat[k])
    return Ek
```

# 用于选择第二个alpha或者说内循环的alpha值

```python
def selectJ(i, oS, Ei):  # this is the second choice -heurstic, and calcs Ej
    maxK = -1
    maxDeltaE = 0
    Ej = 0
    oS.eCache[i] = [
        1, Ei
    ]  # set valid #choose the alpha that gives the maximum delta E
    validEcacheList = nonzero(oS.eCache[:, 0].A)[0]
    if (len(validEcacheList)) > 1:
        for k in validEcacheList:  # loop through valid Ecache values and find the one that maximizes delta E
            if k == i: continue  # don't calc for i, waste of time
            Ek = calcEk(oS, k)
            deltaE = abs(Ei - Ek)
            if (deltaE > maxDeltaE):
                maxK = k
                maxDeltaE = deltaE
                Ej = Ek
        return maxK, Ej
    else:  # in this case (first time around) we don't have any valid eCache values
        j = selectJrand(i, oS.m)  # 调用函数 selectJrand
        Ej = calcEk(oS, j)
    return j, Ej
```

# 辅助函数，计算误差并存入缓存当中

```python
def updateEk(
        oS,
        k):  # after any alpha has changed update the new value in the cache
    Ek = calcEk(oS, k)
    oS.eCache[k] = [1, Ek]
```

# 完整Platt SMO算法中的优化

```python
def innerL(i, oS):
    # 调用函数 calcEk
    Ei = calcEk(oS, i)
    if ((oS.labelMat[i] * Ei < -oS.tol) and
        (oS.alphas[i] < oS.C)) or ((oS.labelMat[i] * Ei > oS.tol) and
                                   (oS.alphas[i] > 0)):
        # 调用函数 selectJ
        j, Ej = selectJ(i, oS, Ei)  # this has been changed from selectJrand
        alphaIold = oS.alphas[i].copy()
        alphaJold = oS.alphas[j].copy()

        if (oS.labelMat[i] != oS.labelMat[j]):
            L = max(0, oS.alphas[j] - oS.alphas[i])
            H = min(oS.C, oS.C + oS.alphas[j] - oS.alphas[i])
        else:
            L = max(0, oS.alphas[j] + oS.alphas[i] - oS.C)
            H = min(oS.C, oS.alphas[j] + oS.alphas[i])

        if L == H:
            print("L==H")
            return 0

        eta = 2.0 * oS.K[i, j] - oS.K[i, i] - oS.K[j, j]  # changed for kernel

        if eta >= 0:
            print("eta>=0")
            return 0

        oS.alphas[j] -= oS.labelMat[j] * (Ei - Ej) / eta
        oS.alphas[j] = clipAlpha(oS.alphas[j], H, L)  # 调用函数clipAlpha
        updateEk(oS, j)  # added this for the Ecache

        if (abs(oS.alphas[j] - alphaJold) < 0.00001):
            print("j not moving enough")
            return 0

        oS.alphas[i] += oS.labelMat[j] * oS.labelMat[i] * (
            alphaJold - oS.alphas[j])  # update i by the same amount as j
        updateEk(oS, i)  # added this for the Ecache
        # #the update is in the oppostie direction

        b1 = oS.b - Ei - oS.labelMat[i] * (oS.alphas[i] - alphaIold) * oS.K[
            i, i] - oS.labelMat[j] * (oS.alphas[j] - alphaJold) * oS.K[i, j]
        b2 = oS.b - Ej - oS.labelMat[i] * (oS.alphas[i] - alphaIold) * oS.K[
            i, j] - oS.labelMat[j] * (oS.alphas[j] - alphaJold) * oS.K[j, j]

        if (0 < oS.alphas[i]) and (oS.C > oS.alphas[i]):
            oS.b = b1
        elif (0 < oS.alphas[j]) and (oS.C > oS.alphas[j]):
            oS.b = b2
        else:
            oS.b = (b1 + b2) / 2.0
        return 1
    else:
        return 0
```

# 完整版Platt SMO的外循环代码

```python
def smoP(dataMatIn, classLabels, C, toler, maxIter,
         kTup=('lin', 0)):  # full Platt SMO
    oS = optStruct(mat(dataMatIn),
                   mat(classLabels).transpose(), C, toler, kTup)
    iter = 0
    entireSet = True
    alphaPairsChanged = 0
    while (iter < maxIter) and ((alphaPairsChanged > 0) or (entireSet)):
        alphaPairsChanged = 0
        if entireSet:  # go over all
            for i in range(oS.m):
                alphaPairsChanged += innerL(i, oS)
                print("fullSet, iter: %d i:%d, pairs changed %d" %
                      (iter, i, alphaPairsChanged))
            iter += 1
        else:  # go over non-bound (railed) alphas
            nonBoundIs = nonzero((oS.alphas.A > 0) * (oS.alphas.A < C))[0]
            for i in nonBoundIs:
                alphaPairsChanged += innerL(i, oS)
                print("non-bound, iter: %d i:%d, pairs changed %d" %
                      (iter, i, alphaPairsChanged))
            iter += 1
        if entireSet:
            entireSet = False  # toggle entire set loop
        elif (alphaPairsChanged == 0):
            entireSet = True
        print("iteration number: %d" % iter)
    return oS.b, oS.alphas
```

# 根据 smoP 返回结果计算 w

```python
def calcWs(alphas, dataArr, classLabels):
    X = mat(dataArr)
    labelMat = mat(classLabels).transpose()
    m, n = shape(X)
    w = zeros((n, 1))
    for i in range(m):
        w += multiply(alphas[i] * labelMat[i], X[i, :].T)
    return w
```

```python
class optStruct:
    def __init__(self, dataMatIn, classLabels, C, toler,
                 kTup):  # Initialize the structure with the parameters
        self.X = dataMatIn
        self.labelMat = classLabels
        self.C = C
        self.tol = toler
        self.m = shape(dataMatIn)[0]
        self.alphas = mat(zeros((self.m, 1)))
        self.b = 0
        self.eCache = mat(zeros((self.m, 2)))  # first column is valid flag
        self.K = mat(zeros((self.m, self.m)))
        for i in range(self.m):
            self.K[:, i] = kernelTrans(self.X, self.X[i, :], kTup)
```

```python
class optStructK:
    def __init__(self, dataMatIn, classLabels, C, toler):  # Initialize the structure with the parameters
        self.X = dataMatIn
        self.labelMat = classLabels
        self.C = C
        self.tol = toler
        self.m = shape(dataMatIn)[0]
        self.alphas = mat(zeros((self.m, 1)))
        self.b = 0
        self.eCache = mat(zeros((self.m, 2)))  # first column is valid flag
```

```python
# 核转换函数
def kernelTrans(
        X, A, kTup
):  # calc the kernel or transform data to a higher dimensional space
    m, n = shape(X)
    K = mat(zeros((m, 1)))
    if kTup[0] == 'lin':
        K = X * A.T  # linear kernel
    elif kTup[0] == 'rbf':
        for j in range(m):
            deltaRow = X[j, :] - A
            K[j] = deltaRow * deltaRow.T
        K = exp(K / (-1 * kTup[1]**2)
                )  # divide in NumPy is element-wise not matrix like Matlab
    else:
        raise NameError(
            'Houston We Have a Problem -- That Kernel is not recognized')
    return K
```

```python
dataMat, labelMat = loadDataSet('datasets/testSet2.txt')
b,alpha = smoP(dataMat, labelMat, 200, 0.0001, 10000, kTup=('lin', 0))
ws = calcWs(alpha, dataMat, labelMat)

datMat = mat(dataMat)

datMat[0] * mat(ws) + b
labelMat[0]
```

# 利用核函数进行分类的径向基测试函数

```python
def testRbf(k1=1.3):
    dataArr, labelArr = loadDataSet('datasets/testSetRBF.txt')
    # 调用完整版Platt SMO的外循环函数
    b, alphas = smoP(dataArr, labelArr, 200, 0.0001, 10000,
                     ('rbf', k1))  # C=200 important
    datMat = mat(dataArr)
    labelMat = mat(labelArr).transpose()
    svInd = nonzero(alphas.A > 0)[0]
    sVs = datMat[svInd]  # get matrix of only support vectors
    labelSV = labelMat[svInd]
    print("there are %d Support Vectors" % shape(sVs)[0])
    m, n = shape(datMat)
    errorCount = 0
    for i in range(m):
        kernelEval = kernelTrans(sVs, datMat[i, :], ('rbf', k1))
        predict = kernelEval.T * multiply(labelSV, alphas[svInd]) + b
        if sign(predict) != sign(labelArr[i]): errorCount += 1
    print("the training error rate is: %f" % (float(errorCount) / m))
    dataArr, labelArr = loadDataSet('datasets/testSetRBF2.txt')
    errorCount = 0
    datMat = mat(dataArr)
    labelMat = mat(labelArr).transpose()
    m, n = shape(datMat)
    for i in range(m):
        kernelEval = kernelTrans(sVs, datMat[i, :], ('rbf', k1))
        predict = kernelEval.T * multiply(labelSV, alphas[svInd]) + b
        if sign(predict) != sign(labelArr[i]): errorCount += 1
    print("the test error rate is: %f" % (float(errorCount) / m))
```

```python
testRbf()
```

```python
# 手写识别问题回顾------------------------------------------------------------------
def img2vector(filename):
    returnVect = zeros((1, 1024))
    fr = open(filename)
    for i in range(32):
        lineStr = fr.readline()
        for j in range(32):
            returnVect[0, 32 * i + j] = int(lineStr[j])
    return returnVect
```

```python
def loadImages(dirName):
    from os import listdir
    hwLabels = []
    trainingFileList = listdir(dirName)  # load the training set
    m = len(trainingFileList)
    trainingMat = zeros((m, 1024))
    for i in range(m):
        fileNameStr = trainingFileList[i]
        fileStr = fileNameStr.split('.')[0]  # take off .txt
        classNumStr = int(fileStr.split('_')[0])
        if classNumStr == 9:
            hwLabels.append(-1)
        else:
            hwLabels.append(1)
        trainingMat[i, :] = img2vector('%s/%s' % (dirName, fileNameStr))
    return trainingMat, hwLabels
```

```python
def testDigits(kTup=('rbf', 10)):
    dataArr, labelArr = loadImages('datasets/trainingDigits')
    b, alphas = smoP(dataArr, labelArr, 200, 0.0001, 10000, kTup)
    datMat = mat(dataArr)
    labelMat = mat(labelArr).transpose()
    svInd = nonzero(alphas.A > 0)[0]
    sVs = datMat[svInd]
    labelSV = labelMat[svInd]
    print("there are %d Support Vectors" % shape(sVs)[0])
    m, n = shape(datMat)
    errorCount = 0
    for i in range(m):
        kernelEval = kernelTrans(sVs, datMat[i, :], kTup)
        predict = kernelEval.T * multiply(labelSV, alphas[svInd]) + b

        if sign(predict) != sign(labelArr[i]):
            errorCount += 1
    print("the training error rate is: %f" % (float(errorCount) / m))

    dataArr, labelArr = loadImages('datasets/testDigits')
    errorCount = 0
    datMat = mat(dataArr)
    labelMat = mat(labelArr).transpose()
    m, n = shape(datMat)

    for i in range(m):
        kernelEval = kernelTrans(sVs, datMat[i, :], kTup)
        predict = kernelEval.T * multiply(labelSV, alphas[svInd]) + b
        if sign(predict) != sign(labelArr[i]):
            errorCount += 1
    print("the test error rate is: %f" % (float(errorCount) / m))
```

```python
testDigits(kTup=('rbf', 20))
```

# Non-Kernel VErsions below

```python
class optStructK:
    def __init__(self, dataMatIn, classLabels, C, toler):  # Initialize the structure with the parameters
        self.X = dataMatIn
        self.labelMat = classLabels
        self.C = C
        self.tol = toler
        self.m = shape(dataMatIn)[0]
        self.alphas = mat(zeros((self.m, 1)))
        self.b = 0
        self.eCache = mat(zeros((self.m, 2)))  # first column is valid flag
```

```python
def calcEkK(oS, k):
    fXk = float(multiply(oS.alphas, oS.labelMat).T * (oS.X * oS.X[k, :].T)) + oS.b
    Ek = fXk - float(oS.labelMat[k])
    return Ek
```

```python
def selectJK(i, oS, Ei):  # this is the second choice -heurstic, and calcs Ej
    maxK = -1;
    maxDeltaE = 0;
    Ej = 0
    oS.eCache[i] = [1, Ei]  # set valid #choose the alpha that gives the maximum delta E
    validEcacheList = nonzero(oS.eCache[:, 0].A)[0]
    if (len(validEcacheList)) > 1:
        for k in validEcacheList:  # loop through valid Ecache values and find the one that maximizes delta E
            if k == i: continue  # don't calc for i, waste of time
            Ek = calcEk(oS, k)
            deltaE = abs(Ei - Ek)
            if (deltaE > maxDeltaE):
                maxK = k;
                maxDeltaE = deltaE;
                Ej = Ek
        return maxK, Ej
    else:  # in this case (first time around) we don't have any valid eCache values
        j = selectJrand(i, oS.m)
        Ej = calcEk(oS, j)
    return j, Ej
```

```python
def updateEkK(oS, k):  # after any alpha has changed update the new value in the cache
    Ek = calcEk(oS, k)
    oS.eCache[k] = [1, Ek]
```

```python
def innerLK(i, oS):
    Ei = calcEk(oS, i)
    if ((oS.labelMat[i] * Ei < -oS.tol) and (oS.alphas[i] < oS.C)) or (
        (oS.labelMat[i] * Ei > oS.tol) and (oS.alphas[i] > 0)):
        j, Ej = selectJ(i, oS, Ei)  # this has been changed from selectJrand
        alphaIold = oS.alphas[i].copy();
        alphaJold = oS.alphas[j].copy();
        if (oS.labelMat[i] != oS.labelMat[j]):
            L = max(0, oS.alphas[j] - oS.alphas[i])
            H = min(oS.C, oS.C + oS.alphas[j] - oS.alphas[i])
        else:
            L = max(0, oS.alphas[j] + oS.alphas[i] - oS.C)
            H = min(oS.C, oS.alphas[j] + oS.alphas[i])
        if L == H: print ("L==H"); return 0
        eta = 2.0 * oS.X[i, :] * oS.X[j, :].T - oS.X[i, :] * oS.X[i, :].T - oS.X[j, :] * oS.X[j, :].T
        if eta >= 0: print ("eta>=0"); return 0
        oS.alphas[j] -= oS.labelMat[j] * (Ei - Ej) / eta
        oS.alphas[j] = clipAlpha(oS.alphas[j], H, L)
        updateEk(oS, j)  # added this for the Ecache
        if (abs(oS.alphas[j] - alphaJold) < 0.00001): print ("j not moving enough"); return 0
        oS.alphas[i] += oS.labelMat[j] * oS.labelMat[i] * (alphaJold - oS.alphas[j])  # update i by the same amount as j
        updateEk(oS, i)  # added this for the Ecache                    #the update is in the oppostie direction
        b1 = oS.b - Ei - oS.labelMat[i] * (oS.alphas[i] - alphaIold) * oS.X[i, :] * oS.X[i, :].T - oS.labelMat[j] * (
        oS.alphas[j] - alphaJold) * oS.X[i, :] * oS.X[j, :].T
        b2 = oS.b - Ej - oS.labelMat[i] * (oS.alphas[i] - alphaIold) * oS.X[i, :] * oS.X[j, :].T - oS.labelMat[j] * (
        oS.alphas[j] - alphaJold) * oS.X[j, :] * oS.X[j, :].T
        if (0 < oS.alphas[i]) and (oS.C > oS.alphas[i]):
            oS.b = b1
        elif (0 < oS.alphas[j]) and (oS.C > oS.alphas[j]):
            oS.b = b2
        else:
            oS.b = (b1 + b2) / 2.0
        return 1
    else:
        return 0
```

```python
def smoPK(dataMatIn, classLabels, C, toler, maxIter):  # full Platt SMO
    oS = optStruct(mat(dataMatIn), mat(classLabels).transpose(), C, toler)
    iter = 0
    entireSet = True
    alphaPairsChanged = 0
    while (iter < maxIter) and ((alphaPairsChanged > 0) or (entireSet)):
        alphaPairsChanged = 0
        if entireSet:  # go over all
            for i in range(oS.m):
                alphaPairsChanged += innerL(i, oS)
                print("fullSet, iter: %d i:%d, pairs changed %d" %
                      (iter, i, alphaPairsChanged))
            iter += 1
        else:  # go over non-bound (railed) alphas
            nonBoundIs = nonzero((oS.alphas.A > 0) * (oS.alphas.A < C))[0]
            for i in nonBoundIs:
                alphaPairsChanged += innerL(i, oS)
                print("non-bound, iter: %d i:%d, pairs changed %d" %
                      (iter, i, alphaPairsChanged))
            iter += 1
        if entireSet:
            entireSet = False  # toggle entire set loop
        elif (alphaPairsChanged == 0):
            entireSet = True
        print("iteration number: %d" % iter)
    return oS.b, oS.alphas
```
