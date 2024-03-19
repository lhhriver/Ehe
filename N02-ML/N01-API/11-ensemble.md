
# ensemble

## AdaBoostClassifier

1.AdaBoostClassifier是 AdaBoost分类器，其原型为：
```python
class sklearn.ensemble.AdaBoostClassifier(
    base_estimator=None, 
    n_estimators=50,  
    learning_rate=1.0, 
    algorithm='SAMME.R', 
    random_state=None)
```

- base_estimator：一个基础分类器对象，该基础分类器必须支持带样本权重的学习。默认为DecisionTreeClassfier。
- n_estimators：一个整数，指定基础分类器的数量（默认为50）。

当然如果训练集已经完美的训练好了，可能算法会提前停止，此时基础分类器数量少于该值。
- learning_rate：一个浮点数，表示学习率，默认为1。它就是下式中的$\nu$:
$$
H _ { m } ( \overrightarrow { \mathbf { x } } ) = H _ { m - 1 } ( \overrightarrow { \mathbf { x } } ) + \nu \alpha _ { m } h _ { m } ( \overrightarrow { \mathbf { x } } )
$$
  - 它用于减少每一步的步长，防止步长太大而跨过了极值点。
  - 通常学习率越小，则需要的基础分类器数量会越多，因此在learning_rate和n_estimators之间会有所折中。
- algorithm：一个字符串，指定用于多类分类问题的算法，默认为'SAMME.R' 。
  - 'SAMME.R' ：使用SAMME.R 算法。基础分类器对象必须支持计算类别的概率。
通常'SAMME.R' 收敛更快，且误差更小、迭代数量更少 。
  - 'SAMME'：使用SAMME算法。
- random_state：指定随机数种子。

2.模型属性：

- estimators_： 所有训练过的基础分类器。
- classes_： 所有的类别标签。
- n_classes_：类别数量。
- estimator_weights_：每个基础分类器的权重。
- estimator_errors_：每个基础分类器的分类误差。
- feature_importances_：每个特征的重要性。

3.模型方法：

- fit(X, y[, sample_weight])：训练模型。
- predict(X)：用模型进行预测，返回预测值。
- predict_log_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率的对数值。
- predict_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率值。
- score(X,y[,sample_weight])：返回模型的预测性能得分。
- staged_predict(X)：返回一个数组，数组元素依次是：集成分类器在每一轮迭代结束时的预测值。
- staged_predict_proba(X)：返回一个二维数组，数组元素依次是：集成分类器在每一轮迭代结束时，预测X为各个类别的概率值。
- staged_score(X, y[, sample_weight])：返回一个数组，数组元素依次是：集成分类器在每一轮迭代结束时，该集成分类器的预测性能得分。

```python
from sklearn.ensemble import AdaBoostClassifier

model = AdaBoostClassifier()
model.get_params()
```




    {'algorithm': 'SAMME.R',
     'base_estimator': None,
     'learning_rate': 1.0,
     'n_estimators': 50,
     'random_state': None}



<font color=bleu size=5>参数详解</font>

参数|默认值|值域|说明
---|---|---|---
algorithm|SAMME.R|---|boosting算法，也就是模型提升准则，有两种方式SAMME, 和SAMME.R两种，默认是SAMME.R，两者的区别主要是弱学习器权重的度量，前者是对样本集预测错误的概率进行划分的，后者是对样本集的预测错误的比例，即错分率进行划分的，默认是用的SAMME.R
base_estimator|None|---|基分类器，默认是决策树，在该分类器基础上进行boosting，理论上可以是任意一个分类器，但是如果是其他分类器时需要指明样本权重
learning_rate|1.0|---|学习率，表示梯度收敛速度，默认为1，如果过大，容易错过最优值，如果过小，则收敛速度会很慢；该值需要和n_estimators进行一个权衡，当分类器迭代次数较少时，学习率可以小一些，当迭代次数较多时，学习率可以适当放大
n_estimators|50|---|基分类器提升（循环）次数，默认是50次，这个值过大，模型容易过拟合；值过小，模型容易欠拟合
random_state|None|---|随机种子设置

**Adaboost-对象**

        estimators_:以列表的形式返回所有的分类器。
        classes_:类别标签
        estimator_weights_:每个分类器权重。
        estimator_errors_:每个分类器的错分率，与分类器权重相对应。
        feature_importances_:特征重要性，这个参数使用前提是基分类器也支持这个属性。


**Adaboost-方法**

        decision_function(X):返回决策函数值（比如svm中的决策距离）
        fit(X,Y):在数据集（X,Y）上训练模型。
        get_parms():获取模型参数
        predict(X):预测数据集X的结果。
        predict_log_proba(X):预测数据集X的对数概率。
        predict_proba(X):预测数据集X的概率值。
        score(X,Y):输出数据集（X,Y）在模型上的准确率。
        staged_decision_function(X):返回每个基分类器的决策函数值
        staged_predict(X):返回每个基分类器的预测数据集X的结果。
        staged_predict_proba(X):返回每个基分类器的预测数据集X的概率结果。
        staged_score(X, Y):返回每个基分类器的预测准确率。




## AdaBoostRegressor

1. AdaBoostRegressor是 AdaBoost回归器，其原型为：
```python
class sklearn.ensemble.AdaBoostRegressor(base_estimator=None, n_estimators=50,  
learning_rate=1.0, loss='linear', random_state=None)
```

- base_estimator：一个基础回归器对象，该基础回归器必须支持带样本权重的学习。默认为DecisionTreeRegressor。
- loss：一个字符串。指定了损失函数。可以为：
  - 'linear'：线性损失函数（默认）。
  - 'square'：平方损失函数。
  - 'exponential'：指数损失函数。
- 其它参数参考AdaBoostClassifier 。
2. 模型属性：

- estimators_：所有训练过的基础回归器。
- estimator_weights_：每个基础回归器的权重。
- estimator_errors_：每个基础回归器的回归误差。
- feature_importances_：每个特征的重要性。
3. 模型方法：

- fit(X, y[, sample_weight])：训练模型。
- predict(X)：用模型进行预测，返回预测值。
- score(X,y[,sample_weight])：返回模型的预测性能得分。
- staged_predict(X)：返回一个数组，数组元素依次是：集成回归器在每一轮迭代结束时的预测值。
- staged_score(X, y[, sample_weight])：返回一个数组，数组元素依次是：集成回归器在每一轮迭代结束时，该集成回归器的预测性能得分。


## RandomForestClassifier

1. GradientBoostingClassifier是随机森林分类模型，其原型为：
```python
class sklearn.ensemble.RandomForestClassifier(n_estimators=10, criterion='gini', 
max_depth=None, min_samples_split=2, min_samples_leaf=1, min_weight_fraction_leaf=0.0,
max_features='auto', max_leaf_nodes=None, bootstrap=True, oob_score=False, n_jobs=1,
random_state=None, verbose=0, warm_start=False, class_weight=None)
```
- n_estimators：一个整数，指定了随机森林中决策树的数量.
- criterion：一个字符串，指定了每个决策树的criterion参数。
- max_features：一个整数或者浮点数或者字符串或者None，指定了每个决策树的max_features参数。
- max_depth：一个整数或者None，指定了每个决策树的max_depth参数。
如果max_leaf_nodes不是None，则忽略本参数。
- min_samples_split：一个整数，指定了每个决策树的min_samples_split参数。
- min_samples_leaf：一个整数，指定了每个决策树的min_samples_leaf参数。
- min_weight_fraction_leaf：一个浮点数，指定了每个决策树的min_weight_fraction_leaf参数。
- max_leaf_nodes：为整数或者None，指定了每个基础决策树模型的max_leaf_nodes参数。
- boostrap：为布尔值。如果为True，则使用采样法bootstrap sampling来产生决策树的训练数据集。
- oob_score：为布尔值。如果为True，则使用包外样本来计算泛化误差。
- n_jobs：指定并行性。
- random_state：指定随机数种子。
- verbose：一个正数。用于开启/关闭迭代中间输出日志功能。
- warm_start：一个布尔值。用于指定是否继续使用上一次训练的结果。
- class_weight：一个字典，或者字典的列表，或者字符串'balanced'，或者字符串'balanced_subsample'，或者None：
  - 如果为字典：则字典给出了每个分类的权重，如 ：{class_label: weight} 。
  - 如果为字符串'balanced'：则每个分类的权重与该分类在样本集中出现的频率成反比。
  - 如果为字符串 'balanced_subsample'：则样本集为采样法bootstrap sampling产生的决策树的训练数据集，每个分类的权重与该分类在采用生成的样本集中出现的频率成反比。
  - 如果为None：则每个分类的权重都为 1 。

2.模型属性：

- estimators_：所有训练过的基础决策树。
- classes_：所有的类别标签。
- n_classes_：类别数量。
- n_features_：训练时使用的特征数量。
- n_outputs_：训练时输出的数量。
- feature_importances_：每个特征的重要性。
- oob_score_：训练数据使用包外估计时的得分。 

3.模型方法：

- fit(X, y[, sample_weight])：训练模型。
- predict(X)：用模型进行预测，返回预测值。
- predict_log_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率的对数值。
- predict_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率值。
- score(X,y[,sample_weight])：返回模型的预测性能得分。

```python
from sklearn.ensemble import RandomForestClassifier

nodel = RandomForestClassifier()
model.get_params()
```




    {'algorithm': 'SAMME.R',
     'base_estimator': None,
     'learning_rate': 1.0,
     'n_estimators': 50,
     'random_state': None}



<font color=bule size=5>参数详解</font>

参数|默认值|值域|说明
---|---|---|---
bootstrap|True|---|是统计学中的一种重采样技术，可以简单理解成是有放回地抽样，默认是True,即采取有放回抽样这种策略，这不就是bagging的思想么。
class_weight|None|
criterion|gini|---|样本集切分策略，默认是gini指数，此时树模型为CART模型，当值选为信息增益的时候，模型就成了ID3模型，默认为CART模型
max_depth|None|
max_features|auto|
max_leaf_nodes|None|
min_impurity_decrease|0.0|
min_impurity_split|None|
min_samples_leaf|1|
min_samples_split|2|
min_weight_fraction_leaf|0.0|
n_estimators|50|---|随机森林中树的棵树
n_jobs|None|
oob_score|False|---|袋外估计(out-of-bag)，这个外是针对于bagging这个袋子而言的，我们知道，bagging采取的随机抽样的方式去建立树模型，那么那些未被抽取到的样本集，也就是未参与建立树模型的数据集就是袋外数据集，我们就可以用这部分数据集去验证模型效果，默认值为False。
random_state|None|
verbose|0|
warm_start|False

**对象/属性**

        estimators_：打印输出随机森林中所有的树。
        classes_：输出样本集的类别。
        n_classes_：输出类别数量。
        n_features_：特征数量。
        n_outputs_：当模型被fit时的输出维度。看看下图来感受一些这个属性。
        feature_importances_：特征重要性。
        oob_score_：袋外估计准确率得分，必须是oob_score参数选择True的时候才可用。
        oob_decision_function_：袋外估计对应的决策函数。


**方法**

        apply(X)：将训练好的模型应用在数据集X上，并返回数据集X对应的叶指数。
        decision_function(X):返回决策函数值（比如svm中的决策距离）
        fit(X,Y):在数据集（X,Y）上训练模型。
        get_parms():获取模型参数
        predict(X):预测数据集X的结果。
        predict_log_proba(X):预测数据集X的对数概率。
        predict_proba(X):预测数据集X的概率值。
        score(X,Y):输出数据集（X,Y）在模型上的准确率。



```python
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.datasets import make_classification
from sklearn.metrics import classification_report
```


```python
x, y = make_classification(
    n_samples=1000,
    n_features=10,  # 特征个数= n_informative（） + n_redundant + n_repeated
    n_informative=3,  # 多信息特征的个数
    n_redundant=1,  # 冗余信息，informative特征的随机线性组合
    n_repeated=1,  # 重复信息，随机提取n_informative和n_redundant 特征
    n_classes=2,  # 分类类别
    n_clusters_per_class=2,  # 某一个类别是由几个cluster构成的
    class_sep=0.5,  # 乘以超立方体大小的因子。 较大的值分散了簇/类，并使分类任务更容易。默认为1
    random_state=1000,  # 如果是int，random_state是随机数发生器使用的种子
    shuffle=False)

x_train, x_test, y_train, y_test = train_test_split(x,
                                                    y,
                                                    test_size=0.25,
                                                    random_state=33)
```


```python
params_gs = {
    "gs__n_estimators": [200],
    "gs__class_weight": [None, "balanced"],
    "gs__max_features": ["auto", "sqrt", "log2"],
    "gs__max_depth": [3, 4, 5, 6, 7, 8],
    "gs__min_samples_split": [0.005, 0.01, 0.05, 0.10],
    "gs__min_samples_leaf": [0.005, 0.01, 0.05, 0.10],
    "gs__criterion": ["gini", "entropy"],
    "gs__n_jobs": [-1]
}

model_original = RandomForestClassifier()

#
scaler = StandardScaler()
steps = [("scaler", scaler), ("gs", model_original)]

pipeline = Pipeline(steps=steps)  # 管道

# 参数搜索
gscv = GridSearchCV(
    pipeline,
    params_gs,
    cv=5,
    n_jobs=-1,  # n_jobs=-1代表使用该计算机全部的CPU
    verbose=1,
    scoring="roc_auc")

gscv.fit(x_train, np.ravel(y_train.astype('int')))
```

    Fitting 5 folds for each of 1152 candidates, totalling 5760 fits


    [Parallel(n_jobs=-1)]: Using backend LokyBackend with 12 concurrent workers.
    [Parallel(n_jobs=-1)]: Done  26 tasks      | elapsed:    4.2s
    [Parallel(n_jobs=-1)]: Done 176 tasks      | elapsed:   10.2s
    [Parallel(n_jobs=-1)]: Done 426 tasks      | elapsed:   21.7s
    [Parallel(n_jobs=-1)]: Done 776 tasks      | elapsed:   39.4s
    [Parallel(n_jobs=-1)]: Done 1226 tasks      | elapsed:  1.0min
    [Parallel(n_jobs=-1)]: Done 1776 tasks      | elapsed:  1.5min
    [Parallel(n_jobs=-1)]: Done 2426 tasks      | elapsed:  2.1min
    [Parallel(n_jobs=-1)]: Done 3176 tasks      | elapsed:  2.7min
    [Parallel(n_jobs=-1)]: Done 4026 tasks      | elapsed:  3.4min
    [Parallel(n_jobs=-1)]: Done 4976 tasks      | elapsed:  4.3min
    [Parallel(n_jobs=-1)]: Done 5760 out of 5760 | elapsed:  5.0min finished





    GridSearchCV(cv=5, error_score='raise-deprecating',
           estimator=Pipeline(memory=None,
         steps=[('scaler', StandardScaler(copy=True, with_mean=True, with_std=True)), ('gs', RandomForestClassifier(bootstrap=True, class_weight=None, criterion='gini',
                max_depth=None, max_features='auto', max_leaf_nodes=None,
                min_impurity_decrease=0.0, min_impurity_split=None,
          ...obs=None,
                oob_score=False, random_state=None, verbose=0,
                warm_start=False))]),
           fit_params=None, iid='warn', n_jobs=-1,
           param_grid={'gs__n_estimators': [200], 'gs__class_weight': [None, 'balanced'], 'gs__max_features': ['auto', 'sqrt', 'log2'], 'gs__max_depth': [3, 4, 5, 6, 7, 8], 'gs__min_samples_split': [0.005, 0.01, 0.05, 0.1], 'gs__min_samples_leaf': [0.005, 0.01, 0.05, 0.1], 'gs__criterion': ['gini', 'entropy'], 'gs__n_jobs': [-1]},
           pre_dispatch='2*n_jobs', refit=True, return_train_score='warn',
           scoring='roc_auc', verbose=1)




```python
best_params = gscv.best_params_  # 最佳参数
best_score = gscv.best_score_  # 最高得分
best_score
```




    0.8560695471448897




```python
#
tuned_params = {item[4:]: best_params[item] for item in best_params}
model_original.set_params(**tuned_params)

# 最佳参数
parameters = model_original.get_params()
parameters
```




    {'bootstrap': True,
     'class_weight': 'balanced',
     'criterion': 'gini',
     'max_depth': 8,
     'max_features': 'auto',
     'max_leaf_nodes': None,
     'min_impurity_decrease': 0.0,
     'min_impurity_split': None,
     'min_samples_leaf': 0.005,
     'min_samples_split': 0.005,
     'min_weight_fraction_leaf': 0.0,
     'n_estimators': 200,
     'n_jobs': -1,
     'oob_score': False,
     'random_state': None,
     'verbose': 0,
     'warm_start': False}




```python
model_pre = RandomForestClassifier(**parameters)

model_pre.fit(x_train, np.ravel(y_train.astype('int')))
y_predict = model_pre.predict(x_test)
```


```python
rp = classification_report(y_test, y_predict, target_names=["负例", "正例"])
print(rp)
```

                  precision    recall  f1-score   support
    
              负例       0.75      0.78      0.77       109
              正例       0.82      0.80      0.81       141
    
       micro avg       0.79      0.79      0.79       250
       macro avg       0.79      0.79      0.79       250
    weighted avg       0.79      0.79      0.79       250


​    


```python
sc = model_pre.score(x_test, y_test)
print(sc)
```

    0.792

## RandomForestRegressor

1. RandomForestRegressor是随机森林回归模型，其原型为：

```python
class sklearn.ensemble.RandomForestRegressor(
    n_estimators=10, 
    criterion='mse', 
    max_depth=None, 
    min_samples_split=2, 
    min_samples_leaf=1, 
    min_weight_fraction_leaf=0.0,
    max_features='auto', 
    max_leaf_nodes=None, 
    bootstrap=True, 
    oob_score=False, 
    n_jobs=1,
    random_state=None, 
    verbose=0, 
    warm_start=False)
```
参数：参考 GradientBoostingClassifier 。

1. 模型属性：

- estimators_：所有训练过的基础决策树。
- n_features_：训练时使用的特征数量。
- n_outputs_：训练时输出的数量。
- feature_importances_：每个特征的重要性。
- oob_score_：训练数据使用包外估计时的得分。 
- oob_prediction_：训练数据使用包外估计时的预测值。

2. 模型方法：

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

| 参数                     | 默认值 | 值域 | 说明 |
| ------------------------ | ------ | ---- | ---- |
| bootstrap                | True   |      |      |
| criterion                | mse    |      |      |
| max_depth                | None   |      |      |
| max_features             | auto   |      |      |
| max_leaf_nodes           | None   |      |      |
| min_impurity_decrease    | 0.0    |      |      |
| min_impurity_split       | None   |      |      |
| min_samples_leaf         | 1      |      |      |
| min_samples_split        | 2      |      |      |
| min_weight_fraction_leaf | 0.0    |      |      |
| n_estimators             | warn   |      |      |
| n_jobs                   | None   |      |      |
| oob_score                | False  |      |      |
| random_state             | None   |      |      |
| verbose                  | 0      |      |      |
| warm_start               | False  |      |      |


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


```python
from sklearn.metrics import mean_absolute_error, mean_squared_error
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.datasets import load_boston

boston = load_boston()


x_train, x_test, y_train, y_test = train_test_split(
    boston.data, boston.target, random_state=33, test_size=0.25)

ss_x = StandardScaler()
ss_y = StandardScaler()

x_train = ss_x.fit_transform(x_train)
y_train = ss_y.fit_transform(y_train.reshape(-1, 1))

x_test = ss_x.transform(x_test)
y_test = ss_y.transform(y_test.reshape(-1, 1))

rfr = RandomForestRegressor()
rfr.fit(x_train, y_train)
rfr_y_predict = rfr.predict(x_test)


print('R-squared value of RandomForestRegressor:', rfr.score(x_test, y_test))
print('The mean squared error of RandomForestRegressor:', mean_squared_error(
    ss_y.inverse_transform(y_test), ss_y.inverse_transform(rfr_y_predict)))
print('The mean absoluate error of RandomForestRegressor:', mean_absolute_error(
    ss_y.inverse_transform(y_test), ss_y.inverse_transform(rfr_y_predict)))
```

    R-squared value of RandomForestRegressor: 0.7985192834517267
    The mean squared error of RandomForestRegressor: 15.623075590551185
    The mean absoluate error of RandomForestRegressor: 2.577480314960629


## GradientBoostingClassifier

梯度提升决策树

1. GradientBoostingClassifier是GBDT 分类模型，其原型为：

```python
class sklearn.ensemble.GradientBoostingClassifier(
    loss='deviance', 
    learning_rate=0.1,
    n_estimators=100, 
    subsample=1.0, 
    min_samples_split=2, 
    min_samples_leaf=1,
    min_weight_fraction_leaf=0.0, 
    max_depth=3, 
    init=None, 
    random_state=None, 
    max_features=None, 
    verbose=0, 
    max_leaf_nodes=None, 
    warm_start=False, 
    presort='auto')
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

2. 模型属性：

- feature_importances_：每个特征的重要性。
- oob_improvement_：给出训练过程中，每增加一个基础决策树，在测试集上损失函数的改善情况（即：损失函数的减少值）。
- train_score_：给出训练过程中，每增加一个基础决策树，在训练集上的损失函数的值。
- init：初始预测使用的分类器。
- estimators_：所有训练过的基础决策树。

3. 模型方法：

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



## GradientBoostingRegressor

1. GradientBoostingRegressor 是GBRT 回归模型，其原型为：

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

2. 模型属性：

- feature_importances_：每个特征的重要性。
- oob_improvement_：给出训练过程中，每增加一个基础决策树，在测试集上损失函数的改善情况（即：损失函数的减少值）。
- train_score_ ：给出训练过程中，每增加一个基础决策树，在训练集上的损失函数的值。
- init：初始预测使用的回归器。
- estimators_：所有训练过的基础决策树。

3. 模型方法：

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



<font color=bleu size=5>参数详解</font>

| 参数                     | 默认值       | 值域 | 说明 |
| ------------------------ | ------------ | ---- | ---- |
| alpha                    | 0.9          |      |      |
| criterion                | friedman_mse |      |      |
| init                     | None         |      |      |
| learning_rate            | 0.1          |      |      |
| loss                     | ls           |      |      |
| max_depth                | 3            |      |      |
| max_features             | None         |      |      |
| max_leaf_nodes           | None         |      |      |
| min_impurity_decrease    | 0.0          |      |      |
| min_impurity_split       | None         |      |      |
| min_samples_leaf         | 1            |      |      |
| min_samples_split        | 2            |      |      |
| min_weight_fraction_leaf | 0.0          |      |      |
| n_estimators             | 100          |      |      |
| n_iter_no_change         | None         |      |      |
| presort                  | auto         |      |      |
| random_state             | None         |      |      |
| subsample                | 1.0          |      |      |
| tol                      | 0.0001       |      |      |
| validation_fraction      | 0.1          |      |      |
| verbose                  | 0            |      |      |
| warm_start               | False        |      |      |


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


## ExtraTreesClassifier

```python
class sklearn.ensemble.ExtraTreeRegressor(
    bootstrap=False, 
    class_weight=None, 
    criterion='gini',
    max_depth=None, 
    max_features='auto', 
    max_leaf_nodes=None,
    min_impurity_decrease=0.0, 
    min_impurity_split=None,
    min_samples_leaf=1, 
    min_samples_split=2,
    min_weight_fraction_leaf=0.0, 
    n_estimators='warn',
    n_jobs=None, 
    oob_score=False, 
    random_state=None, 
    verbose=0,
    warm_start=False)
```



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

| 参数                     | 默认值 | 值域 | 说明 |
| ------------------------ | ------ | ---- | ---- |
| bootstrap                | False  |      |      |
| criterion                | mse    |      |      |
| max_depth                | None   |      |      |
| max_features             | auto   |      |      |
| max_leaf_nodes           | None   |      |      |
| min_impurity_decrease    | 0.0    |      |      |
| min_impurity_split       | None   |      |      |
| min_samples_leaf         | 1      |      |      |
| min_samples_split        | 2      |      |      |
| min_weight_fraction_leaf | 0.0    |      |      |
| n_estimators             | warn   |      |      |
| n_jobs                   | None   |      |      |
| oob_score                | False  |      |      |
| random_state             | None   |      |      |
| verbose                  | 0      |      |      |
| warm_start               | False  |      |      |


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





