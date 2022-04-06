@echo off

echo "pull and update Ehe*****************************" 
D:
cd D:\Gitee\Ehe
git pull origin master
git add .
git commit -m "update"
git push origin master

echo "pull and update DDU*****************************" 
D:
cd D:\Gitee\DDU
git pull origin master
git add .
git commit -m "update"
git push origin master