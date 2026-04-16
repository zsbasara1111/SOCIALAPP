@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo [1/3] 正在编译 Flutter Web...
call C:\Users\admin\flutter\bin\flutter build web
if %ERRORLEVEL% neq 0 (
    echo 编译失败，请检查代码错误
    pause
    exit /b 1
)

echo [2/3] 编译完成，启动本地服务器...
:: 检查 8088 端口是否已被占用
curl -s -o nul -w "%%{http_code}" http://localhost:8088/ | findstr "200" >nul
if %ERRORLEVEL% equ 0 (
    echo 本地服务器已在运行
) else (
    start /min cmd /c "cd /d "%~dp0build\web" && npx serve -l 8088"
    timeout /t 3 >nul
)

echo [3/3] 正在打开浏览器...
start http://localhost:8088

echo.
echo =========================================
echo 预览地址: http://localhost:8088
echo 修改代码后重新运行此脚本即可看到最新效果
echo =========================================
pause
