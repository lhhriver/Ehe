# 数据预处理

TODO


# 在线ASR训练工具

## 准备工作

### 基本信息【133】

> **源码位置**：/wp/aster/zhongke/南网第二阶段文档、源码交付物/二阶段代码-南网202111-jiami/端到端语音识别训练工具/在线/eteh-v2-release-JXJK2021_orig_online_v2_release

### 数据来源【226】

> **json数据**：
>
> /home/blue/ssd/thinkit/fred/data_product/online_AM_dataproduct_nanwang_1000_20211015/json
>
> **特征数据**：
>
> /home/blue/ssd/thinkit/fred/data_product/online_AM_dataproduct_nanwang_1000_20211015/json

### 训练容器【147】

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

5. 源码容器内路径

```
/home/Ehe/WorkSpace/eteh-v2-release-JXJK2021_orig_online_v2_release
```



### 配置修改

#### 数据配置

1. 文件：example/hkust_egs/conf/data.yaml
1. 数据位置：/data/Ehe/online/json

```yaml
clean_source:
1:
type:json
name:kefu_cts
json:/data/Ehe/online/json/data.1.json

2:
type:json
name:kefu_cts
json:/data/Ehe/online/json/data.2.json

3:
type:json
name:kefu_cts
json:/data/Ehe/online/json/data.3.json

valid_source:
1:
type:json
name:dev
json:/data/Ehe/online/json/data.4.json
```

**备注**：将json数据放到/data/Ehe/online/json目录下，可以自定义，特征数据路面必须跟json里面路径一致

2. 特征数据容器位置

```
/home/blue/ssd/thinkit/fred/data_product/online_AM_dataproduct_nanwang_1000_20211015/json
```



#### GPU配置

1. 查看GPU信息

```shell
nvidia-smi
```

2. 文件：example/hkust_egs/path.sh

```shell
MAIN_ROOT=/data/xiaosujie/AM/e2e_finetune/online-jianhang/src_code/eteh-v2-release-JXJK2021_orig_online_v2_release
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

```sh
../path.sh

epochs=70
init_method='tcp://127.0.0.1:8888'
exp_dir=output/exp
train_config=conf/ce_espnet_online_transformer_nospecaug_md.yaml
data_conf=conf/data.yaml
checkpoint=baseModel/checkpoint.59
mkdir-p${exp_dir}

python ${PLAT_ROOT}/bin/train.py -train_config ${train_config} \
-data_config ${data_conf}\
-train_name HKUST\
-task_file bin.taskegs.py torch_backend.task_ctc_att_online \
-num_gpu 2\
-task_name CtcAttOnlineTask \
-exp_dir ${exp_dir} \
-num_epochs ${epochs} \
-seed 100 \
-checkpoint $checkpoint \
--resume_progress \
--split

:<<eof
python ${PLAT_ROOT}/bin/train.py -train_config ${train_config} \
-data_config ${data_conf} \
-train_name HKUST \
-task_file bin.taskegs.pytorch_backend.task_ctc_att \
-num_gpu 1 \
-task_name CtcAttTask \
-exp_dir ${exp_dir} \
-num_epochs ${epochs} \
-seed 100 \
-checkpoint $checkpoint \
--resume_optimizer \
--resume_progress \
--split

eof
```

## 模型预测

TODO

## 模型评估

1. 输出位置修改:example/hkust_egs/run_evaluate.sh

```shell
../path.sh

init_method='tcp://127.0.0.1:8888'

rec=/home/Ehe/WorkSpace/eteh-v2-release-JXJK2021_orig_online_v2_release/example/hkust_egs/output/exp/predictor/result_kefu_cts.txt
ref=/home/Ehe/WorkSpace/eteh-v2-release-JXJK2021_orig_online_v2_release/example/hkust_egs/output/exp/predictor/ref_kefu_cts.txt

Python ${PLAT_ROOT}/bin/evaluate.py -rec ${rec} -ref ${ref}
```



# 在线引擎容器

## 容器【147】

1. 加载镜像文件

```shell
docker load -i online_docker.tar
```

```shell
docker images | grep online
online v1.1 266f66bf8d3d 10 months ago 554MB
```

```shell
docker run -p 20200:20200 -itd -v /data/thinkit/online_e2e/:/root --name online_e2e online:v1.1 /bin/bash
```

## 在线引擎容器构建

**100服务器：**

1. 100构建基础镜像

```shell
mv dockerfile jdk-8u171-linux-x64.tar.gz redis-3.2.0.tar.gz apache-tomcat-9.0.35.20210702.tar.gz /home/ASR/Docker/
```

2. 构建镜像

```shell
docker build -t online_base:v1.0 .
cd dockersave /

docker save -o online_asr.tar online_base:v1.0
rm online_asr.tar
```

3. 添加了基本命令

```shell
docker commit -a "Ehe" -m "online_base_test" online_base_ehe online_base_ehe:v1
```

4. 镜像文件：100/home/dockersave

```shell
docker save -o online_base_ehe.tar online_base_ehe:v1
docker exec -it 7701484e03ce /bin/bash
```



# 在线代码编译及服务集成

> **源码位置：**133:/wp/aster/zhongke/三阶段代码和文档补充平台层0323/应用平台封装/在线/在线识别


## 引擎封装tbnr

### 解码器内核

1. **源码位置**：100：/home/ASR/引擎封装tbnr/解码器内核

2. **输出目录**：100：/home/ASR/引擎封装tbnr/解码器内核/bin

	将编译好的静态库文件librecengine.a、libsrilm.a、libtools.a、libtshare.a和libwfstdecoder.a链接至引擎封装工程TBNR中统一进行测试

3. **应用**：在线\引擎封装tbnr\在线语音识别引擎-总模块\TBNR_API\release_lib_wfst_dnn\

	```shell
	cd /home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎-总模块/TBNR_API/release_lib_wfst_dnn
	cp /home/ASR/引擎封装tbnr/解码器内核/bin/lib* .
	```

### ITN模块

1. **源码位置**：100：/home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎子模块-ITN模块/

2. **输出目录**：

	```
	/home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎子模块-ITN模块/ITN/lib/libthraxrewrite.so
	/home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎子模块-ITN模块/ITN/lib/thraxrewrite-tester-rec
	/home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎子模块-ITN模块/ITN/compile/compileFar/example.far
	```

3. 应用：
	libthraxrewrite.so放到 /home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎-总模块/TBNR_API/ITN/

	```shell
	cd /home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎子模块-ITN模块/ITN/lib/
	cp libthraxrewrite.so /home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎-总模块/TBNR_API/ITN/
	```

	example.far这个文件替换到Decoder/bin目录下

	```shell
	cd /home/ASR/Decoder/bin
	cp /home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎子模块-ITN模块/ITN/lib/example.far .
	```

	

### 标点模块

1. **源码位置**：100：/home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎子模块-标点模块

2. **输出目录**：/home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎子模块-标点模块/Punc/LIB_LINUX

3. **应用**：标点文件目录Decoder/model/punctuation

	```shell
	cd /home/ASR/Decoder/model/punctuation
	cp /home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎子模块-标点模块/Punc/LIB_LINUX/* .
	```

	

### 总模块

1. **源码位置**：100：/home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎-总模块/
	进入TBNR_API目录，执行**make -f Makefile_TBNR_new_epd**，待编译完成后，得到libTBNR_API.so引擎库

2. **输出目录**：/home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎-总模块/TBNR_API/libTBNR_API.so

3. **应用**：libTBNR_API.so在Decoder/model/lib下

	```shell
	cd /home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎-总模块/TBNR_API
	cp libTBNR_API.so /home/ASR/Decoder/model/lib/
	```

	

### 测试用例

**源码位置**：100：/home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎-测试用例/

进入TBNR_API_TBNRTestDemo/TBNR_Test_demo/TBNR_Test_Stream 目录，执行buildTest.sh 编译脚本得到测试用例可执行文件TBNR_Test_Stream

```shell
cd /home/ASR/引擎封装tbnr/引擎封装tbnr/在线语音识别引擎-测试用例/TBNR_API_TBNRTestDemo/TBNR_Test_demo/TBNR_Test_Stream
```

### 运行环境

> **源码位置：**100：/home/ASR/引擎封装tbnr/引擎封装tbnr/

## 工程源码编译及服务集成

> **源码位置**：100/home/ASR/应用平台封装/在线/在线识别/在线识别系统源码/在线识别系统decoder接口
>
> **安装包位置**：
>
> 100/home/ASR/Rel_OnlineASR-e2e_v3.10.9_20210708_20210916_nolic_nanwang.tar.gz
>
> **语音识别引擎sdk包**：133/wp/aster/zhongke/三阶段代码和文档202203/三阶段代码和文档/语音识别引擎(端到端）/在线/引擎封装tbnr/在线语音识别引擎-运行环境
>
> **编译：**
>
> ```shell
> cp -r /home/ASR/应用平台封装/在线/在线识别/在线识别系统源码/在线识别系统decoder接口 /home/ASR/decoder/
> ```
>
> 根据文档《在线代码编译及服务集成》进行编译，编译完成后，可以打包部署到其它服务器上
>
> **部署包路径**：100/home/ASR/Decoder

## MRCP

> **源码位置**：100/home/ASR/应用平台封装/在线/在线识别/在线识别系统源码
>
> **安装包位置**：100/home/ASR/Release_MRCP-v2.7.1_20210820_20210916_nolic_nanwang.tar.gz

**编译：**

```shell
cp -r /home/ASR/应用平台封装/在线/在线识别/在线识别系统源码/在线识别系统mrcp接口 /home/ASR/mrcp/
mv 在线识别系统mrcp接口 unimrcpserver
```

根据文档《在线代码编译及服务集成》进行编译，编译完成后，可以打包部署到其它服务器上，部署包路径：100:/root/local/unimrcp



## http源码编译

**源码位置**：/home/ASR/应用平台封装/在线/在线识别/在线识别系统源码/在线识别系统http能力接口

Pom.xml 添加几行代码：


```xml
 <resource>
      <directory>src/main/resources</directory>
      	<includes>
       		<include>**/*.*</include>
      	</includes>
</resource>
```

只需要将编译后的war包替换到apache-tomcat-9.0.35/webapp目录下即可



## WebSocket源码编译

> **源码位置**：/home/ASR/应用平台封装/在线/在线识别/在线识别系统源码/在线识别系统websocket能力接口
>
> **配置文件**：/root/local/WebSocket/config/application.yml
>
> **服务启停**：
>
> 1. startup.sh
>
> 2. 先kill掉websocketMonitor.sh 然后再执行stop.sh脚本
>
> **验证路径**：/home/asr/online/rel_onlineasr/tools/SDK/JAVA/WebSocketDemo/websocketASR_demo
>
> **配置文件**：
>
> ```
> /home/asr/online/rel_onlineasr/tools/SDK/JAVA/WebSocketDemo/websocketASR_demo/config/application.properties
> ```
>
> **服务启停**：start.sh、stop.sh



# 在线语音识别系统安装

## 容器准备

**144服务器：加载容器**

1. 将online_base_ehe.tar拷贝到144：/data/Ehe/dockersave

```shell
docker load -i online_base_ehe.tar
```

2.  运行容器

```shell
docker run -p 20051:20051 -i -t -d -v /home/data/ASR:/home/data/ASR --name online_base_ehe online_base:v1.0 /bin/bash

docker run -p 20051:20051 -i -t -d -v /data/Ehe/ASR:/data/Ehe/ASR --name online_base_ts online_base_ehe:v1 /bin/bash

# 测试完成后
docker commit -a "" -m "" online_base_ts online_base_ehe:v1.2
docker save -o online_base_ts_v1.2.tar online_base_ehe:v1.2
```

3. 查看镜像

```shell
docker images | grep online_base_ehe
```

```
online_base_ehe      v1.2        6051e3c24aa8        3 months ago        33.7GB
online_base_ehe      v1          7907bf1185fb        6 months ago        8.18GB
```



---

**容器内安装**

进入容器online_base_ts：

```shell
docker exec -it 7701484e03ce /bin/bash
docker exec -it 9562ea64a668 /bin/bash
```

**容器目录**：/home/asr/online/rel_onlineasr

**安装文档**：在线语音识别系统安装手册.docx

进入/home/asr/online/rel_onlineasr/tools/tools_install目录，执行脚本install_All.sh，解压tomcat、redis、jdk、nginx到~/local目录下




## jdk安装

TODO

## nginx安装

**配置文件**：/root/local/nginx/nginx/server_conf_asr.txt

**配置参数**：server=127.0.0.1:20200 weight=2

**启动命令**：cd /root/local/nginx/nginx    ./sbin



## redis单机安装

**配置文件**：/root/local/redis/redis-3.2.0/redis.conf

**配置参数**：bind 127.0.0.1   port 30010

**启动命令**：

```shell
cd /root/local/redis/redis-3.2.0
nohup ./redis-server redis.conf > /dev/null 2>&1 &
```

**验证命令**：

```shell
ps -ef | grep redis
./redis-server redis.conf &
./redis-cli -h 127.0.0.1 -p 30010
monitor
```

## Tomcat安装

**配置文件1**：/root/local/tomcat/apache-tomcat-9.0.35/webapps/asrability/WEB-INF/classes/redis.properties

**配置参数**：

- ASR_REDISSERVER=127.0.0.1

- ASR_REDISPORT=30010

- ASR_REDIS_SINGLE = 127.0.0.1:30010 # 对应redis

- ASR_REDISSETLIST=ASR_SERVICEREQ:test01 # Decoder用到

- ~~ASR_REDISADD= \*\*\*\*\* # 对应redis集群~~

- ASR_INCLUDEPASSWORD=false # 是否有密码，集群有密码，单机模型没有密码

- ASR_REDISPASSWORD=foobared

- ASR_CLUSTER=false#是否启用集群

- Ps:集群模式不一样

	

**配置文件2**：/root/local/tomcat/apache-tomcat-9.0.35/conf/server.xml

**配置参数**：<Connector port="20051" protocol="org.apache.coyote.http11.Http11NioProtocol" # 对外映射端口

**启动命令**：

- cd /root/local/tomcat/apache-tomcat-9.0.35/bin
- sh shutdown.sh
- sh startup.sh

**验证命令**：ps -ef | grep tomcat



## **Decoder**安装

将过程源码编译的Decoder文件夹拷贝到/home/asr/online/rel_onlineasr/

```shell
cp -R /data/Ehe/ASR/Decoder /home/asr/online/rel_onlineasr/
```

进入目录Decoder/bin修改启动线程数可编辑脚本decoder.sh

```shell
./decoder -s 10 -p 20051
```

**配置文件**：/home/asr/online/rel_onlineasr/Decoder/conf/decoder.conf，修改是否保存语音文件和识别结果

```shell
#是否保存语音，范围0－3，0代表不保存语音；1代表只保存接收到的pcm语音，2代表只保存转换后的pcm16语音；3代表同时保存pcm语音和pcm16语音。
SaveVoice=3
VoiceDir=../voice
#设置redis集群是否设置密码，1：设置，0：不设置
RedisPasswdOn=0
RedisCluster=127.0.0.1:30010

Ps:集群模式不一样，单机默认没有密码，集群要密码
#是否保存语音识别结果，0不保存，非0保存
SaveRegResult=1
RegResultPath=../txtFile
RedisKey=ASR_SERVICEREQ:test01
```



---

**添加环境变量**

```shell
vi /root/.bashrc
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/asr/online/rel_onlineasr/Decoder/model/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/asr/online/rel_onlineasr/Decoder/lib
source/root/.bashrc
```

**授权执行**：chmod -R +x Decoder

**启动命令**：

- cd /home/asr/online/rel_onlineasr/Decoder/bin
- ./shutdown.sh
- ./start.sh

**服务验证**：ps -ef | grep decoder

```
root     38274 38271 21 20:31 pts/15   00:00:03 ./decoder -s 10 -p 10200
```



---

**其它配置**：/home/asr/online/rel_onlineasr/Decoder/model/scripts/WFSTDecoder_onlyrec.cfg

```shell
# 标点
PrintPunctuation=true
# 数字
isDoITN=false
```



## 启动服务

**启动nginx**：

```
cd /root/local/nginx/nginx
./sbin
```

**启动redis**：

```
cd /root/local/redis/redis-3.2.0
nohup ./redis-server redis.conf > /dev/null 2>&1 &
```

**启动Tomcat**：

```
cd /root/local/tomcat/apache-tomcat-9.0.35/bin
sh startup.sh
```

**启动Decoder**：

```
cd /home/asr/online/rel_onlineasr/Decoder/bin
sh start.sh
```



# ASR准确率验证

**进入容器**：

```shell
docker exec -it 9562ea64a668 bash
docker exec -it online_base_ts bash
```



**147服务器：**

- 外包编译：/data/Ehe/ASR/asr_api_test/asr_online_ts
- 中科编译：/data/Ehe/ASR/asr_api_test/asr_online_ts_zk



**asr_online_ts为例：**

- short_ivr7.mlf：标注结果

- short_ivr_1_2.mlf：转写结果

- 1_2：原始语音文件

- result_1_2：转写结果数据

- get_asr_result.py：asr接口调用脚本，将1_2中的录音转写结果写入到result_1_2

- txt2mlf.py：将转写结果result_1_2中的文件全部写入到short_ivr_1_2.mlf

- HResults：计算准确率

    ```shell
    ./HResults -t -I /data/Ehe/ASR/asr_api_test/asr_online_ts/short_ivr7.mlf /dev/null /data/Ehe/ASR/asr_api_test/asr_online_ts/short_ivr_1_2.mlf
    ```

    

```shell
/data/Ehe/ananconda3/bin/python3 get_asr_result.py 
```



# 集群部署

## 准备工作

```shell
# 容器内部映射端口 20200是http服务 8066是websocket服务
docker run -itd --name online_e2e --restart=unless-stopped -p 27528:20200 -p 27530:8066 -v /wp/aster/ws/online_asr_e2e/rel_onlineasr:/root/rel_onlineaser offline_base:v1.1

# 文件
133：/wp/dockersave/asr_model/asr_model/model/shenzhen_asr/online
scp Rel_OnlineASR-e2e_v3.10.9_20210708_20220526_withlic_nanwang.tar.gz root@172.16.128.147:/data/Ehe/cluder_online_asr/
```




## 部署计划

  - 133 服务器（主机）：

	  - online\_e2e\_redis
	  - online\_e2e\_bc：apache-tomcat-9.0.62、rel\_onlineaser


  - 147 服务器
	  - online\_e2e\_bc：apache-tomcat-9.0.62、rel\_onlineaser


  - 191 服务器
	  - online\_e2e\_bc：apache-tomcat-9.0.62、rel\_onlineaser


## 容器

**193**：

```shell
docker run -itd --name online_e2e_bc --restart=unless-stopped -p 27528:20200 -v /wp/Ehe/cluder_online_asr/rel_onlineasr:/root/rel_onlineaser offline_base:v1.1
```



## Redis

**注意**：

1. redis.conf端口要改成0.0.0.0

**命令**：

1. 单节点测试：./redis-server cluster/7000.conf

## Tomcat

## Decoder

