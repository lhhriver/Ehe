# 示例
$$
F(x) = \frac{x_i}{3} + x_i^n + \sqrt{2^4} + \sqrt[n]{2} + \int_0^1{x^2}{\rm d}x
$$



# 基础公式

## 行中公式

$ J_\alpha(x) = \sum_{m=0}^\infty \frac{(-1)^m}{m! \Gamma (m + \alpha + 1)} {\left({ \frac{x}{2} }\right)}^{2m + \alpha} \text {，行内公式示例} $

## 独立公式

$$
J_\alpha(x) = \sum_{m=0}^\infty \frac{(-1)^m}{m! \Gamma (m + \alpha + 1)} {\left({ \frac{x}{2} }\right)}^{2m + \alpha} \text {，独立公式示例}
$$

## 多行公式

$$
\begin{aligned} 
L(w, b, \alpha)&= \frac{1}{2}\|w\|^{2}-\sum_{i=1}^{l} \alpha_{i}\left(y_{i}\left(w^{T} \cdot x_{i}+b\right)-1\right) \\ 
&=\frac{1}{2} w^{T} w-\sum_{i=1}^{l} \alpha_{i} y_{i} w^{T} \cdot x_{i}-\sum_{i=1}^{l} \alpha_{i} y_{i} b+\sum_{i=1}^{l} \alpha_{i} \\ 
&=\frac{1}{2} w^{T} \sum_{i=1}^{l} \alpha_{i} y_{i} x_{i}-w^{T} \sum_{i=1}^{l} \alpha_{i} y_{i} \cdot x_{i}+\sum_{i=1}^{l} \alpha_{i} \\ 
&=-\frac{1}{2} w^{T} \sum_{i=1}^{l} \alpha_{i} y_{i} x_{i}+\sum_{i=1}^{l} \alpha_{i} \\
&=-\frac{1}{2}\left(\sum_{i=1}^{l} \alpha_{i} y_{i} x_{i}\right)^{T} \sum_{i=1}^{l} \alpha_{i} y_{i} x_{i}+\sum_{i=1}^{l} \alpha_{i} \\ 
&=-\frac{1}{2} \sum_{i=1}^{l} \alpha_{i} y_{i}\left(x_{i}\right)^{T} \sum_{i=1}^{l} \alpha_{i} y_{i} x_{i}+\sum_{i=1}^{l} \alpha_{i} \\
&=-\frac{1}{2} \sum_{i=1}^{l} \sum_{j=1}^{l} \alpha_{i} y_{i}\left(x_{i}\right)^{T} \alpha_{j} y_{j} x_{j}+\sum_{i=1}^{l} \alpha_{i} \\ 
&=-\frac{1}{2} \sum_{i=1}^{l} \sum_{j=1}^{l} \alpha_{i} \alpha_{j} y_{i} y_{j}\left(x_{i} \cdot x_{j}\right)+\sum_{i=1}^{l} \alpha_{i}
\end{aligned}
$$



## 如何输入上下标

​		^表示上标, _ 表示下标。
$$
x^{y^z}=(1+{\rm e}^x)^{-2xy^w}
$$


$$
\sideset{^1_2}{^3_4}\bigotimes
$$



| LaTex命令 | 显示结果 | LaTex命令 | 显示结果 |   LaTex命令    |     显示结果      |
| :-------: | :------: | :-------: | :------: | :------------: | :---------------: |
|   a_{1}   | $a_{1}$  |   x^{2}   | $x^{2}$  | \sum_{i=1}^{N} | $\sum_{i=1}^{N} $ |

## 如何输入分数

​		通常使用 \frac {分子} {分母}命令产生一个分数\frac {分子} {分母}，分数可嵌套。

​		便捷情况可直接输入 \frac ab来快速生成一个\frac ab。

​		如果分式很复杂，亦可使用 分子 \over 分母 命令，此时分数仅有一层。
$$
\frac{a-1}{b-1} \quad and \quad {a+1\over b+1}
$$


$$
P(A \mid B) = \frac{P(B \mid A)P(A)} {P(B)}
$$

## 如何输入开方

​		平方根的输入命令为 \sqrt ， n次方根的命令为 \sqrt[n]

| LaTex命令 |  显示结果  |  LaTex命令  |   显示结果    |   LaTex命令    |        显示结果         |
| :-------: | :--------: | :---------: | :-----------: | :------------: | :---------------------: |
| \sqrt{x}  | $\sqrt{x}$ | \sqrt[n]{4} | $\sqrt[n]{4}$ | \sqrt{x^2+y^2} | $ \sqrt{x^2+\sqrt{y}} $ |



## 上下大括号

命令 \overbrace 和 \underbrace 在表达式上、下方画出一个水平的大括号。比如：

```
$$
\underbrace{1+2+3+\cdots+100}_{100}
\tag{2-2}
$$
```

$$
\underbrace{1+2+3+\cdots+100}_{100}
\tag{2-2}
$$

## 如何输入省略号

常见的省略号有两种，\ldots 表示与文本底线对齐的省略号，\cdots 表示与文本中线对齐的省略号。

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

## 上下水平线

命令 \overline 和 \underline 在表达式的上、下方画出水平线。比如：

|   LaTex命令    |      显示结果      |    LaTex命令    |      显示结果       |
| :------------: | :----------------: | :-------------: | :-----------------: |
| \overline{x+y} | $ \overline{x+y} $ | \underline{x+y} | $ \underline{x+y} $ |



## 如何输入积分

使用 \int_积分下限^积分上限 {被积表达式} 来输入一个积分。

$$
\int_0^1 {x^2} {\rm d}x
$$

## 如何输入极限运算

使用\lim_{变量 \to 表达式} 表达式 来输入一个极限。如有需求，可以更改 \to 符号至任意符号。

$$
\lim_{n \to +\infty} \frac{1}{n(n+1)} \quad and \quad \lim_{0\leftarrow{n}} \frac{1}{n(n+1)}
$$
## 如何输入累加、累乘运算

使用 \sum_{下标表达式}^{上标表达式} {累加表达式}来输入一个累加。
与之类似，使用 \prod \bigcup \bigcap来分别输入累乘、并集和交集。
$$
\sum_{i=1}^n \frac{1}{i^2} \quad and \quad \prod_{i=1}^n \frac{1}{i^2} \quad and \quad \bigcup_{i=1}^{2} R
$$


## 如何输入希腊字母



|    显示    | 输入     |   显示    | 输入    |    显示    | 输入     |    显示    | 输入     |
| :--------: | -------- | :-------: | ------- | :--------: | -------- | :--------: | -------- |
|  $\alpha$  | \alpha   |    $A$    | A       |   $\mu$    | \mu      |    $M$     | M        |
|  $\beta$   | \beta    |    $B$    | B       |   $\xi$    | \xi      |   $\Xi$    | \Xi      |
|  $\gamma$  | \gamma   | $\Gamma$  | \Gamma  |    $o$     | o        |    $O$     | O        |
|  $\delta$  | \delta   | $\Delta$  | \Delta  |   $\pi$    | \pi      |   $\Pi$    | \Pi      |
| $\epsilon$ | \epsilon |    $E$    | E       |   $\rho$   | \rho     |    $P$     | P        |
|  $\zeta$   | \zeta    |    $Z$    | Z       |  $\sigma$  | \sigma   |  $\Sigma$  | \Sigma   |
|   $\eta$   | \eta     |    $H$    | H       |   $\tau$   | \tau     |    $T$     | T        |
|  $\theta$  | \theta   | $\Theta$  | \Theta  | $\upsilon$ | \upsilon | $\Upsilon$ | \Upsilon |
|  $\iota$   | \iota    |    $I$    | I       |   $\phi$   | \phi     |   $\Phi$   | \Phi     |
|  $\kappa$  | \kappa   |    $K$    | K       |   $\chi$   | \chi     |    $X$     | X        |
| $\lambda$  | \lambda  | $\Lambda$ | \Lambda |   $\psi$   | \psi     |   $\Psi$   | \Psi     |
|   $\nu$    | \nu      |    $N$    | N       |  $\omega$  | \omega   |  $\Omega$  | \Omega   |



## 大括号和行标的使用

​		使用 \left和 \right来创建自动匹配高度的 (圆括号)，[方括号] 和 {花括号} 。
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
\tag{1}
$$

## 如何输入括号和分隔符

​	() 、 [] 和 | 表示自己， {} 表示 {} 。当要显示大号的括号或分隔符时，要用 \left 和 \right 命令。
$$
f(x,y,z) = 3y^2z \left( 3+\frac{7x+5}{1+y^2} \right)
$$
​	有时候要用\left.或\right.进行匹配而不显示本身。
$$
\left. \frac{{\rm d}u} {{\rm d}x} \right| _{x=0}
$$

## 偏导

$$
\frac {\partial^{2}y} {\partial x^{2}}
$$



## 其他

其他，比如 分数可以用 \frac 命令， 求和可以用 \sum 命令， 乘积运算可以用 \prod 生成， 积分可以用 \int 命令。部分示例如下：



| LaTex命令       | 显示结果          | LaTex命令         | 显示结果            | LaTex命令         | 显示结果             |
| --------------- | ----------------- | ----------------- | ------------------- | ----------------- | -------------------- |
| \sum            | $\sum$            | \int              | $\int$              | \sum_{i=1}^{N}    | $\sum_{i=1}^{N} $    |
| \int_{a}^{b}    | $\int_{a}^{b}$    | \prod             | $\prod$             | \iint             | $\iint $             |
| \prod_{i=1}^{N} | $\prod_{i=1}^{N}$ | \iint_{a}^{b}     | $\iint_{a}^{b}$     | \bigcup           | $\bigcup $           |
| \bigcap         | $\bigcap$         | \bigcup_{i=1}^{N} | $\bigcup_{i=1}^{N}$ | \bigcap_{i=1}^{N} | $\bigcap_{i=1}^{N} $ |
| \sqrt[3]{2}     | $\sqrt[3]{2}$     | \sqrt{3}          | $\sqrt{3}$          | x_{3}             | $ x_{3} $            |
| \lim_{x \to 0}  | $\lim_{x \to 0}$  | \frac{1}{2}       | $\frac{1}{2}$       |                   |                      |



# 运算符

## 关系运算符



|     显示     | 输入       |    显示     | 输入      |    显示    | 输入     |
| :----------: | ---------- | :---------: | --------- | :--------: | -------- |
|    $\pm$     | \pm        |  $\times$   | \times    |   $\div$   | \div     |
|    $\mid$    | \mid       |   $\nmid$   | \nmid     |  $\cdot$   | \cdot    |
|   $\circ$    | \circ      |   $\ast$    | \ast      | $\bigodot$ | \bigodot |
| $\bigotimes$ | \bigotimes | $\bigoplus$ | \bigoplus |   $\leq$   | \leq     |
|    $\geq$    | \geq       |   $\neq$    | \neq      | $\approx$  | \approx  |
|   $\equiv$   | \equiv     |   $\sum$    | \sum      |  $\prod$   | \prod    |
|  $\coprod$   | \coprod    |             |           |            |          |



## 集合运算符



|    显示     | 输入      |    显示     | 输入      |
| :---------: | :-------- | :---------: | :-------- |
| $\emptyset$ | \emptyset |    $\in$    | \in       |
|  $\notin$   | \notin    |  $\subset$  | \subset   |
|  $\supset$  | \supset   | $\subseteq$ | \subseteq |
| $\supseteq$ | \supseteq |  $\bigcap$  | \bigcap   |
|  $\bigcup$  | \bigcup   |  $\bigvee$  | \bigvee   |
|  $\bigvee$  | \bigvee   | $\bigwedge$ | \bigwedge |
| $\biguplus$ | \biguplus | $\bigsqcup$ | \bigsqcup |



## 对数运算符



|  显示  | 输入 |
| :----: | :--- |
| $\log$ | \log |
| $\lg$  | \lg  |
| $\ln$  | \ln  |

 

## 戴帽符号



|    显示     | 输入      |
| :---------: | --------- |
|  $\hat{y}$  | \hat{y}   |
| $\check{y}$ | \check{y} |
| $\breve{y}$ | \breve{y} |



## 三角运算符



|    显示    | 输入     |  显示  | 输入 |
| :--------: | :------- | :----: | :--- |
|   $\bot$   | \bot     | $\tan$ | \tan |
|  $\angle$  | \angle   | $\cot$ | \cot |
| $30^\circ$ | 30^\circ | $\sec$ | \sec |
|   $\sin$   | \sin     | $\csc$ | \csc |
|   $\cos$   | \cos     |        |      |



## 微积分运算符



|   显示    | 输入    |   显示   | 输入   |
| :-------: | :------ | :------: | :----- |
| $\prime$  | \prime  | $\oint$  | \oint  |
|  $\int$   | \int    |  $\lim$  | \lim   |
|  $\iint$  | \iint   | $\infty$ | \infty |
| $\iiint$  | \iiint  | $\nabla$ | \nabla |
| $\iiiint$ | \iiiint |          |        |



## 逻辑运算符



|     显示     | 输入       |     显示      | 输入        |
| :----------: | :--------- | :-----------: | :---------- |
|  $\because$  | \because   |    $\not=$    | \not=       |
| $\therefore$ | \therefore |    $\not>$    | \not>       |
|  $\forall$   | \forall    | $\not\subset$ | \not\subset |
|  $\exists$   | \exists    |               |             |



## 箭头符号



|       显示        | 输入            |       显示       | 输入           |
| :---------------: | :-------------- | :--------------: | :------------- |
|    $\uparrow$     | \uparrow        |   $\downarrow$   | \downarrow     |
|    $\Uparrow$     | \Uparrow        |   $\Downarrow$   | \Downarrow     |
|   $\rightarrow$   | \rightarrow     |   $\leftarrow$   | \leftarrow     |
|   $\Rightarrow$   | \Rightarrow     |   $\Leftarrow$   | \Leftarrow     |
| $\longrightarrow$ | \longrightarrow | $\longleftarrow$ | \longleftarrow |
| $\Longrightarrow$ | \Longrightarrow | $\Longleftarrow$ | \Longleftarrow |

# 矩阵编辑

​		矩阵命令中每一行以 \ 结束，矩阵的元素之间用 & 来分隔开。举例如下：

```
$$
\begin{matrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{matrix} \tag{3-1}
$$
```

$$
\begin{matrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{matrix} \tag{3-1}
$$

上述矩阵显示的不是很美观，可以给矩阵加上括号，加括号的方式有多种。

## 带括号的矩阵 \left \right

```
$$
\left \{
\begin{matrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{matrix} 
\right \} \tag{3-2}
$$
```

$$
\left \{
\begin{matrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{matrix} 
\right \} \tag{3-2}
$$

或者：

```
$$
\left [
\begin{matrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{matrix} 
\right ] \tag{3-3}
$$
```

$$
\left [
\begin{matrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{matrix} 
\right ] \tag{3-3}
$$

## 带括号的矩阵 \bmatrix \Bmatrix

```
$$
\begin{bmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{bmatrix} 
 \tag{3-4}
$$
```

$$
\begin{bmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{bmatrix} 
 \tag{3-4}
$$

或者：

```
$$
\begin{Bmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{Bmatrix} 
 \tag{3-5}
$$
```

$$
\begin{Bmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{Bmatrix} 
 \tag{3-5}
$$

## 带括号的矩阵 \vmatrix \Vmatrix

```
$$
\begin{vmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{vmatrix} 
 \tag{3-6}
$$
```

$$
\begin{vmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{vmatrix} 
 \tag{3-6}
$$

或者：

```
$$
\begin{Vmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{Vmatrix} 
 \tag{3-7}
$$
```

$$
\begin{Vmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{Vmatrix} 
 \tag{3-7}
$$

## 带省略号的矩阵

如果矩阵元素太多，可以用 \cdots $\cdots$  \ddots $\ddots$ \vdots $\vdots$ 等省略符号来定义矩阵。

```
$$
\begin{bmatrix}
1 & 2 & \cdots & 4 \\
7 & 6 & \cdots & 5 \\
\vdots & \vdots & \ddots & \vdots \\
8 & 9 & \cdots & 10
\end{bmatrix} \tag{3-8}
$$
```

$$
\begin{bmatrix}
1 & 2 & \cdots & 4 \\
7 & 6 & \cdots & 5 \\
\vdots & \vdots & \ddots & \vdots \\
8 & 9 & \cdots & 10
\end{bmatrix} \tag{3-8}
$$

## 带参数的矩阵

写增广矩阵，可能需要最右边一列单独考虑。可以用array命令来处理：

```
$$
\left [
\begin{array}{cc|c}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{array}
\right ]
 \tag{3-9}
$$
```

$$
\left [
\begin{array}{cc|c}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{array}
\right ]
 \tag{3-9}
$$

## 行内矩阵

可以使用 \big( 和 \big) 来定义行间矩阵。Demo如下：


```
这是行内矩阵的Demo：
$\big( 
    \begin{smallmatrix}
    1 & 2 & 3 \\
    4 & 5 & 6 \\
    7 & 8 & 9
    \end{smallmatrix}
 \big)$  后面还有……
```

这是行内矩阵的Demo：
$\big( 
    \begin{smallmatrix}
    1 & 2 & 3 \\
    4 & 5 & 6 \\
    7 & 8 & 9
    \end{smallmatrix}
 \big)$  后面还有……

或者：

```
这是行内矩阵的Demo：
$ 
    \begin{bmatrix}
    1 & 2 & 3 \\
    4 & 5 & 6 \\
    7 & 8 & 9
    \end{bmatrix} 
$  后面还有……
```

这是行内矩阵的Demo：
$ 
    \begin{bmatrix}
    1 & 2 & 3 \\
    4 & 5 & 6 \\
    7 & 8 & 9
    \end{bmatrix} 
$  后面还有……

***

# LaTex 常用数学符号

## 数学模式重音符号



| 符号          | LaTex命令 | 符号          | LaTex命令 | 符号            | LaTex命令     |
| ------------- | --------- | ------------- | --------- | --------------- | ------------- |
| $ \hat{a} $   | \hat{a}   | $ \check{a} $ | \check{a} | $ \tilde{a} $   | \tilde{a}     |
| $ \grave{a} $ | \grave{a} | $\dot{a}$     | \dot{a}   | $\ddot{a}$      | \ddot{a}      |
| $ \bar{a} $   | \bar{a}   | $\vec{a}$     | \vec{a}   | $\widehat{A}$   | \widehat{A}   |
| $ \acute{a} $ | \acute{a} | $\breve{a}$   | \breve{a} | $\widetilde{A}$ | \widetilde{A} |



## 希腊字母

| 符号            | LaTex命令   | 符号          | LaTex命令 | 符号          | LaTex命令 | 符号            | LaTex命令   |
| --------------- | ----------- | ------------- | --------- | ------------- | --------- | --------------- | ----------- |
| $ \alpha $      | \alpha      | $ \theta $    | \theta    | $ o $         | o         | $ \upsilon $    | \upsilon    |
| $ \beta $       | \beta       | $ \vartheta $ | \vartheta | $ \pi $       | \pi       | $ \phi $        | \phi        |
| $ \gamma $      | \gamma      | $ \iota $     | \iota     | $ \varpi $    | \varpi    | $ \varphi $     | \varphi     |
| $ \delta $      | \delta      | $ \kappa $    | \kappa    | $ \rho $      | \rho      | $ \chi $        | \chi        |
| $ \epsilon $    | \epsilon    | $ \lambda $   | \lambda   | $ \varrho $   | \varrho   | $ \psi $        | \psi        |
| $ \varepsilon $ | \varepsilon | $ \mu $       | \mu       | $ \sigma $    | \sigma    | $ \omega $      | \omega      |
| $ \zeta $       | \zeta       | $ \nu $       | \nu       | $ \varsigma $ | \varsigma | $ \mathcal{O} $ | \mathcal{O} |
| $ \eta $        | \eta        | $ \xi $       | \xi       | $ \tau $      | \tau      |                 |             |
| $ \Gamma $      | \Gamma      | $ \Lambda $   | \Lambda   | $ \Sigma $    | \sigma    | $ \Psi $        | \Psi        |
| $ \Delta $      | \Delta      | $ \Xi $       | \Xi       | $ \Upsilon $  | \Upsilon  | $ \Omega $      | \Omega      |
| $ \Theta $      | \Theta      | $ \Pi $       | \Pi       | $ \Phi $      | \Phi      |                 |             |

**Tips: **

1. 如果使用大写的希腊字母，把命令的首字母变成大写即可，例如 \Gamma 输出的是  $\Gamma$ 。
2. 如果使用斜体大写希腊字母，再在大写希腊字母的LaTeX命令前加上var，例如 \varGamma 生成 $\varGamma$。

## 二元关系



|      符号       | LaTex命令   |      符号      | LaTex命令    |   符号    | LaTex命令   |
| :-------------: | ----------- | :------------: | ------------ | :-------: | ----------- |
|      $ < $      | <           |     $ > $      | >            |   $ = $   | =           |
|     $ \le $     | \leq 或 \le |     $\ge $     | \geq 或 \ge  | $\equiv$  | \equiv      |
|     $ \ll $     | \ll         |     $\gg $     | \gg          | $\doteq$  | \doteq      |
|    $ \prec $    | \prec       |    $\succ $    | \succ        |  $\sim$   | \sim        |
|   $ \preceq $   | \preceq     |   $\succeq $   | \succeq      | $\simeq$  | \simeq      |
|   $ \subset $   | \subset     |   $\supset $   | \supset      | $\approx$ | \approx     |
|  $ \subseteq $  | \subseteq   |  $\supseteq $  | \supseteq    |  $\cong$  | \cong       |
|  $ \sqsubset $  | \sqsubset   |  $\sqsupset $  | \sqsupset    |  $\Join$  | \Join       |
| $ \sqsubseteq $ | \sqsubseteq | $\sqsupseteq $ | \sqsupseteq  | $\bowtie$ | \bowtie     |
|     $ \in $     | \in         |     $\ni $     | \ni 或 \owns | $\propto$ | \propto     |
|   $ \vdash $    | \vdash      |   $\dashv $    | \dashv       | $\models$ | \models     |
|    $ \mid $     | \mid        |  $\parallel $  | \parallel    |  $\perp$  | \perp       |
|   $ \smile $    | \smile      |   $\frown $    | \frown       | $\asymp$  | \asymp      |
|      $ : $      | :           |   $\notin $    | \notin       |  $\neq$   | \neq  或 \n |

**Tips: **

1. 可以在上述符号的相应命令前加上 \not 命令，得到其否定形式。如： \not\subset 生成 $ \not\subset$



## 二元运算符

|        符号        | LaTex命令      |        符号         | LaTex命令        |       符号       | LaTex命令      |
| :----------------: | -------------- | :-----------------: | ---------------- | :--------------: | -------------- |
|       $ + $        | +              |        $ - $        | -                |                  |                |
|      $ \pm $       | \pm            |       $\mp $        | \mp              | $\triangleleft$  | \triangleleft  |
|     $ \cdot $      | \cdot          |       $\div $       | \div             | $\triangleright$ | \triangleright |
|     $ \times $     | \times         |    $\setminus $     | \setminus        |     $\star$      | \star          |
|      $ \cup $      | \cup           |       $\cap $       | \cap             |      $\ast$      | \ast           |
|     $ \sqcup $     | \sqcup         |      $\sqcap $      | \sqcap           |     $\circ$      | \circ          |
|      $ \vee $      | \vee 或 \lor   |      $\wedge $      | \wedge 或 \land  |    $\bullet$     | \bullet        |
|     $ \oplus $     | \oplus         |     $\ominus $      | \ominus          |    $\diamond$    | \diamond       |
|     $ \odot $      | \odot          |     $\oslash $      | \oslash          |     $\uplus$     | \uplus         |
|    $ \otimes $     | \otimes        |     $\bigcirc $     | \bigcirc         |     $\amalg$     | \amalg         |
| $ \bigtriangleup $ | \bigtriangleup | $\bigtriangledown $ | \bigtriangledown |    $\dagger$     | \dagger        |
|      $ \lhd $      | \ldh           |       $\rhd $       | \rhd             |    $\ddagger$    | \ddagger       |
|     $ \unlhd $     | \unldh         |      $\unrhd $      | \unrhd           |      $\wr$       | \wr            |

## 大运算符

|     符号      | LaTex命令 |     符号      | LaTex命令  |    符号     | LaTex命令 |
| :-----------: | --------- | :-----------: | ---------- | :---------: | --------- |
|   $ \sum $    | \sum      |  $\bigcup $   | \bigcup    |  $\bigvee$  | \bigvee   |
|   $ \prod $   | \prod     |  $\bigcap $   | \bigcap    | $\bigwedge$ | \bigwedge |
|  $ \coprod $  | \coprod   | $\bigsqcup $  | \bigsqcup  | $\biguplus$ | \biguplus |
|   $ \int $    | \int      |   $\oint $    | \oint      | $\bigodot$  | \bigodot  |
| $ \bigoplus $ | \bigoplus | $\bigotimes $ | \bigotimes |             |           |

## 箭头

|          符号          | LaTex命令           |          符号          | LaTex命令           |
| :--------------------: | ------------------- | :--------------------: | ------------------- |
|     $ \leftarrow $     | \leftarrow 或 \gets |   $\longleftarrow $    | \longleftarrow      |
|    $ \rightarrow $     | \rightarrow 或 \to  |   $\longrightarrow $   | \longrightarrow     |
|  $ \leftrightarrow $   | \leftrightarrow     | $\longleftrightarrow $ | \longleftrightarrow |
|     $ \Leftarrow $     | \Leftarrow          |   $\Longleftarrow $    | \Longleftarrow      |
|    $ \Rightarrow $     | \Rightarrow         |   $\Longrightarrow $   | \Longrightarrow     |
|  $ \Leftrightarrow $   | \Leftrightarrow     | $\Longleftrightarrow $ | \Longleftrightarrow |
|      $ \mapsto $       | \mapsto             |     $\longmapsto $     | \longmapsto         |
|   $ \hookleftarrow $   | \hookleftarrow      |   $\hookrightarrow $   | \hookrightarrow     |
|   $ \leftharpoonup $   | \leftharpoonup      |   $\rightharpoonup $   | \rightharpoonup     |
|  $ \leftharpoondown $  | \leftharpoondown    |  $\rightharpoondown $  | \rightharpoondown   |
| $ \rightleftharpoons $ | \rightleftharpoons  |        $\iff $         | \iff                |
|      $ \uparrow $      | \uparrow            |     $\downarrow $      | \downarrow          |
|    $ \updownarrow $    | \updownarrow        |      $\Uparrow $       | \Uparrow            |
|     $ \Downarrow $     | \Downarrow          |    $\Updownarrow $     | \Updownarrow        |
|      $ \nearrow $      | \nearrow            |      $\searrow $       | \searrow            |
|      $ \swarrow $      | \swarrow            |      $\nwarrow $       | \nwarrow            |
|      $ \leadsto $      | \leadsto            |                        |                     |

## 定界符

|     符号     | LaTex命令     |      符号      | LaTex命令     |       符号       | LaTex命令    |
| :----------: | ------------- | :------------: | ------------- | :--------------: | ------------ |
|    $ ( $     | (             |     $ ) $      | )             |    $\uparrow$    | \uparrow     |
|    $ [ $     | [ 或 \lbrack  |     $ ] $      | ] 或 \rbrack  |   $\downarrow$   | \downarrow   |
|    $ \{ $    | \{ 或 \lbrace |     $ \} $     | \} 或 \rbrace |  $\updownarrow$  | \updownarrow |
| $ \langle $  | \langle       |  $ \rangle $   | \rangle       |    $ \vert $     | \vert        |
| $ \lfloor $  | \lfloor       |  $ \rfloor $   | \rfloor       |    $ \lceil $    | \lceil       |
|    $ / $     | /             | $ \backslash $ | \backslash    | $ \Updownarrow $ | \Updownarrow |
| $ \Uparrow $ | \Uparrow      | $ \Downarrow $ | \Downarrow    |    $ \Vert $     | \Vert        |
|  $ \rceil $  | \rceil        |                |               |                  |              |

## 大定界符

|      符号       | LaTex命令   |      符号      | LaTex命令  |     符号      | LaTex命令   |
| :-------------: | ----------- | :------------: | :--------- | :-----------: | ----------- |
|   $ \lgroup $   | \lgroup     |  $ \rgroup $   | \rgroup    | $\lmoustache$ | \lmoustache |
| $ \arrowvert $  | \arrowvert  | $ \Arrowvert $ | \Arrowvert | $\bracevert$  | \bracevert  |
| $ \rmoustache $ | \rmoustache |                |            |               |             |

## 其他字符

|       符号       | LaTex命令     |      符号      | LaTex命令  |     符号      | LaTex命令 |      符号      | LaTex命令  |
| :--------------: | ------------- | :------------: | ---------- | :-----------: | --------- | :------------: | ---------- |
|    $ \dots $     | \dots         |   $ \cdots $   | \cdots     |  $ \vdots $   | \vdots    |   $ \ddots $   | \ddtos     |
|    $ \hbar $     | \hbar         |   $ \imath $   | \imath     |  $ \jmath $   | \jmath    |    $ \ell $    | \ell       |
|     $ \Re $      | \Re           |    $ \Im $     | \Im        |  $ \aleph $   | \aleph    |    $ \wp $     | \wp        |
|   $ \forall $    | \forall       |  $ \exists $   | \exists    |   $ \mho $    | \mho      |  $ \partial $  | \partial   |
|      $ ' $       | '             |   $ \prime $   | \prime     | $ \emptyset $ | \emptyset |   $ \infty $   | \infty     |
|    $ \nabla $    | \nabla        | $ \triangle $  | \triangle  |   $ \Box $    | \Box      |  $ \Diamond $  | \Diamond   |
|     $ \bot $     | \bot          |    $ \top $    | \top       |  $ \angle $   | \angle    |   $ \surd $    | \surd      |
| $ \diamondsuit $ | \diamondsuit  | $ \heartsuit $ | \heartsuit | $ \clubsuit $ | \clubsuit | $ \spadesuit $ | \spadesuit |
|     $ \neg $     | \neg 或 \lnot |   $ \flat $    | \flat      | $ \natural $  | \natural  |   $ \sharp $   | \sharp     |

## 非数学符号



|     符号     | LaTex命令 |  符号  | LaTex命令 |     符号     | LaTex命令  |        符号         | LaTex命令       |
| :----------: | --------- | :----: | --------- | :----------: | ---------- | :-----------------: | --------------- |
| $ \dagger $  | \dagger   | $ \S $ | \S        | $\copyright$ | \copyright | $ \textregistered $ | \textregistered |
| $ \ddagger $ | \ddagger  | $ \P $ | \P        | $ \pounds $  | \pounds    |       $ \% $        | \%              |

## AMS 定界符



|     符号      | LaTex命令 |     符号      | LaTex命令 |    符号     | LaTex命令 |     符号      | LaTex命令 |
| :-----------: | --------- | :-----------: | --------- | :---------: | --------- | :-----------: | --------- |
| $ \ulcorner $ | \ulcorner | $ \urcorner $ | \urcorner | $\llcorner$ | \llcorner | $ \lrcorner $ | \llcorner |
|  $ \lvert $   | \lvert    |  $ \rvert $   | \rvert    | $ \lVert $  | \lVert    |  $ \rVert $   | \rVert    |

## AMS 希腊和希伯来字母

|     符号     | LaTex命令 |     符号      | LaTex命令 |  符号   | LaTex命令 |
| :----------: | --------- | :-----------: | --------- | :-----: | --------- |
| $ \digamma $ | \digamma  | $ \varkappa $ | \varkappa | $\beth$ | \beth     |
|  $ \gimel $  | \gimel    |  $ \daleth $  | \daleth   |         |           |

## AMS 二元关系

|          符号           | LaTex命令           |       符号       | LaTex命令    |       符号       | LaTex命令      |
| :---------------------: | ------------------- | :--------------: | ------------ | :--------------: | -------------- |
|      $ \lessdot $       | \lessdot            |   $ \gtrdot $    | \gtrdot      |   $\doteqdot$    | \doteqdot      |
|      $ \leqslant $      | \leqslant           |  $ \geqslant $   | \geqslant    | $\risingdotseq$  | \risingdotseq  |
|    $ \eqslantless $     | \eqslantless        | $ \eqslantgtr $  | \eqslantgtr  | $\fallingdotseq$ | \fallingdotseq |
|        $ \leqq $        | \leqq               |    $ \geqq $     | \geqq        |    $\eqcirc$     | \eqcirc        |
|        $ \lll $         | \lll 或 \llless     |     $ \ggg $     | \ggg         |    $\circeq$     | \circeq        |
|      $ \lesssim $       | \lesssim            |   $ \gtrsim $    | \gtrsim      |   $\triangleq$   | \triangleq     |
|     $ \lessapprox $     | \lessapprox         |  $ \gtrapprox $  | \gtrapprox   |    $\bumpeq$     | \bumpeq        |
|      $ \lessgtr $       | \lessgtr            |   $ \gtrless $   | \gtrless     |    $\Bumpeq$     | \Bumpeq        |
|     $ \lesseqgtr $      | \lesseqgtr          |  $ \gtreqless $  | \gtreqless   |   $\thicksim$    | \thicksim      |
|     $ \lesseqqgtr $     | \lesseqqgtr         | $ \gtreqqless $  | \gtreqqless  |  $\thickapprox$  | \thickapprox   |
|    $ \preccurlyeq $     | \preccurlyeq        | $ \succcurlyeq $ | \succcurlyeq |   $\approxeq$    | \approxeq      |
|    $ \curlyeqprec $     | \curlyeqprec        | $ \curlyeqsucc $ | \curlyeqsucc |    $\backsim$    | \backsim       |
|      $ \precsim $       | \precsim            |   $ \succsim $   | \succsim     |   $\backsimeq$   | \backsimeq     |
|     $ \precapprox $     | \precapprox         | $ \succapprox $  | \succapprox  |     $\vDash$     | \vDash         |
|     $ \subseteqq $      | \subseteqq          |  $ \supseteqq $  | \supseteqq   |     $\Vdash$     | \Vdash         |
|   $ \shortparallel $    | \shortparallel      |   $ \Supset $    | \Supset      |    $\Vvdash$     | \Vvdash        |
| $ \blacktriangleleft $  | \blacktriangleleft  |  $ \sqsupset $   | \sqsupset    |  $\backepsilon$  | \backepsilon   |
|  $ \vartriangleright $  | \vartriangleright   |   $ \because $   | \because     |   $\varpropto$   | \varpropto     |
| $ \blacktriangleright $ | \blacktriangleright |   $ \Subset $    | \Subset      |    $\between$    | \between       |
|  $ \trianglerighteq $   | \trianglerighteq    | $ \smallfrown $  | \smallfrown  |   $\pitchfork$   | \pitchfork     |
|  $ \vartriangleleft $   | \vartriangleleft    |  $ \shortmid $   | \shortmid    |  $\smallsmile$   | \smallsmile    |
|   $ \trianglelefteq $   | \trianglelefteq     |  $ \therefore $  | \therefore   |   $\sqsubset$    | \sqsubset      |

## AMS 箭头

|          符号          | LaTex命令          |           符号           | LaTex命令            |        符号        | LaTex命令        |
| :--------------------: | ------------------ | :----------------------: | -------------------- | :----------------: | ---------------- |
|   $ \dashleftarrow $   | \dashleftarrow     |   $ \leftleftarrows $    | \leftleftarrows      | $\leftrightarrows$ | \leftrightarrows |
|  $ \dashrightarrow $   | \dashrightarrow    |  $ \rightrightarrows $   | \rightrightarrows    | $\rightleftarrows$ | \rightleftarrows |
|    $ \Lleftarrow $     | \Lleftarrow        |  $ \twoheadleftarrow $   | \twoheadleftarrow    |  $\leftarrowtail$  | \leftarrowtail   |
|    $ \Rrightarrow $    | \Rrightarrow       |  $ \twoheadrightarrow $  | \twoheadrightarrow   | $\rightarrowtail$  | \rightarrowtail  |
| $ \leftrightharpoons $ | \leftrightharpoons |         $ \Lsh $         | \Lsh                 |  $\looparrowleft$  | \looparrowleft   |
| $ \rightleftharpoons $ | \rightleftharpoons |         $ \Rsh $         | \Rsh                 | $\looparrowright$  | \looparrowright  |
|  $ \curvearrowleft $   | \curvearrowleft    |   $ \circlearrowleft $   | \circlearrowleft     |   $\upuparrows$    | \upuparrows      |
|  $ \curvearrowright $  | \curvearrowright   |  $ \circlearrowright $   | \circlearrowright    | $\downdownarrows$  | \downdownarrows  |
|   $ \upharpoonleft $   | \upharpoonleft     |   $ \rightsquigarrow $   | \rightsquigarrow     |    $\multimap$     | \multimap        |
|  $ \upharpoonright $   | \upharpoonright    | $ \leftrightsquigarrow $ | \leftrightsquigarrow |                    |                  |

## AMS 二元否定关系符和箭头

|       符号        | LaTex命令      |       符号       | LaTex命令    |         符号         | LaTex命令        |        符号         | LaTex命令         |
| :---------------: | -------------- | :--------------: | ------------ | :------------------: | ---------------- | :-----------------: | ----------------- |
|    $ \nless $     | \nless         |    $ \lneq $     | \lneq        |      $ \nleq $       | \nleq            |  $\varsubsetneqq$   | \varsubsetneqq    |
|     $ \ngtr $     | \ngtr          |    $ \gneq $     | \gneq        |      $ \ngeq $       | \ngeq            |  $\varsubsetneqq$   | \varsubsetneqq    |
|  $ \nleqslant $   | \nleqslant     |    $ \lneqq $    | \lneqq       |      $ \nmid $       | \nmid            |    $\nsubseteqq$    | \nsubseteqq       |
|  $ \ngeqslant $   | \nngeqslantgtr |    $ \gneqq $    | \gneqq       |    $ \nparallel $    | \nparallel       |    $\nsupseteqq$    | \nsupseteqq       |
|  $ \lvertneqq $   | \lvertneqq     |    $ \nleqq $    | \nleqq       |      $ \lnsim $      | \lnsim           |    $\nshortmid$     | \nshortmid        |
|  $ \gvertneqq $   | \gvertneqq     |    $ \ngeqq $    | \ngeqq       |      $ \gnsim $      | \gnsim           |  $\nshortparallel$  | \nshortparallel   |
|   $ \lnapprox $   | \lnapprox      |    $ \nsim $     | \nsim        |    $ \lnapprox $     | \lnapprox        |      $\nprec$       | \nprec            |
|   $ \gnapprox $   | \gnapprox      |    $ \ncong $    | \ncong       |    $ \gnapprox $     | \gnapprox        |      $\nsucc$       | \nsucc            |
|   $ \npreceq $    | \npreceq       |   $ \nvdash $    | \nvdash      |     $ \nVdash $      | \nVdash          |     $\precneqq$     | \precneqq         |
|   $ \nsucceq $    | \nsucceq       |   $ \nvDash $    | \nvDash      |     $ \nVDash $      | \nVDash          |     $\succneqq$     | \succneqq         |
|   $ \precnsim $   | \precnsim      | $ \precnapprox $ | \precnapprox |    $ \subsetneq $    | \subsetneq       |  $\ntriangleleft$   | \ntriangleleft    |
|   $ \succnsim $   | \succnsim      | $ \succnapprox $ | \succnapprox |    $ \supsetneq $    | \supsetneq       |  $\ntriangleright$  | \ntriangleright   |
| $ \varsubsetneq $ | \varsubsetneq  |  $ \nsubseteq $  | \nsubseteq   |   $ \subsetneqq $    | \subsetneqq      | $\ntrianglelefteq$  | \ntrianglelefteq  |
| $ \varsupsetneq $ | \varsupsetneq  |  $ \nsupseteq $  | \nsupseteq   |   $ \supsetneqq $    | \supsetneqq      | $\ntrianglerighteq$ | \ntrianglerighteq |
|  $ \nleftarrow $  | \nleftarrow    | $ \nrightarrow $ | \nrightarrow | $ \nleftrightarrow $ | \nleftrightarrow |                     |                   |
|  $ \nLeftarrow $  | \nLeftarrow    | $ \nRightarrow $ | \nRightarrow | $ \nLeftrightarrow $ | \nLeftrightarrow |                     |                   |

## AMS 二元运算符

|      符号      | LaTex命令  |      符号       | LaTex命令   |        符号        | LaTex命令        |
| :------------: | ---------- | :-------------: | ----------- | :----------------: | ---------------- |
|  $ \dotplus $  | \dotplus   | $ \centerdot $  | \centerdot  |  $\divideontimes$  | \divideontimes   |
|  $ \ltimes $   | \ltimes    |   $ \rtimes $   | \rtimes     |  $\smallsetminus$  | \smallsetminus   |
| $ \doublecup $ | \doublecup | $ \doublecap $  | \doublecap  | $\doublebarwedge$  | \doublebarwedge  |
|  $ \veebar $   | \veebar    |  $ \barwedge $  | \barwedge   |   $\circleddash$   | \circleddash     |
|  $ \boxplus $  | \boxplus   |  $ \boxminus $  | \boxminus   |   $\circledcirc$   | \circledcirc     |
| $ \boxtimes $  | \boxtimes  |   $ \boxdot $   | \boxdot     | $\rightthreetimes$ | \rightthreetimes |
| $ \intercal $  | \intercal  | $ \circledast $ | \circledast | $\leftthreetimes$  | \leftthreetimes  |
| $ \curlyvee $  | \curlyvee  | $ \curlywedge $ | \curlywedge |                    |                  |

## AMS 其他符号

|       符号        | LaTex命令     |          符号          | LaTex命令          |     符号      | LaTex命令   |
| :---------------: | :------------ | :--------------------: | ------------------ | :-----------: | ----------- |
|     $ \hbar $     | \hbar         |      $ \hslash $       | \hslash            |    $\Bbbk$    | \Bbbk       |
|    $ \square $    | \square       |    $ \blacksquare $    | \blacksquare       |  $\circledS$  | \circledS   |
| $ \vartriangle $  | \vartriangle  |   $ \blacktriangle $   | \blacktriangle     | $\complement$ | \complement |
| $ \triangledown $ | \triangledown | $ \blacktriangledown $ | \blacktriangledown |    $\Game$    | \Game       |
|   $ \lozenge $    | \lozenge      |   $ \blacklozenge $    | \blacklozenge      |  $\bigstar$   | \bigstar    |
|    $ \angle $     | \angle        |   $ \measuredangle $   | \measuredangle     |               |             |
|    $ \diagup $    | \diagup       |     $ \diagdown $      | \diagdown          | $\backprime$  | \backprime  |
|   $ \nexists $    | \nexists      |       $ \Finv $        | \Finv              | $\varnothing$ | \varnothing |
|     $ \eth $      | \eth          |  $ \sphericalangle $   | \sphericalangle    |    $\mho$     | \mho        |

