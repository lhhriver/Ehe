# 功能说明

## 搜索功能

搜索功能入口为左上角搜索框。

1、**帮助功能**：输入？？或??

2、**数据专题选择功能**：输入示例：cls=words，影响其它功能数据源。

3、**索引搜索功能**：输入示例：se=11,20，不影响搜索和点击数据范围。

4、**字符搜索功能**：索引范围是该类别全部数据。

5、**清空搜索结果**：按空格键，搜索结果内容清空。



## 过滤功能

右上角3个文本框，过滤数据用于点击展示数据源。

1、**数据专题选择功能**：输入示例：words

2、**起始索引**：输入示例：11

3、**终止索引**：输入示例：20



## 点击效果

1、**点击效果**：点击空白处，弹出展示内容，第二次点击屏幕，前一次的内容消失。

2、**清空最后一次内容**：按空格键，最后一次内容消失。

3、**单、多行展示切换**：点击右上角第一个图标。



## 雪花飘

1、**雪花飘功能控制**：最优上角的图标可以实现雪花飘功能的开启和关闭。

2、**雪花飘效果**：在开启状态，会随机有图案在屏幕上面飘过。



# 代码说明

- Ehe.html：历史文档版，v1.0，对应all_data.js
- Ehe_dev_1.0.html：开发版，对应all_data_dev.js
- Ehe_dev_2.0.html：开发版，对应all_data_code.js
- **Ehe_dev_pro.html**：最新开发版，对应all_data_code.js

---

**json2xlsx.ipynb：**

- **xlsx2js**
- xlsx2json
- json2xlsx



# 数据说明

-   all_data.js：初版
-   all_data_dev.js：开发版，在all_data.js基础上新增oneday，标准json格式，不要只有vscode格式化。
-   all_data_dev.json：开发版all_data_dev.js数据的json格式

-   all_data_code.xlsx：开发版数据json转的xlsx版本
-   all_data_code.json：开发版数据的xlsx版本转成json版本

---

-   **all_data_dev**.xlsx：开发版数据json转的xlsx版本，后续在该版本迭代

-   **all_data_code**.js：基于开发版数据all_data_dev.xlsx生成的js文件，后续使用该版本



# 开发计划