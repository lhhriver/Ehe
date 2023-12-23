- 安装

pip install virtualenv



- 创建目录

Windows系统的话, 新建一个空的文件目录, linux的话 mkdir XXX_project



- 创建虚拟环境

    # 创建完全与外部packages隔离的虚拟环境 myenv, python版本可能是最新的python3.7
    virtualenv --no-site-packages myenv
    virtualenv myenv
    
    # 如果新的python虚拟环境也需要原来python的第三方库，可以将第三方库一起复制到新的虚拟环境
    virtualenv --system-site-packages myenv
    
    # win 指定本地已有的python3.5版本(本地已有python2.7, python3.5, python3.7的解释器)
    virtualenv -p C:\Users\Administrator\AppData\Local\Programs\Python\Python35\python.exe myenv
    
    # linux
    virtualenv -p /usr/bin/python3.5 myenv



- 进入虚拟环境

在新创建的目录中, 进入CMD终端命令, 执行下面命令, 只需要记住, 在win系统下, 激活就是还行 Scripts 下面activate 的脚本, 关闭就是执行 deactivate.bat 的脚本就OK了



```py
# windows 
myenv\Scripts\activate

cd myenv/Scripts
activate

# linux
source myenv/bin/activate
```



- 进入之后查看已安装的包

```
pip list
```




- 退出虚拟环境

```py
# Windows (记不住单词没关系 按Tab键是可以自动补全的)
myenv\Scripts\deactivate.bat

# linux
deactivate
```



- 删除虚拟环境

```py
# windows
简单粗暴, 直接删除创建时生成的 myenv 的目录就好了

# linux
rm -r myenv
```



- 激活虚拟环境中的jupyter notebook

	```python
	# 一、进入虚拟环境
	source tf1/bin/activate
	
	# 二、安装 IPykernel
	# python2版本：
	pip install ipykernel
	# python3版本：
	pip3 install ipykernel
	
	
	# 三、将 Virtualenv 加入IPykernel中
	# python2版本：
	python2 -m ipykernel install --user --name=tf1
	# python3版本：
	python3 -m ipykernel install --user --name=tf1
	
	#四、启动jupyter notebook并更改kernel（右上角Logout下面的名字即为环境名称）
	```

	






- 在我们有多个虚拟环境时候，如何复制一个虚拟环境的包到另一个环境中去呢？

1. 到原始的virtualenv变量的scripts目录下，导出此环境下安装的包的版本信息

　　pip freeze > requirements.txt

2. 来到新的虚拟环境下，复制上不导出的requirements.txt文件到scripts目录下，执行安装命令

　　pip install -r requirements.txt