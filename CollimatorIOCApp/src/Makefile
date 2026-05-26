# SPDX-FileCopyrightText: 1998 Argonne National Laboratory
#
# SPDX-License-Identifier: EPICS

TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE

# Use typed rset structure (see 3.16.1 release notes)
USR_CPPFLAGS += -DUSE_TYPED_RSET

# xxxRecord.h will be created from xxxRecord.dbd
DBDINC += xxxRecord

# Install xxxSupport.dbd into <top>/dbd
DBD += xxxSupport.dbd

# Build an IOC support library
LIBRARY_IOC += CollimatorIOCSupport

# Compile and add code to the support library
CollimatorIOCSupport_SRCS += xxxRecord.c
CollimatorIOCSupport_SRCS += devXxxSoft.c

# Link locally-provided code into the support library,
# rather than directly into the IOC application, that
# causes problems on Windows DLL builds
CollimatorIOCSupport_SRCS += dbSubExample.c
CollimatorIOCSupport_SRCS += devCollimatorIOCVersion.c
CollimatorIOCSupport_SRCS += CollimatorIOCHello.c
CollimatorIOCSupport_SRCS += initTrace.c

CollimatorIOCSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

# Auto-generate a header file containing a version string.
# Version comes from the VCS if available, else date+time.
GENVERSION = CollimatorIOCVersion.h
# Macro name
GENVERSIONMACRO = CollimatorIOCVERSION

# Build the IOC application
PROD_IOC = CollimatorIOC

# CollimatorIOC.dbd will be created and installed
DBD += CollimatorIOC.dbd

# CollimatorIOC.dbd will include these files:
CollimatorIOC_DBD += base.dbd
CollimatorIOC_DBD += xxxSupport.dbd
CollimatorIOC_DBD += dbSubExample.dbd
CollimatorIOC_DBD += devCollimatorIOCVersion.dbd
CollimatorIOC_DBD += CollimatorIOCHello.dbd
CollimatorIOC_DBD += initTrace.dbd

#balmy
CollimatorIOC_DBD += asyn.dbd
CollimatorIOC_DBD += drvAsynIPPort.dbd
CollimatorIOC_DBD += modbusSupport.dbd

CollimatorIOC_LIBS += asyn
CollimatorIOC_LIBS += modbus

# CollimatorIOC_registerRecordDeviceDriver.cpp derives from CollimatorIOC.dbd
CollimatorIOC_SRCS += CollimatorIOC_registerRecordDeviceDriver.cpp

# Build the main IOC entry point where needed
CollimatorIOC_SRCS_DEFAULT += CollimatorIOCMain.cpp
CollimatorIOC_SRCS_vxWorks += -nil-

# Link in the code from our support library
CollimatorIOC_LIBS += CollimatorIOCSupport

# To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file
ifneq ($(SNCSEQ),)
    # Build sncExample into CollimatorIOCSupport
    sncExample_SNCFLAGS += +r
    CollimatorIOC_DBD += sncExample.dbd
    # A .stt sequence program is *not* pre-processed:
    CollimatorIOCSupport_SRCS += sncExample.stt
    CollimatorIOCSupport_LIBS += seq pv
    CollimatorIOC_LIBS += seq pv

    # Build sncProgram as a standalone program
    PROD_HOST += sncProgram
    sncProgram_SNCFLAGS += +m
    # A .st sequence program *is* pre-processed:
    sncProgram_SRCS += sncProgram.st
    sncProgram_LIBS += seq pv
    sncProgram_LIBS += $(EPICS_BASE_HOST_LIBS)
endif

# Link QSRV (pvAccess Server) if available
ifdef EPICS_QSRV_MAJOR_VERSION
    CollimatorIOC_LIBS += qsrv
    CollimatorIOC_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    CollimatorIOC_DBD += PVAServerRegister.dbd
    CollimatorIOC_DBD += qsrv.dbd
endif

# Finally link IOC to the EPICS Base libraries
CollimatorIOC_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devCollimatorIOCVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
