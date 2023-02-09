# TigerGraph GSQL 入门

## 准备

在本教程中，我们将向您展示如何创建图模式、在图中加载数据、编写简单的参数化查询以及运行查询。在开始之前，您需要安装TigerGraph系统，验证它正在工作，并清除以前的任何数据。这也有助于熟悉我们的图术语。

### 图是什么?

图是数据实体的集合和它们之间的连接。也就是说，它是一个数据实体的网络。

许多人把数据实体称为节点；在泰格图，我们称它为顶点。复数是顶点。我们称连接为边。顶点和边都可以有属性或属性。下图是一个包含7个顶点(以圆圈表示)和7条边(以直线表示)的图的可视化表示。

![img](D:\Gitee\Ehe\2022\v2-9f339a4a5ccb24caacdc4056c647790a_720w.jpg)

<center>图1 友谊社交图

图模式是描述可以出现在图中的顶点(节点)和边(连接)类型的模型。上面的图有一种顶点(person)和一种边(friendship)。

模式图看起来像一个小图，除了每个节点代表一种顶点类型，每个链接代表一种边类型。

![img](D:\Gitee\Ehe\2022\v2-c5ac75034abf33dbaf5f452c8181f1f4_720w.jpg)

<center>图2  友谊社交图模式

友谊的循环表明友谊是人与人之间的关系。

### 数据集

对于本教程，我们将创建并查询如图1所示的简单友谊社交图。此图的数据由csv(逗号分隔值)格式的两个文件组成。要继续学习本教程，请保存这两个文件，person.csv和freindship.csv，到你的TigerGraph本地磁盘。在我们的运行示例中，我们使用/home/tigergraph/文件夹来存储两个csv文件。

**person.csv**

```text
name,gender,age,state
Tom,male,40,ca
Dan,male,34,ny
Jenny,female,25,tx
Kevin,male,28,az
Amily,female,22,ca
Nancy,female,20,ky
Jack,male,26,fl
```

**friendship.csv**

```text
person1,person2,date
Tom,Dan,2017-06-03
Tom,Jenny,2015-01-01
Dan,Jenny,2016-08-03
Jenny,Amily,2015-06-08
Dan,Nancy,2016-01-03
Nancy,Jack,2017-03-02
Dan,Kevin,2015-12-30
```

### 准备TigerGraph环境

首先，让我们检查一下您是否可以访问GSQL。

1. 打开一个Linux shell。
2. 下面类型的空间。GSQL shell提示符应该如下所示。

```text
#Linux shell
$ gsql 
GSQL >
```

如果GSQL shell没有启动，请尝试使用“gadmin restart all”重新设置系统。如果您需要进一步的帮助，请参阅泰格图知识库和常见问题。

如果这是您第一次使用GSQL，那么TigerGraph数据存储可能是空的。但是，如果您或其他人已经在系统上工作，那么可能已经有一个数据库了。您可以使用“ls”命令列出数据库目录来进行检查。如果它是空的，应该是这样:

```text
#GSQL shell - an empty database catalog
GSQL > ls
---- Global vertices, edges, and all graphs
Vertex Types:
Edge Types:

Graphs:
Jobs:

Json API version: v2
```

如果数据目录不是空的，您将需要清空它以启动本教程。我们假定你得到了你同事的许可。使用命令DROP ALL删除所有数据库数据、它的模式和所有相关的定义。这个命令运行大约需要一分钟。

```text
#GSQL shell - DROP ALL
GSQL > drop all
Dropping all, about 1 minute ...
Abort all active loading jobs 
[ABORT_SUCCESS] No active Loading Job to abort.

Shutdown restpp gse gpe ...
Graph store /usr/local/tigergraph/gstore/0/ has been cleared!
Everything is dropped.
```

**重新启动TigerGraph**

如果由于任何原因需要重新启动TigerGraph，请使用以下命令序列:

```text
#Linux shell - Restarting TigerGraph services
# Switch to the user account set up during installation
# The default is user=tigergraph, password=tigergraph
$ su tigergraph
Password:tigergraph

# Start all services
$ gadmin restart -fy
```

提示：运行来自Linux的GSQL命令

您还可以从Linux shell中运行GSQL命令。要运行单个命令，只需使用“gsql”，后面跟着用单引号括起来的命令行。(如果没有解析歧义，则不需要引号；使用它们更安全。例如：

```text
#Linux shell - GSQL commands from a Linux shell
# "-g graphname" is need for a given graph
gsql -g social 'ls'
gsql 'drop all'
gsql 'ls'
```

您还可以执行您在文件中存储的一系列命令，只需按文件的名称调用“gsql”。

完成之后，可以使用“quit”命令(不带引号)退出GSQL shell。

## 定义一个模式

对于本教程，我们将主要在GSQL shell中以交互模式工作。一些命令将来自Linux shell。创建GSQL图的第一步是定义它的模式。GSQL提供了一组DDL(数据定义语言)命令，类似于SQL DLL命令，用于建模顶点类型、边缘类型和图形。

### 创建一个顶点类型

使用**CREATE VERTEX**命令定义一个名为person的顶点类型。这里，PRIMARY_ID是必需的：每个人都必须有一个唯一的标识符。其余部分是描述每个人顶点的可选属性列表，格式为：attribute_name data_type, attribute_name data_type， ...

```sql
#GSQL command
CREATE VERTEX person (PRIMARY_ID name STRING, name STRING, age INT, gender STRING, state STRING)
```

我们在所有的大写中显示GSQL关键字以突出显示它们，但是它们是不区分大小写的。

GSQL将确认顶点类型的创建。

```text
#GSQL shell
GSQL > CREATE VERTEX person (PRIMARY_ID name STRING, name STRING, age INT, gender STRING, state STRING)
The vertex type person is created.
GSQL >
```

您可以创建任意多的顶点类型。

### 创建一个边类型

接下来，使用CREATE … EDGE命令创建一个名为friendship的EDGE类型。无定向的关键字表示这条边是双向边，这意味着信息可以从两个顶点开始流。如果您希望有一个单向连接，其中信息只从顶点流动，那么使用有向关键字代替无向关键字。这里，FROM和TO被要求指定边缘类型连接的两个顶点类型。一个单独的边通过给出它的源(从)顶点和目标(到)顶点的primary_id来指定。这些属性后面是可选的属性列表，就像顶点定义一样。

```text
#GSQL command
CREATE UNDIRECTED EDGE friendship (FROM person, TO person, connect_day DATETIME)
```

GSQL将确认边类型的创建。

```sql
#GSQL shell
GSQL > CREATE UNDIRECTED EDGE friendship (FROM person, TO person, connect_day DATETIME)
The edge type friendship is created.
GSQL >
```

您可以创建尽可能多的边类型。

### 创建一个图

接下来，使用CREATE GRAPH命令创建一个名为social的图。这里，我们列出了我们想要在这个图中包含的顶点类型和边类型。

```text
#GSQL command
CREATE GRAPH social (person, friendship)
```

GSQL将在几秒钟后确认第一个图的创建，在此期间，它将目录信息推送给所有服务，如GSE、GPE和RESTPP。

```text
#GSQL shell
GSQL > CREATE GRAPH social (person, friendship)

Restarting gse gpe restpp ...

Finish restarting services in 16.554 seconds!
The graph social is created.
```

至此，我们创建了一个person顶点类型、一个friendship边类型和一个包含它们的社交图。现在您已经构建了您的第一个图模式！让我们通过在GSQL shell中输入“ls”命令来查看目录中的内容。

```text
# GSQL shell
GSQL > ls
---- Global vertices, edges, and all graphs

Vertex Types:
  - VERTEX person(PRIMARY_ID name STRING, name STRING, age INT, gender STRING, state STRING) WITH STATS="OUTDEGREE_BY_EDGETYPE"
  
Edge Types:
  - UNDIRECTED EDGE friendship(FROM person, TO person, connect_day DATETIME)

Graphs:
  - Graph social(person:v, friendship:e)
Jobs:


Json API version: v2
```

## 加载数据

在创建图模式之后，下一步是将数据加载到其中。这里的任务是指导GSQL加载程序如何将一组数据文件中的字段关联到我们刚才定义的图模式的顶点类型和边类型中的属性。

您应该有两个数据文件。person.csv和friendship.csv在本地磁盘上的csv。它们可以不在当前的文件夹中。

如果您出于任何原因需要退出GSQL shell，您可以通过输入“quit”（不带引号）来实现。输入gsql以再次进入。

### 定义一个数据加载的工作

下面的加载作业假设您的数据文件位于文件夹/home/tigergraph中。如果它们在其他地方，则在下面的加载作业脚本中替换“/home/tigergraph/person”。csv和“/ home / tigergraph /friendship.csv"和它们对应的文件路径。假设您(回到)GSQL shell中，输入以下命令集。

```sql
#GSQL commands to define a loading job
USE GRAPH social
BEGIN
CREATE LOADING JOB load_social FOR GRAPH social {
   DEFINE FILENAME file1="/home/tigergraph/person.csv";
   DEFINE FILENAME file2="/home/tigergraph/friendship.csv";

   LOAD file1 TO VERTEX person VALUES ($"name", $"name", $"age", $"gender", $"state") USING header="true", separator=",";
   
   LOAD file2 TO EDGE friendship VALUES ($0, $1, $2) USING header="true", separator=",";
}
END
```

让我们来看看这些命令:

- 使用社交图：告诉GSQL您希望使用哪个图。

- 开始……结束：表明多行模式。GSQL shell将把这些标记之间的所有内容视为一个语句。这些只用于交互模式。如果运行存储在命令文件中的GSQL语句，命令解释器将研究整个文件，因此不需要开始和结束提示。

- 创建加载工作：一个加载作业可以描述从多个文件到多个图对象的映射。每个文件必须分配给文件名变量。字段标签可以按名称或位置进行标记。名称标签需要源文件中的标题行。逐位标签使用整数表示源列位置0,1，…在上面的示例中，第一个LOAD语句按名称引用源文件列，而第二个LOAD语句按位置引用源文件列。

    

请注意以下细节:

- file1中的列“name”被映射到两个字段，即PRIMARY_ID和person顶点的“name”属性。
- 在file1，性别先于年龄。在人的顶点，性别在年龄之后。在加载时，根据目标对象(在本 例中为person顶点)所需的顺序来声明属性。
- 每个LOAD语句都有一个using子句。这里它告诉GSQL，两个文件都包含一个标题行(无论我们是否选择使用名称，GSQL仍然需要知道是否将第一行作为数据)。它还指定列分隔符是逗号。GSQL可以处理任何单字符分隔符，而不仅仅是逗号。

当您运行CREATE LOADING JOB 语句时，GSQL将检查语法错误，并检查指定位置中的数据文件。如果没有检测到错误，它将编译并保存您的作业。

```sql
#GSQL shell
GSQL > USE GRAPH social
Using graph 'social'
GSQL > BEGIN
GSQL > CREATE LOADING JOB load_social FOR GRAPH social {
GSQL > DEFINE FILENAME file1="/home/tigergraph/person.csv";
GSQL > DEFINE FILENAME file2="/home/tigergraph/friendship.csv";
GSQL >
GSQL > LOAD file1 TO VERTEX person VALUES ($"name", $"name", $"age", $"gender", $"state") USING header="true", separator=",";
GSQL > LOAD file2 TO EDGE friendship VALUES ($0, $1, $2) USING header="true", separator=",";
GSQL > }
GSQL > END
The job load_social is created.
```

### 运行一个加载的工作

现在可以运行加载作业，将数据加载到图中:

```text
#GSQL command
RUN LOADING JOB load_social
```

结果显示如下

```sql
#GSQL shell
GSQL > run loading job load_social
[Tip: Use "CTRL + C" to stop displaying the loading status update, then use "SHOW LOADING STATUS jobid" to track the loading progress again]
[Tip: Manage loading jobs with "ABORT/RESUME LOADING JOB jobid"]
Starting the following job, i.e.
  JobName: load_social, jobid: social_m1.1528095850854
  Loading log: '/home/tigergraph/tigergraph/logs/restpp/restpp_loader_logs/social/social_m1.1528095850854.log'

Job "social_m1.1528095850854" loading status
[FINISHED] m1 ( Finished: 2 / Total: 2 )
  [LOADED]
  +---------------------------------------------------------------------------+
  |                       FILENAME |   LOADED LINES |   AVG SPEED |   DURATION|
  |/home/tigergraph/friendship.csv |              8 |       8 l/s |     1.00 s|
  |    /home/tigergraph/person.csv |              8 |       7 l/s |     1.00 s|
  +---------------------------------------------------------------------------+
```

注意加载日志文件的位置。本例假设您在默认位置/home/tigergraph/中安装了TigerGraph。在您的安装文件夹中是主要的产品文件夹，tigergraph。在tigergraph文件夹中有几个子文件夹，如日志、文档、配置、bin和gstore。如果您安装在一个不同的位置，例如/usr/local/，那么您将在/usr/local/tigergraph找到产品文件夹。

## 使用内置的SELECT查询进行查询

你现在有了一个有数据的图!您可以运行一些简单的内置查询来检查数据。

### 选择顶点

下面的GSQL命令报告person顶点的总数。person.csv数据文件标题行后有7行。

```sql
#GSQL command
SELECT count() FROM person
```

类似地，下面的GSQL命令报告friendship边的总数。friendship.csv文件在标题行后也有7行。

```sql
#GSQL command
SELECT count() FROM person-(friendship)->person
```

结果如下所示。

```text
GSQL shell
GSQL > SELECT count() FROM person
[{
  "count": 7,
  "v_type": "person"
}]
GSQL > SELECT count() FROM person-(friendship)->person
[{
  "count": 14,
  "e_type": "friendship"
}]
GSQL >
```

为什么有14条边?对于无向边，GSQL实际上创建两条边，每个方向一条。

如果您想查看关于特定顶点集的详细信息，可以使用“SELECT *”和WHERE子句来指定谓词条件。以下是一些可以尝试的语句:

```sql
#GSQL command
SELECT * FROM person WHERE primary_id=="Tom"
SELECT name FROM person WHERE state=="ca"
SELECT name, age FROM person WHERE age > 30
```

结果是JSON格式，如下所示。

```sql
#GSQL shell
GSQL > SELECT * FROM person WHERE primary_id=="Tom"
[{
  "v_id": "Tom",
  "attributes": {
    "gender": "male",
    "name": "Tom",
    "state": "ca",
    "age": 40
  },
  "v_type": "person"
}]
```

```sql
GSQL > SELECT name FROM person WHERE state=="ca"
[
  {
    "v_id": "Amily",
    "attributes": {"name": "Amily"},
    "v_type": "person"
  },
  {
    "v_id": "Tom",
    "attributes": {"name": "Tom"},
    "v_type": "person"
  }
]
```

```sql
GSQL > SELECT name, age FROM person WHERE age > 30
[
  {
    "v_id": "Tom",
    "attributes": {
      "name": "Tom",
      "age": 40
    },
    "v_type": "person"
  },
  {
    "v_id": "Dan",
    "attributes": {
      "name": "Dan",
      "age": 34
    },
    "v_type": "person"
  }
]
```



### **选择边**

以同样的方式，我们可以看到关于边的细节。为了描述一个边，您可以在三个部分中指定顶点和边的类型，并添加一些标点符号来表示遍历方向：

```text
#GSQL syntax
source_type -(edge_type)-> target_type
```

注意，无论是无向边还是有向边，总是使用箭头->。这是因为我们描述的是查询在图中的遍历(搜索)方向，而不是边本身的方向。

我们可以在WHERE子句中使用from_id谓词，从由“from_id”标识的顶点选择所有friendship边。关键字ANY表示允许任何边缘类型或任何目标顶点类型。以下两个查询的结果相同。

```sql
# GSQL command
SELECT * FROM person-(friendship)->person WHERE from_id =="Tom"
SELECT * FROM person-(ANY)->ANY WHERE from_id =="Tom"
```

对内置边选择查询的限制

为了防止查询可能返回过多的输出项，内置边查询有以下限制:

1. 必须指定源顶点类型。

2. 必须指定from_id条件。

用户定义查询没有这样的限制。

结果如下所示。

```sql
#GSQL
GSQL > SELECT * FROM person-(friendship)->person WHERE from_id =="Tom"
[
  {
    "from_type": "person",
    "to_type": "person",
    "directed": false,
    "from_id": "Tom",
    "to_id": "Dan",
    "attributes": {"connect_day": "2017-06-03 00:00:00"},
    "e_type": "friendship"
  },
  {
    "from_type": "person",
    "to_type": "person",
    "directed": false,
    "from_id": "Tom",
    "to_id": "Jenny",
    "attributes": {"connect_day": "2015-01-01 00:00:00"},
    "e_type": "friendship"
  }
]
```

另一种检查图大小的方法是使用管理员工具gadmin的选项之一。从Linux shell中输入命令

```
gadmin status graph -v
```

```sql
#Linux shell
[tigergraph@localhost ~]$ gadmin status graph -v
verbose is ON
=== graph ===
[m1     ][GRAPH][MSG ] Graph was loaded (/usr/local/tigergraph/gstore/0/part/): partition size is 4.00KiB, SchemaVersion: 0, VertexCount: 7, NumOfSkippedVertices: 0, NumOfDeletedVertices: 0, EdgeCount: 14
[m1     ][GRAPH][INIT] True
[INFO   ][GRAPH][MSG ] Above vertex and edge counts are for internal use which show approximate topology size of the local graph partition. Use DML to get the correct graph topology information
[SUMMARY][GRAPH] graph is ready
```

## 使用参数化GSQL查询进行查询

我们刚刚看到运行简单的内置查询是多么简单和快捷。然而，您无疑希望创建自定义或更复杂的查询。GSQL通过参数化的顶点集查询将最大的权力交给您。参数化查询允许您遍历从一个顶点到相邻的顶点集的图，一次又一次地执行计算过程，内置并行执行和方便的聚合操作。您甚至可以让一个查询调用另一个查询。我们从简单的学起。

写一个GSQL参数化查询有三个步骤。

1. 在GSQL中定义查询。这个查询将被添加到GSQL目录中。
2. 在目录中安装一个或多个查询，为每个查询生成一个REST端点。
3. 运行已安装的查询，提供适当的参数，可以调用GSQL命令，也可以通过向REST端点发送HTTP请求。

**一个简单的1-Hop查询**

现在，让我们编写第一个GSQL查询。我们将显示作为输入参数的人的所有直接(1-hop)邻居。

```sql
#GSQL command
USE GRAPH social
CREATE QUERY hello(VERTEX<person> p) FOR GRAPH social{
  Start = {p};
  Result = SELECT tgt
           FROM Start:s-(friendship:e) ->person:tgt;
  PRINT Result;
}
```

此查询具有一个SELECT语句。这里的SELECT语句比内置查询中的语句强大得多。

在这里，您可以执行以下操作：查询开始时，通过从查询调用传入的参数p所标识的person顶点，将一个顶点集“Start”设置为“Start”。**大括号告诉GSQL构造一个包含所包含项目的集合**。

接下来，SELECT语句根据FROM子句中描述的模式描述了1跳遍历:

```sql
Start:s -(friendship:e)- >person:tgt
```

这基本上与我们用于内置select edges查询的语法相同。也就是说，我们从给定的源集(Start)中选择所有的边，这些边具有给定的边类型(friendship)，并以给定的顶点类型(person)结束。我们以前没有见过的一个特性是使用**":alias"**: “s”是顶点集别名，“e" 是边集别名，“tgt”是目标顶点集别名。

返回到初始子句和赋值(“Result = SELECT tgt”)。这里我们看到目标集的别名tgt。这意味着SELECT语句应该返回目标顶点集(通过SELECT查询块中的完整子句集进行过滤和处理)，并将该输出集分配给名为Result的变量。

最后，我们打印出JSON格式的结果顶点集。

### **创建一个查询**

与其在交互模式中定义查询，不如将查询存储在一个文件中，并使用@filename语法从GSQL shell中调用该文件。将上面的查询复制并粘贴到文件/home/tigergraph/hello.gsql中。然后，进入GSQL shell并使用@hello调用该文件（注意，如果您在开始gsql时没有在/home/tigergraph文件夹中，那么您可以使用绝对路径来调用gsql文件。例如 @/home/tigergraph/hello.gsql）。然后运行“ls”命令，查看新加的查询现在在目录中了。

```sql
GSQL > @hello.gsql
Using graph 'social'
The query hello has been added!
GSQL > ls
---- Graph social

Vertex Types: 
  - VERTEX person(PRIMARY_ID name STRING, name STRING, age INT, gender STRING, state STRING) WITH STATS="OUTDEGREE_BY_EDGETYPE"

Edge Types: 
  - UNDIRECTED EDGE friendship(from person, to person, connect_day DATETIME)

Graphs: 
  - Graph social(person:v, friendship:e)

Jobs: 
  - CREATE LOADING JOB load_social FOR GRAPH social {
      DEFINE FILENAME file2 = "/home/tigergraph/friendship.csv";
      DEFINE FILENAME file1 = "/home/tigergraph/person.csv";

      LOAD file1 TO VERTEX person VALUES($"name", $"name", $"age", $"gender", $"state") USING SEPARATOR=",", HEADER="true", EOL="\n";
      LOAD file2 TO EDGE friendship VALUES($0, $1, $2) USING SEPARATOR=",", HEADER="true", EOL="\n";
    }

Queries: 
  - hello(vertex<person> p) 
```

### **安装一个查询**

但是，查询尚未安装;它还不能运行。在GSQL shell中，输入以下命令来安装刚刚添加的查询“hello”。

```sql
#GSQL command
INSTALL QUERY hello
```



```sql
#GSQL shell
GSQL > INSTALL QUERY hello
Start installing queries, about 1 minute ...
hello query: curl -X GET 'http://127.0.0.1:9000/query/social/hello?p=VALUE'. Add -H "Authorization: Bearer TOKEN" if authentication is enabled.

[====================================================] 100% (1/1)
```

数据库安装这个新查询大约需要1分钟。要有耐心！对于大型数据集上的查询，这种小的投资可以在更快的查询执行中获得多次回报，尤其是在使用不同参数多次运行查询时。安装将生成机器指令和一个REST端点。当进度条达到100%后，我们就可以运行这个查询了。

### **在GSQL中运行查询**

要在GSQL中运行查询，请使用“run query”，后跟查询名和一组参数值。

```sql
#GSQL command - run query examples
RUN QUERY hello("Tom")
```

结果以JSON格式显示。Tom有两个一步邻居，即Dan和Jenny。

```sql
#GSQL shell
GSQL > RUN QUERY hello("Tom")
{
  "error": false,
  "message": "",
  "version": {
    "schema": 0,
    "api": "v2"
  },
  "results": [{"Result": [
    {
      "v_id": "Dan",
      "attributes": {
        "gender": "male",
        "name": "Dan",
        "state": "ny",
        "age": 34
      },
      "v_type": "person"
    },
    {
      "v_id": "Jenny",
      "attributes": {
        "gender": "female",
        "name": "Jenny",
        "state": "tx",
        "age": 25
      },
      "v_type": "person"
    }
  ]}]
}
```

### **将查询作为REST端点运行**

在后台，安装一个查询还会生成一个REST端点，这样就可以通过http调用来调用参数化查询。在Linux中，curl命令是提交http请求的最流行的方式。在下面的示例中，所有查询的标准部分用粗体显示；正常权重中的部分属于这个特定的查询和参数值。JSON结果将返回到Linux shell的标准输出。因此，我们的参数化查询变成了http服务!

```shell
#Linux shell
curl -X GET 'http://localhost:9000/query/social/hello?p=Tom'
```

最后，要查看目录中查询的GSQL文本，可以使用

```text
#GSQL command - show query example
#SHOW QUERY query_name. E.g.
SHOW QUERY hello
```

恭喜你！至此，您已经完成了定义、安装和运行查询的整个过程。

## 一个更高级的查询

现在，让我们执行一个更高级的查询。这一次，我们将学习如何使用强大的内置累加器，它充当在图中遍历过程中访问的每个顶点的运行时属性。运行时意味着它们只在查询运行时存在；它们被称为累加器，因为它们是专门用来在查询的隐式并行处理过程中收集(积累)数据的。

```sql
#GSQL command file - hello2.gsql
USE GRAPH social
CREATE QUERY hello2 (VERTEX<person> p) FOR GRAPH social{
  OrAccum  @visited = false;
  AvgAccum @@avgAge;
  Start = {p};

  FirstNeighbors = SELECT tgt
                   FROM Start:s -(friendship:e)-> person:tgt
                   ACCUM tgt.@visited += true, s.@visited += true;

  SecondNeighbors = SELECT tgt
                    FROM FirstNeighbors -(:e)-> :tgt
                    WHERE tgt.@visited == false
                    POST_ACCUM @@avgAge += tgt.age;

  PRINT SecondNeighbors;
  PRINT @@avgAge;
}
INSTALL QUERY hello2
RUN QUERY hello2("Tom")
```

在这个查询中，我们将找到所有与参数化输入人员两步距离的人。为了好玩，我们来计算一下这些2跳邻居的平均年龄。

在这种图遍历算法的标准方法中，您使用一个布尔变量来标记算法“访问”一个顶点的第一次，这样它就知道不再计算它了。为了满足这一需求，我们将定义一个OrAccum类型的**本地累加器**。要声明本地累加器，我们在标识符名称前面加上一个“@”符号。每个累加器类型都有一个默认的初始值；布尔累加器的默认值为false。可以选择指定初始值。

我们还需要计算一个平均值，因此我们将定义一个全局AvgAccum。**全局累加器**的标识符以两个“@”开头。

定义了开始集之后，我们就有了第一个单跳遍历。SELECT和FROM子句与第一个示例相同，但是还有一个附加的ACCUM子句。ACCUM子句中的+=运算符意味着，对于匹配FROM子句模式的每条边，我们将右手边的表达式(true)累加到左手边的累加器（tgt.@visited以及s.@visited）。注意，可能会多次访问源顶点或目标顶点。参照图1，如果我们从顶点Tom开始，会有两个边事件发生，所以第一个SELECT语句中的ACCUM子句会访问Tom两次。由于累加器类型是OrAccum，两遍历的累积效应如下：

```sql
Tom.@visited <==(初始值:false)OR (true)OR(true)
```

请注意，先处理两条边中的哪一条并不重要，因此此操作适合多线程并行处理。最终的结果是，只要访问一个顶点至少一次，它就会以@visited = true结束。第一个SELECT语句的结果被分配给变量FirstNeighbour。

第二个SELECT块将进一步执行一跳，从FirstNeighbor顶点集变量开始，并到达2跳的邻居。注意，这一次，我们在FROM子句中省略了edge类型friendship和目标顶点类型person，但是保留了别名。如果没有提到别名的类型，则将其解释为所有类型。由于我们的图只有一个顶点类型和一个边缘类型，所以逻辑上它与我们指定的类型相同。WHERE子句过滤掉之前被标记为已访问的顶点（1跳邻居和起始顶点p）。这个SELECT语句使用POST_ACCUM而不是ACCUM，原因是POST_ACCUM会遍历顶点集而不是边集，保证我们不会重复计算任何顶点。在这里，我们计算2跳邻居的年龄，得到他们的平均年龄。

最后，p的第二个邻居被打印出来。

这次，我们将以下所有GSQL命令放入一个文件hello2.gsql：

- USE GRAPH social
- 查询定义
- 安装查询
- 运行查询

我们可以在不输入GSQL shell的情况下执行这一完整的命令集。请将上面的GSQL命令复制并粘贴到一个名为/home/tigergraph/hello2.gsql的Linux文件中。

在Linux shell中，在/home/tigergraph下，输入以下内容:

```sql
#Linux shell
gsql hello2.gsql
```

结果如下所示。

**查询的方法总结:**

- 查询被安装在目录中，可以有一个或多个输入参数，从而可以重用查询。
- GSQL查询由一系列SELECT查询块组成，每个查询块生成一个指定的顶点集。
- 每个SELECT查询块都可以开始从前面定义的任何顶点集遍历图形(也就是说，序列不必形成一个线性链)。
- 累加器是具有内置累加操作的运行时变量，用于高效的多线程计算。
- 输出是JSON格式。

## 总结

您应该能够做到以下几点:

- 创建包含多个顶点类型和边类型的图模式。
- 定义一个加载作业，它接受一个或多个CSV文件，并将数据直接映射到图的顶点和边。
- 编写并运行简单的参数化查询，这些查询从一个顶点开始，然后遍历一个或多个跳点，生成最终的顶点集。



# GSQL中的累加器

GSQL是一种图灵完备的图数据库查询语言。与其他图查询语言相比，最大的优势在于它支持累加器——全局的累加器以及附加到每个顶点上的累加器。

GSQL提供了经典的模式匹配语法，这比较容易掌握。除此以外，GSQL还支持强大的**局部累加器**（运行过程中产生的顶点属性）和**全局累加器**（全局范围的状态变量）。我看到有些用户只花了10分钟就能学习掌握模式匹配语法，相比之下，我发现新手学习起累加器就显得力不从心。

这个简短的教程旨在缩短累加器的学习曲线。您读完这篇文章后，**就可以牢牢掌握累加器的本质，然后开始用这种便捷的语言特性来解决现实中的图问题。**

## 什么是累加器

![img](D:\Gitee\Ehe\2022\v2-6fc6706cb56aeb206687860d6487ef6d_720w.jpg)

<center>图1.左侧框是用不同类型的累加器进行累加的GSQL代码。右侧框显示各累加器变量的最终结果。

累加器是GSQL中的状态变量。它的状态在查询的整个生命周期中都是可变的。它具有初始值，然后用户可以多次使用它内置的运算符“+=”，不断地把新值累加到它身上。定义每个累加器变量时都要声明它的类型，这个类型决定了执行“+=”运算时会进行怎样的操作。

在图1的左侧框中，从第3行到第8行，声明了六个不同的累加器变量（带有前缀@@的变量），每个变量都具有唯一的类型。下面，我们解释它们的语义和用法。

**SumAccum <INT>**允许用户不断地将INT值与其内部状态变量相加。如第10行和第11行所示，我们将1和2加到累加器中，最后得到值3（右侧框中的第3行所示）。

**MinAccum <INT>**始终保存着它看到的最小的INT类型的数值。如第14行和第15行所示，我们将1和2累加到MinAccum累加器，最后得到值1（右侧框中的第6行）。

**MaxAccum <INT>**与MinAccum相反。它返回它看到的最大的INT值。第18行和第19行显示我们将传值1和2给它，最后得到值2（在右侧框中的第9行中显示）。

**OrAccum**持续接收累加到它上面的布尔值，每次它把接收的布尔值与累加器中存的布尔状态变量进行Or操作，然后将状态变量更新为Or后的结果值。初始默认值为FALSE。第22行和第23行显示我们向其发送TRUE和FALSE，最终结果值就是TRUE（如右框中的第12行所示）。

**AndAccum**与OrAccum相似，只是它不进行OR操作，而是进行AND操作。第26行和第27行显示我们将TRUE和FALSE累加到累加器后，最终结果值为FALSE（如右框中的第15行所示）。

**ListAccum <INT>**持续将新INT值添加到累加器中存的List变量中。第30-32行显示我们将1,2和[3,4]累加到累加器中，最终得到[1,2,3,4]（如右框中的第19-22行所示）。

## 全局累加器与附加到顶点的累加器

到目前为止，我们了解到，累加器是GSQL语言中有特定类型的变量。现在我们解释一下什么是全局范围和局部范围的累加器。

**全局累加器属于整个查询**。在查询中的任何位置，语句都可以更新它的值。**局部累加器属于每个顶点**。只有在可以访问拥有它的顶点时才能更新它。为了区分它们，我们在声明它们时，给它们的名称使用了特殊前缀。

**@@前缀用于声明全局累加器变量**。它总是单独使用的。比如：@@cnt += 1。

**@前缀用于声明局部累加器变量**。它必须与查询块中的顶点别名一起使用。例如，v.@cnt += 1，其中v是SELECT-FROM-WHERE查询块的FROM子句中所指定的顶点别名。

![img](D:\Gitee\Ehe\2022\v2-0d95345bc844139f35695c7d63dd23d9_720w.jpg)

<center>图2.这个社交关系图由7个“人”类型的顶点和7条“朋友关系”的边组成

现在看一个简易版的社交关系图如图2，它由“人”类型的顶点和“人-人”友谊关系类型的边构成。下面我们编写一个查询，输入为一个“人”类型的顶点，然后从这个顶点向它的邻居做一跳遍历。我们使用@@global_edge_cnt这个累加器来统计共遍历了多少边，使用@vertex_cnt向所有邻居顶点写入一个整数1。

![img](D:\Gitee\Ehe\2022\v2-97356fe31249454d65ebb4c3b0bf350b_720w.jpg)

![img](D:\Gitee\Ehe\2022\v2-cedf4feba9593045010d57f85d30931c_720w.jpg)

图3上一个框是一段查询语句，输入一个人，将其朋友关系的边进行计数，输入到@@global_edge_cnt中，再对所有朋友，累加1到朋友的@vertex_cnt中去。下面的框展示了计算结果。

如图2所示，Dan有4个直接的朋友--Tom，Kevin，Jenny和Nancy，每个朋友都拥有一个本地累加器@vertex_cnt。@@ global_edge_cnt的值则为4，反映了对于每条边，我们各累加1到这个累加器中。

## ACCUM 和 POST-ACCUM

ACCUM和POST-ACCUM子句分步骤执行。在SELECT-FROM-WHERE查询块中，首先执行ACCUM子句，然后执行POST-ACCUM子句。

- **ACCUM**：找到与FROM子句的模式匹配得上的边后，这些**边**会各执行一次ACCUM子句，而且ACCUM子句在这些边上是并发执行的。

- **POST-ACCUM**：POST_ACCUM会对每个涉及的**顶点**执行一次语句。要注意的是，这里说的“涉及的顶点”可以取源顶点，也可以取目标顶点，但两者只能取一。

## 结论

我们已经解释了累加器的机制、它们的类型以及两个不同的范围——全局范围和局部范围。我们还阐述了ACCUM和POST-ACCUM子句的语义。一旦你掌握了这些基础知识，剩下的就是多练习了。我们已经提供了46个基于LDBC的模式的查询。这46个查询分为三组。

[新版](https://github.com/tigergraph/ecosys/tree/ldbc/ldbc_benchmark/tigergraph/queries_v3)




