# 基础知识

## SQL数据语言
|语 言|命 令|描 述|
|:---:|:---:|:---|
|DDL - 数据定义语言	|CREATE|创建一个新的表，表的视图，或者在数据库中的对象|
|DDL - 数据定义语言	|ALTER	|修改现有的数据库对象，例如一个表|
|DDL - 数据定义语言	|DROP	|删除整个表，数据库中的表或其他对象或视图|
|DML - 数据操纵语言	|SELECT	|从一个或多个表中检索特定的记录|
|DML - 数据操纵语言	|INSERT	|创建记录|
|DML - 数据操纵语言	|UPDATE	|修改记录|
|DML - 数据操纵语言	|DELETE	|删除记录|
|DCL - 数据控制语言	|GRANT	|授予用户权限|
|DCL - 数据控制语言	|REVOKE	|收回用户授予的权限|

## SQL执行顺序

|语法顺序|	执行顺序|
|:-:|:-:|
|SELECT[DISTINCT]|	FROM|
|FROM|	WHERE|
|WHERE|	GROUP BY|
|GROUP BY|	HAVING|
|HAVING|	SELECT|
|UNION|	DISTINCT|
|ORDER BY|	UNION|

## SQL常用语句

>SELECT 语句:	

```sql
 SELECT column1, column2....columnN
FROM   table_name;
```

>DISTINCT 子句:	

```sql
 SELECT DISTINCT column1, column2....columnN
FROM   table_name;
```

>WHERE 子句:	

```sql
SELECT column1, column2....columnN
FROM   table_name
WHERE  CONDITION;
```

>AND/OR 子句:	

```sql
SELECT column1, column2....columnN
FROM   table_name
WHERE  CONDITION-1 {AND|OR} CONDITION-2;
```

>IN 子句:	

```sql
SELECT column1, column2....columnN
FROM   table_name
WHERE  column_name IN (val-1, val-2,...val-N);
```

>BETWEEN 子句:	

```sql
SELECT column1, column2....columnN
FROM   table_name
WHERE  column_name BETWEEN val-1 AND val-2;
```

>LIKE 子句:	

```sql
SELECT column1, column2....columnN
FROM   table_name
WHERE  column_name LIKE { PATTERN };
```

>ORDER BY 子句:	

```sql
SELECT column1, column2....columnN
FROM   table_name
WHERE  CONDITION
ORDER BY column_name {ASC|DESC};
```

>GROUP BY 子句:	

```sql
SELECT SUM(column_name)
FROM   table_name
WHERE  CONDITION
GROUP BY column_name;
```

>COUNT 子句:	

```sql
SELECT COUNT(column_name)
FROM   table_name
WHERE  CONDITION;
```

>HAVING 子句:	

```sql
SELECT SUM(column_name)
FROM   table_name
WHERE  CONDITION
GROUP BY column_name
HAVING (arithematic function condition);
```

>CREATE TABLE 语句:	

```sql
CREATE TABLE table_name(
column1 datatype,
column2 datatype,
column3 datatype,
.....
columnN datatype,
PRIMARY KEY( one or more columns )
);
```

>DROP TABLE 语句:	

```sql
DROP TABLE table_name;
```

>CREATE INDEX 语句 :	

```sql
CREATE UNIQUE INDEX index_name
ON table_name ( column1, column2,...columnN);
```

>DROP INDEX 语句 :	

```sql
ALTER TABLE table_name
DROP INDEX index_name;
```

>DESC 语句 :	

```sql
DESC table_name;
```

>TRUNCATE TABLE 语句:	

```sql
TRUNCATE TABLE table_name;

truncate db_label_pro.t_label_result_pro_test_new
```

>ALTER TABLE 语句:	

```sql
ALTER TABLE table_name {ADD|DROP|MODIFY} column_name {data_ype};

alter table db_label_pro.t_label_pro_test add cleaning_threshold  VARCHAR(20);
```

>ALTER TABLE 语句 (重命名) :	

```sql
ALTER TABLE table_name RENAME TO new_table_name;
alter table t_label_customer change column target_id customer_id  bigint(20) NOT NULL COMMENT '用户ID';
```

>INSERT INTO 语句:	

```sql
INSERT INTO table_name( column1, column2....columnN)
VALUES ( value1, value2....valueN);
```

>UPDATE 语句:	

```sql
UPDATE table_name
SET column1 = value1, column2 = value2....columnN=valueN
[ WHERE  CONDITION ];

update db_label_pro.t_label_pro_test set filter_rules='超重|减重|减到|严重|注重' where tag_id='L01050098_New' and is_valid=1
```

>DELETE 语句:	

```sql
DELETE FROM table_name WHERE  {CONDITION};

delete from  db_label_pro.t_label_result_pro_new where tag_id='L01050098_New'
```

>CREATE DATABASE 语句:	

```sql
CREATE DATABASE database_name;
```

>DROP DATABASE 语句:	

```sql
DROP DATABASE database_name;
```

>USE 语句:	

```sql
USE database_name;
```

>COMMIT 语句:	

```sql
COMMIT;
```

>ROLLBACK 语句:	

```sql
ROLLBACK;
```

## 用户、权限、角色

>新建用户	
```sql
create user river identified by 123;
```

>分配权限
```sql
grant dba to user river ;
grant dba to user river with admin option;
grant all on employees to river;
```

>收回权限
```sql
revoke create session, create table from river;
revoke select，update，insert on employees from river;
```

## SQL常用函数

>lpad

向左补全字符串	
```sql
select lpad('1', 4, '0') empplyee_no from dual;     --->1变成了0001
select lpad('12345', 4, '0') empplyee_no from dual;   --->截取成1234
```

>rpad	

向右补全字符串	
```sql
select rpad('1', 4, '*') empplyee_no from dual;  --->输出1***
select rpad('12345', 4, '*') empplyee_no from dual;  --->输出1234
```
>lower	

返回字符串的小写形式	
```sql
select username, password  from dba_users   where lower(username) = 'system';
```

>upper	

返回字符串的大写形式	
```sql
select username, password  from dba_users   where upper(username) = 'SYSTEM';
```

>initcap	

单词首字符大写	
```sql
select initcap('like') new_word from dual;   --->得到Like
```

>length	

返回字符串长度	
```sql
select length('12345') len from dual;   --->5
```

>substr	

截取字符串	
substr(字符串,截取开始位置,截取长度) 
```sql
select substr('123456789', 2, 3) sub_string from dual;   --->第2位开始，截取3个子字符串，即234
select substr('123456789', 2) sub_string from dual;    --->23456789
```

>instr	

获得字符串出现的位置	
INSTR(源字符串, 查找的字符串, 从第几个字符开始, 要找到第几个匹配的序号)
```sql
SELECT SUBSTR('26℃/9℃', 1, INSTR('26℃/9℃','℃',1)-1)，
SUBSTR('26℃/9℃',INSTR('26℃/9℃','/',1，1)+1,
INSTR('26℃/9℃','℃',1，2)-INSTR('26℃/9℃','/',1，1)-1)   FROM dual;   --->返回结果  26    9
```

>ltrim	

删除字符串左侧空格	
```sql
select ltrim('    000') new_str from dual;   --->000
```

>rtrim	

删除字符串右侧空格	
```sql
select rtrim('    000    ') new_str from dual;   --->    000
```

>trim	

删除字符串两侧的空格	
```sql
select trim('    000    ') new_str from dual;   --->000
```

>replace	

字符串级别的代替	
```sql
select replace('abcd','cd','ef') from dual;   ---> abef
```

>abs	

返回数字的绝对值	
```sql
select abs(-21.45) from dual;  -->21.45
```

>round	

返回数组的“四舍五入”值	
```sql
select round(4.37, 1) result from dual;  -->小数点后1位4.4
select round(456.37, -1) result from dual;  -->460，注意不是456
select round(456.37) result from dual;  -->小数位是0时可以省略，456
```

>ceil	

向上取整
```sql	
select ceil(23.45) result from dual;  -->24
```

>floor	

向下取整
```sql	
select floor(-23.45) result from dual;  -->结果为 -24
```

>mod	

取余	
```sql
select mod(5, 2) result from dual;   -->1
```

>sign	

返回数字的正负	
```sql
select sign(-10) result from dual;  -->结果为 -1
select sign(10) result from dual;   -->1
select sign(0) result from dual;    -->0
```

>sqrt	

返回数字的平方根	
```sql
select sqrt(4) result from dual;   -->2
select sqrt(-4) result from dual;  -->小于0，出错
```

>power	

乘方运算	
```sql
select power(4, 3) result from dual;   -->64
```

>trunc	

截取数字	
```sql
select trunc(3.789, 2) trunc_result  from dual;   -->小数点后两位3.78 
select trunc(3.789, 0) result from dual;  -->3
```

>chr	

将ASCLL码转换为字符	
```sql
select chr(65) character from dual;  -->A
```

>to_date	

将字符串转换成日期	
```sql
select to_date('20161010','yyyy-mm-dd') FROM dual;   --->2016-10-10
```

>to_char	

将日期转换为字符串	
```sql
SELECT to_char(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual;  ---> 2017-02-27 09:23:07
```

>to_timestamp	

将字符转换成时间戳	
```sql
SELECT to_char(to_timestamp(t.t_date,'yyyy-mm-dd hh24:mi:ss:ff3'),'yyyy-mm-dd hh24:mi:ss:ff3') 
FROM AI_TO_HEMODIALYSIS_ALL t
```

>sysdate	

系统时间	
```sql
select SYSDATE FROM dual   --->2017-02-23 19:29:13
```

>max	

最大值	
```sql
select max(employee_age) max_age from employees;   -->37
```

>min	

最小值	
```sql
select min(employee_age) min_age from employees;   -->7
```

>avg	

平均值	
```sql
select avg(employee_age) avg_age from employees;   -->26.8888888
```

>sum	

求和	
```sql
select sum(employee_age) sum_age from employees;   -->242
```

>count	

计数	
```sql
select count(*) from employees; 
select count(1) from employees;
select count(employee_name) , count(employee_position) from employees;   
-->返回 9  8，当列值为空时，count（）函数不进行计数
```

>decode	

多值判断	
```sql
select  employee_name,                                                                      
decode(sign(instr(employee_position, '工程师')), 1, '技术部', '管理部')  from employees;  
select  decode(substr(gxjsqy_tech_value,1,2)
, '01'，'电子信息技术'，'02'，'生物与新医药技术'，''） from gq_organization_info
```
>nvl	

空值处理	
```sql
select employee_name, nvl(salary, 0) from  salary     
```

>rownum	

结果集行号	
```sql
select e.employee_id, e.employee_name, rownum from employees e;  
```

>between	

范围	
```sql
select * from employees where employee_age between 26 and 35;
```

>in	

集合成员	
```sql
select employee_name from employees                                                 
where employee_id in (select distinct employee_id from salary);
```

>like	

模糊匹配	
```sql
select employee_name from employees where employee_name like '钟%';  -->钟小平  钟文
select employee_name from employees where employee_name like '钟_';  -->钟文
select employee_name from employees where employee_name like '钟__';  -->钟小平
```

>null	

空值判断	
```sql
select * from employees  where employee_id is not null and employee_name is  null 
```

>exists	

存在性判断	
```sql
select * from employees e where exists(select 1 from salary s where s.employee_id = e.employee_id);
select * from employees e where e.employee_id in (select s.employee_id from salary s ）  -->等价
```

>all		

获得年龄大于所有工程师的员工信息
```sql
select * from employees e  where age> all( select age from employees where position='工程师');   
select * from employees e where age> ( select max(age) from employees where position='工程师');
```
>some		

>any		
```sql
select * from employees e where age> any(select age from employees where position='工程师');  
select * from employees e where age> ( select min(age) from employees where position='工程师'); 
```

>rank		

>dense_rank		

>row_number

组内编号	
```sql
select row_number() OVER(PARTITION BY t.c_case_no,t.t_date,T.n_item_id ORDER BY t.c_case_no,t.t_date,T.n_item_id DESC) RK,t.*
from AI_TO_HEMODIALYSIS_ALL_D t
```

>first_value	


>last_value	


>lag		


>lead		


>case when		
```sql
SELECT ENAME 名字, SAL 原工资,
       CASE JOB WHEN 'CLERK' THEN SAL * 1.1
                 WHEN 'SALESMAN' THEN SAL * 1.2
                 WHEN 'MANAGER' THEN SAL * 1.3
                 ELSE SAL * 1.5 END 新工资
>FROM EMP;
```

>coalesce	


>nvl2		


>nullif	


1.3 数据库连接

