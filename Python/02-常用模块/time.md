# time

time模块中时间表现的格式主要有三种：

1.  timestamp：时间戳，时间戳表示的是从1970年1月1日00:00:00开始按秒计算的偏移量。
2.  struct_time：时间元组，共有九个元素组。
3.  format time ：格式化时间，已格式化的结构使时间更具可读性。包括自定义格式和固定格式。

## time.time

```python
# 时间戳
time.time()
```

## time.localtime

```python
# 时间元组
time.localtime()
```

## time.mktime

```python
# 元组转时间戳
time.mktime(time.localtime())
```

## time.gmtime

```python
# 时间戳转元组
time.gmtime(time.time())
```

## time.strptime

```python
# 格式化时间转元组
time.strptime('2017-4-8 14:12:12', '%Y-%m-%d %H:%M:%S')
time.strptime('2017-4-8', '%Y-%m-%d')
```

## time.strftime

```python
# 时间元组转格式化时间
time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())

time.strftime('%Y-%m-%d %H:%M:%S')
```

## time.asctime

```
# 生成固定格式的时间表示格式
time.asctime()
time.asctime(time.localtime())
```

## time.ctime

```
time.ctime()
time.ctime(time.time())
```

## time.sleep

```python
t1 = time.time()
time.sleep(10)
t2 = time.time()
print(t1)
print(t2)
```

