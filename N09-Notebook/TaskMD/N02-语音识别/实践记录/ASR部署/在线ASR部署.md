# 容器准备

> 193:/wp/Ehe/ASR_TS/数字人
>
> - Rel_OnlineASR-e2e_v3.10.9_20210708_20220526_withlic_nanwang.tar.gz
> - Thinkit_Env_e2e_online_base.tar

**（1）文件解压**

```shell
tar -zxvf Rel_OnlineASR-e2e_v3.10.9_20210708_20220526_withlic_nanwang.tar.gz 
```

```
rel_onlineasr
```

**（2）加载镜像文件**

```shell
docker load -i Thinkit_Env_e2e_online_base.tar
docker images | grep offline_base
```

```
offline_base    v1.1   8bd3a0500d9f    16 months ago       3.1GB
```

**（3）开启容器**

```shell
docker run -itd --name online_e2e_sr --restart=unless-stopped -p 27529:20200  offline_base:v1.1
```

**（4）将解压的文件复制到容器内**

```shell
docker cp rel_onlineasr online_e2e_sr:/root/
```

**（5）进入容器**

```shell
docker exec -it online_e2e_sr bash
```



# 安装授权

**（1）安装jdk、redis、tomcat**

```shell
cd /root/rel_onlineaser/tools/tools_install
bash 01_install_jdk.sh
bash 02_install_redis.sh
bash 03_install_tomcat.sh
```

**（2）获取机器码**

```shell
cd /root/rel_onlineasr/tools/Lic
./getinfo
```

```
total 48
-rw-r--r-- 1 root root   256 Nov 17 08:20 65c32a947381_machine.info
-rwxr-xr-x 1 root root 43864 Feb  9  2022 getinfo
```

**（3）机器授权**

```shell
# 容器外
docker cp online_e2e_sr:/root/rel_onlineasr/tools/Lic/65c32a947381_machine.info .
./genlicense 20231231 5 120 65c32a947381_machine.info 
```

```
-rwxrwxrwx 1 root root 43736 Feb  8  2022 genlicense
-rw-r--r-- 1 root root   296 Nov 17 16:27 license120_5threads.dat
```

授权完成后，改名并放到/root/rel_onlineasr/Decoder/bin/目录下

方式一：

```shell
# 容器外
docker cp license120_5threads.dat online_e2e_sr:/root/rel_onlineasr/Decoder/bin/license_120.dat
```

方式二：

```shell
# 容器外
docker cp license120_5threads.dat online_e2e_sr:/root/rel_onlineasr/Decoder/bin/
# 容器内
mv license120_5threads.dat license_120.dat
```

**（4）修改授权的线程数**

```shell
vi /root/rel_onlineaser/Decoder/bin/decoder.sh
```

```shell
#!/bin/bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../model/lib/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../lib/
while true
do
    date >> ../log/restart.log
    echo "start decoder!!" >> ../log/restart.log
    ./decoder -s 5 -p 10200   # 5
done
```



# 启动服务

**（1）启动redis**

```shell
cd /root/local/redis/redis-3.2.0
sh cluster_install_ms.sh
```

```

```

**（2）测试解码器**

```shell
# 测试解码器服务，验证机器注册是否成功，验证成功后，kill掉脚本对应的程序（可能没有）
cd /root/rel_onlineasr/Decoder/bin
./decoder.sh
```

```

```

**（3）后台启动服务**

```shell
# 执行start.sh
./start.sh
```

**（4）启动Tomcat**

```shell
# 启动tomcat, 注意版本，有的是35版本
cd /root/local/tomcat/apache-tomcat-9.0.62/bin
sh startup.sh
```

```
Using CATALINA_BASE:   /root/local/tomcat/apache-tomcat-9.0.62
Using CATALINA_HOME:   /root/local/tomcat/apache-tomcat-9.0.62
Using CATALINA_TMPDIR: /root/local/tomcat/apache-tomcat-9.0.62/temp
Using JRE_HOME:        /root/local/jdk/jdk1.8.0_171
Using CLASSPATH:       /root/local/tomcat/apache-tomcat-9.0.62/bin/bootstrap.jar:/root/local/tomcat/apache-tomcat-9.0.62/bin/tomcat-juli.jar
Tomcat started.
```



# 测试程序

**（1）修改配置文件**

```shell
# 修改ip和端口
cd /root/rel_onlineasr/tools/SDK/Linux_Cpp/C++_demo
vi config.ini
```

```shell
# 服务ip  ++++++++++++++++++++++++
serverIp="172.16.128.193"
# 服务端口号  +++++++++++++++++++++++++
serverPort=27529

# 服务url
serverUrl="asrability/onlineasr"
# 语音是否去头,1:表示去语音头，0：表示不去语音头
IsOffHead=1
# 语音格式 0:8k16bit pcm，1:16k16bit pcm
sample=0
# 是否循环执行测试，0：不循环，1：循环
cycleRun=0
# 发送语音模式 1：在线模式，0：离线模式
model = 1
# 离线模式下发送数据包大小（M字节，范围为2-60）
bufferSize=2
# 输出结果形式是否用于统计识别率，0：否，1：是
recogRate = 0
# 热词列表，以英文逗号分隔 例如："确认,你好"
hotWordList=""
```

**（2）执行测试脚本**

```shell
./run.sh 
```

```
=========================================
Thinkit SDK Run: 12:54:27 Apr 29 2021
=========================================
strUrl=172.16.128.193:27529/asrability/onlineasr
threadNum=1
cur1 len is 40
text=确认。
phoneme=确 认。
segtime=0.29 0.45 0.53 0.62
score=99.953041
```



# 调用测试

**asr_online_ts为例：**

- short_ivr7.mlf：标注结果
- short_ivr_1_2.mlf：转写结果
- 1_2：原始语音文件
- result_1_2：转写结果数据



**（1）**get_asr_result.py：asr接口调用脚本，将1_2中的录音转写结果写入到result_1_2

```
/root/anaconda3/bin/python3 get_asr_result.py 
/root/anaconda3/bin/python3 get_asr_result_mul_threading.py
```

**（2）**txt2mlf.py：将转写结果result_1_2中的文件全部写入到short_ivr_1_2.mlf

```
/root/annconda3/bin/python3 txt2mlf.py
```

**（3）**HResults：计算准确率

```shell
./HResults -t -I /data/Ehe/ASR/asr_api_test/asr_online_ts/short_ivr7.mlf /dev/null /data/Ehe/ASR/asr_api_test/asr_online_ts/short_ivr_1_2.mlf
```

输出：

```
=============== HTK Results Analysis ===============
  Date: Fri Nov 18 14:01:30 2022
  Ref : short_ivr7.mlf
  Rec : short_ivr_1_2.mlf
------------------------ Overall Results --------------------------
SENT: %Correct=0.00 [H=0, S=1695, N=1695]
WORD: %Corr=83.58, Acc=46.86 [H=10968, D=173, S=1981, I=4819, N=13122]
===================================================================
```





# 注意事项

> **（1）**Tomcat启动不成功，重新启动
>
> **（2）**Tomcat版本不对，有的35，有的62，注意查看环境变量设置
>
> ```shell
> more ~/.bashrc
> more ~/.bash_profile
> ```
>
> 修改完成
>
> ```shell
> source ~/.bashrc 
> source ~/.bash_profile
> ```
