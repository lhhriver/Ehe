
# neighbors

## KNeighborsClassifier

1. KNeighborsClassifier 是knn 分类模型，其原型为：

```python
sklearn.neighbors.KNeighborsClassifier(
    n_neighbors=5, 
    weights='uniform',
    algorithm='auto', 
    leaf_size=30, 
    p=2, 
    metric='minkowski',
    metric_params=None, 
    n_jobs=1, 
    **kwargs)
```

- n_neighbors：一个整数，指定$k$值。
- weights：一字符串或者可调用对象，指定投票权重策略。

  - 'uniform'：本结点的所有邻居结点的投票权重都相等  。
  - 'distance'：本结点的所有邻居结点的投票权重与距离成反比。即越近的结点，其投票权重越大。
  - 一个可调用对象：它传入距离的数组，返回同样形状的权重数组。
- algorithm：一字符串，指定计算最近邻的算法。可以为：

  - 'ball_tree'：使用 BallTree算法。
  - 'kd_tree：使用 KDTree算法。
  - 'brute'：使用暴力搜索法。
  - 'auto'：自动决定最合适的算法。
- leaf_size：一个整数，指定BallTree或者 KDTree叶结点规模。它影响了树的构建和查询速度。
- metric：一个字符串，指定距离度量。默认为'minkowski'距离。
- p ：一个整数，指定在'Minkowski'度量上的指数。如果 p=1，对应于曼哈顿距离；p=2对应于欧拉距离。
- n_jobs：并行度。



2. 模型方法：

- fit(X,y)：训练模型。
- predict(X)：用模型进行预测，返回预测值。
- score(X,y)：返回模型的预测性能得分。
- predict_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率值。
- kneighbors([X, n_neighbors, return_distance])：返回样本点的$k$近邻点。如果return_distance=True，同时还返回到这些近邻点的距离。
- kneighbors_graph([X, n_neighbors, mode])：返回样本点的$k$近邻点的连接图。

```python
from sklearn.neighbors import KNeighborsClassifier

model = KNeighborsClassifier()
model.fit(x_train, y_train)
model
```




```python
KNeighborsClassifier(
    algorithm='auto', 
    leaf_size=30, 
    metric='minkowski',
    metric_params=None, 
    n_jobs=None, 
    n_neighbors=5, 
    p=2,
    weights='uniform')
```




```python
model.get_params()
```




```python
from sklearn.datasets import load_iris
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier

iris = load_iris()

x_train, x_test, y_train, y_test = train_test_split(iris.data,
                                                    iris.target,
                                                    test_size=0.25,
                                                    random_state=33)

ss = StandardScaler()
x_train = ss.fit_transform(x_train)
x_test = ss.transform(x_test)

knc = KNeighborsClassifier()
knc.fit(x_train, y_train)
y_pred = knc.predict(x_test)

print('>>>The accuracy of K-Nearest Neighbor Classifier is\n',
      knc.score(x_test, y_test))

print(classification_report(y_test, y_pred, target_names=iris.target_names))
"""
k近邻属于无参数模型中非常简单的一种，然而，正是这样的决策算法，
导致了其非常高的计算复杂度和内存消耗，因为该模型每处理一个测试样本，
都需要对所有预先加载在内存的训练样本进行遍历，
逐一计算相似度、排序并且选取k个最近邻训练样本的标记，
进而作出分类决策。这是平方级别的算法复杂度，
一旦数据规模稍大，需权衡更多计算时间的代价。
"""
```

    >>>The accuracy of K-Nearest Neighbor Classifier is
     0.8947368421052632
                  precision    recall  f1-score   support
    
          setosa       1.00      1.00      1.00         8
      versicolor       0.73      1.00      0.85        11
       virginica       1.00      0.79      0.88        19
    
       micro avg       0.89      0.89      0.89        38
       macro avg       0.91      0.93      0.91        38
    weighted avg       0.92      0.89      0.90        38


 

## KNeighborsRegressor

1. KNeighborsRegressor是knn 回归模型，其原型为：

```python
sklearn.neighbors.KNeighborsRegressor(
    n_neighbors=5, 
    weights='uniform', 
    algorithm='auto', 
    leaf_size=30, 
    p=2, 
    metric='minkowski', 
    metric_params=None, 
    n_jobs=1, 
    **kwargs)
```
参数：参考KNeighborsClassifier 。

2. 模型方法：

- fit(X,y)：训练模型。
- predict(X)：用模型进行预测，返回预测值。
- score(X,y)：返回模型的预测性能得分。
- kneighbors([X, n_neighbors, return_distance])：返回样本点的  近邻点。如果return_distance=True，同时还返回到这些近邻点的距离。
- kneighbors_graph([X, n_neighbors, mode])：返回样本点的  近邻点的连接图。

```python
import numpy as np
from sklearn.datasets import load_boston
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error

boston = load_boston()
x_train, x_test, y_train, y_test = train_test_split(boston.data,
                                                    boston.target,
                                                    random_state=33,
                                                    test_size=0.25)

# 分析回归目标值的差异。
# print("The max target value is", np.max(boston.target))
# print("The min target value is", np.min(boston.target))
# print("The average target value is", np.mean(boston.target))

ss_x = StandardScaler()
ss_y = StandardScaler()

x_train = ss_x.fit_transform(x_train)
y_train = ss_y.fit_transform(y_train.reshape(-1, 1))

x_test = ss_x.transform(x_test)
y_test = ss_y.transform(y_test.reshape(-1, 1))

# 初始化K近邻回归器，并且调整配置，使得预测的方式为平均回归：weights='uniform'。
uni_knr = KNeighborsRegressor(weights='uniform')
uni_knr.fit(x_train, y_train)
uni_knr_y_predict = uni_knr.predict(x_test)

# 初始化K近邻回归器，并且调整配置，使得预测的方式为根据距离加权回归：weights='distance'。
dis_knr = KNeighborsRegressor(weights='distance')
dis_knr.fit(x_train, y_train)
dis_knr_y_predict = dis_knr.predict(x_test)

print('R-squared value of uniform-weighted KNeighorRegression:',
      uni_knr.score(x_test, y_test))
print(
    'The mean squared error of uniform-weighted KNeighorRegression:',
    mean_squared_error(ss_y.inverse_transform(y_test),
                       ss_y.inverse_transform(uni_knr_y_predict)))
print(
    'The mean absoluate error of uniform-weighted KNeighorRegression',
    mean_absolute_error(ss_y.inverse_transform(y_test),
                        ss_y.inverse_transform(uni_knr_y_predict)))
print("***".center(50, "+"))
print('R-squared value of distance-weighted KNeighorRegression:',
      dis_knr.score(x_test, y_test))
print(
    'The mean squared error of distance-weighted KNeighorRegression:',
    mean_squared_error(ss_y.inverse_transform(y_test),
                       ss_y.inverse_transform(dis_knr_y_predict)))
print(
    'The mean absoluate error of distance-weighted KNeighorRegression:',
    mean_absolute_error(ss_y.inverse_transform(y_test),
                        ss_y.inverse_transform(dis_knr_y_predict)))
```

    R-squared value of uniform-weighted KNeighorRegression: 0.6907212176346006
    The mean squared error of uniform-weighted KNeighorRegression: 23.981877165354337
    The mean absoluate error of uniform-weighted KNeighorRegression 2.9650393700787396
    +++++++++++++++++++++++***++++++++++++++++++++++++
    R-squared value of distance-weighted KNeighorRegression: 0.7201094821421603
    The mean squared error of distance-weighted KNeighorRegression: 21.703073090490353
    The mean absoluate error of distance-weighted KNeighorRegression: 2.801125502210876

