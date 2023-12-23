import tushare as ts
import pandas as pd

pro = ts.pro_api(token="a8e53ab4da4f693e211284520f4b8b597f4784494b812f68668afbb3")
# df = pro.daily(ts_code='000001.SZ', start_date='20180701', end_date='20180718')


data = pro.query('stock_basic', exchange='', list_status='L', fields='ts_code,symbol,name,area,industry,list_date')


# data = ts.get_today_all()
data = ts.get_realtime_quotes()
print(data)