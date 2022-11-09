#  -文件管理

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

- chattr

## **chgrp**

修改文件或目录的所属组

```shell
chgrp admin file1 # 改变文件file1的所属组为adm
```

## chmod	

修改权限

```shell
chmod 764 /etc/services
chmod g+w file1  # 赋予文件file1所属组写权限   <ugo+rwx>

chmod 755 * -R
chmod -R +x Decoder
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

- cksum
- cmp

## cp

复制文件或目录	

```shell
cp file1 file2 dir1 # 将文件file1、file2复制到目录dir1
cp -R dir1 dir2 # 将dir1下的所有文件及子目录复制到dir2
cp -r  /home/Ehe/Files  /data/Ehe  # Files文件夹复制到Ehe目录下
cp -rf Label_lvshou_fill_vertify /home/liuhuihe/workspace/code_run/  # 将一个文件夹复制到另一个文件夹下
cp -rf /home/lhh/workspace/customer_risk_pro/*  /home/lhh/workspace/code_run/customer_risk_pro/
cp -rf /usr/local/KingSTD_1/*  /usr/local/webapps/KingSTD_2/    #将dir1下的所有文件及子目录复制到dir2,覆盖
```

- cut

## diff

diff 命令用于比较文件的差异。diff 以逐行的方式，比较文本文件的异同处。如果指定要比较目录，则 diff 会比较目录中相同文件名的文件，但不会比较其中子目录。

> "|" 表示前后2个文件内容有不同
>
> "<" 表示后面文件比前面文件少了1行内容
>
> ">" 表示后面文件比前面文件多了1行内容

```shell
diff log2014.log log2013.log 
```

## md5sum

用于计算和校验文件的MD5值。常常被用来验证网络文件传输的完整性，防止文件被人篡改。在日常工作当中，我们可以用来判断系统中的重要文件是否被篡改。

```shell
md5sum log.txt
```



- diffstat

## file

通过file指令，我们得以辨识该文件的类型

```shell
# 显示文件类型
file install.log
```

```
install.log: UTF-8 Unicode text
```



## find	

查找文件或目录

> UNIX/Linux文件系统每个文件都有三种时间戳：
>
> - 访问时间（-atime/天，-amin/分钟）：用户最近一次访问时间。
> - 修改时间（-mtime/天，-mmin/分钟）：文件最后一次修改时间。
> - 变化时间（-ctime/天，-cmin/分钟）：文件数据元（例如权限等）最后一次修改时间。

```shell
find /etc -name init # 在目录/etc中查找文件init
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

- git
- gitview

## head

查看文件的前N行

```shell
head -100 /etc/services
```

- indent
- less

## ln

创建链接文件，目录只能创建软链接

```shell
ln -s  /etc/issue  /issue.soft # 创建文件/etc/issue的软链接/issue.soft
ln /etc/issue  /issue.hard # 创建文件/etc/issue的硬链接/issue.hard
```

## locate	

查找文件或目录，locate命令和slocate命令都用来查找文件或目录。

locate命令其实是find -name的另一种写法，但是要比后者快得多，原因在于它不搜索具体目录，而是搜索一个数据库/var/lib/locatedb，这个数据库中含有本地所有文件信息。Linux系统自动创建这个数据库，并且每天自动更新一次，所以使用locate命令查不到最新变动过的文件。为了避免这种情况，可以在使用locate之前，先使用updatedb命令，手动更新数据库。

```shell
locate ls  # 列出所有跟file相关的文件

# 搜索etc目录下所有以sh开头的文件：
locate /etc/sh

# 搜索用户主目录下，所有以m开头的文件：
locate ~/m

# 搜索用户主目录下，所有以m开头的文件，并且忽略大小写
locate -i ~/m
```

- lsattr
- mattrib
- mc
- mcopy
- mdel
- mdir
- mktemp
- mmove
- more

分页显示文件内容

```shell
more /etc/services
```

- mread
- mren
- mshowfat
- mtools
- mtoolstest

## mv

移动文件、更名	

```shell
mv file1 file3 # 将当前目录下文件file1更名为file3
mv file1 file2 file3 dir2  # 将文件file1、 file2 file3移动到目录dir2下

# 移动文件夹
mv jmeter /home/asr/online/rel_onlineasr/tools/
```

- od
- paste
- patch
- rcp
- read
- rhmask


## rm

删除文件或目录	

```shell
rm he  # 删除文件he
rm -r river # 删除目录river
rm -rf chinese_text_classification/
```



按日期删除文件

```shell
find /home/studies -mtime +10 -name "*.*" -exec rm -Rf {} \;
```

* /home/studies ：准备要进行清理的任意目录
* -mtime：标准语句写法
* ＋10：查找10天前的文件，这里用数字代表天数，＋30表示查找30天前的文件
* "*.*"：希望查找的数据类型，"\*.jpg"表示查找扩展名为jpg的所有文件，"\*"表示查找所有文件
* -exec：固定写法
* rm -rf：强制删除文件，包括目录
* {} \; ：固定写法，一对大括号+空格+/+;

## rmdir

全拼 remove empty directories，功能是删除空目录

```shell
rmdir he  # he为空目录
```

## mkdir

创建新目录

**参数**：-p 确保目录名称存在，如果目录不存在的就新创建一个。

```shell
mkdir river # 创建目录river
mkdir -p  /home/blue/ssd/thinkit
```

```shell
directory=/home/dmp/lixiaoli/yjk_dm
loaddate=`date -d "-1 day" "+%Y-%m-%d"`
mkdir -p ${directory}/log/${loaddate}/
```



## **scp**

```shell
# 从106复制文件到92.8

# 92.8上面
scp root@172.16.92.106:/home/Anaconda3-5.0.1-Linux-x86_64.sh /home

# 106上面
scp /home/Anaconda3-5.0.1-Linux-x86_64.sh root@172.16.92.8:/home
scp -r /home/Ehe root@172.16.92.8:/home
```

- slocate
- split

## tail	

查看文件的后N行

```shell
tail -100 /etc/services
tail -f ./logs/catalina.out

tail -100f nohup.out
```

- tee
- tmpwatch

## touch

创建空文件

```shell
touch student # 创建空文件student
touch  /river/student   # 创建空文件student
```

- umask

- updatedb

    

## whereis

在特定目录中查找符合条件的文件



## which

显示系统命令所在目录

```shell
which hive
```

# 文档编辑

- col
- colrm
- comm
- csplit
- ed
- egrep
- ex
- expr

- fgrep
- fmt
- fold

## **grep**

在文件中搜寻字串匹配的行并输出

```shell
# 在多级目录中对文本进行递归搜索
grep -n -r "linedetail" ./*

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

- ispell
- jed
- joe
- join
- let
- look
- mtype
- pico
- rgrep

## **sed**

```shell
# 对每行匹配到的第一个字符串进行替换
sed -i 's/原字符串/新字符串/' ab.txt 

# 对于文件第3行，把匹配上的所有字符串进行替换
sed -i '3s/原字符串/新字符串/g' ab.txt
```



- sort
- spell
- tr

## uniq

用于检查及**删除**文本文件中**重复出现**的行列，一般与 sort 命令结合使用。

**命令参数：**

- **-c或--count 在每列旁边显示该行重复出现的次数。（常用，比如netstat分析的时候，看不同端口的time_wait数量）**
- -d或--repeated 仅显示重复出现的行列。
- -u或--unique 仅显示出一次的行列。

```shell
uniq -c test.text
```



## **wc**

统计指定文件中的字节数、字数、行数，并将统计结果显示输出。如果没有给出文件名，则从标准输入读取。

**命令参数：**

- -c 统计字节数。

- **-l 统计行数。常用。**

- -m 统计字符数。这个标志不能与 -c 标志一起使用。

- -w 统计字数。一个字被定义为由空白、跳格或换行字符分隔的字符串。

```shell
wc testfile           # testfile文件的统计信息  
```

```
3 92 598 testfile       # testfile文件的行数为3、单词数92、字节数598
```

其中，3 个数字分别表示testfile文件的行数、单词数，以及该文件的字节数。

如果想同时统计多个文件的信息，例如同时统计testfile、testfile_1、testfile_2，可使用如下命令：

```shell
wc testfile testfile_1 testfile_2   # 统计三个文件的信息 
```

输出结果如下：

```
3 92 598 testfile      # 第一个文件行数为3、单词数92、字节数598  
9 18 78 testfile_1     # 第二个文件的行数为9、单词数18、字节数78  
3 6 32 testfile_2       # 第三个文件的行数为3、单词数6、字节数32  
15 116 708 总用量       # 三个文件总共的行数为15、单词数116、字节数708 
```

```shell
wc -l train.txt
wc -l ./*
```

## locale 

```shell
# 查看支持的编码
locale -a
```



## iconv

编码转换

```shell
# 临时解决方法将当前文件强制使用 UTF-8 显示，在终端输入命令
cat cimse_cmd_01.log | iconv -f gb18030 -t utf-8 -c | more
cat ./logs/cimse_cmd_rxRatio_0.2.log | iconv -f gb18030 -t utf-8 -c | more
```



```shell
# 将文件GBK编码转换为UTF-8
#源文件：fnote.txt　　编码：GBK
#目标文件：tnote.txt　　编码：UTF-8
iconv -f gbk -t utf-8 -c fnote.txt -o tnote.txt
iconv -f gb18030 -t utf-8 -c cimse_cmd_rxRatio_1.0.log -o pro_cimse_cmd_rxRatio_1.0.log
```



```shell
# 把 fnote.txt 文件中的“穿越”文本提取，并且把编码从GBK转码为UTF-8保存

cat fnote.txt | iconv -f gbk -t utf-8 -c | grep "穿越" > text.out
cat fnote.txt | iconv -f gbk -t utf-8 -c | more
```



# 文件传输

- bye
- ftp
- ftpcount
- ftpshut
- ftpwho
- lpd
- lpq
- lpr
- lprm
- ncftp

## rz

从客户端上传文件到服务端

## sz

从服务端发送文件到客户端



- tftp
- uucico
- uucp
- uupick
- uuto

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
```

```
[root@Ehe ~]# df -k
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/vda1       41147472 7434824  31809156  19% /
devtmpfs          930368       0    930368   0% /dev
tmpfs             941024       0    941024   0% /dev/shm
tmpfs             941024     448    940576   1% /run
tmpfs             941024       0    941024   0% /sys/fs/cgroup
tmpfs             188208       0    188208   0% /run/user/0
```



```shell
df -h  # 使用-h选项可以以更符合阅读习惯的方式显示磁盘使用量
```

```
[root@Ehe ~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1        40G  7.1G   31G  19% /
devtmpfs        909M     0  909M   0% /dev
tmpfs           919M     0  919M   0% /dev/shm
tmpfs           919M  448K  919M   1% /run
tmpfs           919M     0  919M   0% /sys/fs/cgroup
tmpfs           184M     0  184M   0% /run/user/0
```



- dirs

## **du**

du命令用于显示目录或文件的大小。du会显示指定的目录或文件所占用的磁盘空间。

```shell
# 查看文件夹大小
du -sh data
```

```
20G data
```



```shell
# 查看当前文件夹下所有文件大小
du -h

# 查看指定文件/文件夹大小
du -h test.txt

# 当前文件夹下所有文件总大小
du -sh *
```



```shell
cd / && du -h -x --max-depth=1

du -h --max-depth=1 /home
```

```
[root@Ehe ~]# du -h --max-depth=1 /
4.0K	/srv
4.0K	/mnt
2.1G	/usr
448K	/run
4.6G	/home
306M	/var
2.5M	/root
4.0K	/media
132M	/boot
7.1G	/
```



- edquota
- eject
- lndir

## ls

显示目录文件

```shell
ls -a # 显示所有文件，包括隐藏文件
ls -l # 详细信息显示
ls -al # 所有文件详细信息
ls -r # 反向排序，倒序
ls -t  # 按修改时间排序

# 显示递归文件
ls -R

# 显示完整路径
ls $(pwd)/*
```

```shell
# 按修改时间反向的排序,即最新修改时间的放在最后面
ls -rtl
```

```
[root@Ehe /]# ls -rtl
total 60
drwxr-xr-x.  2 root root  4096 Apr 11  2018 srv
drwxr-xr-x.  2 root root  4096 Apr 11  2018 mnt
drwxr-xr-x.  2 root root  4096 Apr 11  2018 media
drwxr-xr-x. 19 root root  4096 Jul 11  2019 var
drwx------.  2 root root 16384 Jul 11  2019 lost+found
dr-xr-xr-x.  5 root root  4096 Nov 30 15:19 boot
dr-xr-xr-x  83 root root     0 Feb 18 10:58 proc
dr-xr-xr-x  13 root root     0 Feb 18 10:59 sys
```



- mcd
- mdeltree
- mdu

- mlabel
- mmd
- mmount

## mount

用于挂载Linux系统外的文件

```shell
# 将/dev/hda1 挂在/data之下
mkdir /data
mount /dev/hda1 /data
```



- mrd
- mzip

## pwd

当前工作目录



- quota
- quotacheck
- quotaoff
- quotaon
- repquota
- rmt
- stat

## tree

用于以树状图形式列出目录内容。包括所有文件、子目录及子目录里的目录和文件

> -a  # 显示所有文件和目录。
>
> -d  # 显示目录名称而非文件。 
>
> -f  # 显示每个文件的全路径名称。
>
> -i  # 不以阶梯状列出文件和目录名称。
>
> -L level # 限制目录显示层级。
>
> -F  # 在执行文件，目录，Socket，符号连接，管道名称名称，各自加上"*"，"/"，"@"，"|"号。
>
> -l  # 如遇到性质为符号连接的目录，直接列出该连接所指向的原始目录。
>
> -p  # 列出权限标示。
>
> -s  # 列出文件和目录大小。

```shell
tree -f
tree -f -i
```



## umount

可卸除目前挂在Linux目录中的文件系统

```shell
# 直接卸载
umount /data1/img

# 提示被占用，使用强制卸载
umount -f /data1/img
```



# 磁盘维护

- badblocks
- cfdisk
- dd
- e2fsck
- ext2ed
- fdformat

## fdisk

```shell
fdisk -l
```

```
Disk /dev/sdb: 2399.9 GB, 2399913639936 bytes, 4687331328 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 262144 bytes / 262144 bytes
Disk label type: gpt
Disk identifier: 5C7A6AB0-9B4B-4287-86DE-DD0DBB118819

#         Start          End    Size  Type            Name
 1         2048   4687329279    2.2T  Linux LVM       

Disk /dev/sda: 479.6 GB, 479559942144 bytes, 936640512 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 262144 bytes / 262144 bytes
Disk label type: dos
Disk identifier: 0x000c4bb9

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048        6143        2048   83  Linux
/dev/sda2   *        6144     1030143      512000   83  Linux
/dev/sda3         1030144   936640511   467805184   8e  Linux LVM

Disk /dev/mapper/centos-root: 2861.8 GB, 2861761036288 bytes, 5589377024 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 262144 bytes / 262144 bytes

Disk /dev/mapper/centos-swap: 17.2 GB, 17179869184 bytes, 33554432 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 262144 bytes / 262144 bytes
```



- fsck
- fsck.ext2
- fsck.minix
- fsconf
- hdparm
- losetup

## lsblk

查看系统检测的硬盘，列出块设备信息（df -h不能看到的卷）

```shell
lsblk
```

```
NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda               8:0    0 446.6G  0 disk 
├─sda1            8:1    0     2M  0 part 
├─sda2            8:2    0   500M  0 part /boot
└─sda3            8:3    0 446.1G  0 part 
  ├─centos-root 253:0    0   2.6T  0 lvm  /
  └─centos-swap 253:1    0    16G  0 lvm  [SWAP]
sdb               8:16   0   2.2T  0 disk 
└─sdb1            8:17   0   2.2T  0 part 
  └─centos-root 253:0    0   2.6T  0 lvm  /
```

- mbadblocks
- mformat
- mkbootdisk
- mkdosfs
- mke2fs
- mkfs
- mkfs.ext2
- mkfs.minix
- mkfs.msdos
- mkinitrd
- mkisofs
- mkswap
- mpartition
- sfdisk
- swapoff
- swapon
- symlinks
- sync

# 网络通讯

- apachectl
- arpwatch
- cu

## curl

curl命令是一个利用URL规则在命令行下工作的文件传输工具。它支持文件的上传和下载，所以是综合传输工具，但按传统，习惯称curl为下载工具。作为一款强力工具，curl支持包括HTTP、HTTPS、ftp等众多协议，还支持POST、cookies、认证、从指定偏移处下载部分文件、用户代理字符串、限速、文件大小、进度条等特征。

```shell
# 文件下载
curl URL --silent ->将下载文件输出到终端，所有下载的数据都被写入到stdout
curl http://test.com/index.html  -O ->将index.html下载到当前文件夹中
curl http://test.com -o filename.html --progress ->将输出内容保存到指定文件中，并显示进度
curl URL --limit-rate 50k	->限制curl的下载速度
curl URL --max-filesize bytes ->指定可下载的最大文件大小
curl URL -v	->查看详细信息

# 断点续传
curl URL/File -C 偏移量 ->从特定的文件偏移处继续下载,或者下载部分文件
curl -C - URL		   ->自动判断续传位置

# 用curl设置cookies
curl http://test.com --cookie "user=root;pass=126" ->多个cookie使用分号分隔
curl URL --cookie-jar cookie_file ->将cookie另存为一个文件

# 用curl设置用户代理字符串
# 有些网站访问会提示只能使用IE浏览器来访问，这是因为这些网站设置了检查用户代理，
# 可以使用curl把用户代理设置为IE，这样就可以访问了。使用--user-agent或者-A选项
curl URL --user-agent "Mozilla/5.0" ->设置使用IE访问
curl URL -A "Mozilla/5.0"           ->设置使用IE访问

# 设置请求头
curl -H "Host:man.linuxde.net" -H "accept-language:zh-cn" URL

# 用curl进行认证
curl -u user:pwd http://man.linuxde.net
curl -u user http://man.linuxde.net


# 只打印响应头部信息
curl -I http://test.com
curl -head http://test.com

# 使用-X
# POST请求
curl localhost:9999/api/daizhige/article -X POST -d "title=123&content=xdw"
curl http://test.com -X POST -H "Content-Type:application/json" -d '{"title":"123","content":"dw"}'

# 上传文件-F "file=@文件地址"
curl http://test.com -F "file=@/Users/fungleo/Downloads/401.png" -H "token: 222" -v

# 请求https
curl http://test.com -X POST -H "Content-Type:application/json" -d '{"title":"123","content":"dw"}' -k

```



- dip
- dnsconf
- efax
- getty
- httpd



## ifup

## ifdown

## ifconfig

查看网络设置信息	

```shell
ifconfig -a  # 查看网络设置信息
```

## **lsof**

lsof(list open files)是一个列出当前系统打开文件的工具。

lsof 查看端口占用语法格式：

```shell
# 查看8080端口占用
lsof -i:8080 
```

```shell
lsof abc.txt：显示开启文件abc.txt的进程
lsof -c abc：显示abc进程现在打开的文件
lsof -c -p 1234：列出进程号为1234的进程所打开的文件
lsof -g gid：显示归属gid的进程情况
lsof +d /usr/local/：显示目录下被进程开启的文件
lsof +D /usr/local/：同上，但是会搜索目录下的目录，时间较长
lsof -d 4：显示使用fd为4的进程
lsof -i -U：显示所有打开的端口和UNIX domain文件
```



- mesg
- mingetty
- minicom
- nc
- netconf
- netconfig

## **netstat**

**netstat -tunlp** 用于显示 tcp，udp 的端口和进程等相关情况。

netstat 查看端口占用语法格式：

```shell
netstat -tunlp | grep 端口号
```

例如查看 8000 端口的情况，使用以下命令：

```shell
netstat -tunlp | grep 8000 
```

```
tcp        0      0 0.0.0.0:8000            0.0.0.0:*               LISTEN      26993/nodejs 
```

更多命令：

```shell
netstat -ntlp   # 查看当前所有tcp端口
netstat -ntulp | grep 80   # 查看所有80端口使用情况
netstat -ntulp | grep 3306   # 查看所有3306端口使用情况
netstat -ant
```

- newaliases

## ping

测试网络连通性

```shell
ping 192.168.1.1
```

- ppp-off
- pppsetup
- pppstats

## route

- samba
- setserial
- shapecfg
- smbclient
- smbd

## ss

## ssh

```shell
ssh root@10.1.1.5
```



- statserial
- talk

## tcpdump

命令行的抓包工具



## telnet

- testparm
- traceroute
- tty
- uulog
- uuname
- uustat
- uux

## wall	

向所有用户广播信息


## write	

向一个用户发信息

- ytalk

# 系统管理

- adduser
- chfn
- chsh

## date

设置系统日期

```shell
date
date -d "-1 day" "+%Y-%m-%d" # 昨天 2019-12-21
```

- exit
- finger

## free

显示系统当前内存的使用情况，包括已用内存、可用内存和交换内存的情况，默认情况下free会以字节为单位输出内存的使用量

查看所有内存的汇总，请使用-t选项，-g为GB，-m为MB，-k为KB，-b为字节

```shell
free -m
free -t　-g
free -g
```

- fwhios
- gitps
- groupadd
- groupdel
- groupmod
- halt
- id

## kill

在查到端口占用的进程后，如果你要杀掉对应的进程可以使用 kill 命令：**kill -9 PID**

如上实例，我们看到 8000 端口对应的 PID 为 26993，使用以下命令杀死进程：

```shell
kill -9 26993
```

```shell
# 根据名字包含来kill
ps x | grep main_LabelCustomer | grep -v grep |awk '{print $1}'|xargs kill -9
```

- last
- lastb
- login
- logname
- logout
- logrotate
- newgrp
- nice
- procinfo

## ps

**用法**：ps aux 显示所有包含其他使用者的行程

**用法**：ps -ef 是用标准的格式显示进程的

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

- pstree

## pwdx

**用法**：查看进程的启动路径

```shell
ps -ef | grep train
pwdx 99080
```

```
[root@localhost ~]# ps -ef | grep train
root      22409  21936  0 22:56 pts/0    00:00:00 grep --color=auto train
root      99080      1 15 Mar15 ?        21:29:16 /home/cao/anaconda3/bin/python train_css.py

[root@localhost ~]# pwdx 99080
99080: /home/cao/gridsim-master-0811
```



## reboot

重启系统

```shell
reboot
```

- renice
- rlogin
- rsh
- rwho
- screen

## shutdown

关机

```shell
shutdown -h now
```

- skill
- sleep
- sliplogin
- su
- sudo
- suspend
- swatch
- tload

## top

top命令会显示当前系统中占用资源最多的一些进程

```shell
# 显示指定的进程信息，显示进程号为139的进程信息，CPU、内存占用率等
top -p 139
```



## uname

uname可以显示一些重要的系统信息，例如内核名称、主机名、内核版本号、处理器类型之类的信息

```shell
uname -a
```

## useradd

命令用于建立用户帐号

```shell
# 添加一般用户
useradd tt

# 为添加的用户指定相应的用户组
useradd -g root tt

# 为新添加的用户指定home目录
useradd -d /home/myd tt
```



- userconf

## userdel

- usermod
- vlock
- w
- who
- whoami
- whois

# 系统设置

- alias
- apmd
- aumix
- bind
- chkconfig
- chroot
- clear
- clock
- crontab
- declare
- depmod
- dircolors
- dmesg
- enable
- eval

## export

用于设置或显示环境变量。在 shell 中执行程序时，shell 会提供一组环境变量。export 可新增，修改或删除环境变量，供后续执行的程序使用。export 的效力仅限于该次登陆操作。

语法：export \[-fnp\][变量名称]=[变量设置值]

参数说明：

- -f 　代表[变量名称]中为函数名称。
- -n 　删除指定的变量。变量实际上并未删除，只是不会输出到后续指令的执行环境中。
- -p 　列出所有的shell赋予程序的环境变量。

```shell
export PATH=/root/anaconda3/bin:$PATH
export LD_LIBRARY_PATH=/home/cao/gridsim-master-0811/lib64
export LD_LIBRARY_PATH=/home/asr/online/rel_onlineasr/Decoder/model/lib
export LD_LIBRARY_PATH=/home/asr/online/rel_onlineasr/Decoder/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../lib
```



```shell
vi /etc/profile   

# 在文本的最后面添加以下内容 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/apr/lib   

# 使profile生效
source /etc/profile
```



- fbset
- gpasswd
- grpconv
- grpunconv
- hwclock
- insmod
- kbdconfig
- lilo
- liloconfig
- lsmod
- minfo
- mkkickstart
- modinfo
- modprobe
- mouseconfig
- ntsysv

## passwd

passwd用于在命令行修改密码

- pwconv
- pwunconv
- rdate
- reset
- resize
- rmmod
- rpm
- set
- setconsole
- setenv
- setup
- sndconfig
- SVGATextMode
- time
- timeconfig
- ulimit
- unalias
- unset

# 备份压缩

- ar

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

- bzip2recover
- compress
- cpio
- dump

## gunzip	

解压缩.gz的压缩文件

```shell
gunzip file1.gz
```

- gzexe

## gzip	

压缩文件（不能压缩目录）	

- lha
- restore

## tar	

打包目录

```shell
# 将目录dir1压缩成一个打包并压缩的文件
tar -zcvf dir1.tar.gz dir1   
tar -zcvf ifly_mrcp.tar.gz mrcp/

# 解压
tar -zxvf dir1.tar.gz 

    -c 产生.tar打包文件
    -v 显示详细信息
    -f 指定压缩后的文件名指定压缩后的文件名
    -z 打包同时压缩
    
# 加压
tar -zxvf apache-tomcat-9.0.35.20210702.tar.gz
# 压缩
tar -zcvf apache-tomcat-9.0.35.20210702.tar.gz apache-tomcat-9.0.35/

tar -tf test.tar			# 列出test.tar中为所有文件
tar -xzvf test.tar.gz 		# 解压test.tar.gz文件
tar -xf test.tar 			# 解压test.tar文件
tar -xjvf test.tar.bz2   	# 解压 .tar.bz2
tar –xZvf test.tar.Z   		# 解压 .tar.Z
```

- unarj

## unzip	

解压.zip的压缩文件

```shell
unzip test.zip 				->将test.zip解压到当前文件下
unzip -n test.zip -d /tmp 	->将test.zip解压到/tmp目录下，并且不要覆盖已有文件
unzip -v test.zip			->查看test.zip内容，但不解压
unzip -o test.zip -d tmp/	->将test.zip解压到/tmp目录下，并且覆盖已有文件
```

- uudecode
- uuencode

## zip

压缩文件或目录

```shell
zip services.zip /etc/services.txt   # 压缩文件
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

- zipinfo

# 设备管理

- dumpkeys
- loadkeys
- MAKEDEV
- rdev
- setleds

## lscpu

```shell
lscpu
```

```
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                64
On-line CPU(s) list:   0-63
Thread(s) per core:    2
Core(s) per socket:    16
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 85
Model name:            Intel(R) Xeon(R) Silver 4216 CPU @ 2.10GHz
Stepping:              7
CPU MHz:               799.932
CPU max MHz:           3200.0000
CPU min MHz:           800.0000
BogoMIPS:              4200.00
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              1024K
L3 cache:              22528K
NUMA node0 CPU(s):     0-15,32-47
NUMA node1 CPU(s):     16-31,48-63
Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr...
```



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

## watch

可以将命令的输出结果输出到标准输出设备，多用于周期性执行命令/定时执行命令。选项：

```bash
-n # 或--interval  watch缺省每2秒运行一下程序，可以用-n或-interval来指定间隔的时间。
-d # 或--differences  用-d或--differences 选项watch 会高亮显示变化的区域。 而-d=cumulative选项会把变动过的地方(不管最近的那次有没有变动)都高亮显示出来。
-t # 或-no-title  会关闭watch命令在顶部的时间间隔,命令，当前时间的输出。
-h, --help # 查看帮助文档
```

```shell
watch -n 1 -d netstat -ant       # 命令：每隔一秒高亮显示网络链接数的变化情况
watch -n 1 -d 'pstree|grep http' # 每隔一秒高亮显示http链接数的变化情况。 后面接的命令若带有管道符，需要加''将命令区域归整。
watch 'netstat -an | grep:21 | \ grep<模拟攻击客户机的IP>| wc -l' # 实时查看模拟攻击客户机建立起来的连接数
watch -d 'ls -l|grep scf'       # 监测当前目录中 scf' 的文件的变化
watch -n 10 'cat /proc/loadavg' # 10秒一次输出系统的平均负载
watch uptime
watch -t uptime
watch -d -n 1 netstat -ntlp
watch -d 'ls -l | fgrep goface'     # 监测goface的文件
watch -t -differences=cumulative uptime
watch -n 60 from            # 监控mail
watch -n 1 "df -i;df"       # 监测磁盘inode和block数目变化情况
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

## nohup

nohup命令用于不挂断地运行命令（关闭当前session不会中断改程序，只能通过kill等命令删除）。
使用nohup命令提交作业，如果使用nohup命令提交作业，那么在缺省情况下该作业的所有输出都被重定向到一个名为nohup.out的文件中，除非另外指定了输出文件。

```shell
nohup /root/anaconda3/bin/python train_css.py &
```





​    

**示例：**

```shell
nohup command > myout.file 2>&1 & echo $! > command.pid
```
> bash中：
>
> - 0 代表STDIN_FILENO 标准输入（一般是键盘），
>
> - 1 代表STDOUT_FILENO 标准输出（一般是显示屏，准确的说是用户终端控制台），
>
> - 2 三代表STDERR_FILENO (标准错误（出错信息输出）。
>
>
> 
>
> - \> 直接把内容生成到指定文件，会覆盖原来文件中的内容[ls > test.txt]
>     \>> 尾部追加，不会覆盖原有内容 [ls >> test.txt]
>     < 将指定文件的内容作为前面命令的参数[cat < text.sh]


> &：用于后台执行程序，但是关闭当前session程序也会结束.
>
> 2>&1：就是用来将标准错误2重定向到标准输出1中的。此处1前面的&就是为了让bash将1解释成标准输出而不是文件1。至于最后一个&，则是让bash在后台执行。
>
> /dev/null 2>&1：则表示吧标准输出和错误输出都放到这个“黑洞”，表示什么也不输出。



## 输入、输出重定向

1. 或>> 输出重定向

```shell
ls -l /tmp > /river/he

# 将单引号中的语句写入到 /etc/profile 文件，追加
echo 'export LANG="zh_CN.UTF-8"'  >> /etc/proflile
#重新加载 profile 文件（使之立即生效）
source /etc/profile
```

2. < 输入重定向

```shell
wall < /etc/motd
```

3. 2> 错误输出重定向

```shell
cp -R /usr /backup/usr.bak 2> /bak.error
```

## 管道

将一个命令的输出传送给另一个命令，作为另一个命令的输入。

```shell
ls -l / | grep river | wc -l
```

## 命令连接符

1. ； # 用；间隔的各命令按顺序依次执行。

2. && # 前后命令的执行存在逻辑与关系，只有&&前面的命令执行成功后，它后面的命令才被执行。

3. || # 前后命令的执行存在逻辑或关系，只有||前面的命令执行失败后，它后面的命令才被执行。


## 命令替换符

将一个命令的输出作为另一个命令的参数。

```shell
ls -l `which touch`
```

# 情景任务

## CPU

```shell
lscpu
```

```
总核数 = 物理CPU个数 x 每个物理CPU的核数
逻辑CPU个数 = 物理CPU个数 x 每个物理CPU的核数 x 超线程数
```

1. 查看物理 CPU 个数

```shell
cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l
```

2. 查看每个物理 CPU 核数

```shell
cat /proc/cpuinfo | grep "cpu cores" | sort | uniq
```

3. 查看每个物理 CPU 核心上的逻辑处理个数

```shell
cat /proc/cpuinfo | grep 'siblings' | sort | uniq
```

4. 查看总线程数 | 查看逻辑 CPU 的个数

```shell
cat /proc/cpuinfo | grep "processor"| wc -l
```

## 内存

1. 查看内存信息

```shell
cat /proc/meminfo
```

## 系统版本

```shell
cat /etc/redhat-release
lsb_release -a
cat /etc/issue
```

## 磁盘挂载

## 环境变量

### 设置环境变量

1. 在/etc/profile中设置

用vim在文件/etc/profile文件中增加变量，该变量将会对Linux下所有用户有效，并且是“永久的”。

```shell
# vi /etc/profile 
export CLASSPATH=./JAVA_HOME/lib;$JAVA_HOME/jre/lib

# 注：修改文件后要想马上生效还要运行 source /etc/profile 不然只能在下次重进此用户时生效。
```

2. 在用户目录下的.bash_profile文件中

用vim在用户目录下的.bash_profile文件中增加变量，改变量仅会对当前用户有效，并且是“永久的”。

```shell
vim/home/guok/.bash.profile
export CLASSPATH=./JAVAHOME/lib;JAVA_HOME/jre/lib 

# 注：修改文件后要想马上生效还要运行 source /home/guok/.bash_profile
```

3. 直接运行export命令定义变量

这种方法只对当前shell(BASH)有效(临时的)。

```shell
export LD_LIBRARY_PATH=../lib:$LD_LIBRARY_PATH
```

### 查看环境变量

1. 使用echo命令查看单个环境变量

```shell
echo $PATH 
```

2. 使用env查看所有环境变量

```shell
env 
```

3. 使用set查看所有环境变量

```shell
set 
```



### 删除环境变量

```shell
unset  TEST #删除环境变量TEST
```

也可以进入/etc/profile文件进行删除

### 常用的环境变量

```
PATH 决定了shell将到哪些目录中寻找命令或程序 
HOME 当前用户主目录 
HISTSIZE　历史记录数 
LOGNAME 当前用户的登录名 
HOSTNAME　指主机的名称 
SHELL 当前用户Shell类型 
LANGUGE 　语言相关的环境变量，多语言可以修改此环境变量 
MAIL　当前用户的邮件存放目录 
PS1　基本提示符，对于root用户是#，对于普通用户是$
```

