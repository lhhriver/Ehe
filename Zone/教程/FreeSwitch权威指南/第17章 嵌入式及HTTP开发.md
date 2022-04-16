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
# 第15章 其他技巧与实例
# 第16章 嵌入式脚本
# 第17章 嵌入式及HTTP开发

上一章我们学习了嵌入式脚本的基本知识，这一章我们用它们来做些有用的事情。另外，除嵌入式脚本，我们还会在本章讲解一些配合HTTP服务器进行开发的例子，以便于读者了解更多的功能以及进行比较阅读。

## 用Lua脚本写个小游戏

工作再忙也总有时间轻松一下。好玩的游戏总会令人心情愉快。不过，在这里讲的这个小游戏不是我自己玩的，而是另有故事。在写作本书时，笔者的儿子刚刚4岁，他总会不时地过来敲打一下键盘，使得笔者总不能静下心来工作。当写到本章时，需要一个例子，笔者忽然来了灵感，就迅速给他写了个小游戏，这样他就可以自己玩一阵子。

由于是“迅速”写的，因此很简单。笔者给儿子在iPad上装了个软电话，他拨“1”就会进入FreeSWITCH上的一个Lua程序，该程序会提示他输入一个数字，并使用TTS读出这个数字。当然，如果只读“0123456789”肯定是太无聊了，所以笔者还加了一点点逻辑：如果输入的是“*”，就将数字减一，如果按的是“#”，就将数字加一。这样通过按“#”，数字就能一直累加上去。他能玩好一阵子，并乐此不疲。

后来，为了证明笔者确实收到了他的按键，笔者在程序中使用system App调用了系统的banner [1]程序，把它输入的数字在控制台上打印出来。下面是数字“9”在笔者电脑上的输出（只是一直没意识到，在Mac平台上“banner”的输出是横着的）：

```lua
[INFO] switch_cpp.cpp:1293 DTMF: 9 Duration: 800
[NOTICE] mod_dptools.c:1973 Executing command: banner -w 40 9
                          #####
           #          ############
          ##         ##############
          #         ####         ###
          #         ##             ##
          #         #               #
          #         #               #
          ###        ##           ###
           #########################
             #####################
                ###############
```

当然，增加了banner以后又带来了一个副作用，那就是儿子隔一阵就跑过来看看笔者的FreeSWITCH控制台以验证他输入的是否正确，还是会影响工作。好了，闲话少叙，我们来看代码：

```lua
01 local x = 1
02 function onInput(s, type, obj, arg)
03   if (type == "dtmf") then
04       freeswitch.consoleLog("INFO",
05         "DTMF: " .. obj.digit .. " Duration: " .. obj.duration .. "\n")
06     if (obj.digit == "*") then
07       x = x - 1
08       if (x < 0) then x = 0 end
09       n = x
10     elseif (obj.digit == "#") then
11       x = x + 1
12       n = x
13     else
14       n = obj.digit
15     end
16     s:execute("system", "banner -w 40 " .. n)
17     s:speak(n)
18   end
19   return ''
20 end
21 session:set_tts_params("tts_commandline", "Ting-Ting")
22 session:answer()
23 session:speak("冰冰你好，请按一个数字")
24 session:setInputCallback('onInput', '')
25 session:streamFile("local_stream://moh")
```

程序的代码很简单。在第2行我们定义了一个onInput函数，当有按键输入时，系统会调用该回调函数，它用一个简单的算法计算一个变量值n，然后在第16行调用banner在控制台上输出n（其中的s变量就是传入的当前的“session”），并在第17行使用TTS技术“说”出n的值。

真正脚本的执行是从第21行开始的。该脚本在执行时会自动获得一个session变量，它唯一标志了当前的通话。在第21行，首先设置了我们将要使用的TTS的参数；然后在第22行进行应答；第23行播放一个提示音；第24行安装一个回调函数，当该session上有输入时，它将回调该函数；第24行播放保持音乐。

为了能让他很简单地按“1”就呼叫到该脚本，笔者使用了下面的Dialplan：

```xml
<extension name="Number Game">
  <condition field="destination_number" expression="^1$">
    <action application="lua" data="numbers_game.lua"/>
  </condition>
</extension>
```

当然，除此之外，笔者还实现了当他按“2”时可跟笔者来一阵视频通话：

```xml
<extension name="Video Me">
  <condition field="destination_number" expression="^2$">
    <action application="bridge" data="user/1007"/>
  </condition>
</extension>
```

等把书写完了，笔者一定好好想想，在FreeSWITCH中给他写更多更好玩的游戏。现在，就讲到这里吧。其实这个例子不仅仅是个游戏，它包含了在Lua脚本中接收DTMF输入、放音等基本操作，再多加上些if...else之类的语句，肯定能写出很强大的IVR应用了。

[1] UNIX系统上自带的一个程序。它会使用“ASCII Art”形式输出字符。

## 用Lua实现IVR

用Lua可以创建很灵活的IVR应用，在此我们就来看一个电话充值的例子。

假设我们有一项电话自动充值服务，为会员提供自动服务，我们把这项服务称为空中充值服务。其中，每个会员都会有一个会员账号（以及密码），它可以根据账号查询余额，或者向该账号充值。如果需要充值，会员需要事先购买充值卡，在充值时需输入充值卡卡号来达到充值的目的。

为了提供比较好的用户体验，我们精心设计了一个充值流程，并画了一个简单的思维导图 [1]，如图17-1所示。该图非常清晰地描述了用户查询及充值的流程。在此我们先不做太多解释，而是配合脚本代码讲解一下。

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/FreeSwitch权威指南-20211225-182224-431857.png)

<center>图17-1　充值IVR流程思维导图</center>

下面的代码首先是一行注释，接着设置了一些常量和变量：

```lua
01 -- Calling card charging demo. Author: Seven Du
02 error_prompt = "say:输入错误，请重新输入"
03 account = ""
04 digits = ""
05 balance = 100   -- 余额
06 charge = 100    -- 充值卡上的金额
```

我们先定义一个do_charge函数，该函数有两个参数account和charge，分别代表被充值的账号和充值的金额。在该函数中，我们没有做写数据库等操作，而是直接将欲充值的金额加到了全局变量中的余额（balance）上。代码如下：

```lua
07 function do_charge(account, charge)
08     balance = balance + charge
09     return balance
10 end
```

接下来定义一个主菜单函数。注意第12行，我们使用session:ready()函数判断该session是否还继续有效（即判断用户是否挂机），如果无效就立即返回。这是因为，我们的菜单可能会有多次循环，而在循环过程中如果用户挂机，并不会中止Lua脚本的执行，因此一定要保证有一定的退出机制。

第13行使用playAndGetDigits函数让用户选择是查询还是充值。第15行进行判断，如果用户输入有效，则将输入的数字（digits，值为1或2）作为函数的参数传入ask_account函数中，并继续执行ask_account提示用户输入账号；当然，如果用户输入错误（最多3次，由playAndGetDigits函数保证），则直接跳到goodbye函数处理，我们下面会看到。main_menu这一段代码如下：

```lua
11 function main_menu()
12     if not session:ready() then return end
13     digits = session:playAndGetDigits(1, 1, 3, 5000, "#",
           "say:查询请按1，充值请按2", error_prompt, "^1|2$")
14     session:execute("log", "INFO main_menu:" .. digits)
15     if not (digits == "") then
16         ask_account(digits)
17     else
18         goodbye()
19     end
20 end
```

ask_account函数用于询问用户的账号。注意类似第22行对于session:ready()的检测，基本上在每个函数中都有。另外，我们规定账号是4位的，因此在第23行，参数中允许用户输入的最小位长是4，而这里我们使用最大位长是5的原因是，等待用户输入4位账号后，并不立即往下执行，而是等待用户按#号键。这里我们等待用户按#号键完全是一个用户习惯问题。实际上，如果有户不按#号键，我们这里的流程也是可以正常往下执行的 [2]。

当用户输入账号后，我们将其保存到account变量中。在第29行进行判断，如果在上一步用户选择了“1”，即查询，我们接着调用ask_account_password（第28行）询问密码，否则（用户选择了“2”，充值）调用ask_card（第30行）函数询问卡号进行充值流程。

```lua
21 function ask_account(service_type)
22     if not session:ready() then return end
23     digits = session:playAndGetDigits(4, 5, 3, 5000, "#",
           "say:请输入您的账号，以井号结束", error_prompt, "^\\d{4}$")
24     session:execute("log", "INFO account:" .. digits)
25     if not (digits == "") then
26         account = digits
27         if (service_type == "1") then
28             ask_account_password()
29         else
30             ask_card()
31         end
32     else
33         goodbye()
34     end
35 end
```

ask_account_password及ask_card函数的代码如下所示。它们的代码跟上面讲到的类似，都是收集了信息然后根据收到的信息调用相关函并进行处理。

```lua
36 function ask_account_password()
37     if not session:ready() then return end
48     digits = session:playAndGetDigits(4, 5, 3, 5000, "#",
         "say:请输入您的密码，以井号结束", error_prompt, "^\\d{4}$")
39     session:execute("log", "INFO account p:" .. digits)
40     if not (digits == "") then
41         password = digits
42         check_account_password()
43     else
44         goodbye()
45     end
46 end

47 function ask_card()
48     if not session:ready() then return end
49     digits = session:playAndGetDigits(4, 5, 3, 5000, "#",
           "say:请输入您的充值卡卡号，以井号结束", error_prompt, "^\\d{4}$")
50     session:execute("log", "INFO card:" .. digits)
51     if not (digits == "") then
52         card = digits
53         check_account_card()
54     else
55         goodbye()
56     end
57 end
```

如果用户是在查询，则在用户输入密码后执行检查密码的函数（check_account_password）。在此我们直接使用硬编码（Hard coded）的“1111”（第60行）来验证账号和密码的合法性，在实际使用时可以配合查询数据库或第三方接口去检查密码的合法性。如果密码检查通过，则直接使用TTS技术播放余额（第61行），播放完毕后暂停500毫秒再返回主菜单（第62行）；当然，如果密码检查不通过，也进行相关提示并返回主菜单（第65～66行），以让用户有机会输入正确的值。

```lua
58 function check_account_password()
59     if not session:ready() then return end
60     if (account == "1111" and password == "1111") then
61         session:speak("您的余额是" .. balance .. "元")
62         session:sleep(500)
63         main_menu()
64     else
65         sesson:speak("输入有误，请重新输入")
66         main_menu()
67     end
68 end
```

至此，查询的代码分支就结束了，我们接着看充值的函数。第71行我们硬编码了卡号“2222”，如果用户输入正确，则在第72行语音提示用户将要充值的金额（充值卡上已有的金额，在第6行定义），然后让用户确定是否充值（第73行）。为了简单起见，我们没有再写新的函数，而是将逻辑判断都写到这一个函数里。代码如下：

```lua
69 function check_account_card()
70     if not session:ready() then return end
71     if (account == "1111" and card == "2222") then
72         session:speak("您要充值" .. charge .. "元")
73         digits = session:playAndGetDigits(1, 1, 3, 10000, "#",
               "say:确认请按1，返回请按2", error_prompt, "^[12]$")
74         if digits == "1" then
75             balance = do_charge(account, charge)
76             session:speak("充值成功，充值金额" .. charge ..元，余额为" .. balance .. "元")
77             main_menu()
78         else
79             if digits == "2" then
80                 session:sleep(500)
81                 main_menu()
82             else
83                 goodbye()
84             end
85         end
96      else
87         session:speak("输入有误，请重新输入")
88         ask_account("2")
89     end
90 end
```

如果在上面的步骤中出错，我们会转到goodbye函数，该函数的定义如下（它只是简单地说声再见，然后挂机）：

```lua
91 function goodbye()
92     if not session:ready() then return end
93     session:speak("再见")
94     session:hangup()
95 end
```

上面是我们定义的函数，实际的脚本执行是从下面的代码才开始的。在本例中，为了使代码清晰，我们没有使用语音文件，而是使用了TTS技术。因此，第96行我们需要设置一下TTS的相关参数，该行可以保证session:speak()能正常放音，但经过测试，session:playAndGetDigits()函数则不能正常放音，因此我们在第97和98行又分别设置了两个参数，保证其能正常放音。

```lua
96  session:set_tts_params("tts_commandline", "Ting-Ting");
97  session:setVariable("tts_engine", "tts_commandline")
98  session:setVariable("tts_voice", "Ting-Ting")
```

设置好这些参数后，我们就可以应答（第99行）、播放欢迎语（第100行），并开始执行主菜单函数（第101行）了。

```lua
99  session:answer()
100 session:speak("您好，欢迎使用空中充值服务")
101 main_menu()
```

在本例中，我们采用了一种类似状态机的设计，main_menu、ask_*以及check_*等函数都可以看作是一个状态，根据输入的条件不同可以在这几个状态间转换，代码也比较清晰直观。而且，由于Lua的尾递归特性，在这些函数中可以循环地跳转也不会消耗栈空间。当然，我们在每个函数中都使用了session:ready()来判断当前的session是否有效避免了用户挂机后出现无限循环。

[1] 思维导图即Mind Map，是一种利用图像式思考辅助工具来表达思维的工具。在使用繁体中文的地区又称心智图，参见http://zh.wikipedia.org/wiki/心智图。在解决此类问题时，大家也常用流程图。但流程图比较强调流程的正确性，而思维导图更强调思维（思路）的正确性。笔者一般倾向于使用后者，但不管使用前者还是后者，有一个图对于编程实现是非常有帮助的。 

[2] 不过要等一会，读者可以自己试一下。也可以尝试把5改成4看看效果，那样的话就可以把语音提示里的“以井号结束去掉了”。

## 在会议中呼出

很多网友都曾问过，如何在会议中通过DTMF去呼叫其他人加入会议？实现的方法有很多种，这里我们来看一下如何通过配合Lua脚本来实现。

首先，我们来看下面的Lua脚本：

```lua
01 prompt="tone_stream://%(10000,0,350,440)"
02 error="error.wav"
03 result = ""
04 extn = session:playAndGetDigits(1, 4, 3, 5000, '#', prompt, error, "\\d+")
05 arg = "3000 dial user/" .. extn
06 session:execute("log", "INFO extn=" .. extn)
07 session:execute("log", "INFO arg=" .. arg)
08 if not (extn == "") then
09     api = freeswitch.API()
10     result = api:execute("conference", arg)
11     session:execute("log", "INFO result=" .. result)
12 else
13     session:execute("log", "ERR Cannot result=" .. result)
14 end
```

这个Lua脚本也很简单。首先，第1～3行初始化几个变量。然后在第4行执行playAndGetDigits，它的用法我们在第16章已经讲过了，它首先播放prompt指定的声音（是一个拨号音），然后等待用户输入，最大收号长度是4。如果用户输入错误，则播放error.wav，并提示用户重新输入，最多可重试3次。最后收到的DTMF将存入变量extn中。

第5行，我们构造一个字符串，作为conference命令的参数，备用。

第6～7行，打印日志（检查程序错误最好的方法就是多打印日志）。

第8行，判断，如果输入的extn是一个有效的值，则在第9行初始化一个api变量，并在第10行执行一个API命令；如果用户输入的是1006，则实际执行的命令就是conference 3000 dial user/1006，它会主动外呼1006这个用户，被叫接听后便可进行会议。

不管呼叫成功还是失败，都会在第13行打印呼叫结果，如笔者在测试时，第一次拒绝了呼叫，日志如下：

```
[INFO] mod_dptools.c:1595 extn=1006
[INFO] mod_dptools.c:1595 arg=3000 dial user/1006
[INFO] mod_dptools.c:1595 result=Call Requested: result: [USER_BUSY]
```

第二次接听了呼叫，则日志结果如下：

```
[INFO] mod_dptools.c:1595 result=Call Requested: result: [SUCCESS]
```

当然，我们分析了上述脚本，还得研究一下怎么使用上述脚本。我们在12.5.1节曾讲过，在会议中，可以使用DTMF进行控制。我们先把会议控制中的call-controller部分的*和#号键对应的功能修改一下，让*号键对应执行我们刚写的Lua脚本（conference_dial.lua），并把#号键对应的功能注释掉，以防止产生冲突。autolocal_configs/conference.conf.xml中对应的配置如下：

```xml
<caller-controls>
<group name="default">
    <control action="execute_application" digits="*" data="lua conference_dial.lua"/>
    <!-- <control action="hangup" digits="#"/> -->
</group>
</caller-controls>
```

然后，打个电话呼入名称为3000的会议，在会议中就可以通过按*号键在听到拨号音后输入一个号码进行外呼了。

如果只想会议管理员才能使用上述功能，也可以将上述功能键的映射关系放到单独的group中（如group name="modrator"）并通过会议Profile中的moderator-controls指定该组以确保只有管理员才可以使用这些按键来进行控制。

## 一个在FreeSWITCH中外呼的脚本

曾有一个朋友这样问笔者：能否实现在FreeSWITCH中外呼，然后放一段录音？笔者的回答是：当然能！写个简单的脚本就行。但后来他要求还要知道呼叫是否成功，那实现就要复杂一点了。

笔者针对上边的问题很快写了一个例子。这个例子的实现思路是：将待呼号码放到一个文件中，每个号码一行，然后用Lua依次读取每一行，并进行呼叫。呼通后播放一个声音文件，并将呼叫（通话）结果写到一个日志文件中。

该脚本比较长，我们一段一段地来看。

首先设置一些常量和变量。第1行，设置呼叫字符串的前面的参数，其中，ignore_early_media是为了保证对方应答后才开始播放（否则，在对方传回铃音或彩铃时播放就会开始，这不是我们想要的）；第2行指定我们呼叫的数据文件；第3行指定呼通后要播放的声音文件路径；第4行指定日志文件的路径。代码如下：

```lua
01 prefix = "{ignore_early_media=true}sofia/gateway/gw1/"
02 number_file_name = "/usr/local/freeswitch/scripts/number.txt"
03 file_to_play = "/usr/local/freeswitch/sounds/ad.wav"
04 log_file_name = "/usr/local/freeswitch/log/dialer_log.txt"
```

在脚本中，我们经常需要打印一些日志，简单起见，包装一个函数debug，它实际上就是调用了freeswitch.consoleLog来打印日志的。代码如下：

```lua
05 function debug(s)
06     freeswitch.consoleLog("notice", s .. "\n")
07 end
```

接下来，我们定义一个呼叫函数call_number，它接收一个号码（number）作为参数（第8行）。freeswitch.Session会呼叫一个号码（第11行），并一直等待对方应答，对方应答后，将得到一个session变量；如果该session是正常的（第12行），则在第13行先等待1秒（1000毫秒），以防止丢失最开始的声音。然后，在第14行使用streamFile播放一段声音，并在第15行挂机。第18行将进行忙等待；最后，第22行，函数返回挂机原因（hangup_cause）。

```lua
08 function call_number(number)
09     dial_string = prefix .. tostring(number);
10     debug("calling " .. dial_string);
11     session = freeswitch.Session(dial_string);
12     if session:ready() then
13         session:sleep(1000)
14         session:streamFile(file_to_play)
15         session:hangup()
16     end
17     -- waiting for hangup
18     while session:ready() do
19         debug("waiting for hangup " .. number)
20         session:sleep(1000)
21     end
22     return session:hangupCause()
23 end
```

实际的代码是从下面开始执行的。首先第24行打开存放电话号码的文件（准备读）和呼叫日志（第25行，准备写，追加）；然后进入一个死循环，第27行从数据文件中读出一个号码，放到line变量中；第28行测试，如果该行是空行或nil就说明文件读完了，跳出循环；第29行调用我们上面定义的call_number函数进行呼叫，并将结果存到hangup_cause变量中；最后，第30行将呼叫结果写到一个呼叫日志文件中。

然后是无限循环（while），每次读取一行，当读到空行或文件尾时，退出。

在while循环中，读到的每一行实际上是一个号码，调用上面定义的call_number()函数进行呼叫，并将呼叫结果写到log_file中。

```lua
24 number_file = io.open(number_file_name, "r")
25 log_file = io.open(log_file_name, "a+")
26 while true do
27     line = number_file:read("*line")
28     if line == "" or line == nil then break end
29     hangup_cause = call_number(line)
30     log_file:write(os.date("%H:%M:%S ") .. line .. " " .. hangup_cause .. "\n")
31 end
```

将上述脚本保存到FreeSWITCH的scripts目录中（通常是/usr/local/freeswitch/scripts/），命名为dialer.lua，然后在FreeSWITCH控制台上执行如下命令便可以开始呼叫了：

```
freeswitch> luarun dialer.lua
```

除此之外，还有一个batch_dialer，用于批量外呼，感兴趣的读者可以自行研究一下:http://fisheye.freeswitch.org/browse/freeswitch-contrib.git/seven/lua/batch_dialer.lua?hb=true。

## 使用Lua脚本通过多个网关循环外呼

有时候，我们外呼需要通过多个网关。在15.5.4节我们曾讲到使用mod_distributor将呼叫分配到多个网关的方法。现在我们就来看一下如何用Lua脚本来实现上述功能。

首先看脚本的内容。到这里大家应该已经对Lua比较熟悉了，因此我们就不逐行讲了，仅将关键的地方讲一下。

第3行，我们定义了4个网关的名称，电话将通过这4个网关呼出。第4行我们定义了被叫号码取第一个从该脚本输入的参数，我们后面将会看到如何将这个值从Dialplan里传过来。

```lua
01 retries = 0
02 bridge_hangup_cause = ""
03 gateways = {"gw1", "gw2", "gw3", "gw4"}
04 dest = argv[1]
```

下面我们定义一个函数——call_retry，它将被递归调用。第7行中，每次递归我们都将retries参数加1，这是为了在第11行选择一下个网关；第8行很关键，它判断电话是否挂断，如果电话已挂断就立即退出，防止过多递归。

```lua
05 function call_retry()
06     freeswitch.consoleLog("notice", "Calling [" .. dest .. "] From Lua\n");
07     retries = retries + 1
08     if not session.ready() then
09             return;
10     end
11     dial_string = "sofia/gateway/" .. gateways[retries] .. "/" .. dest;
12     freeswitch.consoleLog("notice", "Dialing [" .. dial_string .. "]\n");
```

通过上面的第11行中拼好了呼叫字符串后，下面第13行就调用bridge开始呼叫b-leg了，呼叫应该是阻塞的，直到呼叫失败或呼叫成功通话完毕后才会返回；然后在第14行我们能得到本次呼叫的结果，存放到变量brige_hangup_cause中；接下来判断呼叫结果，如果呼叫失败，而且失败原因是16～19行中的一种，并且重试次数小于4（第15行），则暂停1秒（第23行）并重新调用call_retry函数进行呼叫。

```lua
13     session:execute("bridge", dial_string);
14     bridge_hangup_cause = session:getVariable("bridge_hangup_cause") or session:getVariable("originate_disposition");
15     if (retries < 4 and
16         (bridge_hangup_cause == "NORMAL_TEMPORARY_FAILURE" or
17         bridge_hangup_cause == "NO_ROUTE_DESTINATION" or
18         bridge_hangup_cause == "CALL_REJECTED" or
19         bridge_hangup_cause == "INVALID_GATEWAY") ) then
20         freeswitch.consoleLog("notice",
21             "On calling [" .. dest .. "] hangup. Cause: [" ..
22             bridge_hangup_cause .. "]. Retry: " .. retries .. " \n");
23         session:sleep(1000);
24         call_retry();
25     else
26         freeswitch.consoleLog("notice", "Retry Exceed, Now hangup!\n");
27     end
28 end
```

值得注意的是，上面的call_retry函数是递归调用的。Lua支持尾递归，所以递归时不会消耗栈空间，因此递归深度再大也没关系。不过，这里我们只有4个网关，故递归深度再大也不会超过4。

上面只是定义了变量和函数，真正的函数是在下面开始执行的。第30行和第31行的两个变量设置也很重要，它保证在通过一个网关呼叫不通时电话不会挂断，以便继续尝试其他的网关；最后，第32行开始调用我们前面定义的call_retry函数进行外呼。

```lua
29 session:preAnswer();
30 session:setVariable("hangup_after_bridge", "true");
31 session:setVariable("continue_on_fail", "true");
32 call_retry();
```

在本例中，我们的4个网关是硬编码的（Hard Coded），在真正使用时也可以从Dialplan或其他地方传进来，在此我们尽量保持简单。

另外，从脚本中也可以看出，与17.4节讲的外呼脚本不同，该脚本是在Dialplan中使用的。我们可以用如下的Dialplan调用该脚本：

```lua
<extension name="Lua Multi-GW Example">
    <condition field="destination_number" expression="^0(.*)$">
        <action application="lua" data="call_gw.lua $1"/>
    </condition>
</extension>
```

其中，如果匹配到以0开头的被叫号码，我们“吃掉”0，把剩余的部分作为参数传给Lua脚本，然后在Lua脚本中就可以从argv[1]中获得这些被叫号码的值了（参见代码中第4行）。

## 在FreeSWITCH中执行长期运行的嵌入式脚本

前面我们讲过的Lua脚本都是“短暂”运行的——它们或者存在于一路通话的会话期内，或者是在命令行上执行一个短暂的命令。但在有些情况下，我们可能希望脚本能永远不停地运行，下面我们就来看一个例子。

几年前，笔者曾经写过一个Lua脚本，用于监控网关的状态。实现的思路是：如果接收到挂机事件，就判断该通话是否是经过一个网关出去的；如果是，就判断通话是否成功；然后记录统计结果，并将统计结果以几种方式呈现：

- 在FreeSWITCH中触发一个事件，由其他程序进行处理；
- 发送到一个远端的HTTP服务器上；
- 直接写入数据库；
- 其他方式，如写入一个文件等。

其他的程序在收到这些统计结果后再使用Web方式呈现，进而我们可以知道哪些网关（运营商提供的SIP中继）比较好，哪些网关总是出问题。

笔者是用Lua脚本实现的，我们需要让该脚本一直运行，因此首先想到的就是脚本中必须有一个无限循环。笔者尝试过这样做：

```lua
while true do
  -- Sleep for 500 milliseconds
  freeswitch.msleep(500);
  freeswitch.consoleLog("info", "blah...");
end
```

但这样的脚本是无法终止的 [1]。由于FreeSWITCH使用swig支持这些嵌入式语言，而有些语言没有退出机制，所以所有语言的退出机制都没有在FreeSWITCH中实现，即使卸载（unload）相关的语言模块也不行。也是因为如此，为了避免产生问题，所有语言模块也都不能卸载 [2]。

读者可能要问，既然是长期运行的脚本，那为什么要停止呢？是的，大部分时间是不需要停止的，但是我们都是开发人员，如果在开发过程中你需要调试和修改脚本，总不能每次都重启FreeSWITCH吧？

所以，后来笔者想了一个办法，通过使用事件机制构造另一个循环，然后就可以在检测到一个特殊事件后停止该循环。如下面的代码，其中，第1行，freeswitch.EventConsumer定义一个事件消费者。第2行使用一个for循环不断从该事件消费者中取数据，pop(1)是阻塞的，如果需要无阻塞的话，就可以使用pop(0)。我们这里使用阻塞的方式，即直到有一个事件到来后它才执行循环体内的语句。当然，作为一个例子，我们在第3行仅打印收到的事件的内容。代码如下：

```lua
01 con = freeswitch.EventConsumer("all");
02 for e in (function() return con:pop(1) end) do
03     freeswitch.consoleLog("info", "event\n" .. e:serialize("xml"));
04 end
```

在FreeSWITCH中，事件总会有的。如每个电话初始化、挂机等都会有相应的事件。除此之外，FreeSWITCH内部也会毎20秒发出一个HEARTBEAT事件，这样你就可以根据该事件判断FreeSWITCH是否在正常运行，甚至还可以定时执行一些任务。

当然，到现在为止，还是不能运行上述脚本，因为它还是无法退出的。为了让它能退出，我们在上述代码的循环体中（第4行之前）再加入如下代码。这段代码的含义就是：当收到一个自定义的CUSTOM事件，并且事件的子类型是lua::stopscript时，便打印一个日志并退出（break）循环。代码如下：

```lua
event_name = e:getHeader("Event_IVame")
event_subclass = e:getHeader("Event-Subclass")
if (event_name == "CUSTOM" and event_subclass == "lua::stopscript") then
    freeswitch.consoleLog("INFO", "--lua Script [" ..
        argv[0] .. "] got stop message, Exiting--\n")
    break
end
```

加入上述代码后，可以放心地去运行一下了。为了能让上面的脚本退出，我们可以再写一个脚本，来触发一个自定义的事件，如：

```lua
local event = freeswitch.Event("CUSTOM", "lua::stopscript");
event:addHeader("Exit-Reason", "Seven said you should stop");
event:fire();
```

解决了无限循环的退出问题后，你就可以在循环体内处理各种业务逻辑了。

脚本写好后，可以在控制台上使用lua和luarun命令执行该脚本。二者的不同就是lua是在当前线程中运行的，所以它会阻塞；而luarun会产生一个新的线程，不会阻塞当前的线程执行。

脚本后面可以加参数，如“luarun test.lua arg1 arg2”，在脚本中，就可以通过argv[1]、argv[2]来获得参数的值。而argv[0]是脚本的名字。

另外，也可以将脚本配置到conf/autoload_configs/lua.conf.xml文件中，这样它就能随FreeSWITCH一起启动，如：

```xml
<param name="startup-script" value="test.lua"/>
```

最后，实际的例子可以参考笔者写的gateway_report.lua脚本，具体我们就不详细讲了，完整的代码在http://fisheye.freeswitch.org/browse/freeswitch-contrib.git/seven/lua/gateway_report.lua?hb=true处。

[1] 理论上，在循环体内通过检测一个FreeSWITCH全局变量的值也是可能终止的，不过笔者没有实验，而是采用了一种这里即将讨论的事件的方案。

[2] 事实上，是在笔者发现该问题报告给FreeSWITCH社区后各模块才禁止卸载的。参见：http://jira.freeswitch.org/browse/FS-1365。

## 使用Lua提供XML Binding

在16.2.7节我们介绍了用Lua提供动态括号计划的例子，下面我们再看一下Lua能提供的另外一个功能——XML绑定（Binding）。

前面我们学习过的XML配置文件都是静态的，在很多时候编辑静态的XML很不方便。FreeSWITCH提供了一种机制可以在XML配置节点上绑定一些回调（函数或方法），然后当FreeSWITCH用到一段XML时，就可以调用该回调功能来取得XML。我们可以使用Lua绑定一个回调，并通过Lua脚本来产动态的XML内容。

我们仍以Dialplan为例，注意这里我们使用的是Lua绑定XML提供的Dialplan（提供的还是XML Dialplan），而不是LUA Dialplan。

首先，回想一下第5章，我们讲过FreeSWITCH配置文件conf/freeswitch.xml中有多个Section，如Configuraton、Directory、Dialplan、Chatplan、Languages等，这里我们只绑定到Dialplan。Lua代码如下：

```lua
freeswitch.consoleLog("NOTICE", "SECTION " .. XML_REQUEST["section"] .. "\n")
xml = [[
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<document type="freeswitch/xml">

<section name="dialplan" description="RE Dial Plan For FreeSwitch">
  <context name="default">
    <extension name="9196">
      <condition field="destination_number" expression="^9196$">
        <action application="log" data="ERR I'm from Lua XML dialplan"/>
        <action application="answer"/>
        <action application="echo"/>
      </condition>
    </extension>
  </context>
</section>

</document>
]]
XML_STRING=xml
```

这段代码没有什么特别的，只是第1行打印了一行日志，该日志的内容包含从XML_REQUEST中取出来的参数。跟前面基于Session的脚本类似，所有这种绑定的请求，都会自动有一个XML_REQUEST变量，然后在Lua脚本中通过这个变量的内容来进行各种if…else判断，进而动态产生XML。当然，本例子出于简单起见，在Lua脚本中还是写了一个静态的字符串。

脚本的最后一行，定义一个XML_STRING变量，当脚本执行完成后，FreeSWITCH会在该变量中找到相应的XML文本并进行解析，以执行下一步的动作。

上述脚本编辑完成后，可以在conf/lua.conf.xml中进行如下设置并重启FreeSWITCH使之生效：

```xml
<param name="xml-handler-script" value="/tmp/dp_xml.lua"/>
<param name="xml-handler-bindings" value="dialplan"/>
```

该配置将/tmp/dp_xml.lua脚本绑定到XML配置文件中的Dialplan这个Section，以后当FreeSWITCH需要查找XML Dialplan时，便会自动执行绑定的Lua脚本，生成动态的XML。

## 语音识别

语音识别（Automatic Speech Recognition，ASR）算是一个高级话题。不过，之所以直到现在我们才讲到语音识别，并不仅是因为它高级，还因为使用它不像其他模块那样配置一下就能用了，而是需要配合一些脚本才能实现。

语音识别与TTS技术可以说是一对孪生兄弟，但“长相”却迥然不同。TTS是把文字转成语音，而语音识别则是把声音转换成文字 [1]。一般来说，TTS技术是比较容易实现的，最简单的实现仅需要用查表法将与文字对应的录音逐个查找到并读出，高级一些的借助一些语法和词法分析并借助语音合成技术能读出抑扬顿挫的声调；但语音识别就不同了，它不仅需要语法和词法分析，还需要“理解”声音的内容，以转换成合适的文字。

语音识别分为基于关键词的识别和自然语音识别。基于关键词的识别比较成熟，因为词汇数量有限，比较容易做到精确。这类应用一般用于声控场合，如发出打开、关闭（设备或程序）、呼叫（某人）等命令。基于自然语言的识别则比较难，多年来人们进行了大量的研究，但鲜有较好的应用。后来，随着iPhone上Siri的出现，语音识别好像一下子迎来了曙光，众多的语音识别产品也很快推出来了。

当然，在此我们无意关注这些产品，也不想深入探究这些底层的技术，而是想了解FreeSWITCH如何与语音识别搭上边——由于FreeSWITCH内部处理的媒体类型主要是声音，自然一切与声音有关的应用都能搭上边。

### 使用Pocket Sphinx进行中文语音识别

Sphinx [2]是卡内基梅隆大学研究的开源语音识别软件，Pocket Sphinx [3]则是一个轻量版，主要用于嵌入式及手持移动设备。FreeSWITCH中有一个mod_pocketsphinx [4]模块可以通过PocketSphinx进行语音识别。该模块不是默认安装的，但可以参照前面其他模块的安装方法，在源代码目录下使用“make mod_pocketshpinx-install”并在FreeSWITCH控制台上使用“load mod_pocketsphinx”命令加载。

1. 英文语音识别快速体验

FreeSWITCH自己带了一个Pizza的例子，大意是打电话到一个比萨店，店里的IVR会自动询问你欲订何种比萨，你的回答对方可以识别出来。读者可以参阅该模块的Wiki页面看一下如何测试该例子。不过，该例子讲起来比较复杂，下面我们看一个简单点的例子。

首先，语音识别需要一个语法文件。在FreeSWITCH源代码目录下的script目录下有一个yes_no.gram的语法文件的例子，我们先把它复制到FreeSWITCH安装目录的grammar目录下。该文件不长，全部内容如下：

```
#JSGF V1.0;
/** JSGF Grammar for example */
grammar example;
<yes> = [ yes ];
<no> = [ no ];
public <results> = [ <yes> | <no> ];
```

该语法文件是根据JSGF [5]语法写的，它的作用是对照字典组成相关的词语或句子。在此，该语法仅定义了“yes”和“no”，因此，它仅能识别英文单词“yes”或“no”。不过，对于我们演示语言识别的例子来说足够了。

接下来设置如下Dialplan。这一次我们使用了flite作为TTS，并使用kal嗓音。play_and_detect_speech是一个App，它的作用是播放一段声音（声音文件或TTS文本）并进行语音识别。它的第1个参数是say:please say yes or no，用于指定播放的TTS文本；第2个参数是detect:pocketsphinx，表示使用pocketsphinx进行语音识别；第3个参数yes_no，指定一个语法文件（就是我们刚刚准备的那个）。当语音识别完成后，识别的结果将存入detect_speech_result通道变量中，同时使用log App将它的内容打印到日志中以便观察识别结果。完整的Dialplan设置如下：

```xml
<extension name="ASR">
    <condition field="destination_number" expression="^1234$">
        <action application="answer"/>
        <action application="set" data="tts_engine=flite"/>
        <action application="set" data="tts_voice=kal"/>
        <action application="play_and_detect_speech" data="say:please say yes or no detect:pocketsphinx yes_no"/>
        <action application="log" data="INFO ${detect_speech_result}"/>
    </condition>
</extension>
```

设置好上述Dialplan后，拨打1234便进入了语音识别程序。它将首先播放“please say yes or no”，当说了“yes”后，控制台上打印出如下的日志：

```
[INFO] switch_ivr_async.c:3718 (sofia/internal/1012@192.168.7.6) START OF SPEECH
[INFO] switch_ivr_async.c:3708 (sofia/internal/1012@192.168.7.6) DETECTED SPEECH
[INFO] mod_dptools.c:1602 <?xml version="1.0"?>
<result grammar="pizza_yesno">
  <interpretation grammar="pizza_yesno" confidence="100">
    <input mode="speech">yes</input>
  </interpretation>
</result>
```

其中，第1行START OF SPEECH表示PocketSphinx“听”到了有人说话；第2行DETECTED SPEECH表示识别出了说话的内容；从第3行可以看出，识别的结果是使用XML表示的，里面的yes（在第6行）即表示识别到的文本。

2. 中文语音识别

在中国，语音识别软件必须能识别出中文才有意义。接下来我们再看一看中文语音识别的例子。

（1）准备工作

我们需要先选择一个中文的声音模型，笔者选择了tdt_sc_8k，放到grammer/model目录下面；另外，还得有个字典文件，笔者选择了zh_broadcastnews_utf8.dic，放到grammar目录下面。在conf/autoload_configs/pocketsphinx.conf.xml中进行如下配置：

```xml
<param name="narrowband-model" value="tdt_sc_8k"/>
<param name="dictionary" value="zh_broadcastnews_utf8.dic"/>
```

字典文件本身有点大，笔者精简了一下，内容大致如下：

```
杜 d u
金 j in
房 f ang
令 l ing
狐 h u
冲 ch ong
乔 q iao
布 b u
斯 s if
孙 s un
悟 w u
空 k ong
中 zh ong
山 sh an
杜金房 d u j in f ang
令狐冲 l ing h u ch ong
乔布斯 q iao b u s if
孙悟空 s un w u k ong
孙中山 s un zh ong sh an
```

在此我们就不深入研究字典文件的意义了，读者大致也能明白上面首先是中文的字词，后面是相关的语素就可以了。除了字典文件外，我们还需要有一个语法文件，存放在grammar目录下，不妨取名为zh.gram。内容如下：

```
#JSGF V1.0;
/**
*JSGF Grammar for pizza_size names
*/
grammar names;
<du> = 杜;
<jin> = 金;
<fang> = 房;
<孙> = 孙;
<中> = 中;
<山> = 山;
public <jf> = <jin><fang>;
public <djf> = <du><jin><fang>;
public <szs> = <孙><中><山>;
```

该语法文件也是根据JSGF语法写的。准备好这些内容后，我们就可以写我们的语音识别脚本了。

`注意`

需要指出，本例中用到的部分语言模型及数据字典不是默认安装的，语音识别是一个相对专业的技术，而使用Pocketsphinx进行中文语音识别也没有完整的文档，感兴趣的读者如果需要按这里的内容进行实践的话，可以根据这里提供的关键字自行到互联网上搜索相关资源。

（2）语音识别Lua脚本

我们还是以Lua为例来介绍语音识别的脚本。首先，我们当然要先写一个log函数，以便知道脚本在运行过程中都发生了什么。内容如下：

```lua
function log(text)
    freeswitch.consoleLog("INFO", text);
end
```

然后，我们写一个onInput函数，实现在有输入的时候可以得到回调。在前面的例子中我们学过，当有用户DTMF输入时便可以调用回调函数。在语音识别中，当识别到用户的语音时，也可以回调相应的函数。如下面函数的前几行，当回调是由DTMF引起的时（第3行），便打印一条日志（第4行）并退出（第5行）：

```lua
01 function onInput(s, type, obj)
02     log("Callback type:" .. type)
03     if (type == "dtmf") then
04         log("DTMF: " .. obj.digit .. "\n")
05         return "break"
06     end
```

当检测到语音识别的结果时，回调的类型（type）将是event（第7行），obj即是实际的事件，我们可以在事件中取出Speech-Type的值（第8行）。

当Speech-Type值为begin-speaking时，说明系统检测到你说话了，我们便打印出事件的内容（第10行）。

```lua
07     if (type == "event") then
08         local event = obj:getHeader("Speech-Type")
09         if (event == "begin-speaking") then
10             log("\n" .. obj:serialize())
11             return ""
12         end
```

在实际的运行中，输出结果如下，可以从中看出Speech-Type：

```
Event-Name: DETECTED_SPEECH
Core-UUID: bf7f346e-25c8-498b-9a2c-8d0e5f70a266
FreeSWITCH-Hostname: seven.local
FreeSWITCH-Switchname: seven.local

FreeSWITCH-IPv4: 192.168.7.6
FreeSWITCH-IPv6: %3A%3A1
Event-Date-Local: 2013-11-21%2014%3A48%3A55
Event-Date-GMT: Thu,%2021%20Nov%202013%2006%3A48%3A55%20GMT
Event-Date-Timestamp: 1385016535584614
Event-Calling-File: switch_ivr_async.c
Event-Calling-Function: speech_thread
Event-Calling-Line-Number: 3860
Event-Sequence: 7705
Speech-Type: begin-speaking
```

当识别出语音时，Speech-Type的值就是detected-speech（第13行），然后我们在第14行将语音识别暂停（pause），代码如下：

```lua
13         if (event == "detected-speech") then
14             session:execute("detect_speech", "pause")
15             log("\n" .. obj:serialize())
```

同时我们看到，第15行打印了收到的事件的内容，实际运行效果如下（为节省篇幅，我们省略了一部分事件头）：

```lua
Event-Name: DETECTED_SPEECH
Speech-Type: detected-speech
Content-Length: 168
<?xml version="1.0"?>
<result grammar="zh">
  <interpretation grammar="zh" confidence="100">
    <input mode="speech">杜金房</input>
  </interpretation>
</result>
[INFO] switch_cpp.cpp:1293 Heard! CONFIDENCE = 100
[INFO] switch_cpp.cpp:1293 Heard: 杜金房
```

读者可以看到，实际识别到的内容是以XML描述的，其中confidence的值表示该语音识别程序有多大的把握保证它听到的是正确的，而真正的检测结果在input标签中（即这里的“杜金房”）。接下来，我们只需要用一个XML解析器解出相应的内容即可。下面的代码第16行将通过getBody函数取得XML，同样第17行将识别暂停，第19行使用XML解析函数getResults进而得出结果，并放入results变量中，然后打印日志，并在第23行用TTS进行回放。

```lua
16             if (obj:getBody()) then
17                 session:execute("detect_speech", "pause")
18                 local speech_ouput = obj:getBody()
19                 results = getResults(obj:getBody())
20                 if(results.score ~= nil) then
21                     log("Heard: CONFIDENCE = " .. results.score .. "\n")
22                     log("Heard: " .. results.text)
23                     s:speak("我听到您说的是" .. results.text .. "\n")
```

这里使用TTS把“听到”的内容再跟用户确认一遍，然后执行其他的动作，如根据姓名拨号，调用其他程序的接口控制其他设备等，具体的应用就看读者的想象力了。

本函数其他的代码不是很重要，但出于完整性起见，我们也把它们列在了下面（第24～37行）：

```lua
24                 else
25                     session:speak("对不起，我听不见你说话")
26                 end
27                 session:sleep(100)
28             end
29             return "break"
30         else
31             session:speak("对不起，我听不见你说话")
32             return "break"
33         end
34         return "break"
35     end
36     return "break"
37 end
```

在上面的代码中，我们没有考虑识别不成功的情况。在实际的应用中，如果在识别不成功时要重启识别，可以在代码中合适的地方使用session:execute("detect_speech","resume")实现。

当然，上面仅定义了回调函数，实际的动作是在下面执行的。其中，第43行安装了回调函数；第45行设置了TTS的参数；第46行开启语音识别，它有三个参数，分别表示使用pocketsphinx模块、使用中文（zh）语法文件，以及语法的路径（zh，在这里可以随便填，但不能为空）。第47行实际上是播放一个无限长的静音文件并等待你说话。代码如下：

```lua
38 results = {};
39 speech_detected = false;
40 speech_detected_dest = false;
41 session:sleep(1000);
42 session:answer();
43 session:setInputCallback("onInput");
44 session:sleep(200);
45 session:set_tts_params("tts_commandline", "Ting-Ting");
45 session:speak("请说出一个名字");
46 session:execute("detect_speech", "pocketsphinx zh zh");
47 session:streamFile("silence_stream://0");
```

前面我们讲过，有一些语音识别的参数是在mod_pocketsphinx的模块配置文件中配置的，如果需要动态配置，也可以直接使用detect_speech的params子命令实现。比如，下面代码就设置了另外一个声音识别模型：

```lua
session:execute("detect_speech","param narrowband-model zh_broadcastnews_ptm256_8000");
```

另外，我们在此省略了代码中的XML解析函数，读者可以参考http://lua-users.org/wiki/LuaXml尝试着自己写一个。

（3）测试语音识别

将上面讲的脚本存为asr.lua后可以使用如下Dialplan测试语音识别：

```xml
<extension name="ASR demo">
    <condition field="destination_number" expression="^1234$">
        <action application="answer"/>
        <action application="lua" data="asr.lua"/>
    </condition>
</extension>
```

当呼叫1234后，便听到语音提示你说出一个名字，此时你可以根据语法文件中的名字说几个来测试一下。测试的输出结果我们上面已经讲过了，在此就不赘述了。

### 通过商业语音识别软件进行识别

在上面的语音识别例子中，可能是由于笔者配置、调试得不够到位，识别率不是很高。为了给读者提供一个更生动的例子，笔者联系了Vestec [6]，他们同意提供一个试用的语音识别许可证。Vestec是加拿大的一家做语音技术的公司，他们的ASR产品支持很多种语言，其中一种就是汉语。

Vestec本身的安装和配置也不是太复杂，但需要花一些时间从各种文档里找到需要的信息，这不是一件轻松的事情。笔者在这里就不详细讲解各种细节了，仅将简单的安装过程罗列一下，以便读者参考。

Vestec支持多种Linux平台，笔者是在Ubuntu Linux 12.04上测试的，因此安装了如下的包：

```shell
# dpkg -i vasre-so_2.10.5.Ubuntu.1204-1_amd64.deb       #动态库

# dpkg -i vasre-server_2.10.5.Ubuntu.1204-1_amd64.deb   # ASR服务器

# dpkg -i vasre-rm_2.10.5.Ubuntu.1204-1_amd64.deb       # 资源管理（许可证等）

# dpkg -i vasre-mrcp_2.10.5.Ubuntu.1204-1_amd64.deb     # MRCP接口

# dpkg -i vasre-lang-zh-CN_2.5.2-1_all.deb              # 中文包
```

然后，将申请到的许可证文件license.lic放到/opt/Vestec/license目录中。

我们将使用MRCP接口连接语音识别服务。在默认的配置中，MRCP服务是监听在本地回环接口（127.0.0.1）上，因此我们需要修改/opt/Vestec/mrcp/conf/mrcpserver.xml中的IP地址，将其中的auto修改为实际的IP地址。然后启动以下服务：

```
# /etc/init.d/vasre-server start
# /etc/init.d/vasre-rm start
# /etc/init.d/vasre-mrcp start
```

至此Vestec ASR服务程序应该就可以正常工作了。在/opt/Vestec/mrcp/sample-freeswitch目录中有一些与FreeSWITCH集成的示例文件，可以进行测试，不过那些例子都是英文的，我们这里还是讲中文的例子。

Vestec配置好以后，下面就是配置FreeSWITCH端了。首先，我们需要配置mod_unimrcp模块。该模块提供MRCP协议的支持。MRCP协议有两个版本，V1使用RTSP，V2使用SIP，Vestec和FreeSWITCH对两个版本都支持。在这里，我们仅介绍一个V1版本的例子。在FreeSWITCH安装目录的conf/mrcp_profiles中创建vestec.xml文件，内容如下（其中server-ip为Vestec ASR MRCP服务器的IP，而rtp-ip为FreeSWITCH的IP，其他都是默认值）：

```xml
<include>
  <!-- UniMRCP Server MRCPv1 -->
  <profile name="vestec" version="1">
    <param name="server-ip" value="192.168.7.11"/>
    <param name="server-port" value="1554"/>
    <param name="resource-location" value=""/>
    <param name="speechsynth" value="speechsynthesizer"/>
    <param name="speechrecog" value="speechrecognizer"/>
    <param name="rtp-ip" value="192.168.7.6"/>
    <param name="rtp-port-min" value="4000"/>
    <param name="rtp-port-max" value="5000"/>
    <!--param name="ptime" value="20"/-->
    <param name="codecs" value="PCMU PCMA L16/96/8000"/>
    <!-- Add any default MRCP params for SPEAK requests here -->
    <synthparams>
    </synthparams>
    <!-- Add any default MRCP params for RECOGNIZE requests here -->
    <recogparams>
      <!--param name="start-input-timers" value="false"/-->
    </recogparams>
  </profile>
</include>
```

mod_unimrcp模块默认是不编译的，可以到FreeSWITCH源代码目录下编译安装它：

```
# make mod_unimrcp-install
```

然后，在FreeSWITCH中加载该模块：

```
freeswitch> load mod_unimrcp
```

接下来，还是使用我们在上一节讲的姓名识别的脚本，为了能让Vestec识别到我们的关键词，我们按它的语法规则（基于ABNF [7]）来生成一个语法文件ves-zh.gram放到grammar目录下，内容如下：

```
#ABNF 1.0;
language zh-CN;
tag-format <semantics/1.0-literals>;
root $Name;
$Name =
杜金房     {Seven Du}
    |   
孙中山     {Sun Yat-sen}
    |   
乔布斯     {Steve Jobs}
    |   
令狐冲     {Linghu Chong}
    |   
孙悟空     {Sun Wukong};
```

准备好上面这些以后，我们便可以进行测试了。在这里，我们还是使用上一节的Lua脚本，只是把ASR的调用参数修改为下面一行：

```
session:execute("detect_speech", "unimrcp:vestec ves-zh ves-zh");
```

其中，unimrcp:vestec指定我们新的ASR引擎，ves-zh则指定我们新的语法文件。接下来，就可以用类似上一节的方法测试了。在笔者的测试过程中，识别效果还是相当不错的。下面是识别结果的XML文件，与上一节比起来有一点小小的差别：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<result>
    <interpretation grammar="session:ves-zh" confidence="99">
        <input mode="speech" confidence="99">孙悟空</input>
        <instance confidence="99">
            <Name>Sun Wukong</Name>
        </instance>
    </interpretation>
</result>
```

另外，笔者也在Vestec的日志中发现，它对汉字发音的分析与我们上一节的语言模型有些差异，部分日志内容如下：

```
WARN  Auto-pron generates the pronunciation of 杜金房
INFO  杜金房: "d uw j ih n f ah ng"
WARN  Auto-pron generates the pronunciation of 孙中山
INFO  孙中山: "s uh n zh oh ng sh ah n"
WARN  Auto-pron generates the pronunciation of 乔布斯
INFO  乔布斯: "q ih ao b uw s ir"
WARN  Auto-pron generates the pronunciation of 令狐冲
INFO  令狐冲: "l ih ng hh uw ch oh ng"
WARN  Auto-pron generates the pronunciation of 孙悟空
INFO  孙悟空: "s uh n w uw k oh ng"
```

总之，测试结果还是令人满意的。而且，Vestec对FreeSWITCH开源社区也非常友好。如果读者对此有兴趣的话，也可以向他们申请测试的许可证。

除此之外，我们也在本节讲了mod_unimrcp的使用和配置，读者可以参照本节的内容配置与其他的TTS或ASR MRCP服务器对接。

[1] 当然，它的定义本身不是这么狭隘，语音识别强调的是理解声音的内容，而不单是转换成文字。 

[2] 参见http://www.speech.cs.cmu.edu/sphinx/doc/Sphinx.html。 

[3] 参见http://www.speech.cs.cmu.edu/pocketsphinx/。 

[4] http://wiki.freeswitch.org/wiki/Mod_pocketsphinx。 

[5] JSpeech Grammar Format，即JSpeech语法格式。参见 &lt;http://www.w3.org/TR/jsgf/&gt;。 

[6] 参见http://www.vestec.com。 

[7] Augmented Backus–Naur Form，扩充巴科斯-瑙尔范式，一种基于BNF的元语言。参见http://zh.wikipedia.org/wiki/扩充式巴斯科范式。

## 使用mod_xml_curl提供动态用户管理

在本章前面我们讲了一个使用Lua来绑定一个回调为FreeSWITCH提供XML Dialplan的例子，但Lua脚本的灵活性还是稍微差一点。因此，这里我们再来看一个用外部的脚本来提供XML用户目录的例子。

FreeSWITCH默认使用静态的XML文件配置用户，但如果要动态认证，就需要跟数据库相关联。FreeSWITCH通过使用mod_xml_curl模块完美解决了这个问题。它的实现思路是你自己提供一个HTTP服务器，当有用户有注册请求时（或INVITE或其他，总之需要XML的请求时），FreeSWITCH向你的HTTP服务器发送请求，你查询数据库生成一个标准的XML文件，FreeSWITCH进而通过这一文件所描述的用户信息对用户进行认证。

下面我们先来看一下脚本。该脚本是用PHP实现的，PHP的语法与C/C++以及Java都很类似，因此对于不熟悉PHP的读者来说，也很容易理解。

首先，在脚本的头部，我们从$_POST数组中取得请求参数，如user（用户）以及domain等，然后设置一个$password变量，值为1234。

```
<?php
  $user =  $_POST['user'];
  $domain = $_POST['domain'];
  $password = "1234";
?>
```

作为一个简单的例子，这里我们没有添加多少业务逻辑，下面的代码只是单纯返回了一个XML文件，在需要变量的地方便使用<?php echo$var;?>语法直接输出。

```xml
<document type="freeswitch/xml">
<section name="directory">
  <domain name="<?php echo $domain;?>">
    <params>
      <param name="dial-string" value="{presence_id=${dialed_user}@${dialed_domain}}${sofia_contact(${dialed_user}@${dialed_domain})}"/>
    </params>
    <groups>
    <group name="default">
      <users>
        <user id="<?php echo $user; ?>">
          <params>
            <param name="password" value="<?php echo $password; ?>"/>
            <param name="vm-password" value="<?php echo $password; ?>"/>
            </params>
          <variables>
            <variable name="toll_allow" value="domestic,international,local"/>
            <variable name="accountcode" value="<?php echo $user; ?>"/>
            <variable name="user_context" value="default"/>
            <variable name="effective_caller_id_name" value="FreeSWITCH-CN"/>
            <variable name="effective_caller_id_number" value="<?php echo $user;?>"/>
            <variable name="outbound_caller_id_name" value="$${outbound_caller_name}"/>
            <variable name="outbound_caller_id_number" value="$${outbound_caller_id}"/>
            <variable name="callgroup" value="default"/>
            <variable name="x-powered-by" value="http://www.freeswitch.org.cn"/>
          </variables>
        </user>
      </users>
    </group>
    </groups>
  </domain>
</section>
</document>
```

通过上述脚本便可以生成XML并返回给FreeSWITCH，然后FreeSWITCH再解析该XML并进行下一步的认证等操作。因为该脚本根本不查询数据库，也没有任何业务逻辑，任何注册或呼叫请求只要密码是1234就都能通过验证，因此我们可以把它称为万能脚本。当然，熟悉PHP的读者可以自己尝试添加一些if…else类的条件判断以针对不同的用户返回不同的XML，或者通过查询数据库构造不同的XML。

接下来，把上述PHP文件放到你的HTTP服务器上，并确保它能正确执行，然后修改conf/autoload_configs/xml_curl.conf.xml配置文件，增加一个binding，并将gateway-url的value值设成与你Web服务器与PHP对应的访问地址，并将bindings属性设为directory。笔者的示例配置如下：

```xml
<configuration name="xml_curl.conf" description="cURL XML Gateway">
  <bindings>
    <binding name="directory">
      <param name="gateway-url"
             value="http://localhost/~seven/freeswitch/directory.php"bindings= "directory"/>
    </binding>
  </bindings>
</configuration>
```

可以在源代码目录中使用如下命令编译安装该模块：

```
# mod mod_xml_curl-install
```

然后在FreeSWITCH控制台上加载该模块：

```
freeswitch> load mod_xml_curl
```

拿起你的SIP电话注册试一下吧，别忘了万能密码是1234。

如果在测试过程中遇到错误，试着看一看出错的内容，一般是HTTP服务器无法正常访问造成的。如果没有直接看到错误，也可以在控制台上打开mod_xml_curl的调试选项，如：

```
freeswitch> xml_curl debug_on
```

然后，FreeSWITCH会将每次请求得到的XML文件存放到文件名类似/tmp/xxx.xml的文件中，检查一下里面的内容是否跟你HTTP服务预期的输出是一致的。

## 使用mod_xml_cdr模块处理话单

与mod_xml_curl模块类似，mod_xml_cdr会在每次生成话单后请求一个HTTP服务器，然后HTTP服务器就可以进行一些逻辑处理和写入数据库等操作。在HTTP服务器端，用户可以使用任何熟悉的语言（如Java、PHP、Ruby、Python、C#等）来开发。

在本例中，我们将使用Ruby给大家讲解。之所以使用Ruby，是因为Ruby的语法比较易懂，讲起来也比较容易。Ruby语言之所以能发扬光大倒不是因为它的语法比较好，而是因为有个叫DHH [1]的人写了一个叫Ruby on Rails的开发框架，利用这个框架能迅速开发Web应用，从而使Ruby一时风靡Web开发领域。不过，我们在这里不使用Ruby on Rails，而是使用另外一个比较轻量级的框架Sinatra [2]。

使用Sinatra创建Web应用时能更快捷。笔者在这里选用它的另一个原因是，其不像PHP那样像个黑洞，它直接有个调试的控制台，可以很容易在日志中打印收到的内容。

Sinatra的安装很简单，如果你机器上已经有了Ruby环境，可以直接通过gem来安装，方法如下：

```
# gem install sinatra
```

先来看下面的代码。它的功能很简单，当收到“/cdr”的POST请求后，便在控制台上把请求信息中的“cdr”参数打印出来（Sinatra中所有的请求数据都在request对象中），然后返回一个纯文本的回应“CDR Saved”。

```ruby
require 'sinatra'
post '/cdr' do
    puts "cdr: #{request["cdr"]}"
    "CDR Saved\n"
end
```

把上面的代码保存到cdr.rb文件，然后便可以直接启动一个Web服务器了（下面我们称为CDR服务器）：

```ruby
$ ruby cdr.rb
INFO  WEBrick 1.3.1
INFO  ruby 1.9.3 (2012-04-20) [x86_64-darwin11.4.2]
== Sinatra/1.4.4 has taken the stage on 4567 for development
INFO  WEBrick::HTTPServer#start: pid=98950 port=4567
```

在日志中我们可以看到它监听了4567端口，然后，我们在另外的终端上使用curl工具给它发送一个HTTP POST请求（FreeSWITCH默认都是发送POST请求），我们就能收到“CDR Saved”回应了。

```shell
$ curl -XPOST -d cdr=test localhost:4567/cdr
CDR saved
```

同时，在CDR服务器的日志中也能看到“cdr:test”输出。接下来，修改FreeSWITCH中mod_xml_cdr的配置文件，将其中的url参数设为指向我们的CDR服务器：

```xml
<param name="url" value="http://localhost:4567/cdr"/>
```

然后在FreeSWITCH中重新加载一个mod_xml_cdr模块，并打一个电话测试，就能在CDR服务器日志中看到一大堆的XML。前面的一部分如下：

```xml
cdr: <?xml version="1.0"?>
<cdr core-uuid="bf7f346e-25c8-498b-9a2c-8d0e5f70a266">
  <channel_data>
    <state>CS_REPORTING</state>
    <direction>inbound</direction>
    <state_number>11</state_number>
    <flags>0=1;1=1;36=1;37=1;39=1;42=1;52=1;87=1;111=1;114=1</flags>
    <caps>1=1;2=1;3=1;4=1;5=1;6=1</caps>
  </channel_data>
  <variables>
    <direction>inbound</direction>
    <uuid>6c54299f-ad3b-4d5a-bd32-becbfd290cd2</uuid>
    <session_id>132</session_id>
    <sip_from_user>1006</sip_from_user>
    <sip_from_uri>1006%40192.168.7.6</sip_from_uri>
    <sip_from_host>192.168.7.6</sip_from_host>
```

知道了XML的结构，就很容易将其中有用的内容解析出来了，如主被叫号码、呼叫起止时间、通话时长等。

Ruby中有一个gem叫Nokogiri [3]，可以用于解析XML，我们可以用如下命令来安装：

```
# gem install nokogiri
```

接着，我们使用Nokigiri解析XML [4]，并通过XPath（对应doc对象的xpath方法）取得相关的内容，并打印出来，代码如下：

```xml
require 'sinatra'
require 'nokogiri'
post '/cdr' do
    doc  = Nokogiri::XML(request["cdr"])
    caller = doc.xpath("/cdr/variables/user_name//text()")
    dest = doc.xpath("/cdr/callflow/caller_profile/destination_number//text()")
    start_epoch = doc.xpath("/cdr/variables/start_epoch//text()")
    answer_epoch = doc.xpath("/cdr/variables/answer_epoch//text()")
    end_epoch = doc.xpath("/cdr/variables/end_epoch//text()")
    puts "caller: #{caller}"
    puts "dest: #{dest}"
    puts "start_epoch: #{start_epoch}"
    puts "answer_epoch: #{answer_epoch}"
    puts "end_epoch: #{end_epoch}"
    "CDR saved\n"
end
```

上述代码执行后，打一个电话，挂断后日志中的显示结果如下：

```
caller: 1006
dest: 9196
start_epoch: 1385041256
answer_epoch: 1385041256
end_epoch: 1385041257
```

其中，epoch为UNIX时间戳，即1970年1月1日0时0分0秒以来的秒数（不包括闰秒），这样插入数据库等操作就会比较容易实现，当然，为了方便阅读，可以取stamp相关的变量，如start_stamp。

当然，既然能打印出这些值，就很容易将其写入数据库了。在Sinatra中进行数据库操作也很简单，不过限于篇幅，我们在此就不多讲了。

[1] David Heinemeier Hansson，参见http://en.wikipedia.org/wiki/David_Heinemeier_Hansson。 

[2] 一个用Ruby写的轻量级的Web开发框架，参见http://www.sinatrarb.com/。 

[3] 一个Ruby的XML解析器，参见http://nokogiri.org/。 

[4] XPath即为XML路径语言（XML Path Language），它是一种用来确定XML文档中某部分位置的语言，参考http://zh.wikipedia.org/wiki/XPath及http://www.w3school.com.cn/xpath/。

## 小结

在本章的前面，我们主要以Lua脚本作为例子，讲了IVR、会议控制、外呼、网关连选以及通过Lua提供Dialplan的内容。通过这些例子，我们不仅复习、巩固了前面学过的知识，同时也穿插补充了一些新的知识，并带领大家初步领略到了Lua脚本的魅力。通过对XML Dialplan与Lua Dialplan以及使用Lua绑定提供的XML Dialplan的横向和纵向对比，读者应该能更深入理解这里的实现思路、方法和使用技巧。

接着，我们仍然以Lua脚本为例给出了语音识别的实例，并对两种语音识别的产品作了简单的对比。虽然由于篇幅限制我们没有写出一个完整的应用，但是抛砖引玉，有了这些基础知识读者就可以进行更深入的研究和学习了。

在后面的部分，我们还通过PHP和Ruby语言给出使用mod_xml_curl和mod_xml_cdr的例子。HTTP技术是很流行的技术，因此，FreeSWITCH通过使用HTTP接口就可以很容易跟其他系统集成。而且，经过这么多年的发展，HTTP技术已经是非常成熟了，它几乎可以很容易进行横向扩展，无论是从功能还是从性能上讲都不会有瓶颈。因此，我们也可以使用这些技术建立很庞大的FreeSWITCH集群。

PHP是比较流行的Web开发语言，Ruby可能比较小众，但使用Ruby进行开发和调试还是非常快速和方便的，即使你在工作环境中不使用Ruby，笔者也建议你花点时间准备几个Ruby脚本，以便快速调试与FreeSWITCH的集成。

对编程开发感兴趣的读者可以试着把我们前面的Lua脚本扩展一下，增加一些逻辑判断功能、与数据库的交互等。也可以试试用Ruby向FreeSWITCH提供XML数据，用PHP解析CDR并写入数据库等。通过实践可以帮你把学到的知识掌握得更加牢固。

