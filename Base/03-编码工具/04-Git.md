# 常用的20个Git命令

很多人关于git命令没有形成比较统一、可以自己借鉴的模板，所以在此文中，我将讨论在使用Git时经常使用的前20个Git命令。并带有相关示例，希望能够帮助你们。

以下是涉及的Git命令：

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-769238.jpg)



# **Git命令**

## git config

- 用法： git config –global user.name “[name]”
- 用法： git config –global user.email “[email address]”

此命令分别设置要与提交一起使用的作者姓名和电子邮件地址。

```
git config --global user.name "liuhuihe"
git config --global user.email "lhhriver@163.com"
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-745825.jpg)



## git init

- 用法： git init [repository name]

此命令用于启动新的存储库。

```
git init  /home/liuhuihe/DEMO
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-797132.jpg)



## git clone

- 用法： git clone [url]

此命令用于从现有URL获取存储库。

```
git clone https://github.com/jalammar/jalammar.github.io.git
git clone git@17.163.18.443:/home//src/nlp.git
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-777186.jpg)



## git add

- 用法： git add [file]

此命令将文件添加到暂存区域。

```
git add test.py
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-753662.jpg)



- 用法： git add *

此命令将一个或多个添加到暂存区域。

```
git add *
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-967351.jpg)



## git commit

- 用法： git commit -m “[ Type in the commit message]”

此命令在版本历史记录中永久记录或快照文件。

```
git commit -m "First Commit"
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-832100.jpg)



- 用法： git commit -a

此命令将提交你使用git add命令添加的所有文件，并且还将提交自此以来已更改的所有文件。

```
git commit -a
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-941696.jpg)



## git diff

- 用法： git diff

此命令显示尚未暂存的文件差异。

```
git diff
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-684180.jpg)



- git diff –staged

此命令显示暂存区域中的文件与当前最新版本之间的差异。

```
git diff -staged
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-854018.jpg)



- 用法： git diff [first branch] [second branch]

该命令显示了上述两个分支之间的差异。

```
git diff branch_2 branch_3
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-858717.jpg)



## git reset

- 用法： git reset [file]

此命令取消暂存文件，但保留文件内容。

```
git reset site.css
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-836118.jpg)



- 用法： git reset [commit]

此命令在指定的提交后撤消所有提交，并在本地保留更改。

```
git reset heliluya
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-818136.jpg)



- 用法： git reset –hard [commit] 

此命令将丢弃所有历史记录，并返回到指定的提交。

```
git reset -hard haliluya
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-801122.jpg)



## git status

- 用法： git status

该命令列出了所有必须提交的文件。

```
git status
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-809161.jpg)



## git rm

- 用法： git rm [file]

此命令从你的工作目录中删除文件，然后进行删除。

```
git rm test.py
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-793143.jpg)



```
# 删除缓存区文件，再提交可以删除远程文件，本地不受影响
git rm -r --cached .idea
```



## git log

- 用法： git log

此命令用于列出当前分支的版本历史记录。

```
git log
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-749673.jpg)



- 用法： git log –follow[file]

此命令列出了文件的版本历史记录，包括文件的重命名。

```
git log -follow project_1
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-827143.jpg)



## git show

- 用法： git show [commit]

此命令显示指定提交的元数据和内容更改。

```
git show dfgdfgs
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-724073.jpg)



## git tag

- 用法： git tag [commitID]

该命令用于将标签赋予指定的提交。

```
git tag dfgsdfgsdfgsdf
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231056-005054.jpg)



## git branch

- 用法： git branch

此命令列出当前存储库中的所有本地分支。

```
git branch
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-805112.jpg)

列出本地及远程分支

```
git branch -a
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20210610-092612-207315.png)

- 用法： git branch [branch name]

此命令创建一个新分支。

```
git branch  branch_1
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-785164.jpg)

新建并跳转到分支

```
git checkout -b dbg_lichen_star
```



- 用法： git branch -d [branch name]

此命令删除功能分支。

```
git branch -d branch_1
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-844621.jpg)



## git checkout

- 用法： git checkout [branch name]

此命令用于从一个分支切换到另一个分支。

```
git checkout branch_2
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-781175.jpg)



- 用法： git checkout -b [branch name]

该命令将创建一个新分支，并切换到该分支。

```
git checkout -b branch_4
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-735046.jpg)



## git merge

- 用法： git merge [branch name]

此命令将指定分支的历史记录合并到当前分支中。

```
git merge branch_2
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-840632.jpg)



## git remote

- 用法： git remote add [variable name] [Remote Server Link]

此命令用于将本地存储库连接到远程服务器。

```
git remote add origin http://github.com/lhhriver
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-898107.jpg)



## git push

- 用法： git push [variable name] master

此命令将提交的master分支更改提交到远程存储库。

```
git push origin master
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-902091.jpg)

- 用法： git push [variable name] [branch]

此命令将分支提交发送到你的远程存储库。

```
git push origin master
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-765382.jpg)

- 用法： git push –all [variable name]

此命令将所有分支推送到你的远程存储库。

```
git push --all origin
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-989090.jpg)



- 用法： git push [variable name] :[branch name]

推送分支到远程

```
git push origin develop:develop
```

此命令删除远程存储库上的分支,  推送空到远程分支。

```
git push origin  :branch_2
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-789154.jpg)

或者

```
git push origin --delete branch_2
```



## git pull

- 用法： git pull [Repository Link]

该命令获取远程服务器上的更改并将其合并到你的工作目录中。

```
git pull https://github.com/lhhriver.git
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-814147.jpg)

```
git pull origin master
```



## git stash

- 用法： git stash save

此命令临时存储所有已修改的跟踪文件。

```
git stash save
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-849033.jpg)

- 用法： git stash pop

此命令恢复最近存放的文件。

```
git stash pop
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-862701.jpg)



- 用法： git stash list

此命令列出所有隐藏的变更集。

```
git stash list
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-822126.jpg)

- 用法： git stash drop

此命令将丢弃最近存放的变更集。

```
git stash drop stash@{0}
```

![](https://gitee.com/liuhuihe/Ehe/raw/master/images/03-编码工具-20201215-231055-773198.jpg)



#  git 教程

## 代码提交

- 提交暂存区到仓库区

```
git commit -m "update"
```

- 提交暂存区的指定文件到仓库区

```
git commit [file1] [file2] ... -m [message]
```

- 提交工作区自上次commit之后的变化，直接到仓库区

```
git commit -a
```

- 提交时显示所有diff信息

```
git commit -v
```

- 使用一次新的commit，替代上一次提交
- 如果代码没有任何新变化，则用来改写上一次commit的提交信息

```
git commit --amend -m [message]
```

- 重做上一次commit，并包括指定文件的新变化

```
git commit --amend [file1] [file2] ...
```



## 分支

- 列出所有本地分支

```
git branch
```

- 列出所有远程分支

```
git branch -r
```

- 列出所有本地分支和远程分支

```
git branch -a
```

- 新建一个分支，但依然停留在当前分支

```
git branch dev
```

- 新建一个分支，并切换到该分支

```
git checkout -b dev
git switch -c dev
```

- 切换到指定分支，并更新工作区

```
git checkout dev
git switch master
```

- 合并指定分支到当前分支

```
git checkout master
git merge dev
```

- 删除分支

```
git branch -d dev
```

- 删除远程分支

```
git push origin --delete dev
```



## 查看信息

- 显示有变更的文件

```
git status
```

- 显示当前分支的版本历史, 命令显示从最近到最远的提交日志

```
git log
git log --pretty=oneline
```

- 用来记录你的每一次命令

```
git reflog
```

- 显示暂存区和工作区的差异

```
git diff
```



## 远程同步

- 下载远程仓库的所有变动

```
git fetch [remote]
```

- 显示所有远程仓库

```
git remote -v
```

- 显示某个远程仓库的信息

```
git remote show https://gitee.com/liuhuihe/AC_Project.git
```

- 增加一个新的远程仓库，并命名

```
git remote add dev https://gitee.com/neimenggudaxue/dev.git
```

- 本地电脑连接码云项目

```
git remote add origin https://gitee.com/liuhuihe/AC_Notebook.git
```

- 取回远程仓库的变化，并与本地分支合并

```
git pull origin master
```

-  上传本地指定分支到远程仓库

```
git push origin dev
-- 强制推送
git push origin dev -f
```

- 强行推送当前分支到远程仓库，即使有冲突

```
git push [remote] --force
```

- 推送所有分支到远程仓库

```
git push [remote] --all
```



## 撤销

- 恢复暂存区的指定文件到工作区

```
git checkout [file]
```

- --恢复某个commit的指定文件到暂存区和工作区

```
git checkout [commit] [file]
```

-  恢复暂存区的所有文件到工作区

```
git checkout .
```

- 把readme.txt文件在工作区的修改全部撤销, 回到最近一次git commit或git add时的状态

```
git checkout -- readme.txt
```

- 重置暂存区的指定文件，与上一次commit保持一致，但工作区不变

```
git reset [file]
```

- 重置暂存区与工作区，与上一次commit保持一致

```
git reset --hard
git reset --hard HEAD^   # 上一个版本
git reset --hard HEAD^^   # 上上一个版本
git reset --hard HEAD~100   # 上100个版本
git reset --hard 1094a   # 返回撤销的版本1094a...
```

- 把暂存区的修改撤销掉（unstage），重新放回工作区

```
git reset HEAD readme.txt
```



## 标签

- 列出所有tag

```
git tag
```

- 新建一个tag在当前commit

```
git tag [tag]
```

- 新建一个tag在指定commit

```
git tag [tag] [commit]
```

- 删除本地tag

```
git tag -d [tag]
```

- 删除远程tag

```
git push origin :refs/tags/[tagName]
```

- 查看tag信息

```
git show [tag]
```

- 提交指定tag

```
git push [remote] [tag]
```

- 提交所有tag

```
git push [remote] --tags
```

- 新建一个分支，指向某个tag

```
git checkout -b [branch] [tag]
```



## 提交到服务器

**服务器**

```
git init --bare UncleNLP.git
chown -R git:git UncleNLP.git
```

**本地**

```
git init
git remote add origin git@17.1.1.1:/home/nlp/UncleNLP.git
```



# 参考资料

[狂神说](https://mp.weixin.qq.com/s/Bf7uVhGiu47uOELjmC5uXQ)

[CSDN](https://blog.csdn.net/Maiduoudo/article/details/96998986)