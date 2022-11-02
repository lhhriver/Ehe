# feature_selection

## 过滤式特征选取

### VarianceThreshold
> VarianceThreshold 用于剔除方差很小的特征，其原型为：

```python
class sklearn.feature_selection.VarianceThreshold(threshold=0.0)
```
- threshold：一个浮点数，指定方差的阈值。低于此阈值的特征将被剔除。

>属性：

- variances_：一个数组，元素分别是各特征的方差。

>方法：

- fit(X[, y])：从样本数据中学习每个特征的方差。
- transform(X)：执行特征选择，即删除低于指定阈值的特征。
- fit_transform(X[, y])：从样本数据中学习每个特征的方差，然后执行特征选择。
- get_support([indices])：返回保留的特征。
  - 如果indices=True，则返回被选出的特征的索引。
  - 如果indices=False，则返回一个布尔值组成的数组，该数组指示哪些特征被选择。
- inverse_transform(X)：根据被选出来的特征还原原始数据（特征选取的逆操作），但是对于被删除的特征的值全部用 0 代替。

### SelectKBest
>SelectKBest 用于保留统计得分最高的  个特征，其原型为：

```python
class sklearn.feature_selection.SelectKBest(score_func=<function f_classif>, k=10)
```

- score_func：一个函数，用于给出统计指标。

该函数的参数为 (X,y) ，返回值为(scores,pvalues) 。

  - X ：样本集合。通常是一个numpy array，每行代表一个样本，每列代表一个特征。
  - y ：样本的标签集合。它与X 的每一行相对应。
  - scores ：样本的得分集合。它与X 的每一行相对应。
  - pvalues：样本得分的p 值。它与X 的每一行相对应。
- k：一个整数或者字符串'all'，指定要保留最佳的几个特征。

如果为'all'，则保留所有的特征。

>sklearn提供的常用的统计指标函数为：

- sklearn.feature_selection.f_regression：基于线性回归分析来计算统计指标，适用于回归问题。
- sklearn.feature_selection.chi2：计算卡方统计量，适用于分类问题。
- sklearn.feature_selection.f_classif：根据方差分析Analysis of variance：ANOVA的原理，依靠F-分布为机率分布的依据，利用平方和与自由度所计算的组间与组内均方估计出F值。适用于分类问题 。

>属性：

- scores_：一个数组，给出了所有特征的得分。
- pvalues_：一个数组，给出了所有特征得分的p-values 。

>方法：参考VarianceThreshold 。

### SelectPercentile

>SelectPercentile 用于保留统计得分最高的  比例的特征，其原型为：

```python
class sklearn.feature_selection.SelectPercentile(
    score_func=<function f_classif>,
    percentile=10)
```
- score_func：一个函数，用于给出统计指标。参考SelectKBest  。
- percentile：一个整数，指定要保留最佳的百分之几的特征，如10表示保留最佳的百分之十的特征

>属性：参考SelectKBest 。

>方法：参考VarianceThreshold 。

```python
from sklearn.tree import DecisionTreeClassifier
from sklearn.feature_selection import SelectPercentile, chi2
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction import DictVectorizer


# titanic = pd.read_csv('http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/titanic.txt')
titanic = pd.read_csv('titanic.csv')

# 分离数据特征与预测目标
x = titanic.drop(['row.names', 'name', 'survived'], axis=1)
y = titanic['survived']

# 对对缺失数据进行填充
x['age'].fillna(x['age'].mean(), inplace=True)
x.fillna('UNKNOWN', inplace=True)

x_train, x_test, y_train, y_test = train_test_split(
    x, y, test_size=0.25, random_state=33)

vec = DictVectorizer()
x_train = vec.fit_transform(x_train.to_dict(orient='record'))
x_test = vec.transform(x_test.to_dict(orient='record'))

# 处理后特征向量的维度
# print(len(vec.feature_names_))

# 筛选前20%的特征，使用相同配置的决策树模型进行预测，并且评估性能
fs = SelectPercentile(chi2, percentile=20)
x_train_fs = fs.fit_transform(x_train, y_train)
x_test_fs = fs.transform(x_test)

dt2 = DecisionTreeClassifier(criterion='entropy')
dt2.fit(x_train_fs, y_train)
y_pred = dt2.predict(x_test_fs)
# dt2.score(x_test_fs, y_test)

print(classification_report(y_pred, y_test,
                            digits=4, target_names=['died', 'survived']))
```

                  precision    recall  f1-score   support
    
            died     0.8366    0.8048    0.8204       210
        survived     0.6772    0.7227    0.6992       119
    
       micro avg     0.7751    0.7751    0.7751       329
       macro avg     0.7569    0.7637    0.7598       329
    weighted avg     0.7790    0.7751    0.7765       329

## 包裹式特征选取

### RFE

>RFE类用于实现包裹式特征选取，其原型为：

```python
class sklearn.feature_selection.RFE(estimator, n_features_to_select=None,step=1,verbose=0)
```
- estimator：一个学习器，它必须提供一个.fit方法和一个.coef_特征。
其中.coef_特征中存放的是学习到的各特征的权重系数。
通常使用SVM和广义线性模型作为estimator参数。
- n_features_to_select：一个整数或者None，指定要选出几个特征。

如果为None，则默认选取一半的特征。
- step：一个整数或者浮点数，指定每次迭代要剔除权重最小的几个特征。
  - 如果大于等于1，则作为整数，指定每次迭代要剔除特征的数量。
  - 如果在0.0~1.0之间，则指定每次迭代要剔除特征的比例。
- verbose：一个整数，控制输出日志。

>RFE要求学习器能够学习特征的权重（如线性模型），其原理为：

- 首先学习器在初始的特征集合上训练。
- 然后学习器学得每个特征的权重，剔除当前权重一批特征，构成新的训练集。
- 再将学习器在新的训练集上训练，直到剩下的特征的数量满足条件。

>属性：

- n_features_：一个整数，给出了被选出的特征的数量。
- support_：一个数组，给出了特征是否被选择的mask 。
- ranking_：特征权重排名。原始第 i 个特征的排名为 raning_[i] 。
- estimator_： 外部提供的学习器 。

>方法：

- fit(X,y)：训练RFE模型
- transform(X)：执行特征选择。
- fit_transform(X,y)：从样本数据中学习RFE模型，然后执行特征选择。
- get_support([indices])：返回保留的特征。
  - 如果indices=True，则返回被选出的特征的索引。
  - 如果indices=False，则返回一个布尔值组成的数组，该数组指示哪些特征被选择。
- inverse_transform(X)：根据被选出来的特征还原原始数据（特征选取的逆操作），但是对于被删除的特征值全部用 0 代替。
- predict(X)/predict_log_proba(X) /predict_proba(X)：将X进行特征选择之后，在使用内部的estimator来预测。
- score(X, y) ：将X进行特征选择之后，训练内部estimator 并对内部的estimator进行评分。

### RFECV
>RFECV是RFE的一个变体，它执行一个交叉验证来寻找最优的剩余特征数量，因此不需要指定保留多少个特征。

>RFECV 的原型为：

```python
class sklearn.feature_selection.RFECV(estimator, step=1, cv=None, scoring=None,verbose=0)
```
- cv：一个整数，或者交叉验证生成器或者一个可迭代对象，它决定了交叉验证策略。
  - 如果为None，则使用默认的3折交叉验证。
  - 如果为整数  ，则使用  折交叉验证。
  - 如果为交叉验证生成器，则直接使用该对象。
  - 如果为可迭代对象，则使用该可迭代对象迭代生成训练-测试集合。
- 其它参数参考RFE 。

>属性：

- grid_scores_：一个数组，给出了交叉验证的预测性能得分。其元素为每个特征子集上执行交叉验证后的预测得分。
- 其它属性参考RFE 。

>方法：参考RFE 。

## 嵌入式特征选择
### SelectFromModel

>SelectFromModel用于实现嵌入式特征选取，其原型为：

```python
class sklearn.feature_selection.SelectFromModel(estimator, 
                                                threshold=None,
                                                prefit=False)
```

- estimator：一个学习器，它可以是未训练的(prefit=False)，或者是已经训练好的(prefit=True)。

estimator 必须有coef_或者feature_importances_属性，给出每个特征的重要性。当某个特征的重要性低于某个阈值时，该特征将被移除。

- threshold：一个字符串或者浮点数或者None，指定特征重要性的一个阈值。低于此阈值的特征将被剔除。
  - 如果为浮点数，则指定阈值的绝对大小。
  - 如果为字符串，可以是：
     - 'mean'：阈值为特征重要性的均值。
     - 'median'：阈值为特征重要性的中值。
     - 如果是'1.5*mean'，则表示阈值为 1.5 倍的特征重要性的均值。
  - 如果为None：
    - 如果estimator有一个penalty参数，且该参数设置为'l1'，则阈值默认为1e-5。
    - 其他情况下，阈值默认为'mean' 。
- prefit：一个布尔值，指定estimator是否已经训练好了。

如果prefit=False，则estimator是未训练的。

>属性：

- threshold_：一个浮点数，存储了用于特征选取重要性的阈值。

>方法：

- fit(X,y)：训练SelectFromModel模型。
- transform(X)：执行特征选择。
- fit_transform(X,y)：从样本数据中学习SelectFromModel模型，然后执行特征选择。
- get_support([indices])：返回保留的特征。
  - 如果indices=True，则返回被选出的特征的索引。
  - 如果indices=False，则返回一个布尔值组成的数组，该数组指示哪些特征被选择。
- inverse_transform(X)：根据被选出来的特征还原原始数据（特征选取的逆操作），但是对于被删除的特征值全部用 0 代替。
- partial_fit(X[, y])：通过部分数据来学习SelectFromModel模型。

它支持批量学习，这样对于内存更友好。即训练数据并不是一次性学习，而是分批学习。
