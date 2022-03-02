# 文件管理

## awk

```shell
ps -ef | grep 'main' | awk '{print $2}'
```


## cat

显示文件内容

```shell
cat /etc/issue
cat /proc/meminfo
```


>chattr

## chgrp

修改文件或目录的所属组

```shell
chgrp adm file1 # 改变文件file1的所属组为adm
```

## chmod	
修改权限

```shell
chmod 764 /etc/services
chmod g+w file1  # 赋予文件file1所属组写权限   <ugo+rwx>
```

```shell
path=/opt/package/orochiplus-upgrade/buffalo/dt-buffalo-serv-server/target/logs/app
for line in `ls /opt/package/orochiplus-upgrade/buffalo/dt-buffalo-serv-server/target/logs/app`
do
 chmod -R +x $path/$line
 echo $path/$line
 find $path/$line/ -mtime +30 | xargs rm -rf
done
```

## chown	
修改文件或目录的所有者

```shell
chown liuhh /etc/services
```

>cksum

>cmp

## cp

复制文件或目录	

```shell
cp file1 file2 dir1 # 将文件file1、file2复制到目录dir1
cp -R dir1 dir2 # 将dir1下的所有文件及子目录复制到dir2
cp -rf Label_lvshou_fill_vertify /home/liuhuihe/workspace/code_run/  # 将一个文件夹复制到另一个文件夹下
cp -rf /home/lhh/workspace/customer_risk_pro/*  /home/lhh/workspace/code_run/customer_risk_pro/
cp -rf /usr/local/KingSTD_1/*  /usr/local/webapps/KingSTD_2/    #将dir1下的所有文件及子目录复制到dir2,覆盖
```

>cut

>diff

>diffstat

>file

## find	
查找文件或目录

```shell
find /etc -name init #在目录/etc中查找文件init
find / -size +204800 # 在根目录下查找大于200MB的文件
find / -user sam # 在根目录下查找所有者为sam的文件
find /etc -ctime -1  # 在/etc下查找24小时内被修改过属性的文件和目录
```

```shell
#!/bin/bash
log_path=(/home/dmp/logs
		  /opt/package/orochiplus/web/logs 
		  /var/log/ambari-agent 
		  /var/log/hadoop/hdfs 
		  /var/log/hadoop-yarn/yarn 
		  /var/log/ambari-server 
		  /var/log/hive 
		  /var/log/ambari-metrics-collector)
for path in ${log_path[@]}
do 
  chmod -R +x $path/
  find $path -mtime +30 -regextype posix-extended -regex ".*\.(log|out|err)" | xargs rm
done
echo "clean ok..."
```

>git

>gitview

## head
查看文件的前N行

```shell
head -100 /etc/services
```

>indent

>less

## ln	
创建链接文件,目录只能创建软链接

```shell
ln -s  /etc/issue  /issue.soft # 创建文件 /etc/issue  的软链接  /issue.soft
ln /etc/issue  /issue.hard #创建文件 /etc/issue  的硬链接  /issue.hard

ln -s /root/anaconda3/bin/pip /usr/bin/pip3
ln -s /root/anaconda3/bin/python /usr/bin/python3   # 将python3设置为默认
```

## locate	
查找文件或目录

```shell
locate ls  # 列出所有跟file相关的文件
```

>lsattr

>mattrib

>mc

>mcopy

>mdel

>mdir

>mktemp

>mmove

## more

分页显示文件内容

```shell
more /etc/services
```

>mread

>mren

>mshowfat

>mtools

>mtoolstest

## mv

移动文件、更名	

```shell
mv file1 file3 # 将当前目录下文件file1更名为file3
mv file1 file2 file3 dir2  # 将文件file1、 file2 file3移动到目录dir2下
```

>od

>paste

>patch

>rcp

>read

>rhmask


## rm

删除文件或目录	

```shell
rm he  # 删除文件he
rm -r river # 删除目录river
```

## scp

```shell
# 从106复制文件到92.8

# 92.8上面
scp root@172.16.92.106:/home/Anaconda3-5.0.1-Linux-x86_64.sh /home

# 106上面
scp /home/Anaconda3-5.0.1-Linux-x86_64.sh root@172.16.92.8:/home
```



>slocate

>split

## tail	
查看文件的后N行

```shell
tail -100 /etc/services
tail -f ./logs/catalina.out
```

>tee

>tmpwatch

## touch

创建空文件

```shell
touch student # 创建空文件student
touch  /river/student   # 创建空文件student
```

>umask

>updatedb



## whereis

用于查找文件

```shell
whereis python3 |xargs rm -frv           # 删除所有python3残余文件
```



## which	
显示系统命令所在目录

```shell
which hive
```

# 文档编辑

>col

>colrm

>comm

>csplit

>ed

>egrep

>ex

>expr

>fgrep

>fmt

>fold

## grep	
在文件中搜寻字串匹配的行并输出

```shell
grep ftp /etc/services
```

```shell
ls | grep staff
ps -ef | grep brm_distribution_function
```

```shell
#!/bin/sh

task=$1

source /home/digger/.bashrc
set -ex

dt=`date +%Y-%m-%d_%H-%M-%S`

echo "kill zombie task"
ps avx | grep $task | grep -v grep | awk '{print $1}' | xargs -I {} kill {}

echo "run today task"
python main.py $task > logs/$task.$dt.log
```

>ispell

>jed

>joe

>join

>let

>look

>mtype

>pico

>rgrep

>sed

>sort

>spell

>tr

>uniq

>wc



# 文件传输

>bye

>ftp

>ftpcount

>ftpshut

>ftpwho

>lpd

>lpq

>lpr

>lprm

>ncftp

>tftp

>uucico

>uucp

>uupick

>uuto

# 磁盘管理

## cd
切换目录

```shell
cd /   # 切换到根目录
cd ..   # 回到上一级目录
cd ./home # 当前目录下的home目录
cd ~   # 切换到HOME目录
cd -   # 切换到前一目录
```

```shell
#!/bin/bash
source /etc/profile

cd /home/dmp/script/py/AddressTranform /usr/bin/python3 main.py
```

## df
显示文件系统的磁盘使用情况，默认情况下df -k 将以字节为单位输出磁盘的使用量
```shell
df -k
df -h  #使用-h选项可以以更符合阅读习惯的方式显示磁盘使用量
```

>dirs

## du

du命令用于显示目录或文件的大小。du会显示指定的目录或文件所占用的磁盘空间。

```shell
du -h --max-depth=1 /home
```



>edquota

>eject

>lndir

## ls
显示目录文件

```shell
ls -a # 显示所有文件，包括隐藏文件
ls -l # 详细信息显示
ls -al # 所有文件详细信息
```

```shell
JAR_NAME=`ls | grep jar-with-dependencies`
```


>mcd

>mdeltree

>mdu

## mkdir

创建新目录
参数：-p 确保目录名称存在，如果目录不存在的就新创建一个。

```shell
mkdir river 创建目录river
```

```shell
directory=/home/dmp/lixiaoli/yjk_dm
loaddate=`date -d "-1 day" "+%Y-%m-%d"`
mkdir -p ${directory}/log/${loaddate}/
```

>mlabel

>mmd

>mmount

>mount

>mrd

>mzip

## pwd

当前工作目录


>quota

>quotacheck

>quotaoff

>quotaon

>repquota

>rmdir

>rmt

>stat

>tree

>umount

# 磁盘维护

>badblocks

>cfdisk

>dd

>e2fsck

>ext2ed

>fdformat

>fdisk

>fsck

>fsck.ext2

>fsck.minix

>fsconf

>hdparm

>losetup

>mbadblocks

>mformat

>mkbootdisk

>mkdosfs

>mke2fs

>mkfs

>mkfs.ext2

>mkfs.minix

>mkfs.msdos

>mkinitrd

>mkisofs

>mkswap

>mpartition

>sfdisk

>swapoff

>swapon

>symlinks

>sync

# 网络通讯

>apachectl

>arpwatch

>cu

>dip

>dnsconf

>efax

>getty

>httpd

## ifconfig	
查看网络设置信息	

```shell
ifconfig -a  # 查看网络设置信息
```

>mesg

>mingetty

>minicom

>nc

>netconf

>netconfig

## netstat

```shell
netstat -napl | grep 5060
```



>newaliases

## ping	
测试网络连通性

```shell
ping 192.168.1.1
```

>ppp-off

>pppsetup

>pppstats

>samba

>setserial

>shapecfg

>smbclient

>smbd

>statserial

>talk

>tcpdump

>telnet

>testparm

>traceroute

>tty

>uulog

>uuname

>uustat

>uux

## wall	
向所有用户广播信息


## write	
向一个用户发信息

>ytalk

# 系统管理

>adduser

>chfn

>chsh

## date
设置系统日期
```shell
date

date -d "-1 day" "+%Y-%m-%d" # 昨天 2019-12-21
```

>exit

>finger

## free

　　显示系统当前内存的使用情况，包括已用内存、可用内存和交换内存的情况
默认情况下free会以字节为单位输出内存的使用量
查看所有内存的汇总，请使用-t选项，-g为GB，-m为MB，-k为KB，-b为字节

```shelll
free -m
free -t　-g
free -g
```

>fwhios

>gitps

>groupadd

>groupdel

>groupmod

>halt

>id

## kill

```shell
kill -9 13326

# 根据名字包含来kill
ps x|grep main_LabelCustomer|grep -v grep |awk '{print $1}'|xargs kill -9
```

>last

>lastb

>login

>logname

>logout

>logrotate

>newgrp

>nice

>procinfo

## ps

```shell
ps -ef
ps -ef | grep river    # 在进程显示结果中匹配与river相关的内容并输出
ps -ef | more
ps auxw|head -1;ps auxw|sort -rn -k4|head -10  # 查看内存占用前十的进程

#linux下获取占用CPU资源最多的10个进程，可以使用如下命令组合：
ps aux|head -1; ps aux|grep -v PID|sort -rn -k +3|head

#linux下获取占用内存资源最多的10个进程，可以使用如下命令组合：
ps aux|head -1; ps aux|grep -v PID|sort -rn -k +4|head
```


>pstree

## reboot	
重启系统
```shell
reboot
```

>renice

>rlogin

>rsh

>rwho

>screen

## shutdown
关机

```shell
shutdown -h now
```

>skill

>sleep

>sliplogin

>su

>sudo

>suspend

>swatch

>tload

## top
top命令会显示当前系统中占用资源最多的一些进程

## uname
uname可以显示一些重要的系统信息，例如内核名称、主机名、内核版本号、处理器类型之类的信息
```shell
uname -a
```

>useradd

>userconf

>userdel

>usermod

>vlock

>w

>who

>whoami

>whois

# 系统设置

>alias

>apmd

>aumix

>bind

>chkconfig

>chroot

>clear

>clock

>crontab

>declare

>depmod

>dircolors

>dmesg

>enable

>eval

## export



```shell
export PATH=/root/anaconda3/bin:$PATH
```



>fbset

>gpasswd

>grpconv

>grpunconv

>hwclock

>insmod

>kbdconfig

>lilo

>liloconfig

>lsmod

>minfo

>mkkickstart

>modinfo

>modprobe

>mouseconfig

>ntsysv

## passwd
passwd用于在命令行修改密码

>pwconv

>pwunconv

>rdate

>reset

>resize

>rmmod

>rpm

>set

>setconsole

>setenv

>setup

>sndconfig

>SVGATextMode

>time

>timeconfig

>ulimit

>unalias

>unset

# 备份压缩

>ar

## bunzip2	
解压缩

```shell
bunzip2 -k file1.bz2
```

## bzip2	
压缩文件

```shell
bzip2 -k file1 # -k 产生压缩文件后保留原文件，压缩后文件格式：.bz2
```

>bzip2recover

>compress

>cpio

>dump

## gunzip	
解压缩.gz的压缩文件

```shell
gunzip file1.gz
```

>gzexe

## gzip	
压缩文件（不能压缩目录）	

>lha

>restore

## tar	
打包目录

```shell
tar -zcvf dir1.tar.gz dir1   将目录dir1压缩成一个打包并压缩的文件
tar -zxvf dir1.tar.gz 解压
    -c 产生.tar打包文件
    -v 显示详细信息
    -f 指定压缩后的文件名指定压缩后的文件名
    -z 打包同时压缩
```

>unarj

## unzip	
解压.zip的压缩文件

```shell
unzip test.zip
```

>uudecode

>uuencode

## zip	
压缩文件或目录

```shell
zip services.zip /etc/services   # 压缩文件
zip -r test.zip /test  # 压缩目录
```



```shell
# 压缩文件104
cd /home/liuhuihe
zip -r workspace.zip workspace

# 92.8
scp root@172.16.92.104:/home/liuhuihe/workspace.zip /home/liuhuihe
unzip workspace.zip
```





>zipinfo

# 设备管理

>dumpkeys

>loadkeys

>MAKEDEV

>rdev

>setleds

# 其它

## man

获取帮助信息

```shell
man ls
```

## info	
获取帮助信息

```shell
info ls
```

## whatis	
获得索引的简短说明信息

```shell
whatis ls
```

## wget
使用wget从网上下载软件、音乐、视频
```shell
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-3.2.1.tar.gz
```

## 输入/输出重定向

- >或>> 输出重定向
```shell
ls -l /tmp > /river/he
```

- < 输入重定向
```shell
wall < /etc/motd
```

- 2> 错误输出重定向
```shell
cp -R /usr /backup/usr.bak 2> /bak.error
```

## 管道
将一个命令的输出传送给另一个命令，作为另一个命令的输入。
```shell
ls -l / | grep river | wc -l
```

## 命令连接符
- ； # 用；间隔的各命令按顺序依次执行。
- && # 前后命令的执行存在逻辑与关系，只有&&前面的命令执行成功后，它后面的命令才被执行。
- || # 前后命令的执行存在逻辑或关系，只有||前面的命令执行失败后，它后面的命令才被执行。


## 命令替换符
将一个命令的输出作为另一个命令的参数。
```shell
ls -l `which touch`
```