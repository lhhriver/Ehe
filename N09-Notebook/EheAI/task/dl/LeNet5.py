from torchviz import make_dot
from torchsummary import summary
import time
import torchvision

import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.utils.data import DataLoader
from torchvision.datasets import MNIST
from torchvision import transforms
from torch.autograd import Variable
from torch import optim

import torchkeras

import platform
import warnings

warnings.filterwarnings("ignore")

print(dir(torchvision.models))


class LeNet5(nn.Module):
    """
    实现一
    """

    def __init__(self):
        super(LeNet5, self).__init__()
        self.conv1 = nn.Conv2d(in_channels=1, out_channels=6, kernel_size=(5, 5), stride=(1, 1))
        self.conv2 = nn.Conv2d(in_channels=6, out_channels=16, kernel_size=(5, 5), stride=(1, 1))
        self.fc1 = nn.Linear(in_features=16 * 5 * 5, out_features=120, bias=True)
        self.fc2 = nn.Linear(in_features=120, out_features=84, bias=True)
        self.fc3 = nn.Linear(in_features=84, out_features=10, bias=True)

    def forward(self, x):
        x = F.max_pool2d(input=F.relu(self.conv1(x)), kernel_size=2)
        x = F.max_pool2d(input=F.relu(self.conv2(x)), kernel_size=2)
        x = x.view(-1, self.num_flat_features(x))  # x = x.view(x.size(0), -1)
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


# build network

class LeNet5_A(nn.Module):
    """
    实现二，输入28*28
    """

    def __init__(self):
        super(LeNet5_A, self).__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(in_channels=1, out_channels=6, kernel_size=(3, 3), stride=(1, 1), padding=1),
            nn.MaxPool2d(kernel_size=2, stride=2, padding=0),
            nn.Conv2d(in_channels=6, out_channels=16, kernel_size=(5, 5), stride=(1, 1), padding=0),
            nn.MaxPool2d(kernel_size=2, stride=2, padding=0)
        )

        self.fc = nn.Sequential(
            nn.Linear(in_features=16 * 5 * 5, out_features=120, bias=True),
            nn.Linear(120, 84),
            nn.Linear(84, 10)
        )

    def forward(self, x):
        out = self.conv(x)
        out = out.view(out.size(0), -1)
        out = self.fc(out)
        return out


def main_lenet5_action():
    learning_rate = 1e-3
    batch_size = 64
    epoches = 3

    trans_img = transforms.ToTensor()

    trainset = MNIST(root=r"F:\datasets\minist", train=True, download=False, transform=trans_img)
    testset = MNIST(root=r"F:\datasets\minist", train=False, download=False, transform=trans_img)

    trainloader = DataLoader(trainset, batch_size=batch_size, shuffle=True, num_workers=0)
    testloader = DataLoader(testset, batch_size=batch_size, shuffle=False, num_workers=0)

    lenet = LeNet5_A()
    torchkeras.summary(lenet, input_shape=(1, 28, 28))
    # lenet.cuda()
    criterian = nn.CrossEntropyLoss(reduction='sum')
    optimizer = optim.SGD(lenet.parameters(), lr=learning_rate)

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

            # 1为返回每行的最大值，返回两个tensor，第一个tensor是每行的最大值；第二个tensor是每行最大值的索引。
            _, predict = torch.max(output, 1)
            correct_num = (predict == label).sum()
            running_acc += correct_num.item()

        running_loss /= len(trainset)
        running_acc /= len(trainset)
        print(("[%d/%d] Loss: %.5f, Acc: %.2f, Time: %.2f s" % (i + 1, epoches, running_loss, 100 * running_acc, time.time() - since)))

    print("Finished Training".center(80, "*"))

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


def main_lenet5():
    model = LeNet5()
    print(f">>>lenet模型:\n {model}")

    # -----------------------------------------------------------
    input = torch.randn(64, 1, 32, 32)
    out = model(input)
    print(f">>>模型输出: \n {out.shape}")

    print("模型参数".center(80, "*"))
    summary(model, (1, 32, 32), device='cpu')

    print("模型可视化".center(80, "*"))
    vis_graph = make_dot(out, params=dict(model.named_parameters()))
    vis_graph.render('model/LeNet_model', view=False, cleanup=True)


if __name__ == '__main__':
    print("程序开始执行".center(80, "*"))
    print("代码执行环境>>> %s".center(80, "*") % platform.system())
    start_time = time.time()
    main_lenet5()  # 官方版，输入32*32
    main_lenet5_action()  # 实战版，输入28*28
    end_time = time.time()
    print('执行完毕'.center(80, "*"))
    print("用时%.2f秒".center(80, "*") % (end_time - start_time))
