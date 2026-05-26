@echo off
set EPICS_HOST_ARCH=windows-x64
set PATH=C:\Epics\base-7.0.9\bin\windows-x64;C:\Epics\support\asyn-R4-43\bin\windows-x64;C:\Epics\support\modbus-R3-3\bin\windows-x64;%PATH%
set EPICS_CA_ADDR_LIST=192.168.201.137
set EPICS_CA_AUTO_ADDR_LIST=NO
set EPICS_CAS_INTF_ADDR_LIST=192.168.201.137
set EPICS_CAS_BEACON_ADDR_LIST=192.168.201.137
cd /d %~dp0
..\..\bin\windows-x64\CollimatorIOC.exe BL1_8Axes_st.cmd
