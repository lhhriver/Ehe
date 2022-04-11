# 描述

**定义：**JSON(JavaScript Object Notation) 是一种轻量级的数据交换格式。

**特点：**简洁和清晰的层次结构使得 JSON 成为理想的数据交换语言。 易于阅读和编写，同时也易于机器解析和生成，并有效地提升网络传输效率。

**序列化：**将python的值转换为json格式的字符串。

**反序列化：**将json格式的字符串转换成python的数据类型

|     方法     | 描述                                             |
| :----------: | ------------------------------------------------ |
| json.dumps() | 将 Python 对象编码成 JSON 字符串                 |
| json.loads() | 将已编码的 JSON 字符串解码为 Python 对象（字典） |
| json.dump()  | 将Python内置类型序列化为json对象后写入文件       |
| json.load()  | 读取文件中json形式的字符串元素转化为Python类型   |



# 代码示例

## json.dumps()

将Python对象编码成json字符串

```python
import json

data = {'a':'test','b':100}
print(json.dumps(data))
```

结果:

```
{"a": "test", "b": 100}
```

**注：** 原先的单引号已经变成双引号了



**json.dumps()过程中的中文显示**

```python
import json

v = {'k1':'alex','k2':'中文'}
print(json.dumps(v))

val = json.dumps(v, ensure_ascii=False)
print(val)
```

结果：

```
{"k1": "alex", "k2": "\u4e2d\u6587"}
{"k1": "alex", "k2": "中文"}
```



## json.loads()

将已编码的 JSON 字符串解码为 Python 对象

```python
import json

data = {'a':'test','b':100}

# 先将Python对象编码成json字符串
a = json.dumps(data)

# 再将json字符串编码成Python对象
print(json.loads(a))
```

结果：

```
{'name': 'test', 'b': 100}
```



## json.dump()

将Python内置类型序列化为json对象后写入文件

```python
import json

data = {
    'key1':'test',
    'a':[1,2,3,4],
    'b':(1,2,3)
}

with open('json_test.txt','w+') as f:
    json.dump(data, f)
```

打开json_test.txt文件显示：

```
{"key1": "test", "a": [1, 2, 3, 4], "b": [1, 2, 3]}
```



## json.load()

读取文件中json形式的字符串元素转化为Python类型

```python
import json

data = {
    'key1':'test',
    'a':[1,2,3,4],
    'b':(1,2,3)
}

with open('json_test.txt','w+') as f:
    json.dump(data,f)

with open('json_test.txt','r+') as f:
    print(json.load(f))
```

结果：

```
{'key1': 'test', 'a': [1, 2, 3, 4], 'b': [1, 2, 3]}
```



# 其它

**简单写法**

```python
user_json = json.load(open("data/user.json", "r", encoding="utf-8"))

sessionid = "123456"
this_user = user_json[sessionid]
this_user['task_all'] = "task_all"

user_json[sessionid] = this_user

json.dump(user_json, open("data/user.json", "w", encoding="utf-8"))
```



**附 dumps方法参数介绍：**

```python
def dumps(obj, *, skipkeys=False, ensure_ascii=True, check_circular=True,        
          allow_nan=True, cls=None, indent=None, separators=None,
          default=None, sort_keys=False, **kw):
```