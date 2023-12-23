# 端到端声学模型离线finetune

**注：**如果离线finetune之前做过在线finetune，且使用的同一批训练数据，则可以利用在线生成好的json训练数据，直接进行训练。

## 目录结构

```
├── eteh-v2-release-offline_export_202109
│   ├── data_frontend_v4_hires_chinese_u8_mfcchirs40_release  数据处理第一步，主要完成数据分词、提特征等
│   │   ├── bin
│   │   ├── libs
│   │   ├── log_20190619
│   │   ├── readme.txt
│   │   ├── run.sh
│   │   └── scripts
│   ├── env_train 训练环境目录
│   │   ├── baseModel 基线模型
│   │   ├── bin
│   │   ├── cmd.sh
│   │   ├── conf
│   │   ├── gen_data_yaml.pl
│   │   ├── path.sh
│   │   └── run.offline_finetune.sh 训练启动脚本
│   ├── eteh 训练依赖环境
│   ├── model_convert 二进制模型转换
│   │   ├── average_checkpoints.py
│   │   ├── average_checkpoints.py_bak
│   │   ├── config_chn.txt
│   │   ├── convert_model.py
│   │   └── model_convert.sh
│   ├── model_convert_onnx onnx模型转换
│   │   ├── config.py
│   │   ├── espnet
│   │   ├── __pycache__
│   │   ├── torch2onnx_onnxruntime.py
│   │   └── ZhModel
│   ├── prepare-json 数据预处理第二步，训练数据json文件准备
│   │   ├── prepjson
│   │   └── prepjson_lang
│   ├── run_prepare_trainData.sh 数据预处理脚本
│   └── utils 工具目录
└── env
   └── gpu-cuda10.1-cudnn7-u18-local-espnet-torch1.7-release.tar 镜像文件
```



## 训练环境 docker容器

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
NV_GPU='0,1,2,3' nvidia-docker run 
--ipc=host 
--name e2e-finetune-env -it -d 
-v /data/user:/data/user 
--entrypoint="/bin/bash" 
422f8d9340c5
```

\-v 参数指定工作目录，第一个参数为物理机路径，第二个参数为容器工作路径

422f8d9340c5 image ID

\--name 执定容器的名字

### 进入容器

```shell
docker exec -it e2e-offline-finetune /bin/bash
```

### 关闭容器及删除

容器启动后会占用部分磁盘空间，为了保证磁盘空间的高效利用，容器使用完成后要及时关闭和删除，命令如下：

```shell
docker stop containerID
```

```shell
docker rm containerID
```

如果后续镜像也不会再使用，也需要进行删除，命令如下：

```shell
docker rmi imageID
```



## 训练

进入到该目录下eteh-v2-release-offline\_export\_202109，进行数据预处理及模型训练。

请预先参照Q\&A重新编译kaldi环境，防止出现数据预处理异常，kaldi编译需要一些时间。

### 数据预处理

#### stage=0开始处理

进入到该目录下eteh-v2-release-offline\_export\_202109，修改数据预处理总控脚本run\_prepare\_trainData.sh，可修改参数如下：

**注意：以下路径请使用绝对路径**

- wav\_dir=/home/user/e2e\_finetune/test/input 语音路径

- output\_dir=/home/user/e2e\_finetune/test/output 中间结果及最终结果输出路径

- num\_utt\_percent=50 从训练集中挑选百分之多少作为验证集，取倒数，这里是1/50=2%

- 输出的可用于训练的json文件路径为：${output\_dir}/preparejson/split\_train\_dev

### 模型训练

进入eteh-v2-release-offline\_export\_202109/env\_train目录，修改run.offline.sh脚本，参数说明如下：

- 使用该命令nvidia-smi查看可用卡数，进行配置，例如：0,1,2,3

```
export CUDA_VISIBLE_DEVICES=3
```

- 用几块进行训练，与上面配置的CUDA\_VISIBLE\_DEVICES个数相同

```
num_gpu=1
```

- 迭代的epoch个数为40-30=10次

```
epochs=40 # epochs for online model
```

- 基线模型，无需修改

```
checkpoint= baseModel/checkpoint.29
```

- 模型配置，无需修改

```
train_config=conf/ce_espnet_baseline_fintune.yaml
```

- json训练数据配置

```
data_conf=conf/data.yaml
```

- 数据预处理最后输出的json路径，根据数据预处理实际输出进行配置

```
json_train_dir=/data/user/AM/dataEnv/test/output/offline/split_train_dev
```

- 训练数据json个数，与数据预处理过程最后生成的train的json个数相同

```
json_nj=8
```

- 训练模型输出路径，可自定义修改

```
exp_dir=/data/user/AM/dataEnv/test/output/offline/exp
```

---

主要修改参数为json\_train\_dir、exp\_dir，可以适当调节epochs的个数，修改完成后执行该脚本进行训练。

- 模型输出路径：${exp\_dir}目录下

- 学习率可调：conf/ce\_espnet\_baseline\_fintune.yaml 文件里factor参数默认为1，可调节至0.1、0.01对模型进行调优。

### 模型转换

#### bin模型（常用）：

进入eteh-v2-release-offline\_export\_202109 /model\_convert目录，执行：

```
./run.sh 模型输出路径 37 40
```

- 参数1为模型输出路径，保存要做平均的checkpoint.\*的路径

- 参数2为模型平均的开始epoch数

- 参数3 为模型平均的结束的epoch数

上述命令对37、38、39 epoch模型做平均。

## Q\&A

**问题**：数据预处理异常，Kaldi命令提示找不到相应的库文件

**问题描述**：align.1.log

```
compile-train-graphs: error while loading shared libraries: libkaldi-decoder.so: cannot open shared object file: No such file or directory

nnet3-align-compiled: error while loading shared libraries: libkaldi-nnet3.so: cannot open shared object file: No such file or directory
```

**解决办法**：进入到容器后，进入到/kaldi-master/src目录，重新编译kaldi，参照INSTALL说明进行编译即可。

```shell
make clean
./configure --shared
make depend -j 8
make -j 8
```



## 模型训练yaml文件说明

ce\_espnet\_baseline\_fintune.yaml

```
set_config:
data_type: json
load: False

jconfig:
batch_size: 16 #训练数据batch大小，可根据显存进行调节，16-32
max_length_in: 512
max_length_out: 150
num_batches: 0
min_batch_size: 1
shortest_first: True
batch_sort_key: "input"
swap_io: False
count: "seq"
batch_bins: 100000
batch_frames_in: 0
batch_frames_out: 0
batch_frames_inout: 0
clean_data: True #是否对数据进行筛选
down_sample: 2
ilen_max: 2000 #最大输入utt的帧数
ilen_min: 17 #最小输入utt的帧数
olen_max: 100 #最大输出utt的字符个数

trans_config:
# these three processes are a.k.a. SpecAugument
- type: "time_warp"
max_time_warp: 5
inplace: true
mode: "PIL"
- type: "freq_mask"
F: 30
n_mask: 2
inplace: true
replace_with_zero: false
- type: "time_mask"
T: 40
n_mask: 2
inplace: true
replace_with_zero: false

opti_config:
name: 'eteh.models.pytorch_backend.optimizer.optimizer:Noam'
factor: 1 #调节学习率大小，缩放因子
warm_step: 25000
model_size: 256

criterion_config:
name: 'eteh.models.pytorch_backend.criterion.loss:E2E_Loss'
size: 5720
padding_idx: -1
smoothing: 0.1
rate: 0.3

model_config: #模型配置参数
name: 'eteh.models.pytorch_backend.model.e2e:E2E_Transformer_CTC'
idim: 40 #特征输入维度
odim: 5720 #label输出个数
encoder_attention_dim: 320 #encoder注意力机制维度
encoder_attention_heads: 8 #注意力头个数
encoder_linear_units: 2048 #encoder的线性单元个数
encoder_num_blocks: 14 #encoder的block个数
encoder_input_layer: conv2d #encoder的输入层，二维卷积
encoder_dropout_rate: 0.1
encoder_attention_dropout_rate: 0
decoder_attention_dim: 320
decoder_attention_heads: 4
decoder_linear_units: 2048
decoder_input_layer: embed
decoder_num_block: 7
decoder_dropout_rate: 0.1
decoder_src_attention_dropout_rate: 0
decoder_self_attention_dropout_rate: 0
ctc_dropout: 0.1

train_config: #训练参数
char_num: 5720 #输出label个数
accum_grad: 2 #must be 1 when amp is used #梯度累积，2*batch_size更新梯度
amp: False

valid_config: #valid 配置
data_type: json

jconfig:
batch_size: 16
max_length_in: 512
max_length_out: 150
num_batches: 0
min_batch_size: 1
shortest_first: True
batch_sort_key: "input"
swap_io: False
count: "seq"
batch_bins: 100000
batch_frame_in: 0
batch_frames_out: 0
batch_frames_inout: 0
clean_data: True
down_sample: 2
ilen_max: 2000
ilen_min: 17
olen_max: 100

decode_config: #解码参数
beam: 10
ctc_beam: 15
lm_rate: 0
ctc_weight: 0.3
char_num: 5720
```

