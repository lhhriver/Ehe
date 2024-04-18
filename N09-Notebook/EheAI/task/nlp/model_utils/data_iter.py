import time
from utils.utils import get_time_dif


def data_iter(config, word, build_dataset, build_iterator):
    """

    :param config:
    :param word:
    :param build_dataset:
    :param build_iterator:
    :return:
    """

    start_time = time.time()
    print("Loading data...")
    vocab, train_data, dev_data, test_data = build_dataset(config, word)

    train_iter = build_iterator(train_data, config)
    dev_iter = build_iterator(dev_data, config)
    test_iter = build_iterator(test_data, config)

    time_dif = get_time_dif(start_time)
    print("Time usage:", time_dif)
    return train_iter, dev_iter, test_iter, vocab


def data_iter_bert(config, build_dataset, build_iterator):
    """

    :param config:
    :param build_dataset:
    :param build_iterator:
    :return:
    """
    start_time = time.time()
    print("Loading data...")
    train_data, dev_data, test_data = build_dataset(config)

    train_iter = build_iterator(train_data, config)
    dev_iter = build_iterator(dev_data, config)
    test_iter = build_iterator(test_data, config)

    time_dif = get_time_dif(start_time)
    print("Time usage:", time_dif)
    return train_iter, dev_iter, test_iter
