# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:light
#     text_representation:
#       extension: .py
#       format_name: light
#       format_version: '1.4'
#       jupytext_version: 1.2.4
#   kernelspec:
#     display_name: Python 3
#     language: python
#     name: python3
# ---

# # 2.2 数据操作

# +
import torch

torch.manual_seed(0)
torch.cuda.manual_seed(0)
print(torch.__version__)
# -

# ## 2.2.1 创建`Tensor`
#
# 创建一个5x3的未初始化的`Tensor`：

x = torch.empty(5, 3)
print(x)

# 创建一个5x3的随机初始化的`Tensor`:
#
#

x = torch.rand(5, 3)
print(x)

# 创建一个5x3的long型全0的`Tensor`:
#
#

x = torch.zeros(5, 3, dtype=torch.long)
print(x)

# 直接根据数据创建:

x = torch.tensor([5.5, 3])
print(x)

# 还可以通过现有的`Tensor`来创建，此方法会默认重用输入`Tensor`的一些属性，例如数据类型，除非自定义数据类型。

# +
x = x.new_ones(5, 3, dtype=torch.float64)      # 返回的tensor默认具有相同的torch.dtype和torch.device
print(x)

x = torch.randn_like(x, dtype=torch.float)    # 指定新的数据类型
print(x)                                    
# -

# 我们可以通过`shape`或者`size()`来获取`Tensor`的形状:

print(x.size())
print(x.shape)

# > 注意：返回的torch.Size其实就是一个tuple, 支持所有tuple的操作。

# ## 2.2.2 操作
# ### 算术操作
# * **加法形式一**

y = torch.rand(5, 3)
print(x + y)

# * **加法形式二**

print(torch.add(x, y))

result = torch.empty(5, 3)
torch.add(x, y, out=result)
print(result)

# * **加法形式三、inplace**

# adds x to y
y.add_(x)
print(y)

# > **注：PyTorch操作inplace版本都有后缀"_", 例如`x.copy_(y), x.t_()`**
#
# ### 索引
# 我们还可以使用类似NumPy的索引操作来访问`Tensor`的一部分，需要注意的是：**索引出来的结果与原数据共享内存，也即修改一个，另一个会跟着修改。** 

y = x[0, :]
y += 1
print(y)
print(x[0, :]) # 源tensor也被改了

# ### 改变形状
# 用`view()`来改变`Tensor`的形状：

y = x.view(15)
z = x.view(-1, 5)  # -1所指的维度可以根据其他维度的值推出来
print(x.size(), y.size(), z.size())

# **注意`view()`返回的新tensor与源tensor共享内存，也即更改其中的一个，另外一个也会跟着改变。**

x += 1
print(x)
print(y) # 也加了1

# 如果不想共享内存，推荐先用`clone`创造一个副本然后再使用`view`。

x_cp = x.clone().view(15)
x -= 1
print(x)
print(x_cp)

# 另外一个常用的函数就是`item()`, 它可以将一个标量`Tensor`转换成一个Python number：

x = torch.randn(1)
print(x)
print(x.item())

# ## 2.2.3 广播机制

x = torch.arange(1, 3).view(1, 2)
print(x)
y = torch.arange(1, 4).view(3, 1)
print(y)
print(x + y)

# ## 2.2.4 运算的内存开销

x = torch.tensor([1, 2])
y = torch.tensor([3, 4])
id_before = id(y)
y = y + x
print(id(y) == id_before)

x = torch.tensor([1, 2])
y = torch.tensor([3, 4])
id_before = id(y)
y[:] = y + x
print(id(y) == id_before)

x = torch.tensor([1, 2])
y = torch.tensor([3, 4])
id_before = id(y)
torch.add(x, y, out=y) # y += x, y.add_(x)
print(id(y) == id_before)

# ## 2.2.5 `Tensor`和NumPy相互转换
# **`numpy()`和`from_numpy()`这两个函数产生的`Tensor`和NumPy array实际是使用的相同的内存，改变其中一个时另一个也会改变！！！**
# ### `Tensor`转NumPy

# +
a = torch.ones(5)
b = a.numpy()
print(a, b)

a += 1
print(a, b)
b += 1
print(a, b)
# -

# ### NumPy数组转`Tensor`

# +
import numpy as np
a = np.ones(5)
b = torch.from_numpy(a)
print(a, b)

a += 1
print(a, b)

b += 1
print(a, b)
# -

# 直接用`torch.tensor()`将NumPy数组转换成`Tensor`，该方法总是会进行数据拷贝，返回的`Tensor`和原来的数据不再共享内存。

# 用torch.tensor()转换时不会共享内存
c = torch.tensor(a)
a += 1
print(a, c)

# ## 2.2.6 `Tensor` on GPU

# 以下代码只有在PyTorch GPU版本上才会执行
if torch.cuda.is_available():
    device = torch.device("cuda")          # GPU
    y = torch.ones_like(x, device=device)  # 直接创建一个在GPU上的Tensor
    x = x.to(device)                       # 等价于 .to("cuda")
    z = x + y
    print(z)
    print(z.to("cpu", torch.double))       # to()还可以同时更改数据类型



# +
import torch

print(torch.__version__)
# -

# # 2.3 自动求梯度
# ## 2.3.1 概念
# 上一节介绍的`Tensor`是这个包的核心类，如果将其属性`.requires_grad`设置为`True`，它将开始追踪(track)在其上的所有操作。完成计算后，可以调用`.backward()`来完成所有梯度计算。此`Tensor`的梯度将累积到`.grad`属性中。
# > 注意在调用`.backward()`时，如果`Tensor`是标量，则不需要为`backward()`指定任何参数；否则，需要指定一个求导变量。
#
# 如果不想要被继续追踪，可以调用`.detach()`将其从追踪记录中分离出来，这样就可以防止将来的计算被追踪。此外，还可以用`with torch.no_grad()`将不想被追踪的操作代码块包裹起来，这种方法在评估模型的时候很常用，因为在评估模型时，我们并不需要计算可训练参数（`requires_grad=True`）的梯度。
#
# `Function`是另外一个很重要的类。`Tensor`和`Function`互相结合就可以构建一个记录有整个计算过程的非循环图。每个`Tensor`都有一个`.grad_fn`属性，该属性即创建该`Tensor`的`Function`（除非用户创建的`Tensor`s时设置了`grad_fn=None`）。
#
# 下面通过一些例子来理解这些概念。
#
# ## 2.3.2 `Tensor`

x = torch.ones(2, 2, requires_grad=True)
print(x)
print(x.grad_fn)

y = x + 2
print(y)
print(y.grad_fn)

# 注意x是直接创建的，所以它没有`grad_fn`, 而y是通过一个加法操作创建的，所以它有一个为`<AddBackward>`的`grad_fn`。

print(x.is_leaf, y.is_leaf)

z = y * y * 3
out = z.mean()
print(z, out)

# 通过`.requires_grad_()`来用in-place的方式改变`requires_grad`属性：

a = torch.randn(2, 2) # 缺失情况下默认 requires_grad = False
a = ((a * 3) / (a - 1))
print(a.requires_grad) # False
a.requires_grad_(True)
print(a.requires_grad) # True
b = (a * a).sum()
print(b.grad_fn)

# ## 2.3.3 梯度 
#
# 因为`out`是一个标量，所以调用`backward()`时不需要指定求导变量：

out.backward() # 等价于 out.backward(torch.tensor(1.))
print(x.grad)

# 我们令`out`为 $o$ , 因为
# $$
# o=\frac14\sum_{i=1}^4z_i=\frac14\sum_{i=1}^43(x_i+2)^2
# $$
# 所以
# $$
# \frac{\partial{o}}{\partial{x_i}}\bigr\rvert_{x_i=1}=\frac{9}{2}=4.5
# $$
# 所以上面的输出是正确的。

# 数学上，如果有一个函数值和自变量都为向量的函数 $\vec{y}=f(\vec{x})$, 那么 $\vec{y}$ 关于 $\vec{x}$ 的梯度就是一个雅可比矩阵（Jacobian matrix）:
#
# $$
# J=\left(\begin{array}{ccc}
#    \frac{\partial y_{1}}{\partial x_{1}} & \cdots & \frac{\partial y_{1}}{\partial x_{n}}\\
#    \vdots & \ddots & \vdots\\
#    \frac{\partial y_{m}}{\partial x_{1}} & \cdots & \frac{\partial y_{m}}{\partial x_{n}}
#    \end{array}\right)
# $$
#
# 而``torch.autograd``这个包就是用来计算一些雅克比矩阵的乘积的。例如，如果 $v$ 是一个标量函数的 $l=g\left(\vec{y}\right)$ 的梯度：
#
# $$
# v=\left(\begin{array}{ccc}\frac{\partial l}{\partial y_{1}} & \cdots & \frac{\partial l}{\partial y_{m}}\end{array}\right)
# $$
#
# 那么根据链式法则我们有 $l$ 关于 $\vec{x}$ 的雅克比矩阵就为:
#
# $$
# v \cdot J=\left(\begin{array}{ccc}\frac{\partial l}{\partial y_{1}} & \cdots & \frac{\partial l}{\partial y_{m}}\end{array}\right) \left(\begin{array}{ccc}
#    \frac{\partial y_{1}}{\partial x_{1}} & \cdots & \frac{\partial y_{1}}{\partial x_{n}}\\
#    \vdots & \ddots & \vdots\\
#    \frac{\partial y_{m}}{\partial x_{1}} & \cdots & \frac{\partial y_{m}}{\partial x_{n}}
#    \end{array}\right)=\left(\begin{array}{ccc}\frac{\partial l}{\partial x_{1}} & \cdots & \frac{\partial l}{\partial x_{n}}\end{array}\right)
# $$

# 注意：grad在反向传播过程中是累加的(accumulated)，这意味着每一次运行反向传播，梯度都会累加之前的梯度，所以一般在反向传播之前需把梯度清零。

# +
# 再来反向传播一次，注意grad是累加的
out2 = x.sum()
out2.backward()
print(x.grad)

out3 = x.sum()
x.grad.data.zero_()
out3.backward()
print(x.grad)
# -

x = torch.tensor([1.0, 2.0, 3.0, 4.0], requires_grad=True)
y = 2 * x
z = y.view(2, 2)
print(z)

# 现在 `y` 不是一个标量，所以在调用`backward`时需要传入一个和`y`同形的权重向量进行加权求和得到一个标量。

# +
v = torch.tensor([[1.0, 0.1], [0.01, 0.001]], dtype=torch.float)
z.backward(v)

print(x.grad)
# -

# 再来看看中断梯度追踪的例子：

# +
x = torch.tensor(1.0, requires_grad=True)
y1 = x ** 2 
with torch.no_grad():
    y2 = x ** 3
y3 = y1 + y2
    
print(x, x.requires_grad)
print(y1, y1.requires_grad)
print(y2, y2.requires_grad)
print(y3, y3.requires_grad)
# -

y3.backward()
print(x.grad)

# 为什么是2呢？$ y_3 = y_1 + y_2 = x^2 + x^3$，当 $x=1$ 时 $\frac {dy_3} {dx}$ 不应该是5吗？事实上，由于 $y_2$ 的定义是被`torch.no_grad():`包裹的，所以与 $y_2$ 有关的梯度是不会回传的，只有与 $y_1$ 有关的梯度才会回传，即 $x^2$ 对 $x$ 的梯度。
#
# 上面提到，`y2.requires_grad=False`，所以不能调用 `y2.backward()`。

# +
# y2.backward() # 会报错 RuntimeError: element 0 of tensors does not require grad and does not have a grad_fn
# -

# 如果我们想要修改`tensor`的数值，但是又不希望被`autograd`记录（即不会影响反向传播），那么我么可以对`tensor.data`进行操作.

# +
x = torch.ones(1, requires_grad=True)

print(x.data)  # 还是一个tensor
print(x.data.requires_grad)  # 但是已经是独立于计算图之外

y = 2 * x
x.data *= 100  # 只改变了值，不会记录在计算图，所以不会影响梯度传播

y.backward()
print(x)  # 更改data的值也会影响tensor的值
print(x.grad)
# -


