

# datetime

## datetime.timedelta

```
datetime.timedelta(days=-1)
```

## datetime.date



```python
dt = datetime.date(2017, 4, 8)
dt

dt.year

dt.month

dt.day

dt.timetuple()

dt.weekday()

dt.isocalendar()

# dt.isoformat()：返回格式如'YYYY-MM-DD’的字符串；
dt.isoformat()

# dt.strftime(fmt)：和time模块format相同。
dt.strftime('%Y-%m-%d')
```



### datetime.date.max

```python
datetime.date.max
```

### datetime.date.min

```python
datetime.date.min
```

### datetime.date.resolution

```python
datetime.date.resolution
```

### datetime.date.today

```python
datetime.date.today()
datetime.date.today().strftime("%Y-%m-%d")
datetime.date.today() + datetime.timedelta(days=-1)
(datetime.date.today() + datetime.timedelta(days=-1)).strftime('%Y-%m-%d')
```

### datetime.date.fromtimestamp

```python
datetime.date.fromtimestamp(time.time())
```

## datetime.time

```python
t = datetime.time(18, 40, 58)
t

t.hour

t.minute

t.second

t.microsecond
```



### datetime.time.min

```python
datetime.time.min
```

### datetime.time.max

```python
datetime.time.max
```

### datetime.time.resolution

```python
# time.resolution：时间的最小单位，这里是1微秒；
datetime.time.resolution
```



## datetime.datetime

### datetime.datetime.now

```python
datetime.datetime.now()
datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

# dt.year、month、day、hour、minute、second、microsecond、tzinfo：
datetime.datetime.now().year

# 获取date对象；
datetime.datetime.now().date()

# 获取time对象
datetime.datetime.now().time()

datetime.datetime.now().replace(2019, 8, 6)

datetime.datetime.now().timetuple()

datetime.datetime.now().utctimetuple()

datetime.datetime.now().toordinal()

datetime.datetime.now().weekday()

datetime.datetime.now().isocalendar()

datetime.datetime.now().isoformat()

# 返回一个日期时间的C格式字符串，等效于time.ctime(time.mktime(dt.timetuple()))；
datetime.datetime.now().ctime()
```

### datetime.datetime.today

```python
datetime.datetime.today()
```

### datetime.datetime.strftime

```python
datetime.datetime.now().strftime("%Y-%M-%D %H:%M:%S")
```

### datetime.datetime.strptime

```python
datetime.datetime.strptime("2019-05-28", '%Y-%m-%d')
```



## Action

```python
import pandas as pd
pd.date_range(start='2019-09-01', end='2019-09-10',freq='D').astype(str).tolist()
```



```python
li = [("%s-01-01" % i, "%s-01-01" % str(i+1)) for i in range(2015, 2019)]  
li.insert(0, ('1900-01-01', '2015-01-01'))
li.append(('2019-01-01', '2019-09-23'))
li
```



```python
import datetime

def main(start_date, end_date):
    if isinstance(start_date, str):
        start_date = datetime.datetime.strptime(start_date, "%Y-%m-%d")

    if isinstance(end_date, str):
        end_date = datetime.datetime.strptime(end_date, "%Y-%m-%d") + datetime.timedelta(days=1)

    while start_date < end_date:
        print(start_date.strftime("%Y-%m-%d"))
        start_date += datetime.timedelta(days=1)


if __name__ == "__main__":
    start_date = datetime.datetime.today() + datetime.timedelta(days=-1)
    end_date = datetime.datetime.today()

    start_date = "2020-03-08"
    end_date = "2020-03-12"

    main(start_date, end_date)
```

