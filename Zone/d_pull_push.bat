@echo off

echo ==============  Update Ehe  =========================================
D:
cd D:\Gitee\Ehe

echo:
git add .

echo:
git commit -m "update"

echo:
echo ==============  Pull  Ehe  =============
git pull origin master

echo:
git push origin master



echo:
echo ==============  Update DDU  ========================================
D:
cd D:\Gitee\DDU

echo:
git add .

echo:
git commit -m "update"

echo:
echo ==============  Pull DDU  ==============
git pull origin master

echo:
git push origin master


echo:
echo ==============  Update DeepRed  ======================================
D:
cd D:\Gitee\DeepRed

echo:
git add .

echo:
git commit -m "update"

echo:
echo ==============  Pull DeepRed  ==============
git pull origin master

echo:
git push origin master


echo:
echo ==============  Update ICEhe  ======================================
D:
cd D:\Gitee\ICEhe

echo:
git add .

echo:
git commit -m "update"

echo:
echo ==============  Pull ICEhe  ==============
git pull origin master

echo:
git push origin master

echo:
pause