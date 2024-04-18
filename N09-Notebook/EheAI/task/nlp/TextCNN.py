# coding: UTF-8
import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
from task.nlp.model_utils.data_iter import data_iter
from task.nlp.model_utils.train_eval import train, init_network


class Config(object):
    """配置参数"""

    def __init__(self, dataset, embedding):
        """

        :param dataset:
        :param embedding:
        """
        self.model_name = 'TextCNN'
        self.train_path = f"data/{dataset}/train.txt"  # 训练集
        self.dev_path = f"data/{dataset}/dev.txt"  # 验证集
        self.test_path = f"data/{dataset}/test.txt"  # 测试集
        self.class_list = [x.strip() for x in open(f"data/{dataset}/class.txt", encoding='utf-8').readlines()]  # 类别名单
        self.vocab_path = f"data/{dataset}/vocab.pkl"  # 词表

        self.save_path = f'data/saved_dict/{self.model_name}.ckpt'  # 模型训练结果
        self.log_path = 'logs/' + self.model_name

        self.embedding_pretrained = torch.tensor(np.load(f'data/{dataset}/' + embedding)["embeddings"].astype('float32')) if embedding != 'random' else None  # 预训练词向量
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')  # 设备

        self.dropout = 0.5  # 随机失活
        self.require_improvement = 1000  # 若超过1000batch效果还没提升，则提前结束训练
        self.num_classes = len(self.class_list)  # 类别数
        self.n_vocab = 0  # 词表大小，在运行时赋值
        self.num_epochs = 2  # epoch数20
        self.batch_size = 128  # mini-batch大小
        self.pad_size = 32  # 每句话处理成的长度(短填长切)
        self.learning_rate = 1e-3  # 学习率
        self.embed = self.embedding_pretrained.size(1) if self.embedding_pretrained is not None else 300  # 字向量维度
        self.filter_sizes = (2, 3, 4)  # 卷积核尺寸
        self.num_filters = 256  # 卷积核数量(channels数)


'''Convolutional Neural Networks for Sentence Classification'''


class TextCNN(nn.Module):
    def __init__(self, config):
        super(TextCNN, self).__init__()

        if config.embedding_pretrained is not None:
            self.embedding = nn.Embedding.from_pretrained(config.embedding_pretrained, freeze=False)
        else:
            self.embedding = nn.Embedding(num_embeddings=config.n_vocab, embedding_dim=config.embed, padding_idx=config.n_vocab - 1)

        self.convs = nn.ModuleList([nn.Conv2d(in_channels=1, out_channels=config.num_filters, kernel_size=(k, config.embed)) for k in config.filter_sizes])
        self.dropout = nn.Dropout(config.dropout)
        self.fc = nn.Linear(in_features=config.num_filters * len(config.filter_sizes), out_features=config.num_classes)

    def conv_and_pool(self, x, conv):
        """

        :param x:
        :param conv:
        :return:
        """
        x = F.relu(conv(x)).squeeze(3)
        x = F.max_pool1d(x, x.size(2)).squeeze(2)
        return x

    def forward(self, x):
        """

        :param x:
        :return:
        """
        out = self.embedding(x[0])
        out = out.unsqueeze(1)
        out = torch.cat([self.conv_and_pool(out, conv) for conv in self.convs], 1)
        out = self.dropout(out)
        out = self.fc(out)
        return out


def main_textcnn():
    """

    :param dataset:
    :param embedding:
    :param word:
    :return:
    """
    from utils.utils import build_dataset, build_iterator

    # 搜狗新闻:embedding_SougouNews.npz, 腾讯:embedding_Tencent.npz, 随机初始化:random
    # embedding = 'sgns.weibo.char'
    dataset = 'THUCNews'  # 数据集
    embedding = 'embedding_SougouNews.npz'
    word = False

    config = Config(dataset, embedding)
    train_iter, dev_iter, test_iter, vocab = data_iter(config, word, build_dataset, build_iterator)

    config.n_vocab = len(vocab)

    model = TextCNN(config).to(config.device)
    init_network(model)

    print(model.parameters)
    train(config, model, train_iter, dev_iter, test_iter)
