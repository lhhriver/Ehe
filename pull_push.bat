@echo off

echo "==============  Update Eh88e  ==============" 
D:
cd D:\Gitee\Ehe

echo:
git add .

echo:
git commit -m "update"


echo:
echo "==============  Pull  Ehe  =============" 
git pull origin master

echo:
git push origin master


echo:
echo "==============  Update DDU  ==============" 
D:
cd D:\Gitee\DDU


echo:
git add .

echo:
git commit -m "update"

echo:
echo "==============  Pull DDU  ==============" 
git pull origin master

echo:
git push origin master

echo:
pause