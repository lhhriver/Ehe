@echo off
cd ..

echo:
git add .

echo:
for /f "tokens=*" %%a in ('WMIC OS GET LocalDateTime ^| find "."') do set datetime=%%a
set datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%:%datetime:~12,6%
set GIT_COMMITTER_DATE=%datetime%
git commit -m "updated by Ehe at %GIT_COMMITTER_DATE%"

echo:
git push origin master

echo:
git add .

echo:
git commit -m "updated by Ehe at %GIT_COMMITTER_DATE%"

echo:
git push origin master
echo:
pause