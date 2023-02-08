# 数据类型

## 基础数据类型

|  类型  |    默认值    |             示例              |
| :----: | :----------: | :---------------------------: |
|  INT   |      0       |    SumAccum<int> @off = 0;    |
|  UINT  |      0       |                               |
| FLOAT  |     0.0      |                               |
| DOUBLE |     0.0      |  MaxAccum<DOUBLE> @latitude;  |
|  BOOL  |    false     |                               |
| STRING | Empty string | ListAccum<string> @tpnd_name; |



## 高级数据类型

|        类型         |   默认值   | 示例 |
| :-----------------: | :--------: | :--: |
|      DATETIME       | UTC time 0 |      |
| FIXED_BINARY(**n**) |    N/A     |      |



## 集合类型

| 类型 | 说明                                                         |                             示例                             |
| :--: | :----------------------------------------------------------- | :----------------------------------------------------------: |
| LIST | 默认值：[]<br />支持类型：INT, DOUBLE, STRING, DATETIME, UDT | ListAccum<double> @@emptyList;<br />ListAccum<edge>@@listedge; |
| SET  | 默认值：（)<br />支持类型：INT, DOUBLE, STRING, DATETIME, UDT | SetAccum<int> @topoID1;<br />SetAccum<edge> @@main_island_setedge; |
| MAP  | 默认值：空MAP<br />key支持类型：INT, STRING, DATETIME<br />value支持类型：INT, DOUBLE, STRING, DATETIME, UDT |                  MapAccum<int, double> @G;                   |



## 自定义元组



```c++
typedef tuple<int exId, int ep, double M_Vm, double M_Va, double GenP, double GenQ, double LdP, double LdQ, double M_C_P> sort_vertex_NTPUpdate;

HeapAccum<sort_vertex_NTPUpdate>(1000000000, exId asc) @@vertex; 

...
POST-ACCUM
@@vertex += sort_vertex_NTPUpdate(
                s.exId, // 编号
                s.@alldgr, // 关联节点数量
                s.@M_Vm,  // 有功量测
                s.@M_Va, // 相角量测
                s.@GenP, // 发电机有功
                s.@GenQ, // 发电机无功
                s.@LdP, // 负荷有功
                s.@LdQ, // 负荷无功
                s.@M_C_P // 电容无功
                );
```



# 累加器



# 流程结构

## if

```c++
if s.@flagM == 1 then 
	t.@dis_point = s.@statusM,
	@@discrete_counter += 1
else 
	t.@dis_point = s.status
end
```



```shell
if s.@busnameUpdated==false then
	s.@bus_name = t.name,
	s.@busnameUpdated += true
end
```



## foreach

```
FOREACH x in t.today DO
	IF isOneDay(timestamp, x.t) THEN
		t.@tempListAccum2+=x
	END
END
```



## when



## while



# 构建Schema

## 新建图数据库



## 节点构建





## 边构建



# 常用命令

```shell
gadmin --help

gadmin status

gadmin start all

gadmin restart -y

gadmin start gpe

gadmin license status

gsql -g gsql_EMS initiateMeasPoint.gsql
gsql -g gsql_EMS 'install query initiateMeasPoint'
gsql -g gsql_EMS 'run query initiateMeasPoint()'

gadmin -g graphdb "install query all"
```



# 应用场景

## 更新license

（1）更新license

```shell
gadmin license set eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJc3N1ZXIiOiJUaWdlckdyYXBoIEluYy4iLCJBdWRpZW5jZSI6IlRpZ2VyR3JhcGggRnJlZSIsIlN0YXJ0VGltZSI6MTY2MzIzMjc2MiwiRW5kVGltZSI6MTY5NzM2NDM2MiwiSXNzdWVUaW1lIjoxNjYzMjM2MzYyLCJFZGl0aW9uIjoiRW50ZXJwcmlzZSIsIlZlcnNpb24iOiJBbGwiLCJIb3N0Ijp7Ik1heENQVUNvcmUiOjEwMDAwMDAwMDAwMDAwMDAsIk1heFBoeXNpY2FsTWVtb3J5Qnl0ZXMiOjEwMDAwMDAwMDAwMDAwMDAsIk1heENsdXN0ZXJOb2RlTnVtYmVyIjoxMDI0fSwiVG9wb2xvZ3kiOnsiTWF4VmVydGV4TnVtYmVyIjoxMDAwMDAwMDAwMDAwMDAwLCJNYXhFZGdlTnVtYmVyIjoxMDAwMDAwMDAwMDAwMDAwLCJNYXhHcmFwaE51bWJlciI6MTAyNCwiTWF4VG9wb2xvZ3lCeXRlcyI6NTM2ODcwNjM3MTJ9LCJHU1QiOnsiRW5hYmxlIjp0cnVlLCJab29tQ2hhcnRzTGljZW5zZSI6IntcbiAgXCJsaWNlbnNlXCI6IFwiWkNCLTI5Z3A4aWN5MTogWm9vbUNoYXJ0cyBQcm9kdWN0aW9uIGxpY2VuY2UgZm9yIFRpZ2VyR3JhcGggZm9yIG9mZmxpbmUgdXNlOyB1cGdyYWRlcyB1bnRpbDogMjAyMy0wOC0xNlwiLFxuICBcImxpY2Vuc2VLZXlcIjogXCI4MjE1N2MyNjlmYmFjZDU3ZTc0MDFjYTc1ZjI4MDk3YzllNjBkYjQ2ZjRkNzEzMzgzZDQzM2FiYzczNjdkOTE1MzRhYjJmOTY5OTYyY2YwZThhYzVlZjRiMzE5MThhOGFmNDg2YjFiMzFlNzM4MGQ0ZDEyYWIyMWNhZGY3ZTFjMTUyYzZlNzRiNjk0ZjI2ZWYwMDRlZWExYWE5YTE0YTVmYmExM2I5NzBlZDhlYmNiMDFkYmQ3N2FhYmZjYjcwZGQyZjlkZTdmNzRlNWUxNjU0MjJmODIwNjVmYjBkMTAzNTVkZTRlN2YwODczMDMzZTUzZjVjMWMyZjUwOTlhNDc0MDg5NmEwMzEyNmFkNWU2ZjJkYTk5MzA0ZDU3M2FjYWI5ZTQ4OTFlODYxMzJlNTNhNTdjYTVjMjA4YWE3ZmI0MzBmMzdmMTdmNmM4MWY0NzBhNGM4OWU0OGMyMmMwOTQ1YWViNzA5YTY2YjRlNjQwOWFhYjc3YWM1NjAwNjZjYzYxMzA3ZjM1MGIyNzI1NzFlNzM3OGVhYWM5OTcwYTEwMjdkOWU1NjYwMmJjMDBkMmVmYTA3ZGFhYjcyMGMzMWM2NzllM2VlZGZiNDY3NmU4NjNhNGFkNDE3ZTUwZWYzYjg3MTVlNWMyZGJlYTkyNDAwZGZmOGIwZjE2ODUxN2JkOVwiXG59In0sIlJ1bnRpbWVNZW1vcnkiOnsiTWF4VXNlclJlc2lkZW50U2V0Qnl0ZXMiOjEwMDAwMDAwMDAwMDAwMDB9fQ.ZzJHTrbVOqyOANiKf4NFZy5updZOyZds9_aDArL0rpG9MmiDCBOw-72nX9fMYNomzicEDpO-REHRqhhAf6kbCwAxNmzXLpjmbDROW-cyKefjCKQbpYae13VMzpMRuB6mh2QjgQ_9b3uWjyDAXcfd6CIdrWJ1FeyCM8iVQrnW34f5jkAVajOT6NpSO4wXYwnmPll3H-vluo7d4GE_tQr7X6EpdRDLNT3W2pJ2Cz71QoMoJ_dzbkZpMQrVuFukq8SvqjvGQkDjITaJCM0l86-YTMy4uEhIclUOHF0vJ433jGQmHKRtCQaS4jpasnGam8T60OIBpKiYwRpy7o0Zn28pbQ
```

（2）应用配置

```shell
gadmin config apply
```

（3）重启服务

```shell
gadmin restart -y
```



