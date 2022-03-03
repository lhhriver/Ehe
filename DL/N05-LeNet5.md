<center><font color=steel size=14>LeNet5</font></center>

# 介绍

LeNet5诞生于1998年，是最早的卷积神经网络之一，并且推动了深度学习领域的发展。自从1988年开始，在许多次成功的迭代后，这项由 Yann LeCun 完成的开拓性成果被命名为 LeNet5。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N05-LeNet5-20201215-224442-842885.png)



LeNet分为**卷积层块**和**全连接层块**两个部分。下面我们分别介绍这两个模块。

卷积层块里的基本单位是**卷积层后接最大池化层**：卷积层用来识别图像里的空间模式，如线条和物体局部，之后的最大池化层则用来降低卷积层对位置的敏感性。卷积层块由两个这样的基本单位重复堆叠构成。在卷积层块中，每个卷积层都使用$5\times 5$的窗口，并在输出上使用sigmoid激活函数。第一个卷积层输出通道数为6，第二个卷积层输出通道数则增加到16。这是因为第二个卷积层比第一个卷积层的输入的高和宽要小，所以增加输出通道使两个卷积层的参数尺寸类似。卷积层块的两个最大池化层的窗口形状均为$2\times 2$，且步幅为2。由于池化窗口与步幅形状相同，池化窗口在输入上每次滑动所覆盖的区域互不重叠。

卷积层块的输出形状为(批量大小, 通道, 高, 宽)。当卷积层块的输出传入全连接层块时，全连接层块会将小批量中每个样本变平（flatten）。也就是说，全连接层的输入形状将变成二维，其中第一维是小批量中的样本，第二维是每个样本变平后的向量表示，且向量长度为通道、高和宽的乘积。全连接层块含3个全连接层。它们的输出个数分别是120、84和10，其中10为输出的类别个数。

---

1998， Yann LeCun 的 LeNet5 卷积神经网路的开山之作，麻雀虽小，但五脏俱全，卷积层、pooling层、全连接层，这些都是现代CNN网络的基本组件。

   - 用卷积提取空间特征；
   - 由空间平均得到子样本；
   - 用 tanh 或 sigmoid 得到非线性；
   - 用 multi-layer neural network（MLP）作为最终分类器；
   - 层层之间用稀疏的连接矩阵，以避免大的计算成本。

**输入**：图像Size为32\*32。这要比mnist数据库中最大的字母(28\*28)还大。这样做的目的是希望潜在的明显特征，如笔画断续、角点能够出现在最高层特征监测子感受野的中心。

**输出**：10个类别，分别为0-9数字的概率



以上图为例，对经典的LeNet-5做深入分析：
1. 首先输入图像是单通道的32\*32大小的图像，用矩阵表示就是[1,32,32]。
2. 第一个卷积层conv1所用的卷积核尺寸为5\*5，滑动步长为1，卷积核数目为6，那么经过该层后图像尺寸变为28，32-5+1=28，输出矩阵为[6,28,28]。
3. 第一个池化层pool核尺寸为2\*2，步长2，这是没有重叠的max pooling，池化操作后，图像尺寸减半，变为14×14，输出矩阵为[6,14,14]。
4. 第二个卷积层conv2的卷积核尺寸为5\*5，步长1，卷积核数目为16，卷积后图像尺寸变为10,这是因为14-5+1=10，输出矩阵为[16,10,10]。
5. 第二个池化层pool2核尺寸为2\*2，步长2，这是没有重叠的max pooling，池化操作后，图像尺寸减半，变为5×5，输出矩阵为[16,5,5]。
6. pool2后面接全连接层fc1，神经元数目为16\*5\*5-->120，再接relu激活函数。
7. 再接fc2，神经元个数为120-->84。
8. 再接fc3，神经元个数为84-->10，得到10维的特征向量，用于10个数字的分类训练，送入softmaxt分类，得到分类结果的概率output。

​       LeNet5的架构基于这样的观点：（尤其是）图像的特征分布在整张图像上，以及带有可学习参数的卷积是一种用少量参数在多个位置上提取相似特征的有效方式。在那时候，没有 GPU 帮助训练，甚至 CPU 的速度也很慢。因此，能够保存参数以及计算过程是一个关键进展。这和将每个像素用作一个大型多层神经网络的单独输入相反。LeNet5 阐述了那些像素不应该被使用在第一层，因为图像具有很强的空间相关性，而使用图像中独立的像素作为不同的输入特征则利用不到这些相关性。



LeNet5特征能够总结为如下几点：
1. 卷积神经网络使用三个层作为一个系列： 卷积，池化，非线性。
2. 使用卷积提取空间特征。
3. 使用映射到空间均值下采样（subsample）。
4. 双曲线（tanh）或 S型（sigmoid）形式的非线性。
5. 多层神经网络（MLP）作为最后的分类器。
6. 层与层之间的稀疏连接矩阵避免大的计算成本。

​     总体看来，这个网络是最近大量神经网络架构的起点，并且也给这个领域带来了许多灵感。



# Pytorch实现

## 官方版


```python
import torchvision

print(dir(torchvision.models)) 
```


```python
import torch
import torch.nn as nn
import torch.nn.functional as F
```


```python
print(help(F.relu))
```


```python
class LeNet5(nn.Module):
    def __init__(self):
        super(LeNet5, self).__init__()
        # 1 , 6 , 5x5
        # kernel
        self.conv1 = nn.Conv2d(in_channels=1,  # input image channel
                               out_channels=6,  # output channels
                               kernel_size=5  # square convolution
                               )

        self.conv2 = nn.Conv2d(in_channels=6,  #
                               out_channels=16,
                               kernel_size=5
                              )

        # an affine operation: y = Wx + b
        self.fc1 = nn.Linear(16 * 5 * 5,  #
                             120
                            )

        self.fc2 = nn.Linear(in_features=120,  #
                             out_features=84
                            )

        self.fc3 = nn.Linear(in_features=84,  #
                             out_features=10
                            )

    def forward(self, x):
        # Max pooling over a (2, 2) window
        x = F.max_pool2d(input=F.relu(self.conv1(x)),  #
                         kernel_size=(2, 2)
                        )

        # If the size is a square you can only specify a single number
        x = F.max_pool2d(input=F.relu(self.conv2(x)),  #
                         kernel_size=2
                        )

        x = x.view(-1, self.num_flat_features(x))

        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        x = self.fc3(x)
        return x

    def num_flat_features(self, x):
        size = x.size()[1:]  # all dimensions except the batch dimension
        num_features = 1
        
        for s in size:
            num_features *= s
        return num_features

net = LeNet5()
print(net)
```


```python
params = list(net.parameters())
print(len(params))
print(params[0].size())  # conv1's .weight
```


```python
input = torch.randn(1, 1, 32, 32)
out = net(input)
print(out)
```


```python
net.zero_grad()
out.backward(torch.randn(1, 10))
```

## 民间版


```python
import torch
import torchvision
from torch.utils.data import DataLoader
from torchvision.datasets import MNIST
from torchvision import transforms
from torch.autograd import Variable
from torch import optim
import torch.nn as nn
import torch.nn.functional as F
import time

learning_rate = 1e-3
batch_size = 64
epoches = 10

trans_img = transforms.ToTensor()

trainset = MNIST(root='./data',  #
                 train=True,
                 download=True,
                 transform=trans_img)

testset = MNIST(root='./data',  #
                train=False,
                download=True,
                transform=trans_img)

trainloader = DataLoader(trainset,  #
                         batch_size=batch_size,
                         shuffle=True,
                         num_workers=4)

testloader = DataLoader(testset,  #
                        batch_size=batch_size,
                        shuffle=False,
                        num_workers=4)
```


```python
print(help(nn.MaxPool2d))
```



```python
# build network
class Lenet(nn.Module):
    def __init__(self):
        super(Lenet, self).__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(in_channels=1,  #
                      out_channels=6,
                      kernel_size=(3, 3),
                      stride=(1, 1),
                      padding=1  # 
                      ),
            nn.MaxPool2d(kernel_size=2,  #
                         stride=2,
                         padding=0  #
                         ),
            nn.Conv2d(in_channels=6,  #
                      out_channels=16,
                      kernel_size=(5, 5),
                      stride=(1, 1),
                      padding=0  # 
                      ),
            nn.MaxPool2d(kernel_size=2,  #
                         stride=2,
                         padding=0  #
                         ))

        self.fc = nn.Sequential(
            nn.Linear(in_features=16 * 5 * 5,  #
                      out_features=120,
                      bias=True),  #
            nn.Linear(120, 84),  #
            nn.Linear(84, 10)  #
        )

    def forward(self, x):
        out = self.conv(x)
        out = out.view(out.size(0), -1)
        out = self.fc(out)
        return out
```


```python
lenet = Lenet()
print(lenet)
```

    Lenet(
      (conv): Sequential(
        (0): Conv2d(1, 6, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1))
        (1): MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False)
        (2): Conv2d(6, 16, kernel_size=(5, 5), stride=(1, 1))
        (3): MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False)
      )
      (fc): Sequential(
        (0): Linear(in_features=400, out_features=120, bias=True)
        (1): Linear(in_features=120, out_features=84, bias=True)
        (2): Linear(in_features=84, out_features=10, bias=True)
      )
    )



```python
# lenet.cuda()
criterian = nn.CrossEntropyLoss(reduction='sum')
optimizer = optim.SGD(lenet.parameters(), lr=learning_rate)
```


```python
# train
for i in range(epoches):
    since = time.time()
    running_loss = 0.
    running_acc = 0.
    
    for (img, label) in trainloader:
        img = Variable(img)  # img = Variable(img).cuda()
        label = Variable(label)  # label = Variable(label).cuda()

        optimizer.zero_grad()
        output = lenet(img)
        loss = criterian(output, label)
        # backward
        loss.backward()
        optimizer.step()

        running_loss += loss.item()
        _, predict = torch.max(output, 1)
        correct_num = (predict == label).sum()
        running_acc += correct_num.item()

    running_loss /= len(trainset)
    running_acc /= len(trainset)
    print(("[%d/%d] Loss: %.5f, Acc: %.2f, Time: %.2f s" % (
        i + 1, epoches, running_loss, 100 * running_acc, time.time() - since)))

print("Finished Training")
```

    [1/10] Loss: 0.39701, Acc: 87.57, Time: 22.53 s
    [2/10] Loss: 0.10656, Acc: 96.69, Time: 21.71 s
    [3/10] Loss: 0.08275, Acc: 97.48, Time: 23.29 s
    [4/10] Loss: 0.06917, Acc: 97.87, Time: 23.81 s
    [5/10] Loss: 0.06041, Acc: 98.15, Time: 20.59 s
    [6/10] Loss: 0.05388, Acc: 98.35, Time: 23.04 s
    [7/10] Loss: 0.04801, Acc: 98.51, Time: 22.69 s
    [8/10] Loss: 0.04432, Acc: 98.62, Time: 18.72 s
    [9/10] Loss: 0.04174, Acc: 98.69, Time: 20.01 s
    [10/10] Loss: 0.03946, Acc: 98.75, Time: 17.87 s
    Finished Training



```python
# evaluate
lenet.eval()

testloss = 0.
testacc = 0.
for (img, label) in testloader:
    img = Variable(img)  # img = Variable(img).cuda()
    label = Variable(label)  # label = Variable(label).cuda()

    output = lenet(img)
    loss = criterian(output, label)
    testloss += loss.item()
    _, predict = torch.max(output, 1)
    num_correct = (predict == label).sum()
    testacc += num_correct.item()

testloss /= len(testset)
testacc /= len(testset)
print("Test: Loss: %.5f, Acc: %.2f %%" % (testloss, 100 * testacc))
```

# 基于TensorFlow的代码实现


```python
#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data
```



```python
import warnings

warnings.filterwarnings("ignore")
```


```python
# 定义神经网络模型的评估部分
def compute_accuracy(test_xs, test_ys):
    # 使用全局变量prediction
    global prediction
    # 获得预测值y_pre
    y_pre = sess.run(
        prediction,  #
        feed_dict={
            xs: test_xs,
            keep_prob: 1
        })
    # 判断预测值y和真实值y_中最大数的索引是否一致，y_pre的值为1-10概率, 返回值为bool序列
    correct_prediction = tf.equal(
        tf.argmax(y_pre, 1),  
        tf.argmax(test_ys, 1))
    
    # 定义准确率的计算
    # tf.cast将bool转换为float32
    accuracy = tf.reduce_mean(tf.cast(
        correct_prediction,  
        tf.float32))
    
    # 计算准确率
    result = sess.run(accuracy)
    return result
```


```python
# 下载mnist数据
mnist = input_data.read_data_sets(
    'G:\LV_PLAN\算法\Ai_river\datasets\mnist',  # 
    one_hot=True)

# mnist = tf.keras.datasets.mnist.load_data()
```



```python
# 权重参数初始化
def weight_variable(shape):
    initial = tf.truncated_normal(shape, stddev=0.1)  # 截断的正态分布，标准差stddev
    return tf.Variable(initial)


# 偏置参数初始化
def bias_variable(shape):
    initial = tf.constant(0.1, shape=shape)
    return tf.Variable(initial)


# 定义卷积层
def conv2d(x, W):
    # stride的四个参数：[batch, height, width, channels], [batch_size, image_rows, image_cols, number_of_colors]
    # height, width就是图像的高度和宽度，batch和channels在卷积层中通常设为1
    conv2 = tf.nn.conv2d(
        input=x,  #d
        filter=W,  # 滤波器大小
        strides=[1, 1, 1, 1],
        padding='SAME'  #填充方式，补零('SAME')
    )
    return conv2


def max_pool_2x2(x):
    max_pl = tf.nn.max_pool(
        value=x,  #
        ksize=[1, 2, 2, 1],  # 滤波器大小
        strides=[1, 2, 2, 1],  # 步长
        padding='SAME')
    return max_pl
```


```python
# 输入输出数据的placeholder
xs = tf.placeholder(tf.float32, [None, 784])
ys = tf.placeholder(tf.float32, [None, 10])
# dropout的比例
keep_prob = tf.placeholder("float")
```


```python
# 对数据进行重新排列，形成图像
x_image = tf.reshape(xs, [-1, 28, 28, 1])  # -1, 28, 28, 1
print((x_image.shape))
```

    (?, 28, 28, 1)



```python
# 卷积层一
# patch为5*5，in_size为1，即图像的厚度，如果是彩色，则为3，
# 32是out_size，输出的大小-》32个卷积和（滤波器）
W_conv1 = weight_variable([5, 5, 1, 32])
b_conv1 = bias_variable([32])
# ReLU操作，输出大小为28*28*32
h_conv1 = tf.nn.relu(conv2d(x_image, W_conv1) + b_conv1)
# Pooling操作，输出大小为14*14*32
h_pool1 = max_pool_2x2(h_conv1)
```


```python
# 卷积层二
# patch为5*5，in_size为32，即图像的厚度，64是out_size，输出的大小
W_conv2 = weight_variable([5, 5, 32, 64])
b_conv2 = bias_variable([64])
# ReLU操作，输出大小为14*14*64
h_conv2 = tf.nn.relu(conv2d(h_pool1, W_conv2) + b_conv2)
# Pooling操作，输出大小为7*7*64
h_pool2 = max_pool_2x2(h_conv2)
```


```python
# 全连接层一
W_fc1 = weight_variable([7 * 7 * 64, 1024])
b_fc1 = bias_variable([1024])
# 输入数据变换
h_pool2_flat = tf.reshape(h_pool2, [-1, 7 * 7 * 64])  # 整形成m*n,列n为7*7*64
# 进行全连接操作
h_fc1 = tf.nn.relu(tf.matmul(h_pool2_flat, W_fc1) + b_fc1)  # tf.matmul
# 防止过拟合，dropout
h_fc1_drop = tf.nn.dropout(h_fc1, keep_prob)
```


```python
# 全连接层二
W_fc2 = weight_variable([1024, 10])
b_fc2 = bias_variable([10])
```


```python
# 预测
prediction = tf.nn.softmax(tf.matmul(h_fc1_drop, W_fc2) + b_fc2)
```


```python
# 计算loss
cross_entropy = tf.reduce_mean(-tf.reduce_sum(
    ys * tf.log(prediction),  #
    reduction_indices=[1]))
```


```python
# 神经网络训练
train_step = tf.train.AdamOptimizer(0.001).minimize(cross_entropy)  # 0.0001
```


```python
# 定义Session
with tf.Session() as sess:
    # 执行初始化
    sess.run(tf.global_variables_initializer())

    # 进行训练迭代
    for i in range(100):
        # 取出mnist数据集中的100个数据
        batch_xs, batch_ys = mnist.train.next_batch(20)  # 100
        # 执行训练过程并传入真实数据
        sess.run(
            train_step, feed_dict={
                xs: batch_xs,
                ys: batch_ys,
                keep_prob: 0.5
            })
        if i % 10 == 0:
            print((compute_accuracy(mnist.test.images, mnist.test.labels)))
```

