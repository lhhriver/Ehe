# coding:utf-8

import os
import time
import platform
from task.dl.LeNet5 import main_lenet5
from task.dl.AlexNet import main_alexnet
from task.dl.DenseNet import main_densenet121
from task.dl.GoogLeNet import main_googlenet
from task.dl.Inception3 import main_inception3
from task.dl.MobileNetV2 import main_mobilenet_v2
from task.dl.ResNet import main_resnet18
from task.dl.VggNet import main_vgg16

os.environ["PATH"] += os.pathsep + r'C:\Program Files (x86)\graphviz-2.38\release\bin'


def main_dl(model_in):
    if isinstance(model_in, list):
        for model in model_in:
            model()
    else:
        model_in()


if __name__ == '__main__':
    print("程序开始执行".center(80, "*"))
    print("代码执行环境>>> %s".center(80, "*") % platform.system())
    start_time = time.time()

    model_in = [main_alexnet, main_densenet121, main_googlenet, main_inception3,
                main_lenet5, main_mobilenet_v2, main_resnet18, main_vgg16]
    main_dl(model_in)

    end_time = time.time()
    print('执行完毕'.center(80, "*"))
    print("用时%.2f秒".center(80, "*") % (end_time - start_time))
