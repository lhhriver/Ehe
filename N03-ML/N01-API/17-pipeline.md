
# pipeline

>scikit-learn 中的流水线的流程通常为：

- 通过一组特征处理estimator 来对特征进行处理（如标准化、正则化）。
- 通过一组特征提取estimator来提取特征。
- 通过一个模型预测 estimator 来学习模型，并执行预测。

　　除了最后一个 estimator 之外，前面的所有的 estimator 必须提供transform方法。该方法用于执行数据变换（如归一化、正则化、以及特征提取等）。

>Pipeline将多个estimator组成流水线，其原型为：

```python
class sklearn.pipeline.Pipeline(steps)
```

- steps：一个列表，列表的元素为(name,transform)元组。其中：
  - name是 estimator 的名字，用于输出和日志
  - transform是 estimator  。之所以叫transform是因为这个 estimator （除了最后一个）必须提供transform方法。

>属性：

- named_steps：一个字典。键就是steps中各元组的name元素，字典的值就是steps中各元组的transform元素。

>方法：

- fit(X[, y])：启动流水线，依次对各个estimator（除了最后一个）执行.fit方法和.transform方法转换数据；对最后一个estimator执行.fit方法训练学习器。
- transform(X)：启动流水线，依次对各个estimator （包括最后一个）执行.fit方法和.transform方法转换数据。
- fit_transform(X[, y])：启动流水线，依次对各个estimator（除了最后一个）执行.fit方法和.transform方法转换数据；对最后一个estimator执行.fit_transform方法转换数据。
- inverse_transform(X)：将转换后的数据逆转换成原始数据。

要求每个estimator都实现了.inverse_transform方法。
- predict(X)/predict_log_proba(X) /predict_proba(X)：将X进行数据转换后，用最后一个学习器来预测。
- score(X, y) ：将X进行数据转换后，训练最后一个estimator ，并对最后一个estimator 评分。

参见随机森林


```python
from sklearn.model_selection import GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.datasets import fetch_20newsgroups
import numpy as np

news = fetch_20newsgroups(subset='all')
X_train, X_test, y_train, y_test = train_test_split(
    news.data[:3000], news.target[:3000], test_size=0.25, random_state=33)

tfidf_filter_vec = TfidfVectorizer(stop_words='english', analyzer='word')
model_svc = SVC()
# 使用Pipeline 简化系统搭建流程，将文本抽取与分类器模型串联起来
clf = Pipeline([('vect', tfidf_filter_vec), ('svc', model_svc)])

# 这里需要试验的2个超参数的的个数分别是4、3， svc__gamma的参数共有10^-2, 10^-1... 。这样我们一共有12种的超参数组合，12个不同参数下的模型。
parameters = {'svc__gamma': np.logspace(-2, 1, 4),
              'svc__C': np.logspace(-1, 1, 3)}

# 初始化配置并行网格搜索，n_jobs=-1代表使用该计算机全部的CPU
gs = GridSearchCV(clf, parameters, verbose=2, refit=True, cv=3, n_jobs=-1)
gs.fit(x_train, y_train)
# 执行多线程并行网格搜索
# get_ipython().magic('time _= gs.fit(X_train, y_train)')
gs.best_params_
gs.best_score_

# 输出最佳模型在测试集上的准确性
print(gs.score(X_test, y_test))
```


    ---------------------------------------------------------------------------
    ValueError: Found input variables with inconsistent numbers of samples: [112, 2250]

