# coding: UTF-8
import torch
import torch.nn as nn
import torch.nn.functional as F
from task.nlp.pytorch_pretrained import BertModel, BertTokenizer
from task.nlp.model_utils.data_iter import data_iter_bert
from task.nlp.model_utils.train_eval_bert import train, init_network


class Config(object):
    """配置参数"""

    def __init__(self, dataset):
        self.model_name = 'bert'
        self.train_path = f"data/{dataset}/train.txt"  # 训练集
        self.dev_path = f"data/{dataset}/dev.txt"  # 验证集
        self.test_path = f"data/{dataset}/test.txt"  # 测试集
        self.class_list = [x.strip() for x in open(f"data/{dataset}/class.txt", encoding='utf-8').readlines()]  # 类别名单

        self.save_path = f'data/saved_dict/{self.model_name}.ckpt'  # 模型训练结果
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')  # 设备

        self.require_improvement = 1000  # 若超过1000batch效果还没提升，则提前结束训练
        self.num_classes = len(self.class_list)  # 类别数
        self.num_epochs = 3  # epoch数
        self.batch_size = 128  # mini-batch大小
        self.pad_size = 32  # 每句话处理成的长度(短填长切)
        self.learning_rate = 5e-5  # 学习率
        self.bert_path = 'task/nlp/bert_pretrain'

        self.tokenizer = BertTokenizer.from_pretrained(self.bert_path)
        self.hidden_size = 768

        self.filter_sizes = (2, 3, 4)  # 卷积核尺寸
        self.num_filters = 256  # 卷积核数量(channels数)
        self.dropout = 0.1


class BertCNN(nn.Module):

    def __init__(self, config):
        super(BertCNN, self).__init__()
        self.bert = BertModel.from_pretrained(config.bert_path)

        for param in self.bert.parameters():
            param.requires_grad = True

        self.convs = nn.ModuleList([nn.Conv2d(in_channels=1, out_channels=config.num_filters, kernel_size=(k, config.hidden_size)) for k in config.filter_sizes])
        self.dropout = nn.Dropout(config.dropout)

        self.fc_cnn = nn.Linear(in_features=config.num_filters * len(config.filter_sizes),
                                out_features=config.num_classes)

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
        context = x[0]  # 输入的句子
        mask = x[2]  # 对padding部分进行mask，和句子一个size，padding部分用0表示，如：[1, 1, 1, 1, 0, 0]
        encoder_out, text_cls = self.bert(context, attention_mask=mask, output_all_encoded_layers=False)
        out = encoder_out.unsqueeze(1)
        out = torch.cat([self.conv_and_pool(out, conv) for conv in self.convs], 1)
        out = self.dropout(out)
        out = self.fc_cnn(out)
        return out


def main_bertcnn():
    """

    :param dataset:
    :return:
    """
    from utils.utils_bert import build_dataset, build_iterator

    dataset = 'THUCNews'  # 数据集

    config = Config(dataset)
    train_iter, dev_iter, test_iter = data_iter_bert(config, build_dataset, build_iterator)

    model = BertCNN(config).to(config.device)

    print(model.parameters)
    train(config, model, train_iter, dev_iter, test_iter)
