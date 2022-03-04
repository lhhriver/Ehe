**常见的关于Anaconda的操作命令**

|               终端命令               | 作用                                                         |
| :----------------------------------: | ------------------------------------------------------------ |
|          python -V/–version          | 查看当前环境python版本                                       |
|          conda -V/–version           | 查看当前Anaconda版本                                         |
|          conda info --envs           | 查看在Anaconda下已创建的环境                                 |
| conda create -n 环境名 python=版本号 | 在指定python版本下创建环境                                   |
|     conda remove -n 环境名 --all     | 删除指定环境                                                 |
|        conda activate 环境名         | 激活当前环境并进入                                           |
|           conda deactivate           | 退出当前环境                                                 |
|          conda install 包名          | 使用Anaconda安装包                                           |
|           pip install 包名           | 安装包（对于那些无法通过ANaconda安装或者从Anaconda.org获得的包，我们通常可以用pip命令来安装包） |
|              conda list              | 进入一个环境后，查看该环境下安装的所有包（以及版本号）       |
|          conda update conda          | 升级当前版本的Anaconda                                       |



**选择清华软件仓库镜像**

```python
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/

conda config --set show_channel_urls yes
```



**用Anaconda3创建一个python3.7的环境，环境名称为tensorflow**

```python
# 创建
conda create -n tensorflow python=3.7

# 查看
conda info --envs

# 激活
activate tensorflow

# 安装自己的package
pip install ***

# 退出
conda deactivate
```



source activate fs_dev

source deactivate





