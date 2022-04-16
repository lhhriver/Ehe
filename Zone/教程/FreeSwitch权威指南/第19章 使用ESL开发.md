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
# 第18章 Event Socket
# 第19章 使用ESL开发

上一章我们学习了ESL，本章我们就趁热打铁再继续讲一些与ESL相关的例子。这些例子有的是从真实的项目中精简出来的，有的是为了讲了某些概念和方法精心编写的。我们在讲解的过程中也尽量以实际项目开发的方式将源代码纳入版本管理系统，并逐步修改和完善，以便读者更容易理解。ESL是一个客户端库，它主要用于对FreeSWITCH进行逻辑控制，因此，很多实际的功能还得靠我们前面讲过的App和API来完成。因此，如果读者在学习过程中注意复习和强化我们前面学习过的基本概念，并比较它与在Dialplan中及嵌入式脚本中使用方法的异同，学习本章必能事半功倍。同时，本章中的开发方式和方法也有助于理解和学习后面的章节，希望读者认真阅读和实践。

## 创建独立的ESL应用

在上一章，我们也讲了一些ESL的例子，但为了简单起见都是直接在FreeSWITCH源代码提供的例子上改的，也没有写自己的Makefile，这样有的读者在自己做项目的时候可能会觉得无从下手。下面我们就把ESL这一块从FreeSWITCH中独立出来。

当然，为了跟给读者讲清楚其中的原理，我们独立还是一步一步地进行。在进行下一步之前，我们先要为我们的新的项目起个名字，就叫myesl吧，虽然这个名字没有什么创造性。

### 创建目录和源文件

下面我们先尝试把实现我们自己业务逻辑的源文件分离出来。首先，创建一个叫myesl的目录，把我们相关的源代码都放到该目录里面。

然后，创建myesl.c文件，它的内容就直接把FreeSWITCH源码目录下的testclient.c中的内容原样复制过来即可，我们暂时不改源代码，主要是看一看怎么把它独立出来。既然我们原文件已经有了，下面就写一个Makefile，保存到相同的目录下，内容如下：

```makefile
ESLPATH = /usr/src/freeswitch/libs/esl
CFLAGS  = -I$(ESLPATH)/src/include
all: myesl.c $(ESLPATH)/libesl.a
    gcc $(CFLAGS) -o myeslmyesl.c $(ESLPATH)/libesl.a
```

其中，第1行在Makefile中定义一个变量，它即是ESL库所在的路径（笔者把FreeSWITCH的源代码放到/usr/src/freeswitch目录中）。第2行定义另一个变量，使用“-I”参数指定C语言头文件的位置，这一行还使用“\$()”引用了第1行中定义的变量ESLPATH。

第3行中的all，是一个目标（Target）。在Makefile中，默认会编译第一个目标，该目录依赖于myesl.c以及ESL的静态库文件libesl.a（所以libesl.a是必须存在的，即FreeSWITCH必须事先被编译过）。这样写的好处是，如果myesl.c已经编译过，那么在下次编译的时候就会检查它有没有变化，如果没有变化，则不用重新编译。这样做在单独一个源文件的时候影响不是很大（重新编译一次也费不了多少时间），但在编译比较大型的项目时，可能会有很多源文件，那么节省的时间就很可观了。

真正的编译动作是在第4行执行的，它调用gcc进行编译。命令行参数中，使用了“$(CFLAGS)”指定了头文件的位置；“-o”后面指定编译完成后生成的可执行文件的名称；myesl.c即是源文件；最后一个参数指定了ESL静态库的位置（libesl.a，注意ESL默认只生成静态库）。

### 编译和执行

一切准备好以后，接下来直接在控制台上输入make命令进行编译，编译完成后将产生myesl可执行程序，然后即可以直接执行看一下效果。下面是执行make以及我们新生成的myesl命令的输出结果：

```shell
$ make
gcc -I/usr/src/freeswitch/libs/esl/src/include -o myeslmyesl.c /usr/src/freeswitch/libs/esl/libesl.a
$ ./myesl
UP 0 years, 0 days, 4 hours, 26 minutes, 48 seconds, 650 milliseconds, 344 microseconds
FreeSWITCH (Version 1.5.8b git e7fe9aa 2013-11-25 00:45:51Z 64bit) is ready
0 session(s) since startup
0 session(s) - peak 0, last 5min 0
0 session(s) per Sec out of max 200, peak 0, last 5min 0
3000 session(s) max
min idle cpu 0.00/100.00
Current Stack Size/Max 240K/8192K
```

至此，便大功告成了。我们成功地把我们的ESL应用与FreeSWITCH源代码分隔开了，以后再也不用跟FreeSWITCH的源代码放到同一目录了。其实，编译ESL应用程序时，不需要依赖全部FreeSWITCH的源代码了，只需要依赖于ESL的头文件及静态库文件libesl.a。也就是说，ESL的源代码是可以单独存在的，可以将FreeSWITCH源代码目录中的libs/esl目录复制到别的地方，以后做ESL客户端应用时就不需要全部的FreeSWITCH的源代码了。

### 将源代码纳入版本控制

在开发过程中，我们经常会对源代码进行修改，因此需要有版本控制工具进行管理。FreeSWITCH是使用Git进行源代码管理的，大家在前面的学习中也熟悉了Git的复制操作，下面我们再带领大家熟悉一下其他的操作，到后面我们阅读FreeSWITCH源代码甚至进行FreeSWITCH开发的时候，将会用到更多的Git功能。

使用Git很简单，只需要在我们的myesl目录中执行如下三条命令：

第一条，初始化一个版本库，该版本库仅在当前目录中有效。

第二条，把我们新建的两个文件增加到版本库管理中来。

第三条，提交（commit）我们的修改，这两个文件便存入版本库，并产生一条提交历史。

具体的命令如下：

```
$ git init
$ git add Makefilemyesl.c
$ git commit -m 'initial commit' .
```

与SVN等版集中式的代码管理工具不同，Git的管理是分布式的，因此上述的提交操作仅在本地执行，如果需要与其他人共享，便需要将本地的代码库“推”（push）到远端去。Github是一个很好的源代码管理平台，对于开源项目是免费的。为了更好地与各位读者分享，我们也将我们的代码“推”上去。

具体的Github操作在此就不多讲了，笔者在Github上创建了一个远程版本库，它的地址是https://github.com/seven1240/myesl.git，下面首先在我们本地的代码库中用如下命令增加远程版本库：

```
$ git remote add origin https://github.com/seven1240/myesl.git
```

然后，就可以“推”了，命令和显示结果如下：

```shell
$ git push origin master
Counting objects: 4, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 658 bytes, done.
Total 4 (delta 0), reused 0 (delta 0)
To https://github.com/seven1240/myesl.git

*[new branch]      master -> master
```

推送成功后，就可以用浏览器访问https://github.com/seven1240/myesl来查看远程版本库的情况了 [1]。

读者感兴趣的话，也可以把该项目复制到本地计算机上，如下面是笔者测试的复制过程：

```
dujinfang@seven:~$ cd /tmp
dujinfang@seven:/tmp$ git clone https://github.com/seven1240/myesl.git
Cloning into 'myesl'...
remote: Counting objects: 7, done.
remote: Compressing objects: 100% (6/6), done.
remote: Total 7 (delta 0), reused 4 (delta 0)
Unpacking objects: 100% (7/7), done.
```

[1] 在首次查看的时候，该页面建议增加一个README，以让读者知道该项目是干什么的，此时读者就可以单击“创建”按钮在上面的网页上自动创建了。

## 用ESL重写空中充值服务

在17.3节我们讲过一个空中充值服务，当时是用Lua脚本实现的，下面我们来看一下在ESL中该怎么实现。

IVR类应用一般只涉及一个Channel，因此比较适合使用ESL的Outbound模式——即我们启动一个ESL服务器，当有新的呼叫到来时FreeSWITCH便会连接我们的ESL服务器。

在此，我们还是使用C语言作为例子。接着上一节的内容，在myesl目录中创建源文件charge.c。我们稍后再看如何改写Makefile，下面我们会先从代码看起。

`注意`：一般来说，在C语言程序中，被调用的函数写在前面，调用别的函数的函数则写在后面，这样就可以避免对所有的被调用的函数做前向声明。而在我们的程序中，main要调用前面的其他函数，所以我们把main函数写到最后。但从逻辑上看，程序是从main函数开始执行的，所以我们先从main函数开始看。

下面是我们的main函数入口，它比较简单。第188行定义main函数。第190行设置ESL日志级别，在此我们使用的是INFO级别，如果在调试的情况下，可以将日志级别改为ESL_LOG_LEVEL_DEBUG，这样便可以在控制台上看到大量日志输出。第191行使用esl_listen_threaded函数监听本地的一个8040端口，并阻塞等待连接到来。如果有新的连接到来，它就会启动一个新线程，并回调charge_callback函数 [1]。

```c
188  int main(void)
189  {
190    esl_global_set_default_logger(ESL_LOG_LEVEL_INFO);
191    esl_listen_threaded("localhost", 8040, charge_callback, NULL, 100000);
192    return 0;
193  }
```

charge_callback回调函数是在第161行定义的，当有新的连接到来时，它便在新的线程里执行。在函数的一开始，我们初始化了一个handle变量，用于标识一个ESL Socket连接，以及一个charge_helper结构体变量，用于记录充值过程中的一些数据。

```c
161  static void charge_callback(esl_socket_t server_sock, esl_socket_t client_sock, struct sockaddr_in *addr, void *user_data)
162  {
163    esl_handle_t handle = {{ 0 }};
164    esl_status_t status;
165    charge_helper_t charge_helper = { 0 };
```

接下来初始化charge_helper的值。第166行设置handle。第167行初始化当前的余额。第168行将充值状态机的当前状态设为CHARGE_WELCOME，即欢迎主菜单。

```c
166    charge_helper.handle = &handle;
167    charge_helper.balance = BALANCE;
168    charge_helper.state = CHARGE_WELCOME;
```

第169行将连接进来的Socket（client_sock）与我们这里的handle进行绑定，以后所有与FreeSWITCH的交互都通过该handle进行。第171行订阅我们需要的CHANNEL_EXECUTE_COMPLETE事件。第172行通过一个过滤器（filter）告诉FreeSWITCH，我们仅需要关注与本次通话（当前的Channel）相关的事件，而其他的事件一概不关心。注意该过滤器的作用不是过滤掉，而是“过滤进”，即过滤关键字（这里是Unique-ID）指定的是想要的内容，而不是不想要的内容。当然，为了取得当前通话的UUID，我们使用了esl_event_get_header函数从handle.info_event中取出。在有通话到来时，FreeSWITCH会首先发一个事件告诉我们的ESL程序该通话相关的信息，这些信息就存在handle.info_event变量中。另外，第173行我们还给FreeSWITCH发送linger API命令，通知FreeSWITCH如果电话挂机的话，“逗留”5秒后再将该Socket断开，以保证所有我们需要的事件都能收到。

```c
169    esl_attach_handle(&handle, client_sock, addr);
170    esl_log(ESL_LOG_INFO, "Connected! %d\n", handle.sock);
171    esl_events(&handle, ESL_EVENT_TYPE_PLAIN, "CHANNEL_EXECUTE_COMPLETE");
172    esl_filter(&handle, "Unique-ID",
           esl_event_get_header(handle.info_event, "Caller-Unique-ID"));
173    esl_send_recv(&handle, "linger 5");
174    esl_log(ESL_LOG_INFO, "%s\n", handle.last_sr_reply);
```

本函数中上面的语句都是当有电话进来时进行的一些初始化和准备工作，从第175行开始，就通过esl_execute函数在FreeSWITCH中执行一些App了，这些App的执行跟在Dialplan中是类似的。如第175行的answer表示对来话进行应答（必须先应答再放音），然后设置中TTS引擎的参数（第176～177行），并播放欢迎音（第178行）。

```c
175    esl_execute(&handle, "answer", NULL, NULL);
176    esl_execute(&handle, "set", "tts_engine=tts_commandline", NULL);
177    esl_execute(&handle, "set", "tts_voice=Ting-Ting", NULL);
178    esl_execute(&handle, "speak", "您好，欢迎使用空中充值服务", NULL);
```

下面是一个while循环，不断地从FreeSWITCH接收（esl_recv）事件，收到的事件将存到变量handle.last_event中，如果我们判断事件的类型（type）是“text/event-plain”（第181行），说明是一个我们订阅的事件，然后就可调用回调函数event_callback（第182行）进行处理。注意，这里我们收到的事件last_event是ESL对FreeSWITCH中事件的一个包装，我们需要的真正的事件在last_ievent中，所以后面将看到在第56行我们将事件指针event指向handle->last_ievent。

```c
179    while((status = esl_recv(&handle)) == ESL_SUCCESS) {
180      const char *type = esl_event_get_header(handle.last_event, "content-type");
181      if (type && !strcasecmp(type, "text/event-plain")) {
182        event_callback(&charge_helper);
183      }
184    }
```

如果上述while循环中接收失败（可能是Socket已断开），则循环结束，我们打印一行日志（第185行），并为了保险起见再调用一次esl_disconnect（第186行）断开Socket连接。该线程会退出。

```c
185    esl_log(ESL_LOG_INFO, "Disconnected! %d\n", handle.sock);
186    esl_disconnect(&handle);
187  }
```

可以看出，系统的关键部分在event_callback函数中。该函数我们稍后会讲到，现在为了理解该函数，我们从返回到文件开始处，从程序的第一行开始看。

在程序的一开始，先装入必要的头文件（第1～3行）以及定义几个宏（第4～13行）。其中，ENSURE_INPUT宏（第8～13行）比较长，它用于检查用户的输入是否为空，以避免遇到空指针引起崩溃。

```c
01  #include <stdio.h>
02  #include <stdlib.h>
03  #include <esl.h>
04  #define ERROR_PROMPT "say:输入错误，请重新输入"
05  #define BALANCE 100
06  #define CHARGE  100
07  #define set_string(dest, str) strncpy(dest, str, sizeof(dest) - 1)
08  #define ENSURE_INPUT(input) if (!input) { \
09    esl_execute(ch->handle, "speak", "再见", NULL); \
10    /* sleep(1); */ \
11    esl_execute(ch->handle, "hangup", NULL, NULL); \
12    return; \
13  }
```

接下来，我们定义几个结构。charge_menu_t是一个enum的类型，用于定义菜单项。其中，为了与用户输入按键相匹配，我们定义了一个无效的菜单CHARGE_MENU_NONE，它的值为0，那么后面的CHARGE_MENU_QUERY和CHARGE_MENU_CHARGE的值就可以与菜单项相应的按键（1和2）对应起来。使用enum类型的常量在C语言编程中是一个好的习惯，这样代码就比较易读。后面接着我们定义了一个charge_state_t类型，作为菜单中的状态机使用（注意由于C语言的编程方法不太一样，这里跟Lua脚本中的状态并不是一一对应的），它也是对enum的重定义。

```c
14  typedef enum charge_menu_s {
15    CHARGE_MENU_NONE,
16    CHARGE_MENU_QUERY,
17    CHARGE_MENU_CHARGE
18  } charge_menu_t;
19  typedef enum charge_state {
20    CHARGE_WELCOME,
21    CHARGE_MENU,
22    CHARGE_WAIT_ACCOUNT,
23    CHARGE_WAIT_ACCOUNT_PASSWORD,
24    CHARGE_WAIT_CARD,
25    CHARGE_WAIT_CONFIRM
26  } charge_state_t;
```

下面定义一个charge_helper_t类型，用于保存充值环节中数据。

```c
27  typedef struct charge_helper_s {
28    esl_handle_t *handle;
29    charge_state_t state;
30    charge_menu_t menu;
31    char account[20];
32    char card[20];
33    int balance;
34  } charge_helper_t;
```

get_digits函数用于从用户输入事件中获取输入的DTMF字符串。

```c
35  char * get_digits(esl_event_t *event)
36  {
37    char *digits = esl_event_get_header(event, "variable_digits");
38    if (digits) esl_log(ESL_LOG_INFO, "digits: %s\n", digits);
39    return digits;
40  }
```

下面的check_account_password和check_account_card函数只是用于硬编码的检查用户的账号、卡号、密码等 [2]。do_charge函数也只是简单地将余额与充值金额相加。这些函数在以后都可以扩充（如与数据库交互等）。

```c
41  int check_account_password(char *account, char *password)
42  {
43    return (!strcmp(account, "1111")) && (!strcmp(password, "1111"));
44  }
45  int check_account_card(char *account, char *card)
46  {
47    return (!strcmp(account, "1111")) && (!strcmp(card, "2222"));
48  }
49  int do_charge(int balance, int charge)
50  {
51    return balance + charge;
52  }
```

下面的event_callback函数（第53行）是一个回调函数，我们在每次收到相关的事件时，都会回调该函数。在该函数内，我们实现了一个简单的状态机，用于根据用户的输入进行各种判断，以决定执行哪个流程。

该函数的输入参数是一个charge_helper_t类型的指针ch，通过它可以取得相应的收到的事件，如第56行将event指针指向当前收到的事件。第57行是一行调试信息，我们暂时注释掉了，在用到的时候可以将注释去掉，以方便调试。第58行判断事件的类型，我们只接收CHANNEL_EXECUTE_COMPLETE类型的事件，其他事件一概不理。第59行我们将从当前事件中取得最后执行的App的名字，并赋值给application变量。

```c
53  static void event_callback(charge_helper_t *ch)
54  {
55    char *application = NULL;
56    esl_event_t *event = ch->handle->last_ievent;
57    /* esl_log(ESL_LOG_INFO, "event_id: %d\n", event->event_id); */
58    if (event->event_id != ESL_EVENT_CHANNEL_EXECUTE_COMPLETE) return;
59    application = esl_event_get_header(event, "Application");
60    esl_log(ESL_LOG_INFO, "State: %d App: %s\n", ch->state, application);
```

第61行用一个switch语句判断当前的状态。电话刚刚接入时将进入CHARGE_WELCOME状态，然后我们判断上一次执行的App是不是speak（注意，这里我们只有一个speak，如果前面执行多个speak，则需要更多的条件进行判断，以找到最后一个speak），如果是，则说明前面的欢迎音（第180行，后面会讲到）播放完了，便接着使用play_and_get_digits提示用户选择是查询还是充值，以进入相应的菜单。注意这里的play_and_get_digits与Lua中的用法有点差别，前者将收到的输入结果存入digits变量中，我们后续收到CHANNEL_EXECUTE_COMPLETE时便可以从事件的variable_digits头域中取得结果（如第37行所示）。当然，在这里我们只需要使用esl_execute（第66行）通知FreeSWITCH执行就行了，执行完毕后我们将在下次收到事件时获得用户输入。当然，我们事先在第65行将下一次的状态设为CHARGE_MENU，这样在下次收到事件后，我们将跳到第71行开始判断。

```c
61    switch(ch->state) {
62      case CHARGE_WELCOME:
63        if (!strcmp(application, "speak")) {
64  select_menu:
65          ch->state = CHARGE_MENU;
66          esl_execute(ch->handle, "play_and_get_digits",
67            "1 1 3 5000 # 'say:查询请按1，充值请按2' "
68            ERROR_PROMPT " digits ^\\d$", NULL);
69        }
70        break;
71      case CHARGE_MENU:
72        if (!strcmp(application, "play_and_get_digits")) {
73          char *menu = get_digits(event);
```

在收到用户输入后，我们将使用ENSURE_INPUT宏判断用户输入是否合法，如果不合法则立即播放“再见”并挂机。

```c
74          ENSURE_INPUT(menu)
75          if (!strcmp(menu, "1")) {
76            ch->menu = CHARGE_MENU_QUERY;
77          } else if (!strcmp(menu, "2")) {
78            ch->menu = CHARGE_MENU_CHARGE;
79          }
```

在获取到用户输入的菜单后（1或2），我们接着询问用户的账号（第81行），并将状态设为CHARGE_WAIT_ACCOUNT（第80行）等待下一次事件到来。

```c
80          ch->state = CHARGE_WAIT_ACCOUNT;
81          esl_execute(ch->handle, "play_and_get_digits",
82            "4 5 3 5000 # 'say:请输入您的账号，以井号结束' "
83            ERROR_PROMPT " digits ^\\d{4}$", NULL);
84        }
85        break;
86      case CHARGE_WAIT_ACCOUNT:
87        if (!strcmp(application, "play_and_get_digits")) {
88          char *account = get_digits(event);
89          ENSURE_INPUT(account)
90          set_string(ch->account, account);
```

当用户输入账号后，检查用户在上一步中选择的菜单项（已存到ch->menu变量中），并根据不同的菜单项决定下一步继续询问密码还是询问卡号。

```c
91          if (ch->menu == CHARGE_MENU_QUERY) {
92            ch->state = CHARGE_WAIT_ACCOUNT_PASSWORD;
93            esl_execute(ch->handle, "play_and_get_digits",
94              "4 5 3 5000 # 'say:请输入您的密码，以井号结束' "
95              ERROR_PROMPT " digits ^\\d{4}$", NULL);
96          } else if (ch->menu == CHARGE_MENU_CHARGE) {
97            ch->state = CHARGE_WAIT_CARD;
98            esl_execute(ch->handle, "play_and_get_digits",
99              "4 5 3 5000 # 'say:请输入您的充值卡卡号，以井号结束' "
100              ERROR_PROMPT " digits ^\\d{4}$", NULL);
101          } else {
102            ch->state = CHARGE_WELCOME;
103            esl_execute(ch->handle, "speak", "输入有误，请重新输入", NULL);
104          }
105        }
106        break;
```

在等待账户密码状态下，如果收到用户输入事件，则检查用户输入的账户、密码是否匹配（第111行）。如果匹配，则将下一步的状态设为CHARGE_WELCOME（第114行），以使播放完毕后重新进入主菜单，并播放当前余额（第115行）；如果用户输入错误（第116行），则播放错误提示，也转入主菜单。

```c
107      case CHARGE_WAIT_ACCOUNT_PASSWORD:
108        if (!strcmp(application, "play_and_get_digits")) {
109          char *password = get_digits(event);
110          ENSURE_INPUT(password)
111          if (check_account_password(ch->account, password)) {
112            char buffer[1024];
113            sprintf(buffer, "您的余额是%d元", ch->balance);
114            ch->state = CHARGE_WELCOME;
115            esl_execute(ch->handle, "speak", buffer, NULL);
116          } else {
117            ch->state = CHARGE_WELCOME;
118            esl_execute(ch->handle, "speak", "输入有误，请重新输入", NULL);
119          }
120        }
121        break;
```

如果用户当初选择了充值，则下面这一步将得到卡号（第124行）。如果用户输入的卡号是正确的（第126行），则播放提示音提示充值卡上的金额（第129行）。注意其中我们在第127行初始化了一个缓冲区，并在第128行写入一个字符串，这是C语言中拼接字符串的一种方式，为了避免缓冲区溢出需要保证缓冲区足够大（这里我们使用了1024字节）。接下来让用户确认是否充值（第132行），并将下一步的状态设为CHARGE_WAIT_CONFIRM等待用户输入结果。如果用户输入的号码有误（第135行），则转入主菜单。

```c
122      case CHARGE_WAIT_CARD:
123        if (!strcmp(application, "play_and_get_digits")) {
124          char *card = get_digits(event);
125          ENSURE_INPUT(card)
126          if (check_account_card(ch->account, card)) {
127            char buffer[1024];
128            sprintf(buffer, "您要充值%d元", CHARGE);
129            esl_execute(ch->handle, "speak", buffer, NULL);
130            /* sleep(2); */
131            ch->state = CHARGE_WAIT_CONFIRM;
132            esl_execute(ch->handle, "play_and_get_digits",
133              "1 1 3 5000 # 'say:确认请按1，返回请按2' "
134              ERROR_PROMPT " digits ^\\d$", NULL);
135          } else {
136            ch->state = CHARGE_WELCOME;
137            esl_execute(ch->handle, "speak", "输入有误，请重新输入", NULL);
138          }
139        }
140        break;
```

在等待用户输入状态下，如果用户按“1”确认，则进行充值（第147）操作，并向用户播报充值结果（第150行），播报完毕后，就可以返回主菜单了（第149行）。如果用户按“2”则放弃充值并返回主菜单。这时我们就会遇到一个问题：首先看第63行有一个验证，即最后执行的App必须是一个speak才能顺利往下走，我们前面返回主菜单前都使用了speak（如第117～118行、第136～137行），而此处用户输入“1”以后，显然在此播放任何语音都是不合适的，因此这里我们使用了C语言中的一个技巧，第153行使用goto语句直接跳转到在第64行定义的select_menu标签，并直接播放主菜单，而不用等待下一次事件的到来。虽然goto语句在C语言中一般是不推荐使用的，但是我们这里编写的是“不一般”的程序，而且到后面我们看FreeSWITCH源代码的时候，也能看到大量的goto语句。

```c
141      case CHARGE_WAIT_CONFIRM:
142        if (!strcmp(application, "play_and_get_digits")) {
143          char *confirm = get_digits(event);
144          ENSURE_INPUT(confirm)
145          if (!strcmp(confirm, "1")) {
146            char buffer[1024];
147            ch->balance = do_charge(ch->balance, CHARGE);
148            sprintf(buffer, "充值成功，充值金额%d元，余额为%d元", CHARGE, ch->balance);
149            ch->state = CHARGE_WELCOME;
150            esl_execute(ch->handle, "speak", buffer, NULL);
151          } else if (!strcmp(confirm, "2")) {
152            ch->state = CHARGE_WELCOME;
153            goto select_menu;
154          }
155        }
156        break;
157      default:
158        break;
159    }
160  }
```

到此为止，我们充值服务的所有代码都准备好了。接下来就需要编译运行了。为了编译运行新的充值服务程序，我们需要修改我们的Makefile，内容如下所示：

```makefile
ESLPATH = /usr/src/freeswitch/libs/esl
CFLAGS  = -ggdb -I$(ESLPATH)/src/include
all: myesl charge
myesl: myesl.c
    gcc $(CFLAGS) -o myeslmyesl.c $(ESLPATH)/libesl.a
charge: charge.c
    gcc $(CFLAGS) -o charge charge.c $(ESLPATH)/libesl.a
```

修改后的Makefile有3个Target——all、myesl和charge。其中all是默认的，但它又依赖于其他两个Target。如果在当前目录中执行Make，则它会先编译生成myesl，再编译charge。

编译完成后，将生成一个名为charge的可执行文件，它就是我们的“空中充值服务”程序。运行该程度后便监听8040端口，一旦有新的连接进来，便开启一个新线程为用户服务，用户挂机后线程退出。笔者拨打电话测试了查询菜单，日志输出如下（由于源文件中有空行，实际日志输出中的行号与代码中的行号不对应，为了读者参考方便对照源代码，笔者手动修改了日志中的行号）：

```
[INFO] charge.c:170 charge_callback() Connected! 4
[INFO] charge.c:174 charge_callback() +OK will linger 5 seconds
[INFO] charge.c:60 event_callback() State: 0 App: answer
[INFO] charge.c:60 event_callback() State: 0 App: set
[INFO] charge.c:60 event_callback() State: 0 App: set
[INFO] charge.c:60 event_callback() State: 0 App: speak
[INFO] charge.c:60 event_callback() State: 1 App: play_and_get_digits
[INFO] charge.c:38 get_digits() digits: 1
[INFO] charge.c:60 event_callback() State: 2 App: play_and_get_digits
[INFO] charge.c:38 get_digits() digits: 1111

INFO] charge.c:60 event_callback() State: 3 App: play_and_get_digits
[INFO] charge.c:38 get_digits() digits: 1111
[INFO] charge.c:60 event_callback() State: 0 App: speak
[INFO] charge.c:60 event_callback() State: 1 App: play_and_get_digits
[INFO] charge.c:185 charge_callback() Disconnected! 4
```

在本例中，我们使用了ESL的Outbound模式，即我们的程序启动后便作为一个ESL服务器程序监听一个TCP端口，而FreeSWITCH中有电话到来时，便主动连接我们的服务器程序。我们的服务器程序是多线程的，因而可以同时为多个用户服务。我们使用如下的Dialplan配置将来话送到我们的充值服务器：

```xml
<extension name="IVR Charge">
    <condition field="destination_number" expression="^1234$">
        <action application="socket" data="127.0.0.1:8040 full"/>
    </condition>
</extension>
```

注意，在这里我们使用了ESL的“同步”模式。在同步模式中，使用esl_execute执行App时是顺序进行的，只有等待一个执行完了才会执行下一个，因而编程比较简单（缺点是不能打断正在执行的App，如想打断一个正在播放长语音文件 [3]的App是无法实现的）。当然，有时我们可能也希望使用“异步”模式的ESL连接，那么可以在Dialplan配置中加入async参数，如：

```xml
<action application="socket" data="127.0.0.1:8040 async full"/>
```

当然，在使用了async参数的情况下，我们上述程序的第129行的执行就会出现问题，因为它会紧接着被132行的App抢占了。在出现这种问题时，需要等待第129行的App执行完毕后（收到CHANNEL_EXECUTE_COMPLETE事件）后再执行第131行的App。当然，那样就会在状态机中引入新的状态，代码就比较复杂了。因此，为了简单起见，我们在第130行使用了一个sleep函数暂停2秒。当然该行默认是注释掉的，仅在异步模式下才需要打开，同样的情况还有第10行。

至此我们的例子就结束了。从本例子中可以看出，使用C语言进行IVR编程也不是很复杂的，虽然代码行数与Lua相比大约增加了一倍。

[1] 注意，这段代码是基于FreeSWITCH 1.4版（Git master）的例子。回调函数中多了一个私有用户数据（user_data）参数，允许在main函数和回调函数间传递私有数据，虽然本例中我们没有用到私有数据。参见18.3.1节中C语言的例子。 

[2] 注意，strcmp函数在匹配成功时返回0（在C语言逻辑判断中为“假”），因而习惯用法是在前面加上一个“!”对0取反使之为“真”。这是该函数容易造成困扰的地方，好多Bug也是因此产生的。但这是一个不可避免的事实。 

[3] 注意，这里说的打断是指在ESL程序中打断，我们使用play_and_get_digits在任何时候都是可以使用DTMF按键打断当前播放的提示音的。

## 用ESL写一个ACD

在第12章中，我们讲了使用mod_fifo和mod_callcenter做呼叫中心的例子，但在实际使用中，还是有大量的用户会自己写业务逻辑进行座席分配（ACD）。既然我们已经学会了ESL，也不妨试着自己写一个。

在此我们还是使用Outbound模式来实现ACD。实现思路是——以来话用户为驱动，当有用户呼入时，查找是否有空闲座席，如果有，则转接到相应的座席上；如果没有，则进行忙等待，不断重试，直到找到一个空闲的座席或者用户挂机。

我们还是先从main函数开始看。首先，在第131行，它初始化了一个MUTEX，该变量是一个全局变量，用于多线程间的互斥（在第17行定义，我们后面还会讲到）；第132行，初始化一些座席，我们也将在后面讲到；第135行，进入监听，有呼入请求即在新线程中执行acd_callback。

```c
129  int main(void)
130  {
131      esl_mutex_create(&MUTEX);
132      init_agents();
133      esl_global_set_default_logger(ESL_LOG_LEVEL_INFO);
134      esl_log(ESL_LOG_INFO, "ACD Server listening at localhost:8040 ...\n");
135      esl_listen_threaded("localhost", 8040, acd_callback, NULL, 100000);
136      esl_mutex_destroy(&MUTEX);
137      return 0;
138  }
```

下面是我们的acd_callback函数。当有用户呼入时，首先在第64行和65行取出主叫用户的名称和主叫号码，并于第66行打印一条日志。在第67行，我们使用myevents命令通知FreeSWITCH我们希望收到与本Channel相关的所有事件。第74行设置的这个变量比较重要，它用于保证在呼叫座席失败时不挂断电话，同时我们也需要第75行，它用于在成功bridge后（即成功接通座席后），如果座席首先挂机，则挂断来话。在播放完欢迎音（第76行）后，我们将持续播放音乐（第77行），直到转到座席上。

```c
57  static void acd_callback(esl_socket_t server_sock,
            esl_socket_t client_sock, struct sockaddr_in *addr)
58  {
59      esl_handle_t handle = {{ 0 }};
60      esl_status_t status = ESL_SUCCESS;
61      agent_t *agent = NULL;
62      const char *cid_name, *cid_number;
63      esl_attach_handle(&handle, client_sock, addr);
64      cid_name = esl_event_get_header(handle.info_event, "Caller-Caller-ID-Name");
65      cid_number = esl_event_get_header(handle.info_event, "Caller-Caller-ID-Number");
66      esl_log(ESL_LOG_INFO, "New Call From \"%s\" <%s>\n", cid_name, cid_number);
67      esl_send_recv(&handle, "myevents");
68      esl_log(ESL_LOG_INFO, "%s\n", handle.last_sr_reply);
69      esl_send_recv(&handle, "linger 5");
70      esl_log(ESL_LOG_INFO, "%s\n", handle.last_sr_reply);
71      esl_execute(&handle, "answer", NULL, NULL);
72      esl_execute(&handle, "set", "tts_engine=tts_commandline", NULL);
73      esl_execute(&handle, "set", "tts_voice=Ting-Ting", NULL);
74      esl_execute(&handle, "set", "continue_on_fail=true", NULL);
75      esl_execute(&handle, "set", "hangup_after_bridge=true", NULL);
76      esl_execute(&handle, "speak", "您好，欢迎致电，电话接通中，请稍侯", NULL);
77      sleep(5);
78      esl_execute(&handle, "playback", "local_stream://moh", NULL);
```

第79行是一个while循环。我们将于第82行使用esl_recv_timed接收事件，如果在1000毫秒（即1秒）内收不到事件，则该函数返回ESL_BREAK，这样就保证了我们的循环体不会因为收不到事件而阻塞。第83行判断如果在1秒内没有收到任何事件（如果收到事件我们则优先处理事件），并且没有找到对该呼入用户进行服务的座席，我们就在第85行查找空闲座席。第86行，如果找到了一个空闲坐席，则在第89行使用break App中断当前正在播放的音乐（这种方式只能在async模式下才有效），并于第90行使用bridge去桥接找到的座席。当然，如果本次没找到空闲的座席，则在下一秒时还有机会查找，因此只要呼入的用户不挂机，当有座席闲下来时，总能找到一个座席。

```c
79      while(status == ESL_SUCCESS || status == ESL_BREAK) {
80          const char *type;
81          const char *application;
82          status = esl_recv_timed(&handle, 1000);
83          if (status == ESL_BREAK) {
84              if (!agent) {
85                  agent = find_available_agent();
86                  if (agent) {
87                      char dial_string[1024];
88                      sprintf(dial_string, "user/%s", agent->exten);
89                      esl_execute(&handle, "break", NULL, NULL);
90                      esl_execute(&handle, "bridge", dial_string, NULL);
91                      esl_log(ESL_LOG_INFO, "Calling: %s\n", dial_string);
92                  }
93              }
94              continue;
95          }
```

下面是事件处理程序，如果收到CHANNEL_BRIDGE事件，则说明已将来话与座席接通，这时我们要记住座席的UUID（第101行），并打印一条日志。如果收到CHANNEL_HANGUP_COMPLETE，则将还原当前座席的状态（置闲，第106行），并于第107行直接使用goto语句跳转到第125行的end标签，结束本次循环和本服务线程。

```c
96          type = esl_event_get_header(handle.last_event, "content-type");
97          if (type && !strcasecmp(type, "text/event-plain")) {
98              /* esl_log(ESL_LOG_INFO, "Event: %s\n",
                esl_event_get_header(handle.last_ievent, "Event-Name")); */
99              switch (handle.last_ievent->event_id) {
100                  case ESL_EVENT_CHANNEL_BRIDGE:
101                      set_string(agent->uuid, esl_event_get_header(handle.last_ievent, "Other-Leg-Unique-ID"));
102                      esl_log(ESL_LOG_INFO, "bridged to %s\n", agent->exten);
103                      break;
104                  case ESL_EVENT_CHANNEL_HANGUP_COMPLETE:
105                      esl_log(ESL_LOG_INFO, "Caller \"%s\" <%s> Hangup \n", 
                         cid_name, cid_number);
106                      if (agent) reset_agent(agent);
107                      goto end;
```

如果收到CHANNEL_EXECUTE_COMPLETE事件，则说明有一个App执行完了，如果该App是bridge的话（第110行），则该事件中可以找到variable_originate_disposition包含了bridge的结果，我们先把它取出放到disposition变量中（第111行）。如果disposition为CALL_REJECTED（第113行，拒接）或USER_BUSY（第114行，被叫忙），则说明呼叫座席失败 [1]，我们就于第115行重置该座席的状态，并于116行将当前座席设为NULL，以后在下次事件循环时可以有机会重新选择座席。

总之，到此为止，主要的业务逻辑都已经实现了。如果成功接通座席，则等待双方挂机后退出；如果未接通座席，则尝试重新查找座席。

```c
108                  case ESL_EVENT_CHANNEL_EXECUTE_COMPLETE:
109                      application = esl_event_get_header(handle.last_
                            ievent, "Application");
110                      if (!strcmp(application, "bridge")) {
111                          const char *disposition = esl_event_get_
                             header(handle.last_ievent,
                             "variable_originate_disposition");
112                          esl_log(ESL_LOG_INFO, "Disposition: %s\n", disposition);
113                          if (!strcmp(disposition, "CALL_REJECTED") ||
114                              !strcmp(disposition, "USER_BUSY")) {
115                              reset_agent(agent);
116                              agent = NULL;
117                          }
118                      }
119                      break;
120                  default:
121                      break;
122              }
123          }
124      }
125  end:
126      esl_log(ESL_LOG_INFO, "Disconnected! status = %d\n", status);
127      esl_disconnect(&handle);
128  }
```

到这里，让我们再回到程序的开始处。第6行定义了座席的状态，包括IDLE（空闲）和BUSY（忙），其他状态未用，只是作为一个例子，在实际的应用中座席会有更多的状态，如签入、签出、话后处理等。第11行定义了座席的结构体类型，它包括座席的分机号（exten）、通话中的UUID和座席当前的状态。

```c
 1  #include <stdio.h>
 2  #include <stdlib.h>
 3  #include <esl.h>
 4  #define MAX_AGENTS 3
 5  #define set_string(dest, str) strncpy(dest, str, sizeof(dest) - 1)
 6  typedef enum agent_state_s {
 7      AGENT_IDLE,
 8      AGENT_BUSY,
 9      AGENT_FAIL
10  } agent_state_t;
11  typedef struct agent_s {
12      char exten[10];
13      char uuid[37];
14      agent_state_t state;
15  } agent_t;
```

出于简单起见，我们定义了几个全局变量。第16行的座席数组用于存放座席，目前我们最大可以有3个座席（由第4行的宏限制）。第17行定义了一个MUTEX（互斥） [2]，由于我们是多线程的处理程序，当有多个电话同时呼入同时需要查找座席时，它用于保护临界区。第18行定义last_agent_index变量用于记录最后查询过的座席的位置，以支持轮循（Round Robin）的方式查找座席。在此，我们将它初始化为座席数组的最大值，以后它再启动会从第一个座席开始查。

```c
16  static agent_t AGENTS[MAX_AGENTS] = { { 0 } };
17  static esl_mutex_t *MUTEX;
18  static int last_agent_index = MAX_AGENTS - 1;
```

下面是初始化座席的函数，我们这里没有签入、签出等操作，因此所有的初始化操作都是硬编码的。在此我们初始化了三个座席：1000～1002。

```c
19  void init_agents()
20  {
21      set_string(AGENTS[0].exten, "1000");
22      set_string(AGENTS[1].exten, "1001");
23      set_string(AGENTS[2].exten, "1002");
24  }
```

下面我们实现了一个简单的查找空闲坐席的算法。第29行首先锁定临界区，以防止其他线程同时查找（其他线程将在临界区外等待）。第31行我们使用一个无限循环，从上一次查找过的座席的下一个开始查起（第32～37行保证agent指针永远指向下一个座席），如果找到空闲座席的话（第40行），则将当前座席置忙（第41行），并将当前座席的指针返回给调用者（第43行）。注意，在这里第42行是非常关键的，它将执行解锁操作，如果在返回之前忘记对临界区解锁的话，将会造成死锁。该函数在找不到空闲座席的情况下将会返回NULL（第48行）。

```c
25  agent_t *find_available_agent()
26  {
27      int last;
28      agent_t *agent

29      esl_mutex_lock(MUTEX);
30      last = last_agent_index;
31      while (1) {
32          if (last_agent_index >= MAX_AGENTS - 1) {
33              last_agent_index = 0;
34          } else {
35              last_agent_index++;
36          }
37          agent = &AGENTS[last_agent_index];
38          esl_log(ESL_LOG_INFO, "Comparing agent [%d:%s:%s]\n",
39              last_agent_index, agent->exten, agent->state == AGENT_IDLE ? 
                   "IDLE" : "BUSY");
40          if (agent->state == AGENT_IDLE) {
41              agent->state = AGENT_BUSY;
42              esl_mutex_unlock(MUTEX);
43              return agent;
44          }
45          if (last_agent_index == last) break;
46      }
47      esl_mutex_unlock(MUTEX);
48      return NULL;
49  }
```

下面函数用于把用完的座席还原，以便接听下一个电话（在下一次查找空闲座席时有机会找到它）。

```c
50  reset_agent(agent_t *agent)
51  {
52      esl_mutex_lock(MUTEX);
53      agent->state = AGENT_IDLE;
54      *agent->uuid = '\0';
55      esl_mutex_unlock(MUTEX);
56  }
```

至此，我们的ACD服务程序就写好了。编译后执行一下，日志输出如下。其中，第3行显示1006呼入。第6行找到空闲座席1000。第7行显示正在呼叫该座席。第8行显示被拒接，然后继续找到1001并呼叫（第9～10行），再次被拒接（第11行）后最终于在第14行呼通1002。座席挂机时第15行显示呼叫的结果为SUCCESS。第16行主叫挂机。第17行Socket中断线程并退出。

```c
01 $ ./acd
02 [INFO] acd.c:165 main() ACD Server listening at localhost:8040 ...
03 [INFO] acd.c:83 acd_callback() New Call From "1006" <1006>
04 [INFO] acd.c:86 acd_callback() +OK Events Enabled
05 [INFO] acd.c:88 acd_callback() +OK will linger 5 seconds
06 [INFO] acd.c:48 find_available_agent() Comparing agent [0:1000:IDLE]
07 [INFO] acd.c:114 acd_callback() Calling: user/1000
08 [INFO] acd.c:138 acd_callback() Disposition: CALL_REJECTED
09 [INFO] acd.c:48 find_available_agent() Comparing agent [1:1001:IDLE]
10 [INFO] acd.c:114 acd_callback() Calling: user/1001
11 [INFO] acd.c:138 acd_callback() Disposition: CALL_REJECTED
12 [INFO] acd.c:48 find_available_agent() Comparing agent [2:1002:IDLE]
13 [INFO] acd.c:114 acd_callback() Calling: user/1002
14 [INFO] acd.c:128 acd_callback() bridged to 1002
15 [INFO] acd.c:138 acd_callback() Disposition: SUCCESS
16 [INFO] acd.c:131 acd_callback() Caller "1006" <1006> Hangup
17 [INFO] acd.c:155 acd_callback() Disconnected! status = 0
```

在本例中，我们使用ESL的Outbound方式实现了一个简单的ACD程序。该程序必须使用ESL的async模式才能工作，即在Dialplan中需要进行如下设置：

```xml
<action application="socket" data="127.0.0.1:8040 async full"/>
```

另外，该程序与上一节的程序有许多相似之处，在细节上又有诸多不同，读者可以自己对比体会一下。

[1] 如果呼叫成功，disposition的值将是SUCCESS。当然你可以尝试修改第113～114行的判断条件，把所有非SUCCESS的值都认为是失败。 

[2] esl_mutex_t是ESL库中的一个简单的多线程互斥的实现，它实际上是对操作系统底层的实现的一个跨平的的封装，如在有pthread库的平台上使用pthread_mutex_t实现，在Windows平台上则使用CRITICAL_SECTION实现。

## 用Inbound模式实现IVR

上面讲到的例子大都是基于Outbound模式的，实际上Inbound模式也能完成同样的事情。下面我们仍以空中充值服务为例，来讲一下如何使用Inbound模式。这一次，我们把程序命名为icharge。

与Outbound模式不同，Inbound模式只跟FreeSWITCH建立一个Socket连接，即使有多路电话进来，所有的事件和控制命令也共享同一个Socket连接。当我们的服务程序接收到事件后，可以启用单线程处理，也可以启用多线程处理，但无论如何，Socket连接只有一个。两者的另一个不同之处我们在上一章也讲过，那就是Outbound模式的ESL程序是一个服务器，在逻辑上作为通话的一方参与到通话中；而Inbound式的ESL程序相对于FreeSWITCH来讲相当于一个客户端，它主动连接到FreeSWITCH上收取事件并进行命令控制，相当于一个第三者控制通话。那么，为了让这个第三者能感知的来话信息，我们可以使用如下Dialplan：

```xml
<extension name="Charge">
  <condition field="destination_number" expression="^1234$">
    <action application="set" data="service=icharge"/>
    <action application="park" data=""/>
  </condition>
</extension>
```

上述Dialplan的设计思路是：当有人拨打1234使用我们的icharge空中充值服务时，我们事先用set App设置一个service通道变量，然后将电话置为park状态。这样我们的icharge程序就可以在有电话进来时收到CHANNEL_PARK事件，并检查这里的service类型进行相应的处理。

通过前面的介绍，笔者想大家应该已经见识过了，C语言的代码比较冗长，因此，在这里我们不再实现完整的查询和充值服务，而只实现一个相对简单的查询功能，以节省篇幅。剩下的部分感兴趣的读者可以自己练习一下。

好了，我们这次将源代码命名为icharge.c，还是从main函数开始看。其中，我们于第74行通过esl_connect函数主动连接到FreeSWITCH上，该连接以后就通过handle来标识；第80行，订阅我们需要的事件，这样FreeSWITCH就会将相关的事件发给我们。

```c
68  int main(void)
69  {
70      esl_handle_t handle = {{ 0 }};
71      esl_status_t status;
72      const char *uuid;
73      esl_global_set_default_logger(ESL_LOG_LEVEL_INFO);
74      status = esl_connect(&handle, "127.0.0.1", 8021, NULL, "ClueCon");
75      if (status != ESL_SUCCESS) {
76          esl_log(ESL_LOG_INFO, "Connect Error: %d\n", status);
77          exit(1);
78      }
79      esl_log(ESL_LOG_INFO, "Connected to FreeSWITCH\n");
80      esl_events(&handle, ESL_EVENT_TYPE_PLAIN,
81          "CHANNEL_PARK CHANNEL_EXECUTE_COMPLETE CHANNEL_HANGUP_COMPLETE");
82      esl_log(ESL_LOG_INFO, "%s\n", handle.last_sr_reply);
```

第83行，我们设置本次连接的handle的event_lock成员变量为“1”，表示我们希望所有的App和事件都以同步的方式执行（类似于上面讲到的Outbound模式中的同步模式），这样我们需要处理的状态机就比较简单了。注意，这里为了简单仅实现了一个单线程的处理机制，因此不能使用sleep等浪费时间的函数，否则就会影响到其他的通话（我们用一个线程也可以处理几千个并发的呼叫）。

接着是一个while循环（第84行），它阻塞地接收事件，当有事件到来时，便使用process_event对事件进行处理。注意，由于ESL是双向的，有可能当程序正在向FreeSWITCH发送命令并等待FreeSWITCH返回结果时，正好收到一个事件，这时FreeSWITCH便会将收到的事件缓存到一个内部链表中，这里esl_recv_event的第二个参数为“1”，表示优先检查内部缓存链表，以防止错过事件。

```c
83      handle.event_lock = 1;
84      while((status = esl_recv_event(&handle, 1, NULL)) == ESL_SUCCESS) {
90          if (handle.last_ievent) {
91              process_event(&handle, handle.last_ievent);
92          }
93      }
94      esl_disconnect(&handle);
95      return 0;
96  }
```

下面我们可以倒回到文件开始处。最开始的部分跟19.1.3节讲到的类似，没什么特别需要注意的。

```c
01  #include <stdio.h>
02  #include <stdlib.h>
03  #include <esl.h>
04  #define ERROR_PROMPT "say:输入错误，请重新输入"
05  int check_account_password(const char *account, const char *password)
06  {
07      return (!strcmp(account, "1111")) && (!strcmp(password, "1111"));
08  }
```

主要的业务逻辑在process_event函数里。第12行，我们还是使用一个switch语句来判断收到的事件类型。如果收到CHANNEL_PARK事件（第13行），则我们首先检查service通道变量，如果它不存在或不等于icharge，说明它不是我们关心的业务类型，我们直接用break跳过后续的处理。否则，继续往下进行打印日志（第20行）、应答（第21行）、播放欢迎词（第24行）等。

```c
09  void process_event(esl_handle_t *handle, esl_event_t *event)
10  {
11      const char *uuid;
12      switch (event->event_id) {
13          case ESL_EVENT_CHANNEL_PARK:
14          {
15              const char *service;
16              service = esl_event_get_header(event, "variable_service");
17              esl_log(ESL_LOG_INFO, "Service: %s\n", service);
18              if (!service || (service && strcmp(service, "icharge"))) break;
19              uuid = esl_event_get_header(event, "Caller-Unique-ID");
20              esl_log(ESL_LOG_INFO, "New Call %s\n", uuid);
21              esl_execute(handle, "answer", NULL, uuid);
22              esl_execute(handle, "set", "tts_engine=tts_commandline", uuid);
23              esl_execute(handle, "set", "tts_voice=Ting-Ting", uuid);
24              esl_execute(handle, "speak", "您好", uuid);
25              /* esl_execute(&handle, "speak", "您好，欢迎使用空中充值服务", uuid); */
```

由于我们使用了handle->event_block，所以我们后面执行的App不会抢占前面的App，因而我们可以在这一步尽量多执行一些App（注意，App的执行在FreeSWITCH中是阻塞的，但在C语言这一端不是，所以不用担心这里会阻塞接收事件的线程）。

在此，我们没有在C语言中实现状态机，而是借用通道变量实现了一个简单的状态机。在第27行，我们设置通道变量charge_state的值为WAIT_ACCOUNT，即等待输入账号。当账号输入完毕后，再在第31行将该变量的值设为WAIT_PASSWORD，即等待输入密码。其中第28行和第32行分别实现询问账号和密码，这些语句在C语言这一端很快就执行完成了，但在FreeSWITCH中，会一个接一个地执行。在此过程中，我们将会收到一个又一个的CHANNEL_EXECUTE_COMPLETE事件。不过，并不是所有事件都进行处理，直到收到的事件中满足第44～45行的检查条件才处理。

```c
26  again:
27              esl_execute(handle, "set", "charge_state=WAIT_ACCOUNT", uuid);
28              esl_execute(handle, "play_and_get_digits",
29                  "4 5 3 5000 # 'say:请输入您的账号，以井号结束' "
30                  ERROR_PROMPT " charge_account ^\\d{4}$", uuid);
31              esl_execute(handle, "set", "charge_state=WAIT_PASSWORD", uuid);
32              esl_execute(handle, "play_and_get_digits",
33                  "4 5 3 5000 # 'say:请输入您的密码，以井号结束' "
34                  ERROR_PROMPT " charge_password ^\\d{4}$", uuid);
35              break;
36          }
37          case ESL_EVENT_CHANNEL_EXECUTE_COMPLETE:
38          {
39              const char *application;
40              const char *charge_state;
41              uuid = esl_event_get_header(event, "Caller-Unique-ID");
42              application = esl_event_get_header(event, "Application");
43              charge_state = esl_event_get_header(event, "variable_charge_state");
44              if (!strcmp(application, "play_and_get_digits") &&
45                  !strcmp(charge_state, "WAIT_PASSWORD")) {
```

第44～45行的检查条件是：收到CHANNEL_EXECUTE_COMPLETE，最后执行的App是play_and_get_digits，当前的状态是WAIT_PASSWORD。只有满足了这三个条件，我们才知道用户输入密码完成了。然后，我们在第46行和第47行分别取出用户输入的用户名和密码。如果用户名和密码检查（第48行）通过，我们就向用户播放当前的余额，然后挂机（第50～52行）。当然如果用户输入有误，我们也友好地告诉他（第54行），并使用goto语句（第55行）跳到第26行的again标签，让用户重新输入。

```c
46                  const char *account =
                        esl_event_get_header(event, "variable_charge_account");
47                  const char *password =
                        esl_event_get_header(event, "variable_charge_password");
48                  if (account && password && check_account_password(account, password)) {
49                      esl_log(ESL_LOG_INFO, "Account: %s Balance: 100\n", account);
50                      esl_execute(handle, "speak", "您的余额是100元", uuid);
51                      esl_execute(handle, "speak", "再见", uuid);
52                      esl_execute(handle, "hangup", NULL, uuid);
53                  } else {
54                      esl_execute(handle, "speak", "账号密码错误", uuid);
55                      goto again;
56                  }
57              }
58              break;
59          }
```

当收到用户挂机事件时（第60行），我们除了打印一条日志外（第62行）没有什么要特别处理的。

```c
60          case ESL_EVENT_CHANNEL_HANGUP_COMPLETE:
61              uuid = esl_event_get_header(event, "Caller-Unique-ID");
62              esl_log(ESL_LOG_INFO, "Hangup %s\n", uuid);
63              break;
64          default:
65              break;
66      }
67  }
```

至此，我们的icharge服务已准备完毕，编译运行后相关日志如下，读者可以对着源代码自行分析一下（当然，为了消除空行对行号的影响，日志中还是手工调整了行号）。

```
$ ./icharge
[INFO] icharge.c:79 main() Connected to FreeSWITCH
[INFO] icharge.c:80 main() +OK event listener enabled plain
[INFO] icharge.c:17 process_event() Service: icharge
[INFO] icharge.c:20 process_event() New Call 65aca71e-4ad0-42d9-a638-e25e7bd75890
[INFO] icharge.c:49 process_event() Account: 1111 Balance: 100
[INFO] icharge.c:62 process_event() Hangup 65aca71e-4ad0-42d9-a638-e25e7bd75890
```

在本例中，我们使用Inbound模式的ESL程序实现了我们的空中充值服务，并使用单线程处理多路通话。由于每一个呼入的Channel都有唯一的UUID，因此，对各路Channel的控制也互不影响。读者可能已经注意到了，在Outbound模式中，我们使用的esl_execute函数的最后一个参数值是NULL，而在Inbound模式中，我们指定了本路通话的UUID。原因就是，在Outbound模式中，是多个Socket连接，每个Channel对应一个Socket连接，因而不需要明确指定UUID（当然如果指定了也没错）；而在Inbound模式中，对所有的Channel的控制都是在同一个Socket上进行的，因而需要明确指定Channel的UUID。在我们这个简单的应用中，UUID可以动态地从事件中获取，因而我们不需要复杂的数据结构来保存这些UUID。

另外，读者可能也注意到了，我们在使用play_and_get_digits取得用户输入的账户和密码时，分别指定了charge_account和charge_password变量，这样就可以在后面一起取出（如第46行和47行），即可以通过这种方法把变量的值都保存到通道变量中，而不需要再在C语言中建立相关的数据结构来存储中间结果。

## 使用Java连接ESL

前面我们讲的都是C语言的例子，C语言是比较基础的语言，因而比较容易说明问题。然而，毕竟C语言比较底层，现在大多数的应用系统都是Java、Ruby、PHP、C#等高级语言开发的，因而更多的需要使用这些语言直接访问ESL。考虑到Java语言在企业应用开发中还是比较流行的语言，因此，本节我们一起来看一下它是如何跟FreeSWITCH交互的。

下面我们假定读者已经非常熟悉Java，并在主机上安装好了Java环境，对于不熟悉的读者，也可以通过该例子开拓一下视野，但对于基础的Java知识我们就不详细讲了。

FreeSWITCH的ESL通过Swig支持多语言，并使用JNI集成C与Java的接口。Java的ESL库是默认不编译的，如果要使用Java ESL，则需要手工进行编译。为了能让FreeSWITCH的编译脚本能找到你的Java安装路径，需要在configure阶段指定，如笔者主机上的Java路径是/opt/jdk1.7.0_45，则笔者在进行configure时按如下的方法指定Java路径：

```
./configure --with-java=/opt/jdk1.7.0_45
```

如果FreeSWITCH以前已经编译过，也可以不用再次运行configure，而是直接修改libs/esl/java目录下的Makefile，将LOCAL_CFLAGS中相关的路径修改为Java的安装目录。比如，笔者修改后的Makefile中相应的行是这样的：

```
LOCAL_CFLAGS=-I../src/include -I/opt/jdk1.7.0_45/include -I/opt/jdk1.7.0_45/include/linux -fPIC
```

修改完成后直接在libs/esl/java目录下执行make或在libs/esl目录下执行make javamod命令完成编译。编译完成后，会在java目录下生成libesljni.so和esl.jar，我们马上就会用到它们。

下面我们就创建一个Java项目，写一个简单的测试的类MyESLTest，并保存到文件MyESLTest.java中。该类的代码很简单，首先第一行导入Java ESL库中一类和函数；第4行在main函数中初始化一个事件变量（event）；在第5行装入ESL的JNI接口库（在此我们使用了绝对路径，如果将该库文件放入Java的库文件目录中，也可以使用相对路径）；第6行初始化一个连接conn，通过Inbound模式连接到FreeSWITCH上；第8行订阅全部事件；第10行在while循环中接收一个事件；第11行打印出事件的名字；当然也可以把第12行的注释去掉，让第11行打印整个事件。

```c
01  import org.freeswitch.esl.*;
02  public class MyESLTest {
03          public static void main(String [] args) {
04                  ESLevent event;
05                  System.load("/root/java/libesljni.so");
06                  ESLconnection conn = new ESLconnection("127.0.0.1",8021,"ClueCon");
07                  if (conn.connected() == 1) System.out.println("Connected");
08                  conn.events("plain","ALL");
09                  while (conn.connected() == 1) {
10                          event = conn.recvEvent();
11                          System.out.println(event.getHeader("Event-Name", -1));
12                          //System.out.println(event.serialize("plain"));
13                  }
14
15          }
16  }
```

在Java中使用的函数与C语言中都是类似的，只是命名和调用习惯不一样。在开发过程中可以参考libs/esl/java/org/freeswitch/esl/*.java文件中的接口定义。

Java源文件需要经过编译才能执行，如果你使用Java的集成开发环境，你需要引入esl.jar并进行编译，不过在此我们简单地写一个Makefile，然后使用make命令编译就可以了，Makefile内容如下：

```makefile
all:
        javac -cp esl.jar MyESLTest.java
clean:
        rm MyESLTest.class
```

编译完成后，将得到MyESLTest.class文件，然后，就可以使用下面的命令执行它了：

```
java -cp .:esl.jar MyESLTest
```

下面是该程序在笔者服务器上的输出结果：

```bash
root@server:~/java# java -cp .:esl.jar MyESLTest
Connected
HEARTBEAT
RE_SCHEDULE
RE_SCHEDULE
```

当然，该程序除了打印一些事件外什么也做不了，不过有了这个例子，相信很容易将FreeSWITCH集成到你现有的Java环境中了。更多的信息可以参考：http://wiki.freeswitch.org/wiki/Java_ESL。

除了标准的ESL库以外，还有一个基于异步IO的Netty框架的ESL库，有兴趣的读者，尤其是正在使用Netty框架进行开发的读者也可以研究一下：http://wiki.freeswitch.org/wiki/Java_ESL_Client。

## 使用Erlang控制呼叫流程

Erlang [1]是一门函数式编程语言。相比其他语言来说，它比较小众，但有着20多年历史的它一点也不年轻 [2]。它具有轻量级多进程、高并发、热代码替换等电信级的特性，并非常易于和适合于创建集群应用（Cluster）。更重要的是，它就是为了编写电信应运而生的，在云计算这个词异常火热的今天，Erlang编程语言更被赋予了新的意义。

在FreeSWITCH中有一个原生的模块mod_erlang_event，它作为一个隐藏的Erlang节点 [3]可以与任何Erlang节点通信。并且，它也实现了类似ESL中的Inbound和Outbound的通信模式。非常方便与其他Erlang系统集成。多年来，笔者一直从事FreeSWITCH以及与Erlang相关的开发，因此，本节的内容是必不可少的了。

### 准备工作

首先，对于对Erlang不熟悉的读者来说，我们简单补一补课。

在Erlang中，进程间通信靠消息和邮箱机制，一个进程可以给另外一个进程发消息，如下面的代码给一个进程（Pid）发送message消息（感叹号代码发送消息）：

```
Pid ! message
```

Erlang天生支持集群，每个Erlang实例就相当于集群中的一个节点，每个节点有一个名字，可以是短名字（如'name@localhost'），也可以是长名字（如'name@freeswitch.org'或'name@192.168.1.2'）。短名字的节点只能和短名字的节点进行通信，长名字的节点也只能与长名字的节点通信。在下面的例子中，FreeSWITCH节点的名字叫'freeswitch@loalhost'，而我们实现的Erlang节点的名字则叫'test@localhost'。

相互能通信的节点间可以互发消息，如使用如下代码可以给一个远程节点上的Pid进程发送消息：

```
{Pid, 'freeswitch@localhost'} ! hello
```

Erlang在变量全部以大写字母或下划线开头，以小写字母开头的则是常量，在Erlang中称为原子（atom）。原子可以作为进程的名字，也可以作为节点的名字。反过来讲进程的名字和节点的名字（如果有的话）必须是原子。所有以单引号括起来的字符串都是原子（而不管字每是大写还是小写）。

关于Erlang的基础知识我们就讲这些，有了这些知识，Erlang新手也能大体理解以下的内容了。当然如果读者有一定Erlang基础就更好了。

接下来，我们再准备一下Erlang的环境。

在FreeSWITCH中，与Erlang节点通信的模块是mod_erlang_event，该模块在FreeSWITCH安装时默认是不安装的，安装该模块要首先应确认你的机器上已经安装好Erlang的开发环境。笔者习惯通过源代码安装（从官方网站上下载源代码，解压后使用如下命令安装：./configure&&make&&make install），如果通过系统提供的管理工具安装的话请安装erlang-devel或erlang-dev包。

确认安装好Erlang环境以后，在FreeSWITCH源代码目录中重新执行./configure，以在产生的Makefile中能找到相关的Erlang环境。然后在FreeSWITCH源代码目录中执行下列命令安装mod_erlang_event：

```
# make mod_erlang_event-install
```

安装完成后，我们要对该模块进行配置。先检查配置文件，确认conf/autoload_configs/erlang_event.conf.xml中有以下三行（其他的行不动）：

```xml
<param name="nodename" value="freeswitch@localhost"/>
<param name="encoding" value="binary"/>
<param name="cookie" value="ClueCon"/>
```

其中第1行的nodename是为了强制限定FreeSWITCH节点的名字，如果不配置的话，FreeSWITCH会自己为节点起一个最适合的名字，但我们发现它自己起的名字并不总是正确的，因此在这里为了防止引起其他可能的错误，在此人工指定一个名字（注意这里我们使用了短名字，如果你的Erlang节点在另一台机器上，你应该使用长名字）。第2行，我们使用二进制编码。默认的节点间通信使用文本编码，文本编码比二进制编码效率要低一些。第3行，设置该节点的Cookie。注意要与Erlang节点的Cookie相同。

然后就可以在FreeSWITCH中加载该模块了，命令如下：

```
freeswitch> load mod_erlang_event
```

### 将来话交给Erlang处理

在此我们先讨论Erlang的Outbound模式。当有电话到来时，FreeSWITCH（可以看作一个客户端）会连接到你的Erlang程序节点（可以看作一个服务器）上，并把进来的电话控制权交给它。

在Dialplan中有两种设置方法：

```xml
<extension name="test">
    <condition field="destination_number" expression="^7777$">
        <action application="erlang" data ="ivr:start test@localhost"/>
    </condition>
</extension>
<extension name="test">
    <condition field="destination_number" expression="^7778$">
        <action application="erlang" data ="ivr:! test@localhost"/>
    </condition>
</extension>
```

我们把这两种方法分别称为“7777法”和“7778法”，下面对这两种方法进行介绍。

1. 7777法

在7777法里，如果你呼叫7777，FreeSWITCH会首先将当前的Channel置于挂起（park）状态，并给你的Erlang程序（test@localhost节点）发送一个RPC调用，调用的函数为ivr:start(Ref)。其中，ivr:start是在Dialplan中定义的，Ref则是由FreeSWITCH端生成的针对该请求的唯一引用。在Erlang端，start/1函数应该创建（spawn）一个新的进程，并且将新进程的PID返回给FreeSWITCH，FreeSWITCH收到该PID以后，便会将后续的所有与该Channel相关的事件都送给该进程。

Erlang端的代码如下所示。当收到FreeSWITCH的远程调用时，它将产生一个新进程，并在新的进程中运行loop()函数，同时原来的进程会将新进程的Pid（NewPid）返回给FreeSWITCH。

```erlang
start(Ref) ->
     NewPid = spawn(fun() -> loop() end),
     {Ref, NewPid}.
```

这是用Erlang控制呼叫的最简单的方法。任何时候来了一个呼叫，FreeSWITCH就发起一个远端RPC调用给Erlang，然后Erlang端启动一个新进程来控制该呼叫。由于Erlang的进程都是非常轻量级的，因而这种方式非常优雅。

我们将在后面再讨论loop()函数。

2. 7778法

除了使用RPC生成新的进程外，还可以用另外一种方法产生新进程。如上面的7778法对应的Dialplan所示，与7777不同的是，其中的ivr:start中的start被换成了“!”。该方法需要你首先在Erlang端启动一个进程，该进程监听所有进来的请求。当FreeSWITCH把电话路由到Erlang节点时，根据“!”语法的规定，FreeSWITCH会向Erlang发送一个{getpid,...}消息，意思是说：我这里来了一路电话，告诉我哪个进程（对应一个Pid）可以处理，我好把相应的事件发送给它。这种方法比上一种方法稍微复杂一些，但程序控制更加灵活。

如下面的代码，第一行的start函数必须事先执行，它在第2行注册一个有名字的进程（名字为ivr），然后进入wait()无限循环。

```
01 start() ->
02     register(ivr, self()),
03     wait().
```

在wait()循环中，当收到一个{get_pid,UUID,Ref,FSPid}消息时，表示FreeSWITCH中来了一路通话，它便在第7行启动一个新的进程（新的进程将调用loop()进行服务），并在第8行把该新进程的Pid（NewPid）发送给FreeSWITCH（FSPid）。然后在第10行重新进入wait()等待后续的请求。

```
04 wait() ->
05     receive
06         {get_pid, UUID, Ref, FSPid} ->
07               NewPid = spawn(fun() -> loop() end),
08               FSPid ! {Ref, NewPid},
09               io:format("Main Pid: ~p Child Pid: ~p~n", [self(), NewPid]),
10               wait();
11          _Any ->
12               wait()
13     end.
```

### 用Erlang实现空中充值服务

下面我们看一下Erlang版的空中充值服务是什么样子的。在此我们将使用“7777法”将呼叫转给Erlang处理。当有新呼叫到来时，新启动的进程将执行loop，并会立即收到一个初始的接通事件，该事件类似我们在C语言的ESL中收到的handle.info_event中的事件，它在Erlang中的消息格式是{event,[UUID|Event]}}，其中，UUID为当前Channel的UUID，Event是一个proplist，我们可以从中获取各种参数。

将我们的Erlang版的空中充值服务命名为echarge，则在Dialplan中使用如下设置便可以将来话路由到我们的Erlang节点了。

```xml
<extension name="test">
  <condition field="destination_number" expression="^7777$">
    <action application="erlang" data ="echarge:start test@localhost"/>
  </condition>
</extension>
```

下面我们来看代码。Erlang程序不像C语言那样需要前向声明，因而我们不必把被调用的函数放到最前面，故这一次我们终于可以从程序的第一行开始看了。

首先，第1行声明一个Erlang模块，它需要与文件名对应。第2行导出一个start函数，以便被FreeSWITCH远程调用。第3行定义了一个宏，表示FreeSWITCH所在的Erlang节点的名称。第4行的宏与C语言版本的类似。

```erlang
01  -module(echarge).
02  -export([start/1]).
03  -define(FS_NODE, 'freeswitch@localhost').
04  -define(ERROR_PROMPT, "say:
输入错误，请重新输入").
```

我们的start函数很简单，它使用了标准的7777法启动一个新进程，并执行loop()函数。

```erlang
05  start(Ref) ->
06      NewPid = spawn(fun() -> loop() end),
07      {Ref, NewPid}.
```

下面是我们的loop()函数。在第9行使用receive语句等待接收消息。第10行是它收到的第一个消息。收到消息后，它将打印该Channel的UUID（第11行），然后调用send_msg函数执行应答（第12行），并设置TTS参数。这些步骤都完成后，再调用send_lock_msg函数播放欢迎词（第15行）。

在这里，send_msg负责给FreeSWITCH发送一条Erlang消息，FreeSWITCH收到消息后便会立即执行它指定的App。send_lock_msg与C语言版本的ESL中的handle.event_locck=1的情况相似，主要是为了能让App顺序阻塞地执行。接下来，在第16行将执行一个函数询问账号和密码，我们稍后再来看该函数，现在只需要知道它与C语言版本中的调用play_and_get_digits类似。

在Erlang中，所有的消息都是异步的，因而上面所描述的操作都很快执行完了。接下来，它在第17行再次执行递归地调用loop()函数，并使用receive再次接收消息。Erlang也支持尾递归，因而不用担心消耗栈空间等。

```erlang
 8  loop() ->
 9       receive
10            {call, {event, [UUID | _Event]} } ->
11                 io:format("New call ~s~n", [UUID]),
12                 send_msg(UUID, answer, ""),
13                 send_msg(UUID, set, "tts_engine=tts_commandline"),
14                 send_msg(UUID, set, "tts_voice=Ting-Ting"),
15                 send_lock_msg(UUID, speak, "您好，欢迎使用空中充值服务"),
16                 ask_account_and_password(UUID),
17                 loop();
```

后续的消息格式都是类似第18行的格式（以call_event开头），在收到消息后，执行process_event()函数来进行处理。如果收到call_hangup消息，则表示电话已挂机，打印一条日志然后就不再进行循环了（不再执行loop()，该进程将会终止），否则在收到其他消息时（如第21、第23行）继续循环。

```erlang
18            {call_event, {event, [UUID | Event]} } ->
19                 process_event(UUID, Event),

20                 loop();
21            call_hangup -> io:format("Call hangup~n", []);
22            ok -> loop();
23            _X ->
24                 io:format("Ignoring message ~p~n", [_X]),
25                 loop()
26       end.
```

下面是我们询问账号和密码的函数，它还是类似19.2节所讲中的样子，在通道变量中设置当前充值流程的状态（charge_state），然后调用play_and_get_digits App收集信息。

```erlang
27  ask_account_and_password(UUID) ->
28       send_lock_msg(UUID, set, "charge_state=WAIT_ACCOUNT"),
29       send_lock_msg(UUID, play_and_get_digits,
30            "4 5 3 5000 # 'say:请输入您的账号，以井号结束' "
31            ?ERROR_PROMPT " charge_account ^\\d{4}$"),
32       send_lock_msg(UUID, set, "charge_state=WAIT_PASSWORD"),
33       send_lock_msg(UUID, play_and_get_digits,
34            "4 5 3 5000 # 'say:请输入您的密码，以井号结束' "
35            ?ERROR_PROMPT " charge_password ^\\d{4}$").
```

大部分业务逻辑都在process_event函数中实现的，当收到来自FreeSWITCH的消息时，便执行该函数。Erlang中的case语句类似C语言中的switch，因此在第41行使用case来判断收到的消息类型，我们比较关心CHANNEL_EXECUTE_COMPLETE（第42行），并且只有当满足第43行的条件时（当前状态为WAIT_PASSWORD并且当前的App为play_and_get_digits），我们才知道账号和密码已收集完毕。在第44和45行我们分别取到它们的值，然后在第46行调用check_account_password函数检查输入是否合法。如果输入无误（第47行），则向用户播放当前余额（第49行），并挂机（第51行）。否则，提示输入错误（第53行），然后在第54行重新调用ask_account_and_password询问用户名和密码（Erlang中没有goto语句，因而无法跳转，这也是我们把这一部分单独写成一个函数的原因）。

```erlang
36  process_event(UUID, Event) ->
37       Name = proplists:get_value(<<"Event-Name">>, Event),
38       App = proplists:get_value(<<"Application">>, Event),
39       State = proplists:get_value(<<"variable_charge_state">>, Event),
40       io:format("Event: ~s, App: ~s State: ~s~n", [Name, App, State]),
41       case Name of
42            <<"CHANNEL_EXECUTE_COMPLETE">> when
43                 State =:= <<"WAIT_PASSWORD">>, App =:= <<"play_and_get_digits">> ->
44                 Account = proplists:get_value(<<"variable_charge_account">>, Event),
45                 Password = proplists:get_value(<<"variable_charge_password">>, Event),
46                 case check_account_password(Account, Password) of
47                      true ->
48                           io:format("Account ~s Balance: 100~n", [Account]),
49                           send_lock_msg(UUID, speak, "您的余额是100元"),
50                           send_lock_msg(UUID, speak, "再见"),
51                           send_lock_msg(UUID, hangup, "");
52                      false ->
53                           send_lock_msg(UUID, speak, "账号密码错误"),
54                           ask_account_and_password(UUID)
55                 end,
56                 loop();
57            _ -> ok
58       end.
```

下面的函数与C语言中的类似，只是语法不同而已，它会返回true或false。

```erlang
59  check_account_password(Account, Password) ->
60       Account =:= <<"1111">> andalso Password =:= <<"1111">>.
```

下面几个函数都是与FreeSWITCH交互的消息，第62行为向FreeSWITCH节点发送一条消息，消息的内容主要在Headers参数中指定。读者可以在下面的代码中看到send_msg和send_lock_msg的不同。

```erlang
61  send_msg(UUID, Headers) ->
62       {sendmsg, ?FS_NODE} ! {sendmsg, binary_to_list(UUID), Headers}.
63  send_msg(UUID, App, Arg) ->
64       send_msg(UUID, [
65            {"call-command", "execute"},
66            {"execute-app-name", atom_to_list(App)},
67            {"execute-app-arg", Arg}
68       ]).
69  send_lock_msg(UUID, App, Arg) ->
70       send_msg(UUID, [
71            {"call-command", "execute"},
72            {"event-lock", "true"},
73            {"execute-app-name", atom_to_list(App)},
74            {"execute-app-arg", Arg}
75       ]).
```

在本例中，我们也是仅实现了空中充值服务中的查询部分。Erlang的代码看起来也很直观，而且我们没有依赖任何其他的库文件，完全是利用纯粹的Erlang消息与FreeSWITCH通信。将上述代码存为echarge.erl，然后在Makefile中加入如下配置：

```erlang
echarge: echarge.erl
    erlc echarge.erl
echarge-run:
    erl -PA . -setcookie ClueCon -sname test@localhost
```

然后执行make echarge就可以编译该文件了。编译完毕后，将产生echarge.beam文件。Erlang的概念跟Java相似，它也是在一个虚拟机上运行的，这里编译生成的.beam文件相当于Java的.class文件，也是跨平台的。

然后，使用make echarge-run启动一个Erlang节点，该节点的名字是test@localhost，以便FreeSWITCH能够在Dialplan中连接到它。用电话呼叫7777，部分日志如下：

```bash
$ make echarge-run
erl -PA . -setcookie ClueCon -sname test@localhost
Erlang R15B01 (erts-5.9.1) [source] [64-bit] [smp:8:8]...
Eshell V5.9.1  (abort with ^G)
(test@localhost)1> New call 4acb4e76-a7da-4b1b-bde0-0cc6921b4b77
Event: CHANNEL_PARK, App: undefined State: undefined
Event: CHANNEL_EXECUTE_COMPLETE, App: answer State: undefined
Event: CHANNEL_EXECUTE_COMPLETE, App: set State: WAIT_ACCOUNT
Event: CHANNEL_EXECUTE_COMPLETE, App: set State: WAIT_PASSWORD
Event: CHANNEL_HANGUP_COMPLETE, App: undefined State: WAIT_PASSWORD
Call hangup
```

### 用Erlang状态机实现空中充值服务

在上一节，我们使用了Erlang原始的消息收发机制控制FreeSWITCH。在实际的Erlang使用中，大部都是都使用OTP（Open Telecom Platform，开放电信平台）框架进行开发的。OTP框架定义了一些标准的通用开发框架，使得Erlang项目开发更标准，也更简单。gen_fsm就是其中的一个有限状态机（Finite State Machine）的实现。在本质上，IVR服务最适合使用状态机实现，因为业务流程本来就是在各种不同状态中迁移的。

下面我们就来看一看如何利用gen_fsm使我们的空中充值服务的代码看起来更优雅。由于使用了Erlang标准的状态机，因此我们不再依赖于在FreeSWITCH中绑定通道变量的状态机实现，而且我们也不再使用send_lock_msg之类的阻塞执行过程，而是让所有过程都是异步的。下面你会看到这一节在Erlang中实现起来是多么的简单和优雅。

首先，我们将服务命名为fsmcharge。代码第2行导出gen_fsm标准的函数。第3行导出所有的状态函数。我们还在第7行定义了一个LOG宏，用于输出带有行号的日志。

```erlang
01   -module('fsmcharge').
02  -export([start/1, init/1, handle_info/3, terminate/3]).
03  -export([welcome/2, wait_account/2, wait_password/2,
04      wait_play_balance/2, wait_play_goodbye/2, wait_hangup/2]).
05  -define(FS_NODE, 'freeswitch@localhost').
06  -define(ERROR_PROMPT, "say:
输入错误，请重新输入").
07  -define(LOG(Fmt, Args), io:format("~b: " ++ Fmt ++ "~n", [?LINE | Args])).
```

下面我们定义一条记录（Erlang中的Record），其中fsnode为FreeSWITCH的节点的名称，其他的字符也都很直观了，不多解释。这些字段本身没什么用，我们实现该框架是为了方便以后扩充。

```erlang
08  -record(state, {
09      fsnode           :: atom(),                 % FreeSWITCH node name
10      uuid             :: undefined | binary(),    % Channel uuid
11      cid_name         :: undefined | binary(),    % Caller id name
12      cid_number       :: undefined | binary()     % Caller id number
13  }).
```

第14行指出是在start函数中。在第15行调用了gen_fsm:start()产生了一个新进的gen_fsm进程，它将在新进程中回调第17行的init函数，可以在这里面进行一些初始化工作。init函数的返回值在第19行，其中第1个值ok表示初始化成功；第2个值welcome表示下一个状态，如果后续收到消息，则调用welcome函数；第3个值State是一个内部状态变量，用于记录一些东西，在此，我们只是记住了FreeSWITCH的节点名（第18行）。

```erlang
14  start(Ref) ->
15      {ok, NewPid} = gen_fsm:start(?MODULE, [], []),
16      {Ref, NewPid}.
17  init([]) ->
18      State = #state{fsnode = ?FS_NODE},
19      {ok, welcome, State}.
```

当第一个消息到来时，将回调welcome函数。第一个消息的格式如第21行粗体字部分所示。该在函数中，我们在第22～23行取出主叫的名称和号码，第24行写一条日志，然后应答，设置TTS参数等。在第28行发出播放欢迎词的消息后，即返回第29行的值。其中，第29行的第一个参数为next_state，它指定下一个状态；下一个状态的值在第2个参数中，还是welcome；第3个参数（在第30行）中的内部状态变量被更新了，填入了当前的主叫用户名称和号码。

```erlang
20  %% The state machine
21  welcome({call, _Name, UUID, Event}, State) ->
22      CidName = proplists:get_value(<<"Caller-Caller-ID-Name">>, Event),
23      CidNumber = proplists:get_value(<<"Caller-Caller-ID-Number">>, Event),
24      ?LOG("New Call \"~s\" <~s>", [CidName, CidNumber]),
25      send_msg(UUID, answer, ""),
26      send_msg(UUID, set, "tts_engine=tts_commandline"),
27      send_msg(UUID, set, "tts_voice=Ting-Ting"),
28      send_msg(UUID, speak, "您好，欢迎使用空中充值服务"),
29      {next_state, welcome,
30          State#state{uuid=UUID, cid_name=CidName, cid_number=CidNumber}};
```

当有后续的消息到来时，都将会继续回调welcome，但消息格式永远不会匹配到第21行。如果到来的消息匹配到第31行，那么说明有一个App执行完了。我们接着在第32行进行判断，如果完成的App是speak（第33行），则说明欢迎语已播放完毕，我们立即发送play_and_get_digits App以提示用户输入账号（第34行），这次我们的返回值在第37行，它的第2个参数变为wait_account，即以后不管收到什么消息都会回调wait_account函数（也就是说我们进入了下一个状态）。另外，第41行会匹配任何消息，它的意思是，如果在这过程中收到的消息与第21和第31行都不匹配，就执行该行，它什么也不做，返回的下一个状态与当前状态相同，即不发生任何状态转换。

```erlang
31  welcome({call_event, <<"CHANNEL_EXECUTE_COMPLETE">>, UUID, Event}, State) ->
32      case proplists:get_value(<<"Application">>, Event) of
33          <<"speak">> ->
34              send_msg(UUID, play_and_get_digits,
35                  "4 5 3 5000 # 'say:请输入您的账号，以井号结束' "
36                  ?ERROR_PROMPT " charge_account ^\\d{4}$"),
37              {next_state, wait_account, State};
38          _ ->
39              {next_state, welcome, State}
40      end;
41  welcome(_Any, State) -> {next_state, welcome, State}.
```

在wait_account状态下，我们仅会收到一个CHANNEL_EXECUTE_COMPLETE消息(第42行），就是第34行的执行结果，说明第34行的App已执行完毕，因而不需要再深入地去判断事件中的Application的值了，只需要继续发送下一个命令询问密码（第43行），并将下一个状态设为wait_password（第46行）。第47行的意思是不管收到任何不期望的事件，都不会发生状态转换。

```erlang
42  wait_account({call_event, <<"CHANNEL_EXECUTE_COMPLETE">>, UUID, _Event}, State) ->
43      send_msg(UUID, play_and_get_digits,
44          "4 5 3 5000 # 'say:请输入您的密码，以井号结束' "
45          ?ERROR_PROMPT " charge_password ^\\d{4}$"),
46      {next_state, wait_password, State};
47  wait_account(_Any, State) -> {next_state, wait_account, State}.
```

当用户输入密码完毕后，我们又收到一个CHANNEL_EXECUTE_COMPLETE，程序执行到第48行。此时，我们便可以在第51行检查账号和密码的有效性了。如果用户输入错误（第56行，注意这里我们先说错误的情况），则播放错误提示（第57行），然后将下一个状态变为welcome，下一次收到事件时将回到我们最开始的welcome状态，并回调welcome函数。

如果用户输入正确，则在第54行播放余额，并进入下一个状态wait_play_balance（第55行）等待播放完成。

```erlang
48  wait_password({call_event, <<"CHANNEL_EXECUTE_COMPLETE">>, UUID, Event}, State) ->
49      Account = proplists:get_value(<<"variable_charge_account">>, Event),
50      Password = proplists:get_value(<<"variable_charge_password">>, Event),
51      case check_account_password(Account, Password) of
52          true ->
53              ?LOG("Account: ~s, Balance: 100", [Account]),
54              send_msg(UUID, speak, "您的余额是100元"),
55              {next_state, wait_play_balance, State};
56          false ->
57              send_msg(UUID, speak, "账号密码错误"),
58              {next_state, welcome, State}
59      end;
60  wait_password(_Any, State) -> {next_state, wait_password, State}.
```

余额播放完毕后，回调第61行的函数，继续在第62行播放“再见”，并进入下一个状态wait_play_goodbye。

```erlang
61  wait_play_balance({call_event, <<"CHANNEL_EXECUTE_COMPLETE">>, UUID, _Event}, State) ->
62      send_msg(UUID, speak, "再见"),
63      {next_state, wait_play_goodbye, State};
64  wait_play_balance(_Any, State) -> {next_state, wait_play_balance, State}.
```

当“再见”也播放完成后，我们的程序会执行到第65行，这时没有其他事情要做了，我们便于第66行发送hangup命令通知FreeSWITCH挂机。为了记录一些信息，我们并没有立即退出进程，而是继续将状态转移到下一个状态wait_hangup等待挂机消息（第67行）。

```erlang
65  wait_play_goodbye({call_event, <<"CHANNEL_EXECUTE_COMPLETE">>, UUID, _Event}, State) ->
66      send_msg(UUID, hangup, ""),
67      {next_state, wait_hangup, State};
68  wait_play_goodbye(_Any, State) -> {next_state, wait_play_goodbye, State}.
```

当收到CHANNEL_HANGUP_COMPLETE，表示电话已经释放完成了。我们可以从该事件中取到呼叫时长（Duration）和计费时长（Billsec）等信息（第70～71行），打印出来（第72行）或（以后）写入数据库。当然，到此为止我们真的没有什么要留恋的了，因而这次的返回值中（第73行）第一个字段是stop，表示不再进行状态转移了，而是要结束本进程。

```erlang
69  wait_hangup({call_event, <<"CHANNEL_HANGUP_COMPLETE">>, _UUID, Event}, 
      State) ->
70      Duration = proplists:get_value(<<"variable_duration">>, Event),
71      Billsec = proplists:get_value(<<"variable_billsec">>, Event),
72      ?LOG("Call Ended, Duration: ~s Billsec: ~s", [Duration, Billsec]),
73      {stop, normal, State};
74  wait_hangup(_Any, State) ->
75      {next_state, wait_hangup, State}.
```

理论上讲不会执行到第76行，因为call_hangup消息是在CHANNEL_HANGUP_COMPLETE事件之后才发出发出的，而我们的进程已经终止了。但是，万一出现事件丢失的情况，多了这一层保障也是好的，我们还是会返回stop（第77行）。

注意，这里的call_hangup消息是在handle_info函数中收到的。在OTP中，一般来说所有原始的Erlang消息都是在handle_info函数中处理的。我们与FreeSWITCH之间是节点互联的关系，FreeSWITCH并不知道我们使用的是OTP框架，仍然给我们发送原始的Erlang消息。

```erlang
76  handle_info(call_hangup, _StateName, State) ->
77      {stop, normal, State};
```

所以，第78行就是FreeSWITCH发过来的所有消息的入口（除call_hangup之外）。在这里，我们收到消息后，取出事件的名字EventName（第79行），并重新组合成一个新的消息（第81行，我们把EventName放到消息中有助于在函数级别进行匹配），作为参数回调当前的状态函数（StateName）。

当然，第81行的实现属于一种取巧的方法。实际上真正的gen_fsm习惯是不使用第81行（可以注释掉），而使用第82行的gen_fsm:send_event函数再向自己（self）发送一次消息，并于第83行返回下一个状态（即当前的状态不做任何变化），让gen_fsm机制去回调当前的状态函数。当然，那样的话会多一次消息收发的过程，不是很高效，因此我们把第82行和第83行注释掉了 [4]。

```erlang
78  handle_info({EventType, {event, [UUID | Event]}}, StateName, State) ->
79      EventName = proplists:get_value(<<"Event-Name">>, Event),
80      ?LOG("State: ~s Event: ~s", [StateName, EventName]),
81      StateName({EventType, EventName, UUID, Event}, State);
82      % gen_fsm:send_event(self(), {EventType, EventName, UUID, Event}),
83      % {next_state, StateName, State};
84  handle_info(_Any, StateName, State) ->
85      {next_state, StateName, State}.
```

最后，将进程终止时，还是有机会进行回调清理一个现场的。如果进程正确终止，则回调第86行的函数；否则将回调第87或第91行的函数。如果是回调第87行，则说明进程是异常终止的（可以从_Reason参数中取得异常原因），这时最好是通知FreeSWITCH端挂机（第89行）。

```erlang
86  terminate(normal, _StateName, _State) -> ok;
87  terminate(_Reason, _StateName, #state{uuid = UUID}) when UUID =/= undefined ->
88      % do some clean up here
89      send_msg(UUID, hangup, ""),
90      ok；
91  terminate(_Reason, _StateName, #state{uuid = UUID}) -> ok;
```

其他的函数跟上一节讲过的一样，为了完整起见我们也列在这里。

```erlang
92  check_account_password(Account, Password) ->
93       Account =:= <<"1111">> andalso Password =:= <<"1111">>.
94  send_msg(UUID, Headers) when is_list(Headers) ->
95       {sendmsg, ?FS_NODE} ! {sendmsg, binary_to_list(UUID), Headers}.
96  send_msg(UUID, App, Arg) ->
97       send_msg(UUID, [
98            {"call-command", "execute"},
99            {"execute-app-name", atom_to_list(App)},
100           {"execute-app-arg", Arg}
101      ]).
```

下面是该程序的执行日志（有删节，并手工调整了行号）：

```bash
$ make fsmcharge-run
erl -PA . -setcookie ClueCon -sname test@localhost
Erlang R15B01 (erts-5.9.1) [source] [64-bit] [smp:8:8] ...
Eshell V5.9.1  (abort with ^G)
(test@localhost)1>
80: State: welcome Event: CHANNEL_DATA
24: New Call "1006" <1006>
80: State: welcome Event: CHANNEL_PARK
80: State: welcome Event: CHANNEL_EXECUTE_COMPLETE
80: State: wait_account Event: CHANNEL_EXECUTE
80: State: wait_account Event: CHANNEL_EXECUTE_COMPLETE
80: State: wait_password Event: CHANNEL_EXECUTE
80: State: wait_password Event: DTMF
80: State: wait_password Event: CHANNEL_EXECUTE_COMPLETE
66: Account: 1111, Balance: 100
80: State: wait_hangup Event: CHANNEL_HANGUP_COMPLETE
72: Call Ended, Duration: 17 Billsec: 17
```

在本节的例子中，我们采用了完全的状态机实现了IVR应用。虽然代码有点长，但Erlang的状态机实现得很优雅，代码看起来很清晰，而在前面的例子中，如果if…else之类的判断多了，就会感觉很乱。这种状态机在其他语言中应该也不难实现。

### 其他

在上面的例子中，我们都使用了Outbound模式的Erlang连接。其实，该模块也支持Inbound模式。

使用Inbound模式连接FreeSWITCH很简单，首先我们启动一个Erlang节点。下列命令实现的就是启动一个Erlang节点并进入一个Erlang Shell等待我们输入命令：

```erlang
$ erl -setcookie ClueCon -sname test@localhost
Erlang R15B01 (erts-5.9.1) [source] [64-bit] [smp:8:8] ...
Eshell V5.9.1  (abort with ^G)
(test@localhost)1>
```

接着输入给FreeSWITCH节点发送一个register_event_handler消息通知FreeSWITCH我们想在当前进程（Erlang Shell进程）中收取事件：

```erlang
(test@localhost)2> {event, 'freeswitch@localhost'} ! register_event_handler.
register_event_handler
```

这时在FreeSWITCH控制台上便能看到类似如下的Debug日志，提示有一个客户端节点test@localhost连接上来了：

```
[DEBUG] mod_erlang_event.c:2022 Launching listener, connection from node test@localhost, ip 127.0.0.1
[DEBUG] mod_erlang_event.c:1031 Connection Open from 127.0.0.1
```

然后，我们再向其发送{event,all}消息订阅全部的事件：

```
(test@localhost)3> {event, 'freeswitch@localhost'} ! {event, all}.
{event, all}
```

FreeSWITCH端的日志如下（这说明日志订阅成功了）：

```
[DEBUG] handle_msg.c:301 ALL events enabled
[DEBUG] handle_msg.c:314 enable event all
```

然后，在我们的Erlang节点上的Shell中输入“flush().”并按回车，就可以看到当前Shell收到的所有事件了，具体代码如下。其中，最初的两个“ok”消息是对我们上面发的两条消息的回复，如果这时候FreeSWITCH中产生了事件，我们也会一起看到。FreeSWITCH每20秒产生一次Heartbeat事件，因此笔者恰好收到了一次（下面只显示了一部分）：

```
(test@localhost)7> flush().
Shell got ok
Shell got ok
Shell got {event,[undefined,
          {<<"Event-Name">>,<<"HEARTBEAT">>},
          {<<"Core-UUID">>,<<"238c20ac-54fb-4312-a6b4-8819fb8a10ac">>},
          {<<"FreeSWITCH-Hostname">>,<<"seven.local">>},
          {<<"FreeSWITCH-Switchname">>,<<"seven.local">>},
          {<<"FreeSWITCH-IPv4">>,<<"192.168.7.6">>},
```

如果有时间，可以多打几次“flush().”试试，应该能一直不停地收到新的事件。

当然，我们也可以直接向FreeSWITCH发送一个API命令，如：

```
(test@localhost)3> {api, 'freeswitch@localhost'} ! {api, version, ""}.
{api,version,[]}
```

再次输入“flush().”将会看到以下结果。可以看出，FreeSWITCH除了返回version命令的结果外，还产生了一个API事件。

```
(test@localhost)4> flush().
Shell got {ok,<<"FreeSWITCH Version 1.5.8b+git~20131201T102929Z~558e484f05~64bit
(git 558e484 2013-12-01 10:29:29Z 64bit)\n">>}
Shell got {event,[undefined,
          {<<"Event-Name">>,<<"API">>},
          {<<"Core-UUID">>,<<"238c20ac-54fb-4312-a6b4-8819fb8a10ac">>},
          {<<"FreeSWITCH-Hostname">>,<<"seven.local">>},
          {<<"FreeSWITCH-Switchname">>,<<"seven.local">>},
          {<<"FreeSWITCH-IPv4">>,<<"192.168.7.6">>},
```

当然，上面是mod_erlang_event模块使用的原始消息格式。在该模块的源代码中，附带了一个freeswitch.erl文件，它包装了一些有用的函数，使用起来就方便多了。作为练习，我们可以将它复制到当前的目录，用以下命令编译它：

```
$ erlc freeswitch.erl
```

编译完成后将在当前目录下生成freeswitch.beam，使用如下命令可以启动一个新的Erlang节点，并加载当前目录（由参数“-pa.”指定）下所有的beam文件：

```
$ erl -pa . -setcookie ClueCon -sname test@localhost
```

然后，就可以直接使用freeswitch:api()进行API命令调用了，如：

```erlang
(test@localhost)1> freeswitch:api('freeswitch@localhost', version, "").
{ok,<<"FreeSWITCH Version 1.5.8b+git~20131201T102929Z~558e484f05~64bit
(git 558e484 2013-12-01 10:29:29Z 64bit)\n">>}
(test@localhost)2> freeswitch:api('freeswitch@localhost', show, "channels").
{ok,<<"\n0 total.\n">>}
```

更多的使用方法我们就不多解释了，读者可以自行参考一下freeswitch.erl文件中的注释以及该模块的Wiki页面：http://wiki.freeswitch.org/wiki/Mod_erlang_event。

[1] 参见http://www.erlang.org。 

[2] 参见http://www.erlang.org/course/history.html。 

[3] 即Hidden Node，它是一个标准的节点，但别的节点看不见它（形象一点的比喻，严格来说如果使劲看也能看得见），如果别的节点知道它的名字，则可以跟它通信。 

[4] 这一点初学者不需要过多深入研究，知道这一点以后就应该对OTP完全了解了。而且，笔者在生产环境中使用的是自己修改过的gen_fsfsm，这从根本上避免了多一次的消息发送，同时又符合OTP的使用习惯。

## 定时呼叫

在本章的最后，我们再讲一个定时呼叫的例子。定时呼叫类似于现有PSTN网络中的叫醒服务，但在FreeSWITCH中我们肯定能玩出更多的花样。在此我们仅举一个最简单的例子。

在UNIX类的系统中，使用crontab作定时服务，我们可以用它定时执行一个脚本或程序。它的设置非常灵活，因此我们几乎可以用它作任何定时。

在Shell中使用crontab-e命令可以启动一个编辑器编辑当前用户的crontab文件，我们输入以下内容并存盘：

```
0 6 * * * /usr/local/freeswitch/bin/fs_cli -x "originate user/1006 &playback(/tmp/wakeup.wav)"
```

以上内容中，以空格分隔的有多个域，前5个分别表示分钟、小时、月、日、星期，如果某个位置的值为“*”，则它可匹配任何值。如上述的定时就是每天早上的6点整执行后面的命令（如果是“0”则表示每小时整点执行一次，“*****”表示每分钟执行一次，以此类推）。

后面的命令实际上是使用fs_cli的-x参数执行一个FreeSWITCH的API，它的操作很简单，即呼叫用户1006，接通后播放声音文件/tmp/wakeup.wav叫用户起床。

如果想要执行的业务逻辑比较复杂（如未接听的情况下重呼，或得接听了但不按“1”就重呼），可以将逻辑放到一个Lua脚本中，用以下命令调用：

```
0 6 * * * /usr/local/freeswitch/bin/fs_cli -x "luarun /tmp/wakeup.lua"
```

具体的Lua脚本内容我们就不举例了。当然，如果觉得Lua不过瘾，也可以使用我们本章讲的ESL知识写一个ESL应用，如/tmp/esl_wakeup，然后可以通过如下配置执行：

```
0 6 * * * /tmp/esl_wakeup
```

总之实现定时呼逻辑应该不是很复杂的事，如果有需要，读者可自行练习。Windows系统上的用户也可以通过系统的定时任务定时执行程序或脚本，因为我们的实现方案是跨平台的。

## 小结

在本章，我们主要讲了使用ESL连接FreeSWITCH实现各种业务逻辑的例子。这些例子主要使用了C语言，因为C语言是一门基础语言，而且FreeSWITCH或ESL底层本身也是使用C语言实现的。在实现这些例子的过程中，我们还穿插着讲了一些Makefile以及系统编译的知识，所有的程序都是可以运行的，通过这些程序可方便读者进行实战演练。本章大部分例子都带有实际运行的结果和日志，以方便读者对照学习。

通过不同的例子，我们涵盖了ESL的Inbound及Outbound模式（以及同步及异步模式）的开发方法和实例，并尽量在不同的例子中使用不同的方法或调用不同的函数或参数，以尽量覆盖更多的内容。当然，由于篇幅限制，我们没有详细比较每一个细节的不同，这些需要读者多多实际练习和比较。

除了C语言外，我们还提供了Java和Erlang语言的例子，通过对这些语言的横向比较，读者可以对ESL的实现机制有一个更宏观的了解。理解了其中一种语言中的实现方法，就可对比理解其他语言。当然，再次由于篇幅限制，我们不可能覆盖所有编程语言，但希望这三种语言能覆盖大部分的用户。

在这些例子中，我们不厌其烦地、一遍又一遍地实现了我们的“空中充值服务”的例子，目的就是为了让大家在同一种语言的不同实现方式，以及不同语言的相同及不同实现方式下做一下横向的比较，以使读者更深入理解各种模式以及其优缺点，这样便能在以后使用时选择最好的实现方法。当然，不要在本章学了ESL就忘了前面的Lua，把我们的充值服务也跟Lua版的比较一下，看自己到底喜欢哪一种。

在本章的最后我们还讲了一个定时呼叫的例子，该例子非常简单，但也经常有网友问到。当然，笔者提供该例子的真正目的是让大家换一下思路，克服思维定势，不要钻到ESL中就拔不出来了。原来该问题还可以用crontab+shell实现，原来还可以配合Lua脚本实现更强的逻辑，原来……肯定还有好多连笔者也没想到的好方法。

本章在我们主要针对ESL的同时，其实我们还讲了许多开发设计的思路及需要注意的问题以及诸如多线程、状态机、节点、集群、日志、源代码版本控制等各种方面的知识，希望这些对读者有所帮助。另外，也希望本章的这些知识对理解我们后面章节中将要讲到的FreeSWITCH的源代码阅读及基于FreeSWITCH的开发有所帮助。

