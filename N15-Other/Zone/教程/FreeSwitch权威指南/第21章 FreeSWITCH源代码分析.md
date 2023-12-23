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
# 第20章 源代码导读及编译指南
# 第21章 FreeSWITCH源代码分析

在上一章，我们一起对FreeSWITCH核心源代码进行了简单分析，了解了FreeSWITCH源代码的大致结构和流程。在这一章，我们再结合实际的模块对源代码进行更深入的分析，来深入了解这些代码是如何协同工作的。

在上一章，我们带领大家从main函数开始看。但有的读者可能还是觉得比较“绕”——一大堆的代码、一大堆的函数调用，很快就把人绕晕了，看了半天还是不得要领。其实这也不怪读者，任何项目、任何代码，从不熟悉到熟悉，总要有一个过程。与代码的作者不同，代码的作者在开发的时候，代码是一行一行写成的，也是一步一步调试成功的，因此整个程序的结构全部在心里。而我们作为一个“外来人”再去看代码，就好像只看一栋盖好的大楼，想去了解其结构和建设过程一样，自然要困难得多。不过，幸运的是我们在上一章已经找到一个突破口——从main函数开始大致了解了总的框架结构。本章我们再来找一个突破口，这样一切就比较容易解决了。

## mod_dptools

在此我们找的突破口就是mod_dptools。该模块包含了系统绝大部分的App，其中就包括我们熟悉的answer（应答）和echo（回声）。不管干什么事情，从熟悉的地方入手，往往比较容易。接下来，我们看一看在源代码里能不能找到answer和echo。

### echo

我们先来找echo。通过使用全文搜索工具搜索源代码，我们很快就在mod_dptools.c中找到了一个函数定义——echo_function，它的代码只有下面短短的三行：

```
2048  SWITCH_STANDARD_APP(echo_function)
2049  {
2050      switch_ivr_session_echo(session, NULL);
2051  }
```

从上述代码中可以看出，echo_function这个函数是用SWITCH_STANDARD_APP宏来定义的。接着跟踪这个宏的定义，发现它是在switch_types.h:2081行定义的：

```
2081 #define SWITCH_STANDARD_APP(name) static void name
                (switch_core_session_t *session, const char *data)
```

因此，如果将上面的宏展开，那么echo_function的定义就是：

```
static void echo_function(switch_core_session_t *session, const char *data){
    switch_ivr_session_echo(session, NULL);
}
```

我们已经知道，每一路通话（一条腿）均有一个Session（即这里的session变量），每个App都是跟Session相关的，因而FreeSWITCH在调用每个App时，均会把当前的Session作为参数传入（一个session指针）。由于echo App没有参数，因而这里的data就是空字符串。当然，如果你在Dialplan中传入参数，如进行如下操作：

```
<application action="echo" data="some data"/>
```

那么，这里的char*data的值就是some data，只不过我们在此并不需要用到该参数，因而直接忽略掉了。

echo-function函数就直接调用核心提供的switch_ivr_session_echo函数，将收到的RTP包原样发回去。switch_ivr_session_echo函数我们在20.3.7节已经详细介绍了，这里就不重复了。

至此，是不是觉得整个呼叫流程一下子就串起来了？当然，如果还是没有这种感觉，我们继续往下看。

继续在mod_dptools.c文件中找echo_function，我们会发现下面一行：

```
5790 SWITCH_ADD_APP(app_interface, "echo", "Echo",
        "Perform an echo test against the calling channel",
echo_function, "", SAF_NONE);
```

它的作用是将我们刚刚定义的echo_function加到app_interface里（即核心的Application Interface指针）。

SWITCH_ADD_APP也是一个宏，它是在switch_loadable_modules.c:368行定义的：

```
368 #define SWITCH_ADD_APP(app_int, int_name, short_descript, \
369     long_descript, funcptr, syntax_string, app_flags) \
370     for (;;) { \
        app_int = (switch_application_interface_t *) \
        switch_loadable_module_create_interface(*module_interface, \
        SWITCH_APPLICATION_INTERFACE); \
371     app_int->interface_name = int_name; \
372     app_int->application_function = funcptr; \
373     app_int->short_desc = short_descript; \
374     app_int->long_desc = long_descript; \
375     app_int->syntax = syntax_string; \
376     app_int->flags = app_flags; \
377     break; \
378 }
```

这个宏定义得非常巧妙，它使用了一个无限的for循环，但由于该循环的最后一条语句是break，因此它只会执行一次。该循环跟Linux内核中的“do{...}while(0)”有异曲同工之妙（参见20.3.6节）。

该宏展开后的结果就相当于（为了易读我们去掉了行尾的续行符）：

```
for (;;) {
    app_interface = (switch_application_interface_t *)
        switch_loadable_module_create_interface(*module_interface, SWITCH_APPLICATION_
             INTERFACE);
    app_interface->interface_name = "echo";
    app_interface->application_function = echo_function;
    app_interface->short_desc = "Echo";
    app_interface->long_desc = "Perform an echo test against the calling channel";
    app_interface->syntax = "";
    app_interface->flags = SAF_NONE;
    break;
}
```

所以一个SWITCH_ADD_APP相当于使用switch_loadable_module_create_interface函数创建了一个SWITCH_APPLICATION_INTERFACE类型的接口（即我们所说的Application Interface）变量app_interface，然后给它赋予合适的值。大部分参数都是一些描述信息或帮助字符串，最重要的是下面两行，其确定了echo这个app_interface与我们定义的echo_function的对应关系。

```
app_interface->interface_name = "echo";
app_interface->application_function = echo_function;
```

因而，通过SWITCH_ADD_APP这个宏，相当于给系统核心添加了一个echo App，它对应源代码中的echo_function。这样每当系统执行到Dialplan中的echo App时，便通过这里的对应关系找到相应的函数入口，进而执行echo_function函数。

### answer

我们用同样的方法可以找到answer_function，代码不也不算长，因此我们也把它全部贴在这里：

```
1210  SWITCH_STANDARD_APP(answer_function)
1211  {
1212      switch_channel_t *channel = switch_core_session_get_channel(session);
1213      const char *arg = (char *) data;
1214
1215      if (zstr(arg)) {
1216          arg = switch_channel_get_variable(channel, "answer_flags");
1217      }
1218
1219      if (!zstr(arg)) {
1220          if (switch_stristr("is_conference", arg)) {
1221              switch_channel_set_flag(channel, CF_CONFERENCE);
1222          }
1223      }
1224
1225      switch_channel_answer(channel);
1226  }
```

跟echo_function类似，该函数也是使用SWITCH_STANDARD_APP定义的。我们知道，一个Session对应一个Channel。通过switch_core_session_get_channel函数便可以找当前与Session对应的Channel（第1212行）。

第1213行定义了一个arg指针，它指向answer的参数data。如果arg（即传过来的data）为空字符串（第1215行，zstr函数用于判断空字符串），则尝试查一下该Channel上有没有answer_flags这个通道变量，如果有（第1219行，其中switch_stristr类似于标准的stristr，不区分大小写），则判断该参数中是否包含“is_conference”，如果包含，则在该Channel上设置一个CF_CONFERENCE标志（该标志主要用于RFC4575/RFC4579描述的会议系统）。

最后，在第1225行调用核心的函数switch_channel_answer来对该Channel进行应答。

switch_channel_answer函数实际上是一个宏，在此使用一个宏的作用就是往函数中传入调用者的源文件名和行号信息，以便在日志中打印的文件名和行号是实际上调用该函数处的文件名和行号，而不是该函数实际定义处的行号（否则没有什么实际意义）。该宏展开后实际上是调用switch_channel.c:3693中的switch_channel_perform_answer函数。

在该函数中，它会首先在第3695行初始化一个msg变量，该变量是switch_core_session_message_t类型的，用于定义一条消息（Message）。然后，第3714～3715行初始化消息的内容，并于第3716行将消息发送出去，消息（Message）是与Core Event类似的另外一种消息传递（调用）方式，与Core Event不同的是，消息的发送总是同步进行的，因此这里的perform_receive_message实际上是直接调用各模块中接收消息的回调函数，我们在21.1.3节还会讲到。

```
3693  SWITCH_DECLARE(switch_status_t) switch_channel_perform_answer(
        switch_channel_t *channel, const char *file, const char *func, int line)
3694  {
3695      switch_core_session_message_t msg = { 0 };
...
3714      msg.message_id = SWITCH_MESSAGE_INDICATE_ANSWER;
3715      msg.from = channel->name;
3716      status = switch_core_session_perform_receive_message(channel->session, 
              &msg, file, func, line);
```

如果消息发送成功，就在第3720行将该Channel的状态置为已经应答的状态。

```
3719      if (status == SWITCH_STATUS_SUCCESS) {
3720          switch_channel_perform_mark_answered(channel, file, func, line);
```

实际上，如果这里的Channel是一个SIP通话的话，FreeSWITCH中的mod_sofia Endpoint模块便会调用底层的Sofia-SIP协议栈（libsofia）给对方发送“200 OK”的SIP消息。

answer_function也是由SWITCH_ADD_APP宏安装到核心中去的。

### set

FreeSWITCH中大量使用通道变量控制通话（Channel）的行为。设置通道变量的操作是由下面的set App实现的。该函数出奇的简单，因为它直接调用了另外一个函数base_set。

```
1439 SWITCH_STANDARD_APP(set_function)
1440 {
1441     base_set(session, data, SWITCH_STACK_BOTTOM);
1442 }
```

base_set其实会被多个函数调用，在此我们只关心它被set_function调用的情况。为了更直观，我们通过实际的例子来说明。假设我们在Dialplan中使用如下配置：

```xml
<action application="set" data="dialed_extension=$1"/>
```

其中，$1为前面的正则表达式的匹配结果，它是一个变量（我们假设它的值为1001）：

```
1375   static void base_set (switch_core_session_t *session,
                             const char *data, switch_stack_t stack)
1376  {
1377      char *var, *val = NULL;
```

在第1385行，会通过switch_core_session_strdup将字符串复制一份。该函数是在session上进行操作的，它会使用该session的内存池申请字符串空间，因而申请以后的内存无需明确释放。为什么要重新复制一份字符串呢？是因为我们接下来的操作会修改该字符串的内存（如第1392行），因而复制一份可以避免破坏原来的字符串所占的内存空间。到此，我们的var变量的值就是“dialed_extension=$1”了。

```
1385          var = switch_core_session_strdup(session, data);
```

接下来，第1387行判断字符串是否包含等号，在我们的例子里有等号，因此val指向等号所在的内存位置，也可以说val指针所指的字符串值为“=$1”。

```
1387          if (!(val = strchr(var, '='))) {
1388              val = strchr(var, ',');

1389          }
```

如果val非空（第1391行），则在第1392行将val所指的位置写入“\0”（即C语言中的字符串结束符），并将val指针向后移动一个字节，此时它的值就是“$1”了。同时，由于我们将原字符串中的等号替换改成了“\0”，因此，var所指向的字符串的值也相当于变短了，此时var的值为“dialed_extension”。

```
1391          if (val) {
1392              *val++ = '\0';
1393              if (zstr(val)) {
1394                  val = NULL;
1395              }
1396          }
```

第1398行，继续判断如果val为非空（因为已经移动了指针，所以要重新判断），则执行第1399行的函数，就是将val指针中的$1变量替换为它的实际的值。在这里，我们将在expanded变量中得到实际的值是“1001”。

```
1398          if (val) {
1399              expanded = switch_channel_expand_variables(channel, val);
1400          }
```

第1404行将调用函数在Channel上设置我们指定的新变量：

```
1404          switch_channel_add_variable_var_check(channel,var, expanded, 
                 SWITCH_FALSE, stack);
```

它等价于：

```
switch_channel_add_variable_var_check(channel,"dialed_extension", "1001", 
    SWITCH_FALSE, stack);
```

当然，最后不要忘记，expanded指针所指向的内存是动态申请的，因此一定要释放内存，以避免引起内存泄漏。

```
1406          if (expanded && expanded != val) {
1407              switch_safe_free(expanded);
1408          }
```

虽然这里我们讲得比较啰嗦，但实际的过程还是非常简单的。我们接着看一看第1404行调用的switch_channel_add_variable_var_check函数到底都干了些什么。

该函数定义于switch_channel.c:1400。它在第1407行先对临界区加锁，以防止其他并发的线程同时修改。然后，经过一系列的判断和检查，如果最终所有检查都通过（第1417行），则在第1418行调用switch_event_add_header_string函数将通道变量添加到channel->variables中去。该函数与我们在18.3.1节讲过的esl_event_add_header_string类似，它实际上是向一个switch_event_t类型的结构体中添加数据，所以这里可以看到，channel->variables在内部是使用switch_event_t来存储的。这也不奇怪，因为通道变量本来就是一对“键/值”对（varname和value）。

```
1400  SWITCH_DECLARE(switch_status_t) switch_channel_add_variable_var_check(
            switch_channel_t *channel,
1401        const char *varname, const char *value,
            switch_bool_t var_check, switch_stack_t stack)
1402  {
...
1407      switch_mutex_lock(channel->profile_mutex);
...
1417              if (ok) {
1418                  switch_event_add_header_string(channel->variables,
                          stack, varname, value);
```

当然，永远不要忘了释放锁：

```
1425      switch_mutex_unlock(channel->profile_mutex);
```

至此，set函数就全部剖析完了。通过它设置的通道变量，以后也可以通过switch_channel_get_variable再取出来。当然，这就是另外的事情了。

### bridge

接下来我们再来看一下bridge这个App，从某种意义上讲，它属于FreeSWITCH的核心功能，比较有代表性。

bridge App是由第3017行的audio_bridge_function函数完成的。该函数比较复杂，我们尽量挑简单的部分说。

首先，该App在Dialplan中的使用方法一般是：

```
<action application="bridge" data="user/1001"/>
```

因而，该函数中的data参数便是一个指向字符串“user/1001”的指针。在第3052行，首先检查该字符串的有效性。如果它为空字符串，那就没有必要继续进行了，直接返回（return，第3053行）即可。

```
3037  SWITCH_STANDARD_APP(audio_bridge_function)
3038  {
...
3052      if (zstr(data)) {
3053          return;
3054      }
```

我们跳过很多if…else假设，直接跳到第3194行（一般来说都会执行到这里）。接下来的第3195行将调用核心的switch_ivr_originate函数发起一个新的呼叫。

```
3194          if ((status =
3195               switch_ivr_originate(session, &peer_session, &cause,
                     data, 0, NULL, NULL, NULL, NULL, NULL, SOF_NONE, NULL))
                        != SWITCH_STATUS_SUCCESS) {
3196              fail = 1;
```

switch_ivr_originate函数是在switch_ivr_originate.c:1850行定义的。该函数可能是FreeSWITCH中最长的一个函数，在我们参考的版本中，它足足有2048行！因此，笔者在此不准备研究它 [1]，但我们下面来看一下它使用的这几个参数的意义。

switch_ivr_originate函数中，session就是指当前的Session，即呼入的那条腿（a-leg），我们执行到此处，调用该函数创建另一条腿（b-leg）。因而，第二个参数peer_session就是新建立的Session。由于我们在该函数执行完成后，需要知道peer_session指针的值，因此这里我们传入的是指针变量的地址（相当于一个双重指针）。同理，我们也需要在呼叫失败时得到呼叫原因（cause），因此把它作为第三个变量。第四个参数便是我们提供的呼叫字符串（data）的指针，在本例中该字符串的值是“user/1001”。

其他的参数我们就没必要看了，大部分都是空指针。在此，由于我们传入了当前的session指针，因此该函数在执行的时候就有参照物了。比如，它会将a-leg（当前session）中的主叫号码（effective_caller_id_number）作为主叫号码去呼叫b-leg等。当然，b-leg也不是仅参照a-leg，如果b-leg的对端回了呼叫进展消息（如SIP 180或183消息），则a-leg也能听到相关的提示音。

如果b-leg的对端应答了，或者在呼叫进展过程中返回了媒体消息（如SIP中的183消息），则上述的switch_ivr_originate函数就会返回。在接下来的第3207行，我们将得到新的Channel（b-leg对应的Channel——peer_channel）。

```
3207 switch_channel_t *peer_channel = switch_core_session_get_channel(peer_session);
```

如果我们在呼叫时使用的是Proxy Media模式（第3123行），则执行第3214行的函数时仅进行信令级的桥接，否则（正常情况）就执行第3236行的多线程的桥接函数switch_ivr_multi_threaded_bridge。

```
3213          if (switch_channel_test_flag(caller_channel, CF_PROXY_MODE)) {
3214              switch_ivr_signal_bridge(session, peer_session);
3215          } else {
...
3236              switch_ivr_multi_threaded_bridge(session, peer_session,
                      func, a_key, b_key);
3237          }
```

接下来看switch_ivr_multi_threaded_bridge函数。它是在switch_ivr.c:1270行实现的。它首先在第1275行和第1276行始始化了两个switch_ivr_bridge_data_t类型的变量a_leg和b_leg，用于存放与两条腿相关的私有数据（我们后面会用到它们）。

```
1270  SWITCH_DECLARE(switch_status_t) switch_ivr_multi_threaded_bridge(
          switch_core_session_t *session,
1271      switch_core_session_t *peer_session,
1272      switch_input_callback_function_t input_callback, void *session_data,
1273      void *peer_session_data)
1274  {
1275       switch_ivr_bridge_data_t *a_leg =
                switch_core_session_alloc(session, sizeof(*a_leg));
1276       switch_ivr_bridge_data_t *b_leg =
                switch_core_session_alloc(peer_session, sizeof(*b_leg));
```

在第1319行，它首先在peer_channel（即b-leg）上安装一些状态回调函数，当b-leg的状态发生变化时，将调用相关的回调函数。

```
1319      switch_channel_add_state_handler(peer_channel, &audio_bridge_peer_state_handlers);
```

然后产生一个CHANNEL_BRIDGE事件（第1342行），并发送出去（第1347行）。

```
1342          if (switch_event_create(&event, SWITCH_EVENT_CHANNEL_BRIDGE) == 
                 SWITCH_STATUS_SUCCESS) {
...
1347              switch_event_fire(&event);
```

接下来，分别在a-leg和b-leg上产生一个SWITCH_MESSAGE_INDICATE_BRIDGE消息（Message，用于标志该Channel已经被桥接了），分别发送给这两个leg（第1400行、第1408行）。

```
1396              msg.message_id = SWITCH_MESSAGE_INDICATE_BRIDGE;
...
1400              if (switch_core_session_receive_message(peer_session, &msg) 
                     != SWITCH_STATUS_SUCCESS) {
...
1408              if (switch_core_session_receive_message(session, &msg) != 
                     SWITCH_STATUS_SUCCESS) {
```

在第1439行，将一个b_leg数据指针确定的私有数据绑定到b-leg上（使用私有数据与设置通道变量类似，但后者只能是字符串值，而前者可以绑定为任意值）。然后，在第1440行将b-leg的状态设为媒体交换的状态（CS_EXCHANGE_MEDIA）

```
1439              switch_channel_set_private(peer_channel, "_bridge_", b_leg);
1440              switch_channel_set_state(peer_channel, CS_EXCHANGE_MEDIA);
```

这时候，b-leg的状态发生了变化，因而会回调在上面第1319行设置过的回调函数。不过，在讲这些回调函数前，我们先把第1442行讲完。接下来的第1442行很简单，它执行audio_bridge_thread函数，并将一个a_leg数据指针传入。该数据指针包含a-leg的一些信息。

```
1442              audio_bridge_thread(NULL, (void *) a_leg);
```

第1442行的执行是阻塞的，它将阻塞的执行一直到bridge结束，因此，我们可以倒回来看b-leg上的回调函数了。

我们在第1319行时就在b-leg上安装了一些回调函数，这里回调函数是在一个全局变量中指定的，具体如下：

```c
771  static const switch_state_handler_table_t audio_bridge_peer_state_handlers = {
772      /*.on_init */ NULL,
773      /*.on_routing */ audio_bridge_on_routing,
774      /*.on_execute */ NULL,
775      /*.on_hangup */ NULL,
776      /*.on_exchange_media */ audio_bridge_on_exchange_media,
777      /*.on_soft_execute */ NULL,
778      /*.on_consume_media */ audio_bridge_on_consume_media,
779  };
```

其中，我们在第1440行将Channel的状态设置为CS_EXCHANGE_MEDIA，Channel的状态发生了改变，它就会回调在第776行指定的audio_bridge_on_exchange_media函数。

在audio_bridge_on_exchange_media函数（第694行）中，可以看到，它在第697行通过switch_channel_get_private取出了该Channel上的一个私有数据，而该私有数据是在第1439行设置的。该私有数据里面存储了与bridge相关的b-leg上的数据，有了它以后，我们就可以在第704行执行audio_bridge_thread函数了。注意，在此第704行传入的参数是b-leg上的switch_ivr_bridge_data_t结构的私有数据。

```
694  static switch_status_t audio_bridge_on_exchange_media(switch_core_
         session_t *session)
695  {
696      switch_channel_t *channel = switch_core_session_get_channel(session);
697      switch_ivr_bridge_data_t *bd =
            switch_channel_get_private(channel, "_bridge_");
...
703          if (bd->session == session && *bd->b_uuid) {
704              audio_bridge_thread(NULL, (void *) bd);
```

至此，我们可以看到，a-leg和b-leg分别在自己的线程中执行了audio_bridge_thread函数（这个很重要，我们的思维现在并行化了，即下面讲的所有代码都是在两条腿上在两个线程中并行执行的），并且在该函数中，它们分别传入了自己所在的那条腿上的switch_ivr_bridge_data_t结构的数据。

在该函数中，它首先在第207行将传入的数据从obj指针赋值给一个data指针，并在第236行将data指针中的session成员变量赋值给session_a。注意，到了这里，session_a就不一定是a-leg了，而是只在当前线程中的那条腿。即，如果在a-leg中调用该函数，它就是a-leg；如果在b-leg中调用该函数，它就是b-leg。同理，第237行的session_b变量也不一定是b-leg，而是与本条腿相对的那条腿（桥接中的另一条腿）。注意，该腿相关的session_b变量不是直接传入的指针，而是传入了一个Channel的UUID（data->b_uuid），因此我们需要使用switch_core_session_locate来取得与该UUID对应的Session的指针session_b。

```
205  static void *audio_bridge_thread(switch_thread_t *thread, void *obj)
206  {
207      switch_ivr_bridge_data_t *data = obj;
...
236      session_a = data->session;
237      if (!(session_b = switch_core_session_locate(data->b_uuid))) {
238          return NULL;
239      }
```

至此，在两个线程中分别都有了当前的Session和另一个Session的信息了，第256～257行分别取出与它们对应的Channel。然后，就是一个无限循环（第341行），在该循环中，不停地在当前的Session（session_a）中读取一帧媒体数据（第547行），然后写入另一个Session（session_b，第565行）。这就实现了媒体 [2]的交换，也是bridge App的全部秘密。当然，第546行的注释可能更简洁直观一些——从一个Channel中读取音频并写入另一个Channel。

```
245      chan_a = switch_core_session_get_channel(session_a);
246      chan_b = switch_core_session_get_channel(session_b);
...
341      for (;;) {
...
546          /* read audio from 1 channel and write it to the other */
547          status = switch_core_session_read_frame(session_a, &read_frame, 
                SWITCH_IO_FLAG_NONE, stream_id);
...
565                  if (switch_core_session_write_frame(session_b, read_
      frame, SWITCH_IO_FLAG_NONE, stream_id) != SWITCH_STATUS_SUCCESS) {
```

当读取数据错误或者检测到挂机时，上述无限循环将终止。在上述函数中，我们在第237行使用了switch_core_session_locate通过一个UUID获得了session_b的指针。而该函数在返回指针的同时会将当前的Session加锁，以防止产生竞争条件（Race Condition）。因此，在任何时候使用switch_core_session_locate函数并获得了非空的指针时，在指针使用完成后都需要明确解锁，如第673行所示：

```
673      switch_core_session_rwunlock(session_b);
```

当然，当上面的audio_bridge_thread函数完成后，后续还有很多事情要做，如发送CHANNEL_UNBRIDGE事件、检查所有相关的after_bridge（桥接后的）变量（我们常用的hangup_after_bridge变量就是在这里检查的）等，因篇幅所限，我们就不多讲了。

### Endpoint Interface

在mod_dptools模块中，实现了一些常用的“假”的Endpoint Interface。之所以说是“假”的，是因为它们并没有像mod_sofia那样既有底层的协议驱动，又有媒体收、发处理，而是为了简化某些操作，或者为了在某些特殊的情况下使用一些一致的命令或接口而实现的。比如，我们常用的user就是一个Endpoint。一般来说，一个Endpoint都会提供一个用于外呼的呼叫字符串，我们对于user提供的呼叫字符串已经非常熟悉了，如在命令行和Dialplan中我们经常使用如下的呼叫字符串：

```
originate user/1000 &echo
<action application="bridge" data="user/1000" />
```

这里面的user就是由user Endpoint实现的。该Interface的指针是在第3879行声明的一个全局变量。

```
3879  switch_endpoint_interface_t *user_endpoint_interface;
```

在第3885～3887行，定义了一个switch_io_routines_t类型的结构体，用于定义回调函数。可以看出，由于该Endpoint很简单，它只定义了一个outgoing_channel回调函数。该回调函数将在有人使用user呼叫字符串时（如执行originate和bridge时）被调用。

```
3885  switch_io_routines_t user_io_routines = {
3886      /*.outgoing_channel */ user_outgoing_channel
3887  };
```

该回调函数的定义如下：

```
3889  static switch_call_cause_t user_outgoing_channel(switch_core_session_t *session,
3890             switch_event_t *var_event,
3891             switch_caller_profile_t *outbound_profile,
3892             switch_core_session_t **new_session,
                 switch_memory_pool_t **pool, switch_originate_flag_t flags,
3893             switch_call_cause_t *cancel_cause)
3894  {
```

首先，该函数的输入参数中将包含一个outbound_profile，它的成员变量destination_number即是被叫号码。在第3909行，复制该被叫号码并赋值给user指针。

```
3909      user = strdup(outbound_profile->destination_number);
```

然后获取domain的值，如果呼叫字符串中未包含domain（如user/1000@192.168.1.2就包含了domain，而user/1000则未包含），则在第3917行尝试获取默认的domain。

```
3914      if ((domain = strchr(user, '@'))) {
3915          *domain++ = '\0';
3916      } else {
3917          domain = switch_core_get_domain(SWITCH_TRUE);
```

接下来，第3942行，从XML用户目录中查找该用户，并继续在第3593行尝试找到dial-string配置参数：

```
3942      if (switch_xml_locate_user_merged("id", user, domain, NULL,
          &x_user, params) != SWITCH_STATUS_SUCCESS) {
3953              if (!strcasecmp(pvar, "dial-string")) {
```

如果该呼叫字符串是在bridge中使用的，则第3992行的判断成立（即说明有a-leg），否则（第4004行）说明是个单腿的呼叫（originate）。然后根据不同的情况进行相关的设置，并得到一个d_dest（第4002行或第4022行）的地址（如sip:1000@192.168.1.100:7890等）。

```
3992          if (session) {
...
4002              d_dest = switch_channel_expand_variables(channel, dest);
4003
4004          } else {
...
4022              d_dest = switch_event_expand_headers(event, dest);
...
4024          }
```

随后调用switch_ivr_originate去呼叫该地址，如第4040行所示：

```
4040          } else if (switch_ivr_originate(session,new_session, &cause, d_dest, ...
```

user Endpoint是一个最简单的Endpoint。它目前仅支持SIP呼叫（理论上它还可以扩展支持其他的），实际的呼叫流程还要转到实际的mod_sofia Endpoint上进行处理。我们将在21.3节讲解mod_soifa是如何实现Endpoint Interface的。

### 模块框架

在20.3.5节我们讲过，一个模块主要是由load、runtime和shutdown回调函数组成的。mod_dptools当然也不例外。

mod_dptools模块的load函数是在第5578行定义的，它将在模块被加载的时候执行。从第5580～5584行可以看出，它实现了包括API Interface、App Interface、Dialplan Interface在内的多个Interface。

```
5578  SWITCH_MODULE_LOAD_FUNCTION(mod_dptools_load)
5579  {
5580      switch_api_interface_t *api_interface;
5581      switch_application_interface_t *app_interface;
5582      switch_dialplan_interface_t *dp_interface;
5583      switch_chat_interface_t *chat_interface;
5584      switch_file_interface_t *file_interface;
```

在初始化了一系列的内存池及其他数据结构后，它在第5593行向核心注册该模块。

```
5593      *module_interface = switch_loadable_module_create_module_
             interface(pool, modname);
```

在第5595行，它向核心绑定（订阅）了一个SWITCH_EVENT_PRESENCE_PROBE事件的回调函数，即每当系统中产生该事件后，都会执行回调函数pickup_pres_event_handler。

```
5595      switch_event_bind(modname, SWITCH_EVENT_PRESENCE_PROBE,
          SWITCH_EVENT_SUBCLASS_ANY, pickup_pres_event_handler, NULL);
```

另外，它还实现了一些EndpointInterface：

```
5621      error_endpoint_interface = ...
5625      group_endpoint_interface = ...
5629      user_endpoint_interface = ...
5633      pickup_endpoint_interface = ...
```

向核心注册API和App：

```
5641      SWITCH_ADD_API(api_interface, "strepoch", ...
5645      SWITCH_ADD_API(api_interface, "strftime", ...
5790      SWITCH_ADD_APP(app_interface, "echo", ...
5791      SWITCH_ADD_APP(app_interface, "park", ...
5794      SWITCH_ADD_APP(app_interface, "playback", ...
```

还可以看到，inline Dialplan也是在该模块中实现的：

```
5839      SWITCH_ADD_DIALPLAN(dp_interface, "inline", inline_dialplan_hunt);
```

总之，在该函数的最后，返回SWITCH_STATUS_SUCCESS表明该模块加载成功：

```
5842      return SWITCH_STATUS_SUCCESS;
```

mod_dptoots模块没有runtime函数。其shutdown函数也很简单，该模块没有太多要清理的资源，它只需要在第5573行向核心取消先前在第5593行绑定的事件回调函数：

```
5571  SWITCH_MODULE_SHUTDOWN_FUNCTION(mod_dptools_shutdown)

5572  {
5573      switch_event_unbind_callback(pickup_pres_event_handler);
5574
5575      return SWITCH_STATUS_SUCCESS;
5576  }
```

上述就是mod_dptoots模块的大体框架。读者可以尝试在FreeSWITCH控制台上使用“reload mod_dptools”命令查看与这些代码相关的日志输出，并对照实际的代码加深一下印象。

[1] 这一个函数也许就够写一本书了。好多读者也是在阅读源代码时，好像是在学会了originate命令之后，抑或是在知道bridge App调用了该函数之后，就来看这个函数。最后的结果要不是认为一个函数写这么长，代码写得太烂；要不就是一下就被吓住了，看不懂。因此，不建议初学者研究这个函数。笔者也是大致看过，并没有深入研究。 

[2] 注意，这里所说的媒体就是音频，为了简单起见，我们没有分析视频有关的代码。

## mod_commands

在mod_commands中，实现了大部分的API命令，如常用的version、status、originate等。

### 模块框架

下面我们先从mod_commands模块的load函数看起。

load函数是在第6388行定义的，它也是定义了一个switch_api_interface_t类型的指针（第6390行），用于实现API Interface，于第6393行向核心注册本模块，于第6420行、第6444行、第6460行等向核心注册相关命令实现的回调函数。

```
6388  SWITCH_MODULE_LOAD_FUNCTION(mod_commands_load)
6389  {
6390      switch_api_interface_t *commands_api_interface;
...
6393      *module_interface = switch_loadable_module_create_module_
             interface(pool, modname);
6394
...
6420      SWITCH_ADD_API(commands_api_interface, "version", ...
...
6444      SWITCH_ADD_API(commands_api_interface, "originate", ...
...
6460      SWITCH_ADD_API(commands_api_interface, "status", ...
```

然后，它使用switch_console_set_complete添加命令补全信息（如第6603、6604行），以便用户在控制台上输入命令时可以使用Tab键进行补全。

```
6603      switch_console_set_complete("add show calls");
6604      switch_console_set_complete("add show channels");
```

最后，第6388行定义的那个函数返回SWITCH_STATUS_NOUNLOAD。与其他模块返回SWITCH_STATUS_SUCCESS不同，这里的返回值表示该模块是无法被卸载的（由于unload命令本身是在该模块内实现的）。

```
6690      return SWITCH_STATUS_NOUNLOAD;
6691  }
```

### originate

本节我们以originate命令为例来进行讲解。originate命令是在originate_function中实现的。它在第4067行使用SWITCH_STANDARD_API进行声明。该声明也是一个在switch_types.h:2016行定义的一个宏，该宏的定义在笔者的电脑上展开的结果如下：

```
static switch_status_t originate_function ( const char *cmd,
    switch_core_session_t *session, switch_stream_handle_t *stream)
```

从上面的展开结果可以看出，该宏有3个输入参数：第一个是输入的命令参数；第二个是一个session，但由于大多数的API命令都跟Session无关，因此该参数一般是一个空指针；第三个参数是一个stream，它是一个流，写入该流中的数据（命令输出）将可作为命令的结果返回。

第4089行复制了命令字符串。由于originate命令的参数众多，因此它使用一个switch_separate_string对命令字符串进行分隔。该函数将分割后的结果放到一个argv数组中，并返回数组中参数的个数argc（在这一点上，类似于C语言中经典的main函数的参数）。

```
4067  SWITCH_STANDARD_API(originate_function)
4068  {
...
4089      mycmd = strdup(cmd);
4090      switch_assert(mycmd);
4091      argc = switch_separate_string(mycmd, ' ', argv, (sizeof(argv) / sizeof(argv[0])));
```

在对输入参数进行分析后，它便在第4128行调用switch_ivr_originate发起一个呼叫。读者可以看到，bridge App也是调用了该函数发起呼叫，但不同的是，在这里它的第一个参数是一个空指针（NULL），因而这是一个单腿的呼叫。

```
4128      if (switch_ivr_originate(NULL, &caller_session, &cause, aleg,
                timeout, NULL, cid_name, cid_num, ...
```

另外一个与bridge App中调用方法不同的地方在于，在这里它的大部分参数都不是空指针，因而可以在外呼的同时指定其他参数，如超时（timeout）、主叫名称（cid_name）、主叫号码（cid_num）等。

如果我们在发起呼叫时使用“&”指定了一个App，如originate user/1000&echo命令，则它在对方接听后（严格来说是收到媒体后，如收到SIP 183消息后），即开始执行第4153行，执行app_name（如echo）所指定的函数。

```
4153          if ((extension = switch_caller_extension_new(caller_session, app_name, arg)) == 0) {
```

否则（第4160行）就在第4161行转移到相应的Dialplan。如用户输入“originate user/1000 9196 XML default”命令则执行下面的代码。

```
4160      } else {
4161          switch_ivr_session_transfer(caller_session, exten, dp,
```

在第4165行，调用输出流stream的write_function输出命令的反馈信息，如“+OK UUID”。

```
4165          stream->write_function(stream, "+OK %s\n",
```

使用switch_ivr_originate所产生的Session也是加锁的，因而，我们也要明确地释放它：

```
4170      switch_core_session_rwunlock(caller_session);
```

## mod_sofia

mod_sofia是FreeSWITCH中最大的一个模块，也是最重要的一个模块。所有的SIP通话都是从它开始和终止的，因而分析该模块的源代码是很有参考意义的。

mod_sofia模块非常庞大而且复杂，它实现了SIP注册、呼叫、Presence、SLA等一系列的SIP特性。在此我们抓住一条主线，仅研究SIP呼叫有关的代码，以避免又陷入庞大代码的海洋。

### 模块加载

我们还是把mod_sofia模块的load函数作为入口，它是在mod_sofia.c:5420实现的。该函数最开始在第5423行定义了一个api_interface指针，用于往核心中添加API。在第5427行，它将一个全局变量mod_sofia_globals清零。该全局变量在整个模块内是有效的，它用于记录一些模块级的数据和变量。然后，在进行一定的初始化后，它在第5447行将全局变量的一个running成员变量设为1，标志该模块是在运行的。

```
5420  SWITCH_MODULE_LOAD_FUNCTION(mod_sofia_load)
5421  {
5423      switch_api_interface_t *api_interface;
...
5428      memset(&mod_sofia_globals, 0, sizeof(mod_sofia_globals));
...
5446      switch_mutex_lock(mod_sofia_globals.mutex);
5447      mod_sofia_globals.running = 1;
5448      switch_mutex_unlock(mod_sofia_globals.mutex);
```

在第5468行，将启动一个消息处理线程，用于SIP消息的处理。

```
5468      sofia_msg_thread_start(0);
```

第5475行调用config_sofia函数来从XML中读取该模块的配置并启动相关的Sofia Profile。第5549行，向核心注册本模块。第5550行，初始化一个新的Endpoint，接着指定该新的Endpoint的名字及绑定相关的回调函数（第5551行～第5554行）。

```
5475      if (config_sofia(SOFIA_CONFIG_LOAD, NULL) != SWITCH_STATUS_SUCCESS) {
...
5549      *module_interface =
              switch_loadable_module_create_module_interface(pool, modname);
5550      sofia_endpoint_interface =
              switch_loadable_module_create_interface(*module_interface,
                  SWITCH_ENDPOINT_INTERFACE);
5551      sofia_endpoint_interface->interface_name = "sofia";
5552      sofia_endpoint_interface->io_routines = &sofia_io_routines;
5553      sofia_endpoint_interface->state_handler = &sofia_event_handlers;
5554      sofia_endpoint_interface->recover_callback = sofia_recover_callback;
```

后面的代码还有很多，我们就不继续往下看了。至此，我们还有两个细节没有研究明白：第一，就是上面刚刚讲到的这些回调函数都是怎么使用的；第二，就是底层的Sofia库是在哪里启动的，又是如何接收SIP消息并建立通话的。为了从根本上了解一路通话的建立过程，这次我们先从第二个问题开始看。

### Sofia的加载及通话建立

接下来，我们来看一下Sofia（即我们的SIP服务）到底是从哪里加载的，通话的建立是从哪里开始的，又是如何进行的。

1. Sofia的加载

关于Sofia的加载，其实我们刚刚已经讲过了，它就隐藏在第5475行的config_sofia函数中。该函数是在sofia.c:3585行定义的。该函数非常长，它解析XML配置文件，初始化与Profile相关的变量的数据结构，并启动相关的Profile。我们熟知的默认的internal Profile就是在第4940行启动的。

```
3585  switch_status_t config_sofia(sofia_config_t reload, char *profile_name)
3586  {
3587      char *cf = "sofia.conf";
...
4940                          launch_sofia_profile_thread(profile);
```

launch_sofia_profile_thread在第2817行定义的，它将于第2826行启动一个新线程，并在新线程中执行sofia_profile_thread_run，同时将profile作为输入参数。

```
2817 void launch_sofia_profile_thread(sofia_profile_t *profile)
2818 {
...
2826     switch_thread_create(&profile->thread, thd_attr,
             sofia_profile_thread_run, profile, profile->pool);
2827 }
```

在新线程中（第2430行），将在第2432行得到profile指针的值。然后会在第2481行调用nua_create函数建立一个UA（User Agent）。nua_create是Sofia-SIP库提供的函数，它将启动一个UA，监听相关的端口（如大家熟知的5060），并等待SIP消息到来。一旦收到SIP请求，它便会回调sofia_event_callback回调函数（第2482行），该回调函数中将带着对应的profile作为回调参数。

```
2430 void *SWITCH_THREAD_FUNC sofia_profile_thread_run(
                                    switch_thread_t *thread, void *obj)
2431 {
2432     sofia_profile_t *profile = (sofia_profile_t *) obj;
...
2481    profile->nua = nua_create(profile->s_root,  /* Event loop */
2482        sofia_event_callback, /* Callback for processing events */
2483        profile,  /* Additional data to pass to callback */
2484        ...
```

关于Sofia-SIP底层的库我们就不深入研究了。到此为止，我们的SIP服务已经启动了，就等着接收SIP消息了。

2. SIP消息的接收

当我们的服务收到SIP消息后，便会调用sofia_event_callback回调函数。该函数在第1789行定义。在该行，如果得到回调，则收到一个nua_event_t结果的SIP事件event。即使不看Sofia-SIP库的文档，我们也能从第1800行的switch语句以及后面的case分支中看出——该事件到底是对应什么类型的SIP消息了。如果收到SIP INVITE消息，那么它一定会匹配到第1840行。

```
1789  void sofia_event_callback(nua_event_t event,
1790      int status,
1791      char const *phrase,
1792      nua_t *nua, sofia_profile_t *profile,
        nua_handle_t *nh, sofia_private_t *sofia_private,
        sip_t const *sip,
1793      tagi_t tags[])
1794  {
...
1800      switch(event) {
1801      case nua_i_terminated:
...
1840      case nua_i_invite:
1841      case nua_i_register:
1842      case nua_i_options:
1843      case nua_i_notify:
1844      case nua_i_info:
```

不同的消息将进行不同的处理，但大部分都会执行到第2018行，将消息通过一个核心的消息队列分发出去（其中，de是一个sofia_dispatch_event_t的结构体指针，它包含了本次收到的SIP消息）。

```
2018      sofia_queue_message(de);
```

Sofia-SIP库在底层是一个单线程的结构，因此在这里我们使用了消息队列以提高并发量。

接下来我们跟踪到第1749行，sofia_queue_message函数将保证我们的消息队列有足够的处理能力。然后，进行必要的检查。如果这是第一次INVITE请求（第1881行），则在第1943行（略）或第1945行调用switch_core_session_request生成一个新的Session，并赋值给session指针。到这里，INVITE请求在我们系统中起作用了——它导致我们的系统创建了一个Session，在以后所有与该INVITE消息相关的会话消息中，都会与该Session相关（当然，具体的关联代码还有很多，我们就不再深入了）。

```
1749 void sofia_queue_message(sofia_dispatch_event_t *de)
1750 {
...
1881      if (event == nua_i_invite && !sofia_private) {
...
1945            session = switch_core_session_request(sofia_endpoint_interface, SWITCH_CALL_DIRECTION_INBOUND, SOF_NONE, NULL);
```

接下来，在第1950行，初始化一个tech_pvt指针（该指针所指向的结构中将用于保存本Session的私有数据，我们后面还会讲到）。在第1962行，将这些私有数据与session绑定。然后，在第1981行，为该Session启动一个新的线程，以执行后续耗时的操作，避免阻塞当前的线程。

```
1950            tech_pvt = sofia_glue_new_pvt(session);
...
1962            sofia_glue_attach_private(session, profile, tech_pvt, channel_name);
...
1981          if (switch_core_session_thread_launch(session) != SWITCH_STATUS_SUCCESS) {
```

当然，启动了新线程后，对该SIP事件的处理还没有完，它还会后续设置de指针，并将收到的消息通过第1777行的switch_queue_push推到一个模块级的消息队列中去（即这里的msg_queue）。

```
2003          de->init_session = session;
...
1777     switch_queue_push(mod_sofia_globals.msg_queue, de);
1778 }
```

至此，SIP事件的接收就完成了。如果后续收到其他SIP事件，将进行下次回调，并推到队列中等候处理。

3. SIP消息的处理

对SIP事件的处理是在单独的线程（组）中执行的。进行事件处理的线程是在模块加载时从sofia_msg_thread_start函数开始的。该函数定义于sofia.c:1715，它首先会启动一个新线程，并在以后根据CPU的数量以及当前的需要决定启动多少个消息处理线程。从第1738行可以看出，新的事件处理线程中将执行sofia_msg_thread_run函数。

```
1715  void sofia_msg_thread_start(int idx)
1716  {
...
1736      switch_thread_create(&mod_sofia_globals.msg_queue_thread[i],
1737                               thd_attr,
1738                               sofia_msg_thread_run,
```

我们继续跟踪，就发现sofia_msg_thread_run是在第1671行定义的。它在第1691行使用一个无限循环，不断地从消息队列中取出一条消息（事件），然后在第1700行使用sofia_process_dispatch_event函数发送出去。

```
1671  void *SWITCH_THREAD_FUNC sofia_msg_thread_run(
                                   switch_thread_t *thread, void *obj)
1672  {
...
1691      for(;;) {
1692
1693          if (switch_queue_pop(q, &pop) != SWITCH_STATUS_SUCCESS) {
...
1699              sofia_dispatch_event_t *de = (sofia_dispatch_event_t *) pop;
1700              sofia_process_dispatch_event(&de);
```

看来还得继续跟踪，sofia_process_dispatch_event被定义在第1643行，当看到第1652行时，我们总算看到了一点曙光，它终于像在调用一个回调函数了。

```
1643  void sofia_process_dispatch_event(sofia_dispatch_event_t **dep)
1644  {

1652      our_sofia_event_callback(de->data->e_event, de->data->e_status,
              de->data->e_phrase, de->nua, de->profile,
1653          de->nh, sofia_private, de->sip, de, (tagi_t *)de->data->e_tags);
```

继续往下跟踪可以确定我们的猜测，在第1024行找到our_sofia_event_callback的定义后，可以看到它确实是在处理SIP消息了。在第1130行的switch语句的各个分支中，我们可以看到许多以nua_r_和nua_i_开头的SIP event，其中，前者表示收到一条响应（Response）消息，而后者表示收到一条请求消息。

```
1024  static void our_sofia_event_callback(nua_event_t event,
1025      int status,
1026      char const *phrase,
1027      nua_t *nua, sofia_profile_t *profile, nua_handle_t *nh,
        sofia_private_t *sofia_private, sip_t const *sip,
1028      sofia_dispatch_event_t *de, tagi_t tags[])
1029  {
...
1130      switch (event) {
1131      case nua_r_get_params:
1132      case nua_i_fork:
```

我们集中精力看INVITE消息，如果收到INVITE消息，则第1247行的case条件成立。继续判断如果第1249行的条件成立，则说明是一个re-INVITE消息，在第1250行进行处理。否则，则说明是一个新的INVITE消息，在第1253行调用sofia_handle_sip_i_invite处理。

```
1247      case nua_i_invite:
1248          if (session && sofia_private) {
1249              if (sofia_private->is_call > 1) {
1250                  sofia_handle_sip_i_reinvite(...
1251              } else {
1252                  sofia_private->is_call++;
1253                  sofia_handle_sip_i_invite(session, nua, profile, nh,
                        sofia_private, sip, de, tags);
1254              }
1255          }
```

在sofia_handle_sip_i_invite中，将更深入解析INVITE消息，对Session的相关内容进行更新，如果需要对来话进行认证，还需要给对方发送SIP 407消息进行挑战认证等。sofia_handle_sip_i_invite函数是在第7845行定义的，有兴趣的读者可以找到它来研究一下，在此我们就不再深入了。

4. SIP状态机

在Sofia-SIP底层，也实现了一个状态机，在SIP通话的不同阶段使用不同的状态进行表示和处理。因而在SIP状态发生改变时，它便向上层上报状态变化事件，这些状态变化事件也是在SIP事件的形式上报的，因而会经过跟上述的INVITE消息类似的回调过程一直到回调同一个回调函数our_sofia_event_callback。在该函数的第1265行，我们会看到在收到Sofia-SIP底层驱动的状态变化后，继续回调sofia_handle_sip_i_state函数来进行相关处理。

```
1265      case nua_i_state:
1266          sofia_handle_sip_i_state(session, status, phrase, nua,
                  profile, nh, sofia_private, sip, de, tags);
```

由于sofia_handle_sip_i_state函数有太多的状态和情况需要处理，因此也非常长。我们很难通过直接阅读源码的方式找到正确的入口。看起来，虽然我们代码剖析到最后了，但是竟然可能要迷失了。

不过，办法总比困难多。在本章中，我们过多地关注了理论却少了实践。下面让我们拿起一个SIP电话，拨打9196，很快就可以在日志中看到如下的信息：

```
[DEBUG] sofia.c:5861 ... Channel entering state [received][100]
```

从上一条日志可以看出，在第5861行打印了一条日志，表示我们的状态机进入了收到INVITE消息后发送100 Trying消息的阶段（代码略）。而接着下一条日志则告诉我们Channel的状态从CS_NEW变成了CS_INIT。

```
[DEBUG] sofia.c:6116 ... State Change CS_NEW -> CS_INIT
```

有了上述信息，我们就可以在sofia.c的第6116行很快找到该日志对应的代码了。只要满足一定的条件，在该行就会把Channel的状态变为CS_INIT，然后Channel的核心状态机就会回调相关的状态回调函数了。

```
5773  static void sofia_handle_sip_i_state(...
5778  {
...
6115                      if (switch_channel_get_state(channel) == CS_NEW) {
6116                          switch_channel_set_state(channel, CS_INIT);
```

5. Channel状态机

只要Channel的状态一变成CS_INIT，FreeSWITCH核心的状态机代码就会负责处理各种状态变化了，因而各Endpoint模块就不需要再自己维护状态机了。也就是说，在一个Endpoint模块，首先要有一定的机制用于初始化一个Session（对应一个Channel，它的初始状态将为CS_NEW），然后在适当的时候把该Channel的状态变成CS_INIT，剩下的事就基本不用管了。

当然，这里说的是“基本”而不是“绝对”。一般来说，还是要在Endpoint模块中跟踪Channel状态机的变化，这就需要靠在核心状态机上注册相应的回调函数实现，如Sofia Channel的状态机的回调是在第4012行定义的。

```
4012  switch_state_handler_table_t sofia_event_handlers = {
4013      /*.on_init */ sofia_on_init,
4014      /*.on_routing */ sofia_on_routing,
4015      /*.on_execute */ sofia_on_execute,
4016      /*.on_hangup */ sofia_on_hangup,
4017      /*.on_exchange_media */ sofia_on_exchange_media,
4018      /*.on_soft_execute */ sofia_on_soft_execute,
4019      /*.on_consume_media */ NULL,
4020      /*.on_hibernate */ sofia_on_hibernate,
4021      /*.on_reset */ sofia_on_reset,
4022      /*.on_park */ NULL,
4023      /*.on_reporting */ NULL,
4024      /*.on_destroy */ sofia_on_destroy
4025  };
```

这些回调函数是在21.3.1节讲过的代码的第5553行注册到核心中去的。回调函数本身都比较简单，感兴趣的读者可以自己看一下代码。为了节省篇幅，在此我们就不多列举了。

6. IO例程

与Channel状态机回调相比，Endpoint模块中更重要的是IO例程的回调。IO例程主要提供媒体数据的输入输出（IO）功能。与上一节讲的Channel的状态机类似，IO例程的回调函数是在21.3.1节讲到的代码的第5552行注册到核心中去的。其中，IO例程的回调函数是由一个switch_io_routines_t类型的结构体变量设置的，该变量的定义在第3997行。

```
3997  switch_io_routines_t sofia_io_routines = {
3998      /*.outgoing_channel */ sofia_outgoing_channel,
3999      /*.read_frame */ sofia_read_frame,
4000      /*.write_frame */ sofia_write_frame,
4001      /*.kill_channel */ sofia_kill_channel,
4002      /*.send_dtmf */ sofia_send_dtmf,
4003      /*.receive_message */ sofia_receive_message,
4004      /*.receive_event */ sofia_receive_event,
4005      /*.state_change */ NULL,
4006      /*.read_video_frame */ sofia_read_video_frame,
4007      /*.write_video_frame */ sofia_write_video_frame,
4008      /*.state_run*/ NULL,
4009      /*.get_jb*/ sofia_get_jb
4010  };
```

在21.1.5节，我们已经讲过了outgoing_channel的回调，该回调是在有外呼请求的时候（如，执行“originate sofia/gateway/...”时）被回调执行的。在此我们再来看一下mod_sofia中的outgoing_channel有何不同。

该模块的outgoing_channel回调是在第4032行定义的。在第4057～4058行，它也是初始化了一个新的Session（nsession），然后初始化了一个新的tech_pvt用于存放私有数据。第4065行还是从outbound_profile中复制被叫号码，第4071行得到对应的Channel（nchannel）。如果该外呼是由bridge发起的，则还会有a-leg存在，因而在第4074行将得到与a-leg对应的Channel，我们新生成的nchannel即是b-leg。

```
4032  static switch_call_cause_t sofia_outgoing_channel(...
...
4057      if (!(nsession = switch_core_session_request_uuid(
                sofia_endpoint_interface, SWITCH_CALL_DIRECTION_OUTBOUND,
4058            flags, pool, switch_event_get_header(var_event,
                                 "origination_uuid")))) {
4063      tech_pvt = sofia_glue_new_pvt(nsession);
4064
4065      data = switch_core_session_strdup(nsession,
                     outbound_profile->destination_number);
...
4071      nchannel = switch_core_session_get_channel(nsession);
4072
4073      if (session) {
4074          o_channel = switch_core_session_get_channel(session);
4075      }
```

之后，在第4346行将tech_pvt与nsession关联进来。

```
4346      sofia_glue_attach_private(nsession, profile, tech_pvt, dest);
```

从第4428～4430行可以看出，新的Channel nchannel的状态变为了CS_INIT。然后，该Channel便进入正常的呼叫流程了。接下来，核心的状态机会接管后面的状态变化，如将状态机置为CS_ROUTING，然后进行路由查找（即查找Dialplan），最后进入CS_EXECUTE状态，执行在Dialplan中找到的各种App等。

```
4428      if (switch_channel_get_state(nchannel) == CS_NEW) {
4429          switch_channel_set_state(nchannel, CS_INIT);
4430      }
```

当代码中某处调用switch_core_session_read_frame试图读取一帧音频数据时（如21.1.4节中的情况），就会执行read_frame回调函数，因而会回调第929行定义的函数。该回调函数由于将大部分功能都移动到核心的Core Media代码中去了，因而非常简单，它主要就是在第964行调用核心的switch_core_media_read_frame从底层的RTP中读取音频数据。

```
929  static switch_status_t sofia_read_frame(switch_core_session_t *session,
        switch_frame_t **frame, switch_io_flag_t flags, int stream_id)
930  {
...
964      status = switch_core_media_read_frame(session, frame, flags,
                      stream_id, SWITCH_MEDIA_TYPE_AUDIO);
...
968      return status;
969  }
```

当然，写数据的情况与此差不多，write_frame回调函数在第971行定义。它在第1008行也是调用了Core Media中的函数switch_core_media_write_frame通过RTP将音频数据发送出去。

```
971  static switch_status_t sofia_write_frame(switch_core_session_t *session,
        switch_frame_t *frame, switch_io_flag_t flags, int stream_id)
972  {
...
1008      if (switch_core_media_write_frame(session, frame, flags,
              stream_id, SWITCH_MEDIA_TYPE_AUDIO)) {
```

视频的回调函数read_video_frame和write_video_frame与此差不多。我们就不多讲了。最后，还有一个比较有意思的receive_message回调，看第1096行定义的回调函数。其中，在第1123行和第1244行各一个switch语句用于判断收到的各种消息，并进行相应的处理。我们直接跳到第2031行，在收到SWITCH_MESSAGE_INDICATE_ANSWER消息时，它将在第2032行调用sofia_answer_channel对当前通话进行应答。

```
1096  static switch_status_t sofia_receive_message(switch_core_session_t *session,
                                switch_core_session_message_t *msg)
1097  {
...
1123      switch (msg->message_id) {
...
1244      switch (msg->message_id) {
...
2031      case SWITCH_MESSAGE_INDICATE_ANSWER:
2032          status = sofia_answer_channel(session);
```

可很容易想象到，应答将会向对方发送SIP 200 OK消息。而它就是在第608行调用Sofia-SIP底层库实现的。

```
602 static switch_status_t sofia_answer_channel(switch_core_session_t *session)
603 {
...
608                    nua_respond(tech_pvt->nh, SIP_200_OK, ...
```

如果我们再回到21.1.2节的answer App，就可以看到它调用了核心的switch_answer_channel函数，并在switch_channel.c:3716行发送了一个SWITCH_MESSAGE_INDICATE_ANSWER消息，因而sofia_receive_message函数被回调，代码执行到了第2032行，并最终在第608行向对方的SIP终端发送200 OK消息。

至此，我们所有的呼叫流程就全部都串起来了，我们对源代码的分析也到此结束了。

## 小结

在本章，我们对3个最有代表性的模块的源代码进行了深入剖析。结合上一章所学的内容，以我们最熟悉的echo、answer等App作为突破口，一步一步深入跟踪，终于理清了代码的执行流程，了解了各种回调函数的含义及触发时机。同时，我们也对从模块启动、网络监听、来话的接收、Session的生成、各种状态的转移直到应答等全部的流程进行了跟踪和梳理。

通过对本章的学习再配合系统的运行日志，便可轻松深入地学习和研究源代码了。当然，FreeSWITCH的代码非常多，学习源代码更多的是需要细心和耐心。退一万万步讲，这些代码是用了将近十年的时间写成的，不要指望一天就能精通。另外，笔者也不可能在短短几章内把所有的概念、方法、流程讲清楚。掌握FreeSWITCH的代码还需要阅读代码、多实践、多调试，总之，多下工夫才会有更多收获。

