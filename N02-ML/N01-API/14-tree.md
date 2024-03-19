
# tree

## DecisionTreeClassifier

1. DecisionTreeClassifier 是分类决策树，其原型为：

```python
sklearn.tree.DecisionTreeClassifier(
    criterion='gini',  # 指定切分质量的评价准则
    splitter='best', 
    max_depth=None,
    min_samples_split=2, 
    min_samples_leaf=1, 
    min_weight_fraction_leaf=0.0, 
    max_features=None,
    random_state=None, 
    max_leaf_nodes=None, 
    class_weight=None,
    presort=False)
```

- criterion：一个字符串，指定切分质量的评价准则。可以为：
  - 'gini'：表示切分时评价准则是Gini系数
  - 'entropy'：表示切分时评价准则是熵
- 其它参数参考 DecisionTreeRegressor 。

2. 模型属性：

- classes_：分类的标签值。
- n_classes_：给出了分类的数量。
- 其它属性参考 DecisionTreeRegressor  。

3. 模型方法：

- fit(X, y[, sample_weight, check_input, ...])：训练模型。
- predict(X[, check_input])：用模型进行预测，返回预测值。
- predict_log_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率的对数值。
- predict_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率值。
- score(X,y[,sample_weight])：返回模型的预测性能得分。

```python
from sklearn.tree import DecisionTreeClassifier

dtr = DecisionTreeClassifier()
dtr.get_params()
```




    {'class_weight': None,
     'criterion': 'gini',
     'max_depth': None,
     'max_features': None,
     'max_leaf_nodes': None,
     'min_impurity_decrease': 0.0,
     'min_impurity_split': None,
     'min_samples_leaf': 1,
     'min_samples_split': 2,
     'min_weight_fraction_leaf': 0.0,
     'presort': False,
     'random_state': None,
     'splitter': 'best'}




```python
params = dtr.get_params()
li = [i for i in dir(dtr) if not i.startswith("_") and i not in params]
li
```




    ['apply',
     'decision_path',
     'feature_importances_',
     'fit',
     'get_params',
     'predict',
     'predict_log_proba',
     'predict_proba',
     'score',
     'set_params']




```python
dtr.fit(x_train, y_train)
dtr
```



### 参数详解

|           参数           | 默认值 |      值域      | 说明                                                         |
| :----------------------: | :----: | :------------: | ------------------------------------------------------------ |
|       class_weight       |  None  |                | 权重设置，主要是用于处理不平衡样本，可以自定义类别权重，也可以直接使用balanced参数值进行不平衡样本处理 |
|        criterion         |  gini  | {gini,entropy} | 特征选择的标准，有信息增益和基尼系数两种，使用信息增益的是ID3和C4.5算法（使用信息增益比），使用基尼系数的CART算法 |
|        max_depth         |  None  |                | 决策树最大深度，先对所有数据集进行切分，再在子数据集上循环切分，max_depth可以理解成用来限制这个循环次数。 |
|       max_features       |  None  |                | 特征切分时考虑的最大特征数量，默认是对所有特征进行切分，也可以传入int类型的值，表示具体的特征个数；也可以是浮点数，则表示特征个数的百分比；还可以是sqrt,表示总特征数的平方根；也可以是log2，表示总特征数的log个特征。 |
|      max_leaf_nodes      |  None  |                | 最大叶节点个数，即数据集切分成子数据集的最大个数。           |
|  min_impurity_decrease   |  0.0   |                | 切分点不纯度最小减少程度，如果某个结点的不纯度减少小于这个值，那么该切分点就会被移除。 |
|    min_impurity_split    |  None  |                | 切分点最小不纯度，用来限制数据集的继续切分（决策树的生成），如果某个节点的不纯度（可以理解为分类错误率）小于这个阈值，那么该点的数据将不再进行切分。 |
|     min_samples_leaf     |   1    |                | 叶节点（子数据集）最小样本数，如果子数据集中的样本数小于这个值，那么该叶节点和其兄弟节点都会被剪枝（去掉），该值默认为1 |
|    min_samples_split     |   2    |                | 子数据集再切分需要的最小样本量，默认是2，如果子数据样本量小于2时，则不再进行下一步切分。如果数据量较小，使用默认值就可，如果数据量较大，为降低计算量，应该把这个值增大，即限制子数据集的切分次数。 |
| min_weight_fraction_leaf |  0.0   |                | 在叶节点处的所有输入样本权重总和的最小加权分数，如果不输入则表示所有的叶节点的权重是一致的。 |
|         presort          | False  |                | 是否进行预排序，默认是False，所谓预排序就是提前对特征进行排序，我们知道，决策树分割数据集的依据是，优先按照信息增益/基尼系数大的特征来进行分割的，涉及的大小就需要比较，如果不进行预排序，则会在每次分割的时候需要重新把所有特征进行计算比较一次，如果进行了预排序以后，则每次分割的时候，只需要拿排名靠前的特征就可以了 |
|       random_state       |  None  |                | 随机种子的设置                                               |
|         splitter         |  best  | {best,random}  | 特征切分点选择标准，决策树是递归地选择最优切分点，spliter是用来指明在哪个集合上来递归，best表示在所有特征上递归，适用于数据集较小的时候，random表示随机选择一部分特征进行递归，适用于数据集较大的时候。 |

### **对象/属性**

> classes\_:分类模型的类别，以字典的形式输出
>
> feature\_importances\_: 特征重要性，以列表的形式输出每个特征的重要性
>
> max\_features\_: 最大特征数
>
> n\_classes\_: 类别数，与classes\_对应，classes\_输出具体的类别
>
> n\_features\_: 特征数，当数据量小时，一般max\_features和n\_features\_相等
>
> n\_outputs\_: 输出结果数
>
> tree\_: 输出整个决策树,用于生成决策树的可视化

### **方法**

    decision_path(X): 返回X的决策路径
    fit(X, y): 在数据集(X,y)上使用决策树模型
    get_params([deep]): 获取模型的参数
    predict(X): 预测数据值X的标签
    predict_log_proba(X): 返回每个类别的概率值的对数
    predict_proba(X): 返回每个类别的概率值（有几类就返回几列值）
    score(X,y): 返回给定测试集和对应标签的平均准确率


```python
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction import DictVectorizer
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import classification_report

# titanic = pd.read_csv('http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/titanic.txt')
# titanic.to_csv('titanic.csv')
titanic = pd.read_csv('titanic.csv')
titanic = titanic[['pclass', 'age', 'sex', 'survived']]
titanic['age'].fillna(titanic['age'].mean(), inplace=True)

x_train, x_test, y_train, y_test = train_test_split(
    titanic[['pclass', 'age', 'sex']],
    titanic['survived'],
    test_size=0.25,
    random_state=33)

vec = DictVectorizer(sparse=False)
# 转换特征后，我们发现凡是类别型的特征都单独剥离出来，独成一列特征，数值型的则保持不变
x_train = vec.fit_transform(x_train.to_dict(orient='record'))
print(vec.feature_names_)

x_test = vec.transform(x_test.to_dict(orient='record'))

dtc = DecisionTreeClassifier()
dtc.fit(x_train, y_train)
y_pred = dtc.predict(x_test)

print(dtc.score(x_test, y_test))

print(classification_report(y_pred, y_test, target_names=['died', 'survived']))
"""
相比于其他学习模型，决策树在模型描述上有着巨大的优势，决策树的推断逻辑非常直观，
具有清晰的可解释性，也方便了模型的可视化，
这些特性同时也保证了在使用决策树模型时是无需考虑对数据的量化，甚至标准化的，
并且与前一节k近邻模型不同，决策树树仍然属于有参数模型，
需要花费更多的时间在训练数据上
"""
```

    ['age', 'pclass=1st', 'pclass=2nd', 'pclass=3rd', 'sex=female', 'sex=male']
    0.7811550151975684
                  precision    recall  f1-score   support
    
            died       0.91      0.78      0.84       236
        survived       0.58      0.80      0.67        93
    
       micro avg       0.78      0.78      0.78       329
       macro avg       0.74      0.79      0.75       329
    weighted avg       0.81      0.78      0.79       329


​    




    '\n相比于其他学习模型，决策树在模型描述上有着巨大的优势，决策树的推断逻辑非常直观，\n具有清晰的可解释性，也方便了模型的可视化，\n这些特性同时也保证了在使用决策树模型时是无需考虑对数据的量化，甚至标准化的，\n并且与前一节k近邻模型不同，决策树树仍然属于有参数模型，\n需要花费更多的时间在训练数据上\n'



## DecisionTreeRegressor

1. DecisionTreeRegressor 是回归决策树，其原型为：

```python
class sklearn.tree.DecisionTreeRegressor(
    criterion='mse', 
    splitter='best', 
    max_depth=None, 
    min_samples_split=2, 
    min_samples_leaf=1,
    min_weight_fraction_leaf=0.0, 
    max_features=None,random_state=None, 
    max_leaf_nodes=None, 
    presort=False)
```

- criterion：一个字符串，指定切分质量的评价准则。默认为'mse'，且只支持该字符串，表示均方误差。

- splitter：一个字符串，指定切分原则。可以为：
  - 'best'：表示选择最优的切分。
  - 'random'：表示随机切分。
- max_features：可以为整数、浮点、字符串或者None，指定寻找最优拆分时考虑的特征数量。
  - 如果是整数，则每次切分只考虑 max_features 个特征。
  - 如果是浮点数，则每次切分只考虑  max_features * n_features 个特征，max_features指定了百分比。
  - 如果是字符串'sqrt'，则 max_features等于 sqrt(n_features) 。
  - 如果是字符串'log2'，则 max_features等于 log2(n_features) 。
  - 如果是 None或者 'auto'，则 max_features等于 n_features 。

注意：如果已经考虑了max_features 个特征，但是还没有找到一个有效的切分，那么还会继续寻找下一个特征，直到找到一个有效的切分为止。

- max_depth：可以为整数或者None，指定树的最大深度。
  - 如果为None，则表示树的深度不限。分裂子结点，直到每个叶子都是纯的（即：叶结点中所有样本点都属于一个类），或者叶结点中包含小于 min_samples_split 个样点。
  - 如果 max_leaf_nodes参数非 None，则忽略此选项。
- min_samples_split：为整数，指定每个内部结点包含的最少的样本数。
- min_samples_leaf：为整数，指定每个叶结点包含的最少的样本数。
- min_weight_fraction_leaf：为浮点数，叶结点中样本的最小权重系数。
- max_leaf_nodes：为整数或者None，指定最大的叶结点数量。
  - 如果为None，此时叶结点数量不限。
  - 如果非None，则max_depth被忽略。
- class_weight：为一个字典、字符串'balanced'、或者 None 。它指定了分类的权重。
  - 如果为字典，则权重的形式为：{class_label:weight}。
  - 如果为字符串'balanced' ，则表示分类的权重是样本中各分类出现的频率的反比。
  - 如果为None，则每个分类的权重都为1 。

注意：如果提供了 sample_weight参数（由 fit方法提供），则这些权重都会乘以sample_weight 。
- random_state：指定随机数种子。
- presort：一个布尔值，指定是否要提前排序数据从而加速寻找最优切分的过程。
  - 对于大数据集，设置为 True 会减慢总体的训练过程。
  - 对于一个小数据集或者设定了最大深度的情况下，设置为 True 会加速训练过程。

2. 模型属性：

- feature_importances_：给出了特征的重要程度。该值越高，则该特征越重要。
- max_features_：max_features的推断值。
- n_features_：当执行fit之后，特征的数量。
- n_outputs_：当执行fit之后，输出的数量。
- tree_：一个 Tree对象，即底层的决策树。

3. 模型方法：

- fit(X, y[, sample_weight, check_input, ...])：训练模型。
- predict(X[, check_input])：用模型进行预测，返回预测值。
- score(X,y[,sample_weight])：返回模型的预测性能得分。

```python
import numpy as np
from sklearn.datasets import load_boston
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.tree import DecisionTreeRegressor
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

dtr = DecisionTreeRegressor()
dtr.fit(x_train, y_train)
y_pred = dtr.predict(x_test)

print('R-squared value of DecisionTreeRegressor:', dtr.score(x_test, y_test))
print(
    'The mean squared error of DecisionTreeRegressor:',
    mean_squared_error(ss_y.inverse_transform(y_test),
                       ss_y.inverse_transform(y_pred)))
print(
    'The mean absoluate error of DecisionTreeRegressor:',
    mean_absolute_error(ss_y.inverse_transform(y_test),
                        ss_y.inverse_transform(y_pred)))
```

    R-squared value of DecisionTreeRegressor: 0.5406430333773062
    The mean squared error of DecisionTreeRegressor: 35.619133858267716
    The mean absoluate error of DecisionTreeRegressor: 3.388188976377953

