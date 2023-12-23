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
# 第14章 FreeSWITCH与其他设备或系统对接

上一章，我们讲了不同的FreeSWITCH之间的对接，了解了FreeSWITCH世界的配置及组网方式。在本章，我们该走出FreeSWITCH，去看看外面的世界了。

我们在前面的章节中讲到，FreeSWITCH支持多种协议，可以与众多的系统进行对接。在这一章，我们就配合一些实例来看一看在FreeSWITCH中是怎么配置的。其实，只要读者熟悉了前面章节的内容，配置FreeSWITCH与任何系统对接都是没有问题的。但在本章，我们还是通过实例，拓展一些概念和基础知识，并且与读者一起熟悉一些常见的对端设备。读者也可以从这些实例中思考一下对端是怎么实现与我们的FreeSWITCH对接的，从而更加深刻地理解一些基本概念和系统的运行机制，以便在以后的应用中做到游刃有余。

另外，本章将要讲到的“其他系统”大部分属于传统的电信设备或系统，因而读者如果对这些传统的概念不熟悉，建议再回过头去复习一下第1章和第2章中相关的内容。

## 使用Doubango客户端连接

Doubango [1]是一个不错的开源框架，它跟电信业务走得比较近，主要集中在以3GPP、TISPAN、Packet Cabel、WiMax、GSMA、RCS-e、IETF等为标准的NGN技术、音视频处理技术、云计算以及WebRTC技术等中。该框架使用ANSI C编写，具有很好的可移植性。在很多平台上都有基于Doubango的客户端实现，如Windows上的Boghe、Mac上的iDoubs以及Android系统上的IMSDroid等。

但是，我们这里单独介绍Doubango并不是因为其强大，而是因为它总是倾向于把简单的东西搞得异常复杂。

我们在第3章曾介绍过，最简单的SIP注册一共就需要三个选项：服务器地址（Realm）、用户名（Username）和密码（Password），但在Doubango中，就没这么简单了。如果你要注册，就得填一大堆的东西，并且格式相当严格和专业，这令好多初学者都摸不着头脑。

下面我们以Mac平台上的iDoubs为例，讲一下它往FreeSWITCH上注册的方法。图14-1是笔者使用Mac版的iDoubs注册时的参数设置，在其他平台上可以参考使用。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-952910.png)

<center>图14-1　iDoubs注册设置</center>

要进行注册，首先，要到“Preferences”->“Network”中设置Proxy-CSCF-Host和Proxy-CSCF-Port。这是代理服务器的地址和端口号，相当于其他软件高级设置中的Outbound Proxy。这个地址的意思是，如果Doubango注册时，会将注册的包发到这个地址。而它实际请求域（或简单认为是注册的地址）将是下一步我们将要设置的Realm的地址。但由于我们的FreeSWITCH只有一个地址，因而这里就填FreeSWITCH服务器的IP地址。

接下来，要填写注册相关的参数。其中，Display Name跟其他软件中的一样，是可以随便填的。Public Identity是IMS里的概念，相当于你的公有SIP地址，就是说，别人呼叫你的时候要呼叫这个地址。注意这个地址的格式，其中的“sip:”是不能省略的。Private Identity是你的私有账号，这个在认证的时候要使用，相当于其他软件中的Username或Auth-User（会出现在SIP消息的Authentication头域中）。Password就是密码。Realm是服务器的域（或IP地址）。

总之，基于Doubango的所有默认应用都倾向于把填写注册信息弄的异常复杂 [2]。不过，如果顺利过了这一关，大家也能学到不少的知识。尤其是在下一节的对接IMS系统时我们还会看到更复杂一些的参数。

[1] 参见http://doubango.org/。 

[2] 实际上，其他类似的的SIP客户端软件也都需要这些信息，但它们都会要求填入最少的信息，如果可能的话，会自动计算这些值，或者有合理的默认值（如FreeSWITCH中的网关设置）。Doubango官方提供的各种应用在这一点上都不是很人性化。

## 对接IMS

IMS是新一代通信网络事实上的标准，它旨在在过渡阶段兼容原有的PSTN TDM网络（基于电路交换的网络，在IMS中称为CS域），并最终将所有的业务都转移到基于包交换的网络（PS域）中。

目前，国内的运营商都部署了IMS。IMS网元众多，系统各网元之间通过高速网络相连。就与交换最相关的核心功能来讲，在IMS内部，包含P-CSCF、I-CSCF、S-CSCF及AS等功能与实体。其中P-CSCF位于网络的边缘，接收SIP消息，并将SIP消息转发到内部的S-CSCF及AS上。

一般来说，IMS运行在运营商内部专门的网络上（称为承载网），而在外部是无法接触到运营商的内部网络的。如果要通过互联网与运营商的IMS对接，就需要通过SBC设备及层层防火墙。SBC设备横跨运营商的承载网及互联网。所以，一般来说，我们可以通过SBC连接到IMS，进而能够与PSTN网络上所有的电话进行通信。所以我们可以把SBC设备和IMS看成一个SIP转PSTN的“大”网关。实际上，在实际使用中，大家也不关心是否有SBC设备，而只认为运营商有一个“大大”的SIP服务器，它可以给我们开放账号。

目前，有些运营商也开始在IMS系统上针对一些话务批发商或企业应用放号，因此如何使用FreeSWITCH与其对接就是我们需要研究的了。

### 网关配置

当然，与IMS对接最好的方式是使用SIP中继方式对接，配置简单使用起来也灵活。但很少有运营商允许你这么做。比较典型的方式还是使用类似电话号码的方式，一个账号一个账号地对接。

下面是一个与云南移动的IMS使用账号对接的实例。笔者拿到的是一个试验号码，实际上，对我们来讲，它就是一个SIP服务器上的账号。为了与其对接，我们要将FreeSWITCH当作一个SIP客户端注册到IMS上去。在FreeSWITCH中，这可以通过添加一个网关实现。下面是一个网关的配置文件：

```xml
<gateway name="ims">
    <param name="realm" value="ims.yn.chinamobile.com"/>
    <param name="register-proxy" value="211.139.x.x"/>
    <param name="username" value="+86871xxxxxxxx@ims.yn.chinamobile.com"/>
    <param name="password" value="1234"/>
    <param name="from-user" value="+86871xxxxxxxx"/>
    <param name="from-domain" value="ims.yn.chinamobile.com"/>
    <param name="register" value="true"/>
    <param name="outbound-proxy" value="211.139.x.x"/>
</gateway>
```

在网关的配置参数中：

- ims.yn.chinamobile.com为云南移动内部的域。在公网上，它并不是一个合法的域名。那么我们怎么能注册到该服务器上去呢？实际注册的服务器地址是用register-proxy定义的，这里211.139.x.x是一个SBC的地址。以前，我们在配置网关时都不写这个register-proxy参数，它默认就等于realm。
- username是IMS中的用户账号，它和password配合用于鉴权（前者将出现在SIP消息中的Authorization头域中）。该用户账号中包含了用户所属的域，其用户名部分是一个PSTN网络中的E164格式的电话号码，前面几位中的“+86”表示中国的国家代码，“871”是云南昆明的区号，后面的“xxxxxxxx”则是一个本地的电话号码。
- from-user指定在SIP消息中的源用户信息，from-domain则是指定域，它们会影响SIP中的From头域。
- register的值为true表示FreeSWITCH会向该网关发起注册。
- 前面的信息都是与注册相关的，最后的outbound-proxy表示呼叫（即INVITE消息）应该发到什么地址，它可以是与注册服务器不同的地址，不过在本例中它与register-proxy是相同的。

当然，上述这些参数的值都是在IMS系统上配置的。从IMS上取得正确值并进行配置后，我们就完成了从FreeSWITCH注册到IMS，这时就可以对外打电话了。

### 通过IMS呼出

完成上一节的配置后，我们可以很快地在FreeSWITCH中输入以下命令试一试它是否真的能打到我们的手机上：

```
originate sofia/gateway/ims/0186xxxxxxxx &echo
```

电话接通后，应该能听到自己的声音（回音）。注意，上述账号就相当于一个云南昆明本地的电话号码，因而拨云南以外的手机号需要加“0”。

在Dialplan中，进行如下设置就可以通过上面的网关往外打电话了：

```xml
<extension name="IMS gateway outbound">
    <condition field="destination_number" expression="^(0.*)$">
        <action application="bridge" data="sofia/gateway/ims/$1"/>
    </condition>
</extension>
```

当然，如果运营商给我们开的账号支持号码透传的话，我们就可以透传任何号码了。比如下面的代码，透传了一个美国的911出去（注意，最好不要透传110）：

```xml
<action application="set" data="effective_caller_id_number=911"/>
<action application="bridge" data="sofia/gateway/ims/$1"/>
```

其实，有意思的是，有的运营商开的账号默认就是支持透传的，这样就会将FreeSWITCH内部的分机号（如1000）透传出去。为了能对所有呼出的电话都显示运营商给我们分配的号码（这里的“xxxxxxxx”），我们可以使用如下Dialplan设置：

```xml
<action application="set" data="effective_caller_id_number=xxxxxxxx"/>
<action application="bridge" data="sofia/gateway/ims/$1"/>
```

也可以使用如下设置：

```xml
<action application="bridge" data="{origination_caller_id_number=xxxxxxxx}sofia/gateway/ims/$1"/>
```

### 通过IMS呼入

在我们正确向IMS注册后，这种号码也支持呼入。如果有人呼叫该号码（即这里的“xxxxxxxx”），IMS就会给我们的FreeSWITCH发SIP INVITE消息。我们的FreeSWITCH收到该消息后，就可以在FreeSWITCH中进行路由了。一般来说，呼入的DID是不带区号的本地号码，就是上面网关配置中的“xxxxxxxx”部分，然后，我们就可以设置如下Dialplan将来话路由到一个IVR：

```xml
<extension name="IMS gateway outbound">
    <condition field="destination_number" expression="^(xxxxxxxx)$">
        <action application="answer" data=""/>
        <action application="ivr" data="demo_ivr"/>
    </condition>
</extension>
```

当然，如果我们很神奇地从运营商那里获得了一个号段（如一个千群或一个万群），也可以把这个号码与我们内部的分机号做成一对一的关系。如，下面Dialplan设置可以将来话DID的后4位与我们内部的分机号一一对应：

```xml
<extension name="IMS gateway outbound">
    <condition field="destination_number" expression="^xxxx([0-9]{4})$">
        <action application="answer" data=""/>
        <action application="bridge" data="user/$1"/>
    </condition>
</extension>
```

### 其他问题

与这种IMS对接的难点就是调试比较困难。一般来说，也很难找到对端真正懂技术的技术人员配合。所以，在对接遇到问题时，解决的方法基本上就是抓包，看SIP消息，然后瞎猜，把所有可能的参数都试一遍。

在一次与IMS的对接测试中，发现主叫听不到被叫方的回铃音。经过无数次的探索，终于发现，对方需要一个特殊的SIP消息头“P-Early-Media:supported”。该消息头是在RFC5009 [1]中定义的。在FreeSWITCH的Dialplan中，可以使用“sip_h_”开头的通道变量添加扩展的SIP消息头，实现添加上述SIP消息头的Dialplan设置如下：

```xml
<action application="bridge" data="{sip_h_P-Early-Media=supported}sofia/gateway/ims/$1"/>
```

一般来讲，SIP中的“1xx”响应消息是不需要证实的，但在IMS系统中，大部分情况下183消息也是需要证实的，否则可能无法听到正常的回铃音甚至无法正常接续。与普通的证实消息ACK不同的是，对于“1xx”的消息需要使用PRACK [2]（即Pre-ACK）消息证实。通过在Profile中开启如下参数可以让FreeSWITCH在收到183时发送PRACK证实消息：

```xml
<param name="enable-100rel" value="true"/>
```

通过这些配置，FreeSWITCH就可以完美地与IMS系统对接并进行呼入呼出了。

[1] 参见http://tools.ietf.org/html/rfc5009。 

[2] 参见http://tools.ietf.org/html/rfc3262。

## 连接模拟话机和模拟中继线

在实际应用中，不可避免地要连接模拟话机。这里说的模拟电话机就是我们在家里或公司中常见的普通电话机。当然，在没有FreeSWITCH之前，我们的电话机就是通过一根普通模拟电话线连接出去的（具体连接到哪儿将在第14.3.1中讲到），并通过这条电话线往外打电话。

现在，我们有了FreeSWITCH，那我们就会想到两个问题：

- 我们能不能把模拟话机也连接到FreeSWITCH上？这样模拟话机就可以与我们的SIP软电话（或硬电话）通话了。
- 我们的FreeSWITCH能不能通过模拟电话线也往外打电话，甚至别人也可以通过与该电话线对应的号码呼叫我们？

答案是肯定的。下面，我们就来看一下这两个问题是怎么解决的。不过，在这之前，我们先来看一些与模拟电话相关的概念。

### FXS和FXO

普通电话机是模拟的，通过一根模拟线连接到距离最近的电话交换机上。根据所处位置的不同，这个交换机可能是处在运营商机房的交换机，也可能是运营商设在用户小区的一个模块局中的交换机，还可能是本企业自己建设的用户小交换机。近几年，为响应国家光进铜退的号召，有些运营商就直接将光纤拉到用户家里，通过一个“小盒子”（因特网接入设备，称为IAD）将光纤接口转成普通的以太网口和模拟电话接口，然后再在模拟电话接口上接电话机。总之，我们的普通电话都要通过一根电话线连接到某个设备上。该设备提供一个模拟电话线的接入端口，在技术上，称为FXS口。同时，我们的电话机上也有一个模拟线的接口，称为FXO（在物理上，就是一个RJ11接口 [1]）。FXS和FXO的连接方式如图14-2所示。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-967855.png)

<center>图14-2　FXS和FXO连接示意图</center>

从常识来讲，我们知道，电话线是带电的，即使家里停电了也可以打电话，如果不小心摸到裸露的电话线也会有“触电的感觉”；而话机本身是不带电的，直接在话机上接上电话线并也不会感觉到有电 [2]。由此我们可以联想到，FXS口是带电的，而FXO口是不带电的。这也是两者的根本区别。

实际上，FXS提供的是–48V的直流电，主要是为了能感知话机摘挂机的变化、给话机提供拨号音、振铃及其他信号音等。在摘机状态下，电压将降至 [3]–7V，而在振铃状态下电压可能增大至–90V。也可以这样认为，FXS与FXO的区别是：前者能提供拨号音。

`注意`：在实际使用中一定不要将两个FXS口用电话线连接在一起，否则两者互相供电，后果是不堪设想的。

### 拓扑结构

有了上述基本概念以后，我们就可以来看一下要解决我们的问题需要的拓扑结构了。如图14-3所示，我们把图14-2中的电话线从中间截断，中间放上FreeSWITCH。FreeSWITCH提供一个FXO接口用于连接原来的交换机；另外提供一个FXS接口用于连接原来的模拟电话。此外，其他的SIP话机也可以通过以太网(Ethernet）口接进来，以实现互相通信。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-981855.png)

<center>图14-3　FreeSWITCH连接FXS及FXO的拓扑结构</center>

FreeSWITCH本身是一个软件，因而它是不能提供FXO和FXS硬件接口的。要解决这一问题，有以下两种方案：

- 在FreeSWITCH所在的服务器上安装相关的硬件板卡，该硬件板卡负责提供连接FXO及FXS的硬件接口。FreeSWITCH就可以通过相应的驱动程序去控制这些板卡。因而相当于给FreeSWITCH增加了FXO及FXS的接入能力。这类板卡中比较有代表性的有Sangoma及Diguim生产的模拟和数字板卡等。国内也有许多厂商生产所谓的“Asterisk兼容卡”，它们有的（如OpenVox）也能与FreeSWITCH搭配使用。
- 通过外部网关 [4]来实现。有些厂商针对这一问题专门生产了支持SIP到模拟线的转换网关，称为模拟网关。对于FreeSWITCH来讲，这种网关就是一个普通的SIP UA；而对于模拟话机来讲它就是一个电话交换机；对于电话交换机来讲，它就相当于一个普通模拟话机 [5]。

至于如何在以上两种方案之间选择，没有标准的答案。如果有的话，也是具体问题具体分析 [6]。不过，一般来说，笔者建议：对于模拟线路，选用第二种方案，因为这些网关设备很容易买到，而且坏了可以随时更换，兼容性也比较强；而第一种方案中支持这些板卡的驱动往往需要编译内核等，操作起来比较复杂。后面我们讲到用于数字线路的数字板卡时则可以考虑使用第一种方案，性价比和可控性会高一些。

增加了网关后的拓扑结构如图14-4所示。与图14-3比较起来，相当于在FreeSWITCH中把内置的板卡换成了外置的网关设备。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182223-996853.png)

<center>图14-4　FreeSWITCH通过网关连接模拟话机及电话线</center>

在实际应用中，有单纯的FXS网关及FXO网关，端口数从1口、2口到几十口不等。也有的网关是FXS和FXO混合装在同一设备上的，根据实际需求可以选用不同的网关。

下面我们先来看一下模拟网关的配置和使用。

### 使用潮流网关连接模拟话机

我们先来看一下如何将话机通过模拟网关连接到FreeSWITCH上。潮流网络公司有一款型号为HT701的单口模拟网关，它有一个FXS口和一个以太网接口，FXS口用于连接话机，以太接口用于通过以太网连接FreeSWITCH。如果把它和与之相连的模拟话机看成一体的话，实际上就相当于一个SIP话机。也可以说，这款模拟网关能把普通的模拟话机“变”成SIP话机。该网关小巧方便，比较适合在桌面上使用。

该网关有一个简单的Web配置界面 [7]，如图14-5所示。首先切换到“FXS PORT”配置界面，通过相关配置，可以令其向网关注册。在图中可以看到，它其实跟图3-13中亿联话机的账号配置界面是类似的（因为该网关的功能就相当于一个SIP话机）。其中，Primary SIP Server填入我们FreeSWITCH服务器的IP地址；Failover SIP Server是一个备份服务器，用于在Primary SIP服务器出现故障的时候自动倒换到Failover指定的服务器上，在这里我们不使用，可以不填；SIP User ID即我们注册的账号，在这里我们使用FreeSWITCH默认提供的账号1000；Authenticate ID为认证ID，跟账号一样；Authenticate Password即密码，填入1234，Name为SIP中的显示的名字，可以随便起一个；其他的都保留默认配置就可以了。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-012855.png)

<center>图14-5　HT701的配置</center>

正确配置完上述选项后，就可以切换到“Status”页面查看注册状态了。如果注册正常，拿起相连的模拟话机的话筒就可以听到拨号音，然后就可以像正常的SIP话机一样打电话了。别人拨打SIP账号1000时，模拟话机也会振铃。

### 使用迅时网关连接模拟话机和模拟中继线

上海迅时的网关设备也是国内市场上常见的设备。在本节，我们以迅时MX8为例来讲解如何连接模块话机和中继线。MX8根据情况可以配置8个FXS口，也可以配置8个FXO接口，笔者使用的是一款配有4个FXS接口和4个FXO接口（简称4S4O）的网关。

1. 配置FXS接口

MX8网关FXS接口的功能和配置跟我们上面讲到的潮流HT701差不多。首先，连接MX8的Web配置界面后，依次选择“基本配置”→“SIP”→“注册服务器和代理服务器”菜单项，在配置页面上选择注册方式为“按线路注册”，使用这种注册方式可以单独配置每个FXS接口对应的SIP账号，相当于4个独立的SIP话机。

配置好SIP服务器的地址后，再转到“线路配置”→“用户线功能”页面，如图14-6所示。在线路号码中选择一个FXS接口，如FXS-1；电话号码即我们的SIP注册账号，图所示的例子中我们使用1007，勾选“注册”复选框，然后在密码栏中输入“1234”，提交后，就可以成功注册到我们的SIP服务器上了。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-026855.png)

<center>图14-6　MX8网关FXS口的配置</center>

如果有多个模拟话机，可以依次注册其他的。拿起话机听到拨号音，便可以像普通SIP电话一样对外呼叫。当然，模拨话机与SIP话机毕竟是不同的，这一点体现在拨号方式上尤为明显，要理解这一点需要了解我们下一节将要讲到的拨号规则。

2. 拨号规则

在上一节我们讲到，SIP话机与普通模拟话机的拨号方式不同。在普通的模拟电话中，拨号时，按下的每一位号码都会实时传到后端的交换机上。因而在打电话时只需要拨完号码等着就行了，交换机在收齐相关号码后会自动帮我们接续。而SIP话机是比较“智能”的设备，它能在本地存储号码，在收齐所有号后需要用户按一个“发送”键才能将被叫号码送出去。这一点和模拟电话不同，故往往会很不适应——经常在拨完了号码后忘了按发送键，瞎等半天没有任何反应。不过，这一点倒是跟手机有些类似，手机也是在收齐了号码后需要按“发送”键才能拨出的。

这里我们还是讨论模拟话机。在用户摘机后，相连的交换机就开始向话机播放拨号音并启动收号程序。一般来说，电话号码是有规律的。比方说110，交换机知道它是一个短号码，收到三位110后就不会等待下面的拨号了，保证比较快速地接续。另外大家熟悉的手机号码也都是定长的，所以交换机在收齐足够的位数后就会快速接续。

现在，我们将模拟话机接到MX8网关上，因而该网关就需要具备收号功能。为了能保证快速地接续，它定义了一些拨号规则。如果所拨的号码匹配该拨号规则，就会将号码立即送出去（即向SIP服务器发送INVITE消息）。笔者使用的网关默认的拨号规则如下：

```
01[3,5,8]xxxxxxxxx
010xxxxxxxx
02xxxxxxxxx
0[3-9]xxxxxxxxxx
120
11[0,2-9]
111xx
123xx
95xxx
100xx
1[3,5,8]xxxxxxxxx
[2-3,5-7]xxxxxxx
… 
（后面略）
```

可以看出，上述规则中第1行是匹配常见的手机号，第2行匹配北京的固定电话号码，其他的依此类推。我们在这里不介绍这些规则的具体含义，读者如果在使用时可以自行参考网关设备的参考手册。在这里需要注意的是，这些默认的拨号规则不一定适合你的需要。比如，如果你想拨打内网的一个分机号1200，由于在规则匹配时匹配到第5行的120就终止了，因而INVITE消息中的被叫号码就只是120，只要有这条规则存在，1200就永远也拨不出去 [8]。

当然，如果你不理解这些的具体含义又一时找不到手册的话也不要紧，可以尝试把这些规则全删掉，而在拨号时拨完所有号码后在后面再加上一个“#”号，MX8网关收到“#”号后就会立即将前面收到的号码送出，而不包含最后的“#”号（当然，如果被叫号码中要求包含“#”号的情况下还是可能会有问题，那时候就真需要参考设备手册了）。

3. 配置FXO接口连接外线

FXO接口可以连接运营商提供的电话线（我们称为外线）与外界通话。在MX8中，连接到FXO接口的电话线称为中继线（见2.1.2节中的模拟中继线部分）。切换到“线路配置”→“中继线功能”可以看到如图14-7所示的界面。在这里，在线路号码中选择一个端口，如FXO-1；外线号码填入运营商给我们分配的电话号码（实际上在这里可以是任意号码，它只是作为一个标志使用）；我们不像FXS那样使用注册方式向FreeSWITCH注册，而是使用“中继对接”方式与FreeSWITCH对接，因此我们不选注册复选框；接入方式选择“绑定”，并输入绑定号码（该绑定号码一般应该是运营商提供给我们的电话号码，但同样，也可以是做任意值，我们这里以88888888为例）。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-042854.png)

<center>图14-7　MX8网关FXO接口配置</center>

通过使用绑定方式，我们可以在FXO接口有来话时自动路由到FreeSWITCH上（后面会讲到具体配置）。另外还可选择二次拨号的方式，我们先来讲一下二次拨号的方式。

注意，FXO接口的功能相当于一个电话机，如果有人拨打该外线对应的电话号码（为了简单起见，我们以88888888为例），它是无法知道我们在该外线上到底接了一个电话机还是模拟网关的。当然，如果我们直接在外线接了一个电话机，有人打电话时就会振铃，我们就可以接听了。但是这里我们接了一个模拟网关，如果有电话呼进来，模拟网关振铃的铃流电压后就可以代替我们接听。但接听后下一步该怎么办呢？一般来讲，它可以给用户再放一个拨号音（有的网关可以在这里设置一个比较简短的语音提示，称为IVR），这样主叫用户就可以再次通过DTMF按键进行拨号以拨打我们的内线号码。

当然，既然我们已经有了FreeSWITCH，就可以用FreeSWITCH做任何我们想做的事。所以这里我们选择绑定方式。在绑定号码88888888后，对于任何外线来话，该网关都会向FreeSWITCH发送INVITE消息（在设置了正确的路由的情况下），被叫号码为88888888。FreeSWITCH在收到后，就可以进入Dialplan，播放IVR，引导来电用户进行下一步的操作。在这种情况下，FreeSWITCH需要先对来电应答（发送SIP 200 OK消息），这样，网关收到200 OK消息后才应答进来的呼叫（相当于我们摘机），并建立通话。

当然，FreeSWITCH也可以自己直接将该来电桥接（bridge）到一个内线号码号码上，让该内线号码振铃。如果有多条外线，可以分别插在不同的FXO接口上，对内也可以一一对应不同的内线电话（分机）。当外面的人拨打这些外线号码时，电话就能从某一个FXO接口进来，并最终向对应的内线电话振铃。这种方式，就称为DID（Direct Inbound Dialing，对内直接呼叫）。同时这些外线号码就称为DID号码，简称DID。广义上讲，即使对这些外线来话不是一一对应到内线分机上的，也称为DID，在这种情况下，可以认为DID就是一个外线接入号，是一个被叫号码。

这里配置好了以后，我们还不足以建立它与FreeSWITCH通话。要灵活地对来话、去话进行处理，我们还要用到路由的概念。

4. 配置路由

MX8网关通过路由机制对各种设备的来、去话进行控制。可以通过编辑路由表配置这些路由。路由表的语法也很简单。首先进入“拨号及路由”页面并添加如下的路由：

```
IP      1007    ROUTE   FXS     1
FXO     x       ROUTE   IP      192.168.1.9:5080
IP      x       ROUTE   FXO     5,6,7,8
```

其中，第一行表示所有从IP来的呼叫，如果被叫号码是1007，则将该呼叫路由到FXS的第1个接口上；第二行表示，所有从FXO接口来的呼叫，不管被叫号码是什么，统一路由到一个IP地址上，后面就是我们FreeSWITCH服务器的地址192.168.1.9，并且我们在这里使用5080端口，以避免对网关发来的INVITE请求进行鉴权（参考9.2.2节）。

下面，我们分几种情况进行说明。

1）模拟话机做主叫。当它发起呼叫时，由于我们在这里使用了向FreeSWITCH注册的方式，因而相当于网关设备把它转换成了一个SIP话机，网关设备就会向FreeSWITCH发起INVITE请求，接下来的接续流程跟SIP话机做主叫是一样的，呼叫进入FreeSWITCH的Dialplan，然后进行下一步的路由。

2）模拟话机做被叫。如果在FreeSWITCH中有人呼叫该模拟话机的号码（如1007），FreeSWITCH只是认为它就是一个普通的SIP用户，因而会找到网关设备注册时的Contact地址（即网关的IP），并向该网关发INVITE请求。网关收到INVITE请求后，查找路由表，并匹配到上述路由表中的第一行，因而连接在相关的FXS口的模拟话机就会振铃。

3）接受模拟外线呼入。如果外面的电话从外线呼入，来话就到达网关的FXO接口。网关从上述路由表中查到第2行所示的路由，并向192.168.1.9:5080发送INVITE请求。FreeSWITCH在收到INVITE请求后，会进入路由阶段，我们在日志中就可以看到类似如下的输出（还记得我们在6.1.1节讲到过的“绿色的行”吗？）：

```
Processing 139xxxxxxxx <139xxxxxxxx>->88888888 in context public
```

注意，其中的88888888就是我们设置的DID。因此，为了能处理该通话，我们需要在public Dialplan中添加类似如下的配置：

```xml
<extension name="DID">
    <condition field="destination_number" expression="^88888888$">
        <action application="info" data=""/>
        <action application="ivr" data="welcome"/>
    </condition>
</extension>
```

上述配置可以在日志中显示来话Channel的相关信息，并执行IVR，提示来电用户进行下一步操作。

4）通过模拟外线呼出。如果需要通过模拟外线呼出，则需要首先在FreeSWITCH中做一条路由，将去话路由到该网关上。在这种情况下，FreeSWITCH将MX8网关看成一个外部网关，因而我们可以在FreeSWITCH中添加一个网关（其中192.168.1.8为MX8网关的IP地址）：

```xml
<gateway name="mx8">
    <param name="realm" value="192.168.1.8"/>
    <param name="register" value="false"/>
</gateway>
```

其中，FreeSWITCH仅把MX8网关看作一个以中继方式对接的设备，因而不需要向其注册（register=false）。

然后，就可以使用如下的Dialplan将本地用户的去话路由出去。

```xml
<extension name="DID">
    <condition field="destination_number" expression="^0(.*)$">
        <action application="bridge" data="sofia/gateway/mx8/$1"/>
    </condition>
</extension>
```

另外，在这种中继对接的模式下，我们也可以不在FreeSWITCH中添加网关，而是直接把去话送到网关的IP地址上，如：

```xml
<extension name="DID">
    <condition field="destination_number" expression="^0(.*)$">
        <action application="bridge" data="sofia/external/$1@192.168.1.8"/>
    </condition>
</extension>
```

通过上面的Dialplan可以将FreeSWITCH中的电话送到MX8上，然后MX8收到请求后查找到以下的路由表项：

```
IP      x       ROUTE   FXO     5,6,7,8
```

该路由表表示，从IP（以太网口）进来的呼叫，不管被叫号码是什么（x代表任意号码），全部路由到FXO接口上，FXO接口的选择顺序依次是5、6、7、8。

`注意`：笔者使用的MX8有4个FXS口和4个FXO接口，FXO接口的范围是5～8。在呼出时，如果检测到某个接口忙，则顺序会选择下一个接口进行呼出。

5. 其他

对于网关来讲，还有其他的一些常用功能，比较典型的如主叫号码检测。对于一个从外线（FXO接口）进来的来话而言，如果我们在外线上开通了来电显示功能，则可以在向SIP服务器发送INVITE之前检测主叫号码。

一般来说，现行的模拟线路都使用FSK [9]方式来传送主叫号码。主叫号码在第一声振铃和第二声振铃的时间隔内传送。所以，如果使用主叫号码检测，接续时间就会长一点。从图14-7中可以看出我们勾选了“来电号码检测”功能。

开启了来电号码检测后，如果外线没有开通来电显示功能（通常该功能作为运营商的增值业务，是要单独收费和开通的），则肯定检测不到主叫号码。MX8网关在这时通常使用我们“绑定”的号码作为SIP侧的主叫号码。

另一个值得一提和功能是“回声消除”。回声一般是在话机等终端设备上产生的，典型的场景就是从话筒中传出的声音又传回到了麦克风里去了（相当于声音反射，称为回声），这样对端就会在电话中听到自己的声音，听起来会感觉不舒服 [10]。如果设备有较好的回声消除功能，它可以检测麦克风的输入，如果里面包含话筒中刚刚输出过的内容（它应该能记住一段时间的内容），则自动在传到对方之间将这部分声音数据去掉。这种技术就称为回声消除。

在图14-6中我们也勾选了“回声消除”功能，它在检测到回声时能起到一定的作用。另外，一幅比较好的耳机也能大大减少回声（声音的输出直接传的耳朵里，很少会扩散到麦克风中）。

在本节我们以迅时MX8网关为例子讲解了模拟网关的配置以及与FreeSWITCH的对接。其他厂商的网关也有类似的功能，只是具体的配置和实现方式不同。具体的应用可以参考相应的设备手册。

[1] RJ11接口最多支持4根线，不过模块电话只需要用到其中的2根。常见的以太网接口为RJ45接口，有8根线，不过一般只是用到其中的4根。 

[2] 有些话机需要安装电池或接变压器电源，这些电源主要是为了支持话机的本地显示屏等功能用的，如支持“来电显示”等。远程交换机上的馈电的功率不足以支持这些功能。 

[3] 在通信设备中一般使用负电压。注意，这里说的是电压的绝对值，虽然–48在数学上小于–7，但对于电压的绝对值来说，从48到7是下降了。 

[4] 一般来说，处于设备的中间，用于连接两个不同网络或不同协议的的设备都称为网关设备。根据网关支持的不同的接口或协议类型以及应用场景又分为多种类型，如模拟网关，E1数字中继网关等。我们在这里主要讨论SIP网关，因此一般来说网关一端的协议是SIP的。当然，对于完成同样功能的设备有时也有不同的叫法，如某些型号的路由器设备就支持模拟电话接口，因而也具有网关的功能。另外，有些设备（华为公司生产的终端设备）又称IAD（Internet Access Device，因特网接入设备），也能完成模拟网关的功能，并可能还支持其他的协议。 

[5] 也就是说，带有FSX口的设备就相当于一个电话交换机，带有FXO口的设备就相当于一个普通模拟话机。 

[6] 常见的答案是It Depends，即应该根据具体的使用场景来选择。 

[7] 其实使用这类Web界面最大的一个问题往往是如何先找到该设备的IP地址。不同厂家的设备都有不同的默认地址或者查找IP地址的方法，在使用时请参考相关设备说明书或相关资料，在此我们就不多介绍了。下同。 

[8] 通常的解决办法是去掉该行规则，如果拨打真正的外网的120时拨0120并通过相关的号码变换规则实现。 

[9] Frenquency-shift keying，即移频键控。参见http://en.wikipedia.org/wiki/Frequency-shift_keying。 

[10] 产生回声的原因是对端终端的问题，即如果你能听到回声，那一定是对端的终端设备将你的声音又反射了回来。

## 通过E1线路与其他系统对接

前面，我们讲过通过IMS或模拟中继线连接PSTN网络的例子。但很多时候，我们还是需要使用E1与其他系统对接。很典型地，某些运营商可能只提供E1线路，或者某些设备只提供E1接口。

类似我们在14.2.2节讲到的拓扑结构和对接方式，我们也可以使用E1网关或板卡来与其他系统对接。在14.2节，我们只讲了使用网关方式对接的例子。在这里，我们把两种对接方式都讲一下，以帮助读者有一个全面的了解。

我们将按图14-8所示的拓扑结构来搭建实验环境。其中FS1和FS2分别是两台装有FreeSWITCH的主机，它们分别具有IP地址192.168.1.115和192.168.1.119。FS1上装有E1板卡，可以通过E1线 [1]与E1网关相连，同时E1网关又通过以太网（使用SIP协议）与FS2相连。

其中FreeSWITCH我们使用默认的安装和默认的配置。下面我们就来看一下需要经过哪些步骤可以让分别注册到FS1和FS2上的SIP用户互相打电话。

### 配置FS1

首先，我们来看一下FS1上的配置。FS1上需要安装硬件板卡，安装驱动程序等，因而这一部分配置是比较复杂的。而且我们也将在这里学到一些新的名词术语和概念等。

1. 背景资料

传统的电话交换机都是以时分复用（TDM，Time Division Mutiplex）的方式工作的，因此，与传统交换机相连的设备及板卡都又统称为TDM设备或TDM板卡。在FS1上，我们需要使用E1板卡来支持E1接口。生产这类E1板卡的厂商有Sangoma和Digium等（当然，它们也生产模拟板卡），国内也有一些生产这种兼容卡的厂商，如OpenVox等。从历史上来讲，Digium成立于1999年，算是老牌子的板卡厂商，也就是它推动了Asterisk开源PBX软件的发展。Sangoma是一家创立于1984年的VoIP系统供应商，也是相当有历史的。Sangoma从FreeSWITCH诞生起就一直与FreeSWITCH社区深度合作，并且贡献了FreeTDM软件和mod_freetdm模块，用于配合各种硬件板卡在FreeSWITCH上工作。

最初，这些硬件板卡都是靠Zaptel [2]来驱动的，FreeSWITCH中有一个对应的模块叫mod_openzap [3]。后来，Sangoma公司贡献了并维护着mod_freetdm模块，因此就很少有人用mod_openzap了。同时，Digium也将Zaptel更名为DAHDI [4]，并继续进行改进。该协议主要在Digium的板卡中使用，国内也有一些“Asterisk兼容卡”支持DAHDI协议。Sangoma公司的板卡除了支持Zaptel和DAHDI外，还支持自己的驱动Wanpipe。并且，一般认为在并发数较高的情况下Wanpipe协议比DAHDI表现要好。

FreeTDM作为Sangoma公司贡献的开源软件，可以单独使用，也可以与FreeSWITCH配合使用。而与FreeSWITCH的配合就是靠mod_freetdm将它们联系起来的。

在本质上，FreeTDM也是一个模块化的结构，我们可以在源代码目录中使用ls命令列出FreeTDM支持的子模块 [5]。在FreeSWITCH源代码目录中执行ls命令的输出结果如下：

```
$ ls libs/freetdm/src/ftmod/
ftmod_analog/    ftmod_isdn/     ftmod_pika/      ftmod_sangoma_isdn/   ftmod_wanpipe/
ftmod_analog_em/  ftmod_libpri/   ftmod_pritap/     ftmod_sangoma_ss7/     ftmod_zt/
ftmod_gsm/      ftmod_misdn/   ftmod_r2/       ftmod_skel/
```

上面列出的这些子模块基本上可以分为两种——信令模块和IO模块。其中前者主要负责通话的建立和释放（如ftmod_isdn），类似于我们已经熟悉的SIP；而后者主要负责话音数据的输入输出（如ftmod_wanpipe），类似于我们熟悉的RTP。

在IO层，FreeTDM可以有两种工作模式，一种是DAHDI模式，它是由ftmod_zt驱动的，主要兼容DAHDI及Zaptel协议的板卡；另一种为Wanpipe模式，主要用于Sangoma生产的板卡。这里我们以Sangoma板卡为例来进行说明，因此，主要讲解Wanpipe模式。

关于Sangoma板卡的安装，涉及编译内核、安装各种驱动程序，以及进行各种配置等，操作起来比较复杂。下面的内容假定已经安装好了板卡及驱动。

2. 安装和配置mod_freetdm

只有正确安装了Wanpipe及ISDN信令协议后才能在编译mod_freetdm时正确编译相关的模块。因此，需要确保上述步骤成功才能执行这一步。
跟安装其他模块类似，在FreeSWITCH源码目录直接执行以下命令就可以完成mod_freetdm的安装：

```
# make mod_freetdm

# make mod_freetdm-install
```

安装过程中安装脚本可以自动找到相应的驱动程序，并配置安装相关的FreeTDM子模块。
安装完成之后，可以在FreeSWITCH的conf目录中找到两个与FreeTDM相关的文件。其中，conf/freetdm.conf为FreeTDM的配置文件，内容如下：

```
[span wanpipe wp1]
trunk_type => e1
group=1
b-channel => 1:1-15
b-channel => 1:17-31
d-channel => 1:16
```

该配置文件的格式是类似于Windows中“.ini”文件的配置格式。其中第1行配置了一个Span，一个Span相当于板卡上的一个E1端口，它的类型是wanpipe，名称是wp1；trunk_type即中继的类型，这里是e1；group表示一个组号；该E1板卡上共有32个时隙（又称信道，即Channel），其中0时隙是传时钟同步的，在这里没有列出，16时隙为D信道（传信令），其他的30个时隙为B信道（传话音）。

另一个配置文件是mod_freetdm的模块配置文件，它位于conf/autoload_configs/freetdm.conf.xml。具体内容我们就不详细列举了，其中一部分如下：

```xml
<sangoma_pri_spans>
  <span name="wp1" cfgprofile="my_pri_nt_1">
    <param name="dialplan" value="XML"/>
    <param name="context" value="default"/>
    </span>
</sangoma_pri_spans>
```

其中，它定义了一个Span，名称wp1是与freetdm.conf中的Span的名字相对应的。并且，里面还定义了Dialplan和Context，用于对该E1中继的来话进行路由。

当然，读者可以发现这些配置的值都是我们在安装驱动时的配置向导生成的。后面也可以手工更改并重新加载。
确保wanrouter已经启动，然后就可以在FreeSWITCH控制台上使用如下命令加载mod_freetdm了：

```
freeswitch> load mod_freetdm
+OK Reloading XML
+OK
```

至此，安装的工作已经完成，并且看起来mod_freetdm也加载成功了。

加载mod_freetdm之后，可以在FreeSWITCH控制台上使用模块提供的ftdm命令查看E1板卡及各Span和Channel的状态，比如，使用以下命令列出当前系统配置的所有Span：

```
freeswitch> ftdm list
+OK
span: 1 (wp1)
type: Sangoma (ISDN)
physical_status: alarmed
signaling_status: DOWN
chan_count: 31
dialplan: XML
context: default
dial_regex:
fail_dial_regex:
hold_music:
analog_options: none
```

从上面的输出可以看到，我们只有一个Span（wp1），它的物理状态（physical_status）是alarmed（警告），信令状态（signaling_status）是DOWN，这意味着未连接。

如果这时候插入自环电缆，则可以看到FreeSWITCH控制台上会输出好多DEBUG级别的日志信息，标志状态的变化。重复上述命令会看到物理状态变成ok，但是信令状态仍然是DOWN（因为自环只能模拟一个“对端设备”，可以模拟物理连接的情况，无法与“对端”建立信令连接）。插入自环电缆后查看状态的输出如下：

```
freeswitch@ubuntu32> ftdm list
+OK
span: 1 (wp1)
type: Sangoma (ISDN)
physical_status: ok
signaling_status: DOWN
chan_count: 31
dialplan: XML
context: default
dial_regex:
fail_dial_regex:
hold_music:
analog_options: none
```

另外，也可以使用“ftdm dump”命令显示实际的Span中指定的时际的状态信息，如：

```
freeswitch> ftdm dump 1 1
+OK
span_id: 1
chan_id: 1
physical_span_id: 1
physical_chan_id: 1
physical_status: ok
physical_status_red: 0
physical_status_yellow: 0
physical_status_rai: 0
physical_status_blue: 0
physical_status_ais: 0
physical_status_general: 0
signaling_status: DOWN
type: B
state: DOWN
last_state: DOWN
txgain: 0.00
rxgain: 0.00
cid_date:
cid_name:
cid_num:
ani:
aniII:
dnis:
rdnis:
cause: NONE
session: (none)
```

“ftdm dump”命令可以将当前Span和Channel的状态显示输出，上面的例子中后面两个参数分别是Span号和Channel号。当然，如果省略Channel号，则会dump整个Span里面所有的Channel。

3. 配置电话路由

虽然我们还没有与其他系统对接，但这里我们先把来、去话的路由准备好，等对端的设备准备好以后就可以直接打电话进行测试了。

注意，这里说的“来、去”的概念都是相对的——一路通话，对于一端来说是来话，对于另一端来说就是去话。我们这里涉及的设备比较多，因而一定要想清楚来话和去话是针对哪个设备来说的。

在FS1上，对于从E1上的来话而言，由于我们上面已经指定了将来话路由到XML Dialplan的default Context中，因此暂时不需要任何设置。
对于去话，我们在default Context中配置以下Dialplan，让本地用户在拨打以0开头的电话号码时将电话从E1端口上送出去。Dialplan的内容如下：

```xml
<extension name="E1">
    <condition field="destination_number" expression="^0(.*)$">
        <action application="bridge" data="freetdm/1/a/$1"/>
    </condition>
</extension>
```

其中，正则表达式“0(.*)”表示匹配所有以被叫号码0开头的通话。如果匹配，则将实际的电话号码存储到“\$1”变量中（不包括0）。然后，执行后续的Action。这里的Action只有一个bridge。其中，bridge是一个App，对此我们大家都很熟悉了。后面的freetdm为mod_freetdm提供的呼叫字符串，各参数是以“/”分隔的，其中freetdm为Endpoint的类型，后面的参数含义如下：

- “1”代表第一个Span [6]。我们在这里只有一个Span。
- “a”代表选线规则。其中，小写的“a”表示从小到大选择一个空闲的时隙（Channel）并将电话送出，大写的“A”表示从大到小选择一个空闲时隙。注意如果双方同时选择一个时隙，将会发生“撞车”的现象。为了最大限度避免这种碰撞，相互对接的双方可以从不同的方向优先选择时隙。当然，如果真发生了“撞车”，也有相关机制保证有一方会自动放弃并选择下一个可用的时隙。
- “\$1”表示实际送出的被叫电话号码。其中，从Dialplan的正则表达式中可以看到，“$1”的值中是不包括“0”的，即如果FS1上的用户拨叫了01000，实际送到E1线路上的被叫号码将是1000。这是一种常见的做法，通俗的说法就是在电话路由的时候“吃”掉前面的第一个“0”。

至此，FS1上的配置就结束了。我们再来看其他设备的配置。

### 配置E1网关设备

在这里，我们以鼎信通达的E1网关MTG1000为例。MTG1000是一款E1转SIP的网关设备（它只是完成E1/SIP话路的信令转换和路由，因此，我们还需要另外一个SIP服务器FS2才能完成通话测试）。

在进行下一步的测试之前，先使用E1交叉线将MTG1000和Sangoma A101连接起来。

该设备默认有两个以太网口。其中，网口0的默认地址是192.168.1.111，用于与其他SIP设备对接；网口1的默认地址是11.11.11.11，一般用于连接笔记本电脑以便对设备进行管理。

1. 添加PRI中继

打开浏览器，进入管理界面，选择添加一个PRI中继，如图14-8所示。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-057855.png)

<center>图14-8　添加PRI中继</center>

其中，中继编号使用默认的“0”；中继名称可以为“FS-ISDN”；接口标志符使用“0”；D通道选择“启用”；E1/T1端口号使用默认的“0”；协议类型选择“ISDN”（与我们FS1中的EuroISDN对应）；接口属性选择“设备侧”（与FS1中的相对，对方应该选择NET，即网络侧）；其他选项可以使用默认值。

单击“确定”按钮后保存设置。然后可以转到状态页面查看E1中继端口的状态。如图14-9所示，如果看到端口状态变成绿色的（状态是Actived）则表示链路正常了。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-071854.png)

<center>图14-9　E1中继状态</center>

这时候也可以在FS1中使用ftdm list和ftdm dump等命令检测链路的状态。

2. 添加SIP中继

与PRI中继相对应，在MTG1000中，与我们的SIP服务器FS2相连的SIP链路称为SIP中继。

如图14-10所示。在管理界面上选择添加SIP中继，中继编码使用默认的0；中继名称为FS-SIP；对端地址输入我们FS2的IP地址，在这里是192.168.1.119；对端端口使用5080，以防止对该网关设备进行鉴权，简化配置。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-086854.png)

<center>图14-10　添加SIP中继</center>

其他的配置选项都使用默认的配置即可。单击“确定”按钮保存配置。

3. 添加路由

有了E1中继和SIP中继，该网关的作用就是把这些中继串起来。而这种“串”就是靠MTG1000的由路功能实现的。

首先，我们添加一条路由，将从E1端口进来的通话路由到SIP中继上去。在MTG1000的管理界面上选择添加PSTN-IP路由，如图14-11所示。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-101863.png)

<center>图14-11　添加PSTN到SIP路由</center>

其中，索引号使用默认的255；路由描述中我们填上“ISDN-IP”；来源类型选择“中继”；PSTN中继选择我们刚刚创建的“0”；被叫号码前缀填入“1”，即从该E1线路进来的，而且被叫号码为1的电话将走这一条路由；主叫号码前缀由于我们不关心，这里可以填入“.”以接受任意主叫号码；目的类型选择“中继”；中继类型选择“SIP”；IP中继编号即我们刚刚创建的SIP中继“0”；其他参数使用默认值。

上面的配置的目的就是，从E1来的呼叫若满足一定的主、被叫号码规则，则路由到一条SIP中继上去。

用类似的方法可以配置一条SIP到E1的中继，让从SIP侧过来的通话能送到E1上去。如图14-12所示，参数的含义与上面的类似，在这里就不多介绍了。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-116855.png)

<center>图14-12　添加SIP到PSTN路由</center>

### 配置FS2

在FS2侧，对于来话而言，由于MTG1000将电话路由到了5080端口，因此来话将进入public Dialplan，而public Dialplan已经有默认的Dialplan可以将电话路由到本地用户了。

对于去话而言，则需要把MTG1000也看成一个网关，在FS2上配置一个网关并将电话路由到该网关即可。或者直接在default Dialplan中使用如下配置将去话送到MTG1000所在的IP地址上：

```xml
<extension name="MTG1000">
    <condition field="destination_number" expression="^0(.*)$">
        <action application="bridge" data="sofia/external/$1@192.168.1.111"/>
    </condition>
</extension>
```

其中，192.168.1.111为MTG1000的IP。

1. 拨打测试

我们上面配置了FS1、MTG1000网关及FS2，下面可以进行拨打测试了。如果FS1上的用户1000想呼叫FS2上的用户1001，则拨打0加上对方的号码，如01001；电话在FS1上进行路由时被叫号码最前面的0会被Dialplan“吃”掉，并将剩下的1001送到E1中继网关MTG1000上；MTG1000在收到来自E1中继的来话后，查找本地的路由表，并将该电话送到配置好的SIP中继上，实际上就是送到我们的FS2的5080端口上；FS2在5080端口上接收到来话后，即查找本public Dialplan，将最终向本地用户1000振铃，1000接起电话后就可以进行通话了。呼叫流程如图14-13所示。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-131856.png)

<center>图14-13　呼叫流程</center>

反过来从FS2到FS1的通话流程跟上面差不多，读者可以自行推演。

通话过程中，读者也可以使用“ftdm dump”命令查看当前Span的占用状态。如：

```
freeswitch> ftdm dump 1 5
span_id: 1
chan_id: 5
physical_span_id: 1
physical_chan_id: 5
physical_status: ok
physical_status_red: 0
physical_status_yellow: 0
physical_status_rai: 0
physical_status_blue: 0
physical_status_ais: 0
physical_status_general: 0
signaling_status: UP
type: B
state: UP
last_state: PROCEED
txgain: 0.00
rxgain: 0.00
cid_date:
cid_name:
cid_num: 1000
ani: 1000
aniII:
dnis: 1001
rdnis:
cause: NONE
session: c854e884-1c97-11e3-befe-0f1ace9d0d7b
-- States --          -- Function --             -- Location --        -- Time Offset --
DOWN  => RING    [sngisdn_process_con_ind]   [ftmod_sangoma_isdn_stack_hndl] 0ms
RING  => PROCEED [channel_on_routing]        [mod_freetdm.c:456]             5ms
PROCEED => UP    [channel_receive_message_b] [mod_freetdm.c:991]             10ms
Time since last state change: 91886ms
```

如果在测试的过程中，出现电话不通的情况，那么很可能是配置的时候漏掉了某些地方或写错了某些参数，最好的解决办法是按这里的描述再重新检查一遍所有的配置，根据界面上（见图14-9）的状态指示检查链路和端口状态。如果还是有问题，则复习一下我们在第10章里讲的排错方法，应该很容易就能找到问题。

2. 指定中继拨打

在实际应用中，有时需要经常测试某条线路的好坏。而如果使用出局路由自动选线的方式选择到的某一条中继或时隙可能是未知的。所以我们需要一种方法能测试指定选择的某条中继或时隙，这种测试方法就称为指定中继拨打。

我们先来看如下的freetdm呼叫字符串，在这里不使用“a”或“A”的选线方式，而是直接指定从某个时隙呼出，如：

```
freeswitch> originate freetdm/1/5/1000 &echo
+OK c854e884-1c97-11e3-befe-0f1ace9d0d7b
```

上述命令从第一个Span的第5个时隙呼出，并在本端执行echo，对端接听后可以听到自己的回声。

如果我们不挂机再重复执行一次，可以看到由于该时隙已被占用，并返回拥塞消息NORMAL_CIRCUIT_CONGESTION：

```
freeswitch> originate freetdm/1/5/1000 &echo
-ERR NORMAL_CIRCUIT_CONGESTION
```

了解了上述方法以后，我们可以设置以下Dialplan进行指定中继拨打。

```xml
<extension name="Dial specific trunk">
    <condition field="destination_number" expression="^\*22([0-9])([0-9])(.*)$">
        <action application="bridge" data="freetdm/$1/$2/$3"/>
    </condition>
</extension>
```

其中，正则表达式为“^\*22([0-9])([0-9])(.\*)\$”。如果我们呼叫“*22151000”，则它与正则表达式匹配。其中，“*22”相当于我们指定中继拨打的功能码；接下来的1匹配第一个括号里的“[0-9]”，被记到变量“\$1”中；同理，“5”被记到变量“\$2”中；后面的“1000”被记到变量“\$3”中。因此，最后呼叫字符串“freetdm/$1/$2/\$3”将变成“freetdm/1/5/1000”，即从第一个Span的第5个时隙呼出。

如果我们想从第6个时隙呼出，则可以呼叫“*22161000”。通过这种方法，可以呼叫任意的时隙 [7]，这便是指定中继拨打的含义。

### 对接其他厂家的E1网关

作为一个对比，我们也来看一下与迅时E1数字网关的对接。这里我们使用的设备型号是MX100-TG。其中FS1与FS2的配置保持不变。在MX100-TG上，我们也需要与14.4.2节描述的一样——设置ISDN和SIP侧的参数、添加双向的路由等。不过，后面我们可以看到，迅时网关的配置步骤比较简洁。

1. ISDN设置

MX100-TG的配置界面与MX8类似。打开浏览器，进入管理界面，选择ISDN，便看到如图14-14所示的配置界面。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-162856.png)

<center>图14-14　添加ISDN中继</center>

其中，ISDN链路的名称我们可以为FS-ISDN；收号方式选择默认的整体收号；D通道选择默认的16时隙；接口协议选择默认的用户侧（与FS1中的相对，对方应该选择NET，即网络侧）；信令标准选择默认的CCITT；选线方式可以选择默认的顺序，也可以选择其他的选线方式；其他选项可以使用默认值。

单击“提交”按钮后保存设置，设置即可生效。如果一切正常，则E1链路就会变成正常的连通状态，在图14-14所示的界面上也能观察到。

2. 路由设置

迅时系列的网关，可以直接将SIP通话路由到IP，因而不需要设置明确的SIP中继。为了能让FS1与FS2之间互打，我们只需简单地设置以下两条路由：

```
ISDN      x       ROUTE      IP       192.168.1.119:5080
IP        x       ROUTE      ISDN     1
```

其中，第一条与在模拟网关MX8中的设置类似，即所有从ISDN侧来的呼叫，不管被叫号码是什么，全部（通过SIP）路由到FS2的IP地址上去（192.168.1.119:5080）；而第二条也很容易理解，即所有从IP侧来的SIP呼叫，全部路由到第1条ISDN链路（E1）上去（如果有多个E1的话，也可以使用类似模拟线的配置方式，如“1,2,3,4”选择不同的E1链路）。

[1] 设备之间对接需要使用E1交叉线。E1线由4条线组成，其中2条是收（接收），2条是发（发送）。交叉线的含义就是一端的“收”要接到对端的“发”上。物理接口一般有两种，一种是RJ48（物理上跟RJ45相同，只是线序不同）双绞线接口，阻抗为120Ω；另一种是同轴电缆接口，阻抗是75Ω。也有在这两种物理接口转换的适配电缆。 

[2] Zaptel指Jim Dixon的开放电脑电话硬件驱动API，后来Digium公司生产了相关的板卡并改进了该API。参见http://www.voip-info.org/wiki/view/Zaptel

[3] 注意，该模块的源代码不在src/mod目录下，而是在libs/openzap目录下。 

[4] DAHDI即Digium Asterisk Hardware Device Interface的缩写。由于注册商标问题，Zaptel于2008年更名为DAHDI。参见http://blogs.digium.com/2008/05/19/zaptel-project-being-renamed-to-dahdi/。 

[5] 为了与FreeSWITCH中的模块相区别，我们在这里称FreeTDM的模块为“子模块”。 

[6] 在主机上装有多个Span的情况下，也可以将任意的时隙在逻辑上组成一个分组，因此这里也可以填入一个组名。一个分组可以跨越多个Span，在这里就不多介绍了，有兴趣的读者可以参见http://wiki.freeswitch.org/wiki/FreeTDM。 

[7] 实际上，这里的Dialplan不支持呼叫2位数的时隙，读者可以自已练习一下，看能否通过所学的知识自己实现。

## 对接Asterisk

Asterisk是老牌的开源VoIP软件。事实上，FreeSWITCH的作者Anthony Minessale在早些年也是Asterisk的开发者，后来由于对Asterisk的架构设计和性能问题有意见，提议开发了一个新的Asterisk分支，但是开发新分支的想法却未得到Asterisk社区主要负责人的支持，因此便从头开发了FreeSWITCH [1]。

由于Asterisk比FreeSWITCH资格老，因此在国内有大量的用户群，在很多情况下都需要与FreeSWITCH进行对接。因此，这里我们也来看一下Asterisk与FreeSWITCH对接的例子。

在本例中，我们仅使用中继方式（在Asterisk中称为peer，即对等的连接方式）与Asterisk进行对接，其他的对接方式如相互向对方注册等留给读者练习。我们假定读者已经熟悉Asterisk。先在Asterisk上添加一个分机6000，并用一个SIP客户端注册上去，为下面的测试做准备。另外，下面的测试中FreeSWITCH的IP地址为192.168.7.5，而Asterisk的IP地址为192.168.7.99。

### 从FreeSWITCH呼叫Asterisk

首先，我们已经很熟悉如何在FreeSWITCH中将电话送出，通过使用下列命令可以呼叫Asterisk上的6000：

```
freeswitch> originate sofia/external/6000@192.168.7.99 &echo
```

或者，使用如下的Dialplan，当FreeSWITCH上的用户拨打6000时，也可以送到Asterisk上：

```
<action application="bridge" data="sofia/external/6000@192.168.7.99"/>
```

呼叫到达Asterisk上后，就可以在Asterisk的控制台上看到类似如下的日志：

```
NOTICE[3684][C-0000000d]: chan_sip.c:25381 handle_request_invite:
Call from '' (192.168.7.5:5080) to extension '6000' rejected
    because extension not found in context 'public'.
```

出现上述提示的原因是我们没有在Asterisk上配置入局路由，因而我们的呼叫被拒绝（rejected）了。接下来，我们只需打开Asterisk的配置文件extension.conf，在public Context中增加如下的设置就可以了。

```
exten => 6000,1,Dial(SIP/6000)
```

其中，“6000”匹配被叫号码；“1”是一个优先级标志；“Dial”是一个Application，类似FreeSWITCH中的bridge；最后“SIP/6000”是一个呼叫字符串。

在Asterisk的控制台上使用dialplan reload命令使用之生效，然后，再一次在FreeSWITCH中发起呼叫，Asterisk上的分机6000就可以振铃了。

### 从Asterisk上呼叫FreeSWITCH

我们也可以很容易在Asterisk中使用如下Dialplan将电话送到FreeSWITCH上。

```
exten=>_01X.,1,Dial(SIP/${EXTEN:1}@192.168.7.5:5080)
```

其中，“_01X.”是Asterisk中的模式匹配规则，它匹配以“01”开头的被叫号码；“1”为优先级标志；而后面的Dial相当于FreeSWITCH中的bridge App；再后面是一个以SIP开头的呼叫字符串；“\${EXTEN}”即模式匹配中的被叫号码，而“\$​{EXTEN:1}”即去掉最前面的一位（即“吃掉0”），然后把剩下的号码作为被叫号码并将呼叫送到FreeSWITCH的地址192.168.7.5:5080上去。

因此，使用上述Dialplan在Asterisk上使用分机6000呼叫号码01000时，Asterisk就会“吃”掉被叫号码中最前面的“0”，并将呼叫送达FreeSWITCH，然后FreeSWITCH上的分机1000就会振铃。

上述呼叫在FreeSWITCH中能够正确路由是因为FreeSWITCH中默认的publicDialplan包含了到用户1000的路由。当然，如果是呼叫其他号码，则也可以根据实际情况在FreeSWITCH中配置相关的入局路由。

### 其他

在上面的例子中，我们仅介绍了使用中继对接的最简单的情形。电话是可以呼通了，但出于用于生产环境中的安全性考虑，就需使用账号或IP地址对来话进行验证了，这部分内容就留给读者自行练习了。当然，读者也可以参考以下Wiki页面上的对接说明https://wiki.freeswitch.org/wiki/Connecting_Freeswitch_and_Asterisk。

另外，从上面的例子可以看出，在Asterisk与FreeSWITCH中的用户及路由的配置概念都是很类似的。如果用户熟悉Asterisk，则FreeSWITCH也应该很快能上手。Wiki页面http://wiki.freeswitch.org/wiki/Rosetta_Stone对两者相似的概念进行了对比，对于刚刚从Asterisk转到FreeSWITCH的读者来说，读一读或有帮助。

最后，关于Asterisk和FreeSWITCH的关系，我们来看一下Anthony Minessale在2009年接受媒体采访时的一段对话 [2]：

```
媒体：如果有人想把他或她的Asterisk系统换成FreeSWITCH，是否需要编写很多的代码以及学习完全不同的配置文件语法？

Anthony：并不像你想象的那么难。理解FreeSWITCH最关键的地方有一个它与Asterisk之间的词形变化表。事实上，它们之间有很多相似的地方，如它们都使用可加载模块、都使用“application”执行相应的功能等。不同的，同时也是对学习FreeSWITCH、至关重要的一点是，其尝试最大程度地去除一切复杂性，我们可从一个简单的角度看待Free SWITCH。很多从Asterisk转移过来的FreeSWITCH新手往往由于想得太多而把问题搞得很复杂。实际上我们无比强大的社区成员已经写了一个名为“Asterisk罗塞塔石碑 [3]”的Wiki页面 [4]，该页面非常好地解释了从Asterisk转到FreeSWITCH的各种概念和要素。另外，我们也有一个模块 [5]允许你使用你熟悉的Asterisk的语法写Dialplan进行电话路由。
```

[1] 在此，笔者只是陈述一个事实，并无意将两者对立起来。其实，Asterisk的新版本在近几年性能也有了很大的提升。并且，在市场上有很多成熟的应用，很多用户也将会长期使用Asterisk，这也是笔者写这一节的原因之一。Anthony Minessale在2010年接受VOIPToday采访并被问及FreeSWITCH与其他“竞争者”的关系时也说过：这并不是一个FreeSWITCH必须“打败”Asterisk才能“胜利”的公认的所谓的“零和游戏”，在很多情况下人们都会把FreeSWITCH用作他们已有的Asterisk、CallWeaver、YATE安装部署的一部分…… 

[2] 来自http://www.888voip.com/interview-with-anthony-minessale-from-freeswitch/。 

[3] Rosetta Stone，是一块刻有古埃及法老托勒密五世（Ptolemy V）诏书的石碑。由于这块石碑同时刻有同一段内容的三种不同语言版本，使得近代的考古学家得以有机会对照各语言版本的内容，解读出已经失传千余年的埃及象形文字的意义与结构。参见：http://zh.wikipedia.org/wiki/罗塞塔石碑。——笔者（译者）注 

[4] 参见http://wiki.freeswitch.org/wiki/Rosetta_stone。 

[5] 指mod_dialplan_asterisk。——笔者（译者）注。

## 使用H.323协议对接

H.323是比较古老的VoIP协议，然而现在还是有很多设备支持该协议。作为一款多协议的VoIP系统，FreeSWITCH也支持H.323。下面我们就来简单讨论一下如何在FreeSWITCH中使用H.323。

FreeSWITCH中有两个H.323的实现——mod_opal [1]和mod_h323 [2]。前者基于H323plus库 [3]，后者基于Opal [4]库，两个库又都依赖于ptlib [5]。

### mod_h323

我们先来看mod_h323。下面我们将讨论如何对mod_h323进行安装、配置和拨打测试。

1. 安装

在安装mod_h323之前，首先要安装它依赖的库。这里需要注意的问题是，mod_h323依赖的两个库ptlib和h323plus需要特定的版本配合在一起才能正常工作。该模块对应的Wiki页面上有几个特定的组合列表。这里笔者使用的是h323plus官方网站上最新的组合。

笔者是在Ubuntu Linux 12.04上进行测试的，在编译上述两个库之前，要确保系统上有flex和bison两个软件。可以用如下命令安装它们：

```
# apt-get install flex bison
```

然后，使用如下命令下载ptlib和h323plus：

```
wget http://www.h323plus.org/source/download/ptlib-2.10.9.tar.bz2
wget http://www.h323plus.org/source/download/h323plus-v1_25_0.tar.gz
```

解压并配置安装ptlib：

```
# tar xvjf ptlib-2.10.9.tar.bz2

# cd ptlib-2.10.9

# ./configure && make && make install
```

解压并配置安装h323plus：

```
# tar xvzf h323plus-v1_25_0.tar.gz

# cd h323plus

# ./configure && make
```

在make过程中，笔者遇到以下错误：

```
/home/app/book/h323/h323plus/include/openh323buildopts.h:37:34:
fatal error: ptlib/../../revision.h: No such file or directory
```

为了解决该问题，笔者修改了对应的文件（h323plus/include/openh323buildopts.h”），将第37行的“#include<ptlib/../../revision.h>”一行注释掉（或删除）。然后，继续配置安装：

```
# make && make install
```

上述两个库安装完毕后，到FreeSWITCH的源代码目录下安装mod_h323。由于我们上面的步骤中两个库的安装位置都在/usr/local目录下，因此我们需要改变mod_h323的Makefile（src/mod/endpoint/mod_h323/Makefile），将里面所在的“/usr”路径都替换为“/usr/local”。修改完毕后，就可以在FreeSWITCH源代码目录中使用如下命令安装了：

```
# make mod_h323-install
```

或者，进入mod_h323源代码目录上，使用如下命令安装：

```
# cd src/mod/endpoint/mod_h323

# make install
```

2. 配置和加载模块

安装完毕后，如果一切正常，就可以在FreeSWITCH中加载该模块了：

```
freeswitch> load mod_h323
```

如果在加载时遇到类似下面这样的错误，可以在Linux命令行上执行“ldconfig”，然后重启FreeSWITCH。

```
**libh323_linux_x86_64_.so.1.25.0: cannot open shared object file:
No such file or directory
```

如果在加载模块时看到如下的错误，则说明FreeSWITCH默认没有安装相关的配置文件。

```
[ERR] mod_h323.cpp:483 open of h323.conf failed
```

可以在mod_h323源代码目录中找到h323.conf.xml，然后复制到conf/autoload_configs/目录中，如：

```
# cd src/mod/endpoint/mod_h323

# cp h323.conf.xml /usr/local/freeswitch/conf/autoload_configs/
```

然后再重新加载该模块就可以了：

```
freeswitch> load mod_h323
```

3. 呼叫测试

在正确加载完mod_h323以后，就可以进行拨打测试了。目前，该模块仅支持点对点的模式互通，并不支持Gatekeeper。因此，可以在大部分的H.323客户端上直接呼叫FreeSWITCH的IP地址。呼叫到达FreeSWITCH后，将按照h323.conf.xml中的配置进行路由。当然，有些客户端允许在呼叫的IP地址前面加一个被叫号码，如可以尝试呼叫“1000@192.168.7.5”或“1000@192.168.7.5:1720”等。

如果在FreeSWITCH中使用mod_h323呼出，可以使用如下Dialplan：

```xml
<action application="bridge" data="h323/6000@192.168.7.9"/>
```

其中，“h323”是该模块实现的一个呼叫字符串，后面的地址是欲呼叫的对端的IP地址。

### mod_opal

mod_opal的安装步骤与mod_h323类似，它也是需要一对相互匹配的opal库与ptlib库。在测试时，笔者是如下地址http://sourceforge.net/projects/opalvoip/files/v3.12%20Eridani/Stable%206/下载的ptlib-2.12.6.tar.bz2以及opal-3.12.6.tar.bz2。

ptlib的安装方法与在mod_h323中的类似，在此就不多说了。只是注意，如果同时在一台主机上安装两个版本的ptlib可能会有冲突，如何在同一台主机上安装并运行不同版本的库文件超出了本书的范围，如果你对这些不熟悉的话，请分别在两台“干净”的机器上分别测试mod_h323与mod_opal。

接下来，使用以下命令安装Opal：

```
# tar xvjf opal-3.12.6.tar.bz2

# cd opal-3.12.6

# ./configure && make && make install
```

在FreeSWITCH源代码目录下使用如下命令安装mod_opal：

```
# cd src/mod/endpoint/mod_opal

# make install
```

笔者在编译时遇到如下错误：

```
/home/app/work/freeswitch/src/mod/endpoints/mod_opal/mod_opal.cpp:1034:37:
error: 
‘class OpalConnection
’ has no member named 
‘SwitchT38
’
```

错误的原因是mod_opal跟这里Opal的版本不兼容。不过，T38是与传真相关的，这里，我们不测试传真，所以，可以在mod_opal.h文件中找到如下的行：

```
#define HAVE_T38 (OPAL_CHECK_VERSION(3,11,2) && OPAL_T38_CAPABILITY)
```

并将其修改为：

```
#define HAVE_T38 0
```

即暂时取消与T38相关的宏定义。然后就可以继续编译安装了。

安装完成后，在FreeSWITCH中加载：

```
freeswitch> load mod_opal
```

然后，如果有电话呼入，则可以在FreeSWITCH中看到日志。一旦呼叫到达了Dialplan，就是我们的天下了。通过前面学过的知识，如何配置Dialplan对来话进行路由对我们来说已是小菜一碟了。因此，在此就不多介绍了。

另外，如果使用mod_opal呼出的话，它提供了Opal呼叫字符串，因而可以使用如下Dialplan进行呼出：

```xml
<action application="bridge" data="opal/h323:1000@192.168.7.9"/>
```

其中，“192.168.7.9”是指对端的IP地址。

### 其他

上面我们重点讲了H.323中两个模块的安装，因为该过程的复杂性往往是读者学习和实验这两个模块的门槛。这里笔者是仅仅做了几个实验。如果读者想将这两个模块用于生产环境的话，还需要多测试一下，找一找这几个依赖库的最佳组合。

由于使用H.323的人比较少，因而大家对这两个模块开发的积极性也不高，因而它们的功能也不是很完善。如它们并不支持视频呼叫，也不支持使用Gatekeeper方式注册。不过，如果需要Gatekeeper的环境，也可以考虑与GnuGK [6]等专门的H.323 Gatekeeper配合部署，在此我们就不多讲了。

另外，笔者正在尝试重新写一个H.323模块——mod_ooh323，以支持视频通话。不过，该模块还没写好，暂时就不能写到书里了（等你看到本书时或许已经有了）。

[1] 参考http://wiki.freeswitch.org/wiki/Mod_opal。 

[2] 参考http://wiki.freeswitch.org/wiki/Mod_h323。 

[3] 参考http://www.h323plus.org/。 

[4] 参考http://www.opalvoip.org/。 

[5] ptlib是一个底层的支持库，提供一些抽象和跨平台的支持。真正的历史是这样的：所有这些都起源于一个开源的项目OpenH323，后来，分离成了两个项目Opal和H323plus，底层的一些抽象及跨平台支持也几乎在同时成了独立的库，叫PWlib，后改名为ptlib。 

[6] GnuGK是一款开源的H.323 Gatekeeper，请参考http://www.gnugk.org/。

## 小结

本章主要讲了使用不同的协议跟各种其他的设备进行对接。首先，本章通过Dougango和IMS的例子，帮读者扩充了SIP注册及对接的一些基础知识，并逐渐过渡到与TDM设备的对接上。

与TDM设备的对接，有板卡方案和网关方案。本章使用市场上常见的设备给出了实际的例子，并且用了很大的篇幅讲了Sangoma板卡及驱动的安装和配置。

后面，我们也讲到了与Asterisk的对接方法，并将Asterisk中的一些基本概念和模型与FreeSWITCH做了比较。

在本章最后，我们还讲了FreeSWITCH中H.323的实现、与H.323设备的对接，以及在编译安装时需要注意的问题。

一个人可能永远也不会用到这里讲的所有的设备或协议。但笔者希望读者能通过这些不同的例子，进行对比和思考，以对FreeSWITCH的运行方式、配置方法、设计理念、软硬件配合，以及通信设备的网络拓扑及部署方式有更好的理解。

