# 端到端在线声学模型finetune

## 目录结构

```c++
|-- eteh-v2-release-online_export_202109
| |-- data_frontend_v4_hires_chinese_u8_mfcchirs40_release // 数据处理步骤一，主要完成分词、提特征等
| | |-- bin
| | |-- libs
| | |-- log_20190619
| | |-- readme.txt
| | |-- run.sh
| | -- scripts
| |-- env_alignments // 数据处理步骤二，进行align对齐
| | |-- cmd.sh
| | |-- lang
| | |-- model // align的基线模型
| | |-- path.sh
| | |-- run_alignment.sh
| | |-- steps
| | -- utils
| |-- env_datajson // 数据处理步骤三，准备训练需要的json文件
| | |-- cmd.sh
| | |-- lang // 语言层信息
| | |-- path.sh
| | |-- run_datajson.sh
| | -- utils
| |-- env_train // 训练环境
| | |-- bin
| | |-- cmd.sh
| | |-- conf // 训练配置文件和json数据配置文件
| | |-- exp // 基线模型
| | |-- gen_data_yaml.pl
| | |-- path.sh
| | -- run.online_finetune.sh // 训练可执行文件
| |-- eteh // 训练依赖的环境
| | |-- CONTRIBUTING.md
| | |-- LICENSE
| | |-- README.md
| | |-- bin
| | |-- eteh
| | -- example
| |-- model_convert // 模型转换工具
| | |-- README
| | |-- average_checkpoints.py
| | |-- convert_model_mta.py
| | |-- model.eteh.config
| | -- run.sh
| |-- path.sh
| -- run_prepare_trainData.sh // 数据预处理总控脚本
|-- env // 依赖环境，docker镜像
-- gpu-cuda10.1-cudnn7-u18-local-espnet-torch1.7-release.tar
```



## 训练环境-docker容器

依赖环境位于env目录下

### NVIDIA 驱动要求

要求加载镜像的物理机安装支持cuda10 及以上的NVIDIA驱动，驱动版本要在410.129版本及以上

### Docker镜像加载

```shell
docker load -i gpu-cuda10.1-cudnn7-u18-local-espnet-torch1.7-release.tar
```

### 查看image ID

```shell
docker images
```

### 启动镜像

```shell
NV_GPU='0,1,2,3' nvidia-docker run --ipc=host --name e2e-finetune-env -it -d -v /data/user:/data/user --entrypoint="/bin/bash" 422f8d9340c5
```

> \-v 参数指定工作目录，第一个参数为物理机路径，第二个参数为容器工作路径
>
> 422f8d9340c5 image ID
>
> \--name 执定容器的名字

### 进入容器

```shell
docker exec -it e2e-finetune /bin/bash
```

### 关闭容器及删除

容器启动后会占用部分磁盘空间，为了保证磁盘空间的高效利用，容器使用完成后要及时关闭和删除，命令如下：

```shell
docker stop containerID
docker rm containerID
```

如果后续镜像也不会再使用，也需要进行删除，命令如下：

```shell
docker rmi imageID
```



## 训练

进入到该目录下eteh-v2-release-online\_export\_202109，进行数据预处理及模型训练。

请预先参照Q\&A重新编译kaldi环境，防止出现数据预处理异常，kaldi编译需要一些时间。

### 数据预处理

#### stage=0开始处理

进入到该目录下**deliverables\_release\_online\_finetuneJH\_202102**，修改数据预处理总控脚本**run\_prepare\_trainData.sh**，可修改参数如下：

**注意：以下路径请使用绝对路径**

```shell
wav_dir=/home/user/e2e_finetune/test/input # 语音路径
output_dir=/home/user/e2e_finetune/test/output # 中间结果及最终结果输出路径
num_utt_percent=50 # 从训练集中挑选百分之多少作为验证集，取倒数，这里是1/50=2%
```

 输出的可用于训练的json文件路径为：**${output\_dir}/preparejson/dump/train\_dev\_json**

#### stage=3开始处理

由于align时间较长，有时候我们需要利用之前align的结果，可将stage设置为3进行处理，需要注意两个地方：

**（1）** **run\_prepare\_trainData.sh**脚本中:

```shell
ali_ouput_dir   # 设置为已有align文件的目录
ali_nj   # 设置为已有align文件的个数
```


一定要注意ali\_nj文件个数的设置，以免部分align数据利用不全.

**（2）**资源文件要一致

align的时候用的资源文件要同env\_datajson/lang文件下的资源文件要一致，以免造成生成json文件脚本异常，可以从原来align环境中找到对应的资源文件，拷贝过来，具体包括以下资源文件：**align\_lexicon.int、phones.txt、words.txt**

### 模型训练

进入**deliverables\_release\_online\_finetuneJH\_202102/env\_train**目录，修改`run.online_finetune.sh`脚本，参数说明如下：

- 使用该命令nvidia-smi查看可用卡数，进行配置，例如：0,1,2,3

```
export CUDA_VISIBLE_DEVICES=3
```

- 用几块进行训练，与上面配置的CUDA\_VISIBLE\_DEVICES个数相同

```
ngpu=1
```

- 迭代的epoch个数为40-30=10次

```shell
epochs=70 # epochs for online model
```

- 基线模型，无需修改

```shell
checkpoint =baseModel/checkpoint.59
```

- 模型配置，无需修改

```shell
train_config=conf/ce_espnet_online_transformer_nospecaug_md.yaml
```

- json训练数据配置

```shell
data_conf=conf/data.yaml
```

- 数据预处理最后输出的json路径，根据数据预处理实际输出进行配置

```shell
json_train_dir =/home/user/e2e_finetune/test/output/preparejson/dump/train_dev_json
```

- 训练数据json个数，与数据预处理过程最后生成的train的json个数相同

```shell
json_nj=8
```

- 训练模型输出路径，可自定义修改

```shell
exp_dir=/home/user/e2e_finetune/test/output/exp
```

- 主要修改参数为json\_train\_dir、exp\_dir，可以适当调节epochs的个数，修改完成后执行该脚本进行训练。

- 模型输出路径：**${exp\_dir}**

### 模型转换

#### bin模型（常用）：

进入eteh-v2-release-online\_export\_202109/model\_convert目录，执行：

```shell
./run.sh 模型输出路径 model.epochs.bin 5
```

- 参数1为模型输出路径，保存要做平均的model.\*.tar的路径

- 参数2为二进制模型，可用于实际系统进行测试

- 参数3 模型平均的个数，一般取5个或10个，会对model.\*.tar进行日期排序，取最后num个，一般情况下日期排序就是模型编号排序，如果model.\*.tar是拷贝过去的，顺序会被打乱，为了确保无误，参数1下面只保留确定要平均的模型。

## Q\&A

**问题**：数据预处理异常，Kaldi命令提示找不到相应的库文件

**问题描述**：align.1.log

```
compile-train-graphs: error while loading shared libraries: libkaldi-decoder.so: cannot open shared object file: No such file or directory

nnet3-align-compiled: error while loading shared libraries: libkaldi-nnet3.so: cannot open shared object file: No such file or directory
```

**解决办法**：进入到容器后，进入到**/kaldi-master/src**目录，重新编译kaldi，参照INSTALL说明进行编译即可。

```shell
make clean
./configure --shared

make depend -j 8
make -j 8
```

