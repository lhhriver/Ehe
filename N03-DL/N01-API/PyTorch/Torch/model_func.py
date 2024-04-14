import torch
from torch import nn
from torchkeras import summary, Model

import torchvision
from torchvision import transforms

import datetime
import pandas as pd
from sklearn.metrics import accuracy_score

transform = transforms.Compose([transforms.ToTensor()])

ds_train = torchvision.datasets.MNIST(root=r"F:\datasets\minist", train=True, download=False, transform=transform)
ds_valid = torchvision.datasets.MNIST(root=r"F:\datasets\minist", train=False, download=False, transform=transform)

dl_train = torch.utils.data.DataLoader(ds_train, batch_size=128, shuffle=True, num_workers=0)
dl_valid = torch.utils.data.DataLoader(ds_valid, batch_size=128, shuffle=False, num_workers=0)

print(len(ds_train))
print(len(ds_valid))


class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
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
    return accuracy_score(y_true, y_pred_cls)


def train_step(model, features, labels):
    """

    :param model:
    :param features:
    :param labels:
    :return:
    """
    # 训练模式，dropout层发生作用
    model.train()

    # 梯度清零
    model.optimizer.zero_grad()

    # 正向传播求损失
    predictions = model(features)
    loss = model.loss_func(predictions, labels)
    metric = model.metric_func(predictions, labels)

    # 反向传播求梯度
    loss.backward()
    model.optimizer.step()

    return loss.item(), metric.item()


@torch.no_grad()
def valid_step(model, features, labels):
    # 预测模式，dropout层不发生作用
    model.eval()

    predictions = model(features)
    loss = model.loss_func(predictions, labels)
    metric = model.metric_func(predictions, labels)

    return loss.item(), metric.item()


def train_model(model, epochs, dl_train, dl_valid, log_step_freq):
    """

    :param model:
    :param epochs:
    :param dl_train:
    :param dl_valid:
    :param log_step_freq:
    :return:
    """
    metric_name = model.metric_name
    dfhistory = pd.DataFrame(columns=["epoch", "loss", metric_name, "val_loss", "val_" + metric_name])
    print("Start Training...")
    nowtime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print("==========" * 8 + "%s" % nowtime)

    for epoch in range(1, epochs + 1):

        # 1，训练循环-------------------------------------------------
        loss_sum = 0.0
        metric_sum = 0.0
        step = 1

        for step, (features, labels) in enumerate(dl_train, 1):
            loss, metric = train_step(model, features, labels)

            # 打印batch级别日志
            loss_sum += loss
            metric_sum += metric
            if step % log_step_freq == 0:
                print(("[step = %d] loss: %.3f, " + metric_name + ": %.3f") % (step, loss_sum / step, metric_sum / step))

        # 2，验证循环-------------------------------------------------
        val_loss_sum = 0.0
        val_metric_sum = 0.0
        val_step = 1

        for val_step, (features, labels) in enumerate(dl_valid, 1):
            val_loss, val_metric = valid_step(model, features, labels)

            val_loss_sum += val_loss
            val_metric_sum += val_metric

        # 3，记录日志-------------------------------------------------
        info = (epoch, loss_sum / step, metric_sum / step, val_loss_sum / val_step, val_metric_sum / val_step)
        dfhistory.loc[epoch - 1] = info

        # 打印epoch级别日志
        print(("\nEPOCH = %d, loss = %.3f," + metric_name + "  = %.3f, val_loss = %.3f, " + "val_" + metric_name + " = %.3f") % info)
        nowtime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        print("\n" + "==========" * 8 + "%s" % nowtime)

    print('Finished Training...')
    return dfhistory


if __name__ == '__main__':
    net = Net()
    # print(net)

    summary(net, input_shape=(1, 32, 32))

    model = net
    model.optimizer = torch.optim.SGD(model.parameters(), lr=0.01)
    model.loss_func = nn.CrossEntropyLoss()
    model.metric_func = accuracy
    model.metric_name = "accuracy"

    # features, labels = next(iter(dl_train))
    # train_step(model, features, labels)
    epochs = 3
    dfhistory = train_model(model, epochs, dl_train, dl_valid, log_step_freq=100)
