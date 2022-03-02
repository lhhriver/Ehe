Neo4j是一个世界领先的开源图形数据库，由Java编写。图形数据库也就意味着它的数据并非保存在表或集合中，而是保存为节点以及节点之间的关系。

Neo4j的数据由下面3部分构成：

- 节点
- 边
- 属性

Neo4j除了顶点（Node）和边（Relationship），还有一种重要的部分——属性。无论是顶点还是边，都可以有任意多的属性。属性的存放类似于一个HashMap，Key为一个字符串，而Value必须是基本类型或者是基本类型数组。

在Neo4j中，节点以及边都能够包含保存值的属性，此外：

可以为节点设置零或多个标签（例如Author或Book）

每个关系都对应一种类型（例如WROTE或FRIEND_OF）

关系总是从一个节点指向另一个节点（但可以在不考虑指向性的情况下进行查询）

# Py2Neo安装

Py2Neo是用来对接Neo4j的Python库，接下来对其详细介绍。

官方文档：http://py2neo.org/v3/index.html

GitHub：https://github.com/technige/py2neo

使用pip安装即可：pip install py2neo

# Node & Relationship

Neo4j里面最重要的两个数据结构就是节点和关系，即Node和Relationship，可以通过Node或Relationship对象创建，实例如下：

```python
from py2neo import Node, Relationship

a = Node('Person', name='Alice')
b = Node('Person', name='Bob')
r = Relationship(a, 'KNOWS', b)
print(a, b, r)
```

运行结果：

```
(:Person {name: 'Alice'}) (:Person {name: 'Bob'}) (Alice)-[:KNOWS {}]->(Bob)
```

这样我们就成功创建了两个Node和两个Node之间的Relationship。

Node和Relationship都继承了PropertyDict类，它可以赋值很多属性，类似于字典的形式，例如可通过如下方式对Node或Relationship进行属性赋值，接着上面的代码，实例如下：

```python
a['age'] = 20
b['age'] = 21
r['time'] = '2017/08/31'
print(a, b, r)
```

运行结果：

```
(:Person {age: 20, name: 'Alice'}) (:Person {age: 21, name: 'Bob'}) (Alice)-[:KNOWS {time: '2017/08/31'}]->(Bob)
```

可见通过类似字典的操作方法就可以成功实现属性赋值。

另外还可以通过setdefault()方法赋值默认属性，例如：

```python
a.setdefault('location', '北京')
print(a)
```

运行结果：

```
(:Person {age: 20, location: ‘北京’, name: ‘Alice’})
```

可见没有给a对象赋值location属性，现在就会使用默认属性。

但如果赋值了location属性，则它会覆盖默认属性，例如：

```python
a['location'] = '上海'
a.setdefault('location', '北京')
print(a)
```

运行结果：

```
(:Person {age:20, location: ‘上海’, name: ‘Alice’})
```

另外也可以使用update()方法对属性批量更新，接着上面的例子实例如下：

```python
data = {
    'name': 'Amy',
    'age': 21
}
a.update(data)
print(a)
```

运行结果：

```
(:Person { age:21, location: ‘上海’, name: ‘Amy’})
```

可以看到这里更新了a对象的name和age属性，没有更新location属性，则name和age属性会更新，location属性则会保留。

# Subgraph

Subgraph，子图，是Node和Relationship的集合，最简单的构造子图的方式是通过关系运算符，实例如下：

```python
from py2neo import Node, Relationship

a = Node('Person', name='Alice')
b = Node('Person', name='Bob')
r = Relationship(a, 'KNOWS', b)
s = a | b | r
print(s)
```

运行结果：

```
({(:Person {name: ‘Alice’}), (:Person {name: ‘Bob’})}, {(Alice)-[:KNOWS {}]->(Bob)})
```

这样就组成了一个Subgraph。

另外还可以通过nodes()和relationships()方法获取所有的Node和Relationship，实例如下：

```python
print(s.nodes())
print(s.relationships())
```

运行结果：

```
frozenset({(:Person {name: ‘Alice’}), (:Person {name: ‘Bob’})})
frozenset({(Alice)-[:KNOWS {}]->(Bob)})
```

可以看到结果是frozenset类型。

另外还可以利用&取Subgraph的交集，例如：

```python
s1 = a | b | r
s2 = a | b
print(s1 & s2)
```

运行结果：

```
({(:Person {name: ‘Alice’}), (:Person {name: ‘Bob’})}, {})
```

可以看到结果是二者的交集。

另外我们还可以分别利用keys()、labels()、nodes()、relationships()、types()分别获取Subgraph的Key、Label、Node、Relationship、Relationship Type，实例如下：

```python
s = a | b | r
print(s.keys())
print(s.labels())
print(s.nodes())
print(s.relationships())
print(s.types())
```

运行结果：

```
frozenset({'name'})
frozenset({'Person'})
frozenset({(:Person {name: 'Alice'}), (:Person {name: 'Bob'})})
frozenset({(Alice)-[:KNOWS {}]->(Bob)})
frozenset({'KNOWS'})
```

另外还可以用order()或size()方法来获取Subgraph的Node数量和Relationship数量，实例如下：

```python
from py2neo import Node, Relationship, size, order

s = a | b | r
print(order(s))
print(size(s))
```

运行结果：

```
2
1
```

# Walkable

Walkable是增加了遍历信息的Subgraph，我们通过+号便可以构建一个Walkable对象，例如：

```python
from py2neo import Node, Relationship

a = Node('Person', name='Alice')
b = Node('Person', name='Bob')
c = Node('Person', name='Mike')
ab = Relationship(a, 'KNOWS', b)
ac = Relationship(a, 'KNOWS', c)
w = ab + Relationship(b, 'LIKES', c) + ac
print(w)
```

运行结果：

```
(Alice)-[:KNOWS {}]->(Bob)-[:LIKES {}]->(Mike)<-[:KNOWS {}]-(Alice)
```

这样我们就形成了一个Walkable对象。

另外我们可以调用walk()方法实现遍历，实例如下：

```python
from py2neo import walk

for item in walk(w):
    print(item)
```

运行结果：

```
(:Person {name: ‘Alice’})
(Alice)-[:KNOWS {}]->(Bob)
(:Person {name: ‘Bob’})
(Bob)-[:LIKES {}]->(Mike)
(:Person {name: ‘Mike’})
(Alice)-[:KNOWS {}]->(Mike)
(:Person {name: ‘Alice’})
```

可以看到它从a这个Node开始遍历，然后到b，再到c，最后重新回到a。

另外还可以利用start_node()、end_node()、nodes()、relationships()方法来获取起始Node、终止Node、所有Node和Relationship，例如：

```python
print(w.start_node())
print(w.end_node())
print(w.nodes())
print(w.relationships())
```

运行结果：

```
(:Person {name: ‘Alice’})
(:Person {name: ‘Alice’})
((:Person {name: ‘Alice’}), (:Person {name: ‘Bob’}), (:Person {name: ‘Mike’}), (:Person {name: ‘Alice’}))
((Alice)-[:KNOWS {}]->(Bob), (Bob)-[:LIKES {}]->(Mike), (Alice)-[:KNOWS {}]->(Mike))
```

可以看到本例中起始和终止Node都是同一个，这和walk()方法得到的结果是一致的。

# Graph

在database模块中包含了和Neo4j数据交互的API，最重要的当属Graph，它代表了Neo4j的图数据库，同时Graph也提供了许多方法来操作Neo4j数据库。

Graph在初始化的时候需要传入连接的URI，初始化参数有bolt、secure、host、http_port、https_port、bolt_port、user、password，详情说明可以参考：http://py2neo.org/v3/database.html#py2neo.database.Graph。

初始化的实例如下：

```python
from py2neo import Graph

graph_1 = Graph()
graph_2 = Graph(host="localhost")
graph_3 = Graph("http://localhost:7474/db/data/")
```

另外我们还可以利用create()方法传入Subgraph对象来将关系图添加到数据库中，实例如下：

```python
from py2neo import Node, Relationship, Graph

a = Node('Person', name='Alice')
b = Node('Person', name='Bob')
r = Relationship(a, 'KNOWS', b)
s = a | b | r
graph = Graph(password='123456')
graph.create(s)
```

这里必须确保Neo4j正常运行，其密码为123456，这里调用create()方法即可完成图的创建。

另外我们也可以单独添加单个Node或Relationship，实例如下：

```python
from py2neo import Graph, Node, Relationship

graph = Graph(password='123456')
a = Node('Person', name='Alice')
graph.create(a)
b = Node('Person', name='Bob')
ab = Relationship(a, 'KNOWS', b)
graph.create(ab)
```

另外还可以利用data()方法来获取查询结果：

```python
from py2neo import Graph

graph = Graph(password='123456')
data = graph.run('MATCH (p:Person) return p').data()
print(data)
```

运行结果：

```
[{‘p’: (:Person {name:“Alice”})}, {‘p’: (:Person {name:“Bob”})}]
```

这里是通过CQL语句实现的查询，输出结果即CQL语句的返回结果，是列表形式。

另外输出结果还可以直接转化为DataFrame对象，实例如下：

```python
from py2neo import Graph
from pandas import DataFrame

graph = Graph(password='123456')
data = graph.run('MATCH (p:Person) return p').data()
df = DataFrame(data)
print(df)
```

运行结果：

```
0 {‘name’: ‘Alice’}
1 {‘name’: ‘Bob’}
```

可以利用match()或match_one()方法对Relationship进行查找：

```python
from py2neo import Graph

graph = Graph(password='123456')
relationship = graph.match_one(rel_type='KNOWS')
print(relationship)
```

运行结果：

```
(Alice)-[:KNOWS {}]->(Bob)
```

如果想要更新Node的某个属性可以使用push()方法，例如：

```python
from py2neo import Graph, Node

graph = Graph(password='123456')
a = Node('Person', name='Alice')
a['age'] = 21
graph.push(a)
print(a)
```

运行结果：

```
(:Person {age: 21, name: ‘Alice’})
```

如果想要删除某个Node可以使用delete()方法，例如：

```python
from py2neo import Graph

graph = Graph(password=‘123456’)
node = graph.find_one(label=‘Person’)  # ...
relationship = graph.match_one(rel_type=‘KNOWS’)
graph.delete(relationship)
graph.delete(node)
```

在删除Node时必须先删除其对应的Relationship，否则无法删除Node。

另外我们也可以通过run()方法直接执行CQL语句，例如：

```python
from py2neo import Graph

graph = Graph(password=‘123456’)
data = graph.run(‘MATCH (p:Person) RETURN p LIMIT 5’)
print(list(data))
```

运行结果：

```
[('p':(:Person {age:20,name:"Alice"})), ('p':(:Person {age:20,name:"Alice"})),('p':(:Person{age:20,name:"Alice"}))]
```



# NodeSelector

Graph有时候用起来不太方便，比如如果要根据多个条件进行Node的查询是做不到的，在这里更方便的查询方法是利用NodeSelector，我们首先新建如下的Node和Relationship，实例如下：

```python
from py2neo import Graph, Node, Relationship

graph = Graph(password=‘123456’)
a = Node(‘Person’, name=‘Alice’, age=21, location=‘广州’)
b = Node(‘Person’, name=‘Bob’, age=22, location=‘上海’)
c = Node(‘Person’, name=‘Mike’, age=21, location=‘北京’)
r1 = Relationship(a, ‘KNOWS’, b)
r2 = Relationship(b, ‘KNOWS’, c)
graph.create(a)
graph.create(r1)
graph.create(r2)
```

在这里我们用NodeSelector来筛选age为21的Person Node，实例如下：

```python
from py2neo import Graph, NodeSelector

graph = Graph(password=‘123456’)
selector = NodeSelector(graph)
persons = selector.select(‘Person’, age=21)
print(list(persons))
```

运行结果：

```
[(:Person {age:21,location:“广州”,name:“Alice”}), (:Person {age:21,location:“北京”,name:“Mike”})]
```

另外也可以使用where()进行更复杂的查询，例如查找name是A开头的Person Node，实例如下：

```python
from py2neo import Graph, NodeSelector

graph = Graph(password=‘123456’)
selector = NodeSelector(graph)
persons = selector.select(‘Person’).where(’.name =~ “A.*”’)
print(list(persons))
```

运行结果：

```
[(:Person {age:21,location:“广州”,name:“Alice”})]
```

在这里用了正则表达式匹配查询。

另外也可以使用order_by()进行排序：

```python
from py2neo import Graph, NodeSelector

graph = Graph(password=‘123456’)
selector = NodeSelector(graph)
persons = selector.select(‘Person’).order_by(’.age’)
print(list(persons))
```

运行结果：

```
[(:Person {age:21,location:“广州”,name:“Alice”}), (:Person {age:21,location:“北京”,name:“Mike”}), (:Person {age:22,location:“上海”,name:“Bob”})]
```

前面返回的都是列表，如果要查询单个节点的话，可以使用first()方法，实例如下：

```python
from py2neo import Graph, NodeSelector

graph = Graph(password=‘123456’)
selector = NodeSelector(graph)
person = selector.select(‘Person’).where(’_.name =~ “A.*”’).first()
print(person)
```

运行结果：

```
(:Person {age:21,location:“广州”,name:“Alice”})
```

更详细的内容可以查看：http://py2neo.org/v3/database.html#cypher-utilities。

# OGM

OGM类似于ORM，意为Object Graph Mapping，这样可以实现一个对象和Node的关联，例如：

```python
from py2neo.ogm import GraphObject, Property, RelatedTo, RelatedFrom

class Movie(GraphObject):
    primarykey = ‘title’
    title = Property()
    released = Property()
    actors = RelatedFrom(‘Person’, ‘ACTED_IN’)
    directors = RelatedFrom(‘Person’, ‘DIRECTED’)
    producers = RelatedFrom(‘Person’, ‘PRODUCED’)

class Person(GraphObject):
    primarykey = ‘name’
    name = Property()
    born = Property()
    acted_in = RelatedTo(‘Movie’)
    directed = RelatedTo(‘Movie’)
    produced = RelatedTo(‘Movie’)
```

我们可以用它来结合Graph查询，例如：

```python
from py2neo import Graph
from py2neo.ogm import GraphObject, Property

graph = Graph(password=‘123456’)
class Person(GraphObject):
    primarykey = ‘name’
    name = Property()
    age = Property()
    location = Property()

person = Person.select(graph).where(age=21).first()
print(person)
print(person.name)
print(person.age)
```

运行结果：

```
Alice
21
```

这样我们就成功实现了对象和Node的映射。

我们可以用它动态改变Node的属性，例如修改某个Node的age属性，实例如下：

```python
person = Person.select(graph).where(age=21).first()
print(person.ogm.node)
person.age = 22
print(person.ogm.node)
graph.push(person)
```

运行结果：

```
(:Person {age:21,location:“北京”,name:“Mike”})
(:Person {age:22,location:“北京”,name:“Mike”})
```

另外我们也可以通过映射关系进行Relationship的调整，例如通过Relationship添加一个关联Node，实例如下：

```python
from py2neo import Graph
from py2neo.ogm import GraphObject, Property, RelatedTo

graph = Graph(password=‘123456’)
class Person(GraphObject):
    primarykey = ‘name’
    name = Property()
    age = Property()
    location = Property()
    knows = RelatedTo(‘Person’, ‘KNOWS’)

person = Person.select(graph).where(age=21).first()
print(list(person.knows))
new_person = Person()
new_person.name = ‘Durant’
new_person.age = 28
person.knows.add(new_person)
print(list(person.knows))
```

运行结果：

```
[]
[, ]
```

这样我们就完成了Node和Relationship的添加，同时由于设置了primarykey为name，所以不会重复添加。
但是注意此时数据库并没有更新，只是对象更新了，如果要更新到数据库中还需要调用Graph对象的push()或pull()方法，添加如下代码即可：

```python
graph.push(person)
```

也可以通过remove()方法移除某个关联Node，实例如下：

```python
person = Person.select(graph).where(name=‘Alice’).first()
target = Person.select(graph).where(name=‘Durant’).first()
person.knows.remove(target)
graph.push(person)
graph.delete(target)
```

这里target是name为Durant的Node，代码运行完毕后即可删除关联Relationship和删除Node。

以上便是OGM的用法，查询修改非常方便，推荐使用此方法进行Node和Relationship的修改。

更多内容可以查看：http://py2neo.org/v3/ogm.html#module-py2neo.ogm。

