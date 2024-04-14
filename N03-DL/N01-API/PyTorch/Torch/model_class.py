import torch
from torch import nn
from torchkeras import summary, Model
import torchkeras

import torchvision
from torchvision import transforms

import datetime
import numpy as np
import pandas as pd
from sklearn.metrics import accuracy_score

transform = transforms.Compose([transforms.ToTensor()])

ds_train = torchvision.datasets.MNIST(root=r"F:\datasets\minist", train=True, download=False, transform=transform)
ds_valid = torchvision.datasets.MNIST(root=r"F:\datasets\minist", train=False, download=False, transform=transform)

dl_train = torch.utils.data.DataLoader(ds_train, batch_size=128, shuffle=True, num_workers=0)
dl_valid = torch.utils.data.DataLoader(ds_valid, batch_size=128, shuffle=False, num_workers=0)

print(len(ds_train))
print(len(ds_valid))


class CnnModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.layers = nn.ModuleList([
            nn.Conv2d(in_channels=1, out_channels=32, kernel_size=3),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(in_channels=32, out_channels=64, kernel_size=5),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Dropout2d(p=0.1),
            nn.AdaptiveMaxPool2d((1, 1)),
            nn.Flatten(),
            nn.Linear(64, 32),
            nn.ReLU(),
            nn.Linear(32, 10)]
        )

    def forward(self, x):
        for layer in self.layers:
            x = layer(x)
        return x


def accuracy(y_pred, y_true):
    """

    :param y_pred:
    :param y_true:
    :return:
    """
    y_pred_cls = torch.argmax(nn.Softmax(dim=1)(y_pred), dim=1).data
    return accuracy_score(y_true.numpy(), y_pred_cls.numpy())


if __name__ == '__main__':
    model = torchkeras.Model(CnnModel())
    # print(model)

    model.summary(input_shape=(1, 32, 32))

    model.compile(loss_func=nn.CrossEntropyLoss(),
                  optimizer=torch.optim.Adam(model.parameters(), lr=0.02),
                  metrics_dict={"accuracy": accuracy})

    dfhistory = model.fit(3, dl_train=dl_train, dl_val=dl_valid, log_step_freq=100)
