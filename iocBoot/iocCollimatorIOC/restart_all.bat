@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ============================================
echo   TwinCAT + IOC 一键重启
echo ============================================
echo.

REM === 1. 停 IOC ===
echo [1/4] 停止 IOC...
taskkill /f /im CollimatorIOC.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo   CollimatorIOC.exe 已终止
) else (
    echo   IOC 未在运行
)

REM === 2. 触发 TwinCAT 重启 ===
echo [2/4] 触发 TwinCAT Runtime 重启...
"C:\Program Files\Python311\python.exe" -c "from pymodbus.client import ModbusTcpClient; c=ModbusTcpClient('192.168.201.137',port=502,timeout=3); c.connect(); c.write_register(12288,0x0004); c.close(); print('restartTC 已写入')"
if %errorlevel% neq 0 (
    echo   写入失败，请检查网络连接！
    pause
    exit /b 1
)
echo   restartTC 已发送，PLC 正在重启...

REM === 3. 等待 PLC 恢复 ===
echo [3/4] 等待 PLC 恢复 (最多 90 秒)...
set /a tick=0
:wait_loop
timeout /t 3 /nobreak >nul
set /a tick+=3
"C:\Program Files\Python311\python.exe" -c "from pymodbus.client import ModbusTcpClient; c=ModbusTcpClient('192.168.201.137',port=502,timeout=2); r=c.connect(); r2=c.read_holding_registers(12288,1) if r else None; c.close(); exit(0 if r and r2 and not r2.isError() else 1)" >nul 2>&1
if %errorlevel% equ 0 (
    echo   PLC 已就绪 (耗时 !tick!s)
    goto :plc_ready
)
if !tick! geq 90 (
    echo   等待超时！请手动检查 PLC 状态
    pause
    exit /b 1
)
echo   等待中... !tick!s
goto :wait_loop

:plc_ready

REM 额外等 3 秒确保 TwinCAT 完全初始化
timeout /t 3 /nobreak >nul

REM === 4. 启动 IOC ===
echo [4/4] 启动 IOC...
cd /d "%~dp0"
start "BL1 IOC" "%~dp0start_bl1_silent.bat"
echo   IOC 已启动
echo.
echo ============================================
echo   完成！请等待 IOC 初始化 (约 5 秒)
echo ============================================
timeout /t 5 /nobreak >nul
