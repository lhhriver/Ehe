@echo off

echo ==============  Update Ehe  ==============
G:
cd G:\LocalSpace\Gitee\Ehe

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
echo ==============  Update DDU  ==============
G:
cd G:\LocalSpace\Gitee\DDU

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
pause