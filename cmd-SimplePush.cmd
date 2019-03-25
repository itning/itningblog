@echo off
SET NOW_TIME=%date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%%time:~6,2%
git add .\source\_posts\*
git commit -m "NEW-POST-%NOW_TIME%"
git push --all
PAUSE