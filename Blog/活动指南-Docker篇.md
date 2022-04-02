# 镜像

## 获取镜像

```shell
# 查询镜像
docker search centos

# 拉取指定版本的镜像
docker pull centos:6.9

# 拉取最新的镜像版本：latest
docker pull centos
```



## 查询镜像

```shell
# 查询本机的所有镜像，并显示详细信息
docker images

# 查询本机的所有镜像，只显示镜像ID
docker images -q 

# 查看镜像的详细信息（对外端口、容器启动时执行的命令、环境变量、工作目录等等）
docker inspect ID/name:tag
```

## 删除镜像

```shell
# 删除指定镜像
docker rmi  IID 

# 删除所有镜像
docker rmi `docker images -q`

# 同上
docker rmi $(docker images -q)

# 强制删除镜像（一些相互依赖的镜像通过上面的命令无法删除）
docker rmi -f IID
```

## 导入导出镜像

```shell
# 导出本地镜像为tar文件
docker save nginx >/opt/nginx.tar.gz
docker save -o KnowledgeDemo.tar knowledgedemo:v1

# 从tar文件加载镜像
docker load -i /opt/nginx.tar.gz
```

## 基于Dockerfile制作镜像

**FROM命令**

```shell
FROM 镜像ID:标签

# 必须指定镜像和标签，作为基础镜像，此命令是必须的
FROM centos:latest
```

**RUN命令**

```shell
# RUN 执行shell命令，多条命令使用&&连接，也可以使用多行RUN，但是docker镜像是分层制作的
# 在dockerfile中每一条执行命令都创建一层，所以我们尽量创建少的层，把能够合并的命令放在一
# 层中
RUN cd /opt && mkdir code && yum install -y vim && yum install -y wget
```

以上命令就是切换到/opt目录，创建一个code子目录，安装vim和wget。

**CMD命令**：使用镜像启动容器时默认的运行命令，如果在docker run的时候，在后面带上自定义命令，那么这个命令就会被替换掉，导致容器启动的时候不会执行，所以一般我们不用这个。

```shell
CMD ["/usr/sbin/sshd", "-D"]
```

**ENTRYPOINT**：和上面的CMD命令相似，但是不会被启动容器时的自定义命令替换掉，一定会执行；还有一个用法是在docker run后面的自定义命令可以作为ENTRYPOINT的命令参数传入。

```shell
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
```

**COPY命令**：从主机拷贝文件到容器中。

```shell
COPY init.sh /opt/
```

**ADD命令**：和copy命令类似，拷贝文件到镜像中，但是对于压缩文件（含有tar的）拷贝过去会直接解压。

```shell
ADD xxx.tar.gz /var/www/html
```

**EXPOSE命令**：指定容器要对外暴露的端口。

```shell
EXPOSE 80
EXPOSE 3306
```

**VOLUME命令**：在dockerfile中声明了VOLUME绑定目录并不会在容器启动的时候帮我们自动绑定目录，那么VOLUME和-v有什么区别呢？假设我们在dockerfile中声明了。

```shell
VOLUME ['/data', '/etc/proc']
```

那么我们使用不同的命令启动时。

```shell
# 如果在run容器的时候，没有指定-v，那么此时会创建一个匿名卷，并且绑定到/var/lib/docker/volumes（docker安装目录下的volumes中）
docker run -d --name='cent1' my_centos

# 如果在run的时候，指定了-v，那么就会覆盖匿名卷
docker run -d -v ./data:/data -v ./proc:/etc/proc --name='cent1' my_centos
```

所以如果一个镜像制作的时候使用了VOLUME，那么每次启动都会在宿主机上创建一个数据目录，如果这个目录里存在的东西很多，那么时间长了，我们就会发现宿主机上空间越来越小，即使你重启容器也不行。所以要了解这个性质，针对性的清理docker目录。

**WORKDIR**：相当于cd命令，区别是在dockerfile中使用了WORKDIR后，在它下面的语句，工作目录都变成了WORKDIR指定的目录。

```shell
 WORKDIR /code
```

**ENV**：在dockerfile中设置环境变量，主要为了在执行docker run的时候可以通过-e参数修改环境变量，这样也可以使镜像更加通用。例如MySQL安装时要指定用户名、密码、绑定IP，如果直接在容器里面安装，那么我们如果要修改的话，必须登录到容器中，进行修改重启。但是在dockerfile中指定了ENV变量，那么在docker run的时候就可以修改这些设置。

```shell
ENV MYSQL_USERNAME = 'root'

# 使用时用以下方式获取
${MYSQL_USERNAME}
```



`dockerfile例子1：`

```shell
FROM centos:latest

# 替换yum源
COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
# 配置pip文件
COPY pip.conf ~/.pip/
RUN yum clean all && yum makecache && yum update -y && yum install -y vim && yum install -y wget
RUN yum install -y python38 && yum install -y python38-setuptools && yum install -y python38-pip && # 配置pip文件

# 切换到目录/ftp
WORKDIR /ftp

# 将init.sh文件拷贝到镜像的/ftp目录下
COPY init.sh .

# 执行启动命令
ENTRYPOINT ["/bin/bash", "init.sh"]
```

在当前目录下创建dockerfile文件，并使用docker build命令制作镜像

```shell
# -t 后面是新的镜像标签， .表示使用当前目录下的dockerfile文件
docker build -t my_https://gitee.com/liuhuihe/Ehe/raw/master/images/centos:latest .
```



`dockerfile例子2：`

```dockerfile
FROM centos:7
MAINTAINER asr
ENV MYPATH /home/ASR/Docker
WORKDIR $MYPATH
ADD jdk-8u171-linux-x64.tar.gz /home/ASR/Docker
ADD apache-tomcat-9.0.35.20210702.tar.gz /home/ASR/Docker
ADD redis-3.2.0.tar.gz /home
ENV JAVA_HOME /home/jdk1.8.0_171
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV CATALINA_HOME /home/apache-tomcat-9.0.35
ENV CATALINA_BASE /home/apache-tomcat-9.0.35
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin
```

在/home/ASR/Docker 目录下创建dockerfile文件，并使用docker build命令制作镜像

```shell
docker build -t online_base:v1.0 .
```



## 基于容器制作镜像

```shell
# 查询正在运行的容器
docker ps

# 将容器制作为镜像（如果要提交到私有镜像库，新镜像名称必须携带私有库的域名，例如：xxx.com
docker commit 容器ID xxx.com/my_container:v1

# 将容器提交到私有镜像库
docker push xxx.com/my_container:v1

# 修改镜像名称（想要将公共镜像推送到私有镜像库，必须修改其名称，前面加上私有库的域名）
docker tag old_container_name xxx.com/new_container_name:latest
docker tag b03b74b01d97 redis:v1.0
```

**优点**：制作方便，只要进入容器，安装好环境，就可以制作一个新的镜像，并部署到其他环境。

**缺点**：容器内新增的服务必须在启动后，再进入容器启动一次服务，但是可以通过启动时执行指定命令来解决这个问题。

## 搭建私有镜像库

在很多企业中，都不能肆意的访问外网，那这样是不是docker就没法愉快的使用了呢？我们通常下载镜像都是从docker hub官方仓库下载的，如果在企业内部搭建一个私有镜像库，那是不是就能像外网一样使用docker了呢，docker官方为我们提供了非常简单的搭建私有库的方式：

```shell
docker run -d -p 5000:5000 --restart=always --name docker_registry -v /opt/registry:/var/lib/registry registry
# --restart=always docker服务启动时，容器就启动
# -v 将镜像存储地址映射到宿主机，防止丢失
```

好了，通过以上命令我们的私有镜像库就搭建好了，是不是很简单呢？那么怎么使用呢？

- 修改配置文件

```shell
vim /etc/docker/daemon.json

{
"insecure-registries": ["xx.xx.xx.xx:5000"]
}
```

- 重启docker服务

```shell
systemctl restart docker
```

- 推送本地镜像到私有镜像库

修改镜像名称，添加私有镜像库地址为前缀，然后push到镜像库

```shell
docker tag nginx:latest xx.xx.xx.xx:5000/nginx:latest
docker push xx.xx.xx.xx:5000/nginx:latest
```

- 在其他机器上pull

```shell
docker pull xx.xx.xx.xx:5000/nginx:latest
```



##

# 容器

## 启动容器

```shell
# 启动交互式容器（/bin/sh、/bin/bash、bash），执行exit后容器就退出了，可以使用ctrl+p+q
docker run -it --name="n1" 3fe2fe0dab2e /bin/bash
docker run -itd --name centos7-fs centos:centos7
docker run -p 9000:9000 --name inforextraction -dt ba3145eb99fe bash

# 启动守护式容器
docker run -d -p 8080:80 --name="n1" nginx

# 启动容器，并执行一个命令(执行的命令必须是前台持续性的，不能是执行完就结束的命令，否则容器就会退出）
docker run -d -p 8080:80 --name="n1" nginx cd /usr1;python manager.py runserver 0.0.0.0:8080

# 停止正在运行容器
docker stop 容器ID/名称

# 启动已经停止的容器
docker start 容器ID/名称

# 重启容器，不会使容器中已有的修改失效
docker restart 容器ID/名称
```

## 进入容器

```shell
# 进入容器的已有交互界面，退出时应该使用ctrl+p+q，否则容器会关闭
docker attach 容器ID

# 进入当前运行容器，并创建一个新的交互式界面，退出时不会关闭容器（推荐做法）
docker exec -it 容器ID|容器名称 /bin/bash

# 不进入容器执行命令（查看根目录列表，并显示在控制台）
docker exec 容器ID ls /
  
# 不进入容器，向容器中安装vim，并后台安装，不在前台展示
docker exec -d 容器ID apt-get install vim
```

## 查询容器

```shell
# 查询当前正在运行的容器
docker ps

# 查询所有存在的容器，包括已退出的
docker ps -a

# 查询容器ID
docker ps -q

# 查询容器详细信息（端口映射、IP地址、磁盘绑定等信息）
docker inspect 容器ID/名称 
```

## 删除容器

```shell
# 删除已退出的容器
docker rm 容器ID/名称

# 强制删除容器，包括正在运行的
docker rm -f 容器ID/名称
```

## 容器网络

```shell
# 指定映射(docker 会自动添加一条iptables规则来实现端口映射)
    -p hostPort:containerPort
    -p ip:hostPort:containerPort 
    -p ip::containerPort(随机端口)
    -p hostPort:containerPort/udp
    -p 81:80 –p 443:443

# 随机映射
    docker run -p 80（随机端口）
```

## 容器更新

```shell
# 以mysql的容器为例，容器名是mysql7，那命令就是
docker update --restart=always   mysql7
```

## 容器其他操作

```shell
# 查看容器中正在运行的进程
docker top 容器ID/名称

# 拷贝文件或目录
docker cp 宿主机目录/文件 容器ID:/usr1/test
docker cp 容器ID:/usr1/test 宿主机目录/文件
docker cp json2/ e2e-finetune-env:/data/Ehe/json2/

# 查询容器正在运行的日志
docker logs 容器ID/名称

# 实时显示容器中运行日志
docker logs -f 容器ID/名称

# 将容器实时日志输出到文件，可以配合ELK进行日志收集
docker logs -f  testxx > /var/log/xxx.log 2>1&

# 查看容器状态
docker stats e2e-finetune-env
```

## 容器持久化存储

```shell
# 挂载数据卷  -v 宿主机目录或文件:容器中目录或文件
docker run -d -v ./test:/test --name='n1' nginx
```

## 数据卷容器

```shell
# 启动一个容器作为数据卷
docker run -it --name "my_volumes" -v /opt/Volume/conf:/usr/local/nginx/conf nginx /bin/bash

# 跳出容器
ctrl p q

# 使用上面的数据卷容器作为新容器的数据卷，相当于新容器挂载了/opt/Volume/conf目录
docker run -d  -p 8085:80 --volumes-from  my_volumes --name "n85" nginx
docker run -d  -p 8086:80 --volumes-from  my_volumes --name "n86" nginx
```



# 实战

## 搭建jupyterlab开发环境

1. docker安装anaconda

```shell
docker pull continuumio/anaconda3
```

2. 启动anaconda容器

```shell
docker run -d -p 8888:8888 
-v /home/notebooks/:/opt/notebooks 
--restart=always continuumio/anaconda3 /bin/bash 
-c "/opt/conda/bin/conda install jupyter -y 
--quiet && /opt/conda/bin/jupyter notebook 
--notebook-dir=/opt/notebooks --ip='*' 
--port=8888 
--no-browser 
--allow-root 
--NotebookApp.token='123456789'"
```

-v /home/notebooks：本地目录，jupyter创建的所有文件都会在此目录下

3. 连接jupyterlab

http://127.0.0.1:8888/lab

Token：123456789

4. 安装第三方库

```shell
conda install packagename
```



## Docker实战案例

```shell
# 下拉代码
cd Code/
git clone git@172:/home/git/src/nlp/diaodu/KnowledgeDemo

# 使用已有镜像生成新的容器：KnowledgeDemo
docker images
docker run -p 2530:9001 --name KnowledgeDemo -dt f255141a932f bash

# 进入开启容器，复制代码到容器里面
docker exec -ti KnowledgeDemo bash
docker cp KnowledgeDemo KnowledgeDemo:/home/nlp

# 进去容器，运行脚本
docker exec -ti KnowledgeDemo bash
cd /home/nlp
sh reload.sh

# 查看进程
docker images
docker ps | grep KnowledgeDemo

# 提交代码，指定版本
docker commit -a "liu" -m "KnowledgeDemo" KnowledgeDemo knowledgedemo:v1

# 保存为.tar文件
cd /home/dockersave/
mkdir KnowledgeDemo
cd KnowledgeDemo/
docker save -o KnowledgeDemo.tar knowledgedemo:v1
```

