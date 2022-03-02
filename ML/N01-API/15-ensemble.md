
# ensemble

## ExtraTreesRegressor


```python
from sklearn.ensemble import ExtraTreesRegressor

model = ExtraTreesRegressor()
model.get_params()
```




    {'bootstrap': False,
     'criterion': 'mse',
     'max_depth': None,
     'max_features': 'auto',
     'max_leaf_nodes': None,
     'min_impurity_decrease': 0.0,
     'min_impurity_split': None,
     'min_samples_leaf': 1,
     'min_samples_split': 2,
     'min_weight_fraction_leaf': 0.0,
     'n_estimators': 'warn',
     'n_jobs': None,
     'oob_score': False,
     'random_state': None,
     'verbose': 0,
     'warm_start': False}



<font color=bleu size=5>参数详解</font>

参数|默认值|值域|说明
---|---|---|---
bootstrap|False
criterion|mse
max_depth|None
max_features|auto
max_leaf_nodes|None
min_impurity_decrease|0.0
min_impurity_split|None
min_samples_leaf|1
min_samples_split|2
min_weight_fraction_leaf|0.0
n_estimators|warn
n_jobs|None
oob_score|False
random_state|None
verbose|0
warm_start|False


```python
from sklearn.datasets import load_boston
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import ExtraTreesRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error

boston = load_boston()
x_train, x_test, y_train, y_test = train_test_split(boston.data,
                                                    boston.target,
                                                    random_state=33,
                                                    test_size=0.25)


ss_x = StandardScaler()
ss_y = StandardScaler()

x_train = ss_x.fit_transform(x_train)
y_train = ss_y.fit_transform(y_train.reshape(-1, 1))

x_test = ss_x.transform(x_test)
y_test = ss_y.transform(y_test.reshape(-1, 1))

etr = ExtraTreesRegressor()
etr.fit(x_train, y_train)
etr_y_predict = etr.predict(x_test)


print('R-squared value of ExtraTreesRegessor:', etr.score(x_test, y_test))
print('The mean squared error of  ExtraTreesRegessor:', mean_squared_error(
    ss_y.inverse_transform(y_test), ss_y.inverse_transform(etr_y_predict)))
print('The mean absoluate error of ExtraTreesRegessor:', mean_absolute_error(
    ss_y.inverse_transform(y_test), ss_y.inverse_transform(etr_y_predict)))

# 利用训练好的极端回归森林模型，输出每种特征对预测目标的贡献度。?????
# print(np.sort(zip(etr.feature_importances_, boston.feature_names), axis=0))
```

    R-squared value of ExtraTreesRegessor: 0.7932286404543304
    The mean squared error of  ExtraTreesRegessor: 16.033318897637795
    The mean absoluate error of ExtraTreesRegessor: 2.357716535433071


## GradientBoostingRegressor

1.GradientBoostingRegressor 是GBRT 回归模型，其原型为：
```python
class sklearn.ensemble.GradientBoostingRegressor(loss='ls', learning_rate=0.1,
n_estimators=100, subsample=1.0, min_samples_split=2, min_samples_leaf=1,
min_weight_fraction_leaf=0.0, max_depth=3, init=None, random_state=None,
max_features=None, alpha=0.9, verbose=0, max_leaf_nodes=None, warm_start=False, 
presort='auto')
```

- loss：一个字符串，指定损失函数。可以为：

  - 'ls'：损失函数为平方损失函数。

  - 'lad'：损失函数为绝对值损失函数。

  - 'huber'：损失函数为上述两者的结合，通过alpha参数指定比例，该损失函数的定义为：
$$
L _ { H u b e r } = \left\{ \begin{array} { l l } { \frac { 1 } { 2 } ( y - f ( x ) ) ^ { 2 } , } & { \text { if } | y - f ( x ) | \leq \alpha } \\ { \alpha | y - f ( x ) | - \frac { 1 } { 2 } \alpha ^ { 2 } , } & { \text { else } } \end{array} \right.
$$
即误差较小时，采用平方损失；在误差较大时，采用绝对值损失。

- 'quantile'：分位数回归（分位数指得是百分之几），通过alpha参数指定分位数。

- alpha：一个浮点数，只有当loss='huber'或者loss='quantile'时才有效。

- n_estimators： 其它参数参考GradientBoostingClassifier 。

2.模型属性：

- feature_importances_：每个特征的重要性。
- oob_improvement_：给出训练过程中，每增加一个基础决策树，在测试集上损失函数的改善情况（即：损失函数的减少值）。
- train_score_ ：给出训练过程中，每增加一个基础决策树，在训练集上的损失函数的值。
- init：初始预测使用的回归器。
- estimators_：所有训练过的基础决策树。

3.模型方法：

- fit(X, y[, sample_weight, monitor])：训练模型。

其中monitor是一个可调用对象，它在当前迭代过程结束时调用。如果它返回True，则训练过程提前终止。

- predict(X)：用模型进行预测，返回预测值。

- score(X,y[,sample_weight])：返回模型的预测性能得分。

- staged_predict(X)：返回一个数组，数组元素依次是：GBRT 在每一轮迭代结束时的预测值。

- staged_score(X, y[, sample_weight])：返回一个数组，数组元素依次是：GBRT在每一轮迭代结束时，该GBRT的预测性能得分。

```python
from sklearn.ensemble import GradientBoostingRegressor

model = GradientBoostingRegressor()
model.get_params()
```




    {'alpha': 0.9,
     'criterion': 'friedman_mse',
     'init': None,
     'learning_rate': 0.1,
     'loss': 'ls',
     'max_depth': 3,
     'max_features': None,
     'max_leaf_nodes': None,
     'min_impurity_decrease': 0.0,
     'min_impurity_split': None,
     'min_samples_leaf': 1,
     'min_samples_split': 2,
     'min_weight_fraction_leaf': 0.0,
     'n_estimators': 100,
     'n_iter_no_change': None,
     'presort': 'auto',
     'random_state': None,
     'subsample': 1.0,
     'tol': 0.0001,
     'validation_fraction': 0.1,
     'verbose': 0,
     'warm_start': False}




```python

```

<font color=bleu size=5>参数详解</font>

参数|默认值|值域|说明
---|---|---|---
alpha|0.9
criterion|friedman_mse
init|None
learning_rate|0.1
loss|ls
max_depth|3
max_features|None
max_leaf_nodes|None
min_impurity_decrease|0.0
min_impurity_split|None
min_samples_leaf|1
min_samples_split|2
min_weight_fraction_leaf|0.0
n_estimators|100
n_iter_no_change|None
presort|auto
random_state|None
subsample|1.0
tol|0.0001
validation_fraction|0.1
verbose|0
warm_start|False


```python
from sklearn.metrics import mean_absolute_error, mean_squared_error
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.preprocessing import StandardScaler
import numpy as np
from sklearn.datasets import load_boston
from sklearn.model_selection import train_test_split

boston = load_boston()
x_train, x_test, y_train, y_test = train_test_split(
    boston.data, boston.target, random_state=33, test_size=0.25)

ss_x = StandardScaler()
ss_y = StandardScaler()

x_train = ss_x.fit_transform(x_train)
y_train = ss_y.fit_transform(y_train.reshape(-1, 1))

x_test = ss_x.transform(x_test)
y_test = ss_y.transform(y_test.reshape(-1, 1))

gbr = GradientBoostingRegressor()
gbr.fit(x_train, y_train)
gbr_y_predict = gbr.predict(x_test)

print('R-squared value of GradientBoostingRegressor:', gbr.score(x_test, y_test))
print('The mean squared error of GradientBoostingRegressor:', mean_squared_error(
    ss_y.inverse_transform(y_test), ss_y.inverse_transform(gbr_y_predict)))
print('The mean absoluate error of GradientBoostingRegressor:', mean_absolute_error(
    ss_y.inverse_transform(y_test), ss_y.inverse_transform(gbr_y_predict)))
```

    R-squared value of GradientBoostingRegressor: 0.8421124067813195
    The mean squared error of GradientBoostingRegressor: 12.242808373547959
    The mean absoluate error of GradientBoostingRegressor: 2.270717345039415


## GradientBoostingClassifier

1.GradientBoostingClassifier是GBDT 分类模型，其原型为：
```python
class sklearn.ensemble.GradientBoostingClassifier(loss='deviance', learning_rate=0.1,
n_estimators=100, subsample=1.0, min_samples_split=2, min_samples_leaf=1,
min_weight_fraction_leaf=0.0, max_depth=3, init=None, random_state=None, 
max_features=None, verbose=0, max_leaf_nodes=None, warm_start=False, presort='auto')
```

- loss：一个字符串，指定损失函数。可以为：

  - 'deviance'（默认值）：此时损失函数为对数损失函数：   。
  - 'exponential'：此时使用指数损失函数。

- n_estimators：一个整数，指定基础决策树的数量（默认为100），值越大越好。

- learning_rate：一个浮点数，表示学习率，默认为1。它就是下式中的$\nu$： 
$$
H _ { m } ( \overrightarrow { \mathbf { x } } ) = H _ { m - 1 } ( \overrightarrow { \mathbf { x } } ) + \nu \alpha _ { m } h _ { m } ( \overrightarrow { \mathbf { x } } )
$$
  - 它用于减少每一步的步长，防止步长太大而跨过了极值点。
  - 通常学习率越小，则需要的基础分类器数量会越多，因此在learning_rate和n_estimators之间会有所折中。

- max_depth：一个整数或者None，指定了每个基础决策树模型的max_depth参数。

  - 调整该参数可以获得最佳性能。
  - 如果max_leaf_nodes不是None，则忽略本参数。

- min_samples_split：一个整数，指定了每个基础决策树模型的min_samples_split参数。

- min_samples_leaf：一个整数，指定了每个基础决策树模型的min_samples_leaf参数。

- min_weight_fraction_leaf：一个浮点数，指定了每个基础决策树模型的min_weight_fraction_leaf参数。

- subsample：一个大于 0 小于等于 1.0 的浮点数，指定了提取原始训练集中多大比例的一个子集用于训练基础决策树。

  - 如果 subsample小于1.0，则梯度提升决策树模型就是随机梯度提升决策树。此时会减少方差但是提高了偏差。

  - 它会影响n_estimators参数。

- max_features：一个整数或者浮点数或者字符串或者None，指定了每个基础决策树模型的max_features参数。

如果 max_features< n_features，则会减少方差但是提高了偏差。

- max_leaf_nodes：为整数或者None，指定了每个基础决策树模型的max_leaf_nodes参数。

- init：一个基础分类器对象或者None，该分类器对象用于执行初始的预测。

如果为None，则使用loss.init_estimator 。

- verbose：一个正数。用于开启/关闭迭代中间输出日志功能。

- warm_start：一个布尔值。用于指定是否继续使用上一次训练的结果。

- random_state：一个随机数种子。

- presort：一个布尔值或者'auto'。指定了每个基础决策树模型的presort参数。

2.模型属性：

- feature_importances_：每个特征的重要性。
- oob_improvement_：给出训练过程中，每增加一个基础决策树，在测试集上损失函数的改善情况（即：损失函数的减少值）。
- train_score_：给出训练过程中，每增加一个基础决策树，在训练集上的损失函数的值。
- init：初始预测使用的分类器。
- estimators_：所有训练过的基础决策树。


3.模型方法：

- fit(X, y[, sample_weight, monitor])：训练模型。其中monitor是一个可调用对象，它在当前迭代过程结束时调用。如果它返回True，则训练过程提前终止。

- predict(X)：用模型进行预测，返回预测值。

- predict_log_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率的对数值。

- predict_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率值。

- score(X,y[,sample_weight])：返回模型的预测性能得分。

- staged_predict(X)：返回一个数组，数组元素依次是：GBDT 在每一轮迭代结束时的预测值。

- staged_predict_proba(X)：返回一个二维数组，数组元素依次是：GBDT 在每一轮迭代结束时，预测X为各个类别的概率值。

- staged_score(X, y[, sample_weight])：返回一个数组，数组元素依次是：GBDT 在每一轮迭代结束时，该GBDT 的预测性能得分。

```python
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction import DictVectorizer
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import classification_report
import pandas as pd

titanic = pd.read_csv('titanic.csv')
titanic = titanic[['pclass', 'age', 'sex', 'survived']]
titanic['age'].fillna(titanic['age'].mean(), inplace=True)

x_train, x_test, y_train, y_test = train_test_split(
    titanic[['pclass', 'age', 'sex']],
    titanic['survived'],
    test_size=0.25,
    random_state=33)

vec = DictVectorizer(sparse=False)
x_train = vec.fit_transform(x_train.to_dict(orient='record'))
x_test = vec.transform(x_test.to_dict(orient='record'))

gbc = GradientBoostingClassifier()
gbc.fit(x_train, y_train)
y_pred = gbc.predict(x_test)

# 输出梯度提升决策树在测试集上的分类准确性，以及更加详细的精确率、召回率、F1指标。
print('>>>The accuracy of gradient tree boosting is\n', gbc.score(x_test, y_test))
print(classification_report(y_pred, y_test))
```

    >>>The accuracy of gradient tree boosting is
     0.790273556231003
                  precision    recall  f1-score   support
    
               0       0.92      0.78      0.84       239
               1       0.58      0.82      0.68        90
    
       micro avg       0.79      0.79      0.79       329
       macro avg       0.75      0.80      0.76       329
    weighted avg       0.83      0.79      0.80       329


​    


```python

```

## RandomForestRegressor

1.RandomForestRegressor是随机森林回归模型，其原型为：
```python
class sklearn.ensemble.RandomForestRegressor(n_estimators=10, criterion='mse', 
max_depth=None, min_samples_split=2, min_samples_leaf=1, min_weight_fraction_leaf=0.0,
max_features='auto', max_leaf_nodes=None, bootstrap=True, oob_score=False, n_jobs=1,
random_state=None, verbose=0, warm_start=False)
```
参数：参考 GradientBoostingClassifier 。

1.模型属性：

- estimators_：所有训练过的基础决策树。
- n_features_：训练时使用的特征数量。
- n_outputs_：训练时输出的数量。
- feature_importances_：每个特征的重要性。
- oob_score_：训练数据使用包外估计时的得分。 
- oob_prediction_：训练数据使用包外估计时的预测值。

2.模型方法：

- fit(X, y[, sample_weight])：训练模型。
- predict(X)：用模型进行预测，返回预测值。
- score(X,y[,sample_weight])：返回模型的预测性能得分。

```python
from sklearn.ensemble import RandomForestRegressor

model = RandomForestRegressor()
model.get_params()
```




    {'bootstrap': True,
     'criterion': 'mse',
     'max_depth': None,
     'max_features': 'auto',
     'max_leaf_nodes': None,
     'min_impurity_decrease': 0.0,
     'min_impurity_split': None,
     'min_samples_leaf': 1,
     'min_samples_split': 2,
     'min_weight_fraction_leaf': 0.0,
     'n_estimators': 'warn',
     'n_jobs': None,
     'oob_score': False,
     'random_state': None,
     'verbose': 0,
     'warm_start': False}



<font color=bleu size=5>参数详解</font>

参数|默认值|值域|说明
---|---|---|---
bootstrap|True
criterion|mse
max_depth|None
max_features|auto
max_leaf_nodes|None
min_impurity_decrease|0.0
min_impurity_split|None
min_samples_leaf|1
min_samples_split|2
min_weight_fraction_leaf|0.0
n_estimators|warn
n_jobs|None
oob_score|False
random_state|None
verbose|0
warm_start|False


```python
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction import DictVectorizer
from sklearn.metrics import classification_report
from sklearn.ensemble import RandomForestClassifier

titanic = pd.read_csv('titanic.csv')
titanic = titanic[['pclass', 'age', 'sex', 'survived']]
titanic['age'].fillna(titanic['age'].mean(), inplace=True)

x_train, x_test, y_train, y_test = train_test_split(
    titanic[['pclass', 'age', 'sex']],
    titanic['survived'],
    test_size=0.25,
    random_state=33)

vec = DictVectorizer(sparse=False)
x_train = vec.fit_transform(x_train.to_dict(orient='record'))
x_test = vec.transform(x_test.to_dict(orient='record'))

rfc = RandomForestClassifier()
rfc.fit(x_train, y_train)
y_pred = rfc.predict(x_test)

print('>>>The accuracy of random forest classifier is\n',
      rfc.score(x_test, y_test))
print(classification_report(y_pred, y_test))
```

    >>>The accuracy of random forest classifier is
     0.7781155015197568
                  precision    recall  f1-score   support
    
               0       0.91      0.77      0.83       237
               1       0.57      0.79      0.67        92
    
       micro avg       0.78      0.78      0.78       329
       macro avg       0.74      0.78      0.75       329
    weighted avg       0.81      0.78      0.79       329


​    