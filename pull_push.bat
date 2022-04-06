@echo off

echo "~~~~~~   Pull  Ehe   ~~~~~~" 
D:
cd D:\Gitee\Ehe
git pull origin master

echo:
echo "~~~~~~   Update Ehe   ~~~~~~" 
git add .

echo:
git commit -m "update"

echo:
git push origin master

echo:
echo "~~~~~~   Pull DDU   ~~~~~~" 
D:
cd D:\Gitee\DDU
git pull origin master

echo:
echo "~~~~~~   Update DDU   ~~~~~~" 
git add .

echo:
git commit -m "update"

echo:
git push origin master

echo:
pause