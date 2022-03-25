

```python
import numpy as np
import pandas as pd
```


```python
# dir(np)
```

# 常用函数

## set_printoptions

禁用NumPy的这种行为并强制打印整个数组，你可以设置printoptions参数来更改打印选项。


```python
np.set_printoptions(threshold=1000)
```

## arange


```python
np.arange(10)
```


    array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])




```python
np.arange(1, 20, 3)
```


    array([ 1,  4,  7, 10, 13, 16, 19])



## linspace


```python
np.linspace(2, 20, 5)
```


    array([ 2. ,  6.5, 11. , 15.5, 20. ])



## to_list


```python
np.arange(12).reshape(3, 4).tolist()
```


    [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11]]



## array


```python
np.array(range(5))
```


    array([0, 1, 2, 3, 4])




```python
np.array([1, 2, 3, 4])
```


    array([1, 2, 3, 4])




```python
np.array((1, 2, 3, 4))
```


    array([1, 2, 3, 4])




```python
np.array([[1, 2, 4], 
          [3, 4, 5]])
```


    array([[1, 2, 4],
           [3, 4, 5]])




```python
np.array([np.arange(3), np.arange(3)])
```


    array([[0, 1, 2],
           [0, 1, 2]])




```python
np.arange(24).reshape(2, 3, 4)
```


    array([[[ 0,  1,  2,  3],
            [ 4,  5,  6,  7],
            [ 8,  9, 10, 11]],
    
           [[12, 13, 14, 15],
            [16, 17, 18, 19],
            [20, 21, 22, 23]]])




```python
c = np.array([[1, 2], 
              [3, 4]], dtype=complex)
c
```


    array([[1.+0.j, 2.+0.j],
           [3.+0.j, 4.+0.j]])



## exp


```python
np.exp(1)
```


    2.718281828459045



## zeros


```python
np.zeros((5, 3))
```


    array([[0., 0., 0.],
           [0., 0., 0.],
           [0., 0., 0.],
           [0., 0., 0.],
           [0., 0., 0.]])



## zeros_like


```python
a = np.arange(24).reshape(4,6)
np.zeros_like(a)
```


    array([[0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0],
           [0, 0, 0, 0, 0, 0]])



## ones


```python
np.ones(5)
```


    array([1., 1., 1., 1., 1.])




```python
np.ones((5, 3))
```


    array([[1., 1., 1.],
           [1., 1., 1.],
           [1., 1., 1.],
           [1., 1., 1.],
           [1., 1., 1.]])



## ones_like


```python
a = np.arange(24).reshape(4,6)
np.ones_like(a)
```


    array([[1, 1, 1, 1, 1, 1],
           [1, 1, 1, 1, 1, 1],
           [1, 1, 1, 1, 1, 1],
           [1, 1, 1, 1, 1, 1]])



## empty


```python
np.empty((2, 3))
```


    array([[2.12199579e-314, 6.36598737e-314, 1.06099790e-313],
           [1.48539705e-313, 1.90979621e-313, 2.33419537e-313]])



## empty_like


```python
a = np.arange(24).reshape(4,6)
np.empty_like(a)
```


    array([[ 0,  1,  2,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11],
           [12, 13, 14, 15, 16, 17],
           [18, 19, 20, 21, 22, 23]])




```python
a = np.array([[1., 2., 3.], 
              [4., 5., 6.]])
np.empty_like(a)
```


    array([[2.12199579e-314, 6.36598737e-314, 1.06099790e-313],
           [1.48539705e-313, 1.90979621e-313, 2.33419537e-313]])



## title


```python
a = np.array([0, 1, 2])
np.tile(a, 2)
```


    array([0, 1, 2, 0, 1, 2])




```python
np.tile(a, (2, 2))
```


    array([[0, 1, 2, 0, 1, 2],
           [0, 1, 2, 0, 1, 2]])




```python
b = np.array([[1, 2],
              [3, 4]])
np.tile(b, 2)
```


    array([[1, 2, 1, 2],
           [3, 4, 3, 4]])



## mat


```python
np.mat([1, 3, 5, 7])
```


    matrix([[1, 3, 5, 7]])



## argmin


```python
a = np.random.randint(10, 30, (5, 3))
a
```


    array([[20, 26, 27],
           [17, 19, 29],
           [12, 22, 18],
           [24, 11, 26],
           [26, 29, 27]])




```python
np.argmin(a, axis=1)
```


    array([0, 0, 0, 1, 0], dtype=int64)




```python
np.argmin(a, axis=0)
```


    array([2, 3, 2], dtype=int64)



## argmax


```python
np.argmax(a, axis=1)
```


    array([2, 2, 1, 2, 1], dtype=int64)




```python
np.argmax(a, axis=0)
```


    array([4, 4, 1], dtype=int64)



## minimum
取对应位置上的小值


```python
np.minimum([2, 3, 4], 
           [1, 5, 2])
```


    array([1, 3, 2])




```python
np.minimum([1,2,3,4,5], 2)
```


    array([1, 2, 2, 2, 2])



## maximum
取对应位置上的大值


```python
# help(np.maximum)
```


```python
np.maximum([2, 3, 4], [1, 5, 2])
```


    array([2, 5, 4])




```python
a = np.random.randint(1, 20, (10)) - 10
a
```


    array([-4,  0, -4, -8, -4,  1,  1, -1,  2,  5])




```python
n = 0
np.maximum(a, n)  # 小于n的取n,大于n的不变
```


    array([0, 0, 0, 0, 0, 1, 1, 0, 2, 5])




```python
np.maximum(a, 0)  # 取0时，即relu函数
```


    array([0, 0, 0, 0, 0, 1, 1, 0, 2, 5])



## astype


```python
a.astype(float)
```


    array([-4.,  0., -4., -8., -4.,  1.,  1., -1.,  2.,  5.])



## searchsorted
数组的插入


```python
# np.searchsorted(a, b，side="left")
```

## where
np.where(condition, x, y)

满足条件(condition)，输出x，不满足输出y


```python
a = np.random.randint(-5, 10, (10))
a
```


    array([ 7,  5,  6,  1, -4,  8,  6,  8,  7,  9])




```python
np.where(a > 3, 1, -1)
```


    array([ 1,  1,  1, -1, -1,  1,  1,  1,  1,  1])




```python
a = np.array([2, 4, 6, 8, 10])
np.where(a > 5)
```


    (array([2, 3, 4], dtype=int64),)




```python
a[np.where(a > 5)] 
```


    array([ 6,  8, 10])



## argwhere


```python
a = np.random.randint(0, 10, size=(3, 3))
a
```


    array([[6, 1, 0],
           [3, 2, 3],
           [5, 2, 8]])




```python
np.argwhere(a > 5)  #返回值是a中的数据大于5的索引数组
```


    array([[0, 0],
           [2, 2]], dtype=int64)



## extract
和where函数有一点相，不过extract函数是返回满足条件的元素，而不是元素索引


```python
a = np.random.randint(-5, 10, (10))
a
```


    array([ 0,  2,  4,  5,  8,  8, -3,  9,  4,  7])




```python
np.extract(a > 3, a)
```


    array([4, 5, 8, 8, 9, 4, 7])



## take
提取指定索引位置的数据,并以一维数组或者矩阵返回(主要取决axis)


```python
a = [4, 3, 5, 7, 6, 8]
np.take(a, [0, 1, 4])
```


    array([4, 3, 6])



## fill


```python
a = np.array([1, 2])
a.fill(6)
a
```


    array([6, 6])



## exp


```python
np.exp(1)
```


    2.718281828459045



## floor


```python
a = np.floor(10 * np.random.random((3, 4)))
a
```


    array([[5., 3., 5., 7.],
           [9., 2., 7., 4.],
           [1., 3., 2., 8.]])



## clip
修剪数组，将数组中小于x的数均换为x，大于y的数均换为y


```python
np.clip(np.arange(10), 3,8)
```


    array([3, 3, 3, 3, 4, 5, 6, 7, 8, 8])



## sign
数组元素的符号


```python
np.sign(np.random.randint(1, 10, size=(12)) - 6)
```


    array([ 1,  1,  1, -1, -1,  1, -1,  1, -1, -1, -1,  1])



## piecewise
数组元素分类

## array_equal
判断两数组是否相等

## isreal
判断数组元素是否为实数

## trim_zeros
去除数组中首尾为0的元素

## rint
对浮点数取整，但不改变浮点数类型

## I
矩阵的逆矩阵

## mat
创建复合矩阵

## cov
计算协方差矩阵

## trace
计算矩阵的迹（对角线元素和）

## corrcoef
相关系数

## diagonal
给出对角线元素

## polyfit
多项式拟合

## polyder
多项式求导函数

## deriv
得到多项式的n阶导函数

## roots
多项式求根

## polyval
多项式在某点上的值

## polysub
两个多项式做差运算

## fromfunction

 多维数组可以每个轴有一个索引。这些索引由一个逗号分割的元组给出。


```python
def f(x, y):
    return 10 * x + y

b = np.fromfunction(f, (5, 4), dtype=int)
b
```


    array([[ 0,  1,  2,  3],
           [10, 11, 12, 13],
           [20, 21, 22, 23],
           [30, 31, 32, 33],
           [40, 41, 42, 43]])



## fromfile

## Numpy的数值类型


```python
np.int8(12.334)
```


    12




```python
np.float64(12)
```


    12.0




```python
np.float(True)
```


    1.0




```python
bool(1)
```


    True




```python
np.arange(5, dtype=float)
```


    array([0., 1., 2., 3., 4.])



## ndarray数组的属性

### dtype属性


```python
np.arange(4, dtype=float)
```


    array([0., 1., 2., 3.])




```python
# 'D'表示复数类型
np.arange(4, dtype='D')
```


    array([0.+0.j, 1.+0.j, 2.+0.j, 3.+0.j])




```python
np.array([1.22, 3.45, 6.779], dtype='int8')
```


    array([1, 3, 6], dtype=int8)



### ndim属性

数组维度的数量  
数组轴的个数，轴的个数被称作秩


```python
a = np.array([[1, 2, 3], [7, 8, 9]])
a.ndim
```


    2



### shape属性
数组对象的尺度，对于矩阵，即n行m列,shape是一个元组（tuple）


```python
a.shape
```


    (2, 3)



### size属性
数组元素的总个数，等于shape属性中元组元素的乘积。


```python
a.size
```


    6



### itemsize
属性返回数组中各个元素所占用的字节数大小。


```python
a.itemsize
```


    4



### nbytes属性
如果想知道整个数组所需的字节数量，可以使用nbytes属性。其值等于数组的size属性值乘以itemsize属性值。


```python
a.nbytes
```


    24




```python
a.size * a.itemsize
```


    24



### *T属性
数组转置


```python
b = np.arange(24).reshape(4, 6)
b
```


    array([[ 0,  1,  2,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11],
           [12, 13, 14, 15, 16, 17],
           [18, 19, 20, 21, 22, 23]])




```python
b.T
```


    array([[ 0,  6, 12, 18],
           [ 1,  7, 13, 19],
           [ 2,  8, 14, 20],
           [ 3,  9, 15, 21],
           [ 4, 10, 16, 22],
           [ 5, 11, 17, 23]])



### real和imag属性
复数的实部和虚部属性


```python
d = np.array([1.2 + 2j, 2 + 3j])
d
```


    array([1.2+2.j, 2. +3.j])




```python
d.real
```


    array([1.2, 2. ])




```python
d.imag
```


    array([2., 3.])



### flat属性
返回一个numpy.flatiter对象，即可迭代的对象。


```python
e = np.arange(6).reshape(2, 3)
e
```


    array([[0, 1, 2],
           [3, 4, 5]])




```python
f = e.flat
f
```


    <numpy.flatiter at 0x27d42900cb0>




```python
for item in f:
    print(item)
```

    0
    1
    2
    3
    4
    5


## 处理数组形状

### 形状转换

#### reshape()和resize()

函数resize（）的作用跟reshape（）类似，但是会改变所作用的数组，相当于有inplace=True的效果


```python
b = np.arange(12).reshape(3, 4)
b.reshape(4, 3)
```


    array([[ 0,  1,  2],
           [ 3,  4,  5],
           [ 6,  7,  8],
           [ 9, 10, 11]])




```python
b
```


    array([[ 0,  1,  2,  3],
           [ 4,  5,  6,  7],
           [ 8,  9, 10, 11]])




```python
b.resize(4, 3)
b
```


    array([[ 0,  1,  2],
           [ 3,  4,  5],
           [ 6,  7,  8],
           [ 9, 10, 11]])



#### ravel()和flatten()
将多维数组转换成一维数组，如下：


```python
b.ravel()
```


    array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11])




```python
b.flatten()
```


    array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11])



两者的区别在于返回拷贝（copy）还是返回视图（view），flatten()返回一份拷贝，需要分配新的内存空间，对拷贝所做的修改不会影响原始矩阵，而ravel()返回的是视图（view），会影响原始矩阵。

参考如下代码：

```python
# flatten()返回的是拷贝，不影响原始数组
# 即数组“b”没有发生变化
b.flatten()[2] = 20
b
```


    array([[ 0,  1,  2],
           [ 3,  4,  5],
           [ 6,  7,  8],
           [ 9, 10, 11]])




```python
# ravel()返回的是视图，会影响原始数组
# 即数组“b”会发生变化
b.ravel()[2] = 20
b
```


    array([[ 0,  1, 20],
           [ 3,  4,  5],
           [ 6,  7,  8],
           [ 9, 10, 11]])



### 用tuple指定数组的形状


```python
b.shape = (2, 6)
b
```


    array([[ 0,  1, 20,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11]])



### 转置T

前面描述了数组转置的属性（T），也可以通过transpose()函数来实现


```python
b
```


    array([[ 0,  1, 20,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11]])




```python
b.transpose()
```


    array([[ 0,  6],
           [ 1,  7],
           [20,  8],
           [ 3,  9],
           [ 4, 10],
           [ 5, 11]])




```python
b.T
```


    array([[ 0,  6],
           [ 1,  7],
           [20,  8],
           [ 3,  9],
           [ 4, 10],
           [ 5, 11]])



进行矩阵维度的位置替换


```python
a = np.random.rand(4, 2, 2, 3)
a
```


    array([[[[0.59772118, 0.3437354 , 0.91577702],
             [0.02118691, 0.72658281, 0.02020622]],
    
            [[0.72904567, 0.53322306, 0.01358828],
             [0.30950185, 0.64112673, 0.09092444]]],

           [[[0.66268257, 0.47367145, 0.93696601],
             [0.60369876, 0.73021665, 0.73415374]],
    
            [[0.65593156, 0.22530437, 0.67801094],
             [0.88824509, 0.16108978, 0.22386695]]],

           [[[0.55052278, 0.43406955, 0.50047349],
             [0.54894779, 0.14793545, 0.47773545]],
    
            [[0.52211343, 0.17926104, 0.88712801],
             [0.34530313, 0.13585922, 0.18842949]]],

           [[[0.82638749, 0.18427874, 0.37611174],
             [0.13662737, 0.63558351, 0.35934497]],
    
            [[0.833255  , 0.20921554, 0.939865  ],
             [0.42424037, 0.95424393, 0.03557415]]]])




```python
# 三四维转换，2*3变成3*2
a.transpose(0, 1, 3, 2)
```


    array([[[[0.59772118, 0.02118691],
             [0.3437354 , 0.72658281],
             [0.91577702, 0.02020622]],
    
            [[0.72904567, 0.30950185],
             [0.53322306, 0.64112673],
             [0.01358828, 0.09092444]]],

           [[[0.66268257, 0.60369876],
             [0.47367145, 0.73021665],
             [0.93696601, 0.73415374]],
    
            [[0.65593156, 0.88824509],
             [0.22530437, 0.16108978],
             [0.67801094, 0.22386695]]],

           [[[0.55052278, 0.54894779],
             [0.43406955, 0.14793545],
             [0.50047349, 0.47773545]],
    
            [[0.52211343, 0.34530313],
             [0.17926104, 0.13585922],
             [0.88712801, 0.18842949]]],

           [[[0.82638749, 0.13662737],
             [0.18427874, 0.63558351],
             [0.37611174, 0.35934497]],
    
            [[0.833255  , 0.42424037],
             [0.20921554, 0.95424393],
             [0.939865  , 0.03557415]]]])



### 堆叠数组


```python
b
```


    array([[ 0,  1, 20,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11]])




```python
c = b * 2
c
```


    array([[ 0,  2, 40,  6,  8, 10],
           [12, 14, 16, 18, 20, 22]])



#### 水平叠加hstack()


```python
np.hstack((b, c))
```


    array([[ 0,  1, 20,  3,  4,  5,  0,  2, 40,  6,  8, 10],
           [ 6,  7,  8,  9, 10, 11, 12, 14, 16, 18, 20, 22]])



column_stack()函数以列方式对数组进行叠加，功能类似hstack（）


```python
np.column_stack((b, c))
```


    array([[ 0,  1, 20,  3,  4,  5,  0,  2, 40,  6,  8, 10],
           [ 6,  7,  8,  9, 10, 11, 12, 14, 16, 18, 20, 22]])



#### 垂直叠加vstack()


```python
np.vstack((b, c))
```


    array([[ 0,  1, 20,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11],
           [ 0,  2, 40,  6,  8, 10],
           [12, 14, 16, 18, 20, 22]])



row_stack()函数以行方式对数组进行叠加，功能类似vstack（）


```python
np.row_stack((b, c))
```


    array([[ 0,  1, 20,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11],
           [ 0,  2, 40,  6,  8, 10],
           [12, 14, 16, 18, 20, 22]])



#### concatenate()方法
通过设置axis的值来设置叠加方向

axis=1时，沿水平方向叠加

axis=0时，沿垂直方向叠加


```python
np.concatenate((b, c), axis=1)
```


    array([[ 0,  1, 20,  3,  4,  5,  0,  2, 40,  6,  8, 10],
           [ 6,  7,  8,  9, 10, 11, 12, 14, 16, 18, 20, 22]])




```python
np.concatenate((b, c), axis=0)
```


    array([[ 0,  1, 20,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11],
           [ 0,  2, 40,  6,  8, 10],
           [12, 14, 16, 18, 20, 22]])




```python
np.concatenate((b, c), axis=None)
```


    array([ 0,  1, 20,  3,  4,  5,  6,  7,  8,  9, 10, 11,  0,  2, 40,  6,  8,
           10, 12, 14, 16, 18, 20, 22])



### 深度叠加

这个有点烧脑，举个例子如下，自己可以体会下：


```python
b
```


    array([[ 0,  1, 20,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11]])




```python
c
```


    array([[ 0,  2, 40,  6,  8, 10],
           [12, 14, 16, 18, 20, 22]])




```python
arr_dstack = np.dstack((b, c))
print(arr_dstack.shape)
arr_dstack
```

    (2, 6, 2)

    array([[[ 0,  0],
            [ 1,  2],
            [20, 40],
            [ 3,  6],
            [ 4,  8],
            [ 5, 10]],
    
           [[ 6, 12],
            [ 7, 14],
            [ 8, 16],
            [ 9, 18],
            [10, 20],
            [11, 22]]])



叠加前，b和c均是shape为（2,6）的二维数组，叠加后，arr_dstack是shape为（2,6,2）的三维数组。

### 数组的拆分split

跟数组的叠加类似，数组的拆分可以分为横向拆分、纵向拆分以及深度拆分。

涉及的函数为 hsplit()、vsplit()、dsplit() 以及split()


```python
b = np.arange(12).reshape(2, -1)
b
```


    array([[ 0,  1,  2,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11]])



#### 沿横向轴拆分（axis=1）-hsplit


```python
np.hsplit(b, 2)
```


    [array([[0, 1, 2],
            [6, 7, 8]]), array([[ 3,  4,  5],
            [ 9, 10, 11]])]




```python
np.split(b, 2, axis=1)
```


    [array([[0, 1, 2],
            [6, 7, 8]]), array([[ 3,  4,  5],
            [ 9, 10, 11]])]



#### 沿纵向轴拆分（axis=0）-vsplit


```python
np.vsplit(b, 2)
```


    [array([[0, 1, 2, 3, 4, 5]]), array([[ 6,  7,  8,  9, 10, 11]])]




```python
np.split(b, 2, axis=0)
```


    [array([[0, 1, 2, 3, 4, 5]]), array([[ 6,  7,  8,  9, 10, 11]])]



#### 深度拆分dsplit


```python
arr_dstack
```


    array([[[ 0,  0],
            [ 1,  2],
            [20, 40],
            [ 3,  6],
            [ 4,  8],
            [ 5, 10]],
    
           [[ 6, 12],
            [ 7, 14],
            [ 8, 16],
            [ 9, 18],
            [10, 20],
            [11, 22]]])




```python
np.dsplit(arr_dstack, 2)
```


    [array([[[ 0],
             [ 1],
             [20],
             [ 3],
             [ 4],
             [ 5]],
     
            [[ 6],
             [ 7],
             [ 8],
             [ 9],
             [10],
             [11]]]), array([[[ 0],
             [ 2],
             [40],
             [ 6],
             [ 8],
             [10]],
     
            [[12],
             [14],
             [16],
             [18],
             [20],
             [22]]])]



拆分的结果是原来的三维数组拆分成为两个二维数组。

## 数组的广播

当数组跟一个标量进行数学运算时，标量需要根据数组的形状进行扩展，然后执行运算。

这个扩展的过程称为“广播（broadcasting）”

**广播法则(rule)**

>广播法则能使通用函数有意义地处理不具有相同形状的输入。  
>广播第一法则是，如果所有的输入数组维度不都相同，一个“1”将被重复地添加在维度较小的数组上直至所有的数组拥有一样的维度。  
>广播第二法则确定长度为1的数组沿着特殊的方向表现地好像它有沿着那个方向最大形状的大小。对数组来说，沿着那个维度的数组元素的值理应相同。  
>应用广播法则之后，所有数组的大小必须匹配。更多细节可以从这个文档找到。


```python
b
```


    array([[ 0,  1,  2,  3,  4,  5],
           [ 6,  7,  8,  9, 10, 11]])




```python
d = b + 2
d
```


    array([[ 2,  3,  4,  5,  6,  7],
           [ 8,  9, 10, 11, 12, 13]])





# 数组的切片和索引

可通过位置进行索引，如下：


```python
f = np.arange(12)
```


```python
f[2]
```


    2




```python
f[[1, 4]]
```


    array([1, 4])




```python
e = np.arange(6).reshape(2, 3)
e
```


    array([[0, 1, 2],
           [3, 4, 5]])




```python
e.flat = 7
e
```


    array([[7, 7, 7],
           [7, 7, 7]])




```python
e.flat[[1, 4]] = 1
e
```


    array([[7, 1, 7],
           [7, 1, 7]])




```python
a = np.arange(7)
a
```


    array([0, 1, 2, 3, 4, 5, 6])




```python
a[1:4]
```


    array([1, 2, 3])




```python
a[:6:2]
```


    array([0, 2, 4])




```python
b = np.arange(12).reshape(3, 4)
b
```


    array([[ 0,  1,  2,  3],
           [ 4,  5,  6,  7],
           [ 8,  9, 10, 11]])




```python
b[0:3, 0:2]
```


    array([[0, 1],
           [4, 5],
           [8, 9]])




```python
for row in b:
    print(row)
```

    [0 1 2 3]
    [4 5 6 7]
    [ 8  9 10 11]


## 通过数组索引


```python
a = np.arange(12)**2  # the first 12 square numbers
i = np.array([1, 1, 3, 8, 5])  # an array of indices
a[i]
```


    array([ 1,  1,  9, 64, 25], dtype=int32)




```python
j = np.array([[3, 4], [9, 7]])  # a bidimensional array of indices
a[j]  # the same shape as j
```


    array([[ 9, 16],
           [81, 49]], dtype=int32)



当被索引数组a是多维的时，每一个唯一的索引数列指向a的第一维5。 

以下示例通过将图片标签用调色版转换成色彩图像展示了这种行为。


```python
palette = np.array([[0, 0, 0],  # black
                 [255, 0, 0],  # red
                 [0, 255, 0],  # green
                 [0, 0, 255],  # blue
                 [255, 255, 255]])  # white

image = np.array([[0, 1, 2, 0],  # each value corresponds to a color in the palette
               [0, 3, 4, 0]])

palette[image]
```


    array([[[  0,   0,   0],
            [255,   0,   0],
            [  0, 255,   0],
            [  0,   0,   0]],
    
           [[  0,   0,   0],
            [  0,   0, 255],
            [255, 255, 255],
            [  0,   0,   0]]])



我们也可以给出不不止一维的索引，每一维的索引数组必须有相同的形状。


```python
a = np.arange(12).reshape(3, 4)
a
```


    array([[ 0,  1,  2,  3],
           [ 4,  5,  6,  7],
           [ 8,  9, 10, 11]])




```python
i = np.array([
    [0, 1],  # indices for the first dim of a
    [1, 2]
])
j = np.array([
    [2, 1],  # indices for the second dim
    [3, 3]
])

a[i, j]
```


    array([[ 2,  5],
           [ 7, 11]])




```python
a[i, 2]
```


    array([[ 2,  6],
           [ 6, 10]])




```python
a[:, j] 
```


    array([[[ 2,  1],
            [ 3,  3]],
    
           [[ 6,  5],
            [ 7,  7]],
    
           [[10,  9],
            [11, 11]]])




```python
l = [i, j]
a[l]    
```


    array([[ 2,  5],
           [ 7, 11]])




```python
s = np.array([i, j])
a[s]  # not what we want
```


    ---------------------------------------------------------------------------
    
    IndexError                                Traceback (most recent call last)
    
    <ipython-input-8-38525a369f97> in <module>()
          1 s = np.array([i, j])
    ----> 2 a[s]  # not what we want


    IndexError: index 3 is out of bounds for axis 0 with size 3



```python
a[tuple(s)]
```


    array([[ 2,  5],
           [ 7, 11]])




```python
time = np.linspace(20, 145, 5)  #
time
```


    array([ 20.  ,  51.25,  82.5 , 113.75, 145.  ])




```python
data = np.sin(np.arange(20)).reshape(5, 4) 
data
```


    array([[ 0.        ,  0.84147098,  0.90929743,  0.14112001],
           [-0.7568025 , -0.95892427, -0.2794155 ,  0.6569866 ],
           [ 0.98935825,  0.41211849, -0.54402111, -0.99999021],
           [-0.53657292,  0.42016704,  0.99060736,  0.65028784],
           [-0.28790332, -0.96139749, -0.75098725,  0.14987721]])




```python
ind = data.argmax(axis=0)  # index of the maxima for each series
ind
```


    array([2, 0, 3, 1], dtype=int64)




```python
time_max = time[ind]  # times corresponding to the maxima

data_max = data[ind, range(data.shape[1])]  # => data[ind[0],0], data[ind[1],1]...

time_max
```


    array([ 82.5 ,  20.  , 113.75,  51.25])




```python
data_max
```


    array([0.98935825, 0.84147098, 0.99060736, 0.6569866 ])




```python
all(data_max == data.max(axis=0))
```


    True




```python
a = np.arange(5)
a
```


    array([0, 1, 2, 3, 4])




```python
a[[1, 3, 4]] = 0
a
```


    array([0, 0, 2, 0, 0])




```python
a = np.arange(5)
a[[0, 0, 2]] = [1, 2, 3]
a
```


    array([2, 1, 3, 3, 4])




```python
a = np.arange(5)
a[[0, 0, 2]] += 1
a
```


    array([1, 1, 3, 3, 4])



## 通过布尔数组索引


```python
a = np.arange(12).reshape(3, 4)
b = a > 4
b
```


    array([[False, False, False, False],
           [False,  True,  True,  True],
           [ True,  True,  True,  True]])




```python
a[b]
```


    array([ 5,  6,  7,  8,  9, 10, 11])




```python
# 这个属性在赋值时非常有用：
a[b] = 0 
a
```


    array([[0, 1, 2, 3],
           [4, 0, 0, 0],
           [0, 0, 0, 0]])




```python
a = np.arange(12).reshape(3, 4)
b1 = np.array([False, True, True])  # first dim selection
b2 = np.array([True, False, True, False])  # second dim selection
```


```python
a[b1, :]
```


    array([[ 4,  5,  6,  7],
           [ 8,  9, 10, 11]])




```python
a[b1]
```


    array([[ 4,  5,  6,  7],
           [ 8,  9, 10, 11]])




```python
a[:, b2]
```


    array([[ 0,  2],
           [ 4,  6],
           [ 8, 10]])




```python
a[b1, b2]
```


    array([ 4, 10])



# 数组运算

## 基本计算


```python
a = np.array([20, 30, 40, 50])
b = np.arange(4)
b
```


    array([0, 1, 2, 3])




```python
c = a - b
c
```


    array([20, 29, 38, 47])




```python
b**2
```


    array([0, 1, 4, 9], dtype=int32)




```python
10 * np.sin(a)
```


    array([ 9.12945251, -9.88031624,  7.4511316 , -2.62374854])




```python
a < 35
```


    array([ True,  True, False, False])




```python
A = np.array([[1, 1], [0, 1]])
B = np.array([[2, 0], [3, 4]])

A * B
```


    array([[2, 0],
           [0, 4]])




```python
a = np.ones((2, 3), dtype=int)
b = np.random.random((2, 3))

a *= 3
a
```


    array([[3, 3, 3],
           [3, 3, 3]])




```python
b += a
b
```


    array([[3.31916353, 3.08512937, 3.83817354],
           [3.07107614, 3.68484232, 3.90804087]])




```python
a += b  # b is converted to integer type
a
```


    ---------------------------------------------------------------------------
    
    UFuncTypeError                            Traceback (most recent call last)
    
    <ipython-input-37-4ad53cb40011> in <module>()
    ----> 1 a += b  # b is converted to integer type
          2 a


    UFuncTypeError: Cannot cast ufunc 'add' output from dtype('float64') to dtype('int32') with casting rule 'same_kind'


当运算的是不同类型的数组时，结果数组和更普遍和精确的一致(这种行为叫做upcast)。


```python
a = np.ones(3, dtype='int32')
b = np.linspace(0, np.pi, 3)

b.dtype.name
```


    'float64'




```python
c = a + b
c
```


    array([1.        , 2.57079633, 4.14159265])




```python
c.dtype.name
```


    'float64'




```python
d = np.exp(c * 1j)
d
```


    array([ 0.54030231+0.84147098j, -0.84147098+0.54030231j,
           -0.54030231-0.84147098j])




```python
d.dtype.name
```


    'complex128'




```python
# 许多非数组运算，如计算数组所有元素之和，被作为ndarray类的方法实现

# 这些运算默认应用到数组好像它就是一个数字组成的列表，无关数组的形状。
# 然而，指定axis参数你可以吧运算应用到数组指定的轴上：

b = np.arange(12).reshape(3, 4)
b
```


    array([[ 0,  1,  2,  3],
           [ 4,  5,  6,  7],
           [ 8,  9, 10, 11]])




```python
b.sum(axis=0)  # sum of each column
```


    array([12, 15, 18, 21])




```python
b.min(axis=1)  # min of each row
```


    array([0, 4, 8])




```python
b.cumsum(axis=1)  # cumulative sum along each row
```


    array([[ 0,  1,  3,  6],
           [ 4,  9, 15, 22],
           [ 8, 17, 27, 38]], dtype=int32)



## 常用统计函数

常用的函数如下：

请注意函数在使用时需要指定axis轴的方向，若不指定，默认统计整个数组。

* np.sum()，返回求和
* np.mean()，返回均值
* np.max()，返回最大值
* np.min()，返回最小值
* np.ptp()，数组沿指定轴返回最大值减去最小值，即（max-min）
* np.std()，返回标准偏差（standard deviation）
* np.var()，返回方差（variance）
* np.cumsum()，返回累加值
* np.cumprod()，返回累乘积值


```python
b = np.random.random((2, 3))
b
```


    array([[0.00206153, 0.32925106, 0.33984151],
           [0.10040862, 0.73174281, 0.56028802]])



### np.max()


```python
np.max(b)
```


    0.7317428128149566




```python
b.max()
```


    0.7317428128149566




```python
# 沿axis=1轴方向统计
np.max(b, axis=1)
```


    array([0.33984151, 0.73174281])




```python
# 沿axis=0轴方向统计
np.max(b, axis=0)
```


    array([0.10040862, 0.73174281, 0.56028802])



### np.min()


```python
np.min(b)
```


    0.0020615318593358856




```python
b.min()
```


    0.0020615318593358856




```python
# 沿axis=1轴方向统计
np.min(b, axis=1)
```


    array([0.00206153, 0.10040862])




```python
# 沿axis=0轴方向统计
np.min(b, axis=0)
```


    array([0.00206153, 0.32925106, 0.33984151])



### np.ptp()

返回整个数组的最大值减去最小值


```python
np.ptp(b)
```


    0.7296812809556207




```python
# 沿axis=0轴方向
np.ptp(b, axis=0)
```


    array([0.09834709, 0.40249175, 0.2204465 ])




```python
# 沿axis=1轴方向
np.ptp(b, axis=1)
```


    array([0.33777998, 0.63133419])



### np.cumsum()

沿指定轴方向进行累加


```python
b = np.random.random((2, 6))
b.resize(4, 3)
b
```


    array([[0.10674932, 0.93979694, 0.94855996],
           [0.02413605, 0.24353007, 0.94912462],
           [0.43391076, 0.08490208, 0.2068033 ],
           [0.50240349, 0.37762655, 0.81599639]])




```python
np.cumsum(b, axis=1)
```


    array([[0.10674932, 1.04654626, 1.99510622],
           [0.02413605, 0.26766612, 1.21679074],
           [0.43391076, 0.51881284, 0.72561614],
           [0.50240349, 0.88003003, 1.69602642]])




```python
np.cumsum(b, axis=0)
```


    array([[0.10674932, 0.93979694, 0.94855996],
           [0.13088537, 1.18332701, 1.89768458],
           [0.56479613, 1.26822909, 2.10448788],
           [1.06719962, 1.64585564, 2.92048427]])



### np.cumprod()

沿指定轴方向进行累乘积 （Return the cumulative product of the elements along the given axis）


```python
np.cumprod(b, axis=1)
```


    array([[0.10674932, 0.10032269, 0.09516208],
           [0.02413605, 0.00587785, 0.00557882],
           [0.43391076, 0.03683993, 0.00761862],
           [0.50240349, 0.18972089, 0.15481156]])




```python
np.cumprod(b, axis=0)
```


    array([[1.06749324e-01, 9.39796939e-01, 9.48559961e-01],
           [2.57650694e-03, 2.28868814e-01, 9.00301615e-01],
           [1.11797409e-03, 1.94314386e-02, 1.86185347e-01],
           [5.61674081e-04, 7.33782704e-03, 1.51926571e-01]])



### np.prod

所有数组元素乘积


```python
np.prod(b)
```


    6.261603858290139e-07




```python
np.prod(b, axis=0)
```


    array([0.00056167, 0.00733783, 0.15192657])




```python
np.prod(b, axis=1)
```


    array([0.09516208, 0.00557882, 0.00761862, 0.15481156])



### mod

求余

### mean

计算平均值

### average

计算加权平均值

### pth

计算数组的极差

### var

计算方差（总体方差）

### std

标准差

### sqrt

算术平方根，a为浮点数类型

### log

### dot

点积（计算两个数组的线性组合）

# 数组维度


```python
a = np.random.randint(10, 30, (6, 4))
a
```


    array([[15, 17, 21, 13],
           [25, 15, 15, 17],
           [26, 21, 16, 18],
           [10, 28, 10, 26],
           [29, 15, 29, 23],
           [21, 17, 13, 18]])




```python
a.resize(2, 3, 4)
a
```




    array([[[15, 17, 21, 13],
            [25, 15, 15, 17],
            [26, 21, 16, 18]],
    
           [[10, 28, 10, 26],
            [29, 15, 29, 23],
            [21, 17, 13, 18]]])



# 复制和视图

## 完全不拷贝

简单的赋值不拷贝数组对象或它们的数据。


```python
a = np.arange(12)
b = a  # no new object is created
b is a
```


    True




```python
b.shape = 3, 4  # changes the shape of a
a.shape
```


    (3, 4)




```python
# Python传递不定对象作为参考4，所以函数调用不拷贝数组。
def f(x):
    print(id(x))

id(a)
```


    2957083713984




```python
f(a)
```

    2957083713984


## 视图(view)和浅复制  

不同的数组对象分享同一个数据。视图方法创造一个新的数组对象指向同一数据。


```python
c = a.view()
c is a
```


    False




```python
c.base is a
```


    True




```python
c.flags.owndata
```


    False




```python
c.shape = 2, 6  # a's shape doesn't change
a.shape
```


    (3, 4)




```python
c[0, 4] = 1234  # a's data changes
a
```


    array([[   0,    1,    2,    3],
           [1234,    5,    6,    7],
           [   8,    9,   10,   11]])




```python
# 切片数组返回它的一个视图：
s = a[:, 1:3]  # spaces added for clarity; could also be written "s = a[:,1:3]"
s
```


    array([[ 1,  2],
           [ 5,  6],
           [ 9, 10]])




```python
s[:] = 10  # s[:] is a view of s. Note the difference between s=10 and s[:]=10
s
```


    array([[10, 10],
           [10, 10],
           [10, 10]])




```python
a
```


    array([[   0,   10,   10,    3],
           [1234,   10,   10,    7],
           [   8,   10,   10,   11]])



## 深复制

这个复制方法完全复制数组和它的数据。


```python
d = a.copy()  # a new array object with new data is created
d is a
```


    False




```python
d.base is a
```


    False




```python
d[0, 0] = 9999
a
```


    array([[   0,   10,   10,    3],
           [1234,   10,   10,    7],
           [   8,   10,   10,   11]])



# 随机-random

## random.randint


```python
np.random.randint(1, 10, 6)
```


    array([6, 7, 6, 1, 5, 2])



## random.randn


```python
np.random.randn(5, 3)
```


    array([[ 0.04648026,  0.94502572,  0.83840576],
           [ 0.23603822,  0.00897836, -1.55858616],
           [ 1.10588287, -1.75275083, -0.20591962],
           [-0.32976423, -1.7079426 , -0.88457696],
           [-0.50483345, -1.07277225, -0.23841873]])



## random.normal


```python
mu, sigma = 0, 0.1
s = np.random.normal(mu, sigma, 10)
s
```


    array([ 0.12918615, -0.11123183,  0.02988147, -0.05118002, -0.04918006,
            0.04860972, -0.14915559,  0.06995321, -0.04692938, -0.01737406])



## random.rand


```python
np.random.rand(5)
```


    array([0.54615321, 0.02666393, 0.8210047 , 0.27473617, 0.03414602])




```python
np.random.rand(5, 3)
```


    array([[0.88879424, 0.00292729, 0.78695172],
           [0.84529257, 0.91022798, 0.77088328],
           [0.71748683, 0.07495647, 0.11241636],
           [0.47621146, 0.37339614, 0.96207082],
           [0.47058721, 0.85808478, 0.03164623]])




```python
np.random.rand(2, 3, 4)
```


    array([[[0.41488202, 0.45036626, 0.85700627, 0.24221969],
            [0.55521474, 0.77805402, 0.33380093, 0.85808105],
            [0.70332921, 0.73371334, 0.54173939, 0.47741248]],
    
           [[0.8404254 , 0.55998499, 0.87036267, 0.08176074],
            [0.31683183, 0.63935123, 0.67894601, 0.00936004],
            [0.26146434, 0.46910538, 0.71922109, 0.27774205]]])



## random.random


```python
np.random.random(5)
```


    array([0.31804585, 0.81412031, 0.57810202, 0.22778101, 0.49642852])




```python
np.random.sample(3)
```


    array([0.82930204, 0.24712845, 0.66725345])



## random.randint


```python
np.random.randint(10, 30, (4, 3))
```


    array([[23, 26, 17],
           [13, 11, 14],
           [22, 16, 13],
           [20, 16, 12]])



## random.seed


```python
np.random.seed(50)
```

## random.shuffle


```python
arr = np.arange(10)
np.random.shuffle(arr)
arr
```


    array([7, 8, 6, 2, 4, 1, 5, 3, 9, 0])



## random.uniform


```python
np.random.uniform(1, 10)
```


    9.969168071391843



## random.binomial

产生二项分布的随机数

## random.hypergeometric

产生超几何分布随机数

## random.lognormal

产生N个对数正态分布的随机数

## random.permutation


```python
a = np.random.randint(20, 50, (8, 3))
a
```


    array([[25, 22, 46],
           [27, 35, 24],
           [34, 23, 48],
           [47, 46, 46],
           [26, 40, 31],
           [37, 41, 30],
           [29, 20, 47],
           [26, 39, 22]])




```python
ind = np.random.permutation(a.shape[0])
a[ind]
```


    array([[37, 41, 30],
           [25, 22, 46],
           [34, 23, 48],
           [26, 40, 31],
           [47, 46, 46],
           [27, 35, 24],
           [29, 20, 47],
           [26, 39, 22]])



# 矩阵类


```python
A = np.matrix('1.0 2.0; 3.0 4.0')
A
```


    matrix([[1., 2.],
            [3., 4.]])




```python
type(A)
```


    numpy.matrix




```python
A.T
```


    matrix([[1., 3.],
            [2., 4.]])




```python
X = np.matrix('5.0 7.0')
Y = X.T
Y
```


    matrix([[5.],
            [7.]])




```python
A * Y
```


    matrix([[19.],
            [43.]])




```python
A.I
```


    matrix([[-2. ,  1. ],
            [ 1.5, -0.5]])




```python
np.linalg.solve(A, Y)
```


    matrix([[-3.],
            [ 4.]])



**索引：比较矩阵和二维数组**

注意NumPy中数组和矩阵有些重要的区别。 

NumPy提供了两个基本的对象：一个N维数组对象和一个通用函数对象。其它对象都是建构在它们之上的。  

特别的，矩阵是继承自NumPy数组对象的二维数组对象。对数组和矩阵，索引都必须包含合适的一个或多个这些组合：整数标量、省略号(ellipses)、整数列表;  

布尔值，整数或布尔值构成的元组，和一个一维整数或布尔值数组。矩阵可以被用作矩阵的索引，但是通常需要数组、列表或者其它形式来完成这个任务。


```python
A = np.arange(12)
A
```


    array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11])




```python
A.shape = (3, 4)
M = np.mat(A.copy())

print(type(A), "  ", type(M))
```

    <class 'numpy.ndarray'>    <class 'numpy.matrix'>



```python
A
```


    array([[ 0,  1,  2,  3],
           [ 4,  5,  6,  7],
           [ 8,  9, 10, 11]])




```python
M
```


    matrix([[ 0,  1,  2,  3],
            [ 4,  5,  6,  7],
            [ 8,  9, 10, 11]])




```python
A[:]
```


    array([[ 0,  1,  2,  3],
           [ 4,  5,  6,  7],
           [ 8,  9, 10, 11]])




```python
A[:].shape
```


    (3, 4)




```python
M[:]
```


    matrix([[ 0,  1,  2,  3],
            [ 4,  5,  6,  7],
            [ 8,  9, 10, 11]])




```python
M[:].shape
```


    (3, 4)




```python
A[:, 1]
```


    array([1, 5, 9])




```python
A[:, 1].shape
```


    (3,)




```python
M[:, 1]
```


    matrix([[1],
            [5],
            [9]])




```python
M[:, 1].shape
```


    (3, 1)




```python
A[:, [1, 3]]
```


    array([[ 1,  3],
           [ 5,  7],
           [ 9, 11]])




```python
A[:, ].take([1, 3], axis=1)
```


    array([[ 1,  3],
           [ 5,  7],
           [ 9, 11]])




```python
A[1:, ].take([1, 3], axis=1)
```


    array([[ 5,  7],
           [ 9, 11]])




```python
A[np.ix_((1, 2), (1, 3))]
```


    array([[ 5,  7],
           [ 9, 11]])




```python
A[0, :] > 1
```


    array([False, False,  True,  True])




```python
A[:, A[0, :] > 1]
```


    array([[ 2,  3],
           [ 6,  7],
           [10, 11]])




```python
M[0, :] > 1
```


    matrix([[False, False,  True,  True]])




```python
M
```


    matrix([[ 0,  1,  2,  3],
            [ 4,  5,  6,  7],
            [ 8,  9, 10, 11]])




```python
np.matrix([[2, 3]])
```


    matrix([[2, 3]])




```python
M[:, M.A[0, :] > 1]
```


    matrix([[ 2,  3],
            [ 6,  7],
            [10, 11]])




```python
A[A[:, 0] > 2, A[0, :] > 1]
```


    array([ 6, 11])




```python
M[M.A[:, 0] > 2, M.A[0, :] > 1]
```


    matrix([[ 6, 11]])




```python
A[np.ix_(A[:, 0] > 2, A[0, :] > 1)]
```


    array([[ 6,  7],
           [10, 11]])




```python
M[np.ix_(M.A[:, 0] > 2, M.A[0, :] > 1)]
```


    matrix([[ 6,  7],
            [10, 11]])



# linalg

## linalg.lstsq

估计线性模型中的系数

## linalg.inv

求方阵的逆矩阵


```python
a = np.array([[1.0, 2.0], [3.0, 4.0]])
a
```


    array([[1., 2.],
           [3., 4.]])




```python
np.linalg.inv(a)
```


    array([[-2. ,  1. ],
           [ 1.5, -0.5]])



## linalg.pinv

求广义逆矩阵


```python
print(a)
```

    [[1. 2.]
     [3. 4.]]



```python
a.transpose()
```


    array([[1., 3.],
           [2., 4.]])



## linalg.det

求矩阵的行列式

## linalg.solve

解形如AX = b的线性方程组

## linalg.eigvals

求矩阵的特征值

## linalg.eig

求特征值和特征向量

## linalg.svd

Svd分解

# 高级操作

## 数组排序

### msort

列排序, 会错行


```python
a = np.random.randint(1, 50, (4, 6))
a
```


    array([[ 3, 13, 33,  4,  3, 11],
           [49, 47,  1, 30, 30, 31],
           [ 1, 12, 31, 27,  8, 29],
           [25, 28, 47, 14,  8, 37]])




```python
np.msort(a)
```


    array([[ 1, 12,  1,  4,  3, 11],
           [ 3, 13, 31, 14,  8, 29],
           [25, 28, 33, 27,  8, 31],
           [49, 47, 47, 30, 30, 37]])



### sort

行排序,会错列


```python
np.sort(a)
```


    array([[ 3,  3,  4, 11, 13, 33],
           [ 1, 30, 30, 31, 47, 49],
           [ 1,  8, 12, 27, 29, 31],
           [ 8, 14, 25, 28, 37, 47]])



### argsort

排序后返回下标


```python
np.argsort(a)
```


    array([[0, 4, 3, 5, 1, 2],
           [2, 3, 4, 5, 1, 0],
           [0, 4, 1, 3, 5, 2],
           [4, 3, 0, 1, 5, 2]], dtype=int64)



### np.sort_complex

复数排序，按先实部后虚部排序
