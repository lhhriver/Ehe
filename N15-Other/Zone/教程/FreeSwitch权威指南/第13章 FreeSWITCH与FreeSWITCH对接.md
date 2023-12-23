# 第01章 PSTN与VoIP基础
# 第02章 PSTN、PBX及呼叫中心业务
# 第03章 初识FreeSWITCH
# 第04章 运行FreeSWITCH
# 第05章 FreeSWITCH架构
# 第06章 拨号计划
# 第07章 SIP协议
# 第08章 媒体
# 第09章 SIP模块
# 第10章 基本技能
# 第11章 基本功能与实现
# 第12章 高级功能与配置实例
# 第13章 FreeSWITCH与FreeSWITCH对接

在前面的章节中，我们学习了FreeSWITCH的基础知识，并带领大家进行了一些实践，以巩固所学的知识。其实，学好FreeSWITCH的关键就是在掌握基础知识，能够用好各种API和App，并配置好Dialplan。无论如何，前面的章节好像都是我们自己跟自己玩。在真实的世界中，无论是什么产品，是一定要跟别人打交道的，何况我们做的是通信。因此，从本章开始，我们逐渐增加一些与其他系统对接的知识。由于我们对FreeSWITCH的配置已经比较熟悉，因此，很容易用FreeSWITCH来实现或模拟一个“其他系统”。所以，在本章我们先来看一看FreeSWITCH跟FreeSWITCH是怎么对接的。这样一方面可以复习并巩固以前所学的知识，另一方面也为与其他系统对接打下良好的基础。

明白了多个FreeSWITCH之间的连接，就很容易理解如何与其他的设备进行对接了。虽然作为FreeSWITCH的粉丝，我想很多读者都会与笔者一样，期待有一天全世界所有的软交换设备都变成FreeSWITCH。

## 在同一台主机上启动多个FreeSWITCH实例

为了测试FreeSWITCH与FreeSWITCH之间的对接，我们需要多个FreeSWITCH实例。它们可以运行在同一台主机上，也可以运行在不同的主机上。在此，我们先从在一台主机上启动多个实例讲起。

本章我们会用到多个FreeSWITCH进行测试。当然，我们可以用很多台主机进行安装测试，也可以在一台服务器上安装多个虚拟机，但这些操作都费时费力。因此，在这里我们探讨一下多个FreeSWITCH实例能否运行在同一台主机上。当然，这对生产环境的FreeSWITCH也有指导意义。比如，有时可能需要在一台生产环境的服务器上部署多个不兼容的系统。

### 背景故事

几年前笔者曾经使用FreeSWITCH通过VoIP做过在线一对一的网络英语口语教学，由于需要连接Skype及Google Talk。就曾经在同一台主机上做过这样的部署，如图13-1所示。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-861855.png)

<center>图13-1　一个网络教学的FreeSWICH部署结构</center>

其中，我们的服务器集群（图中虚线部分）在美国。教员也绝大部分在美国，他们的网络条件比较好，因而直接使用客户端通过SIP连接FreeSWITCH。而学生在中国，不能直接使用SIP，因此，我们直接使用了一些美国运营商的SIP落地网关将SIP呼叫转换到PSTN网络中，再打通学生的手机或固定电话。当然，有时会遇到学生手机信号不好，或者在异地上学习班的情况，此时他们的手机可能会支持高昂的漫游费 [1]，为此我们开发了对Skype和Googl Talk（GTalk）的支持，即从FreeSWITCH中也可以打到学生的Skype或GTalk客户端上。

FreeSWITCH中有支持Skype的模块（原先叫mod_skypiax，后来改名为mod_skypopen）及GTalk（mod_dingaling）模块的支持。当然，我们这里主要讲怎么启动多个实例，而具体的模块配置就不讲了。

当时主要考虑到FreeSWITCH的Skype模块不是很稳定，所以我们把带Skype的FreeSWITCH启动到另一个实例（对于主的FreeSWITCH而言，它们就相当于两个SIP到Skype的转换网关），这样就避免了由于Skype模块崩溃影响到所有业务。当然，为了让Skype模块崩溃后也不影响使用Skype进行通话的学生，我们后来又启动了另一个带有Skype的FreeSWITCH实例。这样，正常情况下两个Skype网关可以平均分担Skype通话，一旦一台崩溃，所有的Skype话务就都由另外一台承担。起到了类似HA（High Availability，高可用）的效果。

后来我们又启动了一个带mod_dingaling的FreeSWITCH实例，用于与Google Talk互通。除了考虑到可能出现的mod_dingaling的稳定性问题外，我们主要是为了让呼叫处理更方便。比如，不管是呼叫什么用户，在主FreeSWITCH上的呼叫字符串都是类似sofia/gateway/<gateway-name>/<dest-number>的形式，从而编程开发方便了许多。

### 练习

这里我们虽不能复现当时的场景，但基本概念是差不多的。我们这里的练习就是在同一机器上启动两个FreeSWITCH实例而互相不冲突，甚至可以用各种方式进行互通。

我们都知道FreeSWITCH默认的配置文件在/usr/local/freeswitch/conf下。这里假设第一个实例已启动并正确运行。

为了启动第二个FreeSWITCH实例，首先我们要复制一个新的环境（放到freeswitch2目录中，以下的操作都在该目录中）：

```bash
# mkdir /usr/local/freeswitch2

# cp -R /usr/local/freeswitch/conf  /usr/local/freeswitch2/

# mkdir /usr/local/freeswitch2/log

# mkdir /usr/local/freeswitch2/db

# ln -sf /usr/local/freeswitch/sounds /usr/local/freeswitch2/sounds
```

其中第1行创建一个新目录freeswitch2，第2行把旧的配置文件（整个conf目录）复制到新目录中，第4、5行分别创建log和db目录，最后一行做个符号链接，确保在新的环境也能正常访问声音文件。

然后，我们需要修改新配置中的一些配置参数以防止端口冲突。第一个要修改的就是Event Socket的端口号，它是在conf/autoload_configs/event_socket.conf.xml中定义的，找到它并把其中的8021改成另一个端口，比方说9021。

接着修改conf/vars.xml，把其中的5060、5080也改成其他的值，如7060和7080。

如果仅做简单的测试的话，改这两个地方就够了。但如果用于生产环境，还需要修改两个实例的配置文件，将其中的RTP端口号的范围改成不冲突的值。FreeSWITCH中自己维护一个RTP端口池，可以在conf/autoload_config/switch.conf.xml中修改，默认值如下（修改成不相互冲突的范围就行）：

```xml
<param name="rtp-start-port" value="16384"/>
<param name="rtp-end-port" value="32768"/>
```

当然如果你还加载了其他的模块，注意要把可能引起冲突的资源都改一下。比如因为笔者要用到mod_erlang_event模块，就需要改autoload_configs/erlang_event.conf.xml中的listen-port和nodename。

下面我们就可以启动测试了：

```
# cd /usr/local/freeswitch2/

# /usr/local/freeswitch2/bin/freeswitch -conf conf -log log -db db
```

以上命令分别用-conf、-log、-db指定新的环境目录。启动完成后将进入控制台。如果想使用fs_cli连接该实例的话，则可以打开另外一个终端窗口，使用如下命令连接（还记得前面我们把端口改成9021了吧？）：

```
/usr/local/freeswitch2/bin/fs_cli -P 9021
```

找个软电话注册到7060端口试试，比如笔者使用X-Lite注册时，服务器地址填的是192.168.1.100:7060。

当然，为了以后启动方便，也可以将上述启动第二个FreeSWITCH的命令写到一个简单的脚本里面。例如下面我们使用了bash脚本：

```bash
#!/bin/bash
FSDIR=/usr/local/freeswitch2
cd $FSDIR
$FSDIR/bin/freeswitch -conf conf -log log -db db
```

当然，如果需要启动多个实例，只需要重复本节的步骤，将不同实例的配置文件放到不同的目录中去，将相关的参数修改成不冲突的值就可以了。

### 进阶

上一节讲到的两个FreeSWITCH实例运行的是同一份代码。有时候，你还可能运行两个不同版本的FreeSWITCH。在这种情况下，在编译的时候就需要指定一个不同的安装目录，比如下面我们指定将新版本的FreeSWITCH安装到/opt/freeswitch目录中：

```bash
# ./configure --prefix=/opt/freeswitch
# make && make install
```

安装完毕后，如果执行/opt/freeswitch/bin/freeswitch命令，它就默认使用/opt/freeswitch/conf目录下面的配置文件，我们也不需要再复制一份配置文件了。

当然，如果需要两个实例同时运行，还是要修改其中一个的相关端口号，以避免冲突。改完以后就可以使用下列命令启动新的FreeSWITCH实例了：

```
/opt/freeswitch/bin/freeswitch
```

如果用于生产环境，你可能也想把新的配置加到随操作系统启动的自启动文件里去，这些就留给读者自己练习了。

[1] 比较奇怪的是，我们使用的国际落地长途电话比国内的漫游费都便宜。

## FreeSWITCH与FreeSWITCH对接

其实，多机对接的目的就是让不同交换机上的用户能互相打电话。从呼叫上来讲，就是把一个呼叫路由到正确的目的地。在FreeSWITCH中，就是设置正确的Dialplan。在此，我们先来看一下不同的FreeSWITCH交换机（不同的主机或不同的实例）之间的对接。

下面我们就带领大家来看几种常见对接方式和组网情况。

### 双机对接

虽然在13.1节我们在同一台机器上启动了两个实例，理论上讲我们可以继续使用上面的例子做下面的练习。但是，由于下面我们还要讲更多的FreeSWITCH系统（实例），为了防止混乱，这里还是以每台机器上都有一个FreeSWITCH实例来进行讲解，这样我们就可以以不同的IP地址代表不同的FreeSWITCH，讲起来都更容易理解一些。

假设你有两台FreeSWITCH主机，分别为A和B，IP地址分别为192.168.1.A和192.168.1.B。每台机器均使用默认配置，也就是说在每台机器上1000～1019这20个号码之间可以互打电话。位于同一机器上的用户称为本地用户，如果需要与其他机器上的用户通信，则其他机器上的用户就称为外地用户。

如果我们需要两台机器之间的用户可以互拨，最需要解决的问题不是技术上如何配置，而是一个逻辑问题，即我们需要先确定一种拨号方案。例如：如果A上的1000想拨打B上的1000，则B上的1000相对于A上的1000来说就是外地用户。就一般的企业PBX而言，一般拨打外地用户就需要加一个特殊的号码，比方说0。这时0就称为出局字冠 [1]。

由上面例子可知，为了完成该实验，我们规定：不管是A上的用户还是B上的用户，拨打外网用户均需要在实际的电话号码前加拨0。

在A机上，把以下Dialplan片断加到conf/dialplan/default.xml中（注意在测试时，类似我们在前面讲到的，把下列配置加得“靠前”一点，以防止与其他现有的配置项相冲突）：

```xml
<extension name="B">
  <condition field="destination_number" expression="^0(.*)$">
    <action application="bridge" data="sofia/external/sip:$1@192.168.1.B:5080"/>
  </condition>
</extension>
```

其中，正则表示式^0(.*)$表示匹配所有以0开头的被叫号码，匹配完成后，括号中的匹配结果会被绑定到变量$1中。因此，如果A上的用户呼叫01000，则$1的值就是1000，bridge是一个App，它的参数就变成sofia/external/sip:1000@192.168.1.B:5080，它是一个呼叫字符串。在一个呼叫中，当FreeSWITCH执行到这里的bridge时，就会从本机的external Profile（本机的5080端口）向B的5080端口发送INVITE呼叫请求。

注意，在上述过程中，被叫号码中的第一个0在到达B时丢失了。这是系统对接中常用的一个策略，俗称把0“吃掉”了。

B在5080端口上收到INVITE请求后，由于5080端口默认走public Dialplan，所以查找public.xml，可以找到以下的Dialplan配置项：

```xml
<extension name="public_extensions">
  <condition field="destination_number" expression="^(10[01][0-9])$">
    <action application="transfer" data="$1 XML default"/>
  </condition>
</extension>
```

上述Dialplan中的正则表达式^(10[01][0-9])$会匹配被叫号码1000，然后执行transfer，并把来话转到default Dialplan。呼叫转到default Dialplan后，路由规则就跟本地用户的来话一样了，因而最终B上的1000就会振铃。如果B摘机接听，电话就可以接通了。

如果B上的用户也要拨打A上的用户，那么只需要在B上也做类似A上的配置就可以了。因为A和B是完全对称的。

### 汇接

理论上来讲，所有的对接模式都可以采用上面的双机对接模式，即上述的对接模式是一切对接的基础。下面我们来考虑一些更复杂的情况。比方说，在此我们假设全世界的交换机都变成FreeSWITCH的情况。我们将各FreeSWITCH编号为A、B、C、D、E、F、G……如果A上的用户要跟世界上所有的用户都能通话，那么A上就需要配置到所有其他主机的路由，这显然是不现实的。

为了解决这一问题，A、B、C、D开会讨论。D主动说：“我精力比较旺盛，给你们3个提供转接服务吧，你们就不用费心了”。这时候，D就成了一个汇接局，为A、B、C之间的通话做转接服务。A、B、C就称为端局，因为他们只有终端用户（本地用户）。拓扑结构如图13-2所示。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-877855.png)

<center>图13-2　汇接局模式</center>

同时，大家商量了新的拨号规则：本地用户之间的通话拨号规则不变，但是如果拨叫其他外地用户的话，则需要拨打相应的局号（即，如果A上的用户呼叫B上的1000，则拨打B1000），并统一送到D进行汇接。我们以A为例，它上面的Dialplan如下：

```xml
<extension name="D">
  <condition field="destination_number" expression="^([B-Z].*)$">
    <action application="bridge" data="sofia/external/sip:$1@192.168.1.D:5080"/>
  </condition>
</extension>
```

其中，正则表达式^([B-Z].*)$表示任何以B～Z开头的号码（我们假设世界上只有这么多FreeSWITCH）都送到D（即192.168.1.D）的5080端口上去。注意，这里并没有“吃掉”第一位号码，因为如果吃掉的话，D就不知道如何进行下一步路由了。所以，如果A上的用户拨打B1000，在D上将收到B1000。

在D上，收到5080端口的呼叫请求后，查找public Dialplan对来话进行路由。它的Dialplan设置如下：

```xml
<extension name="D">
  <condition field="destination_number" expression="^D(.*)$">
    <action application="transfer" data="$1 XML default"/>
  </condition>
</extension>
```

上述Dialplan说明，如果被叫号码的首位是D，则说明是一个本地用户，所以“吃掉”首位的“D”，然后把路由转（transfer）到default Dialplan进行处理。

对于被叫号码不在本地的用户，则使用下列Dialplan：

```xml
<extension name="D">
  <condition field="destination_number" expression="^([A-CE-Z])(.*)$">
    <action application="bridge" data="sofia/external/sip:$2@192.168.1.$1:5080"/>
  </condition>
</extension>
```

其中，正则表示式^([A-CE-Z])(.*)\$匹配所有除D以外的A到Z开头的被号码。我们还是以有人拨打B1000为例，匹配成功后，$1的值为B，而$2的值为1000，所以，bridge的参数中呼叫字符串就会变成sofia/external/sip:1000@192.168.1.B:5080，因而相当于在D上“吃掉”了被叫号码中最首位的“B”，并把电话送到B的5080端口上。

电话到达B后，B上默认的Dialplan就可以将电话路由到本地用户上，因而电话接通。这种方式就称为汇接模式。由于D即带本地用户，又作为汇接局，因而它是一种混合模式的汇接局。如果D上不带用户，而专门做汇接这项工作，就称为一个纯粹的汇接局。

所有局间的通话都是通过D的，因而它的压力比较大。在实际应用中，如果A、B、C之间的网络直接可达，则可以让D仅转发SIP信令，而让RTP流直接在端局之间传递。在上述配置的bridge Action之前增加如下参数可以让D工作在Bypass Media（媒体绕过）模式，仅转发SIP信令，而让RTP媒体流在端局之间传送：

```xml
<action application="set" data="bypass_media=true"/>
```

上述参数是在Dialplan中设置的，因而仅针对当前通话有效。如果想让D对所有通话，不管什么情况都使用Bypass Media，则可以直接在Profile（这里我们使用的是external）中添加如下设置：

```xml
<param name="inbound-bypass-media" value="true"/>
```

当然，理论上讲，除了D之外，其他的端局也可以采用Bypass Media技术，让媒体流只在终端用户之间发送，而不经过FreeSWITCH。但是，一般来说，终端用户可以会位于NAT设备的后面，它们之前的媒体流互通并不总是可行的，因而在端局很少这么做。

### 双归属

即使采用了Bypass Media，D的压力还是很大。当然，不一定是电话的压力，更可能是精神上的压力。因为，如果一旦D出现了故障，则A、B、C之间的用户就都打不通电话了。

为了解决这一问题，它们又找到来了E，让它做一个备份的汇接局。并且，把D和E的本地用户都分了一下，放到A、B、C上，让D和E专门做汇接。拓扑结构如图13-3所示。

这样就可以把E上的路由规则配置得跟D上一模一样。但每个端局都同时连接到两个汇接局上。一旦其中一个出现故障，则另一个可以接替工作。这种拓扑方式就称为双归属（每个端局都归属于两个汇接局）。端局的配置如下（仍以A为例，注意，由于“192.168.1”太长了，为了排版方便，我们以“IP.”代替它，读者知道它是一个IP地址就行了）：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-891854.png)

<center>图13-3　双汇接局双归属网络拓扑</center>

```xml
<extension name="DE">
  <condition field="destination_number" expression="^([B-Z].*)$">
    <action application="bridge"
      data="sofia/external/sip:$1@IP.D:5080|sofia/external/sip:$1@IP.E:5080"/>
  </condition>
</extension>
```

这里我们修改了呼叫字符串，增加了使用“|”连接起来的两个呼叫字符串。它的意思是，如果第一个呼叫不成功（到D的），则使用下一个呼叫字符串（送到E上）。这种方式就称为主备用模式。

很容易看出，上述配置虽然解决了D的精神压力，但是，它实际的话务压力还是很大的。因为，只要它不出故障，E就没事干，显然很不公平。所以，实际的双归属汇接局大部分是以话务负荷分担的方式进行的。所谓负荷分担，就是平时在端局将50%的通话送到D上，50%通话送到E上，让两端的负载差不多。一旦其中一台发生故障，则所有的通话都送到另外一台上。负荷分担的算法有很多，这里我们可以使用如下Dialplan实现（以A上的出局路由为例）：

```xml
<extension name="DE">
  <condition field="destination_number" expression="^([B-Z].*[13579])$">
    <action application="bridge"
      data="sofia/external/sip:$1@IP.D:5080|sofia/external/sip:$1@IP.E:5080"/>
  </condition>
</extension>
<extension name="ED">
  <condition field="destination_number" expression="^([B-Z].*[24680])$">
    <action application="bridge"
      data="sofia/external/sip:$1@IP.E:5080|sofia/external/sip:$1@IP.D:5080"/>
  </condition>
</extension>
```

通过上述配置，根据正则表达式^([B-Z].*[13579])$，所有被叫号码以奇数结尾的都优先送到汇接局D上（如果D失败仍然会送到E）。同理，所有以偶数结尾的被叫号码都会优先送到E上，如果失败后则尝试D。这就实现了一个简单的50%/50%负荷分担策略。其他类似的策略可以使用随机数实现，也可以使用mod_distributor（FreeSWITCH中的一个模块，参见15.5.4节）中提供的方法实现。当然，实际应用中需要考虑的事情还有很多，这里就不多讲了。

### 长途局

一般来说，一个地级市的电话网络有两个汇接局就够用了。如果需要在不同的地级市间打长途电话，上面需再建设长途局，以便与其他地级市的长途局互通。有了长途局的网络拓扑结构如图13-4所示（我们将另外一个地级市的名称全部以小写字母表示）。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-907858.png)

<center>图13-4　有长途局的网络拓扑</center>

长途局也是采用成对配置的方式，汇接局跟长途局之间也采用双归属。另外，如果某地级市到另外一个地级市的话务量比较高，也可以从汇接局直接向另外一个地市的长途局开中继并设置高速直达路由（如E和t1之间），它可以避免占用本地长途局的资源。当然，极少数情况下也可能从本地端局直接向另外一个地级市的其他局（如汇接局，C和d之间）开通高速直达中继。

有了长途局，就有了长途区号。我们假设长途局T1的长途区号就是T1，按习惯使用0作为国内长途字冠，那么，如果端局a上的用户1000呼叫端局A上的用户1000时，它要拨的号码就是0T1A1000（参见1.2.1节）。这样一通电话经过的各交换机的号码分析和路由，最后走的路径是：1000→a→d（或e）→t1（或t2）→T1（或T2）→D（或E）→A→1000。

具体的配置方式我们就不多讲了。总之，电话网就是这样以树状和网状的结构向外延伸，最终到达世界的每一个角落。电话网内所有的用户也都可以通过一定的拨号规则打通其他的用户的电话。

### ACL

在生产环境中，只考虑把电话接通还是不够的，还得考虑安全性。上面的方法只使用5080端口从public Dialplan做互通，而发送到5080端口的INVITE是不需要鉴权的，这意味着任何人均可以向它发送INVITE从而按你设定的路由规则打电话。这种方式用在端局上问题可能不大，因为你的public Dialplan仅将外面的来话路由到本地用户。但在汇接局模式下，你可能将一个来话再转接到其他局去，那你就需要好好考虑一下安全问题了，因为你肯定不希望全世界的人都通过你的汇接局免费的往各端局打电话。

为了防止这个问题，我们在汇接局上关闭5080端口，而让所有来话都送到5060端口上（internal Profile）。5060端口上的来话是需要先鉴权才能路由的。在这种汇接局模式中，一般会使用IP地址鉴权的方式。而IP地址鉴权就会用到ACL。

ACL（Access Contorl List）即访问控制列表，它通过一个列表矩阵来控制哪些用户可以访问哪些资源。在FreeSWITCH中，实现了基于ACL的鉴权（当然，ACL不仅用于SIP鉴权，还可以用在其他地方）。

其中，internal Profile默认使用“domains”这个ACL进行鉴权。读者可以在internal.xml配置中找到如下的配置：

```xml
<param name="apply-inbound-acl" value="domains"/>
```

上述配置说明，当收到呼叫（INVITE）请求时，要查看“domains”这个ACL，看是否允许来源IP地址进行呼叫。

ACL是在conf/autoload_configs/acl.conf.xml中配置的，其中domains的默认配置如下：

```xml
<list name="domains" default="deny">
  <!-- domain= 是一种特殊情况，它会根据用户目录中的配置生成ACL -->
  <node type="allow" domain="$${domain}"/>
  <!-- 如果你想允许某些IP段能通过该ACL检查的话，使用 cidr= 的配置方式 -->
  <!-- <node type="allow" cidr="192.168.1.123/32"/> -->
</list>
```

其中，第1行说明该列表项的名称是“domains”，可以在其他地方引用，默认（default）的规则是拒绝请求（deny）。其他几行的的含义我们就不在这里介绍了。

如果我们想在D上允许来自A、B、C的呼叫，就可以把A、B、C的地址加到上述配置里面，如可以添加以下配置，以允许（allow）来自这些IP的呼叫 [2]。

```xml
<node type="allow" cidr="192.168.1.A/32"/>
<node type="allow" cidr="192.168.1.B/32"/>
<node type="allow" cidr="192.168.1.C/32"/>
```

通过设置上述ACL，我们就保证了只有授权的用户才能从D上进行路由（当然要记得我们关闭了5080端口，因此所有呼叫要送到5060端口上）。

[1] 以前的交换机又称交换局，因此呼出和呼入就常称为出局和入局。 

[2] 其中，cidr为无状态域间路由（Classless Inter Domain Routing）的表示形式，以“/”分开的为IP地址和掩码中二进制1的位数，32表示掩码中有32个1，对应的十进制表示即255.255.255.255，因而它仅表示一台主机；其他常用的掩码位数有24（255.255.255.0，表示一个C类网段）、27（255.255.255.224，表示一个包含30台主机IP的子网）等。

## FreeSWITCH作为PBX

在图13-4所示的图网络结构中，假设A、B、C一层的都是运营商提供的端局交换机，最底层的1000、1001等是端局上的用户。如果再向下延伸，我们可以在端局用户这一层再搭建自己的PBX，下面再挂分机用户。

### 普通的PBX设置

FreeSWITCH的配置就是一个全功能的PBX。假设我们有了A上1000这个用户账号，我们以前是接了一个SIP软电话往外打电话的。现在，我们把它换成FreeSWITCH（我们称为F），并且在FreeSWITCH上创建600～619这20个用户 [1]，这时候的拓扑结构如图13-5所示。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-922857.png)

<center>图13-5　FreeSWITCH作为PBX</center>

因为F是作为A上的一个用户（1000）存在的，所以它只能作为一个普通用户向A去注册。对于A而言，它就认为F是一个普通的SIP电话客户端（或软电话）。

为了能使F能向A注册，我们在F上添加一个网关（gateway）指向A，配置如下 [2]：

```xml
<include>
    <gateway name="gw_A">
        <param name="realm" value="192.168.1.A"/>
        <param name="username" value="1000"/>
        <param name="password" value="1234"/>
    </gateway>
</include>
```

添加完上述配置后这样，我们就有了一个名称为gw_A的网关。本地的用户600～619就可以通过如下的Dialplan拨打外部的电话了（假设PBX的出局码为0）：

```xml
<extension name="ga_A">
    <condition field="destination_number" expression="^0(.*)$">
        <action application="bridge" data="sofia/gateway/gw_A/$1"/>
    </condition>
</extension>
```

该Dialplan的含义就是遇到以0开头的被叫号码，“吃掉”0，然后将电话送到gw_A定义的网关上。假设分机600想拨打A上的1001，就可以直接拨打01001，600的SIP客户端将向F发送INVITE（呼叫01001），F再向A发送INVITE（1001），对于A而言，F到底是用的FreeSWITCH还是用的SIP软电话都是一样的。在1001上收到呼叫以后，看起来也是从1000打过来的（来电显示的号码是1000）。

如果A上的1001想呼叫600，则它必须先呼叫1000，因为600这个号码是无法直达的（如600这个人的名片上可能印着“电话：总机(A)1000转600”），然后F上会启动一个IVR，让1001输入一个分机号，并为其转接到相应的分机号。

一般来说，端局A不允许主叫号码透传，即不管F上的哪个分机往外打电话，都会在对方的话机上显示1000这个主叫号码。当然，我们这里的A是FreeSWITCH，那么我们就可以设置允许1000往外打电话时进行主叫号码透传。只需要在A上找到1000这个用户的配置文件（1000.xml），将下面的行注释掉就可以了。

```xml
<variable name="effective_caller_id_number" value="1000"/>
```

其中，effective_caller_id_number就表示1000这个用户如果发起呼叫时（从F来的所有呼叫都变为是1000这个用户发起的）对外显示的号码是什么，默认的设置就是1000。注释掉该项后，就会根据实际的来电号码对外进行发送。那么，如果600发起呼叫时，在A上看到的实际的来电号码是什么呢？首先，600发起呼叫时，呼叫到达F，F查找600的用户配置文件，应该能找到类似的如下的配置，因此F将对外发送主叫号码600。

```xml
<variable name="effective_caller_id_number" value="600"/>
```

呼叫到达A后，它看到F送过来的主叫号码是600，而1000这个用户又没有设置effective_caller_id_number这个参数（从F来的所有通话均认为是从1000来的，刚才该参数已经被我们注释掉了）便可以对外显示这个600，因而1001话机上就显示了600，实现了电话号码的透传。

可以看出，实现电话号码透传本身是很简单的事情。所以它本身不是什么技术问题，而在实际应用中主要是面临一个现实问题，那就是如果所有人都可以做任意透传电话号码，那么所有人都可以任意冒充任何人打电话（试想一下有人冒充110或国务院的电话的情况）。

电话号码透传带来的另一个问题就是回呼。在上述情况下，如果1001收到600来的呼叫，显示的主叫号码是600，显然这个号码是无法回呼的，即1001无法通过这个号码直接呼通600，因为600这个号码理论上讲对于1001所在的交换机A来说是不存在的。它最多只能呼通到1000。

为了解决这个问题，我们先把600呼出时对外显示的主叫号码变换一下，下面的代码即Dialplan将600的主叫号码变换为1000600：

```xml
<extension name="ga_A">
  <condition field="destination_number" expression="^0(.*)$">
    <action application="set"
      data="effective_caller_id_number=1000${caller_id_number}"/>
    <action application="bridge" data="sofia/gateway/gw_A/$1"/>
  </condition>
</extension>
```

至于为什么这么变换，我们将在下一节给出答案，并给出回呼解决方案。

### DID

我们在前面的章节中不止一次讲到DID这个概念。在13.1.1的方式中，对于F而言，号码1000就是一个DID。因为在A上的其他用户都可以通过拨打1000这个号码打到F上，其他交换机如B、C上的用户也可以通过拨打A1000呼叫到F上。当然，从13.1.1节我们也看到，其他用户如果想呼叫F内部的分机，就只能先拨叫1000这个DID号码，然后，再通过IVR，以人工总机或自动总机转接的方式转到对应的分机上。那么，我们能不能直接呼叫到内部的分机呢？毕竟，DID的真正含义是“对内直接呼叫”，目前看来，我们还未实现这个目标。

要实现这个在技术上当然是可以的。让我们来考虑这样一种拨号方案：对所有A上的用户而言（如1001），如果想直接呼叫F上的内部分机600~619，就需要呼叫1000加上这些分机号。如1001呼叫F上的600，则需要呼叫1000600。

我们已经在上一节将600对外呼出的主叫号码设置成了可以对外显示1000600，因此只要能在A上设置正确的回呼路由，电话就应该能呼通了。

确定了拨号方案以后，我们再来看在A上的实现。为了要让A上其他用户打1000开头的电话号码都送到F上，我们需要在A上增加一个Dialplan项，于是我们很快想到了如下的Dialplan：

```xml
<extension name="F-DID">
  <condition field="destination_number" expression="^(1000.*)$">
    <action application="bridge" data="..."/>
  </condition>
</extension>
```

其中，我们让的正则表达式^(1000.*)$表示匹配任何以1000开头的电话号码。如果匹配到这样的电话号码，则将电话桥接到我们希望的地方。可是到这里，bridge后面的参数怎么写呢？我们知道，这里我们要给一个呼叫字符串，但是这里的情况不同于我们上面讲到的任何一种情况，呼叫字符串该怎么写呢？

首先，让我们来看一下这里的情况与上述讲的有什么不同。在上面的各种情况中，各FreeSWITCH之间的对接都是通过IP方式的，即一般来说各FreeSWITCH之间都互相知道对方的IP地址，也就是说各FreeSWITCH的IP是相对固定的。而在这里，F的IP地址对A来说是不固定的。因为F是以动态注册的方式注册到A上的，因而只有F向A注册的时候A才能知道F的IP地址，并且F的IP是可以不断变化的，每次变化后F都会重新向A注册它的IP地址，以让A能找到它。在这种情况下，如果让A能找到F，那么我们应该就能在A上动态地获取F的IP地址了。

实际上，我们已经知道，A本来就能动态获取F的IP地址，下面的配置方式我们已经很熟悉了：

```xml
<action application="bridge" data="user/1000"/>
```

上面的呼叫字符串“user/1000”我们已经讲到很多次了，它的作用就是在A上找到1000这个注册用户注册时的Contact地址（即F的地址），然后向该地址上发送INVITE请求。

但在这里，如果我们还是这样配置的话，很显然不能达到我们的要求。因为使用这种方法获取到的呼叫字符串，在呼叫到达F后，被叫号码（即DID）永远是1000，而我们想要在有人呼叫1000606时把被号码变成1000606。所以，这里我们就需要解决两个问题：①在A上动态能找到F的IP地址；②呼叫到达F后被叫号码变成我们指定的被叫号码。

我们先一步一步来看。当F向A注册时，它提供了自己的Contact地址，我们通过前面的学习已经知道，可以用以下命令在A上查看相关信息（以1000为过滤条件显示注册用户）：

```
freeswitch> sofia status profile internal reg 1000

Registrations:
=================================================================

Total items returned: 0
=================================================================
```

但令人奇怪的是，它并没有显示出1000的注册信息。这是为什么呢？

在回答为什么之前，我们先来试一下以下的命令。在下列命令中我们在显示时去掉了1000这个过滤条件，从中我们可以看到类似如下的输出信息（省略其他不相关的输出）：

```
freeswitch> sofia status profile internal reg

Registrations:
=====================================================================

Call-ID:        d3db5f74-3fb9-4951-ac38-75b419ba4894
User:           1000@192.168.1.F
Contact:        "user" <sip:gw+gw_A@192.168.1.F:5080;transport=udp;gw=gw_A>
.....
```

从中可以看出，User一行标明我们的确有一条来自192.168.1.F上的用户1000的注册信息，不过该用户的注册信息中的Contact地址是比较奇怪的。由于它里面没有包含1000这样的用户名，所以我们在上面想用1000为过滤条件限制输出结果时失败了。

当然，该Contact字符串来自于F，我们来讲一下F为什么这么做。

F向A注册是以在F中添加一个到A的网关实现，并以“gw_A”这个名字来标志这个网关。F向A注册时使用了这样的Contact字符串。注册完成后，如果A上有电话需要呼叫F时，F就会向A发送INVITE请求。通过上面的注册信息，A向F发的INVITE请求如下：

```
INVITE gw+gw_A@192.168.1.F:5080;transport=udp;gw=gw_A SIP/2.0
```

这样当F上收到上面的INVITE请求后，就可以知道该呼叫是从gw_A这个网关来的，这样便于知道呼叫的来源。否则的话，F也可以使用像“1000@192.168.1.F:5080”这样的Contact字符串，可是那样的话它会收到类似“INVITE 1000@192.168.1.F:5080”这样的呼入请求，不便于将呼叫来源与F中本身已定义的gw_A网关关联。

继续看上面的INVITE请求。其中有两个“gw_A”。第一个“gw+gw_A”实际上出现在被叫号码的位置，这时候如果F检测到被号号码中有“gw+”以后，就能找到gw_A这个网关了。有时候，在A是其他SIP服务器的情况下，可能会将该字段放入真正的被叫号码，如“INVITE 1000@192.168.1.F...”，这样，F就会尝试从后面的“gw=gw_A”这个位置（分号后面都相当于参数）找到gw_A这个网关名称。当然，如果A不发送这些参数的话，F就无法与系统中配置的网关进行关联了（不过电话仍然可以通）。

F收到上述的INVITE请求后就会在本地的网关gw_A中找到真正的被叫号码1000（从extension参数或username参数中找）。

实际上，上述的Contact地址已经包含了F的IP，我们可以在A的命令行上使用下列命令找到它：

```
freeswitch> sofia_contact internal/1000@192.168.1.A
sofia/internal/sip:gw+gw_A@192.168.1.F:5080;transport=udp;gw=gw_A
```

其中，sofia_contact是一个API命令，它的参数格式为“Profile/User@Domain”。可以看到，我们这里的Profile是internal，User是1000，Domain就是A的IP地址。

在继续往下研究之前，我们需要先来做一些实验。实验中，我们会用到echo和expand这两个API命令。其中，echo命令会将字符串原样输出，如：

```
freeswitch> echo test
test
freeswitch> echo $${domain}
$${domain}
```

我们虽然已经知道A上的Domain（即A的IP地址）是192.168.1.A，而且它也是相对固定的。但是，在实际应用中还是用变量引用比较方便一些。默认情况下，在XML中的配置都是会进行变量替换的，但在命令行上不会。如果要在命令行上进行变量替换，就需要用到一个expand API命令：

```
freeswitch> expand echo $${domain}
192.168.1.A
```

可以看到，由于expand的作用，$${domain}被替换成了实际的值。接下来，我们继续进行实验：

```
freeswitch> expand sofia_contact internal/1000@$${domain}
sofia/internal/sip:gw+gw_A@192.168.1.F:5080;transport=udp;gw=gw_A
```

有了1000的Contact地址后，我们可以构造如下的命令呼叫它，如：

```
freeswitch> expand echo originate ${sofia_contact(internal/1000@$${domain})} &echo
originate sofia/internal/sip:gw+gw_A@192.168.1.F:5080;transport=udp;gw=gw_A &echo
```

可以使用“\${API命令(参数)}”的形式引用一个API命令的结果。所以上述的originate命令后面的参数需要的呼叫字符串就是用“\${sofia_contact()}”动态获取的。当然，上述的命令是echo输出后的结果，如果我们去掉echo，就可以直接执行originate呼叫1000了：

```
freeswitch> expand originate ${sofia_contact(internal/1000@$${domain}) &echo
```

在A上执行上述originate命令后，它就会向F发送如下的INVITE请求：

```
INVITE sip:gw+gw_A@192.168.1.A:5080;transport=udp;gw=gw_A SIP/2.0
To: <sip:gw+gw_A@192.168.1.A:5080;transport=udp;gw=gw_A>
```

然后F在收到上述请求后就能找到gw_A这个在本地配置的网关，进而找到对应的被叫号码1000，并进行路由。

如果要将被叫号码改为我们指定的被叫号码（如1000606），我们只需要想办法改变INVITE请求中的被叫号码部分，即将sip:gw+gw_A@192.168.1.A:5080变成sip:1000606@192.168.1.A:5080即可。为了达到这个目的，我们使用正则表达式替换。其中，FreeSWITCH提供了一个regex API命令可以进行正则表达式替换，它的语法是“regex原字符串|正则表达式|替换后的内容”，如：

```
freeswitch> regex sip:gw+gw_A|^sip:gw\+(.*)|sip:1000606
sip:1000606
```

其中，使用“^sip:gw\+(.*)”作为正则表达式匹配就可以将原字符串“sip:gw+gw_A”替换为“sip:1000606”，这也是我们主要需要替换的部分。好了，我们来看一个完整的替换，替换前的字符串为：

```
freeswitch> expand echo originate ${sofia_contact(internal/1005@$${domain})} &echo
originate sofia/internal/sip:gw+gw_A@192.168.1.F:5080;transport=udp;gw=gw_A &echo
```

替换后为：

```
freeswitch> expand echo originate 
${regex(${sofia_contact(internal/1005@$${domain})}|^(.*)sip:gw\+xyt@(.*)|$1sip:1000606@$2)} &echo
originate sofia/internal/sip:1000606@192.168.1.F:5080;transport=udp;gw=gw_A &echo
```

可以看到，我们得到了需要的呼叫字符串，接下来就可以去掉上面的“echo”进行呼叫测试了。如果在F的日志中，看到类似“Processing<0000000000>->1000606 in context public”这样的行就说明我们修改被叫号码成功了。

接下来，可以就可以完成我们的F-DID Dialplan了：

```xml
<extension name="F-DID">
  <condition field="destination_number" expression="^(1000.*)$">
    <action application="bridge" 
data="${regex(${sofia_contact(internal/1005@$${domain})}|^(.*)sip:gw\+xyt@(.*)|%1sip:$1@%2)}"/>
  </condition>
</extension>
```

注意，与在命令行上不同的是，由于Condition条件中的正则表达式匹配中的Capture结果已经占用了$1、$2之类的变量，因而为避免冲突，在Dialplan中使用${regex()}之类的表达式时，其Capture结果中的变量用%1、%2之类表示。

本节给出了一个端局交换机对下面注册上来的PBX中的分机用户的一种直接呼叫方案。虽然该方案不是唯一的解决办法，但它至少是一种有效的解决方案。其他的解决方案原理与此差不多，都是要想办法找到用户注册上来的联系地址，并进行相应的替换。当然，在实际应用中，这种方案是否可行还需要局端交换机A与PBX交换机F相互配合来决定，在此我们就不多介绍了。

### 使用PBX上的网关呼出

下面我们来看另外一种场景。如图13-6所示，假设A是运行在公网上的FreeSWITCH，而F是运行在私网上的PBX（也是FreeSWITCH），F仍然使用1000这个号码向A注册，并且F上自己带了600～619之间的分机用户。另外，F上还可以通过另外的一个网关G与外界沟通。在现实场景中，G就可能是一个连接模拟线的模拟网关，该网关一端跟FS通过SIP相连，另一端则通过模拟电话线连接PSTN交换机。由于我们运行在公网上的A可能没有对外的中继，因而它上面的用户1000～1019可能也希望通过F上的网关G对外呼出。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-936854.png)

<center>图13-6　PBX上带网关的结构图</center>

有了上一节的经验，我们知道实现这个也很简单。首先，就是将A上的外呼请求先转发到F上。根据上一节的方案，我们可以使用下列Dialplan配置来做到：

```xml
<extension name="F-GW">
  <condition field="destination_number" expression="^(0.*)$">
    <action application="bridge" 
data="${regex(${sofia_contact(internal/1005@$${domain})}|^(.*)sip:gw\+xyt@(.*)|$1sip:${destination_number}@$2)}"/>
  </condition>
</extension>
```

其实该Dialplan跟13.3.2节的类似。我们只是用正则表达式“^(0.*)$”来匹配以0开头的被叫号码，然后通过bridge将这种呼叫送到F上。在F上收到这种呼叫请求后，就可以使用下列的Dialplan进行呼出了：

```xml
<extension name="F-GW">
  <condition field="destination_number" expression="^(0.*)$">
    <action application="bridge" data="sofia/gateway/G/$1"/>
  </condition>
</extension>
```

[1] 创建用户我们应该已经很熟悉了。首先可以手工添加这些用户，也可以简单地修改原有的1000～1019这些用户配置文件，改成对应的600～619。关于如何添加用户参见3.3节及11.1节。 

[2] 如何添加网关我们应该已经很熟悉了，可以将下面的内容存放到conf/sip-profiles/external/gw_a.xml文件中，并在FreeSWITCH中使用“sofia profile external rescan”命令使之生效（参见3.5节）。

## 小结

在本章，我们首先讲了如何在同一个主机上启动多个FreeSWITCH实例。通过这个例子，可以熟悉FreeSWITCH的运行方式，也便于以后启动多个FreeSWITCH实例进行对接测试。

另外，我们也从双机对接开始，一步步地讲解了大型通信网络的组织及演变，以及FreeSWITCH在各个节点和环节起到的作用。同时也讲解了在FreeSWITCH中是怎么实现这些功能的。以后，如果FreeSWITCH需要与其他系统对接，不管FreeSWITCH是处于哪个位置，总能在本章找到合适的配置方式。读者熟悉了这些配置，就可以以不变应万变，在各种组网环境下都能很快地使用FreeSWITCH实现了。

最后，我们还讲了一个公网的FreeSWITCH服务器通过位于私网的PBX上的中继线或网关呼出的例子。这里介绍的并不是最好的配置，但在开发人员在很难自由获得公网上可用的SIP账号的情况下，做到公网上的服务器与PSTN网络的互联，也不失是一种办法，而且社区中也确实有好多网友问到该问题。

当然，本书讲解这些例子的目的并不是仅仅为了回答网友的提问，而是希望读者通过这些例子，能从不同的角度和维度深入理解FreeSWITCH、理解通信网络，以及通信网络中各个组成部分的协作和通信方式，以便在以后的工作中更有效地解决各种问题，创造更强大的应用。

