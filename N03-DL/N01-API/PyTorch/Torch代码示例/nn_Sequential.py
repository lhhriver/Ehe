import torch
from torch import nn
import torchkeras
from torchkeras import summary
from collections import OrderedDict

net = nn.Sequential()
net.add_module("conv1", nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3))
net.add_module("pool1", nn.MaxPool2d(kernel_size=2, stride=2))
net.add_module("conv2", nn.Conv2d(in_channels=32, out_channels=64, kernel_size=5))
net.add_module("pool2", nn.MaxPool2d(kernel_size=2, stride=2))
net.add_module("dropout", nn.Dropout2d(p=0.1))
net.add_module("adaptive_pool", nn.AdaptiveMaxPool2d((1, 1)))
net.add_module("flatten", nn.Flatten())
net.add_module("linear1", nn.Linear(64, 32))
net.add_module("relu", nn.ReLU())
net.add_module("linear2", nn.Linear(32, 1))
net.add_module("sigmoid", nn.Sigmoid())

net_2 = nn.Sequential(
    nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3),
    nn.MaxPool2d(kernel_size=2, stride=2),
    nn.Conv2d(in_channels=32, out_channels=64, kernel_size=5),
    nn.MaxPool2d(kernel_size=2, stride=2),
    nn.Dropout2d(p=0.1),
    nn.AdaptiveMaxPool2d((1, 1)),
    nn.Flatten(),
    nn.Linear(64, 32),
    nn.ReLU(),
    nn.Linear(32, 1),
    nn.Sigmoid()
)

net_3 = nn.Sequential(
    OrderedDict(
        [("conv1", nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3)),
         ("pool1", nn.MaxPool2d(kernel_size=2, stride=2)),
         ("conv2", nn.Conv2d(in_channels=32, out_channels=64, kernel_size=5)),
         ("pool2", nn.MaxPool2d(kernel_size=2, stride=2)),
         ("dropout", nn.Dropout2d(p=0.1)),
         ("adaptive_pool", nn.AdaptiveMaxPool2d((1, 1))),
         ("flatten", nn.Flatten()),
         ("linear1", nn.Linear(64, 32)),
         ("relu", nn.ReLU()),
         ("linear2", nn.Linear(32, 1)),
         ("sigmoid", nn.Sigmoid())
         ])
)


class Net_4(nn.Module):
    def __init__(self):
        super(Net_4, self).__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(in_channels=32, out_channels=64, kernel_size=5),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Dropout2d(p=0.1),
            nn.AdaptiveMaxPool2d((1, 1))
        )
        self.dense = nn.Sequential(
            nn.Flatten(),
            nn.Linear(64, 32),
            nn.ReLU(),
            nn.Linear(32, 1),
            nn.Sigmoid()
        )

    def forward(self, x):
        x = self.conv(x)
        y = self.dense(x)
        return y


class Net_5(nn.Module):
    def __init__(self):
        super(Net_5, self).__init__()
        self.layers = nn.ModuleList([
            nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(in_channels=32, out_channels=64, kernel_size=5),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Dropout2d(p=0.1),
            nn.AdaptiveMaxPool2d((1, 1)),
            nn.Flatten(),
            nn.Linear(64, 32),
            nn.ReLU(),
            nn.Linear(32, 1),
            nn.Sigmoid()]
        )

    def forward(self, x):
        for layer in self.layers:
            x = layer(x)
        return x


class Net_6(nn.Module):

    def __init__(self):
        super(Net_6, self).__init__()
        self.layers_dict = nn.ModuleDict(
            {"conv1": nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3),
             "pool": nn.MaxPool2d(kernel_size=2, stride=2),
             "conv2": nn.Conv2d(in_channels=32, out_channels=64, kernel_size=5),
             "dropout": nn.Dropout2d(p=0.1),
             "adaptive": nn.AdaptiveMaxPool2d((1, 1)),
             "flatten": nn.Flatten(),
             "linear1": nn.Linear(64, 32),
             "relu": nn.ReLU(),
             "linear2": nn.Linear(32, 1),
             "sigmoid": nn.Sigmoid()
             })

    def forward(self, x):
        layers = ["conv1", "pool", "conv2", "pool", "dropout", "adaptive",
                  "flatten", "linear1", "relu", "linear2", "sigmoid"]
        for layer in layers:
            x = self.layers_dict[layer](x)
        return x


if __name__ == '__main__':
    print("*" * 100)
    print(net)

    print("*" * 100)
    print(net_2)

    print("*" * 100)
    print(net_3)
    torchkeras.summary(net_3, input_shape=(3, 32, 32))

    print("*" * 100)
    net_4 = Net_4()
    print(net_4)
    torchkeras.summary(net_4, input_shape=(3, 32, 32))

    print("*" * 100)
    net_5 = Net_5()
    print(net_5)
    torchkeras.summary(net_5, input_shape=(3, 32, 32))

    print("*" * 100)
    net_6 = Net_6()
    print(net_6)
    torchkeras.summary(net_6, input_shape=(3, 32, 32))
