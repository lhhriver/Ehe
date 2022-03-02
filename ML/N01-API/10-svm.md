

# SVM

1. SVM 的通用参数：

- tol：浮点数，指定终止迭代的阈值。
- fit_intercept：一个布尔值，指定是否需要计算截距项。如果为False，那么不会计算截距项。

当$\overrightarrow{\hat{\mathbf{w}}}=\left(w^{(1)}, w^{(2)}, \cdots, w^{(n)}, b\right)^{T}=\left(\overrightarrow{\mathbf{w}}^{T}, b\right)^{T}, \overrightarrow{\tilde{\mathbf{x}}}=\left(x^{(1)}, x^{(2)}, \cdots, x^{(n)}, 1\right)^{T}=\left(\overrightarrow{\mathbf{x}}^{T}, 1\right)^{T}$, 时， 可以设置 fit_intercept=False 。
- intercept_scaling：一个浮点数，用于缩放截距项的正则化项的影响。

当采用fit_intercept 时，相当于人造一个特征出来，该特征恒为 1 ，其权重为  。

在计算正则化项的时候，该人造特征也被考虑了。为了降低这个人造特征的影响，需要提供intercept_scaling。
- class_weight：一个字典或者字符串'balanced' ，指定每个类别的权重。
  - 如果为字典：则字典给出了每个分类的权重。如{class_label: weight} 。
  - 如果为字符串'balanced'：则每个分类的权重与该分类在样本集中出现的频率成反比。
  - 如果未指定，则每个分类的权重都为 1 。

## LinearSVC

1.LinearSVC是根据liblinear实现的，它可以用于二类分类，也可以用于多类分类问题（此时是根据one-vs-rest原则来分类）。

2.线性支持向量机 LinearSVC：

```python
sklearn.svm.LinearSVC(penalty='l2', loss='squared_hinge', dual=True, tol=0.0001, C=1.0,
multi_class='ovr', fit_intercept=True, intercept_scaling=1, class_weight=None, 
verbose=0, random_state=None, max_iter=1000)
```

- penalty：字符串，指定 'l1'或者'l2'，罚项的范数。默认为 'l2'（它是标准SVC采用的）。

- loss：一个字符串，表示损失函数。可以为：
  - 'hinge'：此时为合页损失函数（它是标准 SVM 的损失函数）。
  - 'squared_hinge'：合页损失函数的平方。
- dual：一个布尔值。如果为True，则解决对偶问题；如果是False,则解决原始问题。当n_samples > n_features时，倾向于采用False。
- tol ：一个浮点数，指定终止迭代的阈值。
- C：一个浮点数，罚项系数。
- multi_class ：一个字符串，指定多类分类问题的策略。
  - 'ovr'：采用one-vs-rest分类策略。
  - 'crammer_singer'：多类联合分类，很少用。因为它计算量大，而且精度不会更佳。此时忽略loss,penalty,dual项。
- fit_intercept ：一个布尔值，指定是否需要计算截距项。
- intercept_scaling：一个浮点数，用于缩放截距项的正则化项的影响。
- class_weight： 一个字典或者字符串'balanced' ，指定每个类别的权重。
- verbose：一个正数。用于开启/关闭迭代中间输出日志功能。
- random_state： 指定随机数种子。
- max_iter： 一个整数，指定最大迭代次数。

3.模型属性：

- coef_：权重向量。
- intercept_：截距值。


4.模型方法：

- fit(X, y)：训练模型。
- predict(X)：用模型进行预测，返回预测值。
- score(X,y[,sample_weight])：返回模型的预测性能得分。

5.下面的示例给出了不同的 C 值对模型预测能力的影响。

C衡量了误分类点的重要性，C越大则误分类点越重要。

为了便于观察将x轴以对数表示。可以看到当C较小时，误分类点重要性较低，此时误分类点较多，分类器性能较差。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N01-API-20201215-223656-704269.png)

```python
from sklearn.svm import LinearSVC

model = LinearSVC()
model.get_params()
```




    {'C': 1.0,
     'class_weight': None,
     'dual': True,
     'fit_intercept': True,
     'intercept_scaling': 1,
     'loss': 'squared_hinge',
     'max_iter': 1000,
     'multi_class': 'ovr',
     'penalty': 'l2',
     'random_state': None,
     'tol': 0.0001,
     'verbose': 0}



**参数详解**

参数|默认值|值域|说明
---|---|---|---
C|1.0|---|惩罚系数，用来控制损失函数的惩罚系数，类似于LR中的正则化系数
class_weight|None|---|与其他模型中参数含义一样，也是用来处理不平衡样本数据的，可以直接以字典的形式指定不同类别的权重，也可以使用balanced参数值
dual|True|---|是否转化为对偶问题求解，默认是True
fit_intercept|True|---|是否计算截距，与LR模型中的意思一致
intercept_scaling|1||
loss|squared_hinge|---|损失函数，有‘hinge’和‘squared_hinge’两种可选，前者又称L1损失，后者称为L2损失，默认是是’squared_hinge’，其中hinge是SVM的标准损失，squared_hinge是hinge的平方。
max_iter|1000|---|最大迭代次数，默认是1000
multi_class|ovr|---|负责多分类问题中分类策略制定，有‘ovr’和‘crammer_singer’ 两种参数值可选，默认值是’ovr’，'ovr'的分类原则是将待分类中的某一类当作正类，其他全部归为负类，通过这样求取得到每个类别作为正类时的正确率，取正确率最高的那个类别为正类；‘crammer_singer’ 是直接针对目标函数设置多个参数值，最后进行优化，得到不同类别的参数值大小
penalty|l2|---|正则化参数，L1和L2两种参数可选，仅LinearSVC有
random_state|None|---|随机种子的大小
tol|0.0001|---|残差收敛条件，默认是0.0001，与LR中的一致
verbose|0|---|是否冗余，默认是False.

**对象**

        coef_:各特征的系数（重要性）。
        intercept_:截距的大小（常数值）。


```python
from sklearn.datasets import load_digits
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.svm import LinearSVC
from sklearn.metrics import classification_report

digits = load_digits()
x_train, x_test, y_train, y_test = train_test_split(digits.data,
                                                    digits.target,
                                                    test_size=0.25,
                                                    random_state=33)

ss = StandardScaler()
x_train = ss.fit_transform(x_train)
x_test = ss.transform(x_test)

lsvc = LinearSVC()
lsvc.fit(x_train, y_train)
y_pred = lsvc.predict(x_test)

print('>>>The Accuracy of Linear SVC is\n', lsvc.score(x_test, y_test))
cp = classification_report(
    y_test, y_pred, target_names=digits.target_names.astype(str))
print(cp)

"""
支持向量机精妙的模型假设，可以再海量甚至高维度的数据中筛选对预测任务最为有效的少数训练样本，
这样不仅节省了模型学习所需要的数据内存，同时也提高了模型的预测性能，
但付出了更多的计算代价（CPU资源和计算时间）
"""
```

    >>>The Accuracy of Linear SVC is
     0.9533333333333334
                  precision    recall  f1-score   support
    
               0       0.92      1.00      0.96        35
               1       0.96      0.98      0.97        54
               2       0.98      1.00      0.99        44
               3       0.93      0.93      0.93        46
               4       0.97      1.00      0.99        35
               5       0.94      0.94      0.94        48
               6       0.96      0.98      0.97        51
               7       0.92      1.00      0.96        35
               8       0.98      0.84      0.91        58
               9       0.95      0.91      0.93        44
    
       micro avg       0.95      0.95      0.95       450
       macro avg       0.95      0.96      0.95       450
    weighted avg       0.95      0.95      0.95       450


​    




    '支持向量机精妙的模型假设，可以再海量甚至高维度的数据中筛选对预测任务最为有效的少数训练样本，这样不仅节省了模型学习所需要的数据内存，同时也提高了模型的预测性能，但付出了更多的计算代价（CPU资源和计算时间）'



## NuSVC

1. NuSVC: Nu-Support Vector Classificatio 与 SVC相似，但是用一个参数来控制了支持向量的个数。它是基于libsvm来实现的。
2. NuSVC 支持向量机：

```python
sklearn.svm.NuSVC(nu=0.5, kernel='rbf', degree=3, gamma='auto', coef0=0.0,
shrinking=True,probability=False, tol=0.001, cache_size=200, class_weight=None,
verbose=False,max_iter=-1, decision_function_shape=None, random_state=None)
```
- nu : 一个浮点数，取值范围为 (0,1]， 默认为0.5。它控制训练误差与支持向量的比值，间接控制了支持向量的个数。
- 其它参数参考SVC。
3. 模型属性：参考SVC。
4. 模型方法：参考SVC。

```python
from sklearn.svm import NuSVC

model = NuSVC()
model.get_params()
```




    {'cache_size': 200,
     'class_weight': None,
     'coef0': 0.0,
     'decision_function_shape': 'ovr',
     'degree': 3,
     'gamma': 'auto_deprecated',
     'kernel': 'rbf',
     'max_iter': -1,
     'nu': 0.5,
     'probability': False,
     'random_state': None,
     'shrinking': True,
     'tol': 0.001,
     'verbose': False}



<font color=bleu size=5>参数详解

参数|默认值|值域|说明
---|---|---|---
cache_size|200|---|缓冲大小，用来限制计算量大小，默认是200M
class_weight|None
coef0|0.0|---|核函数常数值(y=kx+b中的b值)，只有‘poly’和‘sigmoid’核函数有，默认值是0
decision_function_shape|ovr|---|与'multi_class'参数含义类似
degree|3|---|当核函数是多项式核函数的时候，用来控制函数的最高次数。（多项式核函数是将低维的输入空间映射到高维的特征空间）
gamma|auto_deprecated|---|核函数系数，默认是“auto”，即特征维度的倒数
kernel|rbf|---|核函数，核函数是用来将非线性问题转化为线性问题的一种方法，默认是“rbf”核函数.linear线性核函数、poly多项式核函数、、rbf高斯核函数、sigmod sigmod核函数、precomputed自定义核函数
max_iter|-1|---|最大迭代次数，默认值是-1，即没有限制
nu|0.5|---|训练误差部分的上限和支持向量部分的下限，取值在（0，1）之间，默认是0.5
probability|False|---|是否使用概率估计，默认是False
random_state|None
shrinking|True
tol|0.001
verbose|False

**对象**

        support_:以数组的形式返回支持向量的索引。
        support_vectors_:返回支持向量。
        n_support_:每个类别支持向量的个数。
        dual_coef_:支持向量系数。
        coef_:每个特征系数（重要性），只有核函数是LinearSVC的时候可用。
        intercept_:截距值（常数值）。

## SVC

1. SVC是根据libsvm实现的，其训练的时间复杂度是采样点数量的平方。
它可以用于二类分类，也可以用于多类分类问题（此时默认是根据one-vs-rest原则来分类）。
2. 支持向量机 SVC：

```python
sklearn.svm.SVC(
    C=1.0, 
    kernel='rbf', 
    degree=3, 
    gamma='auto', 
    coef0=0.0, 
    shrinking=True,
    probability=False, 
    tol=0.001, 
    cache_size=200, 
    class_weight=None, 
    verbose=False,
    max_iter=-1, 
    decision_function_shape=None, 
    random_state=None)
```

- C：一个浮点数，罚项系数。
- kernel：一个字符串，指定核函数。
  - 'linear'：线性核：$K(\overrightarrow{\mathbf{x}}, \overrightarrow{\mathbf{z}})=\overrightarrow{\mathbf{x}} \cdot \overrightarrow{\mathbf{z}}$。
  - 'poly'：多项式核：$K(\overrightarrow{\mathbf{x}}, \overrightarrow{\mathbf{z}})=(\gamma(\overrightarrow{\mathbf{x}} \cdot \overrightarrow{\mathbf{z}}+1)+r)^{p}$。其中：
    - $p$由 degree参数决定。
    - $\gamma$由 gamma参数决定。
    - $r$由 coef0参数决定。
  - 'rbf'（默认值）：高斯核函数： 。

其中$\gamma$由 gamma参数决定。
  - 'sigmoid'：$K(\overrightarrow{\mathbf{x}}, \overrightarrow{\mathbf{z}})=\tanh (\gamma(\overrightarrow{\mathbf{x}} \cdot \overrightarrow{\mathbf{z}})+r)$。其中：
    - 由 gamma参数决定。
    - r由 coef0参数指定。
  - 'precomputed'：表示提供了kernel matrix 。
  - 或者提供一个可调用对象，该对象用于计算kernel matrix 。
- degree：一个整数。指定当核函数是多项式核函数时，多项式的系数。对于其他核函数，该参数无效。
- gamma：一个浮点数。当核函数是'rbf'，'poly'，'sigmoid'时，核函数的系数。如果'auto'，则表示系数为1/n_features 。
- coef0：浮点数，用于指定核函数中的自由项。只有当核函数是'poly'和'sigmoid'是有效。
- probability：布尔值。如果为True则会进行概率估计。它必须在训练之前设置好，且概率估计会拖慢训练速度。
- shrinking：布尔值。如果为True，则使用启发式(shrinking heuristic) 。
- tol：浮点数，指定终止迭代的阈值。
- cache_size：浮点值，指定了kernel cache的大小，单位为 MB 。
- class_weight：指定各类别的权重。
- decision_function_shape：为字符串或者None，指定决策函数的形状。
  - 'ovr'：则使用one-vs-rest准则。那么决策函数形状是(n_samples,n_classes)。

此时对每个分类定义了一个二类SVM，一共 n_classes个二类 SVM 。
  - 'ovo'：则使用one-vs-one准测。那么决策函数形状是(n_samples, n_classes * (n_classes - 1) / 2)

此时对每一对分类直接定义了一个二类SVM，一共 n_classes * (n_classes - 1) / 2)个二类SVM 。
  - None：默认值。采用该值时，目前会使用'ovo'，但是在 scikit v0.18之后切换成'ovr' 。
- 其它参数参考LinearSVC 。
3. 模型属性：

- support_ :一个数组, 形状为 [n_SV]，给出了支持向量的下标。
- support_vectors_ : 一个数组, 形状为 [n_SV, n_features]，给出了支持向量。
- n_support_ : 一个数组, 形状为 [n_class]，给出了每一个分类的支持向量的个数。
- dual_coef_ : 一个数组，形状为[n_class-1, n_SV]。给出了对偶问题中，每个支持向量的系数。
- coef_ : 一个数组，形状为[n_class-1, n_features]。给出了原始问题中，每个特征的系数。
  - 它只有在linear kernel中有效。
  - 它是个只读的属性。它是从dual_coef_ 和support_vectors_计算而来。
- intercept_ : 一个数组，形状为[n_class * (n_class-1) / 2]，给出了决策函数中的常数项。

4. 模型方法：

- fit(X, y[, sample_weight])：训练模型。
- predict(X)：用模型进行预测，返回预测值。
- score(X,y[,sample_weight])：返回模型的预测性能得分。
- predict_log_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率的对数值。
- predict_proba(X)：返回一个数组，数组的元素依次是X预测为各个类别的概率值 。

```python
from sklearn.svm import SVC

model = SVC()
model.get_params()
```




    {'C': 1.0,
     'cache_size': 200,
     'class_weight': None,
     'coef0': 0.0,
     'decision_function_shape': 'ovr',
     'degree': 3,
     'gamma': 'auto_deprecated',
     'kernel': 'rbf',
     'max_iter': -1,
     'probability': False,
     'random_state': None,
     'shrinking': True,
     'tol': 0.001,
     'verbose': False}



<font color=bleu size=5>参数详解

参数|默认值|值域|说明
---|---|---|---
C|1.0|---|惩罚系数
cache_size|200|---|
class_weight|None|---|
coef0|0.0|---|
decision_function_shape|ovr|---|
degree|3|---|
gamma|auto_deprecated|---|
kernel|rbf|---|
max_iter|-1|---|
probability|False|---|
random_state|None|---|
shrinking|True|---|
tol|0.001|---|
verbose|False|---|

**方法**

三种分类方法的方法基本一致，所以就一起来说啦。

    decision_function(X):获取数据集X到分离超平面的距离。
    fit(X, y):在数据集(X,y)上使用SVM模型。
    get_params([deep]):获取模型的参数。
    predict(X):预测数据值X的标签。
    score(X,y):返回给定测试集和对应标签的平均准确率。

## SVR

1. SVR是根据libsvm实现的。
2. 支持向量回归 SVR：

```python
class sklearn.svm.SVR(kernel='rbf', 
                      degree=3, 
                      gamma='auto', 
                      coef0=0.0, 
                      tol=0.001, 
                      C=1.0,
                      epsilon=0.1, 
                      shrinking=True, 
                      cache_size=200, 
                      verbose=False, 
                      max_iter=-1)
```
参数：参考SVC 。
3. 模型属性：参考SVC 。
4. 模型方法：参考SVC 。

```python
from sklearn.svm import SVR

model = SVR()
model.get_params()
```




    {'C': 1.0,
     'cache_size': 200,
     'coef0': 0.0,
     'degree': 3,
     'epsilon': 0.1,
     'gamma': 'auto_deprecated',
     'kernel': 'rbf',
     'max_iter': -1,
     'shrinking': True,
     'tol': 0.001,
     'verbose': False}



`参数详解`

参数|默认值|值域|说明
---|---|---|---
C|1.0
cache_size|200
coef0|0.0
degree|3
epsilon|0.1
gamma|auto_deprecated
kernel|rbf
max_iter|-1
shrinking|True
tol|0.001
verbose|False


```python
from sklearn.datasets import load_boston
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVR
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

linear_svr = SVR(kernel='linear')
linear_svr.fit(x_train, y_train)
linear_svr_y_predict = linear_svr.predict(x_test)
print('R-squared value of linear SVR is', linear_svr.score(x_test, y_test))
print(
    'The mean squared error of linear SVR is',
    mean_squared_error(ss_y.inverse_transform(y_test),
                       ss_y.inverse_transform(linear_svr_y_predict)))
print(
    'The mean absoluate error of linear SVR is',
    mean_absolute_error(ss_y.inverse_transform(y_test),
                        ss_y.inverse_transform(linear_svr_y_predict)))
```

    R-squared value of linear SVR is 0.650659546421538
    The mean squared error of linear SVR is 27.088311013556027
    The mean absoluate error of linear SVR is 3.4328013877599624



```python
# 使用多项式核函数配置的支持向量机进行回归训练，并且对测试样本进行预测。
poly_svr = SVR(kernel='poly')
poly_svr.fit(x_train, y_train)
poly_svr_y_predict = poly_svr.predict(x_test)

print('R-squared value of Poly SVR is', poly_svr.score(x_test, y_test))
print(
    'The mean squared error of Poly SVR is',
    mean_squared_error(ss_y.inverse_transform(y_test),
                       ss_y.inverse_transform(poly_svr_y_predict)))
print(
    'The mean absoluate error of Poly SVR is',
    mean_absolute_error(ss_y.inverse_transform(y_test),
                        ss_y.inverse_transform(poly_svr_y_predict)))
```

    R-squared value of Poly SVR is 0.40365065102550846
    The mean squared error of Poly SVR is 46.24170053103929
    The mean absoluate error of Poly SVR is 3.73840737104651



```python
# 使用径向基核函数配置的支持向量机进行回归训练，并且对测试样本进行预测。
rbf_svr = SVR(kernel='rbf')
rbf_svr.fit(x_train, y_train)
rbf_svr_y_predict = rbf_svr.predict(x_test)

print('R-squared value of RBF SVR is', rbf_svr.score(x_test, y_test))
print(
    'The mean squared error of RBF SVR is',
    mean_squared_error(ss_y.inverse_transform(y_test),
                       ss_y.inverse_transform(rbf_svr_y_predict)))
print(
    'The mean absoluate error of RBF SVR is',
    mean_absolute_error(ss_y.inverse_transform(y_test),
                        ss_y.inverse_transform(rbf_svr_y_predict)))
```

    R-squared value of RBF SVR is 0.7559887416340944
    The mean squared error of RBF SVR is 18.92094886153873
    The mean absoluate error of RBF SVR is 2.6067819999501114

## LinearSVR

1. LinearSVR是根据liblinear实现的。

2. 线性支持向量回归 LinearSVR：

```python
class sklearn.svm.LinearSVR(epsilon=0.0, 
                            tol=0.0001, 
                            C=1.0, 
                            loss='epsilon_insensitive',
                            fit_intercept=True, 
                            intercept_scaling=1.0, 
                            dual=True, 
                            verbose=0, 
                            random_state=None,
                            max_iter=1000)
```

- epsilon：一个浮点数，表示$\epsilon$值。
- loss：字符串。表示损失函数。可以为：
  - 'epsilon_insensitive'：此时损失函数为$L_{\epsilon}$  （标准的SVR）
  - 'squared_epsilon_insensitive'：此时损失函数为$L_{\epsilon}^{2}$  
- 其它参数参考LinearSVC 。
3.模型属性：参考LinearSVC 。
4.模型方法：参考LinearSVC 。
5.下面的示例给出了不同的$\epsilon$值对模型预测能力的影响。

为了方便观看将x轴转换成对数坐标。可以看到预测准确率随着$\epsilon$下降。
![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N01-API-20201215-223656-731639.png)
6. 下面的示例给出了不同的 C 值对模型预测能力的影响。

为了方便观看将x轴转换成对数坐标。可以看到预测准确率随着$C$增大而上升。说明越看重误分类点，则预测的越准确。
![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N01-API-20201215-223656-717299.png)

## NuSVR

1.NuSVR是根据libsvm实现的。
2.支持向量回归 NuSVR：
```python
class sklearn.svm.NuSVR(nu=0.5, 
                        C=1.0, 
                        kernel='rbf', 
                        degree=3, 
                        gamma='auto', 
                        coef0=0.0,
                        shrinking=True, 
                        tol=0.001, 
                        cache_size=200, 
                        verbose=False, 
                        max_iter=-1)
```
- C：一个浮点数，罚项系数。
- 其它参数参考NuSVC。
3.模型属性：参考NuSVC。
4.模型方法：参考NuSVC。

## OneClassSVM

1. OneClassSVM是根据libsvm实现的。
2. 支持向量描述 OneClassSVM：

```python
class sklearn.svm.OneClassSVM(
    kernel='rbf', 
    degree=3, 
    gamma='auto', 
    coef0=0.0, 
    tol=0.001,
    nu=0.5, 
    shrinking=True, 
    cache_size=200, 
    verbose=False, 
    max_iter=-1, 
    random_state=None)
```
参数：参考NuSVC。
3. 模型属性：参考NuSVC。
4. 模型方法：

- fit(X[, y, sample_weight])：训练模型。
- predict(X)：用模型进行预测，返回预测值。每个预测值要么是 +1 要么是 -1 。
