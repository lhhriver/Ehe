# -*- coding: utf-8 -*-

from iFinDPy import *
from datetime import datetime
import pandas as pd
import time as _time
import json
from threading import Thread,Lock,Semaphore
import requests

sem = Semaphore(5)  # 此变量用于控制最大并发数
dllock = Lock()  #此变量用来控制实时行情推送中落数据到本地的锁


# 登录函数
def thslogindemo():
    # 输入用户的帐号和密码
    thsLogin = THS_iFinDLogin("blsj003", "178583")
    print(thsLogin)
    if thsLogin != 0:
        print('登录失败')
    else:
        print('登录成功')


thslogindemo()

"""
股票简称 ths_stock_short_name_stock
股票代码 ths_stock_code_stock
同花顺代码 ths_thscode_stock
上市板块 ths_listedsector_stock
上市交易所 ths_listing_exchange_stock

"""
codes = '300033.SZ,600030.SH'
indicators = "ths_stock_short_name_stock;ths_stock_code_stock;ths_thscode_stock;ths_listedsector_stock"
parameters = ";;;"
dataformat = "format:dataframe"
data_a = THS_BD(codes, indicators,parameters, format='format:dataframe').data

data_a


THS_DP('block','2023-02-06;001005010','date:Y,thscode:Y,security_name:Y')
