# 介绍

当大家还在惊叹 GoogLeNet 的 inception 结构的时候，微软亚洲研究院的研究员已经在设计更深但结构更加简单的网络 ResNet，并且凭借这个网络子在 2015 年 ImageNet 比赛上大获全胜。

ResNet 有效地解决了深度神经网络难以训练的问题，可以训练高达 1000 层的卷积网络。网络之所以难以训练，是因为存在着梯度消失的问题，离 loss 函数越远的层，在反向传播的时候，梯度越小，就越难以更新，随着层数的增加，这个现象越严重。

之前有两种常见的方案来解决这个问题：

　　1. 按层训练，先训练比较浅的层，然后在不断增加层数，但是这种方法效果不是特别好，而且比较麻烦

　　2. 使用更宽的层，或者增加输出通道，而不加深网络的层数，这种结构往往得到的效果又不好

ResNet 通过引入了跨层链接解决了梯度回传消失的问题。



加深层次的问题：

1. 模型深度达到某个程度后继续加深会导致训练集准确率下降。



加深层次的问题解决：  　

1. 假设：深层网络更难优化而非深层网络学不到东西  
2. 深层网络至少可以和浅层网络持平  
3. y=x ，虽然增加了深度，但误差不会增加  

# 模型结构

## 残差块

让我们聚焦于神经网络局部。如图5.9所示，设输入为$\boldsymbol{x}$。假设我们希望学出的理想映射为$f(\boldsymbol{x})$，从而作为图5.9上方激活函数的输入。左图虚线框中的部分需要直接拟合出该映射$f(\boldsymbol{x})$，而右图虚线框中的部分则需要拟合出有关恒等映射的残差映射$f(\boldsymbol{x})-\boldsymbol{x}$。残差映射在实际中往往更容易优化。

以本节开头提到的恒等映射作为我们希望学出的理想映射$f(\boldsymbol{x})$。我们只需将图5.9中右图虚线框内上方的加权运算（如仿射）的权重和偏差参数学成0，那么$f(\boldsymbol{x})$即为恒等映射。实际中，当理想映射$f(\boldsymbol{x})$极接近于恒等映射时，残差映射也易于捕捉恒等映射的细微波动。图5.9右图也是ResNet的基础块，即**残差块**（residual block）。在残差块中，输入可通过跨层的数据线路更快地向前传播。

<div align=center>
![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N11-ResNet-20201215-224443-648008.svg)
</div>
<div align=center>图5.9 普通的网络结构（左）与加入残差连接的网络结构（右）</div>

ResNet沿用了VGG全$3\times 3$卷积层的设计。残差块里首先有2个有相同输出通道数的$3\times 3$卷积层。每个卷积层后接一个批量归一化层和ReLU激活函数。然后我们将输入跳过这两个卷积运算后直接加在最后的ReLU激活函数前。这样的设计要求两个卷积层的输出与输入形状一样，从而可以相加。如果想改变通道数，就需要引入一个额外的$1\times 1$卷积层来将输入变换成需要的形状后再做相加运算。



> 描述二：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N11-ResNet-20201215-224443-685928.png)

这就普通的网络连接跟跨层残差连接的对比图，使用普通的连接，上层的梯度必须要一层一层传回来，而是用残差连接，相当于中间有了一条更短的路，梯度能够从这条更短的路传回来，避免了梯度过小的情况。

假设某层的输入是 x，期望输出是 H(x)， 如果我们直接把输入 x 传到输出作为初始结果，这就是一个更浅层的网络，更容易训练，而这个网络没有学会的部分，我们可以使用更深的网络 F(x) 去训练它，使得训练更加容易，最后希望拟合的结果就是 F(x) = H(x) - x，这就是一个残差的结构

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N11-ResNet-20201215-224443-650998.png)

​	残差结构使得网络需要学习的知识变少，容易学习。

​    残差结构使得每一层的数据分布接近，容易学习。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N11-ResNet-20201215-224443-658980.png)

两种形态的残差模块，左图是常规残差模块，有两个3×3卷积核卷积核组成，但是随着网络进一步加深，这种残差结构在实践中并不是十分有效。

针对这问题，右图的“瓶颈残差模块”（bottleneck residual block）可以有更好的效果，它依次由1×1、3×3、1×1这三个卷积层堆积而成，这里的1×1的卷积能够起降维或升维的作用，从而令3×3的卷积可以在相对较低维度的输入上进行，以达到提高计算效率的目的。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/N11-ResNet-20201215-224443-671957.png)



**模型结构：**

1. 先用一个普通的卷积层，stride=2
2. 再经过一个3*3的max_pooling
3. 再经过残差网络
4. 没有中间的全连接层，直接到输出

# Pytorch实现


```python
import sys
sys.path.append('..')

import numpy as np
import torch
from torch import nn
import torch.nn.functional as F
from torch.autograd import Variable
from torchvision.datasets import CIFAR10
```


```python
def conv3x3(in_channel, out_channel, stride=1):
    return nn.Conv2d(in_channel, out_channel, 3, stride=stride, padding=1, bias=False)
```


```python
class residual_block(nn.Module):
    def __init__(self, in_channel, out_channel, same_shape=True):
        super(residual_block, self).__init__()
        self.same_shape = same_shape
        stride=1 if self.same_shape else 2
        
        self.conv1 = conv3x3(in_channel, out_channel, stride=stride)
        self.bn1 = nn.BatchNorm2d(out_channel)
        
        self.conv2 = conv3x3(out_channel, out_channel)
        self.bn2 = nn.BatchNorm2d(out_channel)
        if not self.same_shape:
            self.conv3 = nn.Conv2d(in_channel, out_channel, 1, stride=stride)
        
    def forward(self, x):
        out = self.conv1(x)
        out = F.relu(self.bn1(out), True)
        out = self.conv2(out)
        out = F.relu(self.bn2(out), True)
        
        if not self.same_shape:
            x = self.conv3(x)
        return F.relu(x+out, True)
```

我们测试一下一个 residual block 的输入和输出


```python
# 输入输出形状相同
test_net = residual_block(32, 32)
test_x = Variable(torch.zeros(1, 32, 96, 96))
print('input: {}'.format(test_x.shape))
test_y = test_net(test_x)
print('output: {}'.format(test_y.shape))
```

    input: torch.Size([1, 32, 96, 96])
    output: torch.Size([1, 32, 96, 96])



```python
# 输入输出形状不同
test_net = residual_block(3, 32, False)
test_x = Variable(torch.zeros(1, 3, 96, 96))
print('input: {}'.format(test_x.shape))
test_y = test_net(test_x)
print('output: {}'.format(test_y.shape))
```

    input: torch.Size([1, 3, 96, 96])
    output: torch.Size([1, 32, 48, 48])


下面我们尝试实现一个 ResNet，它就是 residual block 模块的堆叠


```python
class resnet(nn.Module):
    def __init__(self, in_channel, num_classes, verbose=False):
        super(resnet, self).__init__()
        self.verbose = verbose
        
        self.block1 = nn.Conv2d(in_channel, 64, 7, 2)
        
        self.block2 = nn.Sequential(
            nn.MaxPool2d(3, 2),
            residual_block(64, 64),
            residual_block(64, 64)
        )
        
        self.block3 = nn.Sequential(
            residual_block(64, 128, False),
            residual_block(128, 128)
        )
        
        self.block4 = nn.Sequential(
            residual_block(128, 256, False),
            residual_block(256, 256)
        )
        
        self.block5 = nn.Sequential(
            residual_block(256, 512, False),
            residual_block(512, 512),
            nn.AvgPool2d(3)
        )
        
        self.classifier = nn.Linear(512, num_classes)
        
    def forward(self, x):
        x = self.block1(x)
        if self.verbose:
            print('block 1 output: {}'.format(x.shape))
        x = self.block2(x)
        if self.verbose:
            print('block 2 output: {}'.format(x.shape))
        x = self.block3(x)
        if self.verbose:
            print('block 3 output: {}'.format(x.shape))
        x = self.block4(x)
        if self.verbose:
            print('block 4 output: {}'.format(x.shape))
        x = self.block5(x)
        if self.verbose:
            print('block 5 output: {}'.format(x.shape))
        x = x.view(x.shape[0], -1)
        x = self.classifier(x)
        return x
```

输出一下每个 block 之后的大小


```python
test_net = resnet(3, 10, True)
test_x = Variable(torch.zeros(1, 3, 96, 96))
test_y = test_net(test_x)
print('output: {}'.format(test_y.shape))
```

    block 1 output: torch.Size([1, 64, 45, 45])
    block 2 output: torch.Size([1, 64, 22, 22])
    block 3 output: torch.Size([1, 128, 11, 11])
    block 4 output: torch.Size([1, 256, 6, 6])
    block 5 output: torch.Size([1, 512, 1, 1])
    output: torch.Size([1, 10])



```python
# %load utils.py
from datetime import datetime

import torch
import torch.nn.functional as F
from torch import nn
from torch.autograd import Variable


def get_acc(output, label):
    total = output.shape[0]
    _, pred_label = output.max(1)
    num_correct = (pred_label == label).sum().data[0]
    return num_correct / total


def train(net, train_data, valid_data, num_epochs, optimizer, criterion):
    if torch.cuda.is_available():
        net = net.cuda()
    prev_time = datetime.now()
    for epoch in range(num_epochs):
        train_loss = 0
        train_acc = 0
        net = net.train()
        for im, label in train_data:
            if torch.cuda.is_available():
                im = Variable(im.cuda())  # (bs, 3, h, w)
                label = Variable(label.cuda())  # (bs, h, w)
            else:
                im = Variable(im)
                label = Variable(label)
            # forward
            output = net(im)
            loss = criterion(output, label)
            # backward
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()


            train_loss += loss.data[0]
            train_acc += get_acc(output, label)

        cur_time = datetime.now()
        h, remainder = divmod((cur_time - prev_time).seconds, 3600)
        m, s = divmod(remainder, 60)
        time_str = "Time %02d:%02d:%02d" % (h, m, s)
        if valid_data is not None:
            valid_loss = 0
            valid_acc = 0
            net = net.eval()
            for im, label in valid_data:
                if torch.cuda.is_available():
                    im = Variable(im.cuda(), volatile=True)
                    label = Variable(label.cuda(), volatile=True)
                else:
                    im = Variable(im, volatile=True)
                    label = Variable(label, volatile=True)
                output = net(im)
                loss = criterion(output, label)
                # valid_loss+=float(loss.data[0])
                valid_loss += loss.data[0]
                valid_acc += get_acc(output, label)
            epoch_str = (
                "Epoch %d. Train Loss: %f, Train Acc: %f, Valid Loss: %f, Valid Acc: %f, "
                % (epoch, train_loss / len(train_data),
                   train_acc / len(train_data), valid_loss / len(valid_data),
                   valid_acc / len(valid_data)))
        else:
            epoch_str = ("Epoch %d. Train Loss: %f, Train Acc: %f, " %
                         (epoch, train_loss / len(train_data),
                          train_acc / len(train_data)))
        prev_time = cur_time
        print(epoch_str + time_str)


def conv3x3(in_channel, out_channel, stride=1):
    return nn.Conv2d(
        in_channel, out_channel, 3, stride=stride, padding=1, bias=False)


class residual_block(nn.Module):
    def __init__(self, in_channel, out_channel, same_shape=True):
        super(residual_block, self).__init__()
        self.same_shape = same_shape
        stride = 1 if self.same_shape else 2

        self.conv1 = conv3x3(in_channel, out_channel, stride=stride)
        self.bn1 = nn.BatchNorm2d(out_channel)

        self.conv2 = conv3x3(out_channel, out_channel)
        self.bn2 = nn.BatchNorm2d(out_channel)
        if not self.same_shape:
            self.conv3 = nn.Conv2d(in_channel, out_channel, 1, stride=stride)

    def forward(self, x):
        out = self.conv1(x)
        out = F.relu(self.bn1(out), True)
        out = self.conv2(out)
        out = F.relu(self.bn2(out), True)

        if not self.same_shape:
            x = self.conv3(x)
        return F.relu(x + out, True)


class resnet(nn.Module):
    def __init__(self, in_channel, num_classes, verbose=False):
        super(resnet, self).__init__()
        self.verbose = verbose

        self.block1 = nn.Conv2d(in_channel, 64, 7, 2)

        self.block2 = nn.Sequential(
            nn.MaxPool2d(3, 2), residual_block(64, 64), residual_block(64, 64))

        self.block3 = nn.Sequential(
            residual_block(64, 128, False), residual_block(128, 128))

        self.block4 = nn.Sequential(
            residual_block(128, 256, False), residual_block(256, 256))

        self.block5 = nn.Sequential(
            residual_block(256, 512, False),
            residual_block(512, 512), nn.AvgPool2d(3))

        self.classifier = nn.Linear(512, num_classes)

    def forward(self, x):
        x = self.block1(x)
        if self.verbose:
            print('block 1 output: {}'.format(x.shape))
        x = self.block2(x)
        if self.verbose:
            print('block 2 output: {}'.format(x.shape))
        x = self.block3(x)
        if self.verbose:
            print('block 3 output: {}'.format(x.shape))
        x = self.block4(x)
        if self.verbose:
            print('block 4 output: {}'.format(x.shape))
        x = self.block5(x)
        if self.verbose:
            print('block 5 output: {}'.format(x.shape))
        x = x.view(x.shape[0], -1)
        x = self.classifier(x)
        return x

```


```python
# from utils import train

def data_tf(x):
    x = x.resize((96, 96), 2) # 将图片放大到 96 x 96
    x = np.array(x, dtype='float32') / 255
    x = (x - 0.5) / 0.5 # 标准化，这个技巧之后会讲到
    x = x.transpose((2, 0, 1)) # 将 channel 放到第一维，只是 pytorch 要求的输入方式
    x = torch.from_numpy(x)
    return x
     
train_set = CIFAR10('F:\datasets\CIFAR10', train=True, transform=data_tf)
train_data = torch.utils.data.DataLoader(train_set, batch_size=64, shuffle=True)
test_set = CIFAR10('F:\datasets\CIFAR10', train=False, transform=data_tf)
test_data = torch.utils.data.DataLoader(test_set, batch_size=128, shuffle=False)

net = resnet(3, 10)
optimizer = torch.optim.SGD(net.parameters(), lr=0.01)
criterion = nn.CrossEntropyLoss()
```


```python
train(net, train_data, test_data, 20, optimizer, criterion)
```


    ---------------------------------------------------------------------------
    
    IndexError                                Traceback (most recent call last)
    
    <ipython-input-15-7ec4ef8e0b59> in <module>
    ----> 1 train(net, train_data, test_data, 20, optimizer, criterion)


    <ipython-input-11-9a85f470cb08> in train(net, train_data, valid_data, num_epochs, optimizer, criterion)
         39 
         40 
    ---> 41             train_loss += loss.data[0]
         42             train_acc += get_acc(output, label)
         43 


    IndexError: invalid index of a 0-dim tensor. Use tensor.item() to convert a 0-dim tensor to a Python number


ResNet 使用跨层通道使得训练非常深的卷积神经网络成为可能。同样它使用很简单的卷积层配置，使得其拓展更加简单。

**小练习： 
1.尝试一下论文中提出的 bottleneck 的结构 
2.尝试改变 conv -> bn -> relu 的顺序为 bn -> relu -> conv，看看精度会不会提高**


```python
import torchvision as tv
import torchvision.transforms as transforms
```


```python
transform = transforms.Compose([
        transforms.RandomResizedCrop(224),
        transforms.RandomHorizontalFlip(),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                             std=[0.229, 0.224, 0.225])])
```


```python
trainset = tv.datasets.CIFAR10(root='./data/', train=True, transform=transform, download=True)
testset = tv.datasets.CIFAR10(root='./data/', train=False, transform=transform, download=True)
```


```python

```


```python

```
