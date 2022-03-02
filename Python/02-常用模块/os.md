该模块就是操作系统相关的功能了，用于处理文件和目录这些我们日常手动需要做的操作，比如**新建文件夹**、**获取文件列表**、**删除某个文件、获取文件大小、重命名文件**、**获取文件修改时间**等。

```python
##  加载
import os

##  查看os下的函数 
print(dir(os))

##  查看os.path下的函数 
print(dir(os.path))
```



# os.func

##  **os.name（）**

**描述：**显示当前使用的平台，'nt'表示Windows，'posix' 表示Linux

**语法：os.name**

```python
os.name
'nt'
```



##  **os.getcwd（）**

**描述：**返回当前进程的工作目录。

**语法：**os.getcwd()

```python
os.getcwd()
'C:\\Users\\wuzhengxiang'
```



##  os.curdir

```python
os.curdir
```



##  **os.chdir（）**

**描述：**改变当前工作目录到指定的路径。

**语法：**os.chdir(path)

```python
##  查看当前目录
os.getcwd()
'C:\\Users\\wuzhengxiang'

##  重新设置当前工作空间
os.chdir('C:/Users/wuzhengxiang/Desktop/股票数据分析')

##  再次查看当前目录，已经变成新的了
os.getcwd()
'C:\\Users\\wuzhengxiang\\Desktop\\股票数据分析
```



##  **os.makedirs（）**

**描述：**方法用于递归创建目录。像 mkdir(), 但创建的所有intermediate-level文件夹需要包含子目录。

**语法：**os.makedirs(path, mode=0o777)

```python
os.makedirs('C:/Users/wuzhengxiang/Desktop/股票数据分析/1122', mode=0o777)

os.makedirs('py18\\1\\2\\3')
```



##  **os.mkdir（）**

**描述：**以数字权限模式创建目录。默认的模式为 0777 (八进制)。

**语法：**os.mkdir(path[, mode])

```python
##  创建新的目2233
os.mkdir('C:/Users/wuzhengxiang/Desktop/股票数据分析/2233', mode=0777  )
```



##  **os.listdir（）**

**描述：**列出目录下的所有文件和文件夹

**语法：**os.listdir（path）

```python
os.listdir('C:/Users/wuzhengxiang/Desktop/股票数据分析')
['ETF研究.py', 'foo.txt', 'pi.txt', 'render.html']


os.listdir('.') 
['ETF研究.py', 'foo.txt', 'pi.txt', 'render.html']
```



##  os.rmdir

```python
os.rmdir('py18\\1\\2\\3')  ##  只能删除目录
```



##  **os.remove（）**

**描述：**用于删除指定路径的文件。如果指定的路径是一个目录，将抛出OSError。

语法：os.remove(path)

```python
os.remove('C:/Users/zhengxiang.wzx/Desktop/timg.jpg')
```



##  **os.rename（）**

**描述：**命名文件或目录,能对相应的文件进行重命名

**语法：**os.rename(src, dst)

参数

- **src** -- 要修改的目录名
- **dst** -- 修改后的目录名

```python
##  空间设置
data_path = 'C:/Users/zhengxiang.wzx/Desktop/微博情绪识别'
os.chdir(data_path)##  设置工作空间

os.getcwd()
'C:\\Users\\zhengxiang.wzx\\Desktop\\微博情绪识别'

os.rename("图片下载.py","图片下载1.py")
```



##  **os.renames()**

**描述：**用于递归重命名目录或文件。类似rename()。既可以重命名文件, 也可以重命名文件的上级目录名

**语法：**os.renames(old, new)

参数：

- **old** -- 要重命名的目录
- **new** --文件或目录的新名字。甚至可以是包含在目录中的文件，或者完整的目录树。

```python
os.chdir('C:/Users/wuzhengxiang/Desktop/Python知识点总结')
os.getcwd()


##  文件夹和文件同时命名
os.renames("test/Python 63个内置函数详解.py","test2/内置函数详解.py")


os.listdir()
['kaggle',
 'test2',
 '股票分析',
 '课程资源']
```



##  **os.linesep()**

**描述：**当前平台用于分隔（或终止）行的字符串。它可以是单个字符，如 POSIX 上是 '\n'，也可以是多个字符，如 Windows 上是 '\r\n'。在写入以文本模式（默认模式）打开的文件时，请不要使用 os.linesep 作为行终止符，请在所有平台上都使用一个 '\n' 代替。

**语法：**os.linesep

```python
os.linesep
'\r\n'
```



##  **os.pathsep()**

**描述：**操作系统通常用于分隔搜索路径（如 PATH）中不同部分的字符，如 POSIX 上是 ':'，Windows 上是 ';'。在 os.path 中也可用。

**语法：**os.pathsep

```python
os.pathsep
';'
```



##  **os.close（）**

**描述：**关闭指定的文件描述符 fd

**语法：**os.close(fd)

```python
fd = os.open( "foo.txt", os.O_RDWR|os.O_CREAT )
os.write(fd, bytes("This is test", encoding = "utf8"))
os.close( fd )
```



##  **os.stat（）**

**描述：**获取文件或者目录信息

**语法：**os.stat(path)

```python
os.stat('C:/Users/wuzhengxiang/Desktop/股票数据分析\\pi.txt')
os.stat_result(st_mode=33206, st_ino=22236523160361562, st_dev=2419217970, st_nlink=1, st_uid=0, st_gid=0, st_size=53, st_atime=1589638199, st_mtime=1589638199, st_ctime=1581868007)
```



##  **os.sep()**

**描述：**显示当前平台下路径分隔符,在 POSIX 上是 '/'，在 Windows 上是是 '\\'

语法：os.sep

```python
os.sep
'\\'
```



##  **os.walk()**

**描述：**遍历path，进入每个目录都调用visit函数，visit函数必须有3个参数(arg, dirname, names)，dirname表示当前目录的目录名，names代表当前目录下的所有文件名，args则为walk的第三个参数

**语法：**os.path.walk(path, visit, arg)

```python
list(os.walk(abs_cur_dir))
[('C:/Users/wuzhengxiang/Desktop/股票数据分析',
  ['1122'],
  ['ETF研究.py', 'foo.txt', 'pi.txt', 'render.html', 'test.gif']),
 ('C:/Users/wuzhengxiang/Desktop/股票数据分析\\1122', [], [])]


##  穷举遍历一个文件夹里面的所有文件，并获取文件的目录名
abs_cur_dir ='C:/Users/wuzhengxiang/Desktop/股票数据分析'
file_url=[]
for dirs,folders,files in os.walk(abs_cur_dir):
    for i in files:
            file_url.append(os.path.join(dirs,i))
            
file_url           
['C:/Users/wuzhengxiang/Desktop/股票数据分析\\ETF研究.py',
 'C:/Users/wuzhengxiang/Desktop/股票数据分析\\foo.txt',
 'C:/Users/wuzhengxiang/Desktop/股票数据分析\\pi.txt',
 'C:/Users/wuzhengxiang/Desktop/股票数据分析\\render.html',
 'C:/Users/wuzhengxiang/Desktop/股票数据分析\\test.gif']

##  pathlib也能实现类似的


def file_name(file_dir):
    for root, dirs, files in os.walk(file_dir):
        print(root)  ##  当前目录路径
        ##  print(dirs)  ##  当前路径下所有子目录
        print(files)  ##  当前路径下所有非目录子文件

file_name(dir_)
```



# os.path

##  **os.path.abspath()**

**描述：**返回文件的绝对路径

**语法：**os.path.abspath(path)

```python
##  Excel文件
os.path.abspath('all_data.xlsx') 
'C:\\Users\\zhengxiang.wzx\\all_data.xlsx'


##  图片文件
os.path.abspath('IMG_7358.JPG') 
'C:\\Users\\zhengxiang.wzx\\IMG_7358.JPG'
```



##  **os.path.basename()**

**描述：**返回文件名，纯粹字符串处理逻辑，路径错误也可以

**语法：**os.path.basename(path)

```python
os.path.basename('C:\\Users\\zhengxiang.wzx\\all_data.xlsx')
'all_data.xlsx'

TAG = os.path.basename(__file__)
```



##  **os.path.commonprefix()**

**描述：**返回list(多个路径)中，所有path共有的最长的路径

**语法：**os.path.commonprefix(list)

```python
os.path.commonprefix(['http://c.biancheng.net/python/aaa', 'http://c.biancheng.net/shell/'])
'http://c.biancheng.net/'


os.path.commonprefix(['http://bianc/python/aaa', 'http://c.biancheng.net/shell/'])
'http://'
```



##  **os.path.dirname()**

**描述：**返回文件路径

**语法：**os.path.dirname(path)

```python
os.path.dirname('C://my_file.txt')
 'C://'


os.path.dirname('C://python//my_file.txt')
'C://python'
```



##  **os.path.exists()**

**描述：**如果路径 path 存在，返回 True；如果路径 path 不存在，返回 False。

**语法：**os.path.exists(path)

```python
os.path.exists('C:/Users/wuzhengxiang/Desktop/股票数据分析/pi.txt')
True

os.path.exists('C:/Users/wuzhengxiang/Desktop/股票数据分析/')
True

os.path.exists('C:/Users/wuzhengxiang/Desktop/股票数据分析/pi_01.txt')
Fals
```



##  **os.path.lexists()**

**描述：**路径存在则返回True，路径损坏也返回True， 不存在，返回 False。

**语法：**os.path.lexists

```python
os.path.lexists('C:/Users/wuzhengxiang/Desktop/股票数据分析/pi.txt')
True

os.path.lexists('C:/Users/wuzhengxiang/Desktop/股票数据分析/pi_01.txt')
False
```



##  **os.path.expanduser()**

**描述：**把path中包含的"~"和"~user"转换成用户目录

**语法：**os.path.expanduser(path)

```python
os.path.expanduser('~/wuzhengxiang/Desktop/股票数据分析/')
'C:\\Users\\wuzhengxiang/wuzhengxiang/Desktop/股票数据分析/'
```



##  **os.path.expandvars()**

**描述：**根据环境变量的值替换path中包含的"$name"和"${name}"

**语法：**os.path.expandvars(path)

```python
os.environ['KITTIPATH'] = 'D:/thunder'
path = '$KITTIPATH/train/2011_09_26_drive_0001_sync/proj_depth/velodyne_raw/image_02/0000000013.png'

os.path.expandvars(path)
'D:/thunder/train/2011_09_26_drive_0001_sync/proj_depth/velodyne_raw/image_02/0000000013.png'
```



##  **os.path.getatime()**

**描述：**返回最近访问时间（浮点型秒数），从新纪元到访问时的秒数。

**语法：**os.path.getatime(path)

```python
os.path.getatime('C:/Users/wuzhengxiang/Desktop/股票数据分析/pi.txt')
1589638199.1343248
```



##  **os.path.getmtime()**

**描述：**返回最近文件修改时间，从新纪元到访问时的秒数。

**语法：**os.path.getmtime(path)

```python
os.path.getmtime('C:/Users/wuzhengxiang/Desktop/股票数据分析/pi.txt')
1583069050.8148942 
```



##  **os.path.getctime()**

**描述：**返回文件 path 创建时间，从新纪元到访问时的秒数。

**语法：**os.path.getctime(path)

```python
os.path.getctime('C:/Users/wuzhengxiang/Desktop/股票数据分析/pi.txt')
1581868007.6123319
```



##  **os.path.getsize()**

**描述：**返回文件大小，如果文件不存在就返回错误

**语法：**os.path.getsize(path)

```python
os.path.getsize('C:/Users/wuzhengxiang/Desktop/股票数据分析/test.gif')
1128677
```



##  **os.path.isabs()**

**描述：**判断是否为绝对路径，也就是说在WIndow系统下，如果输入的字符串以" / "开头，os.path.isabs()就会返回True

**语法：**os.path.isabs(path)

```python
os.path.isabs('D:/thunder')
True

os.path.isabs('D:\thunder')
False

os.path.isabs('D:\\thunder')
True
```



##  **os.path.isfile()**

**描述：**判断路径是否为文件

**语法：**os.path.isfile(path)

```python
##  文件不存在 返回False
os.path.isfile("C:/Users/wuzhengxiang/Desktop/股票数据分析/pi_01.txt")
False

os.path.isfile("C:/Users/wuzhengxiang/Desktop/股票数据分析/pi.txt")
True

##  不是文件 返回False
os.path.isfile("C:/Users/wuzhengxiang/Desktop/股票数据分析/")
False

##  检验一个文件是否是目录，是否是文件
os.path.isfile(file
```



##  **os.path.isdir()**

**描述：**判断路径是否为目录

**语法：**os.path.isdir(path)

```python
os.path.isdir('C:/Users/wuzhengxiang/Desktop/股票数据分析')   
True

os.path.isdir('C:/Users/wuzhengxiang/Desktop/股票数据分析1')   
False

os.path.isdir('C:/Users/wuzhengxiang/Desktop/股票数据分析/pi.txt')   
False
```



##  **os.path.join()**

**描述：**把目录和文件名合成一个路径,1.如果各组件名首字母不包含’/’，则函数会自动加上,2.如果有一个组件是一个绝对路径，则在它之前的所有组件均会被舍弃,3.如果最后一个组件为空，则生成的路径以一个’/’分隔符结尾

**语法：**os.path.join(path1[, path2[, ...]])

```python
os.path.join('C:/Users','wuzhengxiang/Desktop/','股票数据分析')
'C:/Users\\wuzhengxiang/Desktop/股票数据分析'

Path1 = 'home'
Path2 = 'develop'
Path3 = 'code'

Path10 = Path1 + Path2 + Path3
Path20 = os.path.join(Path1,Path2,Path3)
print ('Path10 = ',Path10)
print ('Path20 = ',Path20)

Path10 =  homedevelopcode
Path20 =  home\develop\code

txt_path = os.path.join(os.path.realpath(os.curdir), "1.txt")  
```



##  **os.path.normcase()**

**描述：**转换path的大小写和斜杠

**语法：**os.path.normcase(path)

```python
os.path.normcase('D:\Python\test\data.txt')
'd:\\python\test\\data.txt'

os.path.normcase('c:/WINDOWS\\system64\\')
'c:\\windows\\system64\\'
```



##  **os.path.normpath()**

**描述：**规范path字符串形式

**语法：**os.path.normpath(path)

```python
os.path.normpath('c://windows\\System32\\../Temp/')
'c:\\windows\\Temp'
```



##  **os.path.realpath()**

**描述：**返回path的真实路径

**语法：**os.path.realpath(path)

```python
os.path.relpath('C:\\Users\\Administrat\\代码TRY\\test.ipynb', '代码TRY')
'..\\..\\..\\..\\Administrat\\代码TRY\\test.ipynb'

os.path.realpath(os.curdir)
```



##  **os.path.relpath()**

**描述：**返回从当前目录或 start 目录（可选）到达 path 之间要经过的相对路径。这仅仅是对路径的计算，不会访问文件系统来确认 path 或 start 的存在性或属性。

**语法：**os.path.relpath(path[, start])

```
os.path.relpath('C:/Users/wuzhengxiang/Desktop/股票数据分析\\test.gif')
'test.gif'
```



##  **os.path.samefile( )**

**描述：**判断目录或文件是否相同

**语法：**os.path.samefile(path1, path2)

```python
os.path.samefile('C:\\Users', 'C:\\Users')
True

os.path.samefile('C:\\Users', 'C:/Users')
True

os.path.samefile('C:\\Users', 'C:/Users/wuzhengxiang')
Fals
```



##  **os.path.split()**

**描述：**把路径分割成 dirname 和 basename，返回一个元组

**语法：**os.path.split(path)

```python
os.path.split('D:\Python\test\data.txt')
 ('D:\\Python\test', 'data.txt')
    
os.path.split(os.path.realpath(file))[0]
```



##  **os.path.splitdrive()**

**描述：**一般用在 windows 下，返回驱动器名和路径组成的元组

**语法：**os.path.splitdrive(path)

```python
os.path.splitdrive('C:/Users/zhengxiang.wzx/IMG_7358.JPG')
('C:', '/Users/zhengxiang.wzx/IMG_7358.JPG')
```



##  **os.path.splitext()**

**描述：**分割路径，返回路径名和文件扩展名的元组

**语法：**os.path.splitext(path)

```python
os.path.splitext('C:/Users/zhengxiang.wzx/IMG_7358.JPG')
('C:/Users/zhengxiang.wzx/IMG_7358', '.JPG')
```





#   Action

## 读取路径下指定类型文件

```python
def file_name(file_dir, tail):
    L = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            if os.path.splitext(file)[1] == '.'+ tail:   ##  将路径拆分为文件名+扩展名
                ##  L.append(os.path.join(root, file))   ##  路径+文件名
                ##  L.append(file)  ##  文件名
                L.append(os.path.splitext(file)[0])   ##  文件名不带后缀
    return L

file_name(dir_,'ipynb')
```

##  读取路径下全部文件

```python
def listdir(path, list_name):  ##  传入存储的list
    for file in os.listdir(path):
        file_path = os.path.join(path, file)
        if os.path.isdir(file_path):
            listdir(file_path, list_name)
        else:
            list_name.append(file_path)

li = []
listdir(dir_,li)
li
```



##   指定类型文件复制

```python
path = r"F:\SVN"

for root,dirs,files in os.walk(path):
    for i in files:
        if os.path.splitext(i)[-1]==".sql":
            root_new = root.replace(r"F:", r"F:\WORKSPACE\资源空间\SQL")
            if not os.path.exists(root_new):
                os.makedirs(root_new)
            shutil.copyfile(os.path.join(root,i),os.path.join(root_new,i))
```



##  树目录

```python
import os
import os.path

BRANCH = '├─'
LAST_BRANCH = '└─'
TAB = '│  '
EMPTY_TAB = '   '


def get_dir_list(path, placeholder=''):
    folder_list = [folder for folder in os.listdir(path) if os.path.isdir(os.path.join(path, folder))]
    file_list = [file for file in os.listdir(path) if os.path.isfile(os.path.join(path, file))]

    result = ''
    for folder in folder_list[:-1]:
        result += placeholder + BRANCH + folder + '\n'
        result += get_dir_list(os.path.join(path, folder), placeholder + TAB)

    if folder_list:
        result += placeholder + (BRANCH if file_list else LAST_BRANCH) + folder_list[-1] + '\n'
        result += get_dir_list(os.path.join(path, folder_list[-1]), placeholder + (TAB if file_list else EMPTY_TAB))

    for file in file_list[:-1]:
        result += placeholder + BRANCH + file + '\n'

    if file_list:
        result += placeholder + LAST_BRANCH + file_list[-1] + '\n'
    return result


tree = get_dir_list(r"C:\Users\admin\Desktop\绿瘦标签")
print(tree)
```



## 深度优先-广度优先

```python
import os
file_path = r'D:\Git_code\Taishan'


def BFS_Dir(path, dirCallback=None, fileCallback=None):
    queue = [] # 队列
    ret = [] # 文件
    queue.append(path) # 路径
    while len(queue) > 0:
        tmp = queue.pop(0)
        if os.path.isdir(tmp):
            ret.append(tmp)
            for item in os.listdir(tmp):
                queue.append(os.path.join(tmp, item))
            if dirCallback:
                dirCallback(tmp)
        elif os.path.isfile(tmp):
            ret.append(tmp)
            if fileCallback:
                fileCallback(tmp)
    return ret


def DFS_Dir(path, dirCallback=None, fileCallback=None):
    stack = [] # 文件栈
    ret = [] # 文件
    stack.append(path)
    while len(stack) > 0:
        tmp = stack.pop(len(stack) - 1)
        if os.path.isdir(tmp):
            ret.append(tmp)
            for item in os.listdir(tmp):
                stack.append(os.path.join(tmp, item))
                
            if dirCallback:
                dirCallback(tmp)
        elif os.path.isfile(tmp):
            ret.append(tmp)
            
            if fileCallback:
                fileCallback(tmp)
    return ret


def printDir(path):
    print("dir: " + path)


def printFile(path):
    print("file: " + path)


b = BFS_Dir(file_path, printDir, printFile)
d = DFS_Dir(file_path, printDir, printFile)
```

