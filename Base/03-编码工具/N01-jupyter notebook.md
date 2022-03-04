<center><font color=steel size=14 face=雅黑>Jupyter notebook 使用指南</font></center>

<center>更新时间：2019-07-10</center>

# 基本语法

## 字体

**这是加粗的文字** 

*这是倾斜的文字* 

***这是斜体加粗的文字*** 

~~这是加删除线的文字~~  

## 分割线

三个或者三个以上的 - 或者 * 都可以。

---


## 引用

>这是引用的内容
>>这是引用的内容
>>
>>

## 超链接

[百度](http://baidu.com)

<a href="http://baidu.com" target="_blank">百度</a>

## 列表

无序列表用 - + * 任何一种都可以

- 列表内容
+ 列表内容
* 列表内容

1. 列表内容
2. 列表内容
3. 列表内容

- 你好
  - 列表内容
  + 列表内容
  * 列表内容
  * 段落一
  
    > 区块标记一
* 段落二
  
    > 区块标记二

## 表格

姓名|技能|排行
---|---|---
刘备|哭|大哥
关羽|打|二哥
张飞|骂|三弟

## 代码

```python
def fun():
	print("这是一句非常牛逼的代码")

fun();
```

# 插入图片

## 在线图片


```
#![图片](https://img-blog.csdn.net/20150312214024150)
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-234146-948981)




```python
from IPython.display import Image
Image(url="https://img-blog.csdn.net/20150312214024150",width=420,height=240)
```



## 本地图片


```python
from IPython.display import Image
file_path = "C:/Users/Anchor/Desktop/taishan_plan/picture/yaktocat.png"
Image(filename=file_path,width=420,height=340)
```

```python
Image(filename=file_path,width="50%") 
```


```python
# ![图片](./pictures/6B1217.png)
```


```python
# <img style="float: center;" src=./6B1217.png width = 60%>
```



# 流程图

```
graph TB
A-->B
```

# 公式

https://blog.csdn.net/smilejiasmile/article/details/80670742

## 行中公式

$ J_\alpha(x) = \sum_{m=0}^\infty \frac{(-1)^m}{m! \Gamma (m + \alpha + 1)} {\left({ \frac{x}{2} }\right)}^{2m + \alpha} \text {，行内公式示例} $

## 独立公式示例

$$
J_\alpha(x) = \sum_{m=0}^\infty \frac{(-1)^m}{m! \Gamma (m + \alpha + 1)} {\left({ \frac{x}{2} }\right)}^{2m + \alpha} \text {，独立公式示例}
$$

## 如何输入上下标

^表示上标, _ 表示下标。如果上下标的内容多于一个字符，需要用 {}将这些内容括成一个整体。上下标可以嵌套，也可以同时使用。

$$
x^{y^z}=(1+{\rm e}^x)^{-2xy^w}
$$

$$
\sideset{^1_2}{^3_4}\bigotimes
$$



## 如何输入括号和分隔符

()、[]和|表示符号本身，使用 \{\} 来表示 {}。当要显示大号的括号或分隔符时，要用 \left 和 \right 命令。  

一些特殊的括号：
- $$\langle表达式\rangle$$	  
- $$\lceil表达式\rceil$$	 
- $$\lfloor表达式\rfloor$$	
- $$\lbrace表达式\rbrace$$

$$
f(x,y,z) = 3y^2z \left( 3+\frac{7x+5}{1+y^2} \right)
$$



## 如何输入分数

通常使用 \frac {分子} {分母}命令产生一个分数\frac {分子} {分母}，分数可嵌套。便捷情况可直接输入 \frac ab来快速生成一个\frac ab。如果分式很复杂，亦可使用 分子 \over 分母 命令，此时分数仅有一层。
$$
\frac{a-1}{b-1} \quad and \quad {a+1\over b+1}
$$

$$
P(A \mid B) = \frac{P(B \mid A) \, P(A)}{P(B)}
$$



## 如何输入开方

使用 \sqrt [根指数，省略时为2] {被开方数}命令输入开方。

$$
\sqrt{2} \quad and \quad \sqrt[n]{3}
$$


## 如何输入省略号

数学公式中常见的省略号有两种，\ldots 表示与文本底线对齐的省略号，\cdots 表示与文本中线对齐的省略号。

$$
f(x_1,x_2,\underbrace{\ldots}_{\rm ldots} ,x_n) = x_1^2 + x_2^2 + \underbrace{\cdots}_{\rm cdots} + x_n^2
$$


## 如何输入矢量

使用 \vec{矢量}来自动产生一个矢量。也可以使用 \overrightarrow等命令自定义字母上方的符号。

$$
\vec{a} \cdot \vec{b}=0
$$

$$
\overleftarrow{xy} \quad and \quad \overleftrightarrow{xy} \quad and \quad \overrightarrow{xy}
$$



## 如何输入积分

使用 \int_积分下限^积分上限 {被积表达式} 来输入一个积分。

$$
\int_0^1 {x^2} \,{\rm d}x
$$


## 如何输入极限运算

使用\lim_{变量 \to 表达式} 表达式 来输入一个极限。如有需求，可以更改 \to 符号至任意符号。

$$
\lim_{n \to +\infty} \frac{1}{n(n+1)} \quad and \quad \lim_{x\leftarrow{示例}} \frac{1}{n(n+1)}
$$


## 如何输入累加、累乘运算

使用 \sum_{下标表达式}^{上标表达式} {累加表达式}来输入一个累加。
与之类似，使用 \prod \bigcup \bigcap来分别输入累乘、并集和交集。
此类符号在行内显示时上下标表达式将会移至右上角和右下角。

$$
\sum_{i=1}^n \frac{1}{i^2} \quad and \quad \prod_{i=1}^n \frac{1}{i^2} \quad and \quad \bigcup_{i=1}^{2} R
$$


## 如何输入希腊字母

输入 \小写希腊字母英文全称和\首字母大写希腊字母英文全称来分别输入小写和大写希腊字母。
对于大写希腊字母与现有字母相同的，直接输入大写字母即可。

$\alpha$		$A$	 

$\beta$		$B$	 

$\gamma$		$\Gamma$	

$\delta$		$\Delta$	 

$\epsilon$		$E$	  

$\zeta$		$Z$	

$\eta$		$H$	 

$\theta$		$\Theta$	

$\iota$		$I$	

$\kappa$		$K$	  

$\lambda$		$\Lambda$	

$\nu$		$N$	

$\mu$		$M$	 

$\xi$		$\Xi$	

$o$		$O$	

$\pi$		$\Pi$	

$\rho$		$P$	   

$\sigma$		$\Sigma$	

$\tau$		$T$	

$\upsilon$		$\Upsilon$	   

$\phi$		$\Phi$	

$\chi$		$X$	

$\psi$		$\Psi$	 

$\omega$		$\Omega$

## 大括号和行标的使用

使用 \left和 \right来创建自动匹配高度的 (圆括号)，[方括号] 和 {花括号} 。

在每个公式末尾前使用\tag{行标}来实现行标。
$$
f\left(
   \left[ 
     \frac{
       1+\left\{x,y\right\}
     }{
       \left(
          \frac{x}{y}+\frac{y}{x}
       \right)
       \left(u+1\right)
     }+a
   \right]^{3/2}
\right)
\tag{行标}
$$


## 如何输入括号和分隔符

() 、 [] 和 | 表示自己， {} 表示 {} 。当要显示大号的括号或分隔符时，要用 \left 和 \right 命令。

$$
f(x,y,z) = 3y^2z \left( 3+\frac{7x+5}{1+y^2} \right)
$$


有时候要用\left.或\right.进行匹配而不显示本身。

$$
\left. \frac{ {\rm d}u}{ {\rm d}x} \right| _{x=0}
$$


## 偏导

$$
\frac{\partial^{2}y}{\partial x^{2}}
$$



## 运算符

## 关系运算符

$\pm$  $\times$  $\div$  

$\mid$  $\nmid$  $\cdot$  

$\circ$  $\ast$  $\bigodot$  

$\bigotimes$  $\bigoplus$  $\leq$  

$\geq$  $\neq$  $\approx$  

$\equiv$  $\sum$  $\prod$  

$\coprod$  

## 集合运算符

$\emptyset$  $\in$  

$\notin$  $\subset$    

$\supset$  $\subseteq$   

$\supseteq$  $\bigcap$  

$\bigcup$  $\bigvee$  

$\bigvee$  $\bigwedge$  

$\biguplus$  $\bigsqcup$  


## 对数运算符

$\log$  

$\lg$  

$\ln$  


## 戴帽符号

$\hat{y}$  

$\check{y}$  

$\breve{y}$  


## 三角运算符

$\bot$  

$\angle$  

$30^\circ$  

$\sin$   

$\cos$  

$\tan$  

$\cot$  

$\sec$  

$\csc$  


## 微积分运算符

$\prime$  

$\int$  

$\iint$  

$\iiint$  

$\iiiint$  

$\oint$  

$\lim$  

$\infty$  

$\nabla$


## 逻辑运算符

$\because$  

$\therefore$  

$\forall$  

$\exists$  

$\not=$   

$\not>$  

$\not\subset$  


## 箭头符号

$\uparrow$  $\downarrow$  

$\Uparrow$  $\Downarrow$  

$\rightarrow$  $\leftarrow$  

$\Rightarrow$  $\Leftarrow$  

$\longrightarrow$  $\longleftarrow$  

$\Longrightarrow$  $\Longleftarrow$  

# 启动

## windows

- 1.f:  
- 2.cd F:\LV-HH  
- 3.jupyter notebook


```python
jupyter notebook --generate-config
jupyter_notebook_config.py

# The directory to use for notebooks and kernels.
c.NotebookApp.notebook_dir = 'G:\\taishan_plan'
```

## Linux

- 1.cd /home/lhh/workspace/yihealth_commodity_recommendation/
- 2.jupyter-notebook --allow-root --ip=172.16.92.106

# 更换主题

- pip install --upgrade jupyterthemes  
- pip install jupyterthemes


```python
# 查看已有主题
!jt -l
```

    Available Themes: 
       chesterish
       grade3
       gruvboxd
       gruvboxl
       monokai
       oceans16
       onedork
       solarizedd
       solarizedl



```python
# 恢复原始主题
!jt -r
```


```python
!jt -t monokai -f fira -fs 16 -T -cellw 80% 
```

# 安装工具包

- pip install jupyter_contrib_nbextensions  
- jupyter contrib nbextension install --user --skip-running-check

# 显示网页


```python
from IPython.display import IFrame
IFrame('https://www.baidu.com' , width=800, height=800)
```

# 表格



# win10 自启动

1. 首先进入python命令行： python
2. 在命令行下输入：

	```python
	from notebook.auth import passwd
	
	passwd() 
	```
3. 按照提示输入密码，这是jupyter的登陆密码

	```
	'sha1:b4ef26f393b3:c786e47bfdff260baf3a8cbeb6d1f8b60208f82f'
	```
4. 生成配置文件 jupyter_notebook_config.py

	```
	jupyter notebook --generate-config
	
	# C:\Users\Administrator\.jupyter
	```
5. 修改参数

	```
	c.NotebookApp.notebook_dir = 'F:\Gitee'
	c.NotebookApp.open_browser = False
	c.NotebookApp.password = 'sha1:b4ef26f393b3:c786e47bfdff260baf3a8cbeb6d1f8b60208f82f'
	```
6. 新建文件：jupyter.bat，复制到目标位置

	```
	start /b jupyter-notebook >nul 2>nul
	```
7. 新建文件：jupyter.vbs，复制到windows启动文件夹

	- C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp

	```
	Set ws = CreateObject("Wscript.Shell")
	ws.run "cmd /c C:\Users\Administrator\jupyter.bat",vbhide
	```

	