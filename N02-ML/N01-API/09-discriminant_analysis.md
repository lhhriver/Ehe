
# discriminant_analysis

## discriminant_analysis

1.类LinearDiscriminantAnalysis实现了线性判别分析模型。其原型为：
```python
class sklearn.discriminant_analysis.LinearDiscriminantAnalysis(
    solver='svd', 
    shrinkage=None, 
    priors=None, 
    n_components=None, 
    store_covariance=False, 
    tol=0.0001)
```

- solver：一个字符串，指定求解最优化问题的算法。可以为：
  - 'svd'：奇异值分解。对于有大规模特征的数据，推荐用这种算法。
  - 'lsqr'：最小平方差算法，可以结合shrinkage参数。
  - 'eigen'：特征值分解算法，可以结合shrinkage参数。
- shrinkage：字符串'auto'或者浮点数或者None。
该参数只有在solver='lsqr'或者'eigen'下才有意义。当矩阵求逆时，它会在对角线上增加一个小的数 ，防止矩阵为奇异的。其作用相当于正则化。
  - 字符串'auto'：根据Ledoit-Wolf引理来自动决定  的大小。
  - None：不使用shrinkage参数。
  - 一个0 到 1 之间的浮点数：指定$\lambda$的值。
- priors：一个数组，数组中的元素依次指定了每个类别的先验概率。
如果为None则认为每个类的先验概率都是等可能的。
- n_components：一个整数，指定了数据降维后的维度（该值必须小于 n_classes-1） 。
- store_covariance：一个布尔值。如果为True,则需要额外计算每个类别的协方差矩阵$\Sigma_{i}$。
- tol：一个浮点值。它指定了用于SVD算法中评判迭代收敛的阈值。

2.模型属性：

- coef_：权重向量。
- intercept_： 值。
- covariance_：一个数组，依次给出了每个类别的协方差矩阵。
- means_：一个数组，依次给出了每个类别的均值向量。
- xbar_：给出了整体样本的均值向量。
- n_iter_：实际迭代次数。

3.模型方法： 参考LogisticRegression 。
