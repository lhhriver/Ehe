# CIM数据

## ACLineSegment

交流线段类

```xml
<cim:ACLineSegment rdf:ID="116530641029300226">
        <cimNC:ACLineSegment.EndST rdf:resource="#113997366238904343"/>
        <cimNC:ACLineSegment.EqFlag>ACLineEqFlag.general</cimNC:ACLineSegment.EqFlag>
        <cimNC:ACLineSegment.StartST rdf:resource="#113997366238904413"/>
        <cimNC:ACLineSegment.devState rdf:resource="http://www.naritech.cn/CIM/ext-schema#DevState.run"/>
        <cimNC:ACLineSegment.ratedCurrent>1000.000000</cimNC:ACLineSegment.ratedCurrent>
        <cim:ConductingEquipment.BaseVoltage rdf:resource="#112871466332061698"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#116812116006010884"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#116812116006010883"/>
        <cim:Conductor.bch>0.000000</cim:Conductor.bch>
        <cim:Conductor.r>0.940800</cim:Conductor.r>
        <cimNC:Conductor.rPU>0.711380</cimNC:Conductor.rPU>
        <cim:Conductor.ratedA>1000.000000</cim:Conductor.ratedA>
        <cim:Conductor.x>3.566000</cim:Conductor.x>
        <cimNC:Conductor.x0>0.000000</cimNC:Conductor.x0>
        <cimNC:Conductor.xPU>2.696408</cimNC:Conductor.xPU>
        <cim:Naming.name>110大里Ⅰ线</cim:Naming.name>
</cim:ACLineSegment>
```



## BaseVoltage
```xml
<cim:BaseVoltage rdf:ID="112871466332061697">
        <cimNC:BaseVoltage.name>10.5kV</cimNC:BaseVoltage.name>
        <cimNC:BaseVoltage.nominalI>0.000000</cimNC:BaseVoltage.nominalI>
        <cim:BaseVoltage.nominalVoltage>10.500000</cim:BaseVoltage.nominalVoltage>
        <cimNC:BaseVoltage.v_exm>12.000000</cimNC:BaseVoltage.v_exm>
</cim:BaseVoltage>
```

## Bay
```xml
<cim:Bay rdf:ID="114278841349832705">
        <cim:Bay.MemberOf_Substation rdf:resource="#113997366238904340"/>
        <cim:Bay.MemberOf_VoltageLevel rdf:resource="#113152941442990122"/>
        <cim:Naming.name>100间隔</cim:Naming.name>
</cim:Bay>
```

## Breaker

断路器类

```xml
<cim:Breaker rdf:ID="114560316192325656">
        <cimNC:Breaker.breakType rdf:resource="http://www.naritech.cn/CIM/ext-schema#BreakType.general"/>
        <cim:ConductingEquipment.BaseVoltage rdf:resource="#112871466332061698"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#114560316192325656_T1"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#114560316192325656_T2"/>
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941308772357"/>
        <cim:Naming.name>103开关</cim:Naming.name>
        <cim:Switch.normalOpen>true</cim:Switch.normalOpen>
</cim:Breaker>
```

## BusbarSection

母线段类

```xml
<cim:BusbarSection rdf:ID="115404741122457611">
        <cim:ConductingEquipment.BaseVoltage rdf:resource="#112871466332061698"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#115404741122457611_T1"/>
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941308772357"/>
        <cim:Naming.aliasName>110kV#1母线</cim:Naming.aliasName>
        <cim:Naming.name>110kV#1母线</cim:Naming.name>
</cim:BusbarSection>
```

## Compensator
```xml
<cim:Compensator rdf:ID="117938015912853512">
        <cim:Compensator.compensatorType rdf:resource="http://iec.ch/TC57/2003/CIM-schema-cim10#CompensatorType.shunt"/>
        <cim:Compensator.nominalMVAr>60.000000</cim:Compensator.nominalMVAr>
        <cim:Compensator.nominalkV>38.500000</cim:Compensator.nominalkV>
        <cim:ConductingEquipment.BaseVoltage rdf:resource="#112871466332061707"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#117938015912853512_T1"/>
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941308772358"/>
        <cim:Naming.name>S311电容器</cim:Naming.name>
</cim:Compensator>
```

## ConnectivityNode
```xml
<cim:ConnectivityNode rdf:ID="4000002040002008">
        <cim:ConnectivityNode.MemberOf_EquipmentContainer rdf:resource="#113152941308773062"/>
        <cim:Naming.name>4000002040002008</cim:Naming.name>
</cim:ConnectivityNode>
```

## Disconnector

刀闸类

```xml
<cim:Disconnector rdf:ID="114841791169036313">
        <cim:ConductingEquipment.BaseVoltage rdf:resource="#112871466332061698"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#114841791169036313_T1"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#114841791169036313_T2"/>
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941308772357"/>
        <cim:Naming.name>1031刀闸nn</cim:Naming.name>
</cim:Disconnector>
```

## EnergyConsumer

电能用户类

```xml
<cim:EnergyConsumer rdf:ID="115967691075878979">
        <cim:ConductingEquipment.BaseVoltage rdf:resource="#112871466332061707"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#115967691075878979_T1"/>
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941308772375"/>
        <cim:Naming.name>35kV负荷</cim:Naming.name>
</cim:EnergyConsumer>
```

## GeneratingUnit
```xml
<cim:GeneratingUnit rdf:ID="115686216149499905_UNIT">
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941359104226"/>
        <cim:GeneratingUnit.maximumOperatingMW>80.000000</cim:GeneratingUnit.maximumOperatingMW>
        <cim:GeneratingUnit.minimumOperatingMW>-80.000000</cim:GeneratingUnit.minimumOperatingMW>
        <cim:GeneratingUnit.raiseRampRate>0.000000</cim:GeneratingUnit.raiseRampRate>
        <cim:Naming.name>蜜源风电场等值机</cim:Naming.name>
</cim:GeneratingUnit>
```

## GroundDisconnector
```xml
<cim:GroundDisconnector rdf:ID="115123266145747002">
        <cim:ConductingEquipment.BaseVoltage rdf:resource="#112871466332061700"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#115123266145747002_T1"/>
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941308772473"/>
        <cim:Naming.name>71137接地刀闸</cim:Naming.name>
        <cim:Switch.normalOpen>true</cim:Switch.normalOpen>
</cim:GroundDisconnector>
```

## HydroGeneratingUnit
```xml
<cim:HydroGeneratingUnit rdf:ID="115686216166277121_UNIT">
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941375881369"/>
        <cim:GeneratingUnit.maximumOperatingMW>20.000000</cim:GeneratingUnit.maximumOperatingMW>
        <cim:GeneratingUnit.minimumOperatingMW>0.000000</cim:GeneratingUnit.minimumOperatingMW>
        <cim:GeneratingUnit.raiseRampRate>0.000000</cim:GeneratingUnit.raiseRampRate>
        <cim:Naming.name>1号机组901</cim:Naming.name>
</cim:HydroGeneratingUnit>
```

## Line
```xml
<cim:Line rdf:ID="116249166186807297">
        <cimNC:Line.lnSecNum>0</cimNC:Line.lnSecNum>
        <cim:Naming.name>110kV安桥东高线</cim:Naming.name>
</cim:Line>
```

## Measurement

```xml
<cim:Measurement rdf:ID="114560487991017496">
        <cim:Measurement.MeasurementType rdf:resource="#40740"/>
        <cim:Measurement.MemberOf_PSR rdf:resource="#114560316192325656"/>
        <cimNC:Measurement.ifYk>false</cimNC:Measurement.ifYk>
        <cim:Naming.name>百龙滩电厂_103开关-Pos</cim:Naming.name>
</cim:Measurement>
```

## MeasurementType
```xml
<cim:MeasurementType rdf:ID="40740">
        <cim:Naming.name>SwitchPosition</cim:Naming.name>
</cim:MeasurementType>
```

## PowerTransformer

电力变压器类

```xml
<cim:PowerTransformer rdf:ID="117093590982721539">
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113997366238904323"/>
        <cim:Naming.name>#1主变</cim:Naming.name>
        <cimNC:PowerTransformer.PowerTransformerType rdf:resource="http://www.naritech.cn/CIM/ext-schema#PowerTransformerType.gsuTransformer"/>
        <cimNC:PowerTransformer.excitingCurrent>0.000000</cimNC:PowerTransformer.excitingCurrent>
        <cimNC:PowerTransformer.ifTerm>False</cimNC:PowerTransformer.ifTerm>
        <cimNC:PowerTransformer.noLoadLoss>0.000000</cimNC:PowerTransformer.noLoadLoss>
</cim:PowerTransformer>
```

## SubControlArea

```xml
<cim:SubControlArea rdf:ID="113715891262193666">
        <cim:Naming.name>广西中调</cim:Naming.name>
        <cimNC:SubControlArea.MemberOf_ControlArea rdf:resource="#113715891262193665"/>
</cim:SubControlArea>
```

## Substation

变电站

```xml
<cim:Substation rdf:ID="113997366238904323">
        <cimNC:FacGraph.name>gx_广西_220kV_八一变电站.fac.pic.g</cimNC:FacGraph.name>
        <cim:Naming.name>八一变电站</cim:Naming.name>
        <cim:Substation.MaxBaseVoltage rdf:resource="#112871466332061703"/>
        <cim:Substation.MemberOf_SubControlArea rdf:resource="#113715891262193666"/>
        <cimNC:Substation.substationType rdf:resource="http://www.naritech.cn/CIM/ext-schema#SubstationType.trans"/>
        <cim:Substation.x>109.250000</cim:Substation.x>
        <cim:Substation.y>23.940001</cim:Substation.y>
</cim:Substation>
```

## SynchronousMachine

同步电机类

```xml
<cim:SynchronousMachine rdf:ID="115686216099168258">
        <cim:ConductingEquipment.BaseVoltage rdf:resource="#112871466332061702"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#115686216099168258_T1"/>
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941308772560"/>
        <cim:Naming.name>#1机</cim:Naming.name>
        <cim:SynchronousMachine.MemberOf_GeneratingUnit rdf:resource="#115686216099168258_UNIT"/>
        <cimNC:SynchronousMachine.devState rdf:resource="http://www.naritech.cn/CIM/ext-schema#DevState.run"/>
        <cim:SynchronousMachine.maximumMVAr>198.320007</cim:SynchronousMachine.maximumMVAr>
        <cimNC:SynchronousMachine.maximumMW>320.000000</cimNC:SynchronousMachine.maximumMW>
        <cim:SynchronousMachine.minimumMVAr>-76.000000</cim:SynchronousMachine.minimumMVAr>
        <cimNC:SynchronousMachine.minimumMW>0.000000</cimNC:SynchronousMachine.minimumMW>
        <cimNC:SynchronousMachine.nodeType rdf:resource="http://www.naritech.cn/CIM/ext-schema#SynchronousMachineType.other"/>
        <cimNC:SynchronousMachine.raiseRampRate>0.000000</cimNC:SynchronousMachine.raiseRampRate>
        <cim:SynchronousMachine.ratedMVA>320.000000</cim:SynchronousMachine.ratedMVA>
        <cimNC:SynchronousMachine.ratedMW>0.000000</cimNC:SynchronousMachine.ratedMW>
        <cimNC:SynchronousMachine.synchronousMachineType rdf:resource="http://www.naritech.cn/CIM/ext-schema#SynchronousMachineType.thermal"/>
</cim:SynchronousMachine>
```

## TapChanger

分接头调节器类

```xml
<cim:TapChanger rdf:ID="117375065959432199_TAP">
        <cim:Naming.name>广西11791.25</cim:Naming.name>
        <cim:TapChanger.TransformerWinding rdf:resource="#117375065959432199"/>
        <cim:TapChanger.highStep>17</cim:TapChanger.highStep>
        <cim:TapChanger.lowStep>1</cim:TapChanger.lowStep>
        <cim:TapChanger.neutralStep>9</cim:TapChanger.neutralStep>
        <cim:TapChanger.stepVoltageIncrement>-1.250000</cim:TapChanger.stepVoltageIncrement>
</cim:TapChanger>
```

## TapChangerType
```xml
<cim:TapChangerType rdf:ID="117656540265054291">
        <cim:Naming.name>广西117111.25</cim:Naming.name>
        <cim:TapChangerType.highStep>17</cim:TapChangerType.highStep>
        <cim:TapChangerType.lowStep>1</cim:TapChangerType.lowStep>
        <cim:TapChangerType.neutralStep>11</cim:TapChangerType.neutralStep>
        <cim:TapChangerType.stepVoltageIncrement>-1.250000</cim:TapChangerType.stepVoltageIncrement>
</cim:TapChangerType>
```

## Terminal
```xml
<cim:Terminal rdf:ID="114560316192325656_T1">
        <cim:Naming.name>103开关_T1</cim:Naming.name>
        <cim:Terminal.ConductingEquipment rdf:resource="#114560316192325656"/>
        <cim:Terminal.ConnectivityNode rdf:resource="#4000004040002005"/>
</cim:Terminal>
```

## ThermalGeneratingUnit

火电机组类

```xml
<cim:ThermalGeneratingUnit rdf:ID="115686216099168258_UNIT">
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941308772560"/>
        <cim:GeneratingUnit.maximumOperatingMW>320.000000</cim:GeneratingUnit.maximumOperatingMW>
        <cim:GeneratingUnit.minimumOperatingMW>0.000000</cim:GeneratingUnit.minimumOperatingMW>
        <cim:GeneratingUnit.raiseRampRate>0.000000</cim:GeneratingUnit.raiseRampRate>
        <cim:Naming.name>#1机</cim:Naming.name>
</cim:ThermalGeneratingUnit>
```

## TransformerWinding
```xml
<cim:TransformerWinding rdf:ID="117375065959432199">
        <cim:ConductingEquipment.BaseVoltage rdf:resource="#112871466332061703"/>
        <cim:ConductingEquipment.Terminals rdf:resource="#117375065959432199_T1"/>
        <cim:Equipment.MemberOf_EquipmentContainer rdf:resource="#113152941308773108"/>
        <cim:Naming.name>#1主变230</cim:Naming.name>
        <cim:TransformerWinding.MemberOf_PowerTransformer rdf:resource="#117093590982721539"/>
        <cim:TransformerWinding.leakagelmpedence>0.000000</cim:TransformerWinding.leakagelmpedence>
        <cimNC:TransformerWinding.loadLoss>0.000000</cimNC:TransformerWinding.loadLoss>
        <cim:TransformerWinding.r>0.846400</cim:TransformerWinding.r>
        <cimNC:TransformerWinding.rPU>0.160000</cimNC:TransformerWinding.rPU>
        <cim:TransformerWinding.ratedKV>230.000000</cim:TransformerWinding.ratedKV>
        <cim:TransformerWinding.ratedMVA>120.000000</cim:TransformerWinding.ratedMVA>
        <cim:TransformerWinding.windingType rdf:resource="http://iec.ch/TC57/2003/CIM-schema-cim10#WindingType.primary"/>
        <cim:TransformerWinding.x>64.760178</cim:TransformerWinding.x>
        <cimNC:TransformerWinding.xPU>12.242000</cimNC:TransformerWinding.xPU>
</cim:TransformerWinding>
```

## VoltageLevel
```xml
<cim:VoltageLevel rdf:ID="113152941308772357">
        <cim:Naming.name>115</cim:Naming.name>
        <cim:VoltageLevel.BaseVoltage rdf:resource="#112871466332061698"/>
        <cim:VoltageLevel.MemberOf_Substation rdf:resource="#113997366238904324"/>
        <cim:VoltageLevel.highVoltageLimit>0.000000</cim:VoltageLevel.highVoltageLimit>
        <cim:VoltageLevel.lowVoltageLimit>0.000000</cim:VoltageLevel.lowVoltageLimit>
</cim:VoltageLevel>
```





# CSV数据

## aclinedot

| 索引 |        mRID        |         Substation | ConductingEquipment |                                     name | ConnectivityNode | taskId |
| :--- | :----------------: | -----------------: | ------------------: | ---------------------------------------: | ---------------: | -----: |
| 0    | 116812116073119763 | 113997366306013188 |  116530641096409098 |                  110.110kV平里塘线105_T2 | 4400004040002003 |      1 |
| 1    | 116812116006011102 | 113997366238904421 |  116530641029300335 |                            230.东杨线_T2 | 4000101040007047 |      1 |
| 2    | 116812116022789409 | 113997366255681537 |  116530641046078097 |     PAS_T接厂站1.110kV.屯张八线张村端_T1 | 4100001040002064 |      1 |
| 3    | 116812116224114777 | 113997366457008212 |  116530641247404077 |                 110.110kV磨望电线(望)_T1 | 5300084040002008 |      1 |
| 4    | 116812116039565635 | 113997366272458802 |  116530641062854818 |   PASTJ1.110kV.110kV静南仁Ⅰ线(静兰侧)_T1 | 4200050040002003 |      1 |
| 5    | 116812116190560275 | 113997366423453698 |  116530641213849610 | xn110KV.白沙站新元变新白线105外网进线_T2 | 5100002040002045 |      1 |
| 6    | 116812116022788411 | 113997366255681537 |  116530641046077598 |     PAS_T接厂站1.110kV.五凌白线五一端_T2 | 4100001040002028 |      1 |
| 7    | 116812116224115041 | 113997366457008170 |  116530641247404209 |                         35.35kV旺东线_T1 | 5300042040011012 |      1 |
| 8    | 116812116224114707 | 113997366457008143 |  116530641247404042 |                       110.110kV贡岭线_T1 | 5300015040002015 |      1 |
| 9    | 116812116056343386 | 113997366289236216 |  116530641079632301 |                110kV.110kV田社莲线T莲_T2 | 4300248040002003 |      1 |

## ACLineSegment



|     字段      |                    0 |                       1 |                       2 |                    3 |                       4 |                    5 |                    6 |                    7 |                    8 |                    9 |
| :-----------: | -------------------: | ----------------------: | ----------------------: | -------------------: | ----------------------: | -------------------: | -------------------: | -------------------: | -------------------: | -------------------: |
|     mRID      |   116530641163517959 |      116530641163518217 |      116530641163518130 |   116530641163518257 |      116530641163518204 |   116530641163518023 |   116530641163518110 |   116530641163518262 |   116530641163518280 |   116530641163518279 |
|    EqFlag     | ACLineEqFlag.general | ACLineSegmentType.other | ACLineSegmentType.other | ACLineEqFlag.general | ACLineSegmentType.other | ACLineEqFlag.general | ACLineEqFlag.general | ACLineEqFlag.general | ACLineEqFlag.general | ACLineEqFlag.general |
|    StartST    |   113997366373122104 |      113997366373122185 |      113997366373122104 |   113997366373122104 |      113997366373122104 |   113997366373122104 |   113997366373122104 |   113997366373122104 |   113997366373122104 |   113997366373122157 |
|     EndST     |   113997366373122071 |      113997366373122104 |      113997366373122057 |   113997366373122083 |      113997366373122086 |   113997366373122075 |   113997366373122129 |   113997366373122083 |   113997366373122177 |   113997366373122104 |
|  BaseVoltage  |   112871466332061698 |      112871466332061707 |      112871466332061707 |   112871466332061707 |      112871466332061707 |   112871466332061698 |   112871466332061698 |   112871466332061698 |   112871466332061707 |   112871466332061707 |
|      bch      |              2.84998 |                 64.2302 |                       0 |               12.836 |                 20.8897 |              2.80998 |              4.67501 |              19.3665 |                    0 |                    0 |
|    ratedA     |                  610 |                     610 |                     335 |                  380 |                     380 |                  800 |                  700 |                  800 |                  335 |                  335 |
| ratedCurrent  |                  610 |                     610 |                     335 |                  380 |                     380 |                  800 |                  700 |                  800 |                  335 |                  335 |
|   devState    |         DevState.run |            DevState.run |            DevState.run |         DevState.run |            DevState.run |         DevState.run |         DevState.run |         DevState.run |         DevState.run |         DevState.run |
|       r       |                0.132 |                 2.97488 |                 4.19832 |              1.10727 |                 1.80198 |             0.079999 |             0.181901 |              0.55136 |              3.42924 |              0.90066 |
|      rPU      |             0.099811 |                 24.9938 |                 35.2726 |              9.30283 |                 15.1395 |             0.060491 |             0.137543 |             0.416907 |              28.8111 |              7.56698 |
|       x       |             0.401001 |                 9.03734 |                 4.95155 |              1.76343 |                 2.86982 |                0.406 |               0.7038 |              2.79815 |              4.04449 |              1.06225 |
|      x0       |                    0 |                       0 |                       0 |                    0 |                       0 |                    0 |                    0 |                    0 |                    0 |                    0 |
|     name      |  110kV大秦河线三河侧 |      35kV和沙洋线中沙侧 |      35kV鹤思同线鹤岭侧 |   35kV新佛安线新桥侧 |      35kV覃茶根线覃塘侧 |  110kV谢鹤水线水仙侧 |  110kV大竹高线高塘侧 |  110kV安新康线新桥侧 |   35kV陶江下线陶瓷侧 |   35kV陶江下线下湾侧 |
| MemberOf_Line |   116249166186807296 |      116249166186807328 |      116249166186807328 |   116249166186807328 |      116249166186807328 |   116249166186807312 |   116249166186807296 |   116249166186807296 |   116249166186807328 |   116249166186807328 |
|   Terminals   |   116812116140228622 |      116812116140229138 |      116812116140228964 |   116812116140229218 |      116812116140229112 |   116812116140228750 |   116812116140228924 |   116812116140229228 |   116812116140229264 |   116812116140229262 |
|      xPU      |             0.303214 |                 75.9281 |                 41.6009 |              14.8156 |                 24.1111 |             0.306994 |             0.532174 |               2.1158 |              33.9801 |              8.92459 |
|    node_1     |     4800056040002013 |        4800137040011006 |        4800056040011008 |     4800056040011007 |        4800056040011011 |     4800056040002016 |     4800056040002006 |     4800056040002012 |     4800056040011006 |     4800109040011002 |
|    node_2     |     4800023040002013 |        4800056040011003 |        4800009040011016 |     4800035040011011 |        4800038040011015 |     4800027040002006 |     4800081040002009 |     4800035040002007 |     4800129040011009 |     4800056040011006 |
|  terminal_1   |   116812116140228621 |      116812116140229137 |      116812116140228963 |   116812116140229217 |      116812116140229111 |   116812116140228749 |   116812116140228923 |   116812116140229227 |   116812116140229263 |   116812116140229261 |
|  terminal_2   |   116812116140228622 |      116812116140229138 |      116812116140228964 |   116812116140229218 |      116812116140229112 |   116812116140228750 |   116812116140228924 |   116812116140229228 |   116812116140229264 |   116812116140229262 |
|    taskId     |                    1 |                       1 |                       1 |                    1 |                       1 |                    1 |                    1 |                    1 |                    1 |                    1 |

## BaseVoltage

| 索引 |        mRID        | nominalVoltage |     name |       v_exm |     nominalI | taskId |
| :--: | :----------------: | -------------: | -------: | ----------: | -----------: | -----: |
|  0   | 112871466332061697 |          10.50 |   10.5kV |   12.000000 |     0.000000 |      1 |
|  1   | 112871466332061698 |         115.00 |    110kV |  132.000000 |     0.000000 |      1 |
|  2   | 112871466332061699 |          13.80 |   13.8kV |   16.559999 |     0.000000 |      1 |
|  3   | 112871466332061700 |          15.75 |  15.75kV |   18.900000 |     0.000000 |      1 |
|  4   | 112871466332061701 |          18.00 |     18kV |   21.600000 |     0.000000 |      1 |
|  5   | 112871466332061702 |          20.00 |     20kV |   24.000000 |     0.000000 |      1 |
|  6   | 112871466332061703 |         230.00 |    220kV |  264.000000 |     0.000000 |      1 |
|  7   | 112871466332061704 |          22.00 |     22kV |   26.400000 |     0.000000 |      1 |
|  8   | 112871466332061705 |          24.00 |     24kV |   28.799999 |     0.000000 |      1 |
|  9   | 112871466332061706 |          27.00 |     27kV |   32.400002 |     0.000000 |      1 |
|  10  | 112871466332061707 |          34.50 |     35kV |   42.000000 |     0.000000 |      1 |
|  11  | 112871466332061708 |         525.00 |    500kV |  600.000000 |     0.000000 |      1 |
|  12  | 112871466332061709 |           6.30 |    6.3kV |    7.200000 |     0.000000 |      1 |
|  13  | 112871466332061710 |           1.00 |   中性点 |    1.200000 |     0.000000 |      1 |
|  14  | 112871466332061711 |         350.00 |    350kV |  420.000000 |     0.000000 |      1 |
|  15  | 112871466365616129 |          21.00 |     21kV |   25.200001 |     0.000000 |      1 |
|  16  | 112871466382393345 |           3.00 |      3kV |    3.720000 | 18624.203125 |      1 |
|  17  | 112871466382393346 |           1.00 |      1kV |    1.200000 |     0.000000 |      1 |
|  18  | 112871466432724993 |         132.00 |    132kV |  158.399994 |   437.386597 |      1 |
|  19  | 112871466432724994 |          33.00 |     33kV |   39.599998 |  1749.546265 |      1 |
|  20  | 112871466449502209 |           0.40 |     380V |    0.468000 |     0.000000 |      1 |
|  21  | 112871466449502210 |           5.00 | 保护信号 |    6.000000 |     0.000000 |      1 |
|  22  | 112871466466279425 |        1000.00 |   1000kV | 1200.000000 |     0.000000 |      1 |
|  23  | 112871466466279426 |         330.00 |    330kV |  396.000000 |     0.000000 |      1 |
|  24  | 112871466466279427 |         750.00 |    750kV |  900.000000 |     0.000000 |      1 |
|  25  | 112871466483056641 |          15.00 |     15kV |   18.000000 |     0.000000 |      1 |
|  26  | 112871466499833857 |          10.00 |      0kV |    1.200000 |     0.000000 |      1 |
|  27  | 112871466499833858 |           0.10 |    0.1kV |    1.200000 |     0.000000 |      1 |
|  28  | 112871466550165505 |           3.15 |   3.15kV |    3.780000 |     0.000000 |      1 |
|  29  | 112871466550165506 |         380.00 |    380kV |  456.000000 |     0.000000 |      1 |
|  30  | 112871466566942721 |           0.22 |     220V |    0.264000 |     0.000000 |      1 |
|  31  | 112871466566942722 |          66.00 |     66kV |   79.199997 |     0.000000 |      1 |

## Bay

| 索引 |        mRID        | MemberOf_Substation |                     name | MemberOf_VoltageLevel | taskId |
| :--: | :----------------: | ------------------: | -----------------------: | --------------------: | -----: |
|  0   | 114278841450497229 |  113997366473785437 |        10kV中都线932开关 |    113152941543653785 |      1 |
|  1   | 114278841349834987 |  113997366373122199 |                  907间隔 |    113152941442990486 |      1 |
|  2   | 114278841450496938 |  113997366473785433 |     1号主变35kV侧301开关 |    113152941543653766 |      1 |
|  3   | 114278841349833813 |  113997366373122085 |                  923间隔 |    113152941442990120 |      1 |
|  4   | 114278841450496779 |  113997366473785448 |     1号主变35kV侧301开关 |    113152941543653753 |      1 |
|  5   | 114278841450497039 |  113997366473785452 |                  2号主变 |    113152941543653773 |      1 |
|  6   | 114278841349835227 |  113997366373122053 |                  908间隔 |    113152941442990529 |      1 |
|  7   | 114278841450496044 |  113997366473785372 | 35kV1号主变35kV侧301开关 |    113152941543653515 |      1 |
|  8   | 114278841349832989 |  113997366373122049 |                  911间隔 |    113152941442990086 |      1 |
|  9   | 114278841349834294 |  113997366373122161 |                  903间隔 |    113152941442990369 |      1 |

## Breaker



| 字段                        |                     0 |                     1 |                     2 |                     3 |                     4 |                     5 |                     6 |                     7 |                     8 |                     9 |
| :-------------------------- | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: |
| mRID                        |    114560316242657648 |    114560316209105013 |    114560316209105041 |    114560316209106445 |    114560316309766339 |    114560316292989140 |    114560316410430075 |    114560316242659471 |    114560316192327888 |    114560316242660493 |
| normalOpen                  |                     0 |                     1 |                     1 |                     1 |                     0 |                     1 |                     1 |                     0 |                     1 |                     0 |
| BaseVoltage                 |    112871466332061707 |    112871466332061697 |    112871466332061707 |    112871466332061698 |    112871466332061697 |    112871466332061707 |    112871466332061697 |    112871466332061697 |    112871466332061703 |    112871466332061697 |
| MemberOf_Substation         |    113997366289235995 |    113997366255681585 |    113997366255681586 |    113997366238904411 |    113997366238904539 |    113997366339567628 |    113997366457008149 |    113997366289236062 |    113997366238904403 |    113997366289236197 |
| breakType                   |     BreakType.general |     BreakType.general |     BreakType.general |     BreakType.general |     BreakType.general |     BreakType.general |     BreakType.general |     BreakType.general |     BreakType.general |     BreakType.general |
| volt_name                   |                  34.5 |                  10.5 |                  34.5 |                   115 |                  10.5 |                  34.5 |                  10.5 |                  10.5 |                   230 |                  10.5 |
| name                        |           35kV备用304 |       10kV相望924开关 |       35kV谢马306开关 |      110kV雷标106开关 |                   912 |        35kV1号站变391 |         10kV备用线936 |                   950 |              2002开关 |    10kV电容器Ⅰ930开关 |
| Terminals                   | 114560316242657648_T2 | 114560316209105013_T2 | 114560316209105041_T2 | 114560316209106445_T2 | 114560316309766339_T2 | 114560316292989140_T2 | 114560316410430075_T2 | 114560316242659471_T2 | 114560316192327888_T2 | 114560316242660493_T2 |
| MemberOf_EquipmentContainer |    113152941359104103 |    113152941325549614 |    113152941325549703 |    113152941308772431 |    113152941426212870 |    113152941409435712 |    113152941526876286 |    113152941359104211 |    113152941308772720 |    113152941359104406 |
| node_1                      |      4300027040011016 |      4100049040001026 |      4100050040011032 |      4000091040002023 |      4000219040001013 |      4600012040011026 |      5300021040001025 |      4300094040001036 |      4000083040007012 |      4300229040001020 |
| node_2                      |      4300027040011015 |      4100049040001025 |      4100050040011031 |      4000091040002022 |      4000219040001012 |      4600012040011025 |      5300021040001024 |      4300094040001014 |      4000083040007011 |      4300229040001009 |
| terminal_1                  | 114560316242657648_T1 | 114560316209105013_T1 | 114560316209105041_T1 | 114560316209106445_T1 | 114560316309766339_T1 | 114560316292989140_T1 | 114560316410430075_T1 | 114560316242659471_T1 | 114560316192327888_T1 | 114560316242660493_T1 |
| terminal_2                  | 114560316242657648_T2 | 114560316209105013_T2 | 114560316209105041_T2 | 114560316209106445_T2 | 114560316309766339_T2 | 114560316292989140_T2 | 114560316410430075_T2 | 114560316242659471_T2 | 114560316192327888_T2 | 114560316242660493_T2 |
| taskId                      |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |

## BusbarSection

| 字段                        |                     0 |                     1 |                     2 |                     3 |                     4 |                     5 |                     6 |                     7 |                     8 |                     9 |
| :-------------------------- | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: |
| mRID                        |    115404741273452762 |    115404741172789354 |    115404741307006978 |    115404741357339051 |    115404741122458178 |    115404741340561774 |    115404741256675705 |    115404741156012329 |    115404741357339060 |    115404741239898291 |
| aliasName                   |           10kVⅡ段母线 |                10kVIM |        道石变10kV_I母 |                 Ⅰ母线 |                 2母线 |                    2M |                 1母线 |                 1母线 |           10kVⅠ段母线 |           10kVⅠ段母线 |
| BaseVoltage                 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061703 |    112871466332061697 |    112871466332061707 |    112871466332061698 |    112871466332061697 |    112871466332061697 |
| MemberOf_Substation         |    113997366389899296 |    113997366289236004 |    113997366238904346 |    113997366473785438 |    113997366238904387 |    113997366457008184 |    113997366373122187 |    113997366238904518 |    113997366473785458 |    113997366356344872 |
| volt_name                   |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                   230 |                  10.5 |                  34.5 |                   115 |                  10.5 |                  10.5 |
| name                        |           10kVⅡ段母线 |                10kVIM |        道石变10kV_I母 |                 Ⅰ母线 |                 2母线 |                    2M |                 1母线 |                 1母线 |           10kVⅠ段母线 |           10kVⅠ段母线 |
| Terminals                   | 115404741273452762_T1 | 115404741172789354_T1 | 115404741307006978_T1 | 115404741357339051_T1 | 115404741122458178_T1 | 115404741340561774_T1 | 115404741256675705_T1 | 115404741156012329_T1 | 115404741357339060_T1 | 115404741239898291_T1 |
| MemberOf_EquipmentContainer |    113152941459767390 |    113152941359104011 |    113152941308772585 |    113152941543653792 |    113152941308772706 |    113152941526876457 |    113152941442990438 |    113152941342326927 |    113152941543653795 |    113152941426212970 |
| node_1                      |      4900032040001010 |      4300036040001001 |      4000026040001001 |      5400094040001003 |      4000067040007004 |      5300056040001001 |      4800139040011001 |      4000198040002014 |      5400114040001001 |      4700040040001003 |
| terminal_1                  | 115404741273452762_T1 | 115404741172789354_T1 | 115404741307006978_T1 | 115404741357339051_T1 | 115404741122458178_T1 | 115404741340561774_T1 | 115404741256675705_T1 | 115404741156012329_T1 | 115404741357339060_T1 | 115404741239898291_T1 |
| taskId                      |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |

## Compensator

| 字段                        |                      0 |                      1 |                      2 |                        3 |                      4 |                      5 |                        6 |                      7 |                      8 |                      9 |
| :-------------------------- | ---------------------: | ---------------------: | ---------------------: | -----------------------: | ---------------------: | ---------------------: | -----------------------: | ---------------------: | ---------------------: | ---------------------: |
| mRID                        |     118219491074113559 |     118219490889564161 |     118219491074113572 |       118219490956673032 |     118219490889564163 |     118219490889564165 |       118219490956673027 |     118219490889564173 |     118219491074113562 |     118219490889564169 |
| compensatorType             | CompensatorType.series | CompensatorType.series | CompensatorType.series |   CompensatorType.series | CompensatorType.series | CompensatorType.series |   CompensatorType.series | CompensatorType.series | CompensatorType.series | CompensatorType.series |
| nominalMVAr                 |                     12 |                 122.38 |                     12 |                   1.3856 |                    109 |                    130 |                   2.1218 |                    138 |                     12 |                 116.67 |
| BaseVoltage                 |     112871466332061707 |     112871466332061708 |     112871466332061707 |       112871466332061697 |     112871466332061708 |     112871466332061708 |       112871466332061697 |     112871466332061708 |     112871466332061707 |     112871466332061708 |
| MemberOf_Substation         |     113997366238904553 |     113997366238904325 |     113997366238904553 |       113997366238904484 |     113997366238904325 |     113997366238904382 |       113997366238904488 |     113997366238904373 |     113997366238904553 |     113997366238904454 |
| nominalA                    |                    343 |                   2000 |                    343 |                     4000 |                1990.89 |                2399.97 |                     3500 |                3000.03 |                    343 |                2826.85 |
| volt_name                   |                   34.5 |                    525 |                   34.5 |                     10.5 |                    525 |                    525 |                     10.5 |                    525 |                   34.5 |                    525 |
| name                        |                5电容器 |           西百乙线串补 |          闽航站C09串联 | 220kV2号主变10kV侧电抗器 |             马百线串补 |           柳贺乙线串补 | 220kV1号主变10kV侧电抗器 |          桂山甲线串补2 |                8电容器 |             天平Ⅱ串补B |
| Terminals                   |  118219491074113559_T2 |  118219490889564161_T2 |  118219491074113572_T2 |    118219490956673032_T2 |  118219490889564163_T2 |  118219490889564165_T2 |    118219490956673027_T2 |  118219490889564173_T2 |  118219491074113562_T2 |  118219490889564169_T2 |
| nominalkV                   |                      0 |                      0 |                      0 |                        0 |                      0 |                      0 |                        0 |                      0 |                      0 |                      0 |
| MemberOf_EquipmentContainer |     113152941308772894 |     113152941308772847 |     113152941308772894 |       113152941308772633 |     113152941308772847 |     113152941308772859 |       113152941375881218 |     113152941308772853 |     113152941308772894 |     113152941308772871 |
| node_1                      |       4000233040011065 |       4000005040012019 |       4000233040011071 |         4000164040001064 |       4000005040012020 |       4000062040012036 |         4000168040001058 |       4000053040012012 |       4000233040011077 |       4000134040012009 |
| node_2                      |       4000233040011064 |       4000005040012018 |       4000233040011069 |         4000164040001063 |       4000005040012009 |       4000062040012031 |         4000168040001055 |       4000053040012011 |       4000233040011076 |       4000134040012004 |
| terminal_1                  |  118219491074113559_T1 |  118219490889564161_T1 |  118219491074113572_T1 |    118219490956673032_T1 |  118219490889564163_T1 |  118219490889564165_T1 |    118219490956673027_T1 |  118219490889564173_T1 |  118219491074113562_T1 |  118219490889564169_T1 |
| terminal_2                  |  118219491074113559_T2 |  118219490889564161_T2 |  118219491074113572_T2 |    118219490956673032_T2 |  118219490889564163_T2 |  118219490889564165_T2 |    118219490956673027_T2 |  118219490889564173_T2 |  118219491074113562_T2 |  118219490889564169_T2 |
| taskId                      |                      1 |                      1 |                      1 |                        1 |                      1 |                      1 |                        1 |                      1 |                      1 |                      1 |

## Compensator_P

并联电容器

| 字段                        |                     0 |                     1 |                     2 |                     3 |                     4 |                     5 |                     6 |                     7 |                     8 |                     9 |
| :-------------------------- | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: |
| mRID                        |    117938016013516859 |    117938015929631321 |    117938015963185371 |    117938015996739704 |    117938016080625823 |    117938015979962394 |    117938015946407950 |    117938015929630816 |    117938015912854184 |    117938016114180254 |
| compensatorType             | CompensatorType.shunt | CompensatorType.shunt | CompensatorType.shunt | CompensatorType.shunt | CompensatorType.shunt | CompensatorType.shunt | CompensatorType.shunt | CompensatorType.shunt | CompensatorType.shunt | CompensatorType.shunt |
| nominalMVAr                 |                   1.2 |                     5 |                     8 |                     6 |                 6.012 |                     8 |                 6.012 |                     6 |                  -120 |                     8 |
| BaseVoltage                 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061708 |    112871466332061707 |
| MemberOf_Substation         |    113997366339567641 |    113997366255681642 |    113997366238904341 |    113997366322790417 |    113997366406676514 |    113997366238904532 |    113997366238904369 |    113997366255681540 |    113997366238904551 |    113997366440230956 |
| volt_name                   |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                   525 |                  34.5 |
| name                        |         10kV1号电容器 |            3号电容C03 |             980电容器 |               4电容器 |               2号电容 |      10kV7号电容器907 |               7电容器 |               2电容器 |        光南乙线电抗器 |               2电容器 |
| Terminals                   | 117938016013516859_T1 | 117938015929631321_T1 | 117938015963185371_T1 | 117938015996739704_T1 | 117938016080625823_T1 | 117938015979962394_T1 | 117938015946407950_T1 | 117938015929630816_T1 | 117938015912854184_T1 | 117938016114180254_T1 |
| nominalkV                   |                  10.5 |                    10 |                    11 |                    10 |                    10 |                    10 |                    10 |                    10 |                   525 |                    35 |
| MemberOf_EquipmentContainer |    113152941409435669 |    113152941325549977 |    113152941308772582 |    113152941392658480 |    113152941476544723 |    113152941375881220 |    113152941342326905 |    113152941325549569 |    113152941308772895 |    113152941510099074 |
| node_1                      |      4600025040001013 |      4100106040001104 |      4000021040001020 |      4500017040001037 |      5000034040001014 |      4000212040001020 |      4000049040001095 |      4100004040001094 |      4000231040012034 |      5200044040011046 |
| terminal_1                  | 117938016013516859_T1 | 117938015929631321_T1 | 117938015963185371_T1 | 117938015996739704_T1 | 117938016080625823_T1 | 117938015979962394_T1 | 117938015946407950_T1 | 117938015929630816_T1 | 117938015912854184_T1 | 117938016114180254_T1 |
| taskId                      |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |

## Compensator_S

串联电容器

| 字段                        |                      0 |                      1 |                      2 |                      3 |                      4 |                        5 |                      6 |                        7 |                        8 |                      9 |
| :-------------------------- | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | -----------------------: | ---------------------: | -----------------------: | -----------------------: | ---------------------: |
| mRID                        |     118219491074113559 |     118219491074113556 |     118219490889564162 |     118219490889564172 |     118219490889564171 |       118219490956673029 |     118219491074113570 |       118219490956673027 |       118219490956673030 |     118219490889564165 |
| compensatorType             | CompensatorType.series | CompensatorType.series | CompensatorType.series | CompensatorType.series | CompensatorType.series |   CompensatorType.series | CompensatorType.series |   CompensatorType.series |   CompensatorType.series | CompensatorType.series |
| nominalMVAr                 |                     12 |                     12 |                 122.38 |                    138 |                    175 |                   1.3856 |                     12 |                   2.1218 |                   1.3856 |                    130 |
| nominalA                    |                    343 |                    343 |                   2000 |                3000.03 |                2380.95 |                     4000 |                    343 |                     3500 |                     4000 |                2399.97 |
| BaseVoltage                 |     112871466332061707 |     112871466332061707 |     112871466332061708 |     112871466332061708 |     112871466332061708 |       112871466332061697 |     112871466332061707 |       112871466332061697 |       112871466332061697 |     112871466332061708 |
| MemberOf_Substation         |     113997366238904553 |     113997366238904553 |     113997366238904325 |     113997366238904373 |     113997366238904381 |       113997366238904497 |     113997366238904553 |       113997366238904488 |       113997366238904497 |     113997366238904382 |
| volt_name                   |                   34.5 |                   34.5 |                    525 |                    525 |                    525 |                     10.5 |                   34.5 |                     10.5 |                     10.5 |                    525 |
| name                        |                5电容器 |                2电容器 |           西百甲线串补 |          桂山甲线串补1 |           山河乙线串补 | 220kV1号主变10kV侧电抗器 |          闽航站C07串联 | 220kV1号主变10kV侧电抗器 | 220kV2号主变10kV侧电抗器 |           柳贺乙线串补 |
| Terminals                   |  118219491074113559_T2 |  118219491074113556_T2 |  118219490889564162_T2 |  118219490889564172_T2 |  118219490889564171_T2 |    118219490956673029_T2 |  118219491074113570_T2 |    118219490956673027_T2 |    118219490956673030_T2 |  118219490889564165_T2 |
| nominalkV                   |                      0 |                      0 |                      0 |                      0 |                      0 |                        0 |                      0 |                        0 |                        0 |                      0 |
| MemberOf_EquipmentContainer |     113152941308772894 |     113152941308772894 |     113152941308772847 |     113152941308772853 |     113152941308772858 |       113152941375881219 |     113152941308772894 |       113152941375881218 |       113152941375881219 |     113152941308772859 |
| node_1                      |       4000233040011065 |       4000233040011056 |       4000005040012026 |       4000053040012009 |       4000061040012017 |         4000177040001058 |       4000233040011074 |         4000168040001058 |         4000177040001072 |       4000062040012036 |
| node_2                      |       4000233040011064 |       4000233040011055 |       4000005040012025 |       4000053040012008 |       4000061040012016 |         4000177040001034 |       4000233040011072 |         4000168040001055 |         4000177040001036 |       4000062040012031 |
| terminal_1                  |  118219491074113559_T1 |  118219491074113556_T1 |  118219490889564162_T1 |  118219490889564172_T1 |  118219490889564171_T1 |    118219490956673029_T1 |  118219491074113570_T1 |    118219490956673027_T1 |    118219490956673030_T1 |  118219490889564165_T1 |
| terminal_2                  |  118219491074113559_T2 |  118219491074113556_T2 |  118219490889564162_T2 |  118219490889564172_T2 |  118219490889564171_T2 |    118219490956673029_T2 |  118219491074113570_T2 |    118219490956673027_T2 |    118219490956673030_T2 |  118219490889564165_T2 |
| taskId                      |                      1 |                      1 |                      1 |                      1 |                      1 |                        1 |                      1 |                        1 |                        1 |                      1 |

## ConnectivityNode

| 索引 |       mRID       | MemberOf_Substation |    BaseVoltage     | volt_name |       name       | MemberOf_EquipmentContainer | taskId |
| :--: | :--------------: | :-----------------: | :----------------: | :-------: | :--------------: | :-------------------------: | :----: |
|  1   | 4000002040002001 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002001 |     113152941308773062      |   1    |
|  2   | 4000002040002002 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002002 |     113152941308773062      |   1    |
|  3   | 4000002040002003 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002003 |     113152941308773062      |   1    |
|  4   | 4000002040002004 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002004 |     113152941308773062      |   1    |
|  5   | 4000002040002005 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002005 |     113152941308773062      |   1    |
|  6   | 4000002040002006 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002006 |     113152941308773062      |   1    |
|  7   | 4000002040002007 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002007 |     113152941308773062      |   1    |
|  8   | 4000002040002008 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002008 |     113152941308773062      |   1    |
|  9   | 4000002040002009 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002009 |     113152941308773062      |   1    |
|  10  | 4000002040002010 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002010 |     113152941308773062      |   1    |
|  11  | 4000002040002011 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002011 |     113152941308773062      |   1    |
|  12  | 4000002040002012 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002012 |     113152941308773062      |   1    |
|  13  | 4000002040002013 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002013 |     113152941308773062      |   1    |
|  14  | 4000002040002014 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002014 |     113152941308773062      |   1    |
|  15  | 4000002040002015 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002015 |     113152941308773062      |   1    |
|  16  | 4000002040002016 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002016 |     113152941308773062      |   1    |
|  17  | 4000002040002017 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002017 |     113152941308773062      |   1    |
|  18  | 4000002040002018 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002018 |     113152941308773062      |   1    |
|  19  | 4000002040002019 | 113997366238904322  | 112871466332061698 |  115.000  | 4000002040002019 |     113152941308773062      |   1    |

## Disconnector

| 字段                        |                         0 |                     1 |                     2 |                     3 |                     4 |                     5 |                       6 |                     7 |                        8 |                     9 |
| :-------------------------- | ------------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | ----------------------: | --------------------: | -----------------------: | --------------------: |
| mRID                        |        114841791185821126 |    114841791169045082 |    114841791202594804 |    114841791169047734 |    114841791387142694 |    114841791269701278 |      114841791320033760 |    114841791185816554 |       114841791269700883 |    114841791236145971 |
| BaseVoltage                 |        112871466332061697 |    112871466332061703 |    112871466332061697 |    112871466332061703 |    112871466332061697 |    112871466332061697 |      112871466332061697 |    112871466332061697 |       112871466332061707 |    112871466332061697 |
| MemberOf_Substation         |        113997366255681593 |    113997366238904551 |    113997366272458798 |    113997366238904620 |    113997366457008167 |    113997366238904483 |      113997366238904333 |    113997366255681558 |       113997366339567643 |    113997366306013196 |
| volt_name                   |                      10.5 |                   230 |                  10.5 |                   230 |                  10.5 |                  10.5 |                    10.5 |                  10.5 |                     34.5 |                  10.5 |
| name                        | 10kV越汇乙911手车工作位置 |             20041刀闸 |    10kV备用线阳09小车 |             20012刀闸 |     10kV备用线906手车 |    10kV潭硅线915手车2 | 10kV5号电容959开关手车1 |    10kV电容二9126刀闸 | 35kV1号主变35kV侧301令克 | 10kV1号电容器9012手车 |
| Terminals                   |     114841791185821126_T2 | 114841791169045082_T2 | 114841791202594804_T2 | 114841791169047734_T2 | 114841791387142694_T2 | 114841791269701278_T2 |   114841791320033760_T2 | 114841791185816554_T2 |    114841791269700883_T2 | 114841791236145971_T2 |
| MemberOf_EquipmentContainer |        113152941325549753 |    113152941308772900 |    113152941342326893 |    113152941308773099 |    113152941526876304 |    113152941409435679 |      113152941459767298 |    113152941325549587 |       113152941409435723 |    113152941375881232 |
| node_1                      |          4100057040001165 |      4000231040007007 |      4200046040001069 |      4000300040007021 |      5300039040001022 |      4000163040001038 |        4000013040001043 |      4100022040001072 |         4600027040011003 |      4400012040001035 |
| node_2                      |          4100057040001124 |      4000231040007005 |      4200046040001006 |      4000300040007008 |      5300039040001006 |      4000163040001037 |        4000013040001030 |      4100022040001071 |         4600027040011001 |      4400012040001023 |
| terminal_1                  |     114841791185821126_T1 | 114841791169045082_T1 | 114841791202594804_T1 | 114841791169047734_T1 | 114841791387142694_T1 | 114841791269701278_T1 |   114841791320033760_T1 | 114841791185816554_T1 |    114841791269700883_T1 | 114841791236145971_T1 |
| terminal_2                  |     114841791185821126_T2 | 114841791169045082_T2 | 114841791202594804_T2 | 114841791169047734_T2 | 114841791387142694_T2 | 114841791269701278_T2 |   114841791320033760_T2 | 114841791185816554_T2 |    114841791269700883_T2 | 114841791236145971_T2 |
| taskId                      |                         1 |                     1 |                     1 |                     1 |                     1 |                     1 |                       1 |                     1 |                        1 |                     1 |

## EnergyConsumer

| 字段                        |                     0 |                     1 |                     2 |                     3 |                     4 |                     5 |                     6 |                     7 |                     8 |                     9 |
| :-------------------------- | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: |
| mRID                        |    115967691075880606 |    115967691142988158 |    115967691126212364 |    115967691092656219 |    115967691193319440 |    115967691293982836 |    115967691210097699 |    115967691092656691 |    115967691210097986 |    115967691293983267 |
| BaseVoltage                 |    112871466332061703 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |    112871466332061697 |
| MemberOf_Substation         |    113997366238904355 |    113997366306013202 |    113997366289236190 |    113997366238904463 |    113997366238904364 |    113997366457008135 |    113997366373122179 |    113997366255681565 |    113997366373122053 |    113997366457008162 |
| volt_name                   |                   230 |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                  10.5 |                  10.5 |
| name                        |               电潭Ⅲ线 |        10kV深东Ⅱ线918 |      10kV消弧线圈Ⅱ925 |               琴新912 |        10kV南港Ⅲ线907 |               1站用变 |     10kV莫村线911线路 |               石板915 |  10kV西工园4线908线路 |            10kV北工线 |
| Terminals                   | 115967691075880606_T1 | 115967691142988158_T1 | 115967691126212364_T1 | 115967691092656219_T1 | 115967691193319440_T1 | 115967691293982836_T1 | 115967691210097699_T1 | 115967691092656691_T1 | 115967691210097986_T1 | 115967691293983267_T1 |
| MemberOf_EquipmentContainer |    113152941308772679 |    113152941375881270 |    113152941359104414 |    113152941308772621 |    113152941426212866 |    113152941526876272 |    113152941442990414 |    113152941325549594 |    113152941442990529 |    113152941526876299 |
| node_1                      |      4000035040007036 |      4400018040001020 |      4300222040001003 |      4000143040001047 |      4000044040001006 |      5300007040001009 |      4800131040001008 |      4100029040001041 |      4800005040001004 |      5300034040001015 |
| terminal_1                  | 115967691075880606_T1 | 115967691142988158_T1 | 115967691126212364_T1 | 115967691092656219_T1 | 115967691193319440_T1 | 115967691293982836_T1 | 115967691210097699_T1 | 115967691092656691_T1 | 115967691210097986_T1 | 115967691293983267_T1 |
| taskId                      |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |

## GeneratingUnit

| 字段                        |                       0 |                           1 |                       2 |                       3 |                       4 |                       5 |                       6 |                       7 |                       8 |                           9 |
| :-------------------------- | ----------------------: | --------------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | --------------------------: |
| mRID                        | 115686216149499905_UNIT |     115686216149499916_UNIT | 115686216149499951_UNIT | 115686216149499955_UNIT | 115686216149499942_UNIT | 115686216149499954_UNIT | 115686216149499922_UNIT | 115686216149499923_UNIT | 115686216149499920_UNIT |     115686216149499918_UNIT |
| minimumOperatingMW          |                     -80 |                        -300 |                     -50 |                     -50 |                     -50 |                     -50 |                     -80 |                    -100 |                     -80 |                        -300 |
| MemberOf_Substation         |      113997366289236088 |          113997366289236069 |      113997366289236132 |      113997366289236183 |      113997366289236071 |      113997366289236071 |      113997366289236086 |      113997366289236089 |      113997366289236084 |          113997366289236069 |
| BaseVoltage                 |      112871466332061698 |          112871466332061698 |      112871466332061698 |      112871466332061707 |      112871466332061707 |      112871466332061707 |      112871466332061698 |      112871466332061698 |      112871466332061698 |          112871466332061698 |
| volt_name                   |                     115 |                         115 |                     115 |                    34.5 |                    34.5 |                    34.5 |                     115 |                     115 |                     115 |                         115 |
| name                        |        蜜源风电场等值机 | 107备用线等值机(对端宝象站) |  110kV芙兴和线T芙等值机 |   35kV社兴线T大线等值机 |        35kV溶小线等值机 |        35kV漠庙线等值机 |        马岭变电站等值机 |          南桂电站等值机 |      灵川北牵引站等值机 | 131备用线等值机(对端飞虎站) |
| maximumOperatingMW          |                      80 |                         300 |                     100 |                      20 |                      20 |                      20 |                      80 |                     100 |                      80 |                         300 |
| MemberOf_EquipmentContainer |      113152941359104226 |          113152941359104229 |      113152941359104259 |      113152941359104378 |      113152941359104405 |      113152941359104405 |      113152941359104250 |      113152941359104230 |      113152941359104232 |          113152941359104229 |
| raiseRampRate               |                       0 |                           0 |                       0 |                       0 |                       0 |                       0 |                       0 |                       0 |                       0 |                           0 |
| taskId                      |                       1 |                           1 |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |                           1 |

## gridcom

| 索引 |                 id | level |   name |              owner |          parent_id | PG_ID |
| :--- | -----------------: | ----: | -----: | -----------------: | -----------------: | ----: |
| 0    | 113715891429965825 |  1004 |   百色 | 113715891262193665 | 113715891262193664 |     1 |
| 1    | 113715891396411393 |  1004 |   贵港 | 113715891262193665 | 113715891262193664 |     1 |
| 2    | 113715891497074689 |  1004 |   崇左 | 113715891262193665 | 113715891262193664 |     1 |
| 3    | 113715891295748097 |  1004 |   柳州 | 113715891262193665 | 113715891262193664 |     1 |
| 4    | 113715891278970881 |  1004 |   南宁 | 113715891262193665 | 113715891262193664 |     1 |
| 5    | 113715891329302529 |  1004 |   梧州 | 113715891262193665 | 113715891262193664 |     1 |
| 6    | 113715891446743041 |  1004 |   贺州 | 113715891262193665 | 113715891262193664 |     1 |
| 7    | 113715891362856961 |  1004 | 防城港 | 113715891262193665 | 113715891262193664 |     1 |
| 8    | 113715891480297473 |  1004 |   来宾 | 113715891262193665 | 113715891262193664 |     1 |
| 9    | 113715891346079745 |  1004 |   北海 | 113715891262193665 | 113715891262193664 |     1 |

## GroundDisconnector

| 字段                        |                     0 |                     1 |                         2 |                     3 |                     4 |                     5 |                       6 |                       7 |                     8 |                     9 |
| :-------------------------- | --------------------: | --------------------: | ------------------------: | --------------------: | --------------------: | --------------------: | ----------------------: | ----------------------: | --------------------: | --------------------: |
| mRID                        |    115123266313521462 |    115123266145753511 |        115123266229633645 |    115123266313520168 |    115123266145756280 |    115123266179308004 |      115123266179304122 |      115123266380628708 |    115123266263187541 |    115123266313521771 |
| normalOpen                  |                 False |                  True |                     False |                 False |                  True |                  True |                    True |                    True |                 False |                 False |
| BaseVoltage                 |    112871466332061697 |    112871466332061703 |        112871466332061697 |    112871466332061698 |    112871466332061703 |    112871466332061697 |      112871466332061697 |      112871466332061707 |    112871466332061697 |    112871466332061707 |
| MemberOf_Substation         |    113997366406676507 |    113997366238904455 |        113997366238904337 |    113997366406676495 |    113997366238904325 |    113997366272458804 |      113997366238904439 |      113997366473785444 |    113997366238904364 |    113997366406676576 |
| volt_name                   |                  10.5 |                   230 |                      10.5 |                   115 |                   230 |                  10.5 |                    10.5 |                    34.5 |                  10.5 |                  34.5 |
| name                        |                 90438 |        205117接地刀闸 | 3电容器90638接地刀闸(4级) |                 10537 |      S2003617接地刀闸 |   2接地变Z238接地刀闸 | 10kV备用线90438接地刀闸 | 35kV客兰线31117接地刀闸 |                 90247 |                 31237 |
| Terminals                   | 115123266313521462_T1 | 115123266145753511_T1 |     115123266229633645_T1 | 115123266313520168_T1 | 115123266145756280_T1 | 115123266179308004_T1 |   115123266179304122_T1 |   115123266380628708_T1 | 115123266263187541_T1 | 115123266313521771_T1 |
| MemberOf_EquipmentContainer |    113152941476544583 |    113152941308772763 |        113152941392658446 |    113152941476544542 |    113152941308772652 |    113152941342326942 |      113152941342326911 |      113152941543653736 |    113152941426212866 |    113152941543653562 |
| node_1                      |      5000027040001009 |      4000135040007016 |          4000017040001027 |      5000015040002006 |      4000005040007055 |      4200052040001066 |        4000119040001045 |        5400100040011008 |      4000044040001052 |      5000096040011008 |
| terminal_1                  | 115123266313521462_T1 | 115123266145753511_T1 |     115123266229633645_T1 | 115123266313520168_T1 | 115123266145756280_T1 | 115123266179308004_T1 |   115123266179304122_T1 |   115123266380628708_T1 | 115123266263187541_T1 | 115123266313521771_T1 |
| taskId                      |                     1 |                     1 |                         1 |                     1 |                     1 |                     1 |                       1 |                       1 |                     1 |                     1 |

## HydroGeneratingUnit

| 字段  |                       0 |                       1 |                       2 |                       3 |                       4 |                       5 |                       6 |                       7 |                       8 |                           9 |
| :---- | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | --------------------------: |
| col_0 | 115686216233385988_UNIT | 115686216166277122_UNIT | 115686216166277124_UNIT | 115686216166277123_UNIT | 115686216233385987_UNIT | 115686216166277125_UNIT | 115686216216608776_UNIT | 115686216233385989_UNIT | 115686216166277121_UNIT |                        mRID |
| col_1 |              -15.500000 |                0.000000 |                0.000000 |                0.000000 |              -15.500000 |                0.000000 |                0.000000 |              -15.500000 |                0.000000 |          minimumOperatingMW |
| col_2 |      113997366373122203 |      113997366306013236 |      113997366306013215 |      113997366306013236 |      113997366373122203 |      113997366306013215 |      113997366356344889 |      113997366373122203 |      113997366306013236 |         MemberOf_Substation |
| col_3 |      112871466332061709 |      112871466332061697 |      112871466332061697 |      112871466332061697 |      112871466332061709 |      112871466332061697 |      112871466332061697 |      112871466332061709 |      112871466332061697 |                 BaseVoltage |
| col_4 |                6.300000 |               10.500000 |               10.500000 |               10.500000 |                6.300000 |               10.500000 |               10.500000 |                6.300000 |               10.500000 |                   volt_name |
| col_5 |                2F15.5MW |              2号机组902 |    10kV1号发电机941开关 |              3号机组903 |                1F15.5MW |    10kV2号发电机942开关 |             那滩5*200kW |                3F15.5MW |              1号机组901 |                        name |
| col_6 |               15.500000 |               20.000000 |               34.500000 |               20.000000 |               15.500000 |               34.500000 |                1.000000 |               15.500000 |               20.000000 |          maximumOperatingMW |
| col_7 |      113152941442990533 |      113152941375881369 |      113152941375881372 |      113152941375881369 |      113152941442990533 |      113152941375881372 |      113152941426213013 |      113152941442990533 |      113152941375881369 | MemberOf_EquipmentContainer |
| col_8 |                0.000000 |                0.000000 |                0.000000 |                0.000000 |                0.000000 |                0.000000 |                0.000000 |                0.000000 |                0.000000 |               raiseRampRate |
| col_9 |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |                      taskId |

## Line

| 索引 |        mRID        |            name | lnSecNum | taskId |
| :--: | :----------------: | --------------: | -------: | -----: |
|  0   | 116249166186807317 |   110kV芙旺北线 |        0 |      1 |
|  1   | 116249166186807325 |    35kV桥格湛线 |        0 |      1 |
|  2   | 116249166186807315 | 110kV运明华桥线 |        0 |      1 |
|  3   | 116249166186807299 |   110kV大秦河线 |        0 |      1 |
|  4   | 116249166186807318 |    35kV彩金紫线 |        0 |      1 |
|  5   | 116249166186807324 |    35kV乐金石线 |        0 |      1 |
|  6   | 116249166186807314 |   110kV谢镇平线 |        0 |      1 |
|  7   | 116249166186807309 |   110kV瑞金木线 |        0 |      1 |
|  8   | 116249166186807329 |    35kV燕安同线 |        0 |      1 |
|  9   | 116249166186807328 |    35kV新佛安线 |        0 |      1 |

## Measurement

|      字段       |                                         0 |                                          1 |                                  2 |                     3 |                                4 |                        5 |                     6 |                     7 |                                   8 |                     9 |
| :-------------: | ----------------------------------------: | -----------------------------------------: | ---------------------------------: | --------------------: | -------------------------------: | -----------------------: | --------------------: | --------------------: | ----------------------------------: | --------------------: |
|      mRID       |                        114560573991027601 |                         116812287955697773 |                 115967863042343129 |    117375280724574456 |               114560531158794584 |       115404955870823731 |    115686559696552041 |    115405127803732166 |                  117938187946426453 |    117375366623920385 |
|    minValue     |                                         0 |                                          0 |                                  0 |                     0 |                                0 |                        0 |                     0 |                     0 |                                   0 |                     0 |
|    maxValue     |                                         0 |                                          0 |                                  0 |                     0 |                                0 |                        0 |                     0 |                     0 |                                   0 |                     0 |
| MeasurementType |                                     41540 |                                      41540 |                              41530 |                 41530 |                            41530 |                    41050 |                 41540 |                 41090 |                               41570 |                 41550 |
|  MemberOf_PSR   |                        114560316292989841 |                         116530641180295223 |                 115967691243651289 |    117375065976209656 |               114560316410429784 |       115404741122458931 |    115686216099168361 |    115404741256675526 |                  117938016147734613 |    117375065976209665 |
|      name       | 防城港.防城港35kV那梭站_10kV母线分段900-Q | 玉林.110kVPAST接站1_110kV望镇良线_长望侧-Q | 百色.110kV新安站_35kV铝板厂线313-P |       1主变低端绕组-P | 来宾.110kV河西站_10kV农贸线927-P | 等值机变电站_机端母线4-f |                 3机-Q |              1母线-UB | 崇左.35kV夏石站_10kV2号电容器C02-IA |       1主变低端绕组-I |
|    Terminal     |                     114560316292989841_T1 |                         116812116157005933 |              115967691243651289_T1 | 117375065976209656_T1 |            114560316410429784_T1 |    115404741122458931_T1 | 115686216099168361_T1 | 115404741256675526_T1 |               117938016147734613_T1 | 117375065976209665_T1 |
|      ifYk       |                                       NaN |                                        NaN |                                NaN |                   NaN |                              NaN |                      NaN |                   NaN |                   NaN |                                 NaN |                   NaN |
|     taskId      |                                         1 |                                          1 |                                  1 |                     1 |                                1 |                        1 |                     1 |                     1 |                                   1 |                     1 |

## MeasurementType

| 索引 |  mRID  |           name            | taskId |
| :--: | :----: | :-----------------------: | :----: |
|  0   | 40740  |      SwitchPosition       |   1    |
|  1   | 410100 |         VoltageC          |   1    |
|  2   | 41050  |         Frequency         |   1    |
|  3   | 41080  |         VoltageA          |   1    |
|  4   | 41090  |         VoltageB          |   1    |
|  5   | 41530  |   ThreePhaseActivePower   |   1    |
|  6   | 41540  |  ThreePhaseReactivePower  |   1    |
|  7   | 41550  |     ThreePhaseCurrent     |   1    |
|  8   | 41560  |          Voltage          |   1    |
|  9   | 41570  |    ThreePhaseCurrentA     |   1    |
|  10  | 41580  |    ThreePhaseCurrentB     |   1    |
|  11  | 41590  |    ThreePhaseCurrentC     |   1    |
|  12  | 425100 |           Angle           |   1    |
|  13  | 42570  |  ACThreePhaseActivePower  |   1    |
|  14  | 42580  | ACThreePhaseReactivePower |   1    |
|  15  | 42590  |        TapPosition        |   1    |
|  16  | 43310  |          计算值           |   1    |
|  17  | 43420  |     nari_RelaySignal      |   1    |
|  18  | 43510  |        测点遥信值         |   1    |
|  19  | 43610  |        测点遥测值         |   1    |

## meas_analog

| 索引 |  @   |                 ID |     Value | Quality |
| :--: | :--: | -----------------: | --------: | ------: |
|  0   |  #   | 115405084719842644 |  20.80000 |       1 |
|  1   |  #   | 114560616856816976 | 760.80000 |       1 |
|  2   |  #   | 115967905824245354 |   0.00000 |       1 |
|  3   |  #   | 115967948891357330 |  57.65620 |       1 |
|  4   |  #   | 117938144996753482 |   0.00000 |       1 |
|  5   |  #   | 115967948941689513 |   6.00584 |       0 |
|  6   |  #   | 117375280925901023 |  -2.40300 |       1 |
|  7   |  #   | 116812287804704297 |   2.79900 |       1 |
|  8   |  #   | 116812288039584096 |   1.02296 |       1 |
|  9   |  #   | 116812373804712151 |   0.00000 |       0 |

## meas_discrete

| 索引 |  @   |                 ID | Status | Quality |
| :--: | :--: | -----------------: | -----: | ------: |
|  0   |  #   | 115123395028323633 |      0 |     1.0 |
|  1   |  #   | 114560488108459892 |      1 |     1.0 |
|  2   |  #   | 114560488158789817 |      0 |     1.0 |
|  3   |  #   | 115123395028326639 |      0 |     1.0 |
|  4   |  #   | 114560487991021888 |      1 |     1.0 |
|  5   |  #   | 114841920169057129 |      1 |     1.0 |
|  6   |  #   | 114841920135496512 |      1 |     1.0 |
|  7   |  #   | 114841920118719090 |      0 |     1.0 |
|  8   |  #   | 114560487991020110 |      1 |     1.0 |
|  9   |  #   | 115123395045100429 |      0 |     1.0 |

## parameters_status

|             字段              |  0   |
| :---------------------------: | :--: |
|              id               | 1.0  |
|            tap_bus            | NaN  |
|             z_bus             | NaN  |
|             area              | NaN  |
|             zone              | NaN  |
|            circuit            | NaN  |
|             type              | NaN  |
|               R               | NaN  |
|               X               | NaN  |
|               B               | NaN  |
|            Line_Q1            | NaN  |
|            Line_Q2            | NaN  |
|            Line_Q3            | NaN  |
|          control_bus          | NaN  |
|             side              | NaN  |
| transformer_final_turns_ratio | NaN  |
|    transformer_final_angle    | NaN  |
|            Min_tap            | NaN  |
|            Max_tap            | NaN  |
|           step_size           | NaN  |
|           Min_volt            | NaN  |
|           Max_volt            | NaN  |
|           M_P_TLPF            | NaN  |
|           M_Q_TLPF            | NaN  |
|       M_P_TLPF_reverse        | NaN  |
|       M_Q_TLPF_reverse        | NaN  |
|             Ri_eP             | NaN  |
|             Ri_eQ             | NaN  |
|         Ri_eP_reverse         | NaN  |
|         Ri_eQ_reverse         | NaN  |

## PowerTransformer

| 字段                        |                                         0 |                                   1 |                                   2 |                                   3 |                                         4 |                                   5 |                                   6 |                                   7 |                                   8 |                                   9 |
| :-------------------------- | ----------------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: |
| mRID                        |                        117093591116939656 |                  117093591150493939 |                  117093591016276022 |                  117093591100162224 |                        117093591049830461 |                  117093590982721613 |                  117093591133716583 |                  117093590982722029 |                  117093591133716604 |                  117093590982721751 |
| PowerTransformerType        | PowerTransformerType.auxiliaryTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.auxiliaryTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer |
| MemberOf_Substation         |                                       NaN |                                 NaN |                                 NaN |                                 NaN |                                       NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |
| BaseVoltage                 |                                       NaN |                                 NaN |                                 NaN |                                 NaN |                                       NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |
| excitingCurrent             |                                         0 |                                   0 |                                   0 |                                   0 |                                         0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |
| volt_name                   |                                         0 |                                   0 |                                   0 |                                   0 |                                         0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |
| name                        |                                       42B |                             2号主变 |                               1主变 |                            一号主变 |                     10kV1号接地变兼站用变 |                               4主变 |                         35kV1号主变 |                               1主变 |                         35kV2号主变 |                               2主变 |
| ifTerm                      |                                      True |                               False |                               False |                               False |                                      True |                               False |                               False |                               False |                               False |                               False |
| noLoadLoss                  |                                         0 |                                   0 |                                   0 |                                   0 |                                         0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |
| MemberOf_EquipmentContainer |                        113997366373122203 |                  113997366406676605 |                  113997366272458785 |                  113997366356344922 |                        113997366306013200 |                  113997366238904363 |                  113997366389899327 |                  113997366238904582 |                  113997366389899313 |                  113997366238904433 |
| taskId                      |                                         1 |                                   1 |                                   1 |                                   1 |                                         1 |                                   1 |                                   1 |                                   1 |                                   1 |                                   1 |

## SubControlArea

| 索引 |               mRID |     name | MemberOf_ControlArea | taskId |
| :--: | -----------------: | -------: | -------------------: | -----: |
|  0   | 113715891446743041 |     贺州 |   113715891262193664 |      1 |
|  1   | 113715891362856961 |   防城港 |   113715891262193664 |      1 |
|  2   | 113715891480297473 |     来宾 |   113715891262193664 |      1 |
|  3   | 113715891396411393 |     贵港 |   113715891262193664 |      1 |
|  4   | 113715891413188609 |     玉林 |   113715891262193664 |      1 |
|  5   | 113715891262193666 | 广西中调 |   113715891262193664 |      1 |
|  6   | 113715891329302529 |     梧州 |   113715891262193664 |      1 |
|  7   | 113715891429965825 |     百色 |   113715891262193664 |      1 |
|  8   | 113715891295748097 |     柳州 |   113715891262193664 |      1 |
|  9   | 113715891379634177 |     钦州 |   113715891262193664 |      1 |

## Substation

| 字段                    |                  0 |                  1 |                  2 |                  3 |                  4 |                  5 |                  6 |                  7 |                  8 |                  9 |
| :---------------------- | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: |
| mRID                    | 113997366238904380 | 113997366238904521 | 113997366272458774 | 113997366473785441 | 113997366457008133 | 113997366356344959 | 113997366306013191 | 113997366373122104 | 113997366356344889 | 113997366289236097 |
| MaxBaseVoltage          | 112871466332061708 | 112871466332061703 | 112871466332061698 | 112871466332061707 | 112871466332061698 | 112871466332061698 | 112871466332061698 | 112871466332061698 | 112871466332061707 | 112871466332061698 |
| substationType          |             火电厂 |             变电站 |             变电站 |             变电站 |             变电站 |             变电站 |             变电站 |              T接站 |             变电站 |             火电厂 |
| volt                    |                500 |                220 |                110 |                 35 |                110 |                110 |                110 |                110 |                 35 |                110 |
| name                    |           合山新厂 |         野岭变电站 |   柳州.110kV基隆站 |    崇左.35kV城东站 |   来宾.110kV凤凰站 |        钦州.丽光站 |   梧州.110kV里湖站 |         贵港.T接站 | 钦州.浦北-大江口站 |      桂林.深能电厂 |
| x                       |             108.87 |             109.35 |            109.384 |             107.91 |             109.29 |            108.893 |            111.163 |              109.6 |            109.279 |            110.135 |
| y                       |              23.82 |              24.34 |            24.2639 |              22.63 |            23.9373 |            21.8892 |             25.488 |             23.109 |            22.1073 |             25.196 |
| MemberOf_SubControlArea | 113715891262193665 | 113715891262193665 | 113715891295748097 | 113715891497074689 | 113715891480297473 | 113715891379634177 | 113715891329302529 | 113715891396411393 | 113715891379634177 | 113715891312525313 |
| taskId                  |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |

## svg

| 索引 |                                name |                 id |
| :--- | ----------------------------------: | -----------------: |
| 0    |           sf_gg_110kV茶香站.fac.svg | 113997366373122049 |
| 1    |            sf_gg_35kV厚禄站.fac.svg | 113997366373122227 |
| 2    | sf_gx_广西_220kV_贡模变电站.fac.svg | 113997366238904367 |
| 3    |        sf_nn_nn_110kV旱塘站.fac.svg | 113997366255681553 |
| 4    |           sf_qz_城郊-新棠站.fac.svg | 113997366356344950 |
| 5    |         sf_lz_lz_35kV板榄变.fac.svg | 113997366272458834 |
| 6    |            sf_bs_35kV榜圩站.fac.svg | 113997366406676579 |
| 7    | sf_gx_广西_220kV_八一变电站.fac.svg | 113997366238904323 |
| 8    |   sf_gx_广西_220kV_浔州电厂.fac.svg | 113997366238904609 |
| 9    |   sf_yl_yl_110kV_葵阳风电场.fac.svg | 113997366389899353 |

## SynchronousMachine

| 字段                        |                              0 |                              1 |                              2 |                              3 |                              4 |                              5 |                              6 |                              7 |                              8 |                              9 |
| :-------------------------- | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: |
| mRID                        |             115686216099168483 |             115686216099168513 |             115686216099168322 |             115686216099168300 |             115686216149499927 |             115686216149499920 |             115686216099168488 |             115686216099168419 |             115686216099168411 |             115686216250163220 |
| BaseVoltage                 |             112871466332061708 |             112871466332061707 |             112871466332061701 |             112871466332061704 |             112871466332061698 |             112871466332061698 |             112871466332061708 |             112871466332061697 |             112871466332061697 |             112871466332061707 |
| ratedMVA                    |                           5000 |                             21 |                            323 |                            660 |                             50 |                            100 |                           5000 |                             26 |                             57 |                             28 |
| synchronousMachineType      | SynchronousMachineType.thermal | SynchronousMachineType.thermal | SynchronousMachineType.thermal | SynchronousMachineType.thermal | SynchronousMachineType.virtual | SynchronousMachineType.virtual | SynchronousMachineType.thermal | SynchronousMachineType.thermal | SynchronousMachineType.thermal | SynchronousMachineType.thermal |
| volt_name                   |                            525 |                           34.5 |                             18 |                             22 |                            115 |                            115 |                            525 |                           10.5 |                           10.5 |                           34.5 |
| MemberOf_GeneratingUnit     |        115686216099168483_UNIT |        115686216099168513_UNIT |        115686216099168322_UNIT |        115686216099168300_UNIT |        115686216149499927_UNIT |        115686216149499920_UNIT |        115686216099168488_UNIT |        115686216099168419_UNIT |        115686216099168411_UNIT |        115686216250163220_UNIT |
| nodeType                    |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |
| maximumMW                   |                              0 |                              0 |                            323 |                            660 |                             50 |                             80 |                              0 |                             26 |                             57 |                             28 |
| MemberOf_EquipmentContainer |             113152941308773088 |             113152941308773104 |             113152941308772544 |             113152941308772576 |             113152941359104256 |             113152941359104224 |             113152941308773104 |             113152941308772624 |             113152941308772624 |             113152941459767600 |
| maximumMVAr                 |                              0 |                              0 |                          42.75 |                         319.65 |                             50 |                             80 |                              0 |                             12 |                          42.75 |                             28 |
| ratedMW                     |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |
| devState                    |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |
| MemberOf_Substation         |             113997366238904616 |             113997366238904621 |             113997366238904490 |             113997366238904423 |             113997366289236097 |             113997366289236084 |             113997366238904619 |             113997366238904472 |             113997366238904461 |             113997366389899285 |
| minimumMW                   |                              0 |                              0 |                              0 |                              0 |                            -50 |                            -80 |                              0 |                              0 |                              0 |                            0.1 |
| name                        |                 富武乙线等值机 |                      3风电机组 |                            4机 |                            2机 |          110kV深飞线等值发动机 |             灵川北牵引站等值机 |                 梧龙甲线等值机 |                            3机 |                            3机 |           杨村风电场第一组风机 |
| Terminals                   |          115686216099168483_T1 |          115686216099168513_T1 |          115686216099168322_T1 |          115686216099168300_T1 |          115686216149499927_T1 |          115686216149499920_T1 |          115686216099168488_T1 |          115686216099168419_T1 |          115686216099168411_T1 |          115686216250163220_T1 |
| minimumMVAr                 |                              0 |                              0 |                            -19 |                            -60 |                            -50 |                            -80 |                              0 |                              0 |                            -21 |                            0.1 |
| raiseRampRate               |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |
| node_1                      |               4000296040012007 |               4000301040011167 |               4000170040005007 |               4000103040008002 |               4300129040002001 |               4300116040002001 |               4000299040012001 |               4000152040001006 |               4000141040001006 |               4900021040011040 |
| terminal_1                  |          115686216099168483_T1 |          115686216099168513_T1 |          115686216099168322_T1 |          115686216099168300_T1 |          115686216149499927_T1 |          115686216149499920_T1 |          115686216099168488_T1 |          115686216099168419_T1 |          115686216099168411_T1 |          115686216250163220_T1 |
| taskId                      |                              1 |                              1 |                              1 |                              1 |                              1 |                              1 |                              1 |                              1 |                              1 |                              1 |

## TapChanger

| 字段                 |                      0 |                      1 |                      2 |                      3 |                      4 |                      5 |                      6 |                      7 |                      8 |                      9 |
| :------------------- | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: |
| mRID                 | 117375065959432280_TAP | 117375066009763999_TAP | 117375065959433233_TAP | 117375065959432890_TAP | 117375065959432918_TAP | 117375066076873159_TAP | 117375066127204787_TAP | 117375065959433383_TAP | 117375066076873117_TAP | 117375065976209617_TAP |
| neutralStep          |                      3 |                      9 |                      9 |                      4 |                      9 |                      3 |                      3 |                      3 |                      3 |                      9 |
| highStep             |                      5 |                     17 |                     17 |                      7 |                     17 |                      7 |                      5 |                      5 |                      5 |                     17 |
| TransformerWinding   |     117375065959432280 |     117375066009763999 |     117375065959433233 |     117375065959432890 |     117375065959432918 |     117375066076873159 |     117375066127204787 |     117375065959433383 |     117375066076873117 |     117375065976209617 |
| name                 |             广西1532.5 |          桂林1179-1.25 |           广西11791.25 |            来宾174-2.5 |           广西11791.25 |            钦州173-2.5 |            百色153-2.5 |             广西1532.5 |            钦州153-2.5 |           南宁11791.25 |
| stepVoltageIncrement |                   -2.5 |                  -1.25 |                  -1.25 |                   -2.5 |                  -1.25 |                      0 |                   -2.5 |                   -2.5 |                   -2.5 |                  -1.25 |
| lowStep              |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |
| taskId               |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |

## TapChangerType

| 字段                 |                    0 |                  1 |                  2 |                  3 |                  4 |                  5 |                  6 |                  7 |                  8 |                  9 |
| :------------------- | -------------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: |
| mRID                 |   117656540265054315 | 117656540265054304 | 117656540265054421 | 117656540265054355 | 117656540265054299 | 117656540265054433 | 117656540265054366 | 117656540265054426 | 117656540265054361 | 117656540265054351 |
| neutralStep          |                    9 |                 10 |                  4 |                  9 |                  3 |                  9 |                  4 |                  3 |                  9 |                  9 |
| highStep             |                   17 |                 19 |                  7 |                 17 |                  5 |                 17 |                  7 |                  5 |                 17 |                 17 |
| name                 | 贵港SFSZ10-40000/110 |     梧州11910-1.25 |        北海174-2.5 |      贵港1179-1.25 |         广西1532.5 |    防城港1179-1.25 |        南宁1741.25 |         来宾1532.5 |        南宁11791.5 |       玉林11791.25 |
| stepVoltageIncrement |                -1.25 |              -1.25 |                  0 |              -1.25 |               -2.5 |                  0 |              -1.25 |                  0 |               -1.5 |              -1.25 |
| lowStep              |                    1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |
| taskId               |                    1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |                  1 |

## Terminal

| 索引 |               mRID |         Substation | ConductingEquipment |                                  name | ConnectivityNode | taskId |
| :--- | -----------------: | -----------------: | ------------------: | ------------------------------------: | ---------------: | -----: |
| 0    | 116812116022788853 | 113997366255681568 |  116530641046077819 |        清川站.110kV.亭清旱线清川端_T2 | 4100038040002011 |      1 |
| 1    | 116812116123451883 | 113997366356344880 |  116530641146740982 |               35.35kV龙樟安线龙T线_T1 | 4700050040011004 |      1 |
| 2    | 116812116207337724 | 113997366238904592 |  116530641230626942 |                         110.多青线_T2 | 4000269040002022 |      1 |
| 3    | 116812116056343314 | 113997366238904336 |  116530641079632265 |                  110kV.110kV广茶线_T2 | 4000010040002011 |      1 |
| 4    | 116812116140228766 | 113997366238904528 |  116530641163518031 |     220kV运通站-110kV.110kV运明1线_T1 | 4000213040002019 |      1 |
| 5    | 116812116039565966 | 113997366272458864 |  116530641062854983 | 35kV石墨站.35kV.35kV屯石线(石墨侧)_T2 | 4200113040011007 |      1 |
| 6    | 116812116173783170 | 113997366406676496 |  116530641197072449 |                      110.恩平合线3_T2 | 5000022040002009 |      1 |
| 7    | 116812116173783529 | 113997366406676560 |  116530641197072629 |        百色.35kV五村站/35kV.那五线_T1 | 5000086040011007 |      1 |
| 8    | 116812116089897144 | 113997366322790400 |  116530641113186396 |                 35.35kV公独白线303_T2 | 4500001040011002 |      1 |
| 9    | 116812116173783137 | 113997366406676496 |  116530641197072433 |                     35.35kV濑江1线_T1 | 5000016040011005 |      1 |

## ThermalGeneratingUnit

| 字段                        |                       0 |                       1 |                       2 |                       3 |                       4 |                       5 |                       6 |                       7 |                       8 |                       9 |
| :-------------------------- | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: | ----------------------: |
| mRID                        | 115686216099168290_UNIT | 115686216099168498_UNIT | 115686216099168537_UNIT | 115686216099168477_UNIT | 115686216099168418_UNIT | 115686216250163211_UNIT | 115686216099168460_UNIT | 115686216250163209_UNIT | 115686216099168573_UNIT | 115686216099168366_UNIT |
| minimumOperatingMW          |                       0 |                       0 |                       0 |                       0 |                       0 |                     0.1 |                       0 |                     0.1 |                       0 |                       0 |
| MemberOf_Substation         |      113997366238904405 |      113997366238904621 |      113997366238904625 |      113997366238904609 |      113997366238904472 |      113997366389899360 |      113997366238904568 |      113997366389899359 |      113997366238904634 |      113997366238904385 |
| BaseVoltage                 |      112871466332061705 |      112871466332061707 |      112871466332061707 |      112871466332061700 |      112871466332061697 |      112871466332061707 |      112871466332061703 |      112871466332061707 |      112871466332061707 |      112871466332061697 |
| volt_name                   |                      24 |                    34.5 |                    34.5 |                   15.75 |                    10.5 |                    34.5 |                     230 |                    34.5 |                    34.5 |                    10.5 |
| name                        |                     2机 |              19风电机组 |               7风电机组 |                     4机 |                     2机 |     马子岭风电场1组风机 |                 等值机2 |     六林冲风电场4组风机 |               1光伏方阵 |                     2机 |
| maximumOperatingMW          |                     360 |                       0 |                       0 |                     200 |                      26 |                      12 |                    1000 |                     8.8 |                       0 |                      38 |
| MemberOf_EquipmentContainer |      113152941308772565 |      113152941308773103 |      113152941308773116 |      113152941308773071 |      113152941308772627 |      113152941459767588 |      113152941308772940 |      113152941459767586 |      113152941308773136 |      113152941308772592 |
| raiseRampRate               |                       0 |                       0 |                       0 |                       0 |                       0 |                       0 |                       0 |                       0 |                       0 |                       0 |
| taskId                      |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |                       1 |

## three_port_trans

| 字段                        |                                   0 |                                   1 |                                   2 |                                   3 |                                   4 |                                   5 |                                   6 |                                   7 |                                   8 |                                   9 |
| :-------------------------- | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: |
| mRID                        |                  117093591150493908 |                  117093590982721944 |                  117093590982721749 |                  117093590982721540 |                  117093591033053211 |                  117093590982721928 |                  117093590982721843 |                  117093591016276046 |                  117093590982721996 |                  117093590982721724 |
| PowerTransformerType        | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer |
| MemberOf_Substation         |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |
| BaseVoltage                 |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |                                 NaN |
| excitingCurrent             |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |
| volt_name                   |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |
| name                        |                               2主变 |                               1主变 |                               2主变 |                               2主变 |                               2主变 |                               2主变 |                               2主变 |                               1主变 |                               1主变 |                               2主变 |
| ifTerm                      |                               False |                               False |                               False |                               False |                               False |                               False |                               False |                               False |                               False |                               False |
| noLoadLoss                  |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |                                   0 |
| MemberOf_EquipmentContainer |                  113997366406676598 |                  113997366238904543 |                  113997366238904430 |                  113997366238904323 |                  113997366289236007 |                  113997366238904530 |                  113997366238904486 |                  113997366272458800 |                  113997366238904562 |                  113997366238904419 |
| taskId                      |                                   1 |                                   1 |                                   1 |                                   1 |                                   1 |                                   1 |                                   1 |                                   1 |                                   1 |                                   1 |

## three_port_winding

| 字段                        |                     0 |                     1 |                     2 |                     3 |                     4 |                     5 |                     6 |                     7 |                     8 |                     9 |
| :-------------------------- | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: |
| mRID                        |    117375065959432891 |    117375065959432286 |    117375065959433601 |    117375065959432542 |    117375066076873185 |    117375065959433614 |    117375065959433240 |    117375066127204412 |    117375065976209423 |    117375065959432260 |
| BaseVoltage                 |    112871466332061703 |    112871466332061698 |    112871466332061707 |    112871466332061703 |    112871466332061697 |    112871466332061697 |    112871466332061708 |    112871466332061707 |    112871466332061698 |    112871466332061698 |
| ratedMVA                    |                   180 |                   180 |                    90 |                   180 |                    50 |                   120 |                   750 |                    50 |                    50 |                    75 |
| volt_name                   |                   230 |                   115 |                  34.5 |                   230 |                  10.5 |                  10.5 |                   525 |                  34.5 |                   115 |                   115 |
| leakagelmpedence            |                     0 |                     0 |                     0 |                     0 |                  6.28 |                     0 |                     0 |                 18.23 |                     0 |                     0 |
| MemberOf_EquipmentContainer |    113152941308772767 |    113152941308772364 |    113152941308773025 |    113152941308772709 |    113152941426213170 |    113152941308773032 |    113152941308772880 |    113152941476544557 |    113152941325549631 |    113152941308772360 |
| ratedKV                     |                   230 |                   116 |                    37 |                   220 |                  10.5 |                  10.5 |                   525 |                  38.5 |                   110 |                   121 |
| r                           |                     0 |              0.067675 |              0.014334 |                     0 |              0.003798 |                     0 |                     0 |              0.032907 |                0.6311 |              0.109767 |
| MemberOf_Substation         |    113997366238904459 |    113997366238904339 |    113997366238904594 |    113997366238904390 |    113997366356344969 |    113997366238904475 |    113997366238904528 |    113997366406676493 |    113997366255681543 |    113997366238904334 |
| rPU                         |                     0 |              0.051172 |              0.120428 |                     0 |              0.344455 |                     0 |                     0 |              0.276475 |              0.477202 |                 0.083 |
| windingType                 |   WindingType.primary | WindingType.secondary |  WindingType.tertiary |   WindingType.primary |  WindingType.tertiary |  WindingType.tertiary |   WindingType.primary | WindingType.secondary |   WindingType.primary | WindingType.secondary |
| MemberOf_PowerTransformer   |    117093590982721795 |    117093590982721570 |    117093590982722055 |    117093590982721665 |    117093591100162268 |    117093590982722060 |    117093590982721924 |    117093591150493716 |    117093590999498759 |    117093590982721561 |
| loadLoss                    |                     0 |                     0 |                 149.6 |                     0 |                 184.1 |                     0 |                     0 |                210.29 |                     0 |                     0 |
| name                        |              1主变230 | 淳州站＃1主变中端绕组 |              1主变-低 |              2主变230 |           一号主变-低 |             1主变10.5 |              1主变525 |              1主变-中 |         1主变高端绕组 |              4主变115 |
| x                           |               43.6425 |               -0.7596 |              0.538148 |               45.4601 |              0.145658 |              0.041078 |               56.4204 |             -0.156816 |               26.0513 |             -0.439996 |
| Terminals                   | 117375065959432891_T1 | 117375065959432286_T1 | 117375065959433601_T1 | 117375065959432542_T1 | 117375066076873185_T1 | 117375065959433614_T1 | 117375065959433240_T1 | 117375066127204412_T1 | 117375065976209423_T1 | 117375065959432260_T1 |
| xPU                         |                  8.25 |             -0.574367 |                4.5213 |                8.5936 |               13.2116 |                3.7259 |                 2.047 |               -1.3175 |               19.6985 |               -0.3327 |
| node_1                      |      4000139040007014 |      4000019040002036 |      4000274040011006 |      4000070040007011 |      4700137040001023 |      4000155040001001 |      4000208040012008 |      5000013040011013 |      4100007040002015 |      4000014040002001 |
| terminal_1                  | 117375065959432891_T1 | 117375065959432286_T1 | 117375065959433601_T1 | 117375065959432542_T1 | 117375066076873185_T1 | 117375065959433614_T1 | 117375065959433240_T1 | 117375066127204412_T1 | 117375065976209423_T1 | 117375065959432260_T1 |
| taskId                      |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |

## three_tap_changer

| 字段                 |                      0 |                      1 |                      2 |                      3 |                      4 |                      5 |                      6 |                      7 |                      8 |                      9 |
| :------------------- | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: |
| mRID                 | 117375066093650032_TAP | 117375065992986868_TAP | 117375065976209487_TAP | 117375066076873024_TAP | 117375066160758996_TAP | 117375066009763968_TAP | 117375065959432234_TAP | 117375065959432755_TAP | 117375065959432435_TAP | 117375066060095526_TAP |
| neutralStep          |                      3 |                      3 |                      3 |                      9 |                      9 |                      3 |                      9 |                      1 |                      1 |                      3 |
| highStep             |                      5 |                      5 |                      5 |                     17 |                     17 |                      5 |                     17 |                      1 |                      1 |                      5 |
| TransformerWinding   |     117375066093650032 |     117375065992986868 |     117375065976209487 |     117375066076873024 |     117375066160758996 |     117375066009763968 |     117375065959432234 |     117375065959432755 |     117375065959432435 |     117375066060095526 |
| name                 |            贵港153-2.5 |             柳州1532.5 |             南宁1532.5 |          钦州1179-1.25 |           河池11791.25 |            桂林153-2.5 |           广西11791.25 |               玉林1110 |               柳州1110 |           防城港1532.5 |
| stepVoltageIncrement |                   -2.5 |                   -2.5 |                   -2.5 |                  -1.25 |                  -1.25 |                   -2.5 |                  -1.25 |                      0 |                      0 |                      0 |
| lowStep              |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |
| taskId               |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |

## TransformerWinding

| 字段                        |                     0 |                     1 |                     2 |                       3 |                     4 |                     5 |                     6 |                     7 |                     8 |                     9 |
| :-------------------------- | --------------------: | --------------------: | --------------------: | ----------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: |
| mRID                        |    117375066093650620 |    117375066076872728 |    117375066093650375 |      117375066026541145 |    117375066127204865 |    117375065959433617 |    117375065992986773 |    117375065959433464 |    117375066093650310 |    117375065976209530 |
| BaseVoltage                 |    112871466332061707 |    112871466332061697 |    112871466332061697 |      112871466332061698 |    112871466332061709 |    112871466332061697 |    112871466332061707 |    112871466332061703 |    112871466332061707 |    112871466332061698 |
| ratedMVA                    |                     0 |                    50 |                     8 |                      63 |                    10 |                   120 |                    40 |                   150 |                    10 |                    40 |
| volt_name                   |                  34.5 |                  10.5 |                  10.5 |                     115 |                   6.3 |                  10.5 |                  34.5 |                   230 |                  34.5 |                   115 |
| leakagelmpedence            |                     0 |                     0 |                     0 |                    10.4 |                 14.48 |                     0 |                     0 |                     0 |                     0 |                     0 |
| MemberOf_EquipmentContainer |    113152941442990461 |    113152941426212877 |    113152941442990342 |      113152941375881253 |    113152941476544843 |    113152941308773032 |    113152941342326874 |    113152941308772707 |    113152941442990309 |    113152941325549655 |
| ratedKV                     |                    35 |                  10.5 |                  10.5 |                     110 |                   6.3 |                  10.5 |                  38.5 |                   220 |                  35.5 |                   110 |
| r                           |                     0 |                     0 |                     0 |                0.421657 |                 8e-06 |                     0 |              0.052902 |                     0 |              0.888476 |                 1.366 |
| MemberOf_Substation         |    113997366373122196 |    113997366356344840 |    113997366373122148 |      113997366306013196 |    113997366406676542 |    113997366238904475 |    113997366272458789 |    113997366238904388 |    113997366373122143 |    113997366255681567 |
| rPU                         |                     0 |                     0 |                     0 |                0.318833 |              0.002058 |                     0 |              0.444461 |                     0 |               7.46462 |               1.03289 |
| windingType                 |   WindingType.primary | WindingType.secondary | WindingType.secondary |     WindingType.primary | WindingType.secondary |  WindingType.tertiary | WindingType.secondary |   WindingType.primary |   WindingType.primary |   WindingType.primary |
| MemberOf_PowerTransformer   |    117093591116939592 |    117093591100162058 |    117093591116939472 |      117093591049830435 |    117093591150493925 |    117093590982722061 |    117093591016276029 |    117093590982722007 |    117093591116939440 |    117093590999498805 |
| loadLoss                    |                     0 |                     0 |                     0 |                  242.39 |                  0.04 |                     0 |                     0 |                     0 |                  70.5 |                     0 |
| name                        |         35kV站用变-高 |           二号主变-低 |              1主变-低 | 110kV2号主变100kV侧绕组 |                 8B-中 |             2主变10.5 |         1主变中端绕组 |              2主变230 |              1主变-高 |         2主变高端绕组 |
| x                           |                     0 |                     0 |                     0 |                 21.2326 |              0.295745 |              0.041078 |             -0.137484 |               52.1594 |               10.4853 |                114.95 |
| Terminals                   | 117375066093650620_T1 | 117375066076872728_T1 | 117375066093650375_T1 |   117375066026541145_T1 | 117375066127204865_T1 | 117375065959433617_T1 | 117375065992986773_T1 | 117375065959433464_T1 | 117375066093650310_T1 | 117375065976209530_T1 |
| xPU                         |                     0 |                     0 |                     0 |                 16.0549 |               74.5137 |                3.7259 |              -1.15509 |                  9.86 |               88.0931 |               86.9187 |
| node_1                      |      4800148040011004 |      4700008040001068 |      4800100040001022 |        4400012040002014 |      5000062040013001 |      4000155040001005 |      4200037040011038 |      4000068040007018 |      4800095040011015 |      4100031040002007 |
| terminal_1                  | 117375066093650620_T1 | 117375066076872728_T1 | 117375066093650375_T1 |   117375066026541145_T1 | 117375066127204865_T1 | 117375065959433617_T1 | 117375065992986773_T1 | 117375065959433464_T1 | 117375066093650310_T1 | 117375065976209530_T1 |
| taskId                      |                     1 |                     1 |                     1 |                       1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |

## twoPortWindingMap

| 索引 |      winding1      |      winding2      |
| :--: | :----------------: | :----------------: |
|  0   | 117375066093650673 | 117375066093650674 |
|  1   | 117375066194313643 | 117375066194313644 |
|  2   | 117375065976209863 | 117375065976209864 |
|  3   | 117375066194313493 | 117375066194313494 |
|  4   | 117375066093650464 | 117375066093650465 |
|  5   | 117375066043318415 | 117375066043318416 |
|  6   | 117375066194313632 | 117375066194313633 |
|  7   | 117375066043318364 | 117375066043318365 |
|  8   | 117375065959433462 | 117375065959433463 |
|  9   | 117375065959433737 | 117375065959433738 |

## two_port_trans

| 字段                        |                                   0 |                                   1 |                                   2 |                                         3 |                                   4 |                                         5 |                                         6 |                                   7 |                                   8 |                                   9 |
| :-------------------------- | ----------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------------: | ----------------------------------: | ----------------------------------------: | ----------------------------------------: | ----------------------------------: | ----------------------------------: | ----------------------------------: |
| mRID                        |                  117093591200825346 |                  117093591116939624 |                  117093591033053335 |                        117093591116939383 |                  117093591116939601 |                        117093591217602729 |                        117093591116939542 |                  117093591217602562 |                  117093591116939683 |                  117093591150493828 |
| PowerTransformerType        | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.auxiliaryTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.auxiliaryTransformer | PowerTransformerType.auxiliaryTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer | PowerTransformerType.gsuTransformer |
| MemberOf_Substation         |                                 NaN |                                 NaN |                                 NaN |                                       NaN |                                 NaN |                                       NaN |                                       NaN |                                 NaN |                                 NaN |                                 NaN |
| BaseVoltage                 |                                 NaN |                                 NaN |                                 NaN |                                       NaN |                                 NaN |                                       NaN |                                       NaN |                                 NaN |                                 NaN |                                 NaN |
| excitingCurrent             |                                   0 |                                   0 |                                   0 |                                         0 |                                   0 |                                         0 |                                         0 |                                   0 |                                   0 |                                   0 |
| volt_name                   |                                   0 |                                   0 |                                   0 |                                         0 |                                   0 |                                         0 |                                         0 |                                   0 |                                   0 |                                   0 |
| name                        |                               1主变 |                               2主变 |                               1主变 |                                   2站用变 |                               1主变 |                            35kV2号站变372 |                                     1站变 |                         35kV1号主变 |                               2主变 |                               2主变 |
| ifTerm                      |                               False |                               False |                               False |                                      True |                               False |                                      True |                                      True |                               False |                               False |                               False |
| noLoadLoss                  |                                   0 |                                   0 |                                   0 |                                         0 |                                   0 |                                         0 |                                         0 |                                   0 |                                   0 |                                   0 |
| MemberOf_EquipmentContainer |                  113997366457008130 |                  113997366373122209 |                  113997366289236152 |                        113997366373122082 |                  113997366373122198 |                        113997366238904351 |                        113997366373122177 |                  113997366473785401 |                  113997366373122152 |                  113997366406676534 |
| taskId                      |                                   1 |                                   1 |                                   1 |                                         1 |                                   1 |                                         1 |                                         1 |                                   1 |                                   1 |                                   1 |

## two_port_winding

| 字段                        |                     0 |                     1 |                     2 |                     3 |                     4 |                     5 |                     6 |                     7 |                     8 |                     9 |
| :-------------------------- | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: | --------------------: |
| mRID                        |    117375066093650322 |    117375066127204613 |    117375066009764259 |    117375065959433652 |    117375066093650567 |    117375066076872967 |    117375066009764160 |    117375065992987023 |    117375066127204687 |    117375065976209450 |
| BaseVoltage                 |    112871466332061707 |    112871466332061697 |    112871466332061697 |    112871466332061707 |    112871466332061697 |    112871466332061697 |    112871466332061707 |    112871466332061697 |    112871466332061697 |    112871466332061698 |
| ratedMVA                    |                     8 |                     5 |                    10 |                   120 |                    10 |                  3.15 |                     5 |                     8 |                    10 |                    50 |
| volt_name                   |                  34.5 |                  10.5 |                  10.5 |                  34.5 |                  10.5 |                  10.5 |                  34.5 |                  10.5 |                  10.5 |                   115 |
| leakagelmpedence            |                     0 |                  6.71 |                     0 |                     0 |                     0 |                     0 |                  6.93 |                     0 |                     0 |                     0 |
| MemberOf_EquipmentContainer |    113152941442990311 |    113152941476544728 |    113152941359104366 |    113152941308772418 |    113152941442990436 |    113152941426213045 |    113152941359104320 |    113152941342327028 |    113152941476544755 |    113152941325549636 |
| ratedKV                     |                    35 |                    10 |                  10.5 |                  38.5 |                  10.5 |                  10.5 |                    35 |                  10.5 |                    10 |                   110 |
| r                           |              0.756055 |                     0 |                     0 |                     0 |                     0 |                     0 |              0.065415 |                 1e-06 |                     0 |              0.939899 |
| MemberOf_Substation         |    113997366373122146 |    113997366406676545 |    113997366289236125 |    113997366238904398 |    113997366373122188 |    113997366356344905 |    113997366289236149 |    113997366272458853 |    113997366406676567 |    113997366255681548 |
| rPU                         |               6.35207 |                     0 |                     0 |                     0 |                     0 |                     0 |               0.54959 |                     0 |                     0 |              0.710699 |
| windingType                 |   WindingType.primary | WindingType.secondary | WindingType.secondary | WindingType.secondary | WindingType.secondary | WindingType.secondary |   WindingType.primary | WindingType.secondary | WindingType.secondary |   WindingType.primary |
| MemberOf_PowerTransformer   |    117093591116939446 |    117093591150493809 |    117093591033053365 |    117093590982722074 |    117093591116939565 |    117093591100162163 |    117093591033053316 |    117093591016276144 |    117093591150493846 |    117093590999498771 |
| loadLoss                    |                  39.5 |                0.0125 |                     0 |                     0 |                     0 |                     0 |                 82.48 |                     0 |                     0 |                     0 |
| name                        |              2主变-高 |            2号主变-低 |              2主变-低 |               4主变35 |              1主变-低 |            1号主变-低 |              1主变-高 |         1主变低端绕组 |              1主变-低 |         3主变高端绕组 |
| x                           |               10.6116 |                     0 |                     0 |                     0 |                     0 |                     0 |              0.151925 |                 1e-06 |                     0 |                38.236 |
| Terminals                   | 117375066093650322_T1 | 117375066127204613_T1 | 117375066009764259_T1 | 117375065959433652_T1 | 117375066093650567_T1 | 117375066076872967_T1 | 117375066009764160_T1 | 117375065992987023_T1 | 117375066127204687_T1 | 117375065976209450_T1 |
| xPU                         |               89.1541 |                     0 |                     0 |                     0 |                     0 |                     0 |               1.27641 |                     0 |                     0 |               28.9119 |
| node_1                      |      4800098040011010 |      5000065040001026 |      4300157040001044 |      4000078040011004 |      4800140040001019 |      4700073040001007 |      4300181040011013 |      4200101040001019 |      5000087040001047 |      4100012040002020 |
| terminal_1                  | 117375066093650322_T1 | 117375066127204613_T1 | 117375066009764259_T1 | 117375065959433652_T1 | 117375066093650567_T1 | 117375066076872967_T1 | 117375066009764160_T1 | 117375065992987023_T1 | 117375066127204687_T1 | 117375065976209450_T1 |
| taskId                      |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |                     1 |

## two_tap_changer

| 字段                 |                      0 |                      1 |                      2 |                      3 |                      4 |                      5 |                      6 |                      7 |                      8 |                      9 |
| :------------------- | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: | ---------------------: |
| mRID                 | 117375066043318411_TAP | 117375065976209852_TAP | 117375065959433697_TAP | 117375066127204890_TAP | 117375066009764118_TAP | 117375065992987150_TAP | 117375066076872978_TAP | 117375065976209636_TAP | 117375066093650310_TAP | 117375066009764182_TAP |
| neutralStep          |                      9 |                      4 |                      9 |                     11 |                      2 |                      9 |                      3 |                      9 |                      3 |                      5 |
| highStep             |                     17 |                      7 |                     17 |                     17 |                      3 |                     17 |                      7 |                     17 |                      5 |                      7 |
| TransformerWinding   |     117375066043318411 |     117375065976209852 |     117375065959433697 |     117375066127204890 |     117375066009764118 |     117375065992987150 |     117375066076872978 |     117375065976209636 |     117375066093650310 |     117375066009764182 |
| name                 |          北海1179-1.25 |             南宁1742.5 |           广西11791.25 |         百色11711-1.25 |              桂林132-5 |           柳州11791.25 |            钦州173-2.5 |           南宁11791.25 |            贵港153-2.5 |            桂林175-2.5 |
| stepVoltageIncrement |                  -1.25 |                      0 |                  -1.25 |                      0 |                      0 |                  -1.25 |                      0 |                  -1.25 |                   -2.5 |                      0 |
| lowStep              |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |
| taskId               |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |                      1 |

## VirtualMachine

| 字段   |                              0 |                              1 |                              2 |                              3 |                              4 |                              5 |                              6 |                              7 |                              8 |                              9 |
| :----- | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: | -----------------------------: |
| col_0  |             215404741256675775 |             215404741290229897 |             215404741156012338 |             215404741172789604 |             215404741172789280 |             215404741172789295 |             215404741172789411 |             215404741122457805 |             215404741290229869 |             215404741307006991 |
| col_1  |             112871466332061698 |             112871466332061698 |             112871466332061698 |             112871466332061698 |             112871466332061698 |             112871466332061698 |             112871466332061698 |             112871466332061698 |             112871466332061698 |             112871466332061698 |
| col_2  |                            100 |                            100 |                            100 |                            300 |                            100 |                            300 |                            100 |                            100 |                            100 |                            300 |
| col_3  | SynchronousMachineType.virtual | SynchronousMachineType.virtual | SynchronousMachineType.virtual | SynchronousMachineType.virtual | SynchronousMachineType.virtual | SynchronousMachineType.virtual | SynchronousMachineType.virtual | SynchronousMachineType.virtual | SynchronousMachineType.virtual | SynchronousMachineType.virtual |
| col_4  |                           34.5 |                           34.5 |                           34.5 |                            115 |                           34.5 |                            115 |                           34.5 |                           34.5 |                           34.5 |                            115 |
| col_5  |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |
| col_6  |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |   SynchronousMachineType.other |
| col_7  |                            100 |                            100 |                            100 |                            300 |                            100 |                            300 |                            100 |                            100 |                            100 |                            300 |
| col_8  |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |
| col_9  |                            100 |                            100 |                            100 |                            300 |                            100 |                            300 |                            100 |                            100 |                            100 |                            300 |
| col_10 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |
| col_11 |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |                   DevState.run |
| col_12 |             113997366373122210 |             113997366406676498 |             113997366238904521 |             113997366238904605 |             113997366238904442 |             113997366238904505 |             113997366289236017 |             113997366238904433 |             113997366238904449 |             113997366238904510 |
| col_13 |                           -100 |                           -100 |                           -100 |                           -300 |                           -100 |                           -300 |                           -100 |                           -100 |                           -100 |                           -300 |
| col_14 |                     35kV等值机 |                     35kV等值机 |                     35kV等值机 |                    115kV等值机 |                     35kV等值机 |                    115kV等值机 |                     35kV等值机 |                     35kV等值机 |                     35kV等值机 |                    115kV等值机 |
| col_15 |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |
| col_16 |                           -100 |                           -100 |                           -100 |                           -300 |                           -100 |                           -300 |                           -100 |                           -100 |                           -100 |                           -300 |
| col_17 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |                              0 |
| col_18 |               4800162040011002 |               5000018040011002 |               4000201040011043 |               4000285040002002 |               4000122040011001 |               4000185040002002 |               4300049040011004 |               4000113040011003 |               4000129040011002 |               4000190040002025 |
| col_19 |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |                            NaN |
| col_20 |                              1 |                              1 |                              1 |                              1 |                              1 |                              1 |                              1 |                              1 |                              1 |                              1 |

## VoltageLevel

| 字段                |                  0 |                  1 |                          2 |                  3 |                  4 |                  5 |                  6 |                  7 |                         8 |                  9 |
| :------------------ | -----------------: | -----------------: | -------------------------: | -----------------: | -----------------: | -----------------: | -----------------: | -----------------: | ------------------------: | -----------------: |
| mRID                | 113152941543653722 | 113152941442990081 |         113152941442990524 | 113152941359104356 | 113152941459767492 | 113152941308772505 | 113152941459767580 | 113152941442990096 |        113152941325549910 | 113152941359104096 |
| BaseVoltage         | 112871466332061707 | 112871466332061697 |         112871466332061698 | 112871466332061707 | 112871466332061697 | 112871466332061698 | 112871466332061697 | 112871466332061697 |        112871466332061707 | 112871466332061698 |
| MemberOf_Substation | 113997366473785423 | 113997366238904459 |         113997366373122219 | 113997366289236174 | 113997366389899345 | 113997366238904504 | 113997366389899364 | 113997366373122061 |        113997366255681686 | 113997366289236026 |
| highVoltageLimit    |                  0 |                  0 |                          0 |               37.5 |                 11 |                  0 |                 11 |                  0 |                         0 |                117 |
| lowVoltageLimit     |                  0 |                  0 |                          0 |                 34 |                9.8 |                  0 |                9.8 |                  0 |                         0 |                107 |
| name                |   110kV佛子站/35kV |   220kV启航站-10kV | 发电_110kV朝新风电场/110kV |               35kV |    35kV米场站.10kV |                115 |  35kV凯迪电厂.10kV |   110kV金垌站-10kV | 南宁.35kV宾阳_新桥站/35kV |              110kV |
| taskId              |                  1 |                  1 |                          1 |                  1 |                  1 |                  1 |                  1 |                  1 |                         1 |                  1 |
