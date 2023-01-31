# 数据类型

## 基础数据类型

|  类型  |    默认值    |             示例              |
| :----: | :----------: | :---------------------------: |
|  INT   |      0       |    SumAccum<int> @off = 0;    |
|  UINT  |      0       |                               |
| FLOAT  |     0.0      |                               |
| DOUBLE |     0.0      |  MaxAccum<DOUBLE> @latitude;  |
|  BOOL  |    false     |   OrAccum @busnameUpdated;    |
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





# 构建Schema

## 新建图数据库



## 节点构建





## 边构建















