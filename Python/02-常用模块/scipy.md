
# 正态性检验
检验数据样本是否具有高斯分布。


```python
from scipy.stats import shapiro

data = [21, 12, 12, 23, 19, 13, 20, 17, 14, 19]
stat, p = shapiro(data)

print(("stat为：%f" % stat, "p值为：%f" % p))
```

    ('stat为：0.913007', 'p值为：0.302289')


# 皮尔逊相关性检验
检查两个样本是否相关的统计检验


```python
from scipy.stats import pearsonr

data1 = [21, 12, 12, 23, 19, 13, 20, 17, 14, 19]
data2 = [12, 11, 8, 9, 10, 15, 16, 17, 10, 16]
corr, p = pearsonr(data1, data2)
print(("corr为：%f" % corr, "p值为：%f" % p))
```

    ('corr为：0.142814', 'p值为：0.693889')


# 卡方检验
检验两个分类变量的独立性


```python
from scipy.stats import chi2_contingency

data1 = [21, 12, 12, 23, 19, 13, 20, 17, 14, 19]
data2 = [12, 11, 8, 9, 10, 15, 16, 17, 10, 16]
stat, p, dof, expected = chi2_contingency(data1, data2)
print(("stat为：%f" % stat, "p值为：%f" % p))
```

    ('stat为：0.000000', 'p值为：1.000000')


# T检验
检验两个独立样本的均值是否存在显著差异


```python
from scipy.stats import ttest_ind

data1 = [21, 12, 12, 23, 19, 13, 20, 17, 14, 19]
data2 = [12, 11, 8, 9, 10, 15, 16, 17, 10, 16]
stat, p = ttest_ind(data1, data2)
print(("stat为：%f" % stat, "p值为：%f" % p))
```

    ('stat为：2.802933', 'p值为：0.011763')


# 配对T检验
检验两个配对样本的均值是否有显著差异


```python
from scipy.stats import ttest_rel

data1 = [21, 12, 12, 23, 19, 13, 20, 17, 14, 19]
data2 = [12, 11, 8, 9, 10, 15, 16, 17, 10, 16]
stat, p = ttest_rel(data1, data2)
print(("stat为：%f" % stat, "p值为：%f" % p))
```

    ('stat为：3.022945', 'p值为：0.014410')


# 方差分析
测试两个或两个以上独立样本的均值是否存在显著差异


```python
from scipy.stats import f_oneway

data1 = [21, 12, 12, 23, 19, 13, 20, 17, 14, 19]
data2 = [12, 11, 8, 9, 10, 15, 16, 17, 10, 16]
stat, p = f_oneway(data1, data2)
print(("stat为：%f" % stat, "p值为：%f" % p))
```

    ('stat为：7.856436', 'p值为：0.011763')


# Mann-Whitney U检验
检验两个独立样本的分布是否相等. 对应参数检验里面的t检验.


```python
from scipy.stats import mannwhitneyu

data1 = [21, 12, 12, 23, 19, 13, 20, 17, 14, 19]
data2 = [12, 11, 8, 9, 10, 15, 16, 17, 10, 16]
stat, p = mannwhitneyu(data1, data2)
print(("stat为：%f" % stat, "p值为：%f" % p))
```

    ('stat为：17.500000', 'p值为：0.007627')


# Wilcoxon符号秩检验
检验两个配对样本的分布是否均等. 对应参数检验里面的配对t检验.


```python
from scipy.stats import wilcoxon

data1 = [21, 12, 12, 23, 19, 13, 20, 17, 14, 19]
data2 = [12, 11, 8, 9, 10, 15, 16, 17, 10, 16]
stat, p = wilcoxon(data1, data2)
print(("stat为：%f" % stat, "p值为：%f" % p))
```

    ('stat为：2.000000', 'p值为：0.014714')


# Kruskal-wallis H检验. 
检验两个或多个独立样本的分布是否相等. 对应参数检验里面的方差分析.


```python
from scipy.stats import kruskal

data1 = [21, 12, 12, 23, 19, 13, 20, 17, 14, 19]
data2 = [12, 11, 8, 9, 10, 15, 16, 17, 10, 16]
stat, p = kruskal(data1, data2)
print(("stat为：%f" % stat, "p值为：%f" % p))
```

    ('stat为：6.072239', 'p值为：0.013732')

