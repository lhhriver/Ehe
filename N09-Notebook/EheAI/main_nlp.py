import os
import time
import platform
import numpy as np
import torch

from task.nlp.bert_ import main_bert
from task.nlp.Bi_LSTM import main_bi_lstm
from task.nlp.Bi_LSTM_Attention import main_bi_lstm_attention
from task.nlp.NNLM import main_nnlm
from task.nlp.Seq2Seq import main_seq2seq
from task.nlp.Seq2Seq_Attention import main_seq2seq_attention
from task.nlp.TextCNN_ import main_textcnn
from task.nlp.TextLSTM import main_textlstm
from task.nlp.TextRNN_ import main_textrnn
from task.nlp.Transformer_ import main_transformer
from task.nlp.Transformer_Greedy_decoder import main_transformer_greedy_decoder
from task.nlp.Word2Vec_Skipgram_Softmax import main_word2vec
from task.nlp.FastText import main_fasttext
from task.nlp.TextRCNN import main_textrcnn
from task.nlp.TextRNN_Att import main_textrnn_att
from task.nlp.DPCNN import main_dpcnn

from task.nlp.bert import main_bert as main_bert_2
from task.nlp.TextCNN import main_textcnn as main_textcnn_2
from task.nlp.Transformer import main_transformer as main_transformer_2
from task.nlp.TextRNN import main_textrnn as main_textrnn_2

from task.nlp.bert_CNN import main_bertcnn
from task.nlp.bert_DPCNN import main_bertdpcnn
from task.nlp.bert_RCNN import main_bertrcnn
from task.nlp.bert_RNN import main_bertrnn
from task.nlp.ERNIE import main_ernie

np.random.seed(1)
torch.manual_seed(1)
torch.cuda.manual_seed_all(1)
torch.backends.cudnn.deterministic = True  # 保证每次结果一样


def main_nlp(model_in):
    if isinstance(model_in, list):
        for model in model_in:
            print(model.__name__.center(80, "*"))
            model()
    else:
        model_in()


if __name__ == '__main__':
    print("程序开始执行".center(80, "*"))
    print("代码执行环境>>> %s".center(80, "*") % platform.system())
    start_time = time.time()

    model_in_1 = [main_bert, main_bi_lstm, main_bi_lstm_attention, main_nnlm, main_seq2seq,
                  main_seq2seq_attention, main_textcnn, main_textlstm, main_textrnn, main_transformer,
                  main_transformer_greedy_decoder, main_word2vec]

    model_in_2 = [main_fasttext, main_textcnn_2, main_dpcnn, main_textrcnn, main_textrnn_2, main_textrnn_att, main_transformer_2,
                  main_bert_2, main_bertcnn, main_bertdpcnn, main_bertrcnn, main_bertrnn, main_ernie]
    model_in = model_in_1 + model_in_2
    main_nlp(main_textcnn)

    end_time = time.time()
    print('执行完毕'.center(80, "*"))
    print("用时%.2f秒".center(80, "*") % (end_time - start_time))
