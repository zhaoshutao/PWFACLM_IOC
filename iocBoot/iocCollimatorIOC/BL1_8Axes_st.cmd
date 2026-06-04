#!../../bin/windows-x64/CollimatorIOC

# BL1 10-Axis Collimator IOC Startup Script
# PLC: 192.168.201.137:502 (single TwinCAT, 10 axes)
# Register map confirmed from GVL.TcGVL (base = 12288 = %MW0)

< envPaths

# Lock CA server to single interface to avoid duplicate detection
epicsEnvSet("EPICS_CAS_INTF_ADDR_LIST","192.168.201.137")
epicsEnvSet("EPICS_CAS_BEACON_ADDR_LIST","192.168.201.137")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/CollimatorIOC.dbd"
CollimatorIOC_registerRecordDeviceDriver pdbbase

## Load basic records
dbLoadTemplate "db/user.substitutions"
dbLoadRecords "db/CollimatorIOCVersion.db", "user=balmy"

# ================================================================
# Modbus TCP connection to TWINCAT PLC
# ================================================================
drvAsynIPPortConfigure("BL1", "192.168.201.137:502", 0, 0, 1)
modbusInterposeConfig("BL1", 0, 2000, 0)

# drvModbusAsynConfigure params:
#   portName, tcpPortName, slaveAddr, modbusFn, startAddr, length, dataType, pollMsec, plcType

# ===== BO: EPICS -> PLC commands (fc=6, write single register) =====

# Global control: %MW0 (reg 12288), bits 0-2
drvModbusAsynConfigure("BL1_BO_Global",  "BL1", 0, 6, 12288, 1, 0, 100, "simulation")

# All-axis commands: %MW2 (reg 12290), bits 0-4
drvModbusAsynConfigure("BL1_BO_AllAxes", "BL1", 0, 6, 12290, 1, 0, 100, "simulation")

# Per-axis BOOL commands: %MW4..%MW22 (reg 12292..12310)
# Axis 1 (%MW4): 12292, Axis 2 (%MW6): 12294, ... Axis 10 (%MW22): 12310
drvModbusAsynConfigure("BL1_BO_Axis1",   "BL1", 0, 6, 12292, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BO_Axis2",   "BL1", 0, 6, 12294, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BO_Axis3",   "BL1", 0, 6, 12296, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BO_Axis4",   "BL1", 0, 6, 12298, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BO_Axis5",   "BL1", 0, 6, 12300, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BO_Axis6",   "BL1", 0, 6, 12302, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BO_Axis7",   "BL1", 0, 6, 12304, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BO_Axis8",   "BL1", 0, 6, 12306, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BO_Axis9",   "BL1", 0, 6, 12308, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BO_Axis10",  "BL1", 0, 6, 12310, 1, 0, 100, "simulation")

# ===== AO: EPICS -> PLC REAL params (fc=16, write multiple) =====
# Split into 3 ports: each ≤4 axes (≤28 REALs) to stay under ~123-byte driver limit
# Port 1: Axis 1-4 (COLV01×2 + COLH01×2), 28 REALs, start at %MB200 (reg 12388)
drvModbusAsynConfigure("BL1_AO_FLOAT_1", "BL1", 0, 16, 12388, 120, 0, 100, "simulation")
# Port 2: Axis 5-8 (COLV02×2 + COLH02×2), 28 REALs, start at %MB312 (reg 12444)
drvModbusAsynConfigure("BL1_AO_FLOAT_2", "BL1", 0, 16, 12444, 120, 0, 100, "simulation")
# Port 3: Axis 9-10 (BL2COL1 + BL2COL2), 14 REALs, start at %MB424 (reg 12500)
drvModbusAsynConfigure("BL1_AO_FLOAT_3", "BL1", 0, 16, 12500, 64, 0, 100, "simulation")

# ===== BI: PLC -> EPICS status (fc=3, read) =====

# Global status: %MW601 (MOD_AxisStatW[1] spare word) = reg 12889
drvModbusAsynConfigure("BL1_BI_Global",  "BL1", 0, 3, 12889, 1, 0, 100, "simulation")

# Per-axis BOOL status: %MW600..%MW618 = reg 12888..12906
drvModbusAsynConfigure("BL1_BI_Axis1",   "BL1", 0, 3, 12888, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BI_Axis2",   "BL1", 0, 3, 12890, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BI_Axis3",   "BL1", 0, 3, 12892, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BI_Axis4",   "BL1", 0, 3, 12894, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BI_Axis5",   "BL1", 0, 3, 12896, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BI_Axis6",   "BL1", 0, 3, 12898, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BI_Axis7",   "BL1", 0, 3, 12900, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BI_Axis8",   "BL1", 0, 3, 12902, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BI_Axis9",   "BL1", 0, 3, 12904, 1, 0, 100, "simulation")
drvModbusAsynConfigure("BL1_BI_Axis10",  "BL1", 0, 3, 12906, 1, 0, 100, "simulation")

# ===== AI: PLC -> EPICS REAL values (fc=3, read) =====
# Split into 2 ports: each ≤5 axes (≤15 REALs) to stay under ~125-byte driver limit
# Port 1: Axis 1-5, 15 REALs, start at %MB700 (reg 12638)
drvModbusAsynConfigure("BL1_AI_FLOAT_1", "BL1", 0, 3, 12638, 68, 0, 100, "simulation")
# Port 2: Axis 6-10, 15 REALs, start at %MB760 (reg 12668)
drvModbusAsynConfigure("BL1_AI_FLOAT_2", "BL1", 0, 3, 12668, 68, 0, 100, "simulation")

# ===== Error info =====
# ErrorId INT at %MB820 (reg 12698) — moved from %MB800 to avoid overlap with Axis 9/10 AI_FLOAT
drvModbusAsynConfigure("BL1_ErrorId",    "BL1", 0, 3, 12698, 1, 0, 100, "simulation")

# ErrorDescription STRING at %MB824 (reg 12700) — moved from %MB804
drvModbusAsynConfigure("BL1_ErrorStr",   "BL1", 0, 3, 12700, 125, 0, 100, "simulation")

# ================================================================
# Load 10-axis PV substitutions
# ================================================================
cd "${TOP}/iocBoot/${IOC}"
dbLoadTemplate("BL1_8Axes.substitutions")

#- Set this to see messages from mySub
#-var mySubDebug 1

#- Run this to trace the stages of iocInit
#-traceIocInit

iocInit

## Start any sequence programs
#seq sncExample, "user=balmy"
