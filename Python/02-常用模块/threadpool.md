# 介绍

```python
pool = ThreadPool(poolsize)  
requests = makeRequests(some_callable, list_of_args, callback)  
[pool.putRequest(req) for req in requests]  
pool.wait()  
```

第一行定义了一个线程池，表示最多可以创建poolsize这么多线程；

第二行是调用makeRequests创建了要开启多线程的函数，以及函数相关参数和回调函数，其中回调函数可以不写，default是无，也就是说makeRequests只需要2个参数就可以运行；

第三行用法比较奇怪，是将所有要运行多线程的请求扔进线程池，[pool.putRequest(req) for req in requests]等同于

```python
for req in requests:  
    pool.putRequest(req) 
```

第四行是等待所有的线程完成工作后退出。



# 一般方式

```python
import time

def sayhello(str):
    print("Hello ",str)
    time.sleep(2)

name_list =['xiaozi','aa','bb','cc']
start_time = time.time()

for i in range(len(name_list)):
    sayhello(name_list[i])
    
print('%d second'% (time.time()-start_time))
```



```
Hello  xiaozi
Hello  aa
Hello  bb
Hello  cc
8 second
```





# 线程池方式

```python
import time
import threadpool
def sayhello(str):
    print("Hello ",str)
    time.sleep(2)

name_list =['xiaozi','aa','bb','cc']
start_time = time.time()

pool = threadpool.ThreadPool(10)
requests = threadpool.makeRequests(sayhello, name_list)

[pool.putRequest(req) for req in requests]
pool.wait()
print('%d second'% (time.time()-start_time))
```



```
Hello  xiaozi
Hello  aa
Hello  bb
Hello  cc
2 second
```

