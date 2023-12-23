# 第01章 PSTN与VoIP基础
# 第02章 PSTN、PBX及呼叫中心业务
# 第03章 初识FreeSWITCH
# 第04章 运行FreeSWITCH

在对FreeSWITCH有了一个初步的了解后，各位读者可能已经迫切地想实验它强大的功能了。从这一章起，我们就从最初的运行开始，一步一步进入FreeSWITCH的神秘世界。

## 命令行参数

一般来说，FreeSWITCH不需要任何命令行参数就可以启动，但在某些情况下，你需要以一些特殊的参数启动。在此，仅作简单介绍。使用freeswitch-h或freeswitch-help或freeswitch--help会显示以下信息（其中中文部分是作者加的注释）：

```
# freeswitch -help

Usage: freeswitch [OPTIONS]
These are the optional arguments you can pass to freeswitch:
-nf                    -- 不允许Fork新进程
-u [user]              -- 启动后以非 root 用户 user 身份运行
-g [group]             -- 启动后以非 root 组 group 身份运行
-help                  -- 显示本帮助信息
-version               -- 显示版本信息
-waste                 -- 允许浪费内存地址空间，FreeSWITCH仅需240KB的栈空间，你可以使用 ulimit -s 240 限制栈空间使用，或使用该选项忽略警告信息
-core                  -- 出错时进行内核转储
-rp                    -- 开启高优先级（实时）设置
-lp                    -- 开启低优先级设置
-np                    -- 普通优先级
-vg                    -- 在 valgrind 下运行，调试内存泄露时使用
-nosql                 -- 不使用SQL，show channels 类的命令将不能显示结果
-heavy-timer           -- 更精确的时钟。可能会更精确，但对系统要求更高
-nonat                 -- 如果路由器支持uPnP或NAT-PMP，则FreeSWITCH可以自动解决NAT穿越问题。如果路由器不支持，则该选项可以使启动更快
-nocal                 -- 关闭时钟核准。FreeSWITCH理想的运行环境是1000Hz 的内核时钟。如果你的内核时钟小于1000Hz 或在虚拟机上，可以尝试关闭该选项
-nort                  -- 关闭实时时钟
-stop                  -- 关闭 FreeSWITCH，它会在run目录中查找 PID文件
-nc                    -- 启动到后台模式，没有控制台
-ncwait                -- 后台模式，等待系统完全初始化完毕之后再退出父进程，隐含“-nc”选项
-c                     -- 启动到控制台，默认Options to  control location of files:
-base [confdir]        -- 指定其他的基准目录，在配置文件中使用$${base}
-conf [confdir]        -- 指定其他的配置文件所在目录，须与 -log、 -db 合用
-log [logdir]          -- 指定其他的日志目录
-run [rundir]          -- 指定其他存放 PID 文件的运行目录
-db [dbdir]            -- 指定其他数据库目录
-mod [moddir]          -- 指定其他模块目录
-htdocs [htdocsdir]    -- 指定其他 HTTP 根目录
-scripts [scriptsdir]  -- 指定其他脚本目录
-temp [directory]      -- 指定其他临时文件目录
-grammar [directory]   -- 指定其他语法目录
-certs [directory]     -- 指定其他SSL证书路径
-recordings [directory]-- 指定其他录音目录
-storage [directory]   -- 指定其他存储目录（语音信箱等）
-sounds [directory]    -- 指定其他声音文件目录
```

虽然FreeSWITCH参数众多，但我们常用到的也没有几个。笔者经常用到两个参数，首先，就是将FreeSWITCH启动到后台的参数：

```
# freeswitch -nc
```

其次，FreeSWITCH在启动时默认会启用uPnP（或NAT-PMP）协议试图查找你的路由器是否支持并在你的路由器上“打洞”，如果你的路由器不支持该协议，这一步可能耗时较长，因而会影响启动速度。所以，如果你只是在内网测试并且像作者一样一天启动很多次的话，建议关掉这个选项。关于NAT的内容我们会在后面讲到。

```
# freeswitch –nonat
```

上面两个参数也可以组合来用：

```
# freeswitch –nc -nonat
```

## 　系统启动脚本

在学习调试阶段，你可以将FreeSWITCH启动到前台，而系统真正运行时，你可以使用“-nc”参数启动到后台，然后通过查看log/freeswitch.log跟踪系统运行情况 [1]。

一般情况下，将FreeSWITCH启动到前台更容易调试，但如果你又不想在每次关闭Terminal时停止FreeSWITCH，可以考虑借助screen [2]或tmux来实现。

在真正的生产系统上，一般需要FreeSWITCH能跟系统一起启动。在UNIX类系统上，启动脚本一般放在/etc/init.d/下。你可以在系统源代码目录下找到不同系统启动脚本debian/freeswitch.init及build/freeswitch.init.*，大家可以根据自己的需求和实际情况参考使用。在Windows上，你也可以将FreeSWITCH注册为Windows服务（使用“FreeswitchConsole-install”命令）。

[1] 你可以用“tail-f”命令实时跟踪，也可以使用“less+F”，或者在Windows平台上找一个叫wintail的软件。 

[2] screen是一个终端模块器，它允许在一个终端连接上打开很多虚拟终端，并且能保持终端会话，使用起来非常方便。详情参见http://wiki.freeswitch.org/wiki/Freeswitch_In_Screen。

## 判断FreeSWITCH是否运行

某些情况下，我们需要知道FreeSWITCH是否已经运行，在UNIX类系统上可以用下面的方法判断：

1）看进程是否存在。如果进程已经启动，下列命令能列出所有与FreeSWITCH相关的进程：

```
# ps aux | grep freeswitch
```

2）看相关端口是否被占用。假设你使用默认的5060端口，则使用下述命令可以列出所有与5060端口相关的网络连接：

```
# netstat -an | grep 5060
```

或者，在Linux平台上，能直接得到FreeSWITCH的进程号（需要root权限）：

```
# netstat -anp | grep 5060
```

Windows平台上也有netstat命令，但没有grep。进程信息可以通过按Ctrl+Alt+Del在程序管理器中查看。

## 　控制台与命令客户端

系统不带参数会启动到控制台，在控制台上可以输入各种命令以控制或查询FreeSWITCH的状态。可以尝试输入以下命令（注意，“--”后面是笔者加的注释，它们是相关命令的功能说明，不需要输入）：

```
version           -- 显示当前版本
status            -- 显示当前状态
sofia status       -- 显示 sofia 状态
help              -- 显示帮助
```

示例如下：

```
freeswitch> version
```

FreeSWITCH Version 1.5.2b+git~20130622T184626Z~a38ea77fa3 (git a38ea77 2013-06-22 18:46:26Z)

注：这里显示系统版本号为1.5.2b，后面更详细的信息说明git版库中对应的版本及提交时间

```
freeswitch> status
```

```
UP 0 years, 0 days, 12 hours, 23 minutes, 4 seconds, 711 milliseconds, 696 microseconds
FreeSWITCH (Version 1.5.2b git a38ea77 2013-06-22 18:46:26Z) is ready
7 session(s) since startup
0 session(s) - 0 out of max 30 per sec 
1000 session(s) max
min idle cpu 0.00/100.00
Current Stack Size/Max 240K/8192K
```

注：该命令显示系统状态。第1行说明系统启动了多长时间；第2行主要显示了版本号；第3行说明系统自启动以来已经处理了7个Session；第4行说明当前一个有多少Session，其中，“0 out of max 30 per sec”说明系统最大支持每秒钟处理30个Session（也就是通常所说的cps – Call Per Second，这个值可以在配置文件中更改），目前每秒的Session数为0；第5行说明系统最大允许多少个并发的Session（类似cps，该值也可以修改）；第6行显示最小及当前的空闲CPU；第7行显示当前使用的堆栈空间以及系统预留的堆栈地址空间。

为了调试方便，FreeSWITCH还在conf/autoload_configs/switch.conf.xml中定义了一些控制台快捷键。可以通过F1~F12这几个按键来使用它们（不过，在某些操作系统上，有些快捷键可能与操作系统相冲突，这时你就只能直接输入这些命令或重新定义它们了），也可以修改配置文件加入比较常用的命令（修改完毕后记着运行reloadxml命令使之生效），默认的配置如下：

```xml
<cli-keybindings>
    <key name="1" value="help"/>
    <key name="2" value="status"/>
    <key name="3" value="show channels"/>
    <key name="4" value="show calls"/>
    <key name="5" value="sofia status"/>
    <key name="6" value="reloadxml"/>
    <key name="7" value="console loglevel 0"/>
    <key name="8" value="console loglevel 7"/>
    <key name="9" value="sofia status profile internal"/>
    <key name="10" value="sofia profile internal siptrace on"/>
    <key name="11" value="sofia profile internal siptrace off"/>
    <key name="12" value="version"/>
</cli-keybindings>
```

FreeSWITCH是一个典型的Client/Server结构，不管FreeSWITCH运行在前台还是后台，你都可以使用客户端软件fs_cli连接FreeSWITCH。

fs_cli是一个类似Telnet的客户端（也类似于Asterisk中的“asterisk-r”命令），它使用FreeSWITCH的ESL（Event Socket Library）协议与FreeSWITCH通信。当然，使用该协议需要加载模块mod_event_socket，该模块是默认加载的。

正常情况下，直接输入bin/fs_cli即可连接到FreeSWITCH上，并出现系统提示符。如果出现类似：

[ERROR] libs/esl/fs_cli.c:652 main() Error Connecting [Socket Connection Error]

这样的错误，说明FreeSWITCH没有启动或mod_event_socket没有正确加载，请检查TCP的8021端口是否处于监听状态或被其他进程占用。

fs_cli也支持很多命令行参数，值得一提的是-x参数，它允许执行一条命令后退出，这在编写脚本程序时非常有用（如果它能支持管道会更有用，但是它不支持）：

```
$ bin/fs_cli -x "version"            # 显示版本号
$ bin/fs_cli -x "status"             # 显示状态
$ bin/fs_cli -x "originate user/1000 &bridge(user/1001)"    # 回拨
```

下面让我们看一个使用示例：

```
$ fs_cli -x "version"
```

```
FreeSWITCH Version 1.5.2b+git~20130622T184626Z~a38ea77fa3 (git a38ea77 2013-06-22 18:46:26Z)
```

其他的参数都可以通过配置文件来实现，在这里就不多说了。可以参见http://wiki.freeswitch.org/wiki/Fs_cli。

使用fs_cli，不仅可以连接到本机的FreeSWITCH，也可以连接到其他机器的FreeSWITCH上（或本机另外的FreeSWITCH实例上），通过在用户主目录下编辑配置文件.fs_cli_conf（注意前面的点“.”），可以定义要连接的多个机器：

```
[server1]
host     => 192.168.1.10
port     => 8021
password => secret_password
debug    => 7
[server2]
host     => 192.168.1.11
port     => 8021
password => someother_password
debug    => 0
```

注意，如果要连接到其他机器，要确保目标机器的FreeSWITCH的Event Socket是监听在真实网卡的IP地址上，而不是127.0.0.1，这可以通过将conf/autoload_configs/event_socekt.conf.xml中的IP地址改成为服务器IP或“0.0.0.0”实现，当然，这可能带来潜在的安全性问题。如果你的服务器运行在公网上，则需要考虑你是否确实需要这样做，或者至少考虑设置一下ACL或防火墙规则只允许特定的IP地址访问。当然，记得改完后在控制台上要执行“reload mod_event_socket”。另外，在UNIX中，以点开头的文件是隐藏文件，普通的“ls”命令是不能列出它的，可以使用“ls-a”列出这些文件。

一旦配置好，就可以这样使用它：

```
$ fs_cli server1
$ fs_cli server2
```

在fs_cli中，有几个特殊的命令，它们是以“/”开头的，这些命令并不直接发送到FreeSWITCH，而是先由fs_cli处理。/quit、/bye、/exit、Ctrl+D都可以退出fs_cli；/help是帮助。

其他一些以“/”开头的指令与Event Socket中相关的命令相同，如：

```
/event       -- 开启事件接收
/noevents    -- 关闭事件接收
/nixevent    -- 除了特定一种外，开启所有事件
/log         -- 设置 log 级别，如 /log info 或 /log debug 等
/nolog       -- 关闭 log
/filter       -- 过滤事件
```

除此之外，其他命令都与直接在FreeSWITCH控制台上执行是一样的。在fs_cli中也支持快捷键，最常用的快捷键是F6（reloadxml）、F7（关闭log输出）、F8（开启debug级别的log输出）。

在UNIX类平台上，FreeSWITCH控制台和fs_cli两者都通过libeditline支持命令行编辑功能。可以通过上、下箭头查看历史命令。

## 呼叫

呼叫是FreeSWITCH最基本的功能，下面我们一起来看一下FreeSWITCH中与呼叫相关的命令和概念。

### 发起呼叫

可以在FreeSWITCH中使用originate命令发起一次呼叫。下面我们看个例子。假设用户1000已经注册，那么可以运行如下命令：

```
freeswitch> originate user/1000 &echo
```

上述命令在呼叫1000这个用户后，便执行echo这个程序。echo是一个回音程序，即它会把任何它“听到”的声音（或视频）再返回（说/播）给对方。因此，如果这时候用户1000接了电话，无论说什么都会听到自己的声音。

### 呼叫字符串

在4.5.1节的例子中，“user/1000”称为呼叫字符串（Dial String，有时也叫Call URL）。“user”是一种特殊的呼叫字符串，在后面我们还会看到其他的呼叫字符串。

下面让我们来看一个例子。假设FreeSWITCH UA的地址为192.168.4.4:5050，alice UA的地址为192.168.4.4:5090，bob UA的地址为192.168.4.4:26000。若alice已向FreeSWITCH注册，在FreeSWITCH中就可以看到alice的注册信息：

```
freeswitch> sofia status profile internal reg
Registrations:
==============================================================================

Call-ID:        ZTRkYjdjYzY0OWFhNDRhOGFkNDUxMTdhMWJhNjRmNmE.
User:           alice@192.168.4.4
Contact:        "Alice" <sip:alice@192.168.4.4:5090;rinstance=a86a656037ccfaba;transport=UDP>
Agent:          Zoiper rev.5415
Status:         Registered(UDP)(unknown) EXP(2010-05-02 18:10:53)
Host:           du-sevens-mac-pro.local
IP:             192.168.4.4
Port:           5090
Auth-User:      alice
Auth-Realm:     192.168.4.4

MWI-Account:    alice@192.168.4.4
==============================================================================
```

FreeSWITCH根据Contact字段知道alice的SIP地址：sip:alice@192.168.4.4:5090。当使用originate命令呼叫user/alice这个呼叫字符串时，FreeSWITCH便会在用户目录中查找alice这个用户，找到她的dial-string参数 [1]，dial-string参数通常包含alice实际Contact地址的查找方法，FreeSWITCH进而找到alice的Contact地址sip:alice@192.168.4.4:5090并向其发送INVITE请求。

[1] 该参数可以在默认配置文件中的conf/directory/default.xml中找到，当然它比较复杂，我们将在后面的章节中再深入讨论。

## API与App

在4.5.2节的例子中，originate是FreeSWITCH内部的一个命令（Command），它用于控制FreeSWITCH发起一个呼叫。FreeSWITCH的命令不仅可以在控制台上使用，也可以在各种嵌入式脚本、Event Socket（fs_cli就是使用了ESL库）或HTTP RPC上使用，所有命令都遵循一个抽象的接口，因而这些命令又称API Commands [1]。

echo则是一个常用的应用程序（Application，App），它的作用是控制一个Channel的一端。我们知道，一个Channel有两端，在上面的例子中，alice是一端，另一端就是echo。电话接通后相当于alice在跟echo通话。后面我们会讲到，它们实际上组成了FreeSWITCH的一条腿（leg），这种通话称为“单腿通话（one-legged connection）”。

另一个常用的App是park，其使用格式如下：

```
freeswitch> originate user/alice &park
```

当我们初始化了一个呼叫时，在alice接电话后对端必须有一个人在跟其讲话（否则，如果一个Channel只有一端，那是不可思议的事情），而如果这时FreeSWITCH找不到一个合适的人跟alice通话，那么它可以将该电话“挂起”，park便是实现这个功能，它相当于一个Channel特殊的一端 [2]。

park的用户体验并不好，因为alice不知道要等多长时间才有人接电话，由于它听不到任何声音，这时它就会奇怪电话到底有没有接通。相对而言，另一个程序hold则比较友好，它能在等待的同时播放保持音乐（Music on Hold，MOH）。hold的使用格式如下：

```
freeswitch>originate user/alice &hold
```

当然，你也可以直接播放一个特定的声音文件，如下：

```
freeswitch> originate user/alice &playback(/root/welcome.wav)
```

或者直接录音，如下：

```
freeswitch> originate user/alice &record(/tmp/voice_of_alice.wav)
```

以上的例子实际上都只是建立一个Channel，相当于FreeSWITCH作为一个UA跟alice通话。它是个一条腿（只有a-leg）的通话。在大多数情况下，FreeSWITCH都是作为一个B2BUA来桥接两个UA进行通话的。在alice接听电话以后，bridge程序可以再启动一个UA呼叫bob，如下：

```
freeswitch> originate user/alice &bridge(user/bob)
```

至此，alice和bob终于可以通话了。我们也可以用另一种方式建立他们之间的通话，具体步骤如下：

```
originate user/alice &park
originate user/bob &park
show channels
uuid_bridge <alice_uuid> <bob_uuid>
```

在这里，我们分别呼叫alice和bob，并把他们暂时park到一个地方。通过命令show channels我们可以知道每个Channel的UUID，然后使用uuid_bridge命令将两个Channel桥接起来，而上一种方式实际上是先桥接，再呼叫bob。

上面我们一共学习了两条命令（API）——originate和uuid_bridge，以及几个程序（App）——echo、park、bridge等。细心的读者可能会发现，uuid_bridge API和bridge App有些类似。我们知道它们一个是先呼叫后桥接，另一个是先桥接后呼叫，那么它们到底有什么本质的区别呢？

简单来说，一个App是一个程序（Application），它作为一个Channel一端与另一端的UA进行通信，相当于它工作在Channel内部；而一个API则是独立于一个Channel之外的，它只能通过找到Channel的UUID来控制一个Channel（如果需要的话），相当于一个第三者。这就是API与App最本质的区别。 [3]

通常我们在控制台上输入的命令都是API；而在dialplan中执行的程序都是App（dialplan中也能执行一些特殊的API）。大部分公用的API都是在mod_commands模块中加载的；而App则在mod_dptools中，因而App又称为拨号计划工具（Dialplan Tools）。某些模块（如mod_sofia）有自己特有的API和App。

某些App有与其对应的API，如上述的bridge和uuid_bridge，还有transfer和uuid_transfer、playback和uuid_playback等。uuid一族的API都是在一个Channel之外对Channel进行控制的，它们应用于不能参与到通话中却又想对正在通话的Channel做点什么的场景中。例如alice和bob正在畅聊，有个“坏蛋”使用uuid_kill将电话切断，或使用uuid_broadcast对他们广播恶作剧音频，或者使用uuid_record对他们谈话的内容录音等。

关于API和App更详细的内容，可以参见：

- mod_dptools:http://wiki.freeswitch.org/wiki/Mod_dptools。
- mod_commands:http://wiki.freeswitch.org/wiki/Mod_commands。

[1] 当API与App相对时，我们一般叫API，这个名字来源于它的具体实现，在FreeSWITCH内部的实现中，所有的API都来源于一个叫switch_api_interface_t的结构。在其他情况下，我们不是刻意比较它与App的区别时，更倾向于称之为“命令”，这样描述起来更自然一些。 

[2] 笔者常举的一个例子是：如果把一个Channel看作是一根绳子，那么该例中是alice相当于拉着绳子的一头，而对端则拴（park）在一枚钉子上。 

[3] 当然，除originate以及uuid一族的API（以uuid_开头的API）外，其他大部分API（如version,、status等）一般是没有相对应的App的，因而这里就没有讨论的必要了。

## API命令帮助

在本章的最后，我们来学习一下如何使用FreeSWITCH的API命令帮助。使用help可以列出所有命令的帮助信息，具体示例如下：

```
freeswitch> help
Valid Commands:
...,,Shutdown,mod_commands
acl,<ip><list_name>,Compare an ip to an acl list,mod_commands
alias,[add|stickyadd] <alias><command> | del [<alias>|*],Alias,mod_commands
banner,,Return the system banner,mod_commands
bg_system,<command>,Execute a system command in the background,mod_commands
bgapi,<command>[ <arg>],Execute an api command in a thread,mod_commands
break,<uuid> [all],uuid_break,mod_commands
chat,<proto>|<from>|<to>|<message>|[<content-type>],chat,mod_dptools
cluechoo,syntax,Cluechoo API,mod_cluechoo
complete,add <word>|del [<word>|*],Complete,mod_commands
cond,<expr> ? <true val> : <false val>,Evaluate a conditional,mod_commands
conference ...
```

以bgapi为例，它的作用是把命令放到后台执行（命令执行都是阻塞的，有些命令需要执行相对较长的时间才能返回，因而有时我们会把某些命令放到后台执行）。其后面的<command>表示是一个必选参数，它的值可以是除bgapi以外的任何其他命令；[<arg>]放到方括号中，表示是一个可选参数，该参数是实际的<command>的参数，由于有些命令是没有参数的，因而它是可选的。

某些命令也有自己更详细的帮助信息，如sofia：

```
freeswitch> sofia help
```

```
USAGE:
--------------------------------------------------------------------------------

sofia help
sofia profile <profile_name> [[start|stop|restart|rescan]
    [reloadxml]|flush_inbound_reg [<call_id>] [reboot]|[register|unregister]
....
```

其中，用尖括号（<>）括起来的表示是要输入的参数；而用方括号（[]）括起来的则表示为可选项，该参数可以有也可以没有；用竖线（|）分开的参数列表表示“或”的关系，即只能选其一。

FreeSWITCH的命令参数没有统一的解析函数，都是由命令本身的函数负责解析的，因而不是很规范，不同的命令可能有不同的风格，所以使用时，除使用帮助信息外，最好还是查阅一下Wiki上的帮助。

## 小结

本章介绍了如何启动与控制FreeSWITCH，并提到了几个常用的命令。另外，本章还着重讲述了App与API的区别、呼叫字符串的概念等，搞清楚这些概念对后面的学习是很有帮助的。

我们无法在一本书中讲解所有的命令，因此，我们也在本章中介绍了如何实时获取在线帮助，了解了获取帮助的方法和相关规律，就可以随时迅速学习和掌握新的命令和知识了。