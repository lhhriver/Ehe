
# 1-主控脚本实现

## vim编辑器设置

```shell
语法高亮
	syntax on
显示行号
	set number
自动缩进
	set autoindent
	set cindent
自动加入文件头

```

## shell编程高级知识

### shell高亮显示

```shell
基本格式：
	echo -e 终端颜色 + 内容 + 结束后的颜色
例子：
	echo -e "\e[1;30m 内容 \e[1;0m"
	echo -e "\e[1;30" "内容" $(tupt sgr0)
```

### shell中的关联数组

```shell
关联数组：
	普通数组：只能使用整数作为数组索引
	关联数组：可以使用字符串作为数组索引
	
	申明关联数组变量
	# declare -A ass_array1
	
	数组名[索引]=变量值
	# ass_array1[index1]=per
```

# 实例

## 进程

> 查看进程

```shell
ps auxw|head -1;ps auxw|sort -rn -k4|head -10

ps auxw|head -1;ps auxw|grep 'Label_lvshou_text'|sort -rn -k4
```

> kill进程

```shell
#!/bin/bash

pName='Label_lvshou_text'  # 包含部分
tmp_name=$pName
result=`ps -ef | grep $tmp_name | grep -v grep | awk '{print $2}'` 
for name in ${result}
do
kill -9 $name
done
```


## 调用SQL脚本

```shell
#!/bin/bash

# 依次调用多个SQL脚本，如果失败就退出

hive -f /home/dmp/lixiaoli/dashboard/dm_line2_achievement&several_sales_drill.sql
if [ $? != 0 ]; then
echo "fail"
exit 1
fi

hive -f /home/dmp/lixiaoli/dashboard/dm_line2_distribution_deal_drill.sql
if [ $? != 0 ]; then
echo "fail"
exit 1
fi

hive -f /home/dmp/lixiaoli/dashboard/dm_line2_calls_drill.sql
if [ $? != 0 ]; then
echo "fail"
exit 1
fi
```







