1. 熟练掌握主流的NLP技术和模型算法，包括但不限CRF、HMM、LSTM、Transformer和BERT，有tensorflow实战经验；
2. 熟悉知识图谱相关的算法和模型设计如：实体识别、关系抽取、知识抽取、知识融合、知识推理；
3. 熟悉主流的图数据库引擎如：Neo4j, Titan, OrientDB, Janus和图查询语言；
4. 熟悉常见的语音识别技术如混合架构的语音识别方法或端到端架构的语音识别方法并有实际的应用落地项目经验优先考虑；
5. 有产品研发思维，善于分析总结解决问题，文字表达能力强，具有良好的学习能力和抗压能力；
6. 具备良好的人际沟通及协调能力，有较强的团队合作精神；
7. 责任心强，具备电力行业从业经验者优先。



# 算法

1. CRF、HMM、LSTM、Transformer和BERT
2. TensorFlow、Pytorch

---





---

# 知识图谱

1. 实体识别、关系抽取、知识抽取、知识融合、知识推理
2. Neo4j, Titan, OrientDB, JanusGraph和图查询语言

---

**问题**：服务厂商

**答案**：

1. 海致星图：海致星图核心研发团队脱胎于百度知识图谱研发部门，经历了知识图谱技术在中国发展的全过程，金融知识图谱开创者
2. 拓尔思：Hbase+ES+JanusGraph
3. 海翼知（PlantData）：KGMS知识图谱管理平台
4. 明略科技： 
5. 欧若数网（vesoft)：**Nebula Graph**

---

**问题**：常见的图数据库：titan、[neo4j](https://so.csdn.net/so/search?q=neo4j)、OrientDB、JanusGraph、HugeGraph、Trinity

**答案**：

1. neo4j的用户生态更加完整，使用量多，受欢迎数据库排名第1。
2. 开源版neo4j不支持分布式，而JanusGraph支持分布式。
3. neo4j的表示语言不直观，没有sql方便。
4. Trinity中的边作为Node的属性存在，本身不能具有属性；JanusGraph和Neo4j的边本身是一个对象，可以具有属性。
5. JanusGraph是titan的升级版，titan目前已无人维护。

---

`Neo4j`：

`Titan`：titan是从2012年开始开发，到2016年停止维护的一个分布式图数据库。Titan是一个可扩展的图形数据库，针对存储和查询包含分布在多机群集中的数百亿个顶点和边缘的图形进行了优化。Titan是一个事务性数据库，可以支持数千个并发用户实时执行复杂的图形遍历。

`OrientDB`：OrientDB是兼具文档数据库的灵活性和图形数据库管理链接能力的可深层次扩展的文档-图形数据库管理系统。可选无模式、全模式或混合模式下。支持许多高级特性，诸如ACID事务、快速索引，原生和SQL查询功能。可以JSON格式导入、导出文档。若不执行昂贵的JOIN操作的话，如同关系数据库可在几毫秒内可检索数以百记的链接文档图。OrientDB支持大部分标准的SQL查询。

`JanusGraph`：JanusGraph是2016年12月27日从Titan fork出来的一个分支，**适配多种数据库和索引**。整体架构,大致分为三部分：图计算框架(TinkerPop)、数据存储(Cassandra,HBase,BerkeleyDB)、索引存储(Elasticsearch,Solr,Lucene)

`图查询语言`： 

---

# ASR & TTS

ASR（Automatic Speech Recognition）

1. 常见的语音识别技术：混合架构、端到端架构
2. 

---

**问题**：混合模型(Hybrid Model)和端到端模型(End-to-end Model)

**答案**：混合模型主要使用HMM(隐马尔科夫模型)计算最终的文本序列(实际是音素序列)。HMM计算需要一个状态转移矩阵和发射矩阵，ASR经典模型GMM/HMM中发射矩阵是通过GMM(混合高斯模型)计算的，整个模型混合使用了GMM和HMM，所以叫混合模型。

相对于混合模型，若使用一个模型直接从语音输入得到最终文本序列，则叫端到端模型，主要代表有基于CTC、Transducer和Attention的模型。

---

**问题**：语音基础知识

**答案**：

---

**问题**：在线和离线有啥区别

**答案**：在线就是处理短的，在线是处理流式数据的。离线就是处理那种长音频的。

---

**问题**：在线和离线从技术架构层面有什么差异

**答案**：中科在线和离线都是使用基于注意力机制神经网络Transformer的混合CTC/Attention端到端语音识别模型，在线模型采用单调注意力计算的方式以及分段编码的方式，解决了Attention模型对全局信息依赖的问题，极大的压缩了模型的时延且对识别性能的损失极小。

讯飞用UBRNN和DFCNN，但是详细的也没有说明。

---

# 产品思维