import os
import platform
import time
import torch
import torch.nn as nn
import torchvision
from torchsummary import summary
from torchviz import make_dot

TAG = os.path.basename(__file__)


class AlexNet(nn.Module):

    def __init__(self, num_classes=1000):
        super(AlexNet, self).__init__()
        self.features = nn.Sequential(
            nn.Conv2d(in_channels=3, out_channels=64, kernel_size=11, stride=4, padding=2),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(kernel_size=3, stride=2),

            nn.Conv2d(64, 192, kernel_size=5, padding=2),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(kernel_size=3, stride=2),

            nn.Conv2d(192, 384, kernel_size=3, padding=1),
            nn.ReLU(inplace=True),

            nn.Conv2d(384, 256, kernel_size=3, padding=1),
            nn.ReLU(inplace=True),

            nn.Conv2d(256, 256, kernel_size=3, padding=1),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(kernel_size=3, stride=2),
        )

        self.avgpool = nn.AdaptiveAvgPool2d((6, 6))
        self.classifier = nn.Sequential(
            nn.Dropout(),
            nn.Linear(256 * 6 * 6, 4096),
            nn.ReLU(inplace=True),
            nn.Dropout(),
            nn.Linear(4096, 4096),
            nn.ReLU(inplace=True),
            nn.Linear(4096, num_classes),
        )

    def forward(self, x):
        x = self.features(x)
        x = self.avgpool(x)
        x = torch.flatten(x, 1)
        x = self.classifier(x)
        return x


def main_alexnet():
    # print("官方版".center(80, "*"))
    # alexnet = torchvision.models.AlexNet(pretrained=False)
    # pretrained_dict = alexnet.state_dict()
    # print(pretrained_dict)
    # print(alexnet)

    model = AlexNet()
    print(f">>> AlexNet模型:\n {model}")

    # -----------------------------------------------------------
    input = torch.randn(8, 3, 224, 224)
    out = model(input)
    print(f">>>模型输出:{out.shape}")

    print("模型参数".center(80, "*"))
    # device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    # model = model.to(device)

    summary(model, (3, 224, 224), device='cpu')

    print("模型可视化".center(80, "*"))
    vis_graph = make_dot(out, params=dict(model.named_parameters()))
    vis_graph.render('model/AlexNet_model', view=False, cleanup=True)


if __name__ == '__main__':
    print("程序开始执行".center(80, "*"))
    print("代码执行环境>>> %s".center(80, "*") % platform.system())
    start_time = time.time()
    main_alexnet()
    end_time = time.time()
    print('执行完毕'.center(80, "*"))
    print("用时%.2f秒".center(80, "*") % (end_time - start_time))
