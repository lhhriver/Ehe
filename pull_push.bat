@echo off

echo ">>>> pull and update Ehe <<<<" 
D:
cd D:\Gitee\Ehe
git pull origin master

echo:
git add .

echo:
git commit -m "update"

echo:
git push origin master

echo:
echo ">>>> pull and update DDU <<<<" 
D:
cd D:\Gitee\DDU
git pull origin master

echo:
git add .

echo:
git commit -m "update"

echo:
git push origin master

echo:
pause