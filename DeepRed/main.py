import pandas as pd
import easyquotation
from iFinDPy import *


qt = easyquotation.use('sina') # 新浪 ['sina'] 腾讯 ['tencent', 'qq']
# qt.set_cookie("u=311675521946060;xq_a_token=06c970814873215375f1cd02e4c8e64b740f6704;xq_id_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1aWQiOi0xLCJpc3MiOiJ1YyIsImV4cCI6MTY3NzM3MDg0NiwiY3RtIjoxNjc1NTIxOTQ0OTEzLCJjaWQiOiJkOWQwbjRBWnVwIn0.A-yCzTDnZLwgC3UaXmCRTdGEjRMsopES3UnVcEDMvOmjHBXW3oNa3SODl8i-eJTfxxHKN-JReT2tPiDNFcCquc685DeRy99r7rAs0k1rm6RRMMqZrSJnDK7qYItK_KUiNr7BOEZfWIWAnja7_z0McEmiWJ7_tAvwJkQNsJzH7Jac_mZubu1bgxTYrjiIBOBSsezz0HHKsJjetSU0uQ5mZEGOVZKWZiDQcde48_W-W3vgWvoA8N3ADfFhUYt4cn7vQnUBCBKUO7mKl913zGfbshk6lZQIiZDCnQEYD-Uye2LCgZ541ss60X98kZwyTyMbP_urC6-JQmLvifsfRCBKpw; xq_r_token=9546eea976a2e2f78e2667bb2221518d5306c5b6;xqat=06c970814873215375f1cd02e4c8e64b740f6704;acw_tc=276077a716755219460471802e577fd55d7b560fd0845f8bb69e0f316c1360")

data_all_dt = qt.market_snapshot(prefix=True)

data_all_li = []
for code, info in data_all_dt.items():
    data_tmp = [code]
    for k, v in info.items():
        data_tmp.append(v)
    data_all_li.append(data_tmp)


col = [
    "股票代码", "股票名字", "今日开盘价", "昨日收盘价", "当前价格", "今日最高价", "今日最低价", "竞买价", "竞卖价", "成交的股票数",
    "成交金额", "买一量", "买一价", "买二量", "买二价", "买三量", "买三价", "买四量", "买四价", "买五量",
    "买五价", "卖一量", "卖一价", "卖一量", "卖一价", "卖二量", "卖二价", "卖三量", "卖三价", "卖四量",
    "卖四价", "日期", "时间"
]
data_all_df = pd.DataFrame(data_all_dt).T.reset_index()
data_all_df.columns = col
data_all_df