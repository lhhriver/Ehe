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

        函数 1：加载数据
        函数 2：计算最佳拟合直线
        函数 3：局部加权线性回归函数，测试单行样本
        函数 4：用于测试函数3，测试全部样本

```python
import numpy as np
```

# 函数8.1：数据加载

```python
def loadDataSet(fileName):
    """
    函数8.1：数据加载
    说明：数据是用Tab分隔的文本文件，最后一个值是目标值
    :param fileName:  文件名
    :return:
    """
    numFeat = len(open(fileName).readline().split('\t')) - 1  #属性个数
    dataMat = []
    labelMat = []
    fr = open(fileName)
    for line in fr.readlines():
        lineArr = [] # 存储行
        curLine = line.strip().split('\t')
        for i in range(numFeat):
            lineArr.append(float(curLine[i]))
        dataMat.append(lineArr)
        labelMat.append(float(curLine[-1]))
    return dataMat, labelMat
```

```python
dataMat, labelMat = loadDataSet('datasets/ex0.txt')
print (u"数据矩阵为：\n", dataMat)
print (u"\n数据标签为：\n", labelMat)
```

# 函数 8.2：计算最佳拟合直线

```python
def standRegres(xArr, yArr):
    """
    函数 8.2：计算最佳拟合直线
    :param xArr: 数据
    :param yArr: 标签
    :return: 最佳系数
    """
    xMat = np.mat(xArr)
    yMat = np.mat(yArr).T  # 转置
    xTx = xMat.T * xMat
    if np.linalg.det(xTx) == 0.0:   # 行列式为 0，则不存在逆矩阵
        print (u"这个矩阵非奇异，不能求逆")
        return
    ws = xTx.I * (xMat.T * yMat)   # w 的最优解
    return ws
```

```python
xArr, yArr = loadDataSet('datasets/ex0.txt')
print (u"数据矩阵为：\n", xArr)
print (u"\n数据标签为：\n", yArr)

ws = standRegres(xArr, yArr)
print (u"最佳回归系数为：\n", ws)
```

# 函数 8.3：局部加权线性回归函数

```python
def lwlr(testPoint, xArr, yArr, k=1.0):
    """
    函数 8.3：局部加权线性回归函数
    说明：测试单行样本
    :param testPoint: 样本点
    :param xArr: 数据集
    :param yArr: 标签
    :param k:
    :return:
    """
    xMat = np.mat(xArr)
    yMat = np.mat(yArr).T
    m = np.shape(xMat)[0]
    weights = np.mat(np.eye(m))   # 对角权重矩阵
    for i in range(m):  # 计算权重矩阵
        diffMat = testPoint - xMat[i, :]  # p142
        weights[i, i] = np.exp(diffMat * diffMat.T / (-2.0 * k ** 2))
    xTx = xMat.T * (weights * xMat)  # 即 p142：XTWX
    if np.linalg.det(xTx) == 0.0:
        print (u"这个矩阵非奇异，不能求逆")
        return
    ws = xTx.I * (xMat.T * (weights * yMat))
    return testPoint * ws
```

```python
xArr, yArr = loadDataSet('datasets/ex0.txt')
print (u"数据矩阵为：\n", xArr)
print (u"\n数据标签为：\n", yArr)

ws = lwlr(xArr[0], xArr, yArr, k=1.0)
print (u"对应的yHat为：\n", ws)
```

# 函数 8.4：用于测试函数3，测试全部样本

```python
def lwlrTest(testArr, xArr, yArr, k=1.0):  # loops over all the data points and applies lwlr to each one
    """
    函数 8.4：用于测试函数3，测试全部样本
    :param testArr:
    :param xArr:
    :param yArr:
    :param k:
    :return:
    """
    m = np.shape(testArr)[0]  #行数
    yHat = np.zeros(m)
    for i in range(m):
        yHat[i] = lwlr(testArr[i], xArr, yArr, k)
    return yHat
```

```python
xArr, yArr = loadDataSet('datasets/ex0.txt')
print (u"数据矩阵为：\n", xArr)
print (u"\n数据标签为：\n", yArr)

ws = lwlrTest(xArr, xArr, yArr, k=1.0)
print (u"\n对应的yHat为：\n", ws)
```

```python
def lwlrTestPlot(xArr, yArr, k=1.0):  # same thing as lwlrTest except it sorts X first
    yHat = zeros(shape(yArr))  # easier for plotting
    xCopy = mat(xArr)
    xCopy.sort(0)
    for i in range(shape(xArr)[0]):
        yHat[i] = lwlr(xCopy[i], xArr, yArr, k)
    return yHat, xCopy
```

```python
def rssError(yArr, yHatArr):  # yArr and yHatArr both need to be arrays
    return ((yArr - yHatArr) ** 2).sum()
```

# 函数 ：岭回归

```python
def ridgeRegres(xMat, yMat, lam=0.2):
    xTx = xMat.T * xMat
    denom = xTx + np.eye(np.shape(xMat)[1]) * lam
    if linalg.det(denom) == 0.0:
        print ("This matrix is singular, cannot do inverse")
        return
    ws = denom.I * (xMat.T * yMat)
    return ws
```

```python
def ridgeTest(xArr, yArr):
    xMat = np.mat(xArr);
    yMat = np.mat(yArr).T
    yMean = np.mean(yMat, 0)
    yMat = yMat - yMean  # to eliminate X0 take mean off of Y
    # regularize X's
    xMeans = np.mean(xMat, 0)  # calc mean then subtract it off
    xVar = np.var(xMat, 0)  # calc variance of Xi then divide by it
    xMat = (xMat - xMeans) / xVar
    numTestPts = 30
    wMat = np.zeros((numTestPts, np.shape(xMat)[1]))
    for i in range(numTestPts):
        ws = ridgeRegres(xMat, yMat, exp(i - 10))
        wMat[i, :] = ws.T
    return wMat
```

```python
def regularize(xMat):  # regularize by columns
    inMat = xMat.copy()
    inMeans = np.mean(inMat, 0)  # calc mean then subtract it off
    inVar = np.var(inMat, 0)  # calc variance of Xi then divide by it
    inMat = (inMat - inMeans) / inVar
    return inMat
```

```python
def stageWise(xArr, yArr, eps=0.01, numIt=100):
    xMat = np.mat(xArr)
    yMat = np.mat(yArr).T
    yMean = np.mean(yMat, 0)
    yMat = yMat - yMean  # can also regularize ys but will get smaller coef
    xMat = regularize(xMat)
    m, n = np.shape(xMat)
    # returnMat = zeros((numIt,n)) #testing code remove
    ws = np.zeros((n, 1));
    wsTest = ws.copy();
    wsMax = ws.copy()
    for i in range(numIt):
        print (ws.T)
        lowestError = inf;
        for j in range(n):
            for sign in [-1, 1]:
                wsTest = ws.copy()
                wsTest[j] += eps * sign
                yTest = xMat * wsTest
                rssE = rssError(yMat.A, yTest.A)
                if rssE < lowestError:
                    lowestError = rssE
                    wsMax = wsTest
        ws = wsMax.copy()
        # returnMat[i,:]=ws.T
        # return returnMat
```

```python
def scrapePage(inFile, outFile, yr, numPce, origPrc):
    from BeautifulSoup import BeautifulSoup
    fr = open(inFile)
    fw = open(outFile, 'a')  #a is append mode writing
    soup = BeautifulSoup(fr.read())
    i = 1
    currentRow = soup.findAll('table', r="%d" % i)
    while (len(currentRow) != 0):
        title = currentRow[0].findAll('a')[1].text
        lwrTitle = title.lower()
        if (lwrTitle.find('new') > -1) or (lwrTitle.find('nisb') > -1):
            newFlag = 1.0
        else:
            newFlag = 0.0
        soldUnicde = currentRow[0].findAll('td')[3].findAll('span')
        if len(soldUnicde) == 0:
            print("item #%d did not sell" % i)
        else:
            soldPrice = currentRow[0].findAll('td')[4]
            priceStr = soldPrice.text
            priceStr = priceStr.replace('$', '')  #strips out $
            priceStr = priceStr.replace(',', '')  #strips out ,
            if len(soldPrice) > 1:
                priceStr = priceStr.replace('Free shipping',
                                            '')  #strips out Free Shipping
            print("%s\t%d\t%s" % (priceStr, newFlag, title))
            fw.write("%d\t%d\t%d\t%f\t%s\n" %
                     (yr, numPce, newFlag, origPrc, priceStr))
        i += 1
        currentRow = soup.findAll('table', r="%d" % i)
    fw.close()
```

```python
from time import sleep
import json
import urllib
```

```python
def searchForSet(retX, retY, setNum, yr, numPce, origPrc):
    sleep(10)
    myAPIstr = 'AIzaSyD2cR2KFyx12hXu6PFU-wrWot3NXvko8vY'
    searchURL = 'https://www.googleapis.com/shopping/search/v1/public/products?key=%s&country=US&q=lego+%d&alt=json' % (
    myAPIstr, setNum)
    pg = urllib.request.urlopen(searchURL)
    retDict = json.loads(pg.read())
    for i in range(len(retDict['items'])):
        try:
            currItem = retDict['items'][i]
            if currItem['product']['condition'] == 'new':
                newFlag = 1
            else:
                newFlag = 0
            listOfInv = currItem['product']['inventories']
            for item in listOfInv:
                sellingPrice = item['price']
                if sellingPrice > origPrc * 0.5:
                    print ("%d\t%d\t%d\t%f\t%f" % (yr, numPce, newFlag, origPrc, sellingPrice))
                    retX.append([yr, numPce, newFlag, origPrc])
                    retY.append(sellingPrice)
        except:
            print ('problem with item %d' % i)
```

```python
def setDataCollect(retX, retY):
    searchForSet(retX, retY, 8288, 2006, 800, 49.99)
    searchForSet(retX, retY, 10030, 2002, 3096, 269.99)
    searchForSet(retX, retY, 10179, 2007, 5195, 499.99)
    searchForSet(retX, retY, 10181, 2007, 3428, 199.99)
    searchForSet(retX, retY, 10189, 2008, 5922, 299.99)
    searchForSet(retX, retY, 10196, 2009, 3263, 249.99)
```

```python
def crossValidation(xArr, yArr, numVal=10):
    m = len(yArr)
    indexList = range(m)
    errorMat = np.zeros((numVal, 30))  # create error mat 30columns numVal rows
    for i in range(numVal):
        trainX = []
        trainY = []
        testX = []
        testY = []
        random.shuffle(indexList)
        for j in range(
                m
        ):  # create training set based on first 90% of values in indexList
            if j < m * 0.9:
                trainX.append(xArr[indexList[j]])
                trainY.append(yArr[indexList[j]])
            else:
                testX.append(xArr[indexList[j]])
                testY.append(yArr[indexList[j]])
        wMat = ridgeTest(trainX, trainY)  # get 30 weight vectors from ridge
        for k in range(30):  # loop over all of the ridge estimates
            matTestX = np.mat(testX)
            matTrainX = np.mat(trainX)
            meanTrain = np.mean(matTrainX, 0)
            varTrain = np.var(matTrainX, 0)
            matTestX = (matTestX - meanTrain
                        ) / varTrain  # regularize test with training params
            yEst = matTestX * np.mat(wMat[k, :]).T + np.mean(
                trainY)  # test ridge results and store
            errorMat[i, k] = rssError(yEst.T.A, np.array(testY))
            # print errorMat[i,k]
    meanErrors = np.mean(
        errorMat,
        0)  # calc avg performance of the different ridge weight vectors
    minMean = float(min(meanErrors))
    bestWeights = wMat[nonzero(meanErrors == minMean)]
    # can unregularize to get model
    # when we regularized we wrote Xreg = (x-meanX)/var(x)
    # we can now write in terms of x not Xreg:  x*w/var(x) - meanX/var(x) +meanY
    xMat = np.mat(xArr)
    yMat = np.mat(yArr).T
    meanX = np.mean(xMat, 0)
    varX = np.var(xMat, 0)
    unReg = bestWeights / varX
    print("the best model from Ridge Regression is:\n", unReg)
    print("with constant term: ",
          -1 * sum(multiply(meanX, unReg)) + np.mean(yMat))
```

```python

```
