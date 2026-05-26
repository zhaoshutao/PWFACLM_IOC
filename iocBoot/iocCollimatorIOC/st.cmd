#!../../bin/windows-x64/CollimatorIOC

#- SPDX-FileCopyrightText: 2000 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS

#- You may have to change CollimatorIOC to something else
#- everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/CollimatorIOC.dbd"
CollimatorIOC_registerRecordDeviceDriver pdbbase

## Load record instances
dbLoadTemplate "db/user.substitutions"
dbLoadRecords "db/CollimatorIOCVersion.db", "user=Administrator"
dbLoadRecords "db/dbSubExample.db", "user=Administrator"



# use the following commands for TCP/IP
drvAsynIPPortConfigure("R03CLM", "192.168.201.137:502",0,0,1)
modbusInterposeConfig("R03CLM", 0,2000, 0)

#drvModbusAsynConfigure("portName", 	"tcpPortName",		slaveAddress,	modbusFunction,		modbusStartAddress,	 modbusLength,		dataType,		pollMsec,	"plcType")
#BO,EPICS->PLC,Commnad
drvModbusAsynConfigure("R03CLM_BO1_Bits", 	"R03CLM",		0, 		6, 			12288, 			100, 			0, 			100, 		"simulation")
drvModbusAsynConfigure("R03CLM_BO2_Bits", 	"R03CLM",		0, 		6, 			12289, 			100, 			0, 			100, 		"simulation")
drvModbusAsynConfigure("R03CLM_BO3_Bits", 	"R03CLM",		0, 		6, 			12290, 			100, 			0, 			100, 		"simulation")
drvModbusAsynConfigure("R03CLM_BO4_Bits", 	"R03CLM",		0, 		6, 			12291, 			100, 			0, 			100, 		"simulation")
#BI,PLC->EPICS,Response
drvModbusAsynConfigure("R03CLM_BI1_Bits", 	"R03CLM",		0, 		3, 			12293, 			100, 			0,	 		100, 		"simulation")
drvModbusAsynConfigure("R03CLM_BI2_Bits", 	"R03CLM",		0, 		3, 			12294, 			100, 			0,	 		100, 		"simulation")
drvModbusAsynConfigure("R03CLM_BI3_Bits", 	"R03CLM",		0, 		3, 			12295, 			100, 			0,	 		100, 		"simulation")
#AO,EPICS->PLC,Commnad
drvModbusAsynConfigure("R03CLM_AO1_FLOAT", 	"R03CLM",		0, 		16, 			12538, 			123, 			0, 			100, 		"simulation")
drvModbusAsynConfigure("R03CLM_AO2_FLOAT", 	"R03CLM",		0, 		16, 			12588, 			123, 			0, 			100, 		"simulation")
#AO,PLC->EPICS,Response
drvModbusAsynConfigure("R03CLM_AI1_FLOAT", 	"R03CLM",		0, 		3, 			12638, 			100, 			0,	 		100, 		"simulation")
drvModbusAsynConfigure("R03CLM_AI2_FLOAT", 	"R03CLM",		0, 		3, 			12688, 			100, 			0,	 		100, 		"simulation")
#IntIn,PLC->EPICS,Response
drvModbusAsynConfigure("R03CLM_Intin", 	"R03CLM",		0, 		3, 			12694, 			100, 			0,	 		100, 		"simulation")
#StingIn,PLC->EPICS,Response
drvModbusAsynConfigure("R03CLM_Stringin", 	"R03CLM",		0, 		3, 			12696, 			100, 			0,	 		100, 		"simulation")

cd "${TOP}/iocBoot/${IOC}"
dbLoadTemplate("R03CLM.substitutions")

#- Set this to see messages from mySub
#-var mySubDebug 1

#- Run this to trace the stages of iocInit
#-traceIocInit

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncExample, "user=Administrator"
