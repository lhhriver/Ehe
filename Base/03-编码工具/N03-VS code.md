# 基础

# 插件

1. Chinese (Simplified)
2. code runner
3. Prettier
4. vscode-icons

# 开发环境配置

## Python

## C++



# 远程环境配置

## 远程服务器免密登录

1. 生成本地秘钥：ssh-keygen，连敲几下回车。

```
目录：C:\Users\lhhriver\.ssh
公钥：id_rsa.pub
私钥：id_rsa
```

2. 将公钥拷贝到服务器.ssh文件夹内：如：/root/.ssh

3. 将公钥写入文件：cat id_rsa.pub >> authorized_keys

4. vscode安装Remote-SSH插件。

5. 配置：C:\Users\lhhriver\\.ssh\config

    ```
    Host 133
      User root
      HostName 172.16.128.133
      IdentityFile C:\Users\lhhriver\.ssh\id_rsa
    ```

    

# 附录

## 快捷键

### 编辑器与窗口管理

|         快捷键         | 说明                                                         |
| :--------------------: | ------------------------------------------------------------ |
|         Ctrl+N         | 新建文件                                                     |
|      Ctrl+Shift+N      | 打开一个新的VSCode编辑器                                     |
|         Ctrl+O         | 打开文件                                                     |
|      Ctrl+Shift+O      | 打开文件夹                                                   |
|         Ctrl+W         | 关闭当前文件                                                 |
| Ctrl+Shift+W 或 Alt+F4 | 关闭当前VSCode编辑器                                         |
|         Ctrl+\         | 新建窗口显示代码（相当于复制当前代码到一个新的窗口；同一引用，修改一个文件，其他相同文件会一起改变） |
|       Ctrl+Alt+→       | 移动当前文件到右窗口，若没有右窗口，则创建一个新窗口         |
|       Ctrl+Alt+←       | 移动当前文件到左窗口                                         |
|        Ctrl+Tab        | 切换文件窗口                                                 |
|         Ctrl+B         | 显示/隐藏侧边栏                                              |
|         Ctrl+`         | 显示/隐藏控制面板（Terminal）（反引号位置：英文输入法状态下，键盘ESC按键下面的按键） |
|        Ctrl +/-        | 放大/缩小编辑器窗口                                          |
|          F11           | 全屏显示                                                     |
|      Ctrl+Shift+E      | 文件资源管理器（Explorer）                                   |
|      Ctrl+Shift+G      | git管理窗口（Source Control）                                |
|      Ctrl+Shift+X      | 扩展（插件）管理窗口（Extentions）                           |

### 代码查找替换与格式调整

|      快捷键      | 说明                                         |
| :--------------: | -------------------------------------------- |
|      Ctrl+F      | 查找                                         |
|      Ctrl+H      | 查找替换                                     |
|   Ctrl+Shift+F   | 全局查找                                     |
|   Ctrl+Shift+H   | 全局查找替换                                 |
|      Ctrl+D      | 选中下一个匹配项                             |
|   Ctrl+Shift+L   | 选中所有匹配项（秀儿）                       |
|      Ctrl+[      | 向左缩进                                     |
|      Ctrl+]      | 向右缩进                                     |
|      Alt+Up      | 向上移动当前行                               |
|     Alt+Down     | 向下移动当前行                               |
|   Shift+Alt+Up   | 向上复制当前行                               |
|  Shift+Alt+Down  | 向下复制当前行                               |
|    Ctrl+Enter    | 在当前行下方插入空行（光标位置可以不在行尾） |
| Ctrl+Shift+Enter | 在当前行上方插入空行（光标位置可以不在行尾） |
|      Alt+Z       | 切换内容是否自动换行（底部显示/隐藏滚动条）  |



### 光标操作

Home：光标移动到行首
End：光标移动到行尾
Ctrl+Home：光标移动到文件开头（左上）
Ctrl+End：光标移动到文件结尾（右下）
Shift+Home：选择从光标到行首的内容
Shift+End：选择从光标到行尾的内容
Shift+Alt+Right：扩大选中范围
Shift+Alt+Left：缩小选中范围
Alt+Shift+鼠标左键：同时选中编辑多行多列代码（秀儿）
Ctrl+Alt+Up：向上复制光标
Ctrl+Alt+Down：向下复制光标
Ctrl+U：回退到上一个光标处
F12：转到定义处
Alt+F12：查看定义处缩略图

### 查看全部快捷键

- Ctrl+K Ctrl+S：查看VSCode中全部快捷键
- Ctrl+K Ctrl+R：查看keyboard-shortcuts-windows.pdf







**对于行的操作**：

- 重开一行：光标在行尾的话，回车即可；不在行尾，ctrl` + enter` 向下重开一行；ctrl+`shift + enter` 则是在上一行重开一行
- 删除一行：光标没有选择内容时，ctrl` + x` 剪切一行；ctrl +`shift + k` 直接删除一行
- 移动一行：`alt + ↑` 向上移动一行；`alt + ↓` 向下移动一行
- 复制一行：`shift + alt + ↓` 向下复制一行；`shift + alt + ↑` 向上复制一行
- ctrl + z 回退

**对于词的操作**：

- 选中一个词：ctrl` + d`

**搜索或者替换**：

- ctrl` + f` ：搜索
- ctrl` + alt + f`： 替换
- ctrl` + shift + f`：在项目内搜索



- 通过**Ctrl + `** 可以打开或关闭终端
- Ctrl+P 快速打开最近打开的文件
- Ctrl+Shift+N 打开新的编辑器窗口
- Ctrl+Shift+W 关闭编辑器
- Home 光标跳转到行头
- End 光标跳转到行尾
- Ctrl + Home 跳转到页头
- Ctrl + End 跳转到页尾
- Ctrl + Shift + [ 折叠区域代码
- Ctrl + Shift + ] 展开区域代码
- Ctrl + / 添加关闭行注释
- Shift + Alt +A 块区域注释

## 应用技巧

## 修改左侧文件名字体大小

1. 

|          任务          | 操作                                                         |
| :--------------------: | ------------------------------------------------------------ |
| 修改左侧文件名字体大小 | 1、位置：C:\Users\lhhriver\AppData\Local\Programs\Microsoft VS Code\resources\app\out\vs\workbench <br />2、文件：workbench.desktop.main.css <br />3、搜索：.monaco-workbench .part>.content <br />4、设置：{font-size:16px} |
|         主命令         | 1、F1 或 Ctrl+Shift+P：俗称万能键，可以输入任何命令<br />2、Ctrl+P：根据名称查找文件。当前模式下输入 `>` 可以进入 Ctrl+Shift+P 模式<br />3、Ctrl+P模式下可以通过输入符号来进行快捷方式查找转换，如下：<br />①“?” 列出当前可执行的动作；<br />②“!” 显示 Errors 或 Warnings；<br />③“:” 跳转到行数；<br />④“#” 根据名字查找symbol，也可以 Ctrl+T；<br />⑤“@” 跳转到symbol（搜索当前页面的标签、变量、属性、类名、函数等），也可以 Ctrl+Shift+O 直接进入；<br />⑥“@:” 跳转到symbol（分类搜索当前页面的标签、变量、属性、类名、函数等），也可以 Ctrl+Shift+O 后输入 : 进入； |
|                        |                                                              |

