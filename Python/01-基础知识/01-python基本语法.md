# python是一门什么样的语言

- 动态解释性的强类型定义语言

## python的优缺点

**优点**

- 优雅,明确,简单
- 开发效率高
- 高级语言
- 可移植性
- 可扩展性
- 可嵌入性

**缺点**
- 速度慢
- 代码不能加密
- 线程不能利用多cpu问题

## python的种类

- CPython
	- C语言编写的python解释器
- IPython
	- 基于CPython之上的一个交互式解释器
- PyPy
	- 采用jit技术,对python代码进行动态变异,可以显著提高python代码的执行速度
- Jython
	- 运行在java平台上的python解释器
- IronPython
	- 运行在微软.net上的python解释器,可以直接python代码转换成.net的字节码

## 注释

- 当行注释: `#`
- 多行注释:`"""` 或 `'''`
- 单引号,双引号,和三引号的区别
	-  区别:整体上来说没什么区别:但是单引号和双引号都只能表示单行,而三引号却能表示多行,如果单引号中包含单引号,那么那个单引号需要转义一下

## 常量和变量

**变量定义**

- 把程序运行的中间的结果临时的存在内存中,以便后续的代码调用 

**常量定义**

- python没有绝对的常量,通常全部都是大写的是常量(约定俗称的) 

## 变量的命名规范

- 1.只能是字母,数字和下划线组成
- 2.不能数字开头或全部都是数字
- 3.不能是python的关键字
- 4.不能是中文
- 5.不能太长
- 6.尽量有意义
- 7.推荐使用:
	- 小驼峰体:单词的首字母大写
	- 下划线:单词之间用下划线隔开



# 关键字

## FALSE

## None

## TRUE
## and
## as
## assert
## async

## await
## break
## class
## continue

## def
## del

​		描述

```python
x = [1, 2, 3, 4, 5, 6]
del x
x
->>NameError: name 'x' is not defined
```

## elif

## else
## except
## finally
## for
## from
## global
## if
## import

## in

## is
## lambda
## nonlocal
## not
## or
## pass
## raise
## return
## try
## while
## with
## yield



# 内置函数



## abs

**描述：**返回数字绝对值或复数的模

**语法：**abs( x )

**参数：**x 数值表达式。

```python
abs(-6)
6
 
abs(5j+4)
6.4031242374328485
```

​		

## all	

**描述：**接受一个迭代器，如果迭代器(元组或列表)的所有元素都为真，那么返回True，否则返回False，元素除了是 0、空、None、False 外都算 True。

**注意：**空元组、空列表返回值为True，这里要特别注意。

**语法：**all(iterable)

**参数：**iterable -- 元组或列表

```python
all([1,0,3,6])
False
 
all([1,9,3,6])
True
 
all(['a', 'b', '', 'd'])
False

all([]) #空列表为真
True
 
all(()) #空元组为真
True
```

## any

**描述：**接受一个迭代器，如果迭代器里有一个元素为真，那么返回True，否则返回False，元素除了是 0、空、None、False 外都算 True。

**语法：any**(iterable)

**参数：**iterable -- 元组或列表

```python
any([0,0,0,[]])
False
 
any([0,0,1])
True
 
any((0, '', False))  
False
 
any([]) # 空列表
False
 
any(()) # 空元组
False
```

## ascii	

**描述：**ascii() 函数返回任何对象（字符串，元组，列表等）的可读版本。ascii() 函数会将所有非 ascii 字符替换为转义字符：å 将替换为 \\xe5。

**语法：**ascii(object)

**参数：**object--对象，可以是元组、列表、字典、字符串、set()创建的集合。

```python
print(ascii('hello'))
print(ascii('中文'))
->>'hello'
	'\u4e2d\u6587'
    
ascii('中国')
"'\\\u4e2d\\\u56fd'"

ascii('新冠肺炎')
"'\\\u65b0\\\u51a0\\\u80ba\\\u

ascii("My name is Ståle")
"'My name is St\\\xe5le'"

print(ascii((1,2))) #元组
(1, 2)
print(type(ascii((1,2))))
<class 'str'>

print(ascii([1,2])) #列表
[1, 2]
print(type(ascii([1,2])))
<class 'str'>

print(ascii('？')) #字符串，非 ASCII字符，转义
'\\uff1f'
print(type(ascii("？")))
<class 'str'>

print(ascii({1:2,'name':5})) #字典
{1: 2, 'name': 5}
print(type(ascii({1:2,'name':5})))
<class 
```

## bin	

**描述：bin()** 返回一个整数 int 或者长整数 long int 的二进制表示。将十进制转换为二进制

**语法：**bin(x)

**参数：**x -- int 或者 long int 数字

```python
bin(57)
->>    '0b111001'

bin(2)
'0b10'

bin(20)
'0b10100'
```

## bool	

**描述：**测试一个对象是True, 还是False.bool 是 int 的子类。

**语法：**class bool([x])

**参数：**x -- 要进行转换的参数。	

```python
bool(5)
->>    True

bool([0,0,0])
True

bool([])
False

issubclass(bool, int)  # bool 是 int 子类
True
```

## bytearray	

​		转换成字节数组	

```python
print(bytearray(3))
print(bytearray('hello', encoding='utf-8'))  # 参数为字符串要指定编码
print(bytearray('中文', 'utf-8'))

# 参数为可迭代类型，则元素必须为[0 ,255]中的整数；
print(bytearray([11, 22, 33]))  
->>
bytearray(b'\x00\x00\x00')
bytearray(b'hello')
bytearray(b'\xe4\xb8\xad\xe6\x96\x87')
bytearray(b'\x0b\x16!')
```

​		

## bytes	

**描述：**将一个字符串转换成字节类型

**语法：**class bytes([source[, encoding[, errors]]])

**参数：**

- 如果 source 为整数，则返回一个长度为 source 的初始化数组；
- 如果 source 为字符串，则按照指定的 encoding 将字符串转换为字节序列；
- 如果 source 为可迭代类型，则元素必须为[0 ,255] 中的整数；
- 如果 source 为与 buffer 接口一致的对象，则此对象也可以被用于初始化 bytearray。
- 如果没有输入任何参数，默认就是初始化数组为0个元素。

​	

```python
print(bytes(2))
# 字符转换成字节，utf-8编码1个字符为3个字节，GBK编码1个字符为2个字节
print(bytes('中文', encoding='utf-8'))  
->>
b'\x00\x00'
b'\xe4\xb8\xad\xe6\x96\x87'

s = "apple"
bytes(s,encoding='utf-8')
b'apple'


bytes([1,2,3,4])
b'\\x01\\x02\\x03\\x04'
```

## callable	

**描述：**判断对象是否可以被调用，能被调用的对象就是一个callable 对象，对于函数、方法、lambda 函式、 类以及实现了 **__call__** 方法的类实例, 它都返回 True。

**语法：**callable(object)

**参数：**object -- 对象

```python
def test():
    print('succeed')
    n = 5
    print(callable(test))
    print(callable(n))
    
#    True
#    False
    
callable(0)
#False

def add(x, y):
  return x + y

callable(add)
#True
```

## chr	

**描述：**chr() 用一个范围在 range（256）内的（就是0～255）整数作参数，返回一个对应的字符。

**语法：**chr(i)

**参数：**i -- 可以是10进制也可以是16进制的形式的数字。

```python
chr(65)
		->>    'A'
```

## classmethod	

**描述：classmethod** 修饰符对应的函数不需要实例化，不需要 self 参数，但第一个参数需要是表示自身类的 cls 参数，可以来调用类的属性，类的方法，实例化对象等。

**语法：**classmethod

**参数：无**

```python
class Sample(object):
    bar = 1
    def fun1(self):  
        print ('foo') 


    @classmethod
    def fun2(cls):
        print ('fun2')
        print (cls.bar)
        cls().fun1()   # 调用 foo 方法
 
Sample.fun2()  # 不需要实例化

# fun2
# 1
# foo
```

​		

## compile	

**描述：**compile() 函数将一个字符串编译为字节代码。

**语法：**compile(source, filename, mode[, flags[, dont_inherit]])

**参数：**

- source -- 字符串或者AST（Abstract Syntax Trees）对象。。
- filename -- 代码文件名称，如果不是从文件读取代码则传递一些可辨认的值。
- mode -- 指定编译代码的种类。可以指定为 exec, eval, single。
- flags -- 变量作用域，局部命名空间，如果被提供，可以是任何映射对象。。
- flags和dont_inherit是用来控制编译源码时的标志

```python
# 将字符串编译成python能识别或可以执行的代码，也可以将文字读成字符串再编译。
s = "print('helloworld')"
r = compile(s,"<string>", "exec")
 
r
<code object <module> at 0x000000000F819420, file "<string>", line 1>
exec(r)
helloworld
str = "for i in range(0,5): print(i)" 
c = compile(str,'','exec')   # 编译为字节代码对象 
c
<code object <module> at 0x000001EB82C91ED0, file "", line 1>
exec(c)
0
1
2
3
4
```



## complex	

**描述：**创建一个复数

**语法：**class complex([real[, imag]])

**参数：**

- real -- int, long, float或字符串；
- imag -- int, long, float；

```python
complex(1,2)
(1+2j) 

complex('1')
(1+0j)

complex("1+2j")

(1+2j)
```



## delattr	

**描述：**删除对象的属性

**语法：**delattr(object, name)

**参数：**

- object -- 对象。
- name -- 必须是对象的属性。

​		

```python
class Coordinate:
    x = 10
    y = -5
    z = 0
 
point1 = Coordinate() 


print('x = ',point1.x)
x =  10
print('y = ',point1.y)
y =  -5
print('z = ',point1.z)
z =  0
delattr(Coordinate, 'z')
 
print('--删除 z 属性后--')


print('z = ',point1.z)# 触发错误
AttributeError: 'Coordinate' object has no attribute 'z'


dir(Coordinate)
['__class__
省略部分
 'x',
 'y'
```



## dict	

**描述：**创建数据字典

**语法：**

class dict(**kwarg)

class dict(mapping, **kwarg)

class dict(iterable, **kwarg)

**参数：**

- **kwargs -- 关键字
- mapping -- 元素的容器。
- iterable -- 可迭代对象。

​	

```python
# dict（创建字典）
d = dict(a=1, b=2)
print(d)
->>    {'a': 1, 'b': 2}

#创建空字典
dict()                       
{}

#传入关键字
dict(a='a', b='b', t='t')   
{'a': 'a', 'b': 'b', 't': 't'}

# 映射函数方式来构造字典
dict(zip(['one', 'two', 'three'], [1, 2, 3]))  
{'three': 3, 'two': 2, 'one': 1} 


#可迭代对象方式来构造字典
dict([('one', 1), ('two', 2), ('three', 3)])    
{'three': 3, 'two': 2, 'one': 1}
```

## dir

**描述：dir()** 函数不带参数时，返回当前范围内的变量、方法和定义的类型列表；带参数时，返回参数的属性、方法列表。如果参数包含方法__dir__()，该方法将被调用。如果参数不包含__dir__()，该方法将最大限度地收集参数信息。

**语法：**dir([object])

**参数：**object -- 对象、变量、类型。	

```python
li = [i for i in dir(str) if not i.startswith("_")]
li

# 不带参数时返回当前范围内的变量，方法和定义的类型列表；带参数时返回参数的属性，方法列表。
dir()   #  获得当前模块的属性列表
dir([ ])# 查看列表的方法
dir(list())# 查看列表的方法

print(dir(str))#获取所有的方法
print(dir(list))#获取所有的方法
print(dir(dict))#获取所有的
```

​		

## divmod

**描述：**divmod() 函数把除数和余数运算结果结合起来，返回一个包含商和余数的元组(a // b, a % b)。

**语法：**divmod(a, b)

**参数：**a: 数字--被除数

b: 数字--除数

```python
print(divmod(13, 5))
		->>    (2, 3)
    
divmod(11,3)
(3, 2)


divmod(20,4)
(5, 0)
```

## enumerate	

**描述：**enumerate() 函数用于将一个可遍历的数据对象(如列表、元组或字符串)组合为一个索引序列，同时列出数据和数据下标，一般用在 for 循环当中。返回一个可以枚举的对象，该对象的next()方法将返回一个元组。

**语法：**enumerate(sequence, [start=0])

**参数：**sequence -- 一个序列、迭代器或其他支持迭代对象。

start -- 下标起始位置。

```python
name = ['Tom', 'Lucy', 'Ben']
for i, j in enumerate(name):  # i为索引，j为值
    print(i, j)
    
'''
    0 Tom
    1 Lucy
    2 Ben
'''

L = ['Spring', 'Summer', 'Fall', 'Winter']


enumerate(L)
<enumerate at 0x226e1ee1138>#生成的额迭代器，无法直接查看


list(enumerate(L))#列表形式，可以看到内部结构，默认下标从0开始


[(0, 'Spring'), (1, 'Summer'), (2, 'Fall'), (3, 'Winter')]
 
list(enumerate(L, start=1)) #下标从 1 开始
[(1, 'Spring'), (2, 'Summer'), (3, 'Fall'), (4, 'Winter')]


for i,v in enumerate(L):
    print(i,v)
    
'''
0 Spring
1 Summer
2 Fall
3 Winter
'''

for i,v in enumerate(L,1):
    print(i,v)

'''
1 Spring
2 Summer
3 Fall
4 Winter
'''

s = ["a","b","c"]
 
for i ,v in enumerate(s,2):
    print(i,v)
'''
2 a
3 b
4 c
'''

# 普通的 for 循环
i = 0
seq = ['one', 'two', 'three']
for element in seq:
    print (i, seq[i])
    i+= 1
'''
0 one
1 two
2 three
'''

 
#在看一个普通循环的对比案例    
#for 循环使用 enumerate
 
seq = ['one', 'two', 'three']
for i, element in enumerate(seq):
    print (i, element)
'''
0 one
1 two
2 three
'''

 

seq = ['one', 'two', 'three']
for i, element in enumerate(seq,2):
    print (i, element)
2 one
3 two
```

## eval	

**描述：**将字符串str 当成有效的表达式来求值并返回计算结果取出字符串中内容

**语法：**eval(expression[, globals[, locals]])

**参数：**

- expression -- 表达式。
- globals -- 变量作用域，全局命名空间，如果被提供，则必须是一个字典对象。
- locals -- 变量作用域，局部命名空间，如果被提供，可以是任何映射对象。

​	

```python
print(eval('5*10'))
		->>50
    
a = eval('[1,2,3]')
print(type(a))
# 输出：<class 'list'>

b = eval('max([2,4,5])')
print(b)
# 输出：5
```

## exec	

**描述：**执行储存在字符串或文件中的Python语句，相比于 eval，exec可以执行更复杂的 Python 代码。

**语法：**exec(object, globals, locals)



**参数：**

- object-- 要执行的表达式。
- globals -- 可选。包含全局参数的字典。
- locals -- 可选。包含局部参数的字典。

​	

```python
exec('a=2+3')
print(a)

->>5

执行字符串或compile方法编译过的字符串，没有返回值
s = "print('helloworld')"
r = compile(s,"<string>", "exec")
exec(r)
helloworld


x = 10
expr = """
z = 30
sum = x + y + z
print(sum)
"""
def func():
    y = 20
    exec(expr)
    exec(expr, {'x': 1, 'y': 2})
    exec(expr, {'x': 1, 'y': 2}, {'y': 3, 'z': 4})
    
func()
60
33
34
```



## **frozenset()**

**描述：frozenset()** 返回一个冻结的集合，冻结后集合不能再添加或删除任何元素。

**语法：**class frozenset([iterable])

**参数：**iterable -- 可迭代的对象，比如列表、字典、元组等等。

```python
# 创建一个不可修改的集合。
frozenset([1,1,3,2,3])
frozenset({1, 2, 3})
```



## map

​		遍历可迭代对象的元素，把每个元素传入指定方法或函数中执行，并生成的可迭代对象	

```python
chars = ['apple','watermelon','pear','banana']
a = map(lambda x:x.upper(),chars)
print(list(a))
# 输出：['APPLE', 'WATERMELON', 'PEAR', 'BANANA']
```

## filter	

**描述：filter()** 函数用于过滤序列，过滤掉不符合条件的元素，返回由符合条件元素组成的新列表。

该接收两个参数，第一个为函数，第二个为序列，序列的每个元素作为参数传递给函数进行判断，然后返回 True 或 False，最后将返回 True 的元素放到新列表中。

过滤器，构造一个序列，等价于：[ item for item in iterables if function(item)]

在函数中设定过滤条件，逐一循环迭代器中的元素，将返回值为True时的元素留下，形成一个filter类型数据。



**语法：**filter(function, iterable)

**参数：**

- function -- 判断函数。
- iterable -- 可迭代对象。

```python
def func(a):
    if a > 50:
        return True
    else:
        return False

li = [33, 44, 55, 66, 77]
new_li = filter(func, li)
print(list(new_li))  # new_li是filter对象，要转成list才能输出结果

->>    [55, 66, 77]

fil = filter(lambda x: x>10,[1,11,2,45,7,6,13])
fil
 <filter at 0x28b693b28c8>
list(fil)
[11, 45, 13]


def is_odd(n):
    return n % 2 == 1
 
newlist = filter(is_odd, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
print(list(newlist))
[1, 3, 5, 7, 9]
```

## float	

**描述：**将一个字符串或整数转换为浮点数

**语法：**class float([x])

**参数：**x -- 整数或字符串

```python
float(22)
->>    22.0

float('inf'), float('-inf'), float('nan')
->>    (inf, -inf, nan)

int("101", 2)
->>5

float(3)
3.0


float('123')     # 字符串
 123.0
```

## format	

**描述：**Python2.6 开始，新增了一种格式化字符串的函数 **str.format()**，它增强了字符串格式化的功能。基本语法是通过 **{}** 和 **:** 来代替以前的 **%** 。使用format()来格式化字符串时，使用在字符串中使用{}作为占位符，占位符的内容将引用format()中的参数进行替换。可以是位置参数、命名参数或者兼而有之。

format 函数可以接受不限个参数，位置可以不按顺序。

**语法：**format(value, format_spec)

```python
print(format(9, 'b'))  # 转换成二进制,输出1001
print(format(9, 'o'))  # 转换成八进制,输出11
print(format(9, 'd'))  # 转换成十进制,输出9
print(format(12, 'x'))  # 转换成十六进制,小写显示，输出c
print(format(12, 'X'))  # 转换成十六进制,大写显示，输出C
print(format(65, 'c'))  # 转换成ASCII,输出A

->>
    1001
    11
    9
    c
    C
    A
    
# 位置参数
'{}:您{}购买的{}到了！请下楼取快递。'.format('快递小哥','淘宝','快递')
'快递小哥:您淘宝购买的快递到了！请下楼取快递。'




#给批量客户发短息
n_list=['马云','马化腾','麻子','小红','李彦宏','二狗子']
for name in n_list:
    print('{0}：您淘宝购买的快递到了！请下楼取快递！'.format(name))
马云：您淘宝购买的快递到了！请下楼取快递！
马化腾：您淘宝购买的快递到了！请下楼取快递！
麻子：您淘宝购买的快递到了！请下楼取快递！
小红：您淘宝购买的快递到了！请下楼取快递！
李彦宏：您淘宝购买的快递到了！请下楼取快递！
二狗子：您淘宝购买的快递到了！请下楼取快递！  
    
#名字进行填充    
for n in n_list:
    print('{0}：您淘宝购买的快递到了！请下楼取快递！'.format(n.center(3,'*')))
    
*马云：您淘宝购买的快递到了！请下楼取快递！
马化腾：您淘宝购买的快递到了！请下楼取快递！
*麻子：您淘宝购买的快递到了！请下楼取快递！
*小红：您淘宝购买的快递到了！请下楼取快递！
李彦宏：您淘宝购买的快递到了！请下楼取快递！
二狗子：您淘宝购买的快递到了！请下楼取快递！


'{0}, {1} and {2}'.format('gao','fu','shuai')
'gao, fu and shuai'


x=3
y=5
'{0}+{1}={2}'.format(x,y,x+y)


# 命名参数
'{name1}, {name2} and {name3}'.format(name1='gao', name2='fu', name3='shuai')
'gao, fu and shuai'


# 混合位置参数、命名参数
'{name1}, {0} and {name3}'.format("shuai", name1='fu', name3='gao')
'fu, shuai and gao'


#for循环进行批量处理
["vec_{0}".format(i) for i in range(0,5)]
['vec_0', 'vec_1', 'vec_2', 'vec_3', 'vec_4']


['f_{}'.format(r) for r in list('abcde')]
['f_a', 'f_b', 'f_c', 'f_d','f_e']
```

## getattr	

**描述：**获取对象的属性

**语法：**getattr(object, name[, default])

**参数：**

- object -- 对象。
- name -- 字符串，对象属性。
- default -- 默认返回值，如果不提供该参数，在没有对应属性时，将触发 AttributeError。

​		

```python
class Age(object):
      age = 1
  
my_a = Age()
getattr(my_a, 'age')        # 获取属性 bar 值
 1
getattr(my_a, 'age1')
'Age' object has no attribute 'age1'
```



## globals	

**描述：** 函数会以字典类型返回当前位置的全部全局变量。

**语法：**globals()

**参数：无**	

```python
a = 3
globals()
li = [k for k, v in globals().items() if not k.startswith("_")]
li

->>
    ['In',
     'Out',
     'get_ipython',
     'exit',
     'a',
     'func',
     'new_li']
    
a='runoob'
print(globals()) # globals 函数返回一个全局变量的字典，包括所有导入的变量。
```

## hasattr	

**描述：**函数用于判断对象是否包含对应的属性。

**语法：**hasattr(object, name)

**参数：**

- object -- 对象。
- name -- 字符串，属性名。

​		

```python
class Coordinate:
    x = 10
    y = -5
    z = 0
 
point1 = Coordinate() 
print(hasattr(point1, 'x'))
True
print(hasattr(point1, 'y'))
True
print(hasattr(point1, 'z'))
True
print(hasattr(point1, 'no'))  # 没有该属性
False
```



## hash	

**描述：**返回对象的哈希值

**语法：**hash(object)

**参数：**object -- 对象；	

- 可hash类型：
   - "数字类型：int, float, decimal.Decimal, fractions.Fraction, complex"
   - "字符串类型：str, bytes"
   - "元组：tuple"
    - "冻结集合：frozenset"
    - "布尔类型：True, False"
    - "None"
- 不可hash类型：原地可变类型：list、dict和set。它们不可以作为字典的key。

  ```python
  hash([1,2,3])   # 报错，不可哈希
  
  hash((1, 2, 3))
  ->>2528502973977326415
  
  # hash（获取对象的哈希值）
  print(hash('xxoo'))
  ->>    -1471539393069411467
  
  ```

hash() 函数可以应用于数字、字符串和对象，不能直接应用于 list、set、dictionary。

  在 hash() 对对象使用时，所得的结果不仅和对象的内容有关，还和对象的 id()，也就是内存地址有关。

  class Test:
      def __init__(self, i):
          self.i = i
  for i in range(10):
      t = Test(1)
      print(hash(t), id(t))
      

  hash(point1)
  16294976


  hash('返回对象的哈希值')
  4919828709165481160


  hash() 函数的用途
  hash() 函数的对象字符不管有多长，返回的 hash 值都是固定长度的，也用于校验程序在传输过程中
  是否被第三方（木马）修改，如果程序（字符）在传输过程中被修改hash值即发生变化，如果没有被
  修改，则 hash 值和原始的 hash 值吻合，只要验证 hash 值是否匹配即可验证程序是否带木马（病毒）。

  name1='正常程序代码'
  name2='正常程序代码带病毒'

  print(hash(name1)) # -3048480827538126659
  print(hash(name2)) # -9065726187242961328
  ```
  
  

## help	

**描述：**返回对象的帮助文档

**语法：**help([object])

**参数：**object -- 对象

​```python
help(dict)

->>
Help on class dict in module builtins:
    
help('sys')             # 查看 sys 模块的帮助
help('str')             # 查看 str 数据类型的帮助
a = [1,2,3]
help(a)                 # 查看列表 list 帮助信息
 
help(a.append)       # 显示list的append方法的帮助
  ```

​		

```python
li = [k for k, v in vars(dict).items() if not k.startswith("__")]
li

->>
    ['get',
    'setdefault',
    'pop',
    'popitem',
    'fromkeys',
    'clear',
    'copy']
```

## hex	

**描述：hex()** 函数用于将10进制整数转换成16进制，以字符串形式表示。

**语法：**hex(x)

**参数：**x -- 10进制整数。		

```python
hex(123)
'0x7b'
		
将十进制转换为十六进制
hex(43)
'0x2b'#43等于2B

hex(15)
'0xf'
```

## id	

**描述：id()** 函数返回对象的唯一标识符，标识符是一个整数。CPython 中 **id()** 函数用于获取对象的内存地址。

**语法：**id([object])

**参数：**object -- 对象。

```python
a = 3
print(id(a))

->>140722163651456
```

## input	

**描述：**Python3.x 中 input() 函数接受一个标准输入数据，返回为 string 类型。获取用户输入内容

**语法：**input([prompt])

**参数：**prompt: 提示信息	

```python
name = input('please input your name:')
print(name)
		

->>
please input your name:lhh
lhh
```

## int	

**描述：**int() 函数用于将一个字符串或数字转换为整型。 x可能为字符串或数值，将x 转换为一个普通整数。如果参数是字符串，那么它可能包含符号和小数点。如果超出了普通整数的表示范围，一个长整数被返回。

**语法：**int(x, base =10)

**参数：**

- x -- 字符串或数字。
- base -- 进制数，默认十进制。

​	

```python
a = int(1024)
a

->>1024

int('12',16)
18


int('12',10)
12
```

## isinstance	

**描述：**isinstance() 函数来判断一个对象是否是一个已知的类型，类似 type()。

isinstance() 与 type() 区别：

type() 不会认为子类是一种父类类型，不考虑继承关系。

isinstance() 会认为子类是一种父类类型，考虑继承关系。

如果要判断两个类型是否相同推荐使用 isinstance()。



**语法：**isinstance(object, classinfo)

**参数：**

- object -- 实例对象。
- classinfo -- 可以是直接或间接类名、基本类型或者由它们组成的元组。

​	

```python
print(isinstance(123, int))  # 输出True
print(isinstance(['a', 'b'], list))  # 输出True
print(isinstance(('a', 'b'), tuple))  # 输出True
print(isinstance('abc', (int, str, list)))  # 输出True
print(isinstance('ab', int))  # 输出False

->>
    True
    True
    True
    True
    False
    
a = 2
isinstance (a,int)
True
isinstance (a,str)
False
isinstance (a,(str,int,list))#是元组中的一个返回 True
True
```

## issubclass	

**描述：issubclass()** 方法用于判断参数 class 是否是类型参数 classinfo 的子类。如果class是classinfo类的子类，返回True：

**语法：**issubclass(class, classinfo)

**参数：**

- class -- 类。
- classinfo -- 类。

​	

```python
class A:
    pass
class B(A):
    pass
    
print(issubclass(B,A))    # 返回 True
```

​	

## iter	

**描述：iter()** 函数用来生成迭代器。

**语法：**iter(object[, sentinel])

**参数：**

- object -- 支持迭代的集合对象。
- sentinel -- 如果传递了第二个参数，则参数 object 必须是一个可调用的对象（如，函数），此时，iter 创建了一个迭代器对象，每次调用这个迭代器对象的__next__()方法时，都会调用 object。返回一个可迭代对象, sentinel可省略，sentinel 理解为迭代对象的哨兵，一旦迭代到此元素，立即终止：

```python
l = iter([1, 2, 3, 4, 5])
next(l), next(l), next(l)

->>    
(1, 2, 3)

lst = [1,3,5]
iter(lst)
<list_iterator at 0xf8359e8>


for i in iter(lst):
    print(i)
1
3
5  
```

## len	

**描述：**len() 函数返回对象（字符、列表、元组等）长度或项目个数。

**语法：**len(s)

**参数：**s -- 对象。	

```python
a = [1, 2, 3, 4]
print(len(a))
		
->>4

#字典的长度
dic = {'a':1,'b':3}
len(dic)
2


#字符串长度
s='aasdf'
len(s)
5


#列表元素个数
l = [1,2,3,4,5]
len(l)   
```

## list	

**描述：**list() 函数创建列表或者用于将元组转换为列表。

**语法：**list( tup )

**参数：**tup -- 要转换为列表的元组。	

```python
li = list([1, 2, 3, 4])

atuple = (123, 'xyz', 'zara', 'abc')
aList = list(atuple)


aList
[123, 'xyz', 'zara', 'abc']
```

​		

## locals	

返回当前所有局部变量	

## locals()

## map

**描述：map()** 会根据提供的函数对指定序列做映射。返回一个将 function 应用于 iterable 中每一项并输出其结果的迭代器

**语法：**map(function, iterable, ...)

**参数：**

- function -- 函数
- iterable -- 一个或多个序列

```python
def square(x) :            # 计算平方数
    return x ** 2
list(map(square, [1,2,3,4,5]))   # 计算列表各个元素的平方
[1, 4, 9, 16, 25]


list(map(lambda x: x ** 2, [1, 2, 3, 4, 5]))  # 使用 lambda 匿名函数
[1, 4, 9, 16, 25]


# 提供了两个列表，对相同位置的列表数据进行相加
list(map(lambda x, y: x + y, [1, 3, 5, 7, 9], [2, 4, 6, 8, 10]))
[3, 7, 11, 15, 19]


list(map(lambda x: x%2==1, [1,3,2,4,1]))
[True, True, False, False, Tru
```



## max	

**描述：**max() 方法返回给定参数的最大值，参数可以为序列。

**语法：**max( x, y, z, .... )

**参数：**

- x -- 数值表达式。
- y -- 数值表达式。
- z -- 数值表达式。

​	

```python
print(max(2, 4, 6, 8))

->>8

最大值：
max(3,1,4,2,1)
4


di = {'a':3,'b1':1,'c':4}
max(di)
'c'
```

​		

## memoryview()

**描述：memoryview()** 函数返回给定参数的内存查看对象(Momory view)。返回由给定实参创建的“内存视图”对象， Python 代码访问一个对象的内部数据，只要该对象支持缓冲区协议 而无需进行拷贝

**语法：**memoryview(obj)

**参数：**obj -- 对象

```python
v = memoryview(bytearray("abcefg", 'utf-8'))
v[1]
98
v[-1]
98
 v[1:4]
<memory at 0x0000028B68E26AC8>
v[1:4].tobytes()
b'bce'
```



## min	

**描述：**min() 方法返回给定参数的最小值，参数可以为序列。

**语法：**min( x, y, z, .... )

**参数：**

- x -- 数值表达式。
- y -- 数值表达式。
- z -- 数值表达式。

​	

```python
print(min(2, 4, 6, 8))

->>2

min(80, 100, 1000)
80
min([80, 100, 1000])
80
```

​		

## next	

**描述：next()** 返回迭代器的下一个项目。next() 函数要和生成迭代器的iter() 函数一起使用。

**语法：**next(iterator[, default])

**参数：**

- iterator -- 可迭代对象
- default -- 可选，用于设置在没有下一个元素时返回该默认值，如果不设置，又没有下一个元素则会触发 StopIteration 异常。

​		

```python
it = iter([5,3,4,1])
next(it)
5
 
next(it)
3
 
next(it)
4
```



## object	

**描述：**Object类是Python中所有类的基类，如果定义一个类时没有指定继承哪个类，则默认继承object类。返回一个没有特征的新对象。object 是所有类的基类。

**语法：**object()

**参数：无**

```

```

​		

## oct

**描述：**将十进制转换为八进制

**语法：**oct(x)

**参数：**x -- 整数。

```python
print(oct(12))

->>    0o14

oct(8)
'0o10'

oct(43)
'0o53'
```

​		

## open	

**描述：**open() 函数用于打开一个文件，创建一个 **file** 对象，相关的方法才可以调用它进行读写。

**语法：**open(name[, mode[, buffering]])

**参数：**

- name : 一个包含了你要访问的文件名称的字符串值。
- mode : mode 决定了打开文件的模式：只读，写入，追加等。所有可取值见如下的完全列表。这个参数是非强制的，默认文件访问模式为只读(r)。
- buffering : 如果 buffering 的值被设为 0，就不会有寄存。如果 buffering 的值取 1，访问文件时会寄存行。如果将 buffering 的值设为大于 1 的整数，表明了这就是的寄存区的缓冲大小。如果取负值，寄存区的缓冲大小则为系统默认。

​		

## ord	

**描述：**查看某个ascii对应的十进制数

**语法：**ord(c)

**参数：**c -- 字符。

```python
ord('A')
65


ord('~')
126
```

​		

## pow	

**描述：pow()** 方法返回 xy（x的y次方） 的值。函数是计算x的y次方，如果z在存在，则再对结果进行取模，其结果等效于pow(x,y) %z

**语法：**pow(x, y[, z])

**参数：**

- x -- 数值表达式。
- y -- 数值表达式。
- z -- 数值表达式。

```python
ret = pow(2, 3)  # 求2的3次方
print(ret)

->>8

pow(10, 2)
100


pow(4,3,5)
 4
等价于4**3%5
```

​		

## print

打印输出	

```python
print(123)

->>123
```

​		

## property	

**描述：property()** 函数的作用是在新式类中返回属性值。

**语法：**class property([fget[, fset[, fdel[, doc]]]])

**参数：**

- fget -- 获取属性值的函数
- fset -- 设置属性值的函数
- fdel -- 删除属性值函数
- doc -- 属性描述信息

​		

## range	

**描述：**range() 函数可创建一个整数列表，一般用在 for 循环中。

**语法：**range(start, stop[, step])

**参数：**

- start: 计数从 start 开始。默认是从 0 开始。例如range（5）等价于range（0， 5）;
- stop: 计数到 stop 结束，但不包括 stop。例如：range（0， 5） 是[0, 1, 2, 3, 4]没有5
- step：步长，默认为1。例如：range（0， 5） 等价于 range(0, 5, 1)

```python
for i in range(1, 10):
	print(i)  # 打印1到9的数字
    
list(range(10))
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
 
list(range(1, 11))     # 从 1 开始到 11
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


list(range(0, 30, 5))
[0, 5, 10, 15, 20, 25]


for i in range(5):
    print(i)
0
1
2
3
```

​		

## repr	

将对象转化为供解释器读取的形式	

```python
dt = {'runoob': 'runoob.com', 'google': 'google.com'}
repr(dt)

->>    "{'runoob': 'runoob.com', 'google': 'google.com'}"
```

​		

## reversed	

**描述：**reversed 函数返回一个反转的迭代器。

**语法：**reversed(seq)

**参数：**seq -- 要转换的序列，可以是 tuple, string, list 或 range。

```python
n = [1, 2, 3, 4, 5]
m = reversed(n)
print(list(m))  # m是reversed对象，要转成list输出

->>    
	[5, 4, 3, 2, 1]
    
#反转列表
rev = reversed([1,4,2,3,1])
list(rev)
[1, 3, 2, 4, 1]


for i in rev:
    print(i)
1
3
2
4
1 


#反转字符串
rev = reversed('我爱中国')
list(rev)
['国', '中', '爱', '我']


for i in rev:
    print(i)
国
中
爱
```

​		

## round	

**描述：round()** 函数返回浮点数x的四舍五入值。

**语法：**round( x [, n] )

**参数：**

- x -- 数值表达式。
- n --代表小数点后保留几位

​	

```python
print(round(4.3))
print(round(4.8))

->>
    4
    5
    
round(10.0222222, 3)
10.022
```

​		

## set	

**描述：set()** 函数创建一个无序不重复元素集，可进行关系测试，删除重复数据，还可以计算交集、差集、并集等。

**语法：**class set([iterable])

**参数：**iterable -- 可迭代对象对象；	

```Python
n = set([1, 2, 2, 3, 3])
print(n)

->>    {1, 2, 3}

A = set('hello')
B = set('world')

A.union(B) # 并集，输出：{'d', 'e', 'h', 'l', 'o', 'r', 'w'}
A.intersection(B) # 交集，输出：{'l', 'o'}
A.difference(B) # 差集，输出：{'d', 'r', 'w'}
```

​		

## setattr	

描述	示例
		

## slice	

**描述：slice()** 函数实现切片对象，主要用在切片操作函数里的参数传递。返回一个表示由 range(start, stop, step) 所指定索引集的 slice对象

**语法：**

class slice(stop)

class slice(start, stop[, step])

**参数：**

- start -- 起始位置
- stop -- 结束位置
- step -- 间距

​	

```python
a = [1,4,2,3,1]
a[slice(0,5,2)] #等价于a[0:5:2]
[1, 2, 1]
```

​	

## sorted

**描述：sorted()** 函数对所有可迭代的对象进行排序操作。

sort 与 sorted 区别：

sort 是应用在 list 上的方法，sorted 可以对所有可迭代的对象进行排序操作；list 的 sort 方法返回的是对已经存在的列表进行操作，无返回值，而内建函数 sorted 方法返回的是一个新的 list，而不是在原来的基础上进行的操作。

**语法：**sorted(iterable, key=None, reverse=False)#cmp 3.x已经没有了

**参数：**

- iterable -- 可迭代对象。
- key -- 主要是用来进行比较的元素，只有一个参数，具体的函数的参数就是取自于可迭代对象中，指定可迭代对象中的一个元素来进行排序。
- reverse -- 排序规则，reverse = True 降序 ， reverse = False 升序（默认）。

```python
s = [5, 2, 7, 9, 3]
print(sorted(s))
#输出：[2, 3, 5, 7, 9]
    
sorted((4,1,9,6),reverse=True)
print(a)
# 输出：[9, 6, 4, 1]

chars = ['apple','watermelon','pear','banana']
a = sorted(chars,key=lambda x:len(x))
print(a)
# 输出：['pear', 'apple', 'banana', 'watermelon']

tuple_list = [('A', 1,5), ('B', 3,2), ('C', 2,6)]
# key=lambda x: x[1]中可以任意选定x中可选的位置进行排序
a = sorted(tuple_list, key=lambda x: x[1])
print(a)
# 输出：[('A', 1, 5), ('C', 2, 6), ('B', 3, 2)]
```

​		

```python
a = [5,7,6,3,4,1,2]
b = sorted(a)       # 保留原列表
a 
[5, 7, 6, 3, 4, 1, 2]
b
[1, 2, 3, 4, 5, 6, 7]
 
#利用key
L=[('b',2),('a',1),('c',3),('d',4)]


sorted(L, key=lambda x:x[1])  
[('a', 1), ('b', 2), ('c', 3), ('d', 4)]


#按年龄排序
students = [('john', 'A', 15), ('jane', 'B', 12), ('dave', 'B', 10)]
sorted(students, key=lambda s: s[2]) 
[('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]


#按降序
sorted(students, key=lambda s: s[2], reverse=True)  
[('john', 'A', 15), ('jane', 'B', 12), ('dave', 'B', 10)]
 
#降序排列
a = [1,4,2,3,1]
sorted(a,reverse=True) 
[4, 3, 2, 1, 1]
```



## staticmethod

**描述：**staticmethod 返回函数的静态方法。该方法不强制要求传递参数，如下声明一个静态方法：

**语法：**

class C(object):

@staticmethod

def f(arg1, arg2, ...):

...

以上实例声明了静态方法 **f**，从而可以实现实例化使用 **C().f()**，当然也可以不实例化调用该方法 **C.f()**。

**参数：**无

```python
class C(object):
    @staticmethod
    def f():
        print('runoob');
 
C.f();          # 静态方法无需实例化
cobj = C()
cobj.f()        # 也可以实例化后调用
```

​		

## str

**描述：**str() 函数将对象转化为适于人阅读的形式。将字符类型、数值类型等转换为字符串类型

**语法：**class str(object='')

**参数：**object -- 对象。

```python
integ = 100
str(integ)
'100'


dict = {'baidu': 'baidu.com', 'google': 'google.com'};
str(dict)
"{'baidu': 'baidu.com', 'google': 'google.com'}"
```

​		

## sum

**描述：sum()** 方法对系列进行求和计算。

**语法：**sum(iterable[, start])

**参数：**

- iterable -- 可迭代对象，如：列表、元组、集合。
- start -- 指定相加的参数，如果没有设置这个值，默认为0。

​	

```python
print(sum([1, 2, 3]))

->>6

a = [1,4,2,3,1]
sum(a)
11
 
sum(a,10) #求和的初始值为10
21
```

​		

## super	

**描述：super()** 函数是用于调用父类(超类)的一个方法。

super 是用来解决多重继承问题的，直接用类名调用父类方法在使用单继承的时候没问题，但是如果使用多继承，会涉及到查找顺序（MRO）、重复调用（钻石继承）等种种问题。

MRO 就是类的方法解析顺序表, 其实也就是继承父类方法时的顺序表。

**语法：**super(type[, object-or-type])

**参数：**

- type -- 类。
- object-or-type -- 类，一般是 self

​		

```python
class A:
     def add(self, x):
         y = x+1
         print(y)
class B(A):
    def add(self, x):
        super().add(x)
b = B()
b.add(2)  # 3
3
```



## tuple	

**描述：** 元组 tuple() 函数将列表转换为元组。

**语法：**tuple( iterable )

**参数：**iterable -- 要转换为元组的可迭代序列。	

```python
tuple([1,2,3,4])
(1, 2, 3, 4)
 
tuple({'a':2,'b':4})    #针对字典 会返回字典的key组成的tuple
 ('a', 'b')
```

​		

## type	

**描述：**type() 函数如果你只有第一个参数则返回对象的类型，三个参数返回新的类型对象。

isinstance() 与 type() 区别：

- type() 不会认为子类是一种父类类型，不考虑继承关系。
- isinstance() 会认为子类是一种父类类型，考虑继承关系。

如果要判断两个类型是否相同推荐使用 isinstance()。



**语法：**

type(object)

type(name, bases, dict)



**参数：**

- name -- 类的名称。
- bases -- 基类的元组。
- dict -- 字典，类内定义的命名空间变量。

​	

```python
n = 123
print(type(n))
->>   

type([2])
list


type({0:'zero'})
dict


x = 1          
type( x ) == int    # 判断类型是否相等
True
 
# 三个参数
class X(object):
    a = 1


X = type('X', (object,), dict(a=1))  # 产生一个新的类型 X
X
 __main_
```

##  vars

查看某个对象或模块提供了哪些功能，返回字典，dir是返回列表	

```python
vars(str)
```

​		

## zip

**描述：zip()** 函数用于将可迭代的对象作为参数，将对象中对应的元素打包成一个个元组，然后返回由这些元组组成的对象，这样做的好处是节约了不少的内存。

我们可以使用 list() 转换来输出列表。

如果各个迭代器的元素个数不一致，则返回列表长度与最短的对象相同，利用 ***** 号操作符，可以将元组解压为列表。

**语法：**zip([iterable, ...])

**参数：**iterable 一个或多个迭代器

```python
x = [1, 2, 3]
y = [6, 7, 8, 9]
z = zip(x, y)
print(list(z))  # 取到最短的序列
->>    [(1, 6), (2, 7), (3, 8)]
```



```python
创建一个聚合了来自每个可迭代对象中的元素的迭代器：
x = [3,2,1]
y = [4,5,6]
list(zip(y,x))
[(4, 3), (5, 2), (6, 1)]


#搭配for循环，数字与字符串组合 
a = range(5)
b = list('abcde')
[str(y) + str(x) for x,y in zip(a,b)]
['a0', 'b1', 'c2', 'd3', 'e4']


list1 = [2,3,4]
list2 = [5,6,7]
for x,y in zip(list1,list2):
    print(x,y,'--',x*y)
2 5 -- 10
3 6 -- 18
4 7 -- 28


#元素个数与最短的列表一致
list(zip(x,b))
 [(3, 'a'), (2, 'b'), (1, 'c')]


#与 zip 相反，zip(* ) 可理解为解压，返回二维矩阵式
a1, a2 = zip(*zip(a,b))          
a1
(0, 1, 2, 3, 4)
a2
('a', 'b', 'c', 'd', 'e'
```



# 使用表达式

## 算术运算符

## 赋值运算符

## 比较运算符

## 逻辑运算符

## 位运算符

# 流程结构

## 根据条件进行选择

### if

```python
num = 9
if num >= 0 and num <= 10:    
    print('hello')
```

### if--else--

```python
num = 10
if num < 0 or num > 10:    
    print('hello')
else:
    print('undefine')
```

### if--elif--else--

```python
num = 2
if num == 3:            
    print('boss')
elif num == 2:
    print('user')
elif num == 1:
    print('worker')
elif num < 0:           
    print('error')
else:
    print('roadman')
```

## 循环语句

### while循环

```python
count = 0
while (count < 5):
    print('The count is:', count)
    count = count + 1
print("Good bye!")
```

```python
count = 0
while count < 5:
    print(count, " is  less than 5")
    count = count + 1
else:
    print(count, " is not less than 5")
```

### for循环

```python
fruits = ['banana', 'apple', 'mango']
for fruit in fruits:
    print('当前水果 :', fruit)
print("Good bye!")
```

```python
for num in range(5, 10):  
    for i in range(2, num):  # 根据因子迭代
        if num % i == 0:  # 确定第一个因子
            j = num / i  # 计算第二个因子
            print('%d 等于 %d * %d' % (num, i, j))
            break  # 跳出当前循环
    else:  # 循环的 else 部分
        print(num, '是一个质数')
```

## 特殊流程控制

### break语句

```python
for letter in 'Python': 
    if letter == 'h':
        break
    print('Current Letter :', letter)
```

### continue语句

```python
for letter in 'Python': 
    if letter == 'h':
        continue
    print('当前字母 :', letter)
```

### pass

```python
for letter in 'Python':
    if letter == 'h':
        pass
        print '这是 pass 块'
    print('当前字母 :', letter)
print "Good bye!"
```

