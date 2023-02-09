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

## MapAccum

```c++
...
  MapAccum<STRING, ListAccum<double>> @@from_CP_list;  
  MapAccum<STRING, ListAccum<double>> @@to_CP_list;
 ...
  
@@from_CP_list += (convertToString(s.TOPOID) + "_" + convertToString(t.TOPOID) -> get_CP_list(e.edge_name, t.@tpnd_name, t.@tpnd_Q_meas)),

@@to_CP_list += (convertToString(s.TOPOID) + "_" + convertToString(t.TOPOID) -> get_CP_list(e.edge_name, t.@tpnd_name, t.@tpnd_Q_meas)),  // +++


   V_TopoSet = SELECT s
               FROM V_TPND:s - (topo_connect>:e) - (TopoND):t
               ACCUM
                  
                  double from_CP = 0,
                  double to_CP = 0,
                  @@count_edge += 1,
                  string e_key = convertToString(s.TOPOID) + "_" + convertToString(t.TOPOID),
                  
                  IF (@@from_CP_list.containsKey(e_key)) THEN
                        FOREACH i in @@from_CP_list.get(e_key) DO
                            from_CP = from_CP + i
                        END
                  END,
                  e.from_CP = from_CP,
  
                  IF (@@to_CP_list.containsKey(e_key)) THEN
                        FOREACH i in @@to_CP_list.get(e_key) DO
                            to_CP = to_CP + i
                        END
                  END,
                  e.to_CP = to_CP;
```



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





# 代码参考



## 数据更新

**（1）节点更新**

```shell
curl -X POST -d '{"vertices": {"meas": {"114560315689009434": {"P": {"value": 0.0}, "Q": {"value": 0.0}}, "114560315689009764": {"P": {"value": 0.0}, "Q": {"value": 0.0}}, "114560315689014113": {"P": {"value": 0.0}, "Q": {"value": 0.0}}}}}' "http://localhost:9000/graph/gd_graph"
```

**（2）关系更新**

```shell
curl -X POST -d '{"edges": {"TopoND": {"1200064010002025": {"topo_connect": {"TopoND": {"1200064010026117": {"M_P_TLPF": {"value": 0.1632}, "M_Q_TLPF": {"value": 0.028999999999999998}}}}}}}}' "http://localhost:9000/graph/gd_graph"
```



## 数据删除

**（1）删除节点数据**

```sql
CREATE QUERY Delete_TopoND(/* Parameters here */) FOR GRAPH graph_guangdong { 
  TopoND_set = {TopoND.*};
  delete t from TopoND_set:t;
  print TopoND_set;
}
```

**（2）删除所有数据**

```sql
CREATE QUERY delete_all(/* Parameters here */) FOR GRAPH graph_guangdong { 
  all_set = {ANY};
  delete t from all_set:t;
  print all_set.size();
}
```



## 数据导出

**（1）节点数据导出**

```sql
CREATE QUERY out_TopoND(/* Parameters here */) FOR GRAPH graph_guangxi { 
  FILE outputfile ("/home/tigergraph/TopoND.csv");
  
  T0 = {TopoND.*};
  T1 = select t from T0:t where t.island == 1;
  print T1;
  print "exId,bus_name,busType,base_kV,desired_volts,SE_Va,SE_Vm" TO_CSV outputfile;
  print T1.exId, T1.bus_name, T1.busType, T1.base_kV, T1.desired_volts, T1.SE_Va, T1.SE_Vm TO_CSV outputfile;

}
```

**（2）IEEE格式输出**

```sql
drop query printIEEEModel
CREATE QUERY printIEEEModel() FOR GRAPH gsql_EMS{
  typedef tuple<int Bus_i, int bustype, double Pd, double Qd, double G, double B, int Area, double Vm, double Va, double baseKV, int zone, double Vmax, double Vmin> sort_vertex;
  
  typedef tuple<int Bus, double Pg, double Qg, double Qmax, double Qmin, double Vg, int mBase, int status, double Pmax, double Pmin, double Pc1, double Pc2, double Qc1min, double Qc2min, double Qc2max, double amp_agc, double Ramp_10, double Ramp_30> sort_gen;
  
  typedef tuple<int fbus, int tbus, double er, double ex, double eb, double rateA, double rateB, double rateC, double ratio, int angle, int Status, int angmin, int angmax> sort_edge;
  
  SumAccum<double> @P_max;
  HeapAccum<sort_vertex>(1000000000, Bus_i asc) @@vertex;
  HeapAccum<sort_gen>(1000000000, Bus asc) @@gen;
  HeapAccum<sort_edge>(1000000000, fbus asc, tbus asc) @@edge;

  FILE file1 ("/home/tigergraph/output/branchmatrix_graphoutput.csv");
  FILE file2 ("/home/tigergraph/output/busmatrix_graphoutput.csv");
  FILE file3 ("/home/tigergraph/output/genmatrix_graphoutput.csv");

  measSet = {meas.*};
  Tsub = {Substation.*};

  T0= {TopoND.*};
 
  T0 = select s from T0:s-(topo_connect:e)-TopoND:t
     where s.island == 1 and t.island == 1
     accum
       @@edge += sort_edge(s.exId, t.exId, e.G/(e.G*e.G + e.B*e.B), e.B/(e.G*e.G + e.B*e.B), e.hB, e.line_Q1*100, e.line_Q2*100, e.line_Q3*100, e.transformer_final_turns_ratio, 0, 1, -360, 360)
     post-accum
       @@vertex += sort_vertex(s.exId, s.busType, s.M_Load_P*100, s.M_Load_Q*100, s.G, s.B, 0, 1.0, 0, s.base_kV, 0, 1.1, 0.9);
     
  TGen =  select s from T0:s-(topo_unit:e)-:t
     accum
       s.@P_max += t.P_max
     post-accum
       @@gen += sort_gen(s.exId, s.M_Gen_P*100, s.M_Gen_Q*100, s.qUp*100, s.qLower*100, 1, 100, 1, s.@P_max, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  print "fbus,tbus,r,x,b,rateA,rateB,rateC,ratio,angle,Status,angmin,angmax" TO_CSV file1;
  print "Bus_i,type,Pd,Qd,Gs,Bs,Area,Vm,Va,baseKV,zone,Vmax,Vmin" TO_CSV file2;
  print "Bus,Pg,Qg,Qmax,Qmin,Vg,mBase,status,Pmax,Pmin,Pc1,Pc2,Qc1min,Qc2min,Qc2max,amp_agc,Ramp_10,Ramp_30" TO_CSV file3;

  foreach x in @@edge do
      print x.fbus, x.tbus, x.er, x.ex, x.eb, x.rateA, x.rateB, x.rateC, x.ratio, x.angle, x.Status, x.angmin, x.angmax TO_CSV file1;
  end;
  
  foreach x in @@vertex do
      print x.Bus_i, x.bustype, x.Pd, x.Qd, x.G, x.B, x.Area, x.Vm, x.Va, x.baseKV, x.zone, x.Vmax, x.Vmin TO_CSV file2;
  end;
  foreach x in @@gen do
      print x.Bus, x.Pg, x.Qg, x.Qmax, x.Qmin, x.Vg, x.mBase, x.status, x.Pmax, x.Pmin, x.Pc1, x.Pc2, x.Qc1min, x.Qc2min, x.Qc2max, x.amp_agc, x.Ramp_10, x.Ramp_30 TO_CSV file3;
  end;

 }

install query -ui printIEEEModel
```



## 数据输出

**（1）print输出**

```sql
CREATE QUERY A_print_info(/* Parameters here */) FOR GRAPH gsql_EMS { 
  TopoND_set = {TopoND.*};
  print TopoND_set.size();
  
  TopoND_island_set = SELECT s from TopoND_set:s where s.island == 1 limit 10;
  print TopoND_island_set;
  
  TopoND_island_set = SELECT s from TopoND_island_set:s where s.exId >= 1 or s.exId <= 10;
  print TopoND_island_set[TopoND_island_set.SE_Va, TopoND_island_set.SE_Vm];
}
```



**（2）log输出**

```

```

## 数据生成

create_GXPF_example_schema.gsql

```c++
/*
1、创建数据库GXPF_example
2、创建schema，共42个节点类型、150个关系类型
*/
// clear graph store -HARD

typedef tuple<caFromBus int, caToBus int, violFromBus int, violToBus int, violation_perc double, edgeID int, edgename string (50), device_type string (50), volt string (50), from_bus_name string (50), to_bus_name string (50), CA_bridge int> ca_linedetail
typedef tuple< caFrom int, caTo int, pfViolFrom uint, pfViolTo uint, pfViolTpye int, pfViolFrom_Name string (50), pfViolTo_Name string (50), line_Q1 double, pfSeverity double, edgeID int, vio_type string (50)> ca_pf_detail

typedef tuple< v double,  t string (50)> carbon_hist_info
typedef tuple< p double,  q double, est_p double,  est_q double, t string (50)> meas_hist_info

// docker:/home/tigergraph/tigergraph/tmp/gsql/codegen/udt
// 创建数据库
// create graph GXPF_example()
USE GRAPH graph_ts
DROP JOB create_GXPF_example_schema
CREATE SCHEMA_CHANGE JOB create_GXPF_example_schema FOR GRAPH graph_ts {

    ADD VERTEX from_node (PRIMARY_ID id int, f_id int, value_f double);
    ADD VERTEX to_node (PRIMARY_ID id int, t_id int, value_t double);
    ADD UNDIRECTED edge ft_edge(from from_node, to to_node, value_e double);
}

RUN SCHEMA_CHANGE JOB create_GXPF_example_schema
```

insert_data.gsql

```c++
CREATE QUERY insert_data(/* Parameters here */) FOR GRAPH graph_ts { 
  FOREACH i in range [1, 1000010] DO
      insert into from_node VALUES(10000000 + i, 10000000 + i, 1.1);
      insert into to_node VALUES(20000000 + i, 20000000 + i, 1.2);
      insert into ft_edge VALUES(10000000 + i, 20000000 + i, 1.12);
  END;
}
```



## 数据查看

### 节点数据查看

#### 变压器

```sql
CREATE QUERY Ehe_graph_info(/* Parameters here */) FOR GRAPH gd_graph { 
    ListAccum<edge> @@edgeList;

  two_trans = {two_port_transformer.*};
  two = select t from two_trans:s - ((txI_txJ_transformerline|txJ_txI_transformerline):e) - two_port_transformer:t
        where t.name == "佛山.环保电厂";
  
  sub = {Substation.*};
  sub_all = select t from sub:s -(:e) -:t 
            where s.name=="佛山.环保电厂";
  
  data_all = select t from sub_all -((Meas_trans2|topo_Tx_Two|basevoltage_twoxformer|voltagelevel_twoxformer|stvl_twoxformer|CN_tx_two|txI_txJ_transformerline|txJ_txI_transformerline|two_tap_winding):e)-two_port_transformer:t
  ACCUM @@edgeList +=e;
  
  print(data_all);
  print(@@edgeList);
}
```



### 变电站设备连接情况

```sql
CREATE QUERY E04_topo_q(/* Parameters here */) FOR GRAPH gd_graph { 
  ListAccum<edge> @@edgeList;
  topo = {TopoND.*};
  topo_a = select t from topo:t where t.Sub == "佛山.环保电厂";
  //print(topo_a);
  
  sub = {Substation.*};
  sub_all = select t from sub:s -((cn_subid|topoid_subid|sub_cn|sub_generatingunit|connected_Sub_Compensator_S|connected_Sub_Aclinedot|connected_Sub_Breaker|connected_Sub_Bus|connected_Sub_Compensator_P|connected_Sub_Disconnector|connected_Sub_GroundDisconnector|connected_Sub_Load|connected_Sub_Trans_two|connected_Sub_Trans_three|connected_Sub_Unit):e) -:t 
  where s.name=="佛山.环保电厂";
  
  data_all = select t from sub_all -((topo_connect|topo_bus|topo_Tx_Two|topo_Tx_Three|topo_unit|topo_load|topo_compensatorP|topo_aclinedot|topo_neutral|aclinedot_cn|connected_Breaker_CN|connected_Bus_CN|connected_Compensator_P_CN|connected_Compensator_S_CN|connected_Disconnector_CN|connected_GroundDisconnector_CN|connected_Load_CN|connected_Unit_CN|CN_tx_three|neutral_three|CN_tx_two|txI_txJ_transformerline|txJ_txI_transformerline|aclinedot_aclinedot|aclinedot_aclinedot_reverse|generating_unit):e)-:t
  ACCUM @@edgeList +=e;
  
  print(sub_all);
  print(@@edgeList);
}
```

