
# MDS

1. MDS是scikit-learn实现的多维缩放模型，其原型为：
```python
sklearn.manifold.MDS(
	n_components=2, 
	metric=True, 
	n_init=4, 
	max_iter=300,
	verbose=0, 
	eps=0.001, 
	n_jobs=1, 
	random_state=None, 
	dissimilarity='euclidean')
```

- metric：一个布尔值，指定度量类型。

如果为True，则使用距离度量；否则使用非距离度量SMACOF 。
- n_components：一个整数，指定降维后的维数。
- n_init：一个整数，指定初始化的次数。

在使用SMACOF算法时，会选择n_init次不同的初始值，然后选择这些结果中最好的那个作为最终结果。
- max_iter：一个整数，指定在使用SMACOF算法时得到一轮结果需要的最大迭代次数。
- eps：一个浮点数，用于指定收敛阈值。
- n_jobs：一个整数，指定并行性。
- random_state：一个整数或者一个RandomState实例，或者None，指定随机数种子。
- dissimilarity：一个字符串值，用于定义如何计算不相似度。可以为：
  - 'euclidean'：使用欧氏距离。
  - 'precomputed'：由使用者提供距离矩阵。

2. 属性：
- embedding_：给出了原始数据集在低维空间中的嵌入矩阵。
- stress_：一个浮点数，给出了不一致的距离的总和。

3. 方法：
- fit(X[, y, init])：训练模型。
- fit_transform(X[, y, init])：训练模型并执行降维，返回降维后的样本集。
4. 示例：鸢尾花数据集分别降低到4、3、2、1 维时，距离的误差之和分别为：

			stress(n_components=4) : 12.0577408711
			stress(n_components=3) : 17.8262808779
			stress(n_components=2) : 234.395807108
			stress(n_components=1) : 23691.9560412
该指标并不能用于判定降维的效果的好坏，它只是一个中性指标。

降到2维的样本分布图：
![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N01-API-20201215-223656-793118.png)

# Isomap

1. Isomap类是scikit-learn提供的Isomap模型，其原型为：

```python
sklearn.manifold.Isomap(
n_neighbors=5, 
n_components=2, 
eigen_solver='auto',
tol=0, 
max_iter=None, 
path_method='auto', 
neighbors_algorithm='auto')
```

- n_neighbors：一个整数，指定近邻参数  。
- n_components：一个整数，指定降维后的维数。
- eigen_solver：一个字符串，指定求解特征值的算法，可以为：
  - 'auto'：由算法自动选取。
  - 'arpack'：使用 Arnoldi分解算法。
  - 'dense'：使用一个直接求解特征值的算法（如LAPACK）。
- tol：一个浮点数，指定求解特征值算法的收敛阈值（当eigen_solver='dense'时，该参数无用）。
- max_iter：一个浮点数，指定求解特征值算法的最大迭代次数（当eigen_solver='dense'时，该参数无用）。
- path_method：一个字符串，指定寻找最短路径算法。可以为：
  - 'auto'：由算法自动选取。
  - 'FW'：使用Floyd_Warshall算法。
  - 'D'：使用Dijkstra算法。
- neighbors_algorithm：一字符串，指定计算最近邻的算法。可以为：
  - 'ball_tree'：使用 BallTree算法。
  - 'kd_tree：使用 KDTree算法。
  - 'brute'：使用暴力搜索法。
  - 'auto'：自动决定最合适的算法。

2. 属性：

- embedding_：给出了原始数据集在低维空间中的嵌入矩阵。
- training_data_：存储了原始训练数据。
- dist_matrix_：存储了原始训练数据的距离矩阵。

3. 方法：

- fit(X[, y])：训练模型。
- transform(X)：执行降维，返回降维后的样本集。
- fit_transform(X[, y])：训练模型并执行降维，返回降维后的样本集。
- reconstruction_error()：计算重构误差。

4. 示例：鸢尾花数据集分别降低到4、3、2、1 维时，重构误差分别为：

			reconstruction_error(n_components=4) : 1.00971800681
			reconstruction_error(n_components=3) : 1.01828451463
			reconstruction_error(n_components=2) : 1.02769837643
			reconstruction_error(n_components=1) : 1.07166427632
该指标并不能用于判定降维的效果的好坏，它只是一个中性指标。

不同的k 降维到2维后的样本的分布图如下所示。可以看到 k=1 时，近邻范围过小，此时发生断路现象。本应该相连的区域限制被认定为不相连。
![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N01-API-20201215-223656-624432.png)

不同的k 降维到1维后的样本的分布图如下所示。
![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N01-API-20201215-223656-640398.png)


## LocallyLinearEmbedding

1. LocallyLinearEmbedding是 scikit-learn提供的LLE模型，其原型为：

```python
sklearn.manifold.LocallyLinearEmbedding(n_neighbors=5, n_components=2, 
reg=0.001,eigen_solver='auto', tol=1e-06, max_iter=100, method='standard',
hessian_tol=0.0001,modified_tol=1e-12, neighbors_algorithm='auto',
random_state=None)
```

- n_neighbors：一个整数，指定近邻参数  。
- n_components：一个整数，指定降维后的维数。
- reg：一个浮点数，指定正则化项的系数。
- eigen_solver：一个字符串，指定求解特征值的算法，可以为：
- 'auto'：由算法自动选取。
- 'arpack'：使用 Arnoldi分解算法。
- 'dense'：使用一个直接求解特征值的算法（如LAPACK）。
- tol：一个浮点数，指定求解特征值算法的收敛阈值（当eigen_solver='dense'时，该参数无用）。
- max_iter：一个浮点数，指定求解特征值算法的最大迭代次数（当eigen_solver='dense'时，该参数无用）。
- method：一个字符串，用于指定LLE算法的形式。可以为：
  - 'standard'：使用标准的LLE算法。
  - 'hessian'：使用Hessian eignmap算法。
  - 'modified'：使用modified LLE算法。
  - 'ltsa'：使用local tangent space alignment算法。
- hessian_tol：一个浮点数，用于method='hessian'时收敛的阈值。
- modified_tol：一个浮点数，用于method='modified'时收敛的阈值。
- neighbors_algorithm：一字符串，指定计算最近邻的算法。可以为：
  - 'ball_tree'：使用 BallTree算法。
  - 'kd_tree：使用 KDTree算法。
  - 'brute'：使用暴力搜索法。
  - 'auto'：自动决定最合适的算法。
- random_state：一个整数或者一个RandomState实例，或者None，指定随机数种子。

它用于 eigen_solver='arpack' 。

2. 属性：

- embedding_vectors_：给出了原始数据在低维空间的嵌入矩阵。
- reconstruction_error_：给出了重构误差。

3. 方法：

- fit(X[, y])：训练模型。
- transform(X)：执行降维，返回降维后的样本集。
- fit_transform(X[, y])：训练模型并执行降维，返回降维后的样本集。

4. 示例：鸢尾花数据集分别降低到4、3、2、1 维时，重构误差分别为：

	reconstruction_error(n_components=4) : 7.19936880176e-07
	reconstruction_error(n_components=3) : 3.8706050149e-07
	reconstruction_error(n_components=2) : 6.64141991211e-08
	reconstruction_error(n_components=1) : -1.74047846991e-15

该指标并不能用于判定降维的效果的好坏，它只是一个中性指标。

不同的k 降维到2维后的样本的分布图如下所示。可以看到 k=1,5 时，近邻范围过小，同样发生了断路现象。
![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N01-API-20201215-223656-744619.png)

不同的k 降维到1维后的样本的分布图如下所示。
![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N01-API-20201215-223656-761272.png)

# t-SNE

1. TSNE类是scikit-learn提供的t-SNE模型，其原型为：

```python
sklearn.manifold.TSNE(n_components=2, perplexity=30.0, 
early_exaggeration=12.0, learning_rate=200.0, n_iter=1000, 
n_iter_without_progress=300, min_grad_norm=1e-07, metric='euclidean', init='random',
verbose=0, random_state=None, method=’barnes_hut’, angle=0.5)
```

- n_components：一个整数，指定低维空间的维度。
- perplexity：一个浮点数，指定了困惑度。该参数影响的是：对每个点，考虑其周围多少个邻居点。
  - 其取值范围通常在5~50 之间。
  - 对于较大的数据集，该参数通常较大。
  - t-SNE 对于该参数不是特别敏感，因此该参数不是特别重要。
- early_exaggeration：一个浮点数，指定了早期对  放大的倍数。
  - 如果该数值较大，则相当于将高维空间中的点执行压缩。
  - t-SNE 对于该参数不是特别敏感，因此该参数不是特别重要。
- learning_rate ：一个浮点数，指定学习率。通常范围是在[10.0,1000.0] 。
  - 如果学习率过高，则降维之后的数据就像一个球体，每个点与它最近邻点的距离都几乎相等。
  - 如果学习率过低，则降维之后的数据看起来像是一个密集的压缩云，以及云外少量的异常点。
  - 如果代价函数陷入了局部极小值，则增加学习率会有帮助。
- n_iter：一个整数，指定最大的迭代次数。
- n_iter_without_progress：一个整数，在结束优化之前的、不在进度之内的最大迭代次数。主要用于初始化时的 early_exaggeration 。
- min_grad_norm：一个浮点数，指定梯度的阈值。如果梯度小于该阈值，则优化过程停止。
- metric：一个字符串或者可调用对象，指定距离的度量函数。
  - 如果是字符串，则它必须匹配 scipy.spatial.distance.pdist 的 metric 参数。
  - 如果是字符串'precomputed'，则 X 必须是一个距离矩阵。
  - 如果是可调用对象，则它传入一对样本点返回一个距离值。
- init：一个字符串或者numpy array，指定初始化策略。
  - 'random'：使用随机初始化。
  - 'pca'：使用PCA 初始化。它通常会更健壮。
  - 或者是一个形状为(n_samples,n_componets) 的array：直接初始化。
- verbose：一个整数，指定日志输出的级别。
- random_state ： 一个整数或者一个RandomState实例，或者None。指定随机数种子。
- method：一个字符串，指定梯度计算策略。
  - 'barnes_ht'：使用Barnes-Hut 近似算法，它计算梯度的近似值，计算复杂度为  。
  - 'exact'：计算梯度的精确值，计算复杂度为  。
- angle：一个浮点数，用于method='barnes_ht' ，用于平衡速度和准确率。

该参数在0.2-0.8 之间变化时，t-SNE 的结果不会发生太大的变化。
  - 如果该参数小于0.2，则计算时间会迅速增长。
  - 如果该参数大于0.8，则计算误差会迅速增长。

2. 属性：

- embedding_：一个形状为(n_samples,n_components) 的数组，给出了数据集在低维空间的表示。
- kl_divergence_：一个浮点数，给出了优化后的KL 散度。
- n_iter_：一个整数，给出了执行的迭代次数。

3. 方法：

- fit(X[, y])：训练模型。
- fit_transform(X[, y])：训练模型，并返回训练数据集在低维空间中的表示。