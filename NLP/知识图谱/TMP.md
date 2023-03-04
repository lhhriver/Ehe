```sql
match p = (bd:Breaker|Disconnector{point:"0", "Substation":'百色.110kV宾至站'})-[:(connected_Bus_CN|connected_Unit_CN|connected_Breaker_CN|connected_Disconnector_CN)*1..10]-(bs:BUS|unit{"Substation":'百色.110kV宾至站'})
return p 
```

```sql
match (bd:Breaker|Disconnector) where bd.point="0" and bd.Substation='百色.110kV宾至站'
match (bs:)
match p = (bd:Breaker|Disconnector{point:"0", "Substation":'百色.110kV宾至站'})-[:(connected_Bus_CN|connected_Unit_CN|connected_Breaker_CN|connected_Disconnector_CN)*1..10]-(bs:BUS|unit{"Substation":'百色.110kV宾至站'})
return p 
```

```sql
match (bd:Breaker|Disconnector) where bd.point="0" and bd.Substation='百色.110kV宾至站'
match (bs:BUS|unit) where bs.Substation='百色.110kV宾至站'
match p = (bd)-[:(connected_Bus_CN|connected_Unit_CN|connected_Breaker_CN|connected_Disconnector_CN)*1..5]-(bs)
return p 
```



```sql
match p1=(ba:BUS|unit|l_oad|C_P|two_port_transformer|three_port_transformer|ACline_dot)-[:(connected_Bus_CN|connected_Unit_CN|connected_Load_CN|connected_Compensator_P_CN|CN_tx_two|CN_tx_three|aclinedot_cn)]-(cn:CN)
return nodes(p1)
```

```sql
match p2=(cn:CN)-[:connected_Breaker_CN|connected_Disconnector_CN]-(bd:Breaker|Disconnector) 
where bd.point="0"
return nodes(p2)
```

