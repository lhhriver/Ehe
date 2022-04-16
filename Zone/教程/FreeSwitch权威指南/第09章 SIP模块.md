# 第01章 PSTN与VoIP基础
# 第02章 PSTN、PBX及呼叫中心业务
# 第03章 初识FreeSWITCH
# 第04章 运行FreeSWITCH
# 第05章 FreeSWITCH架构
# 第06章 拨号计划
# 第07章 SIP协议
# 第08章 媒体
# 第09章 SIP模块

通过前面的章节我们学习了SIP协议的基础知识，并了解到SIP协议是现代VoIP通信的一个主要协议。事实上，它也是FreeSWITCH支持的一个核心协议。FreeSWITCH中大部分的功能和应用都是基于SIP的。因此，在本章我们就来看一下在FreeSWITCH中是怎么实现和使用SIP的，以及我们如何来配置和使用它。

网络中的NAT无处不在，而SIP通信的成功与否及质量好坏也与NAT息息相关。因此，本章我们也会用一些篇幅介绍NAT。

## 基本概念

本节我们介绍一些与SIP相关的基本概念。

- Sofia-SIP [1]：FreeSWITCH的SIP功能是在mod_sofia模块中实现的。FreeSWITCH并没有自己开发新的SIP协议栈，而是使用了比较成熟的开源SIP协议栈Sofia-SIP，以避免“重复发明轮子” [2]。
- Endpoint：在FreeSWITCH中，实现一些互联协议接口的模块称为Endpoint。Free-SWITH支持很多类型的Endpoint，如SIP [3]、H232等。这些不同的Endpoint主要是使用不同的控制协议跟其他的Endpoint通话。所以说，Endpoint一般是跟通话相关的。
- mod_sofia：mod_sofia实现了SIP中的注册服务器、重定向服务器、媒体服务器、呈现服务器、SBC等各种功能。它的定位是一个B2BUA，它不能实现SIP代理服务器 [4]的功能。
- SIP Profile：在mod_sofia中，有一个概念是SIPProfile，它相当于一个SIPUA，通过各种不同的配置参数可以配置一个UA的行为。一个系统中可以有多个SIP Profile，每个SIP Profile都可以监听不同的IP地址和端口对。
- Gateway：一个SIP Profile中有多个Gateway，Gateway可以直译为网关，它主要用于定义一个远端的SIP服务器，使FreeSWITCH可以与其他服务器通信。FreeSWITCH可以作为一个SIP客户端（UAC）向远端的网关进行注册；当然也可以不注册，而是使用与远端服务器对等的方式（俗称SIPTrunk，即SIP中继）相互通信（我们将在第14章讲到FreeSWITCH与其他系统相连的各种拓扑结构）。
- 本地SIP用户：FreeSWITCH可以作为注册服务器，这时候，其他的SIP客户端就可以向它注册。FreeSWITCH将通过用户目录（Directory）中的配置信息对注册用户进行鉴权。这些SIP客户端所代表的用户就称为本地SIP用户，简称本地用户。
- 来话和去话：牢记FreeSWITCH是一个B2BUA。如果Alice通过FreeSWITCH给Bob打电话，Alice首先向FreeSWITCH发起呼叫，对FreeSWITCH而言，这路通话就称为来话（InboundCall）；然后FreeSWITCH再去呼叫B，这路通话称为去话（OubtoundCall）。如果来、去话都是本地的，又称为本地来话和本地去话。
- 中继来话或中继去话：如果来、去话不是本地的，双方通话需要以中继方式进行，就称为中继来话或中继去话。但是，中继的叫法只是沿用传统的PSTN网络中的概念，在SIP术语中，本来是没有中继的概念的。
    了解了这些基本概念，下面我们来看一下它们在mod_sofia的配置文件中是怎么实现的。

[1] Sofia-SIP是由诺基亚公司开发的SIP协议栈，它以开源的许可证LGPL发布。参见http://sofia-sip.sourceforge.net/。 

[2] 来自英文Reinvent the Wheel，指重复别人已经建立甚至已经优化了的基本工作和方法，该术语常用于软件开发或其他工程科目中。详见：http://en.wikipedia.org/wiki/Reinventing_the_wheel。当然，选用Sofia-SIP的实际原因比这个要复杂。FreeSWITCH的团队在试验了不下5种开源的SIP协议栈实现后才最后选定Sofia-SIP。 

[3] 有的读者可能会问，那么实现SIP的模块为什么不支持mod_sip呢？这是由于FreeSWITCH的Endpoint是一个抽象的概念，你可以用任意技术来实现。实际上mod_sofia只是对Sofia-SIP库的一个黏合和封装。除Sofia-SIP外，还有很多开源的SIP协议栈，如pjsip、osip等。最初选型的时候，FreeSWITCH的开发团队也对比过许多不同的SIP协议栈，最终选用了Sofia-SIP。FreeSWITCH是一个高度模块化的结构，如果你喜欢其他协议栈，可以自己实现如mod_pjsip或mod_osip等，它们是互不影响的。这也正是FreeSWITCH架构设计的精巧之处。 

[4] 实现SIP代理服务器的开源软件有OpenSIPS、Kamailio等。它们可以很好的与FreeSWITCH配合工作。

## Sofia配置文件

Sofia的配置文件是conf/autoload_configs/sofia.conf.xml，不过一般不需要直接修改它，因为该文件仅有少数的配置参数，大部分的配置参数实际上是直接在上述配置文件中使用下面的预处理指令装入conf/sip_profiles/目录中的XML文件中的配置：

```xml
<X-PRE-PROCESS cmd="include" data="../sip_profiles/*.xml"/>
```

结合我们在第5章学过的配置文件的知识，Sofia的配置文件的总体结构应该是这样的：

```xml
<configuration name="sofia.conf" description="sofia Endpoint">
    <global_settings>
        <!-- 全局参数设置 -->
    </global_settings>
    <profiles>
        <profile name="profile1">
        </profile>
        <profile name="profile2">
        </profile>
    </profiles>
</configuration>
```

其中，global_settings中存放了一些全局配置参数。下面的profiles标签中又包含多个profile标签。每个profile标签的详细信息都是在conf/sip_profiles/下的配置文件中配置的。

Sofia支持多个Profile，而每个Profile相当于一个SIP UA，在启动后它会监听一个“IP地址:端口”对。读到这里细心的读者或许会发现我们前面有一个不准确的地方——我们在讲B2BUA的概念时，实际上只用到了一个Profile，也就是一个UA，但我们还是说FreeSWITCH启动了两个UA（一对背靠背的UA）来为Alice和Bob服务。从物理上来讲，它确实只是一个UA，但由于它同时支持多个Session，在逻辑上就是相当于两个UA，为了不使读者太纠结于这种概念问题，笔者在前面没有进行太多分析。但到了本章，读者应该非常清楚FreeSWITCH中UA的含义了——简单来讲，一个“IP地址:端口”对唯一标志一个UA。

FreeSWITCH默认的配置带了三个Profile（也就是三个UA），在本书中，我们不讨论IPv6，仅讨论internal和external两个（它们分别是在internal.xml和external.xml中定义的）。不要被它们的名字所迷惑，其实internal和external最大的区别就是一个运行在5060端口上，另一个运行在5080端口上。有些读者特别关心internal和external的中文含义（字面意思分别是“内部的”和“外部的”），反而会比较迷惑。当然，两个Profile在默认的配置中还有其他区别，我们下面将会讲到。

### Profile配置文件

internel.xml中定义了一个Profile（名字就是internal），它里面有大量的配置参数。这些参数往往与具体的部署方式和呼叫流程有关。到本章为止，我们还没有接触到太多与呼叫流程有关的内容。但是若先讲流程的话，对这里的参数又不熟悉，也不便理解。因此，这就变成了一个是先有鸡还是先有蛋的问题。经过综合考虑，笔者最后决定在本节先把一些重要的配置参数都大体讲一遍，到后面的实战部分在讲到具体流程的时候，涉及这些参数时再深入讨论。

在熟悉了Sofia的配置文件结构以后，我们再来看一下Profile的配置文件。由于Sofia Profile的参数比较多，因此默认把不同的Profile配置存放在单独的文件中。

以internal.xml为例，首先一个Profile的定义是从下面一行开始的：

```xml
<profile name="internal">
```

该行定义了一个Profile，它的名字就叫internal，这个名字本身并没有特殊的意义，也不需要与文件名相同，你可以改成任意你喜欢的名字，但是必须记住它，因为很多地方要使用这个名字。也可以为Profile起个别名 [1]，如：

```xml
<aliases>
<alias name="default"/>
</aliases>
```

如果有了这个别名，就可以在呼叫字符串中使用这个别名。比如，如果配置文件中有上述配置，就可以使用类似这样的呼叫字符串sofia/default/13912345678@192.168.1.12去呼叫相应的SIP地址。关于呼叫字符串的知识我们还会在第12章讲到。下面我们继续看配置文件。

在一个Profile中，可以配置多个网关（Gateway）。网关是在<gateways></gateways>标签中定义的。默认的配置中只是装入了相关目录下的网关配置文件。配置如下：

```xml
<gateways>
    <X-PRE-PROCESS cmd="include" data="internal/*.xml"/>
</gateways>
```

上面的配置代码定义了一些网关。既然Profile是一个UA，它就应该可以注册到别的SIP服务器上去，它要注册的远端SIP服务器对于该Profile来说，就称为网关，而这里的网关配置就是对远端SIP服务器的一些描述，即网关的配置参数由远端的SIP服务器来决定。我们一般不在internal这个Profile上使用Gateway，大多数在external上使用（详见9.3.3节）。

接下来，便定义该Profile所属的域（Domain）。Domain可以是一个IP地址或一个DNS域名。需要注意，直接在操作系统hosts文件中设置的IP到域名的映射可能不好用，如果使用域名，大多数SIP UA都需要有一个真正的DNS服务器。Domain的配置代码如下：

```xml
1 <domains>
2     <!--<domain name="$${domain}" parse="true"/>-->
3 <domain name="all" alias="true" parse="false"/>
4 </domains>
```

在SIP配置文件中，Domain的含义比较容易令人迷惑。因此，一般采用默认的配置就行。不过，总会有些好奇的读者，或者有些高级用户期望了解这些知识，因此我们也简单讲一下。初学者可以自动跳过这一块，以避免“走火入魔” [2]。

一说到Domain，可能大家都会想到域名。不过在这里，Domain可以是任意的字符串，可以简单把它理解为一个域。FreeSWITCH支持多Domain，也就是逻辑上可以把一些资源（如用户）分到多个“域”中。在本章，我们不讨论多Domain。感兴趣的读者可以参考15.7.1节。

在默认的配置文件中，vars.xml中定义了一个名为domain的全局变量，它的默认值来自于local_ip_v4这个全局变量，也就是说，它是一个IP地址。当然，话又说回来，domain就是一个字符串，它可以是IP地址，也可以是其他值，只是默认的配置中是一个IP地址。该全局变量在很多地方可以引用，如上面配置例子中的第2行（该行默认是注释掉的，因而不生效）。

言归正传。上面配置中第3行的含义是：在该Profile中定义一个Domain，name="all"表示检查看所有的用户目录中定义的Domain（默认是在conf/directory目录下定义的Domain，如果name等于一个特定的Domain，则它仅会检查指定的Domain），然后执行下列动作：

- 如果alias="true"，则会为所有的Domain取一个别名，放到与Profile同等重要的位置，以便后续在构造或查询呼叫字符串时能找到正确的用户。如在笔者的FreeSWITCH中使用sofia status命令可以看到如下的行：

```
  Name            Type                        Data    State
  =================================================================

  192.168.1.128    alias                     internal  ALIASED
```

其中，Type为alias表示是一个别名。

- 如果parse="true"（注意默认的配置中此处为false），则FreeSWITCH会解析该Profile中所有的网关。

注意，上面的alias和parse属性都具有排它性，即在有多个Profile的情况下，它们的值只能有一个为true，否则会产生冲突。

好了，关于这个问题我们就讲到这里，读者可以自行比较一下internal和external中这一行的区别。另外，我们也将在15.5.1节深入讲解Domain的实例。

除了上面这些配置外，下面便与该Profile相关的一系列参数，大体的配置结构如下：

```xml
<settings>
    <param name="参数名称" value="参数值">
</settings>
```

我们在下一节再详细讲几个重要的配置参数。

### Profile的几个重要参数

Sofia的Profile有很多可配置参数，它们可以影响某一Profile所代表的SIP UA的行为。也就是说，对于来话而言，所有到达某一Profile（如internal.xml）的呼叫都会进行统一的处理；对于去话而言也类似——所有从某一Profile出去的通话也都有类似的行为（如下面将要讲到的auth-calls参数）。下面我们就来说一下Profile中的一些主要参数，这些参数大部分可以在internal.xml找到相应的例子。

inbound-bypass-media用于设置入局呼叫是否启用“媒体绕过（Bypass Media）”模式，它的取值有“true”和“false”两种。如：

```xml
<param name="inbound-bypass-media" value="true"/>
```

所有的参数设置格式都差不多，因此，下面我们就不再列出所有代码了。

那么，什么叫Bypass Media呢？

如图9-1所示，Bob和Alice通过FreeSWITCH使用SIP接通了电话，他们谈话的语音（或视频）数据要通过RTP包传送。RTP可以像SIP一样经过FreeSWITCH转发。但是，RTP与SIP相比占用很大的带宽，如果FreeSWITCH不需要“偷听（或录音）”他们谈话，为了节省带宽，完全可以让RTP直接在两者之间点对点传送，这种情况对FreeSWITCH来讲就是没有媒体的，在FreeSWITCH中就称为Bypass Media（媒体绕过）。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-457856.png)

<center>图9-1　Bypass Media</center>

所以，如果将inbound-bypass-media的值设为“true”，那么对于任何来话（如Alice打给Bob，电话要先进入FreeSWITCH，对FreeSWITCH来说该电话就称为来话）都会自动采用Bypass Media模式。

下面我们还会看到更多与Bypass Media相关的参数。

- media-option：媒体选项，它有两个可能的取值——resume-media-on-hold和bypass-media-after-att-xfer。前者的意思是，如果FreeSWITCH是没有媒体（No Media/Bypass Media）的，那么若设置了该参数，当你在话机上按下Hold键时，FreeSWITCH将会回到有媒体的状态；后者是跟Attended Transfer有关的，Attended Transfe即出席转移，又称协商转移，它需要媒体配合才能完成工作。但如果在执行转接之前没有媒体（处于Bypass Media状态），则该参数能让转接执行时通过re-INVITE请求要回媒体，等到转接结束后再回到Bypass Media的状态。我们将在15.1.1节详细讲解Attended Transfer。
- context：设置来话将进入Dialplan中的哪个Context进行路由。

```xml
<param name="context" value="public"/>
```

需要指出的是，如果用户注册到该Profile上（或是经过认证的用户，即本地用户），则用户目录（directory）中设置的user_contex优先级要比这里设置的高（见10.5节）。

- dialplan：设置默认的dialplan类型，即在该Profile上有电话呼入后到哪个Dialplan中进行路由。

```
<param name="dialplan" value="XML"/>
```

- inbound-codec-prefs：设置支持的来话媒体编码，用于编码协商。默认值引用了vars.xml中的一个global_codec_prefs变量，该变量的默认值是“G722,PCMU,PCMA,GSM”。

```xml
<param name="inbound-codec-prefs" value="$${global_codec_prefs}"/>
```

- outbound-codec-prefs：设置去话语音编码。

```xml
<param name="outbound-codec-prefs" value="$${global_codec_prefs}"/>
```

- rtp-ip：设置RTP的IP地址。

```xml
<param name="rtp-ip" value="$${local_ip_v4}"/>
```

- sip-ip：设置SIP的IP地址。

```xml
<param name="sip-ip" value="$${local_ip_v4}"/>
```

- sip-port：该Profile启动后监听的SIP端口号。默认的配置中引用了var.xml中定义的一个变量internal_sip_port，默认是5060。

```xml
<param name="sip-port" value="$${internal_sip_port}"/>
```

- auth-calls：设置是否对来电进行鉴权。默认是需要鉴权，即所有从该Profile进来的INVITE请求都需要经过Digest验证。

```xml
<param name="auth-calls" value="$${internal_auth_calls}"/>
```

- ext-rtp-ip和ext-sip-ip：用于设置NAT环境中公网的RTP IP和SIP IP。该设置会影响SDP中的IP地址。

```xml
<param name="ext-rtp-ip" value="auto-nat"/>
<param name="ext-sip-ip" value="auto-nat"/>
```

其中，value的取值有以下几种可能：一个IP地址，如12.34.56.78；一个STUN服务器，它会使用STUN协议获得公网IP，如stun:stun.server.com；一个DNS名称，如host:host.server.com；auto，它会自动检测IP地址；auto-nat，如果路由器支持NAT-PMP或uPnP，则可以使用这些协议获取公网IP。

这些设置的值可以使用sofia status命令显示，如在笔者的电脑上显示结果如下：

```
freeswitch> sofia status profile internal
=====================================================================

Name                internal
RTP-IP              192.168.1.128
Ext-RTP-IP          119.40.26.181
SIP-IP              192.168.1.128
Ext-SIP-IP          119.40.26.181
```

我们将在9.4节专门介绍NAT。

本节我们讨论了SIP Profile中的几个重要参数，其他的参数在这里就不多解释了。

### external.xml

external.xml是另一个UA配置文件，它定义了另一个名为“external”的UA，默认使用5080端口。从external.xml中可以看到，其中的大部分参数都与internal.xml中相同。最大的不同是auth-calls参数。在internal.xml中，auth-calls默认值是true；而在external.xml中，默认值是false。也就是说，客户端发往FreeSWITCH的5060端口的SIP消息需要鉴权（一般只对REGISTER和INVITE消息进行鉴权），而发往5080的消息则不需要鉴权。我们一般把本地用户都注册到5060上，所以它们打电话时要经过鉴权，保证只有授权（在我们用户目录中配置的）用户才能注册和拨打电话。而5080不同，任何人均可以向该端口发送SIP INVITE请求。

如图9-2所示，本地用户1000注册到5060端口上，每次它向外打电话时（呼叫本地用户1001时也一样），它向FreeSWITCH的5060端口发送INVITE请求，FreeSWITCH对其鉴权，验证通过后（可以是IP地址验证或Digest验证），才允许通话继续进行─如果呼叫1001，则FreeSWITCH继续向用户1001发送INVITE请求；如果呼叫外部电话，则通过端口5080向外部网关发送INVITE请求。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-472872.png)

<center>图9-2　FreeSWITCH的端口连接</center>

在上面的例子中，FreeSWITCH也可以通过5060端口向外部网关发送INVITE请求，效果是一样的。也就是说对于去话（Outbount Call，出局通话）而言，两者在这里没有区别。但对于来话（Inbound Call，入局通话）就不同了。为了让FreeSWITCH能接收来话，一般有两种方式：

- FreeSWITCH作为一个UAC（这里可以理解为软电话，如X-Lite）从本地的5080端口通过SIP注册到外部网关上，这样外部网关就可以通过SIP消息中的Contact字段知道该UAC所在的IP地址和监听的端口（这里是5080）。当有电话进来时，外部网关就向FreeSWITCH所在IP的5080端口发送INVITE请求。
- 某些网关是把来话和去话分开的，一般不需要或者根本不允许注册。那它们怎么知道我们的FreeSWITCH的IP和端口呢？在这种情况下，它们一般是在申请的时候事先配置好的，就比方你去装电话时，告诉电信公司你家的门牌号一样，所不同的是这里你告诉人家的是你FreeSWITCH服务器的IP地址和端口号（在这里是5080）。如果有来话，外部网关就按照事先配置好的地址发送INVITE请求。

不管是使用以上哪种方式，当外部网关的INVITE请求到达FreeSWITCH时，我们不能要求对这些消息进行鉴权，因为外部网关不是FreeSWITCH的本地用户，它们不知道该如何给FreeSWITCH提供鉴权信息。所以我们在external这个Profile中把auth-calls参数设为false，对来话不鉴权。

读到这里，读者大概就明白多了。如果你使用5060端口向外部网关进行注册的话，那么外部网关的来话请求将被发送到FreeSWITCH的5060端口上，由于FreeSWITCH会对发送到该端口的所有来话进行鉴权，很显然外部的网关不知道怎么才能通过FreeSWITCH的验证，所以最终FreeSWITCH会拒绝所有来话。当然可能你还是有疑问，既然5080端口允许所有来话，那么怎么保证安全呢？这个我们将在后面讲安全的时候介绍，在此就不多说了。

### Gateway

上一节我们已经提到，FreeSWITCH需要通过外部网关向外打电话，而这个外部网关就称为Gateway。在external.xml中，我们可以看到它使用预处理指令将external目录下的所有的XML配置文件都装入到了该Profile的gateways标签中：

```xml
<gateways>
    <X-PRE-PROCESS cmd="include" data="external/*.xml"/>
</gateways>
```

这样做的好处是，我们可以把每个网关配置写到不同的文件中。默认的配置中包含了一个example.xml，里面有很多配置选项。这里我们先从最简单的配置讲起。

如3.5节所述，添加一个新网关只需要在external目录中新建一个XML文件，名字可以随便起，但需要以.xml结尾，如“gw1.xml”。其内容如下：

```xml
<gateway name="gw1">
    <param name="realm" value="SIP服务器地址"/>
    <param name="username" value="SIP用户名"/>
    <param name="password" value="密码"/>
</gateway>
```

其中，每个网关都有一个名字，由第一行的name属性指定。该名字可以与XML文件的名字相同，也可以不同。在FreeSWITCH内部，将以该名字唯一确定该网关。在整个FreeSWITCH中，网关名字必须唯一，否则除第一个外，其他的都将被忽略。

realm指定SIP网关服务器的地址，可以是一个合法的域名或IP地址，如果端口号不是5060，则后面需要加上“:端口号”，如“1.2.3.4:5080”。该参数是可选的，如果没有，则默认跟网关的名字（name）相同（此时网关的名字应该写成一个IP地址或者是域名，如192.168.7.7）。

username和password分别指用户名和密码，这两个参数也是必需的。值得注意的是，有些网关使用IP地址验证，而不需要用户名和密码。在FreeSWITCH中，你也必须设置这两个参数，但它们的值将被忽略，所以可以填上任意值 [3]。

我们来看一下example.xml都有哪些默认的参数。注意，默认情况下这些参数都是注释掉的，不起作用。

```xml
<include>
  <!--<gateway name="asterlink.com">-->
  <!--<param name="username" value="cluecon"/>-->
  <!--<param name="password" value="2007"/>-->
  <!--<param name="realm" value="asterlink.com"/>-->
```

其中，<include>以及后面的</include>标签指明该文件被其他文件包含，它将在预处理阶段被去掉。而且即使没有这两个标签也不会出错。但为了严谨性，建议不要省略这对标签。

下面的代码用于设置SIP消息中From字段的值，如果省略，则默认与username相同。

```xml
<!--<param name="from-user" value="cluecon"/>-->
```

下面的代码用于设置From字段中的domain值，默认与realm相同。

```xml
<!--<param name="from-domain" value="asterlink.com"/>-->
```

下面的代码用于设置来话中的分机号，即被叫号码，默认与username相同。

```xml
<!--<param name="extension" value="cluecon"/>-->
```

如果需要代理服务器，则设置该proxy的值，默认与realm相同。

```xml
<!--<param name="proxy" value="asterlink.com"/>-->
```

如果需要注册到代理服务器，则设置该register-proxy的值，默认与realm同。

```xml
<!--<param name="register-proxy" val
”e="mysbc.com"/>-->
```

下面的代码用于设置注册时SIP消息中Expires字段的值，默认为3600秒。

```xml
<!--<param name="expire-seconds" value="60"/>-->
```

如果网关不需要注册，则设为false，默认为true。有些网关必须注册了才能打电话；而有的则不需要。另外，注册到网关上还允许从网关设备呼入我们的FreeSWITCH。

```xml
<!--<param name="register" value="false"/>-->
```

下面的代码用于设置SIP消息使用udp还是tcp来承载。

```xml
<!--<param name="register-transport" value="udp"/>-->
```

下面的代码用于设置如果注册失败或超时，则多少秒后再重新注册。

```xml
<!--<param name="retry-seconds" value="30"/>-->
```

将主叫号码（要发给对方的）放到SIP的From字段中。默认会放到Remote-Party-ID字段中（有些终端从From字段中获取主叫号码）。

```xml
<!--<param name="caller-id-in-from" value="false"/>-->
```

下面的代码用于设置在SIP协议中Contact字段中额外的参数。具体的参数需根据实际情况而定，请参考相关的SIP协议或对端设备的要求。

```xml
<!--<param name="contact-params" value="tport=tcp"/>-->
```

每隔一段时间发送一个SIP OPTIOINS消息，如果失败，则会从该网关注销，并将其设置为down状态。通过周期性地发送无关紧要的SIP消息，有助于快速发现对方的状态变化，同时也在NAT环境中有助于保持路由器上的NAT映射关系，保持连接畅通。

```xml
<!--<param name="ping" value="25"/>-->
```

最后是网关及include的关闭标签，保持XML的完整性。

```xml
<!--</gateway>-->
</include>
```

到此，示例网关配置文件中的参考就都介绍完了。这些参数在与其他设备对接时比较有用。FreeSWITCH的兼容性很强，通过调整Profile及Gateway的参数，可以兼容已知的绝大部分SIP设备。

[1] 注意，在默认的配置文件中，别名一行是加了注释的，也就是说默认情况下这个别名不起作用，写在那里只是一个例子。此处为了叙述方便，去掉了注释。 

[2] 笔者知道这个词可能不严谨，但实在找不到更恰当的比喻了。 

[3] 这里的username将会被填到SIP的From及其他头域里，所以还是可能会有影响的。

## 常用命令

mod_sofia提供了一个API命令——sofia，它有很多参数，可以提供很多功能。比如，我们熟悉的sofia status会列出sofia的运行状态。在FreeSWITCH控制台上输入sofia或sofia help命令，将得到命令的帮助信息。帮助信息如下：

```
freeswitch> sofia

USAGE:
--------------------------------------------------------------------------------

sofia global siptrace <on|off>
sofia        capture  <on|off>
            watchdog <on|off>
sofia profile <name> [start | stop | restart | rescan] [wait]
                   flush_inbound_reg [<call_id> | <[user]@domain>] [reboot]
                   check_sync [<call_id> | <[user]@domain>]
                   [register | unregister] [<gateway name> | all]
                   killgw <gateway name>
                   [stun-auto-disable | stun-enabled] [true | false]]
                   siptrace <on|off>
                   capture  <on|off>
                   watchdog <on|off>
sofia <status|xmlstatus> profile <name> [reg [<contact str>]] |
                                      [pres <pres str>] |
                                      [user <user@domain>]
sofia <status|xmlstatus> gateway <name>
sofia loglevel <all|default|tport|iptsec|nea|nta|nth_client|nth_server|nua|soa| sresolv|stun> [0-9]
sofia tracelevel <console|alert|crit|err|warning|notice|info|debug>
sofia help
```

下面，我们对主要的参数进行讲解。

### 状态相关命令

我们已经很熟悉sofia status命令了，其可以列出当前mod_sofia的运行状态，其还有如下功能：

- 列出某个Profile的状态。

```
freeswitch> sofia status profile internal
```

- 列出某个Profile上所有已注册用户。

```
freeswitch> sofia status profile internal reg
```

- 过滤某些符合条件的用户。

```
freeswitch> sofia status profile internal reg 1000
```

- 列出某个特定用户。

```
freeswitch> sofia status profile internal user 1000
```

- 列出网关状态。

```
freeswitch> sofia status gateway gw1
```

以上的命令都可以将status用xmlstatus来替代，以列出XML格式的状态，这样比较容易用其他程序解析，读者可以自行比较它与“sofia status”命令输出的异同。

### Profile相关命令

Profile相关的命令都是针对某个Profile进行的操作。一般来说，下面这些指令在需要读取XML时都会隐含reloadxml，因而如果要修改XML配置文件中的某个参数，就不需要明确的reloadxml指令了。
常用的启动、停止、重启某个Profile的命令分别如下：

```
freeswitch> sofia profile internal start           # 启动
freeswitch> sofia profile internal stop            # 停止
freeswitch> sofia profile internal restart         # 重启
```

有时候，修改了某个Profile的某个参数（如outbound-codec-prefs、inbound-late-negotiation等），不需要重启（因为重启是影响通话的）。可以使用下列命令让FreeSWITCH重读sofia的配置（并不是所有的配置参数都能生效）：

```
freeswitch> sofia profile internal rescan
```

添加了一个新的gateway以后，也可以使用上述rescan指令读取。

如果是修改了一个网关，则可以先将该网关删除，再rescan，如：

```
freeswitch> sofia profile external killgw gw1       # 删除一个网关
freeswitch> sofia profile external rescan           # 重读参数
```

下列命令可以指定某个网关立即向外注册或注销：

```
freeswitch> sofia profile external register gw1     # 注册
freeswitch> sofia profile external unregister gw2   # 注销
```

开启该Profile的SIP跟踪功能抓SIP包：

```
freeswitch> sofia profile internal siptrace on
```

有时候，希望将已经注册的用户清理掉。可以使用如下方法实现，如：

```
freeswitch> sofia profile internal flush_inbound_reg 1000@192.168.1.7
```

也可以通过找到该用户的call-id来清理，如下面的例子，再重新查看状态时，发现已经被清除了（Total items变成了0）：

```
freeswitch> sofia status profile internal reg 1000

Registrations:
=================================================================================

Call-ID:        ZWIyNDVmMTU1ODIyMDA1ZDl
User:           1000@192.168.1.123
...
Total items returned: 1
freeswitch> sofia profile internal flush_inbound_reg ZWIyNDVmMTU1ODIyMDA1ZDl
+OK flushing all registrations matching specified call_id
freeswitch> sofia status profile internal reg 1000
Total items returned: 0
```

有的时候读者可能会发现记录根本没有清除，出现这种情况可能是因为输错了命令或参数，但更可能是因为记录已经清除了，但客户端又重新注册了（因而又产生了一条新记录）。在flush_inbound_reg时，FreeSWITCH只是简单地清理本地数据库中用户的注册信息，它无法防止客户端重新注册。如果确实不想让该客户端再注册了，可以给该用户改一个密码，让它注册不上来，或直接修改iptables防火墙，不允许相关的IP注册。

### SIP Capture

FreeSWITCH内置了Homer Capture Agent用于SIP抓包。Homer [1]是一个使用HEP、HEP2和IPIP协议的抓包分析工具。它逻辑上由Capture Agent、Capture Node（又称Capture Server）和webHomer三部分组成。其中，Captuer Agent运行于FreeSWITCH内部，用于将收到的SIP包进行封装并通过HEP/HEP2或IPIP协议发送到远端的Capture Node上。Capture Node收到封装后的SIP包以后，进行分析并将分析结果存储到数据库中。然后，技术人员就可以使用webHomer在浏览器中查看各种统计和分析结果了，如图9-3所示。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-487858.png)

<center>图9-3　Homer示意图</center>

使用Capture功能前，需要先在sofia.conf.xml中配置Captcher Node的地址，如：

```xml
<param name="capture-server" value="udp:192.168.0.100:6060"/>
```

通过在Profile中配置下列参数，可以配置该功能默认情况下在Profile加载时是打开的还是关闭的，如：

```xml
<param name="sip-capture" value="yes"/>
```

当然，也可以在运行阶段通过命令动态开关，如：

```
freeswitch> sofia profile internal capture on
freeswitch> sofia profile internal capture off
```

### global相关

在使用sofia命令的siptrace子命令进行抓包时，用户经常搞不清该对哪个Profile进行抓包。因此，FreeSWITCH的作者为这部分用户加入了这个特性——通过使用global参数，使siptrace子命令对所有Profile都有效，如以下两条命令可以分别打开和关闭全局的SIP消息跟踪：

```
freeswitch> sofia global siptrace on
freeswitch> sofia global siptrace off
```

以下两条命令可以分别打开和关闭全局的SIP捕获（Homer方式抓包）：

```
freeswitch> sofia global captuer on
freeswitch> sofia global capture off
```

### debug相关

有时候，可能是协议栈更底层的原因引起的问题，由于收到或发送非法的消息会导致协议栈出错，这可能会使消息丢弃，当然也可能是协议栈层的Bug，在这种情况下即使开启了详细的FreeSWITCH日志以及SIP跟踪（siptsiptrace）也查找不到问题的原因。这时候可以使用如下命令打开更低级别的调试器：

```
freeswitch> sofia loglevel all 9
```

以上命令将开启详细的Sofia SIP底层调试信息，在控制台上打印日志。其中日志级别为0到9。如果你对sofia比较熟悉，也可以开启相关模块的日志。例如，如下命令可以仅开启nua的调试信息：

```
freeswitch> sofia loglevel nua 9
```

loglevel的其他的参数可以在sofia的命令帮助中找到。

在默认的情况下，Sofia层的日志级别是console，它会直接打印相关信息到控制台上，而不会写到日志文件中（如log/freeswitch.log）。如果需要将这些日志也写到日志文件中去，可以为这些日志指定一个级别。例如，下面的命令可以分别将Sofia的日志映射到debug和notice级别：

```
freeswitch> sofia tracelevel debug
freeswitch> sofia tracelevel notice
```

最后，可以使用如下命令关闭这些调试：

```
freeswitch> sofia loglevel all 0
```

### 其他命令

除sofia外，mod_sofia还提供了一些其他API命令，这些命令一般用于显示一些相关的信息，简介如下。

- sofia_username_of。返回注册用户的username。

    ```
    freeswitch> sofia_username_of 1000@192.168.1.123
    1000
    ```

- sofia_contact。返回注册用户的联系地址。

    ```
    freeswitch> sofia_contact 1000@192.168.1.123
    sofia/internal/sip:1000@192.168.1.123:39988;rinstance=e9ce1bbdd471ab2d
    ```
    
- sofia_count_reg。在允许多点注册的情况下（开启multiple-registrations时），计算有多少客户端注册了。

    ```
    freeswitch> sofia_count_reg 1000@192.168.1.123
    1
    ```
    
- sofia_dig。类似于DNS的dig，返回其他服务器的服务地址和端口号，如下命令显示了指定IP上都有哪些SIP服务。

    ```
        freeswitch> sofia_dig 192.168.1.123
        Preference      Weight   Transport        Port     Address
    ================================================================================
                 1       1.000         udp        5060  192.168.1.123
                 2       1.000         tcp        5060  192.168.1.123
    ```

    其中，192.168.1.123上有两个SIP服务，它们分别监听udp和tcp的5060端口。

- sofia_presence_data。显示Presence数据，下面的命令显示1000处于Busy状态：

    ```
    freeswitch> sofia_presence_data status 1000@192.168.1.123
    Busy
    ```

下面的命令列出指定用户的Presence信息：

```
freeswitch> sofia_presence_data list 1000@192.168.1.123
    status|rpid|user_agent|network_ip|network_port
    Busy|busy|Bria 3 release 3.5.0b stamp 69410|192.168.1.123|46342
    +OK
```

下面的命令可以列出用户的user_agent信息：

    freeswitch> sofia_presence_data user_agent 1000@192.168.1.123
    Bria 3 release 3.5.0b stamp 69410
### 其他

笔者经常被问到的一个问题是——Sofia Profile的参数众多，修改哪些参数需要重启，哪些不需要？这个问题现在还没有统一的答案。一个基本原则是，能不重启就不重启，如修改上面所说的inbound-codec-prefs或outbound-codec-prefs等。但有一些参数，如跟IP地址和端口号相关的参数，则一般需要重启，重启Profile前需先中断现有通话。

[1] 参见http://www.sipcapture.org/。

## NAT穿越

默认安装的FreeSWITCH也能很好地工作在NAT环境下，但不可否认，用户的网络环境可能五花八门，因而也不可避免地会遇到NAT问题。适当地解决在NAT网络环境下的内、外网通信问题，就称为NAT穿越。

实际上，SIP/RTP协议本身的特性决定了它与NAT的各种恩怨。NAT涉及的知识比较多，用户不仅要了解FreeSWITCH、SIP协议及跟踪调试技巧，还要了解网络拓扑结构、使用网络设备（如交换机和路由器）的相关参数和特性等。因而对于初学者而言，笔者不建议大家花费时间去研究和解决NAT问题，而是建议在局域网环境中学习FreeSWITCH，等有了一定基础以后再研究NAT环境。

当然NAT问题也不是那么可怕，若初学者有兴趣也不妨读一下本节的内容，即使不为解决NAT的问题，对理解SIP协议以及本节前面讲到的参数配置也是有帮助的。另外，笔者把这部分内容放到本章是也因为它跟mod_sofia模块结合比较紧密。

好了，言归正传。NAT的全称是Network Address Translation（网络地址转换），它最初是为了克服IPv4网络地址不足出现的一项技术。众所周知，IPv4使用32位（4个8位，即4字节）地址空间，因而最多可以表示2 32个地址。随着Internet的迅速发展，人们需要大量的IP地址，大大超出了IPv4所能提供的地址数量。为了解决IPv4地址空间紧张的问题，RFC1918 [1]规定了一些私有的IP地址，这些私有的地址存在于路由器后面，它们本身形成一个私有的网络，称为内部网（Intranet，简称内网）。当内网的IP需要与外界的IP（又称公网）通信时，通过路由器提供的网络地址转换（NAT）功能转换成一个合法的外网IP地址来与外界通信。不同的内部网间彼此独立，因而可以复用这些私有的IP地址，这大大提高了IPv4网络的接入能力。

虽然NAT有效解决了IPv4网络上的IP地址短缺问题，但对于飞速发展的互联网来说，还不是终极的解决方案。因此，人们很早就发明了IPv6，它使用128位的地址空间，能表示2 128个地址，也就是说将来任何可以联网的智能设备，包括家用的微博炉、手表等都可以获取一个IPv6地址。为了推动IPv4向IPv6的过渡，国际IP地址分配机构ICANN [2]早在几年前就提出了IPv4地址预警，称地址将很快耗尽，但遗憾的是，这项工程还是迟迟没有进展。Anthony Menissale《FreeSWITCH 1.2》中说过：“世界改变得越快，人们就越容易怀旧。技术的进步和革命也是如此。我们的汽车仍然假装有速度指针，你喜欢的网站上仍然使用过时的按钮和开关图片，我们作为社会的一分子，仍然信奉一句话：东西，如果它不坏，就不要去修它” [3]。

所以，我们还是整天生活在NAT的环境中，不管是在办公室，还是在家里通过路由器上网时。大多数人并未意识到NAT的存在，因为大多数的Web应用都是基于TCP的，NAT对TCP的影响不是很大。但基于SIP的语音通信中，SIP一般用UDP承载，UDP是无连接的协议，因而在NAT穿越方面就更加困难。而更为复杂的是，媒体（语音或视频）数据是在RTP包中传递的，它是与SIP路径不同的另一路径（甚至是更多的路径，比如同时有语音和视频的情况）。虽然SIP也可以通过TCP承载，但RTP为了保持实时性，还需要用UDP传输。因而，我们就不能忽略NAT的影响了。

图9-4所示为一个典型的NAT结构。其中，路由器有两个网络接口，一个用于连接外网，其IP是1.2.3.4，一个用于连接内网，其IP是192.168.0.1。内网的主机IP从192.168.0.2到192.168.0.5，它们把192.168.0.1作为一个网关，即所有与外网的通信都需要经过192.168.0.1转发。如果内网主机要与外界通信，路由器会将内网主机的请求转换成外网的IP地址，因而不管是哪个内网的主机与外界通信，外界的主机看起来都是从1.2.3.4这个路由器的外网IP发出的。同时，路由器会维护一个地址与内网主机间的映射关系，以保证回来的IP能到达相应的主机。这个映射关系是在内网主机首次向外网发包时建立的，此后外网的主机才可以向内网的主机发送信息。建立该映射关系的过程好像是在NAT设备上打了一个“洞”（因而该技术也称为UDP Hole Punching，即打洞），通过该“洞”进行内外网的通信。该洞是有生命周期的，如果在一段时间内没有数据通过，则洞会自动消失。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-501854.png)

<center>图9-4　NAT示意图</center>

### NAT的种类

NAT有三种类型：静态NAT（Static NAT）、动态地址NAT（Pooled NAT）和网络地址端口转换（Network Address Port Translation，NAPT）。其中静态NAT设置起来最简单；内部网络中的每个主机都被永久映射成外部网络中的某个合法的地址，而动态地址NAT则是在外部网络中定义了的一系列的合法地址，采用动态分配的方法映射到内部网络；NAPT则是把内部地址映射到外部网络的一个IP地址的不同端口上。

前两种类型实际上都不能节省IP地址，我们就不讨论了。NAPT是人们比较熟悉的一种转换方式，它普遍应用于接入设备中，可以将中小型的网络隐藏在一个合法的IP地址后面，这个优点使得这种方式在小型办公室内非常实用，通过从ISP处申请的一个公网IP地址，可以将多台电脑或网络设备通过NAPT接入Internet。

一般来说，NAPT有四种类型，但它实际上又分为两大类：锥型NAT和对称NAT。其中锥型NAT又分为三类，因而一共是四类。简单起见，我们沿用四类的说法来简单讲解（其中前三类属于锥型，最后一类属于对称型）。

（1）Full Cone NAT（全锥型NAT）

内网主机建立一个UDP socket（表示为LocalIP:LocalPort，如192.168.0.2:5060），第一次使用这个socket给外部主机发送数据时，NAT设备（如我们上面讲的路由器）会给其分配一个公网IP、端口对（PublicIP:PublicPort，如1.2.3.4:5060），并记住它们之间的映射关系。以后用这个socket向外面任何主机发送数据都将使用这对PublicIP:PublicPort。此外，任何主机只要知道这个PublicIP:PublicPort就可以给它发送数据，NAT设备会根据它已经记住的映射关系将收到的数据转发到相应的内部主机的LocalIP:LocalPort上。其实简单来说就一句话：内部主机向外打了一个洞，外网的任何主机都可以利用这个洞与它通信。

（2）Restricted Cone NAT（限制锥型NAT）

内网主机建立一个UDP socket（LocalIP:LocalPort），第一次使用这个socket给外部主机发送数据时NAT设备会给其分配一个公网的PublicIP:PublicPort，以后用这个socket向外面任何主机发送数据都将使用这对PublicIP:PublicPort。此外，如果外部主机想要发送数据给这个内网主机，除了需要知道这个PublicIP:PublicPort外，内网主机在这之前必须用这个socket曾向这个外部主机的IP发送过数据。也就是说，如果内网的主机从来没有往某一公网IP发送过数据，则这个公网IP是不能往内网主机发送数据的，即使它知道PublicIP:PublicPort也不行。按洞的理论来说，就是内部主机向某一外部主机打了一个洞后，只有该外部主机才能利用这个洞。

（3）Port Restricted Cone NAT（端口限制锥型NAT）
这种NAT与Restricted Cone类似，唯一不同的是，如果外部主机想要给内网主机发送数据，它除了必须知道PublicIP:PublicPort外，而且内部的主机必须事先向该外部主机的IP:Port发送过数据，并且该公网主机必须使用相应的IP:Port通过PublicIP:PublicPort给内网主机发送数据。

可以看出，Poxt Restricted Cone NAT与Restricted Cone相比增加了对外网主机使用的端口的限制。即内部主机向外部主机上一某一程序（一个端口）打了一个洞，则只有该程序可以利用这个洞，其他的不行。

（4）Symmetric NAT（对称型NAT）

锥型NAT对内网主机的同一socket（LocalIP:Localport）发往任何外网主机的数据均分配一个PublicIP:PublicPort，而对称型NAT会对内网主机同一socket（LocalIP:Localport）发往外部不同主机的数据分配不同的PublicIP:PublicPort映射关系。

详细来讲，内网主机建立一个UDP socket（LocalIP:LocalPort），当用这个socket第一次给外部主机1发送数据时，NAT设备会为其映射一个PublicIP-1:Port-1，以后内网主机发送给外部主机1的所有数据都用这个PublicIP-1:PublicPort-1。如果内网主机同时用这个socket给外部主机B发送数据，第一次发送时，NAT设备会为其分配一个PublicIP-2:PublicPort-2，以后内网主机发送给外部主机2的所有数据都用这个PublicIP-2:Port-2。

如果任何外部主机M想要发送数据给这个内网主机N，N必须曾经用这个socket向这个外部主机M的IP发送过数据，并且M需要知道N向M发送数据时NAT设备为其映射的PublicIP:PublicPort。这样这个外部主机M就可以用自己的IP：AnyPort（即任何端口）给PublicIP:PublicPort发送数据。

对称型NAT相当于对同一内部主机联系不同的外部主机时都需要打不同的洞。

### FreeSWITCH的拓扑结构

FreeSWITCH一般有三种拓扑结构，如图9-5所示。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-516854.png)

<center>图9-5　常见FreeSWITCH NAT网络拓扑结构</center>

如图9-5a所示，FreeSWITCH运行在公网上，与公网上的其他落地网关设备对接。SIP话机一般位于NAT内部。这种情况一般用于运营VoIP业务的情况。

如图9-5b所示，FreeSWITCH运行在内网上，穿过NAT与公网上的设备对接。SIP话机也在内网上。一般用于公司内部的IP-PBX的情况。

如图9-5c所示，与图9-5b所示不同的是，公网上的用户（如B）也可以穿过NAT向FreeSWITCH注册，或通过FreeSWITCH打电话，而其外网用户通常是公司的外勤或出差人员。这种拓扑结构通常比较复杂，尤其是在希望B能在内网和外网间自由切换的情况下（有时内勤有时外勤，但不希望电脑上的SIP软电话注册地址改来改去）。甚至处于另外一个NAT后面的用户（如C）也希望向FreeSWITCH注册，这种情况称为双重NAT（Double Nat），就更加复杂了。

### NAT是怎么影响SIP/RTP通信的

我们来看图9-5a所示的拓扑结构（下面除非特别说明我们都以这种拓扑结构为例）。假设SIP话机的IP地址是192.168.0.2，而路由器的外网IP是1.2.3.4，FreeSWITCH的IP地址是1.2.3.5。如果SIP话机向FreeSWITCH注册，它将发送以下REGISTER消息（省略了其他不需要的字段）：

```
REGISTER 1000@1.2.3.5 SIP/2.0
Contact: 1000@192.168.0.2:5060
```

该消息是从192.168.0.2:5060发出的，由于NAT设备进行了网络地址转换，因此FreeSWITCH在收到请求后会认为该消息是从1.2.3.4:5060发出的 [4]。

大家都已经知道，SIP话机向FreeSWITCH注册是为了让FreeSWITCH记住自己的Contact地址。但如果FreeSWITCH记住了192.168.0.2，由于它没法连通该地址，因此如果有人呼叫1000这个用户就会出现电话打不通的情况，这就是典型的NAT引起的问题。

解决这一问题通常有两种思路：

- 如果FreeSWITCH足够聪明，那么它应该知道192.168.0.2是一个内网地址，并且由于它收到的消息是从1.2.3.4:5060发出的，因而它可以记住后者，而不是那个内网地址。
- 可以从客户端解决，让客户端想办法知道被NAT设备映射完以后的外网地址和端口号，即1.2.3.4:5060。这个一般靠STUN服务解决。

针对这两种思路的具体的解决办法我们稍后还会讲到。下面我们再来看一下RTP的情况。

SIP走通了以后，如果RTP不通，就会出现电话打通了但没有声音的情况（或者是单通，即一方有声音，另一方没有）。

在第7章我们已经学过，RTP的地址是由SDP信息描述的，具体如下（我们照样省略了其他不相关内容）：

```
INVITE 9196@1.2.3.5
Content-Type: application/sdp
c=IN IP4 192.168.0.2
m=audio 50452 RTP/AVP 8 0 101
```

跟SIP消息类似，FreeSWITCH是无法向这个192.168.0.2发送RTP包的，这个问题可以由客户端通过STUN服务解决，也可以由FreeSWITCH端解决。如FreeSWITCH可以在收到第一个RTP包时得知该RTP流对应的外网IP和端口号（如1.2.3.4:50452），以后所有的RTP流都发送到这个NAT设备的外网地址上，NAT设备会将收到的从FreeSWITCH发送过来的RTP包转发到该内网地址上，话机就能“听”到声音了。

上面我们只谈了图9-5a所示的拓扑结构，在图9-5所示的另外两种拓扑结构下，FreeSWITCH就相当于这里说的SIP话机，它跟外网设备通信时就需要通过STUN之类的服务来获取相应的外网IP和端口号。

### NAT的穿越方法

通过对9.4.3节的学习，我们知道要解决NAT穿越问题就要解决内、外网地址映射的问题。也就是说，除了NAT设备自己知道这个映射关系以外，SIP客户端（如话机）和服务器（如FreeSWITCH）都需要知道。

在继续尝试解决NAT穿越问题前，我们先做以下的准备：

- 了解你的网络环境和拓扑结构。如了解自己的IP地址段、网关IP、外网IP、使用的路由设备厂商和型号、提供接入的服务商或运营商等。另外有一些在线工具可以帮你快速知道自己的外网地址，如你可以直接访问国内的http://ip138.com/或国外的http://ifconfig.me。笔者经常用下列命令获取自己的外网地址：

```
  $ curl ifconfig.me
  119.40.26.181
```

- 禁用路由器的ALG（Application Level Gateway）。某些路由器有ALG功能，它们会修改SIP包中的IP地址，“帮助”你进行NAT穿越。但很遗憾的是，它们实现的往往有Bug，而且该功能默认是打开的。FreeSWITCH不需要ALG。

实际上，NAT问题本来是不需要FreeSWITCH来解决的。在理想的情况下，任何可能用于NAT后端的设备要想与外界通信，都必须能自己解决NAT穿越问题。但事实上，现实世界不是理想的国度，很多设备都无法解决NAT穿越问题。因此FreeSWITCH团队通过深入研究，提供了很多方法来帮助解决NAT的穿越问题 [5]。这些方法在默认的安装下一般都能工作得很好，但在不一般的情况下还是需要手工处理的 [6]。

1. SIP穿越

FreeSWITCH默认使用ACL来判断对方是否处于一个NAT环境中，配置项如下：

```xml
<param name="apply-nat-acl" value="nat.auto"/>
```

其中，nat.auto是一个ACL，它包含RFC1918规定的私网地址，并去掉了本地网络的地址。当SIP客户端向FreeSWITCH注册时，FreeSWITCH会比较SIP消息中的Contact地址是否包含在这个ACL中，如果包含，说明是来自一个NAT背后的设备，那么它就把其Contact地址自动替换为与该设备对应的外网地址（即SIP包的来源地址，已经被NAT设备转换成了外网地址），因而接下来再有人呼叫它时，FreeSWITCH就能正常给它发INVITE请求了。

下列命令列出了一个SIP客户端通过NAT注册的情况（其中Contact中进行了人工换行）：

```
recv 557 bytes from udp/[1.2.3.4]:56020 at 04:05:37.636135:
------------------------------------------------------------------------

REGISTER sip:1.2.3.5 SIP/2.0
Contact: <sip:1002@192.168.0.2:56020;rinstance=6622cfa07990b53c>
To: "1002"<sip:1002@1.2.3.5>
From: "1002"<sip:1002@1.2.3.4>;tag=7ae09a77
Call-ID: YjU0OTdhYmRmZTEyZGU5MjM5ZGEyY2I0ZjY0NDhjZDk
User-Agent: Bria 3 release 3.5.0b stamp 69410
```

注册成功后，可以在FreeSWITCH中查看其注册情况：

```
freeswitch> sofia status profile internal reg
```

```
Registrations:
==============================================================================

Call-ID:        YTU5MzZiMjBlODkwNzQ1NGQ1Zjg0OTE3YTUxNGExNWI
User:           1002@1.2.3.5
Contact:        "1002" <sip:1002@192.168.0.2:54892;
                rinstance=1d165ab726aed220;fs_nat=yes;
                fs_path=sip%3A1002%401.2.3.4%3A54892%3B

rinstance%3D1d165ab726aed220>
Agent:          Bria 3 release 3.5.0b stamp 69410
Status:         Registered(UDP-NAT)(unknown) EXP(2013-08-17 12:51:10) EXPSECS(3658)
```

可以看到，其中Contact字段中有fs_nat=yes标志，它表示FreeSWITCH已经“聪明”地知道了该客户端是处于一个NAT后面。上面的显示是经过urlencode的，不直观，我们用urldecode [7]反编码如下：

```
sip:1002@192.168.0.2:54892;rinstance=1d165ab726aed220;
fs_nat=yes;fs_path=sip:1002@1.2.3.4:54892;rinstance=1d165ab726aed220
```

从上面的信息可以看到，FreeSWITCH既知道它的内网地址，又知道它的外网地址。以后任何时候FreeSWITCH向这个客户端发消息时，均使用fs_path指定的地址。

2. RTP穿越

解决了SIP穿越问题后，我们再来看RTP是如何穿越的。由于客户端的SDP信息中的IP地址是私网地址，因而FreeSWITCH无法直接给它发RTP包。而且，从9.4.1节我们也了解到，很多NAT设备都只有内网的主机曾经向外网主机发过包以后，才允许外面的包进入。因此FreeSWITCH使用了一个名为RTP自动调整的特性，即FreeSWITCH在SIP协商时给对方一个可用的公网RTP地址，然后等待客户端发送RTP包，一旦它收到RTP包以后，就可以根据对方发包的地址给它发RTP包了。当这种情况发生时，可以在Log中看到类似如下的信息：

```
[INFO] switch_rtp.c:4753 Auto Changing port from 192.168.1.124:50492 to 1.2.3.4:50492
```

虽然它不能解决所有问题，但总比不解决要好。当然，由于它没有约定使用SIP协商中指定的IP地址，这种解决办法可能有安全性问题，如黑客可以随机猜一些端口并向这些RTP端口发包，FreeSWITCH收到后将远端地址调整到新的黑客的IP和端口，进而RTP数据全跑到黑客那里去了。所以FreeSWITCH为了防止这个问题，规定这种端口调整只能在电话开始的时候进行，一旦调整过，就不能再进行调整了。
这种自动调整是默认开启的，如果用户不需要该功能，可以在Profile中将其禁掉：

```xml
<param name="disable-rtp-auto-adjust" value="true"/>
```

或者只针对个别的呼叫来禁止自动调整，在呼叫时可以通过设置“rtp_auto_adjust=false”通道变量禁止。

3. 其他解决方案

我们前面讲到，FreeSWITCH在默认的情况下就能很好地应对NAT的情况。但在某些网络环境下或对接某些客户端设备时（我们姑且称为“差”设备），以上手段可能还不够。FreeSWITCH还提供了一些设置，这些设置默认是不开启的，如果开启了，可能这些“差”设备就可以工作了，但会影响“好”设备。

有些设备会自动进行NAT穿越，但却把SIP包里的参数改得乱七八糟。FreeSWITCH提供了一个参数，其可以在Profile设置，以实现对这些SIP包进行“深度”检测，进而决定到底该用哪个IP地址。该参数是：

```xml
<param name="aggressive-nat-detection" value="true"/>
```

另外，FreeSWITCH还有一族称为NDLB [8]的配置参数，可以帮助某些“差”设备，如将aggressive-nat-detection参数配置到用户目录中，它会用接收到的SIP包的源地址改写Contact中的IP地址。
下面一个参数需要配置到Profile中：

```xml
<param name="NDLB-force-rport" value="true"/>
```

要理解NDLB-force-rport这个参数，先来说一下什么是rport [9]。对于支持rport的设备，在发起请求时会在Via字段中带一个空的rport参数，如：

```
recv 813 bytes from udp/[1.2.3.4]:5060 at 04:05:37.660375:
------------------------------------------------------------------------

REGISTER sip:1.2.3.5 SIP/2.0
Via: SIP/2.0/UDP 192.168.0.2:5060;branch=z9hG4bK-d8754z-65d2be1ee849d851-1---d8754z-;rport
Contact: <sip:1002@192.168.0.2:5060;rinstance=6622cfa07990b53c
```

FreeSWITCH在收到该请求后，发现该SIP包的实际来源地址是1.2.3.4:5060，因此它会将响应包发往该地址，并在Via字段中设置rport的值为实际来源端口值，同时增加received参数，指定来源IP地址。它回应的SIP消息如下：

```
send 698 bytes to udp/[1.2.3.4]:5060 at 04:05:37.663393:
------------------------------------------------------------------------

SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.0.2:56020;branch=z9hG4bK-d8754z-65d2be1ee849d851-1---d8754z-;rport=5060;received=1.2.3.4
```

SIP客户端在收到该响应后，“学习”到了自己对应的外网地址，因而在接下来重发的注册信息中，Contact地址就可以填外网的地址了。

有意思的是，某些设备支持rport这一功能但在发送请求的时候在Via字段中又没有相应的rport参数。因而在FreeSWITCH开启NDLB-force-rport参数可以认为所有设备请求都带了rport参数，进而打开这些“差”设备的rport功能。需要指出的是，有些设备确定不支持rport，带了该参数可能会导致这些设备不能用，因而该参数的值也可以设置成safe（其他的取值还有client-only和server-only，读者可以自己尝试一下），即仅打开已知可用设备这一功能。

该参数是作用于整个Profile的。有时候在既要支持好设备又要支持差设备的情况下，是否使用该参数不能两全。解决的办法是可以再建立一个新的Profile，单独让这些差设备注册到新的Profile。
NDLB还有其他的参数，有的跟NAT相关，有的不相关。当然了，笔者希望大家永远都用不到这些参数，因为一旦涉及这些参数就会很麻烦，但如果有些设备必须要用这些参数，可以参考http://wiki.freeswitch.org/wiki/NDLB。

好了，接下来就要进入本节的正题了，让我们具体了解其他NAT穿越问题的解决方案。

（1）客户端解决方案

前面我们了解到，FreeSWITCH提供了多种手段来帮助客户端设备穿越NAT，并且在9.4.4节我们也提到，这些工作原来应该是在客户端做的。如果客户端能够知道自己将要被映射出去的外网IP地址和端口，那么它就可以直接在SIP/SDP消息中填上外网地址，因而FreeSWITCH就不用再费劲检测客户端是否有NAT了。

在9.4.4节我们讲到可以使用ifconfig.me之类的服务获取自己的外网IP，但SIP通信中还必须得知道映射的外网端口号。这一工作需要靠STUN [10]来实现。STUN的原理是：在公网上部署一台STUN服务器，位于NAT后面的客户端设备向它发送一系列的UDP包先在NAT设备上打一个“洞”，STUN服务器取到UDP包的来源地址以后，会回送相关的消息告诉该客户端它被映射的外网地址。

大多数的SIP话机及软电话客户端均可以选择是否启用STUN服务。使用STUN以后，SIP消息的Contact头域中就可以直接填入外网地址，这时在FreeSWITCH端看到的注册信息如下（可以跟FreeSWITCH检测到NAT的情况对比一下）：

```
freeswitch> sofia status profile internal reg

Registrations:
==============================================================================

Call-ID:        MWI3OGU3OTk0ODc1ZTFhMmRhZWZmZmM1ZjkwOTVjMTM
User:           1002@115.28.33.221
Contact:        "1002" <sip:1002@119.40.26.181:29054;rinstance=98cf71bfe4dbb8bf>
Agent:          Bria 3 release 3.5.0b stamp 69410
Status:         Registered(UDP)(unknown) EXP(2013-08-17 12:54:14) EXPSECS(3646)
```

对比9.4.1节我们容易得出这样的结论，STUN服务对于锥型NAT是有效的，但对于对称型NAT就无能为力了。这是因为锥型NAT对内网的同一个源地址和端口发往任何外网IP地址的数据都映射成同一外网IP和端口，而对称型NAT则对发往不同IP地址的包进行不同的映射，因而在对称NAT的情况下虽然客户端能从STUN服务器学习到外网IP地址和端口号，但是在客户端向真正的SIP服务器发UDP包时，在NAT设备上会映射出另外一个IP及端口号，因而先前从STUN服务器学习到的是无效的。

另外，考虑图9-5c所示拓扑结构，如果互相通信的两个SIP终端分别位于两个对称NAT之后，则它们是无法进行通信的，因为打通一个“洞”需要首先向对方发送数据，而在对称NAT的情况下谁都无法向先向对方发送数据，因而无法实现UDP通信。

TURN [11]技术主要用来解决对称型NAT的问题的，当然，它对于其他的NAT类型同样有效。使用它需要在公网上部署一台TURN服务器，该服务器作为一个“中间人”对双方的数据进行转发。FreeSWITCH不支持TURN [12]，在这里我们就不多讲了，有兴趣的读者可以参阅相关资料。

除了STUN和TURN外，还有RSIP（Realm Specific IP）、symmetric RTP等NAT穿越技术，但这些技术应用于不同的网络拓扑时都会各有利弊，无法在所有情况下都保证完美。所以人们一直在寻求一种足够灵活的方案，使用它可以在各种情况下对NAT穿透提供最优的解决方案。ICE技术就是满足这一条件的解决方案。

ICE [13]的全称是交互式连通建立（Interactive Connectivity Establishment），它其实不是一个新的协议，而是综合利用现有的STUN和TURN等技术，使之在最合适的情况下工作，以弥补单独使用某种协议所带来的固有的缺陷。

在SIP通信中，ICE通过扩展SDP，为RTP媒体提供多个候选的地址（Candidate），这样两个SIP终端之间就可以尝试多个不同的候选地址找到一个最优的通信路径。比如，如果两个SIP终端处于相同的NAT后面，则它们可以直接用内网地址进行通信；如果位于不同的NAT后面，并且是锥型NAT，则他们可以选择从STUN服务器获得的外网地址进行通信；如果是对称型NAT，则只能通过TURN来进行通信了。

（2）FreeSWITCH处于客户端的位置

以上我们讲的大部分是针对FreeSWITCH在公网上作为服务器端的情况。考虑图9-5b所示拓扑结构，当FreeSWITCH需要穿越NAT向外部的网关注册时，它就相当于处在客户端的位置 [14]。我们一直在说客户端如果处于NAT之后，NAT问题要自己解决，因此，FreeSWITCH也有自己的解决方案。

首先，FreeSWITCH支持通过uPnP或NAT-PMP协议 [15]在路由器上“打洞”。打洞完成后它就知道了自己将要映射的外网地址了。当然，使用该协议需要路由器支持，在笔者的网络环境下，FreeSWITCH启动时可以看到如下信息，证明FreeSWITCH确实检测到外网的地址了：

```
[INFO] switch_nat.c:420 Scanning for NAT
[DEBUG] switch_nat.c:170 Checking for PMP 1/5
[ERR] switch_nat.c:201 Error checking for PMP [general error]
[DEBUG] switch_nat.c:425 Checking for UPnP
[INFO] switch_nat.c:434 NAT detected type: upnp, ExtIP: '119.40.26.181'
[DEBUG] switch_nat.c:264 NAT thread configured
[DEBUG] switch_nat.c:275 NAT thread started
```

也可以在FreeSWITCH中使用如下命令进行验证：

```
freeswitch> show nat_map
port,proto,proto_num,sticky
5060,udp,0,0
5060,tcp,1,0
5080,udp,0,0
5080,tcp,1,0
4 total.
```

上述命令显示了4个端口映射关系，下列命令可以看到映射后的外网地址：

```
4 total. freeswitch> nat_map status
Nat Type: UPNP, ExtIP: 119.40.26.181
NAT port mapping enabled.
port,proto,proto_num,sticky
5060,udp,0,0

5060,tcp,1,0
5080,udp,0,0
5080,tcp,1,0
```

其中，ExtIP:119.40.26.181就表示FreeSWITCH是通过uPnP学习到的外网地址。

FreeSWITCH检测到NAT以后，会设置Profile的外网SIP和RTP的IP。下列命令显示了external Profile当前的Ext-SIP-IP和Ext-RTP-IP：

```
freeswitch@seven> sofia status profile external
================================================================

Name                external
Domain Name         N/A
Auto-NAT            true
DBName              sofia_reg_external
Pres Hosts          192.168.1.124,192.168.1.124
Dialplan            XML
Context             public
Challenge Realm     auto_to
RTP-IP              192.168.1.124
Ext-RTP-IP          119.40.26.181
SIP-IP              192.168.1.124
Ext-SIP-IP          119.40.26.181
```

其中Ext-SIP-IP和Ext-RTP-IP是在与外网的服务器通信时用的。它在FreeSWITCH中默认的配置（在external.xml中）如下：

```xml
<param name="ext-rtp-ip" value="auto-nat"/>
<param name="ext-sip-ip" value="auto-nat"/>
```

其中，auto-nat说明它试图自动检测到NAT外网的地址。如果路由器不支持uPnP及NAT-PMP协议，那么可以在这里填入一个stun服务器的地址，让它从stun服务器获取，如：

```xml
<param name="ext-sip-ip" value="stun:stun.freeswitch.org"/>
<param name="ext-rtp-ip" value="stun:stun.freeswitch.org"/>
```

注意，stun.freeswitch.org可以做测试用，但它不保证永远可用。如果使用上述STUN服务不能正常获取IP，则可以尝试其他STUN服务器。在网上可以找到好多免费的STUN服务器，当然需要自己运营SIP服务的应该自己搭建STUN服务器。

FreeSWITCH提供了一个stun API命令用于测试STUN服务器是否能正确返回外网的IP及端口号。下列命令检测到服务器是正常的：

```
freeswitch> stun stun.freeswitch.org
119.180.70.163:50285
```

下列命令则不能返回正常的结果，因为我们使用的不是一个有效的STUN服务器：

```
freeswitch > stun www.freeswitch.org
-STUN Failed! [Timeout]
```

如果不使用STUN，也可以手工找出路由器的外网IP，有以下两种设置方法：

```xml
<param name="ext-sip-ip" value="autonat:119.40.26.181"/>
<param name="ext-rtp-ip" value="autonat:119.40.26.181"/>
<param name="ext-sip-ip" value="119.40.26.181"/>
<param name="ext-rtp-ip" value="119.40.26.181"/>
```

其中，上述两种配置方法是差不多的，只不过带了“autonat:”前缀以后FreeSWITCH会更智能一些，读者可以自己尝试，看看带与不带有什么区别，这里就不多讲了。最后，你也可以设置一个DNS，如host:sip.example.com，通过域名解析获得外网的IP地址。

（3）其他

一般来说，FreeSWITCH足够智能，使用默认的配置就够用了。但FreeSWITCH并不能帮你解决所有NAT的问题，实际使用过程中还得具体问题具体分析。比如你可能为了兼容某些设备改了一些Profile的参数，同时导致另外一些本来好用的设备不好用了。或者，你修改了ext-sip-ip/ext-rtp-ip后外部的用户注册好用了，但NAT内部用户打电话却有问题了。大多数情况下，一个Profile通过设置适当的参数就能解决这些问题。但如果你遇到的不是上述的“大多数”的情况，那么可以通过创建多个Profile来解决，让某些设备注册到其中一个Profile，另一拨人注册到另一个Profile。当然同时使用多个Profile还需要一些设置技巧，我们将在后面的实战章节中深入探讨。

另外，考虑图9-5c所示拓扑结构，如果FreeSWITCH是企业内部的PBX，员工可能经常会在办公室A或外部B（家里）之间换来换去，那么它可能要在办公室里向内网地址192.168.0.2注册，在外部时就向1.2.3.4注册。每次改来改去比较麻烦。这种情况可以在企业内部部署DNS服务器通过DNS解决；另外有的路由器设备支持所谓“发夹”（Hairpin）的功能，通过这个功能可以解决该问题，有条件的读者也可以尝试一下，因为笔者没有见过这种路由设备，在这里就不多讲了。

[1] http://tools.ietf.org/html/rfc1918。它规定的私有IP地址有：A类：10.x.x.x；B类；172.16.x.x~172.31.x.x；C类：192.168.x.x。 

[2] CANN全称为The Internet Corporation for Assigned Names and Numbers，即互联网名称与数字地址分配机构。 

[3] The more things change,the more everybody wants it to stay the same.It's just a part of how technology evolution works.Our cars still pretend to have speedometer needles;the graphics on your favorite website look like an old-fashioned set of buttons and switches.We as a society also try to live by the motto:"If it ain't broke,don't fix it!"

[4] 路由器映射的端口号也可能不是5060，比如，如果有两个话机同时注册，另一个映射可能成5061。 

[5] To be honest,the original stance of the FreeSWITCH developers on the NAT issue was,&quot;Not our problem!&quot;In an ideal world,every device behind aNAT firewall is well aware of its circumstances and can successfully solve its own problems.Unfortunately,we do not live in an ideal world(of course if we were in an ideal world,none of us would have ajob because there would be no problems to solve).So we decided,&quot;OK fine,we'll give it ashot!&quot;We soon learned that our users had amyriad of devices that they wanted to use with FreeSWITCH,but these devices had absolutely no idea how to deal with NAT.Soon,we began the monumental task of developing techniques to allow these devices to work despite their shortcomings.NAT is a vicious opponent and the faint-hearted do not stand achance to survive.——摘自《FreeSWITCH 1.2》 

[6] Anthony也说过：“如果你觉得NAT问题这么令人困惑，请自我安慰一下，实际上我们已经尽力把这个问题简化了。如果现在你还是觉得它很复杂，实际情况是它以前更差。”原文是：“If you find this whole thing to be completely confusing,take solace in the fact that we have actually simplified it for you.So while it may seem to be crazy right now,the fact is that it was much worse before.”——摘自《FreeSWITCH 1.2》 

[7] 这里有一个实用的站长工具：http://tool.chinaz.com/Tools/URLEncode.aspx。 

[8] No Device Left Behind，不遗弃任何设备。参见：http://wiki.freeswitch.org/wiki/NDLB。 

[9] 参见：http://www.ietf.org/rfc/rfc3581.txt。 

[10] Session Traversal Utilities for NAT，即NAT会话穿越工具。参见：http://zh.wikipedia.org/zh-cn/STUN。 

[11] Traversal Using Relay NAT，即使用转发方式进行穿越的NAT。参见：http://zh.wikipedia.org/wiki/TURN。 

[12] 但支持TURN的SIP客户端可以与FreeSWITCH配合工作。 

[13] 参见：http://zh.wikipedia.org/wiki/互动式连接建立。 

[14] 当然，其他的SIP客户端还可以向它注册，它还是服务器，如图9-5c所示。 

[15] uPnP称为Universal Plug and Play，即通用即插即用。NAT-PMP称为NAT Port Mapping Protocol，即NAT端口映射协议。它们主要用来在NAT设备上打洞，分别参见http://zh.wikipedia.org/wiki/Upnp和http://en.wikipedia.org/wiki/NAT-PMP。

## 小结

本章介绍了mod_sofia在FreeSWITCH中的位置及其基本概念。也讲到了其配置文件的结构，并对默认配置文件中的主要参数进行了解释。笔者深知，仅进行简单的解释还是不够的，实际的使用过程中可能会有好几个参数配合使用，也可能每一个参数都是一则故事，但是如果在本章把这些都展开，还是为时过早。一般在使用过程中仅需要用到少数的参数就够了，因此建议读者在这里先对这些参数有些直观的印象即可，后面的章节中我们会配合一些实例再来详细学习这些参数的用法。

此外，本章还花了很大的篇幅讨论NAT穿越问题。NAT无处不在，所有人都可能遇到。但FreeSWITCH在默认情况下已经帮我们处理了大部分问题。如果你很不幸遇到了NAT的问题，那么也可以尝试修改本章提到的参数看能否解决。对于更复杂的NAT问题，解决起往往需要花很多时间和精力，有时候并不能仅靠修改几个参数实现，可能还需要改变网络的拓扑结构、调整SIP终端设备或路由器的参数等 [1]。因此，对于初学者而言，还是建议在局域网上学习，等熟悉了各种配置参数以及掌握了一定的调试技术以后再尝试解决NAT穿越问题。解决NAT穿越问题时比较有效的方法是进行抓包分析，有时候可能需要在多个点（如话机侧、路由器上、服务器）上抓包比较。然后，尝试修改本章提到的各种参数，看有什么不同。总之，NAT问题复杂归复杂，有了这些基础知识再加上一定的经验，多花点时间，相信所有人都能解决。

[1] 有一次，在解决NAT引起的单通问题时我们尝试了各种手段就是收不到RTP，后来禁用了路由器的“启用快捷转发”功能才把问题解决。能用这样的方法解决问题，多半是靠运气。