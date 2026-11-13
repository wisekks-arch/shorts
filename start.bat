@echo off
chcp 65001 > nul
title 유튜브 쇼츠 자동 제작기 (ShortsMaker)
echo ========================================================
echo  유튜브 쇼츠 자동 제작기 (ShortsMaker) 로컬 서버 구동
echo ========================================================
powershell -ExecutionPolicy Bypass -File "%~dp0server.ps1"
pause

