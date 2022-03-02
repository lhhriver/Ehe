深层网络遇到的问题：

1. 更深的网络容易过拟合
2. 更深的网络有更大的计算量：稀疏网络虽然减少了参数但没有减少计算量

# V1结构

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N10-InceptionNet-20201215-224443-294681.png)



![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N10-InceptionNet-20201215-224443-315730.png)

Inception优势

1. 一层上同时使用多种卷积核，看到各种层级的feature。
2. 不同组时间的feature不交叉计算，减少计算量。

## V1结构的卷积计算量

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N10-InceptionNet-20201215-224443-619106.png)

参数个数

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N10-InceptionNet-20201215-224443-624044.png)

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N10-InceptionNet-20201215-224443-636018.png)

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N10-InceptionNet-20201215-224443-424714.png)

# V2结构

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N10-InceptionNet-20201215-224443-464852.png)

用两个3×3替换5×5

# V3结构

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N10-InceptionNet-20201215-224443-543202.png)

用一个1×3和一个3×1替换3×3



![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N10-InceptionNet-20201215-224443-583121.png)

# V4结构

inceptionNet和ResNet组合

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N10-InceptionNet-20201215-224443-602083.png)

# 基于TensorFlow的V1结构代码实现


```python
import tensorflow as tf
import os
import pickle
import numpy as np

CIFAR_DIR = "D:\Pr_Anchor\Part03-Dataset\CIFAR10\cifar-10-batches-py"
print(os.listdir(CIFAR_DIR))
```

    ['batches.meta', 'data_batch_1', 'data_batch_2', 'data_batch_3', 'data_batch_4', 'data_batch_5', 'readme.html', 'test_batch']



```python
def load_data(filename):
    """read data from data file."""
    with open(filename, 'rb') as f:
        data = pickle.load(f, encoding='bytes')
        return data[b'data'], data[b'labels']

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
def inception_block(x, output_channel_for_each_path, name):
    """inception block implementation"""
    """
    Args:
    - x:
    - output_channel_for_each_path: eg: [10, 20, 5]
    - name:
    """
    with tf.variable_scope(name):
        conv1_1 = tf.layers.conv2d(
            x,
            output_channel_for_each_path[0], (1, 1),
            strides=(1, 1),
            padding='same',
            activation=tf.nn.relu,
            name='conv1_1')
        conv3_3 = tf.layers.conv2d(
            x,
            output_channel_for_each_path[1], (3, 3),
            strides=(1, 1),
            padding='same',
            activation=tf.nn.relu,
            name='conv3_3')
        conv5_5 = tf.layers.conv2d(
            x,
            output_channel_for_each_path[2], (5, 5),
            strides=(1, 1),
            padding='same',
            activation=tf.nn.relu,
            name='conv5_5')
        max_pooling = tf.layers.max_pooling2d(
            x, (2, 2), (2, 2), name='max_pooling')

    max_pooling_shape = max_pooling.get_shape().as_list()[1:]
    input_shape = x.get_shape().as_list()[1:]
    width_padding = (input_shape[0] - max_pooling_shape[0]) // 2
    height_padding = (input_shape[1] - max_pooling_shape[1]) // 2
    padded_pooling = tf.pad(max_pooling,
                            [[0, 0], [width_padding, width_padding],
                             [height_padding, height_padding], [0, 0]])
    concat_layer = tf.concat([conv1_1, conv3_3, conv5_5, padded_pooling],
                             axis=3)
    return concat_layer
```


```python
x = tf.placeholder(tf.float32, [None, 3072])
y = tf.placeholder(tf.int64, [None])
# [None], eg: [0,5,6,3]
x_image = tf.reshape(x, [-1, 3, 32, 32])
# 32*32
x_image = tf.transpose(x_image, perm=[0, 2, 3, 1])

# conv1: 神经元图， feature_map, 输出图像
conv1 = tf.layers.conv2d(
    x_image,
    32,  # output channel number
    (3, 3),  # kernel size
    padding='same',
    activation=tf.nn.relu,
    name='conv1')

pooling1 = tf.layers.max_pooling2d(
    conv1,
    (2, 2),  # kernel size
    (2, 2),  # stride
    name='pool1')

inception_2a = inception_block(pooling1, [16, 16, 16], name='inception_2a')
inception_2b = inception_block(inception_2a, [16, 16, 16], name='inception_2b')

pooling2 = tf.layers.max_pooling2d(
    inception_2b,
    (2, 2),  # kernel size
    (2, 2),  # stride
    name='pool2')

inception_3a = inception_block(pooling2, [16, 16, 16], name='inception_3a')
inception_3b = inception_block(inception_3a, [16, 16, 16], name='inception_3b')

pooling3 = tf.layers.max_pooling2d(
    inception_3b,
    (2, 2),  # kernel size
    (2, 2),  # stride
    name='pool3')

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

# train 10k: 74.65%
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
            print ('[Test ] Step: %d, acc: %4.5f' % (i+1, test_acc))

            
```

    [Train] Step: 10, loss: 2.25442, acc: 0.10000
    (10000, 3072)
    (10000,)
    [Test ] Step: 10, acc: 0.16200
    [Train] Step: 20, loss: 2.11343, acc: 0.25000
    (10000, 3072)
    (10000,)
    [Test ] Step: 20, acc: 0.19750
    [Train] Step: 30, loss: 2.19395, acc: 0.15000
    (10000, 3072)
    (10000,)
    [Test ] Step: 30, acc: 0.21550
    [Train] Step: 40, loss: 1.92940, acc: 0.40000
    (10000, 3072)
    (10000,)
    [Test ] Step: 40, acc: 0.19300
    [Train] Step: 50, loss: 2.44389, acc: 0.20000
    (10000, 3072)
    (10000,)
    [Test ] Step: 50, acc: 0.27050
    [Train] Step: 60, loss: 2.12770, acc: 0.15000
    (10000, 3072)
    (10000,)
    [Test ] Step: 60, acc: 0.26800
    [Train] Step: 70, loss: 1.82913, acc: 0.30000
    (10000, 3072)
    (10000,)
    [Test ] Step: 70, acc: 0.30650
    [Train] Step: 80, loss: 2.23938, acc: 0.15000
    (10000, 3072)
    (10000,)
    [Test ] Step: 80, acc: 0.23200
    [Train] Step: 90, loss: 1.55900, acc: 0.45000
    (10000, 3072)
    (10000,)
    [Test ] Step: 90, acc: 0.34800
    [Train] Step: 100, loss: 1.50096, acc: 0.50000
    (10000, 3072)
    (10000,)
    [Test ] Step: 100, acc: 0.32750



```python

```


```python

```
