```python
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

from jupyterthemes import jtplot
jtplot.style()

%matplotlib inline

import warnings

warnings.filterwarnings('ignore')

plt.style.use('ggplot')
plt.rcParams['font.sans-serif'] = 'SimHei'
plt.rcParams['axes.unicode_minus'] = False
```



# preprocessing

1.  预处理的一些通用方法： 

- get_params([deep])：返回模型的参数。
  - deep： 如果为True，则可以返回模型参数的子对象。
- set_params(**params)：设置模型的参数。

  - params：待设置的关键字参数。
- fit(X[, y]) ：获取预处理需要的参数（如：特征的最大值、最小值等），不同的预处理方法需要的参数不同。
  - X ：训练集样本集合。通常是一个numpy array，每行代表一个样本，每列代表一个特征。
  - y ：训练样本的标签集合。它与X 的每一行相对应。
- transform(X[, copy])：执行预处理，返回处理后的样本集。
  - X ：训练集样本集合。通常是一个numpy array，每行代表一个样本，每列代表一个特征。
  - copy ：一个布尔值，指定是否拷贝数据。
- fit_transform(X[, y]) ：获取预处理需要的参数并执行预处理，返回处理后的样本集。
  - X ：训练集样本集合。通常是一个numpy array，每行代表一个样本，每列代表一个特征。
  - y ：训练样本的标签集合。它与X 的每一行相对应。

2.  预处理的一些通用参数：

- copy： 一个布尔值，指定是否拷贝数据。

　　如果为False则执行原地修改。此时节省空间，但修改了原始数据。

## 二元化

### Binarizer

> 二元化Binarizer 的原型为：

```python
class sklearn.preprocessing.Binarizer(threshold=0.0, copy=True)
```
- threshold：一个浮点数，它指定了转换阈值：低于此阈值的值转换为0，高于此阈值的值转换为 1。
- copy：一个布尔值，指定是否拷贝数据。

> 方法：

- fit(X[, y]) ：不作任何事情，主要用于为流水线Pipeline 提供接口。
- transform(X[, copy]) ：将每个样本的特征二元化。
- fit_transform(X[, y]) ：将每个样本的特征二元化。

```python
from sklearn.preprocessing import Binarizer
from sklearn.model_selection import train_test_split
from sklearn.datasets import load_iris

iris = load_iris()

x_train, x_test, y_train, y_test = train_test_split(iris.data,
                                                    iris.target,
                                                    test_size=0.3,
                                                    random_state=2020,
                                                    shuffle=True)

bi = Binarizer(threshold=2, copy=True)

x_train = bi.fit_transform(x_train)
x_test = bi.transform(x_test)

print(x_train[:3])
print(x_test[:3])
```



### label_binarize


```python
from sklearn.preprocessing import label_binarize
from sklearn.datasets import load_iris

iris = load_iris()
y = label_binarize(iris.target, classes=[0, 1, 2])
y
```




    array([[1, 0, 0],
           [1, 0, 0],
           [1, 0, 0],
    
           [0, 1, 0],
           [0, 1, 0],
           [0, 1, 0],
    
           [0, 0, 1],
           [0, 0, 1],
           [0, 0, 1]])



## 独热码

### OneHotEncoder

> 它只能对以整数值表示的类别型变量进行编码，若执意用OneHotEncoder对字符串变量值编码，则需要先使用LabelEncoder对字符串变量进行自然编码,以整数表示字符串值
>
> 独热码OneHotEncoder 的原型为：

```python
class sklearn.preprocessing.OneHotEncoder(n_values='auto', categorical_features='all',
dtype=<class 'float'>, sparse=True, handle_unknown='error')
```

- n_values：字符串'auto'，或者一个整数，或者一个整数的数组，它指定了样本每个特征取值的上界（特征的取值为从0开始的整数）：
  - 'auto'：自动从训练数据中推断特征值取值的上界。
  - 一个整数：指定了所有特征取值的上界。
  - 一个整数的数组：每个元素依次指定了每个特征取值的上界。
- categorical_features ：字符串'all'，或者下标的数组，或者是一个mask，指定哪些特征需要独热码编码 ：
  - 'all'：所有的特征都将独热码编码。
  - 一个下标的数组：指定下标的特征将独热码编码。
  - 一个mask：对应为True的特征将编码为独热码。
所有的非categorical 特征都将被安排在categorical 特征的右边。
- dtype：一个类型，指定了独热码编码的数值类型，默认为np.float 。
- sparse：一个布尔值，指定编码结果是否作为稀疏矩阵。
- handle_unknown：一个字符串，指定转换过程中遇到了未知的 categorical 特征时的异常处理策略。可以为：
  - 'error'：抛出异常。
  - 'ignore'：忽略。

> 属性：

- active_features_：一个索引数组，存放转换后的特征中哪些是由独热码编码而来。
仅当n_values='auto'时该属性有效。
- feature_indices_：一个索引数组，存放原始特征和转换后特征位置的映射关系。

第 i 个原始特征将被映射到转换后的[feature_indices_[i],feature_indices_[i+1]) 之间的特征。

- n_values_：一个计数数组，存放每个原始特征取值的种类。

一般为训练数据中该特征取值的最大值加1，这是因为默认每个特征取值从零开始。

> 方法：

- fit(X[, y]) ：训练编码器。
- transform(X) ：执行独热码编码。
- fit_transform(X[, y]) ：训练编码器，然后执行独热码编码。



```python
from sklearn.preprocessing import  OneHotEncoder

enc = OneHotEncoder()
enc.fit([[0, 0, 3],
         [1, 1, 0],
         [0, 2, 1],
         [1, 0, 2]])

# 如果不加 toarray() 的话，输出的是稀疏的存储格式，即索引加值的形式，也可以通过参数指定 sparse = False 来达到同样的效果
ans = enc.transform([[0, 1, 3]]).toarray()  
print(ans) 
# 输出 [[ 1.  0.  0.  1.  0.  0.  0.  0.  1.]]
```



## 标准化
### MinMaxScaler

>MinMaxScaler实现了min-max标准化，其原型为：

```python
class sklearn.preprocessing.MinMaxScaler(feature_range=(0, 1), copy=True)
```
- feature_range：一个元组(min,max)，指定了执行变换之后特征的取值范围。
- copy：一个布尔值，指定是否拷贝数据。

>属性：

- min_：一个数组，给出了每个特征的原始最小值的调整值。

　　设特征$j$的原始最小值为$j_{min}$，原始最大值为$j_{max}$。则特征$j$的原始最小值的调整值为：$
\frac{j_{\min }}{j_{\max }-j_{\min }}
$。
- scale_：一个数组，给出了每个特征的缩放倍数 。
- data_min_：一个数组，给出了每个特征的原始最小值 。
- data_max_：一个数组，给出了每个特征的原始最大值。
- data_range_：一个数组，给出了每个特征的原始的范围（最大值减最小值）。

>方法：

- fit(X[, y]) ：计算每个特征的最小值和最大值，从而为后续的转换做准备。
- transform(X) ：执行特征的标准化。
- fit_transform(X[, y]) ：计算每个特征的最大小值和最大值，然后执行特征的标准化。
- inverse_transform(X)：逆标准化，还原成原始数据。
- partial_fit(X[, y]) ：学习部分数据，计算每个特征的最小值和最大值，从而为后续的转换做准备。

　　它支持批量学习，这样对于内存更友好。即训练数据并不是一次性学习，而是分批学习。

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
iris_data = load_iris()

x_train, x_test, y_train, y_test = train_test_split(iris_data.data,
                                                    iris_data.target,
                                                    test_size=0.25,
                                                    random_state=33)

ss = MinMaxScaler()
x_train = ss.fit_transform(x_train)
x_test = ss.transform(x_test)

x_train, x_test
```



### MaxAbsScaler

>MaxAbsScaler 实现了max-abs 标准化，其原型为：

```python
class sklearn.preprocessing.MaxAbsScaler(copy=True)
```

- copy：一个布尔值，指定是否拷贝数据。

>属性：

- scale_：一个数组，给出了每个特征的缩放倍数的倒数。
- max_abs_：一个数组，给出了每个特征的绝对值的最大值。
- n_samples_seen_：一个整数，给出了当前已经处理的样本的数量（用于分批训练）。

>方法：参考MinMaxScaler 。

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MaxAbsScaler
iris_data = load_iris()

x_train, x_test, y_train, y_test = train_test_split(iris_data.data,
                                                    iris_data.target,
                                                    test_size=0.25,
                                                    random_state=33)

ss = MaxAbsScaler()
x_train = ss.fit_transform(x_train)
x_test = ss.transform(x_test)

x_train, x_test
```



### StandardScaler

>StandardScaler实现了 z-score标准化，其原型为：

```python
class sklearn.preprocessing.StandardScaler(copy=True, with_mean=True, with_std=True)
```

- copy：一个布尔值，指定是否拷贝数据。
- with_mean：一个布尔值，指定是否中心化。
  - 如果为True，则缩放之前先将每个特征中心化（即特征值减去该特征的均值）。
  - 如果元素数据是稀疏矩阵的形式，则不能指定with_mean=True 。
- with_std：一个布尔值，指定是否方差归一化。

　　如果为True，则缩放每个特征到单位方差。

>属性：

- scale_：一个数组，给出了每个特征的缩放倍数的倒数。
- mean_：一个数组，给出了原始数据每个特征的均值。
- var_：一个数组，给出了原始数据每个特征的方差。
- n_samples_seen_：一个整数，给出了当前已经处理的样本的数量（用于分批训练）。

>方法：参考MinMaxScaler 。

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
iris_data = load_iris()

x_train, x_test, y_train, y_test = train_test_split(iris_data.data,
                                                    iris_data.target,
                                                    test_size=0.25,
                                                    random_state=33)

ss = StandardScaler()
x_train = ss.fit_transform(x_train)
x_test = ss.transform(x_test)

x_train, x_test
```




    (array([[-0.91090798, -1.59775374, -0.15379535, -0.14784433],
            [-1.0271058 ,  0.08448757, -1.15396123, -1.2248242 ],
            [ 2.22643339, -0.1257926 ,  1.40201824,  1.60224795],
            [-0.44611666,  0.71532806, -1.04283168, -1.2248242 ]]),
     array([[ 1.06445511,  0.08448757,  0.45741713,  0.3906456 ],
            [-1.25950146,  0.29476773, -1.09839645, -1.2248242 ],
            [ 0.71586162,  0.29476773,  0.95750007,  1.60224795],
            [ 1.06445511,  0.08448757,  1.12419438,  1.73687043],
            [ 1.06445511, -0.1257926 ,  0.9019353 ,  1.60224795],
            [ 0.01867465, -0.75663309,  0.84637053,  1.06375802],
            [-0.09752318, -0.1257926 ,  0.34628759,  0.12140063]]))

## 正则化

### Normalizer

> Normalizer 实现了数据正则化，其原型为：

```python
class sklearn.preprocessing.Normalizer(norm='l2', copy=True)
```

- norm：一个字符串，指定正则化方法。可以为：

  - 'l1'：采用  范数正则化。
  - 'l2'：采用   范数正则化。
  - 'max'：采用  范数正则化。
- copy：一个布尔值，指定是否拷贝数据。

>方法：

- fit(X[, y]) ：不作任何事情，主要用于为流水线Pipeline 提供接口。
- transform(X[, y, copy]) ：将每一个样本正则化为范数等于单位1。
- fit_transform(X[, y]) ：将每一个样本正则化为范数等于单位1。

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import Normalizer
iris_data = load_iris()

x_train, x_test, y_train, y_test = train_test_split(iris_data.data,
                                                    iris_data.target,
                                                    test_size=0.25,
                                                    random_state=33)

ss = Normalizer()
x_train = ss.fit_transform(x_train)
x_test = ss.transform(x_test)

x_train, x_test
```

