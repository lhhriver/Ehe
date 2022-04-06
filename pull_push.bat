@echo off

echo "--------------   ¡¾Pull  Ehe ¡¿   -------------" 
D:
cd D:\Gitee\Ehe
git pull origin master

echo:
echo "--------------   ¡¾Update Ehe¡¿   --------------" 
git add .

echo:
git commit -m "update"

echo:
git push origin master

echo:
echo "--------------   ¡¾Pull DDU¡¿   --------------" 
D:
cd D:\Gitee\DDU
git pull origin master

echo:
echo "--------------   ¡¾Update DDU¡¿   --------------" 
git add .

echo:
git commit -m "update"

echo:
git push origin master

echo:
pause