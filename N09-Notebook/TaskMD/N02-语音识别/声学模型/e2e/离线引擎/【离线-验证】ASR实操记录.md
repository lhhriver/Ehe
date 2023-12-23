# 数据预处理

TODO

# 离线ASR训练工具

## 准备工作

### 基本信息【133】

> **代码目录**：/wp/aster/zhongke/南网第二阶段文档、源码交付物/二阶段代码-南网202111-jiami/端到端语音识别训练工具/离线/
> eteh-v2-release-JXJK2021_orig_v2_release

### 数据来源【226】

> **Json数据**：/home/blue/ssd/thinkit/data/95598_longwav/dataEnv/preparejson/split_train_dev
>
> **特征数据**：/home/blue/ssd/thinkit/data/95598_longwav/dataEnv/feats/mfcc-hires

### 容器【147】

1. 加载镜像文件 147/data/thinkit_train/system/env

```shell
docker load -i espnet-gpu-cuda10.1-cudnn7-u18-local-nw.tar
```

2. 镜像：espnet

```shell
docker images | grep espnet
espnet gpu-cuda10.1-cudnn7-u18-local 6d3a635a5ed 15 months ago 22.5GB
```

3. 开启容器：e2e-finetune-env

```shell
NV_GPU='0,1' nvidia-docker run
--ipc=host
--name e2e-finetune-env
-it -d
-v /data/thinkit_train:/data/thinkit_train
--entrypoint="/bin/bash"
6d3a635a5ed1
```

4. 进入容器

```shell
docker exec -it e2e-finetune-env bash
```

5. 容器内路径

```shell
/home/Ehe/WorkSpace/eteh-v2-release-JXJK2021_orig_v2_release
```



### 配置修改

#### 数据配置

1. 文件：example/hkust_egs/conf/data.yaml

```yaml
clean_source:
1:
type:json
name:kefu_cts
json:/data/Ehe/json3/data.1.json

2:
type:json
name:kefu_cts
json:/data/Ehe/json3/data.2.json
valid_source:

1:
type:json
name:dev
json:/data/Ehe/json3/data.3.json
```

**备注**：将json数据放到/data/Ehe/josn3目录下，可以自定义，特征数据路面必须跟json里面路径一致



#### GPU配置

1. 查看GPU信息：

```shell
nvidia-smi
```

2. 文件：example/hkust_egs/path.sh

```shell
MAIN_ROOT=/home/gaochangfeng/docker/env
#PLAT_ROOT=$MAIN_ROOT/eteh_all/eteh2_20210129
PLAT_ROOT=../../
KALDI_ROOT=/opt/kaldi
ESPNET_ROOT=$MAIN_ROOT/espnet_utils:$MAIN_ROOT
FLAC_ROOT=$MAIN_ROOT/flac_1.3.2/bin
FAIRSEQ_ROOT=$MAIN_ROOT/fairseq/fairseq_20200808
LOCAL=./bin
UTIL_ROOT=$MAIN_ROOT/utils/
exportPYTHONPATH=$LOCAL:$FAIRSEQ_ROOT:$ESPNET_ROOT:$PLAT_ROOT:$PYTHONPATH

##[-f$KALDI_ROOT/tools/env.sh]&&.$KALDI_ROOT/tools/env.sh

#exportPATH=$PWD/utils/:$KALDI_ROOT/tools/openfst/bin:$KALDI_ROOT/tools/sctk/bin:$PWD:$PATH
#[!-f$KALDI_ROOT/tools/config/common_path.sh]&&echo>&2"Thestandardfile$KALDI_ROOT/tools/config/common_path.shisnotpresent->Exit!"&&exit1
#.$KALDI_ROOT/tools/config/common_path.sh

exportPATH=$MAIN_ROOT/utils/:$FLAC_ROOT:$ESPNET_ROOT:$PATH
exportCUDA_VISIBLE_DEVICES=0,1
```

## 模型训练

1. 文件：example/hkust_egs/run_train.sh

```shell
../path.sh

epochs=40
init_method='tcp://127.0.0.1:8888'

exp_dir=output/exp
train_config=conf/ce_espnet_baseline_fintune.yaml
data_conf=conf/data.yaml
checkpoint=baseModel/checkpoint.29

mkdir-p${exp_dir}

python${PLAT_ROOT}/bin/train.py-train_config${train_config}\
-data_config${data_conf}\
-train_nameHKUST\
-task_filebin.taskegs.pytorch_backend.task_ctc_att\
-num_gpu2\
-task_nameCtcAttTask\
-exp_dir${exp_dir}\
-num_epochs${epochs}\
-seed100\
-checkpoint$checkpoint\
--resume_progress\
--split

:<<eof
python${PLAT_ROOT}/bin/train.py-train_config${train_config}\
-data_config${data_conf}\
-train_nameHKUST\
-task_filebin.taskegs.pytorch_backend.task_ctc_att\
-num_gpu1\
-task_nameCtcAttTask\
-exp_dir${exp_dir}\
-num_epochs${epochs}\
-seed100\
-checkpoint$checkpoint\
--resume_optimizer\
--resume_progress\
--split
eof
```



> **参数说明**
>
> 1. 模型训练脚本位于：example/hkust_egs/run_train.sh
>
> 2. 参数说明：
>
>     - exp_dir=output/exp 模型输出路径
>     - train_config=conf/ce_espnet_baseline_fintune.yaml 模型训练配置
>     - data_conf=conf/data.yaml 训练数据yaml文件
>     - checkpoint=baseModel/checkpoint.29 基线模型
>
> 3. 运行方法：
>
>     ```shell
>     ./run_train.sh
>     ```
>

## 模型预测

> 1. 模型预测脚本位于：example/hkust_egs/run_predictor.sh
>
> 2. 参数说明：
>
>     - exp_dir=output/exp 模型输出路径
>     - train_config=conf/ce_espnet_baseline_fintune.yaml 模型训练配置
>     - data_conf=conf/data.yaml 训练数据yaml文件
>     - char_list=baseModel/vocab.kefu_cts.txt 字典文件
>     - checkpoint=baseModel/checkpoint.29 基线模型
>
> 3. 运行方法：
>
>     ```shell
>     ./run_predictor.sh
>     ```
>

## 模型评估

> 1. 模型评估脚本位于：example/hkust_egs/run_evaluate.sh
>
> 2. 参数说明：
>
>     - rec=yourresultfile 结果文件
>     - ref=yourreffile 答案文件
>
> 3. 运行方法：./run_evaluate.sh
>
> 4. 执行完成后，会在结果所在路径生成.sys文件，为识别率测试结果，如下：
>
>     ```
>     SPKR|#Snt#Chr|CorrSubDelInsErrS.Err
>     Sum/Avg|2136108|86.510.53.02.616.069.0
>     ```
>
>     由上述结果可知，字正确率为86.5%，字错误率为16%。



# 离线引擎容器

## 容器【147】

1. 加载镜像文件

```shell
docker load -i offline_base.tar
```

```shell
docker images | grep offline_base
```

```
offline_base v1.1 8bd3a0500d9f 8 months ago 3.1GB
```



```shell
docker run
-p 20100:20100
-itd
-v /data/thinkit/offline_e2e/tempvoice:/root/tempvoice
-v /data/thinkit/offline_e2e/tempvoice_xml:/root/tempvoice_Xml
-v /data/thinkit/offline_e2e/thinkit_offline_systeme/:/root/thinkit_offline_system
--privileged=true
--name offline_e2e
offline_base:v1.1
/usr/sbin/init
```



