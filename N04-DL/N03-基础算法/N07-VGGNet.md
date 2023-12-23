# 提出的背景

提出目的即为了探究在大规模图像识别任务中，卷积网络深度对模型精确度有何影响。

VGGNet由牛津大学的视觉几何组（Visual Geometry Group）和Google DeepMind公司的研究员共同提出，是ILSVRC-2014中定位任务第一名和分类任务第二名。其突出贡献在于**证明使用很小的卷积（3×3），增加网络深度可以有效提升模型的效果**，而且VGGNet对其他数据集**具有很好的泛化能力**。到目前为止，VGGNet依然经常被用来提取图像特征。

VGGNet探索了CNN的深度及其性能之间的关系，通过反复堆叠3×3的小型卷积核和2×2的最大池化层，VGGNet成功的构筑了16-19层深的CNN。



# VGGNet结构

## VGG块

VGG块的组成规律是：连续使用数个相同的填充为1、窗口形状为$3\times 3$的卷积层后接上一个步幅为2、窗口形状为$2\times 2$的最大池化层。卷积层保持输入的高和宽不变，而池化层则对其减半。我们使用`vgg_block`函数来实现这个基础的VGG块，它可以指定卷积层的数量和输入输出通道数。

对于给定的感受野（与输出有关的输入图片的局部大小），**采用堆积的小卷积核优于采用大的卷积核，因为可以增加网络深度来保证学习更复杂的模式，而且代价还比较小（参数更少）**。例如，在VGG中，使用了3个3x3卷积核来代替7x7卷积核，使用了2个3x3卷积核来代替5*5卷积核，这样做的主要目的是在保证具有相同感知野的条件下，提升了网络的深度，在一定程度上提升了神经网络的效果。

与AlexNet和LeNet一样，VGG网络由卷积层模块后接全连接层模块构成。卷积层模块串联数个`vgg_block`，其超参数由变量`conv_arch`定义。该变量指定了每个VGG块里卷积层个数和输入输出通道数。全连接模块则跟AlexNet中的一样。

现在我们构造一个VGG网络。它有5个卷积块，前2块使用单卷积层，而后3块使用双卷积层。第一块的输入输出通道分别是1（因为下面要使用的Fashion-MNIST数据的通道数为1）和64，之后每次对输出通道数翻倍，直到变为512。因为这个网络使用了8个卷积层和3个全连接层，所以经常被称为VGG-11。

---

VGGNet有A-E七种结构，从A-E网络逐步变深，但是参数量并没有增长很多，原因为：参数量主要消耗在最后3个全连接层，而前面的卷积层虽然层数多，但消耗的参数量不大。不过，卷积层的训练比较耗时，因为其计算量大。

其中，D和E是常说的VGGNet-16和VGGNet-19。C很有意思，相比于B多了几个1×1的卷积层，1×1卷积的意义在于线性变换，而输入的通道数和输出的通道数不变，没有发生降维。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N07-VGGNet-20201215-224442-916353.png)

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N07-VGGNet-20201215-224442-934675.png)

**VGGNet网络配置情况：**   

1.  为了在公平的原则下探究网络深度对模型精确度的影响，所有卷积层有相同的配置，即卷积核大小为3x3，步长为1，填充为1；  
2.  共有5个最大池化层，大小都为2x2，步长为2；  
3.  共有三个全连接层，前两层都有4096通道，第三层共1000路及代表1000个标签类别；  
4.  最后一层为softmax层；  
5.  所有隐藏层后都带有ReLU非线性激活函数；  
6.  经过实验证明，AlexNet中提出的局部响应归一化（LRN）对性能提升并没有什么帮助，而且还浪费了内存的计算的损耗。 

上述图为VGGNet网络框图，从左至右每一列代表着深度增加的不同的模型，从上至下代表模型的深度，其中conv<滤波器大小>-<通道数>，至于为什么用3x3的滤波器尺寸，是因为这是能捕捉到各个方向的最小尺寸了，如ZFNet中所说，由于第一层中往往有大量的高频和低频信息，却没有覆盖到中间的频率信息，且步长过大，容易引起大量的混叠，因此滤波器尺寸和步长要尽量小；这里使用1x1的卷积模版是因为1x1就相当于可以看作是一种对输入通道进行线性变换的操作（增加决策函数的非线性且不会影响到感受野的大小）。

上面第二个图为各个模型中用到的参数分析图，可以看到随着层数的增加A-E，参数增加的并不是很多，因此也分析出层数的增加可以提升性能的同时，也不会在参数量的计算存储损耗上，有非常多的增加。

之前的网络都用7x7,11x11等比较大的卷积核，现在全用3x3不会有什么影响吗？ 

实际上，一个5x5可以用两个3x3来近似代替，一个7x7可以用三个3x3的卷积核来代替，不仅提升了判别函数的识别能力，而且还减少了参数；如3个3x3的卷积核，通道数为C，则参数为3x(3x3xCxC)=27C^2，而一个7x7的卷积核，通道数也为C，则参数为(7x7xCxC)=49C^2。 

而1x1卷积层的合并是一种增加决策函数的非线性的方式，而且还没有影响到卷积层的感受野。



   **VGGNet网络特点：**
1.  VGGNet拥有5段卷积，每段卷积内有2-3个卷积层，同时每段尾部都会连接一个最大池化层（用来缩小图片）。
2.  每段内的卷积核数量一样，越后边的段内卷积核数量越多，依次为:64-128-256-512-512
3.  越深的网络效果越好。
4.  LRN层作用不大（作者结论）
5.  1×1的卷积也是很有效的，但是没有3×3的卷积好，大一些的卷积核可以学习更大的空间特征。



# 训练

训练使用加动量的小批基于反向传播的梯度下降法来优化多项逻辑回归目标。批数量为256，动量为0.9，权值衰减参数为5x10−410−4，在前两个全连接层使用dropout为0.5，学习率为0.01，且当验证集停止提升时以10的倍数衰减，同时，初始化权重取样于高斯分布N（0，0.01），偏置项初始化为0。 

为了获得初始化的224x224大小的图片，通过在每张图片在每次随机梯度下降SGB时进行一次裁减，为了更进一步的增加训练集，对每张图片进行水平翻转以及进行随机RGB色差调整。 

初始对原始图片进行裁剪时，原始图片的最小边不宜过小，这样的话，裁剪到224x224的时候，就相当于几乎覆盖了整个图片，这样对原始图片进行不同的随机裁剪得到的图片就基本上没差别，就失去了增加数据集的意义，但同时也不宜过大，这样的话，裁剪到的图片只含有目标的一小部分，也不是很好。 

针对上述裁剪的问题，提出的两种解决办法：  

1. 固定最小遍的尺寸为256。
2. 随机从[256,512]的确定范围内进行抽样，这样原始图片尺寸不一，有利于训练，这个方法叫做尺度抖动scal jittering，有利于训练集增强。 训练时运用大量的裁剪图片有利于提升识别精确率。

# 测试

测试图片的尺寸不一定要与训练图片的尺寸相同，且不需要裁剪。 

测试的时候，首先将全连接层转换到卷积层，第一个全连接层转换到一个7x7的卷积层，后面两个转换到1x1的卷积层，这不仅让全连接网应用到整个未裁剪的整个原始图像上，而且得到一个类别的得分图，其通道数等于类别数，还有一个决定与输入图片尺寸的可变空间分辨率。为了获得固定尺寸的图片的得分图，运用原始图片的softmax的后验概率以及其水平翻转的平均来获得。 

# 补充

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N07-VGGNet-20201215-224442-871522.png)

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N07-VGGNet-20201215-224442-885403.png)

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N07-VGGNet-20201215-224442-906376.png)

        将5*5*3 换成 1*1 * n 相当于通道降维
    
        为什么一个段内有多个3*3的卷积层堆叠？
        这是个非常有用的设计。如下图所示，2个3*3的卷积层串联相当于1个5*5的卷积层，即一个像素会跟周围5*5的像素产生关联，可以说感受野大小为5*5。而3个3*3的卷积层相当于1个7*7的卷积层。并且，两个3*3的卷积层的参数比1个5*5的更少，前者为2*3*3=18，后者为1*5*5=25。
        更重要的是，2个3*3的卷积层比1个5*5的卷积层有更多的非线性变换（前者可使用2次ReLu函数，后者只有两次），这使得CNN对特征的学习能力更强。
    
        所以3*3的卷积层堆叠的优点为：
        （1）参数量更小
        （2）小的卷积层比大的有更多的非线性变换，使得CNN对特征的学习能力更强。
    
        训练技巧：
            1.先训练浅层网络如A，再去训练深层网络
            2.多尺寸输入
                不同的尺寸训练多个分类器，然后做ensemble
                随机使用不同的尺寸缩放然后输入进分类器进行训练


# 基于TF的VGG代码实现-卢云

DL_VGG实现十分类(简化版)_v20190731


```python
import tensorflow as tf
import os
import pickle
import numpy as np

CIFAR_DIR = "F:\datasets\cifar-10-batches-py"
print(os.listdir(CIFAR_DIR))
```

    ['batches.meta', 'data_batch_1', 'data_batch_2', 'data_batch_3', 'data_batch_4', 'data_batch_5', 'readme.html', 'test_batch']



```python
def load_data(filename):
    """read data from data file."""
    with open(filename, 'rb') as f:
        data = pickle.load(f, encoding='bytes')
        return data[b'data'], data[b'labels']
```


```python
# tensorflow.Dataset.
class CifarData:
    def __init__(self, filenames, need_shuffle):
        all_data = []
        all_labels = []
        for filename in filenames:
            data, labels = load_data(filename)
            all_data.append(data)
            all_labels.append(labels)
        self._data = np.vstack(all_data)
        self._data = self._data / 127.5 - 1
        self._labels = np.hstack(all_labels)
        print(self._data.shape)
        print(self._labels.shape)
        
        self._num_examples = self._data.shape[0]
        self._need_shuffle = need_shuffle
        self._indicator = 0
        if self._need_shuffle:
            self._shuffle_data()
            
    def _shuffle_data(self):
        # [0,1,2,3,4,5] -> [5,3,2,4,0,1]
        p = np.random.permutation(self._num_examples)
        self._data = self._data[p]
        self._labels = self._labels[p]
    
    def next_batch(self, batch_size):
        """return batch_size examples as a batch."""
        end_indicator = self._indicator + batch_size
        if end_indicator > self._num_examples:
            if self._need_shuffle:
                self._shuffle_data()
                self._indicator = 0
                end_indicator = batch_size
            else:
                raise Exception("have no more examples")
                
        if end_indicator > self._num_examples:
            raise Exception("batch size is larger than all examples")
            
        batch_data = self._data[self._indicator: end_indicator]
        batch_labels = self._labels[self._indicator: end_indicator]
        self._indicator = end_indicator
        return batch_data, batch_labels

train_filenames = [os.path.join(CIFAR_DIR, 'data_batch_%d' % i) for i in range(1, 6)]
test_filenames = [os.path.join(CIFAR_DIR, 'test_batch')]

train_data = CifarData(train_filenames, True)
test_data = CifarData(test_filenames, False)
```

    (50000, 3072)
    (50000,)
    (10000, 3072)
    (10000,)



```python
x = tf.placeholder(tf.float32, [None, 3072])
y = tf.placeholder(tf.int64, [None])
# [None], eg: [0,5,6,3]
x_image = tf.reshape(x, [-1, 3, 32, 32])
# 32*32
x_image = tf.transpose(x_image, perm=[0, 2, 3, 1])

# conv1: 神经元图， feature_map, 输出图像
conv1_1 = tf.layers.conv2d(inputs=x_image,
                           filters=32, # output channel number
                           kernel_size=(3,3), # kernel size
                           padding = 'same',
                           activation = tf.nn.relu,
                           name = 'conv1_1')
conv1_2 = tf.layers.conv2d(conv1_1,
                           32, # output channel number
                           (3,3), # kernel size
                           padding = 'same',
                           activation = tf.nn.relu,
                           name = 'conv1_2')

# 16 * 16
pooling1 = tf.layers.max_pooling2d(inputs=conv1_2,
                                   pool_size=(2, 2), # kernel size
                                   strides=(2, 2), # stride
                                   name = 'pool1')


conv2_1 = tf.layers.conv2d(pooling1,
                           32, # output channel number
                           (3,3), # kernel size
                           padding = 'same',
                           activation = tf.nn.relu,
                           name = 'conv2_1')
conv2_2 = tf.layers.conv2d(conv2_1,
                           32, # output channel number
                           (3,3), # kernel size
                           padding = 'same',
                           activation = tf.nn.relu,
                           name = 'conv2_2')
# 8 * 8
pooling2 = tf.layers.max_pooling2d(conv2_2,
                                   (2, 2), # kernel size
                                   (2, 2), # stride
                                   name = 'pool2')

conv3_1 = tf.layers.conv2d(pooling2,
                           32, # output channel number
                           (3,3), # kernel size
                           padding = 'same',
                           activation = tf.nn.relu,
                           name = 'conv3_1')
conv3_2 = tf.layers.conv2d(conv3_1,
                           32, # output channel number
                           (3,3), # kernel size
                           padding = 'same',
                           activation = tf.nn.relu,
                           name = 'conv3_2')
# 4 * 4 * 32
pooling3 = tf.layers.max_pooling2d(conv3_2,
                                   (2, 2), # kernel size
                                   (2, 2), # stride
                                   name = 'pool3')
# [None, 4 * 4 * 32]
flatten = tf.layers.flatten(pooling3)
y_ = tf.layers.dense(flatten, 10)

loss = tf.losses.sparse_softmax_cross_entropy(labels=y, logits=y_)
# y_ -> sofmax
# y -> one_hot
# loss = ylogy_

# indices
predict = tf.argmax(y_, 1)
# [1,0,1,1,1,0,0,0]
correct_prediction = tf.equal(predict, y)
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float64))

with tf.name_scope('train_op'):
    train_op = tf.train.AdamOptimizer(1e-3).minimize(loss)
```


```python
init = tf.global_variables_initializer()
batch_size = 20
train_steps = 100
test_steps = 100

# train 10k: 73.4%
with tf.Session() as sess:
    sess.run(init)
    for i in range(train_steps):
        batch_data, batch_labels = train_data.next_batch(batch_size)
        loss_val, acc_val, _ = sess.run(
            [loss, accuracy, train_op],
            feed_dict={
                x: batch_data,
                y: batch_labels})
        if (i+1) % 10 == 0:
            print('[Train] Step: %d, loss: %4.5f, acc: %4.5f' 
                  % (i+1, loss_val, acc_val))
        if (i+1) % 10 == 0:
            test_data = CifarData(test_filenames, False)
            all_test_acc_val = []
            for j in range(test_steps):
                test_batch_data, test_batch_labels \
                    = test_data.next_batch(batch_size)
                test_acc_val = sess.run(
                    [accuracy],
                    feed_dict = {
                        x: test_batch_data, 
                        y: test_batch_labels
                    })
                all_test_acc_val.append(test_acc_val)
            test_acc = np.mean(all_test_acc_val)
            print('[Test ] Step: %d, acc: %4.5f' % (i+1, test_acc))
    print("*"*50)
                
                
            
```

# 基于TF的VGG代码实现（2）


```python
# -*- coding:utf-8 -*-
import tensorflow as tf
import math
import time
from datetime import datetime
```


```python
def conv_op(input, kh, kw, n_out, dh, dw, parameters, name):
    """
    定义卷积层的操作
    :param input: 输入的tensor
    :param kh:卷积核的高
    :param kw:卷积核的宽
    :param n_out:输出通道数（即卷积核的数量）
    :param dh:步长的高
    :param dw:步长的宽
    :param parameters:参数列表
    :param name:层的名字
    :return:返回卷积层的结果
    """

    n_in = input.get_shape()[-1].value  #通道数

    with tf.name_scope(name) as scope:
        kernel = tf.get_variable(
            scope + 'w',
            shape=[kh, kw, n_in, n_out],
            dtype=tf.float32,
            initializer=tf.contrib.layers.xavier_initializer_conv2d())
        conv = tf.nn.conv2d(
            input=nputsinput,
            filter=kernel,
            strides=[1, dh, dw, 1],
            padding='SAME')
        biases = tf.Variable(
            tf.constant(0.0, shape=[n_out], dtype=tf.float32),
            trainable=True,
            name='b')
        z = tf.nn.bias_add(conv, biases)  # wx+b
        activation = tf.nn.relu(z, name=scope)
        parameters += [kernel, biases]
        return activation
```


```python
def fc_op(input, n_out, parameters, name):
    """
    定义全连接层操作
    注意：卷积层的结果要做扁平化才能和fc层相连接
    :param input: 输入的tensor
    :param n_out: 输出通道数（即神经元的数量）
    :param parameters: 参数列表
    :param name: 层的名字
    :return: 返回全连接层的结果
    """

    n_in = input.get_shape()[-1].value

    with tf.name_scope(name) as scope:
        kernel = tf.get_variable(
            scope + 'w',
            shape=[n_in, n_out],
            dtype=tf.float32,
            initializer=tf.contrib.layers.xavier_initializer())

        biases = tf.Variable(
            tf.constant(0.1, shape=[n_out], dtype=tf.float32),
            trainable=True,
            name='b')
        activation = tf.nn.relu(tf.matmul(input, kernel) + biases, name=scope)
        parameters += [kernel, biases]
        return activation
```


```python
def maxPool_op(input, kh, kw, dh, dw, name):
    return tf.nn.max_pool(
        input,
        ksize=[1, kh, kw, 1],
        strides=[1, dh, dw, 1],
        padding='SAME',
        name=name)
```


```python
def vggNet(input, keep_prob):
    parameters = []

    #conv1段
    conv1_1 = conv_op(input,
                      kh=3,
                      kw=3,
                      n_out=64,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv1_1')

    conv1_2 = conv_op(conv1_1,
                      kh=3,
                      kw=3,
                      n_out=64,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv1_2')

    pool1 = maxPool_op(conv1_2, kh=2, kw=2, dh=2, dw=2, name='pool1')

    # conv2段
    conv2_1 = conv_op(pool1,
                      kh=3,
                      kw=3,
                      n_out=128,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv2_1')

    conv2_2 = conv_op(conv2_1,
                      kh=3,
                      kw=3,
                      n_out=128,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv2_2')

    pool2 = maxPool_op(conv2_2, kh=2, kw=2, dh=2, dw=2, name='pool2')

    # conv3段
    conv3_1 = conv_op(pool2,
                      kh=3,
                      kw=3,
                      n_out=256,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv3_1')

    conv3_2 = conv_op(conv3_1,
                      kh=3,
                      kw=3,
                      n_out=256,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv3_2')

    conv3_3 = conv_op(conv3_2,
                      kh=3,
                      kw=3,
                      n_out=256,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv3_3')

    pool3 = maxPool_op(conv3_3, kh=2, kw=2, dh=2, dw=2, name='pool3')

    # conv4段
    conv4_1 = conv_op(pool3,
                      kh=3,
                      kw=3,
                      n_out=512,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv4_1')

    conv4_2 = conv_op(conv4_1,
                      kh=3,
                      kw=3,
                      n_out=512,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv4_2')

    conv4_3 = conv_op(conv4_2,
                      kh=3,
                      kw=3,
                      n_out=512,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv4_3')

    pool4 = maxPool_op(conv4_3, kh=2, kw=2, dh=2, dw=2, name='pool4')

    # conv5段
    conv5_1 = conv_op(pool4,
                      kh=3,
                      kw=3,
                      n_out=512,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv5_1')

    conv5_2 = conv_op(conv5_1,
                      kh=3,
                      kw=3,
                      n_out=512,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv5_2')

    conv5_3 = conv_op(conv5_2,
                      kh=3,
                      kw=3,
                      n_out=512,
                      dh=1,
                      dw=1,
                      parameters=parameters,
                      name='conv5_3')

    pool5 = maxPool_op(conv5_3, kh=2, kw=2, dh=2, dw=2, name='pool5')

    #将最后一个卷积层的结果扁平化:每个样本占一行
    conv_shape = pool5.get_shape()
    col = conv_shape[1].value * conv_shape[2].value * conv_shape[3].value
    flat = tf.reshape(pool5, [-1, col], name='flat')

    # fc6段
    fc6 = fc_op(input=flat, n_out=4096, parameters=parameters, name='fc6')
    fc6_dropout = tf.nn.dropout(fc6, keep_prob, name='fc6_drop')

    # fc7段
    fc7 = fc_op(input=fc6_dropout,
                n_out=4096,
                parameters=parameters,
                name='fc7')
    fc7_dropout = tf.nn.dropout(fc7, keep_prob, name='fc7_drop')

    # fc8段：最后一个全连接层，使用softmax进行处理得到分类输出概率
    fc8 = fc_op(input=fc7_dropout,
                n_out=1000,
                parameters=parameters,
                name='fc8')
    softmax = tf.nn.softmax(fc8)
    predictions = tf.arg_max(softmax, 1)
    return predictions, softmax, fc8, parameters
```


```python
def time_compute(session, target, feed, info_string):
    num_batch = 100  #100
    num_step_burn_in = 10  # 预热轮数，头几轮迭代有显存加载、cache命中等问题可以因此跳过
    total_duration = 0.0  # 总时间
    total_duration_squared = 0.0
    for i in range(num_batch + num_step_burn_in):
        start_time = time.time()
        _ = session.run(target, feed_dict=feed)
        duration = time.time() - start_time
        if i >= num_step_burn_in:
            if i % 10 == 0:  # 每迭代10次显示一次duration
                print("%s: step %d,duration=%.5f " %
                      (datetime.now(), i - num_step_burn_in, duration))
            total_duration += duration
            total_duration_squared += duration * duration
    time_mean = total_duration / num_batch
    time_variance = total_duration_squared / num_batch - time_mean * time_mean
    time_stddev = math.sqrt(time_variance)
    # 迭代完成，输出
    print("%s: %s across %d steps,%.3f +/- %.3f sec per batch " %
          (datetime.now(), info_string, num_batch, time_mean, time_stddev))

```


```python
def main():
    with tf.Graph().as_default():
        """仅使用随机图片数据 测试前馈和反馈计算的耗时"""
        image_size = 224
        batch_size = 2  #32

        images = tf.Variable(
            tf.random_normal([batch_size, image_size, image_size, 3],
                             dtype=tf.float32,
                             stddev=0.1))

        keep_prob = tf.placeholder(tf.float32)
        predictions, softmax, fc8, parameters = vggNet(images, keep_prob)

        init = tf.global_variables_initializer()
        sess = tf.Session()
        sess.run(init)
        """
        AlexNet forward 计算的测评
        传入的target:fc8（即最后一层的输出）
        优化目标：loss
        使用tf.gradients求相对于loss的所有模型参数的梯度
 
 
        AlexNet Backward 计算的测评
        target:grad
 
        """
        time_compute(
            sess, target=fc8, feed={keep_prob: 1.0}, info_string="Forward")

        obj = tf.nn.l2_loss(fc8)
        grad = tf.gradients(obj, parameters)
        time_compute(
            sess, grad, feed={keep_prob: 0.5}, info_string="Forward-backward")


if __name__ == "__main__":
    main()
```

# Pytorch实现


```python
import sys
sys.path.append('..')

import numpy as np
import torch
from torch import nn
from torch.autograd import Variable
from torchvision.datasets import CIFAR10
```

我们可以定义一个 vgg 的 block，传入三个参数，第一个是模型层数，第二个是输入的通道数，第三个是输出的通道数，第一层卷积接受的输入通道就是图片输入的通道数，然后输出最后的输出通道数，后面的卷积接受的通道数就是最后的输出通道数


```python
def vgg_block(num_convs, in_channels, out_channels):
    net = [nn.Conv2d(in_channels, out_channels, kernel_size=3, padding=1), nn.ReLU(True)] # 定义第一层
    
    for i in range(num_convs-1): # 定义后面的很多层
        net.append(nn.Conv2d(out_channels, out_channels, kernel_size=3, padding=1))
        net.append(nn.ReLU(True))
        
    net.append(nn.MaxPool2d(2, 2)) # 定义池化层
    return nn.Sequential(*net)
```

我们可以将模型打印出来看看结构


```python
block_demo = vgg_block(3, 64, 128)
print(block_demo)
```


```python
# 首先定义输入为 (1, 64, 300, 300)
input_demo = Variable(torch.zeros(1, 64, 300, 300))
output_demo = block_demo(input_demo)
print(output_demo.shape)
```

可以看到输出就变为了 (1, 128, 150, 150)，可以看到经过了这一个 vgg block，输入大小被减半，通道数变成了 128

下面我们定义一个函数对这个 vgg block 进行堆叠


```python
def vgg_stack(num_convs, channels):
    net = []
    for n, c in zip(num_convs, channels):
        in_c = c[0]
        out_c = c[1]
        net.append(vgg_block(n, in_c, out_c))
    return nn.Sequential(*net)
```

作为实例，我们定义一个稍微简单一点的 vgg 结构，其中有 8 个卷积层


```python
vgg_net = vgg_stack((1, 1, 2, 2, 2), ((3, 64), (64, 128), (128, 256), (256, 512), (512, 512)))
print(vgg_net)
```

我们可以看到网络结构中有个 5 个 最大池化，说明图片的大小会减少 5 倍，我们可以验证一下，输入一张 256 x 256 的图片看看结果是什么


```python
test_x = Variable(torch.zeros(1, 3, 256, 256))
test_y = vgg_net(test_x)
print(test_y.shape)
```

可以看到图片减小了 $2^5$ 倍，最后再加上几层全连接，就能够得到我们想要的分类输出


```python
class vgg(nn.Module):
    def __init__(self):
        super(vgg, self).__init__()
        self.feature = vgg_net
        self.fc = nn.Sequential(
            nn.Linear(512, 100),
            nn.ReLU(True),
            nn.Linear(100, 10)
        )
        
    def forward(self, x):
        x = self.feature(x)
        x = x.view(x.shape[0], -1)
        x = self.fc(x)
        return x
```

然后我们可以训练我们的模型看看在 cifar10 上的效果。


```python
from utils import train

def data_tf(x):
    x = np.array(x, dtype='float32') / 255
    x = (x - 0.5) / 0.5 # 标准化，这个技巧之后会讲到
    x = x.transpose((2, 0, 1)) # 将 channel 放到第一维，只是 pytorch 要求的输入方式
    x = torch.from_numpy(x)
    return x

train_set = CIFAR10('./data', train=True, transform=data_tf)
train_data = torch.utils.data.DataLoader(train_set, batch_size=64, shuffle=True)
test_set = CIFAR10('./data', train=False, transform=data_tf)
test_data = torch.utils.data.DataLoader(test_set, batch_size=128, shuffle=False)

net = vgg()
optimizer = torch.optim.SGD(net.parameters(), lr=1e-1)
criterion = nn.CrossEntropyLoss()
```


```python
train(net, train_data, test_data, 20, optimizer, criterion)
```

可以看到，跑完 20 次，vgg 能在 cifar 10 上取得 76% 左右的测试准确率
