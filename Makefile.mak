# ReC98
# -----
# Makefile for the 16-bit part of the build process

CFLAGS = -ls -Ilibs\master.lib\ -I. -Lbin\ -O -a2

TH01 = \zunsoft.com \op.exe \reiiden.exe \fuuin.exe
TH02 = \zuninit.com \zun_res.com \op.exe \main.exe \maine.exe \zun.com
TH03 = \zunsp.com \res_yume.com \op.exe \main.exe \mainl.exe \zun.com
TH04 = \res_huma.com \op.exe \main.exe \maine.exe
TH05 = \res_kso.com \op.exe \main.exe \maine.exe

all: th01 th02 th03 th04 th05
	@echo Done. Find the executables in the bin\ subdirectory.

th01:: $(TH01:\=bin\th01\)
th02:: $(TH02:\=bin\th02\)
th03:: $(TH03:\=bin\th03\)
th04:: $(TH04:\=bin\th04\)
th05:: $(TH05:\=bin\th05\)

.obj.exe:
	$(CC) $(CFLAGS) -ml $**

.obj.com:
	tlink /t /3 $**

bin\th01\zunsoft.com: th01\zunsoft.c
	$(CC) $(CFLAGS) -mt -lt -nbin\th01\ $** masters.lib

bin\th01\op.exe: bin\th01\op.obj th01\op_03.c th01\op_04.c th01\op_10.c th01\op_11.c th01\op_12.cpp
	$(CC) $(CFLAGS) -ml -3 -nbin\th01\ -eOP.EXE @&&|
$**
|

bin\th01\reiiden.exe: bin\th01\reiiden.obj th01\main_03.c th01\main_04.c th01\main_12.c th01\main_13.c th01\main_14.c th01\main_16.c
	$(CC) $(CFLAGS) -ml -3 -nbin\th01\ -eREIIDEN.EXE @&&|
$**
|

bin\th01\fuuin.exe: bin\th01\fuuin.obj th01\fuuin_05.c th01\fuuin_06.c th01\fuuin_11.c th01\fuuin_12.c th01\fuuin_13.c
	$(CC) $(CFLAGS) -ml -3 -nbin\th01\ -eFUUIN.EXE @&&|
$**
|

bin\th02\zun_res.com: th02\zun_res1.c th02\zun_res2.c
	$(CC) $(CFLAGS) -mt -lt -Z -nbin\th02\ -eZUN_RES.COM @&&|
$**
| masters.lib

bin\th02\op.exe: th02\op_01.c bin\th02\op.obj th02\op_02_1.c th02\op_02_2.c th02\op_03.c th02\op_04.c th02\op_05.c th02\op_06.c
	$(CC) $(CFLAGS) -ml -Z -DGAME=2 -nbin\th02\ -eOP.EXE @&&|
$**
|

bin\th02\main.exe: bin\th02\main.obj th02\main02_1.c th02\main02_2.c
	$(CC) $(CFLAGS) -ml -Z -DGAME=2 -nbin\th02\ -eMAIN.EXE @&&|
$**
|

bin\th02\maine.exe: bin\th02\maine.obj th02\maine021.c th02\maine022.c th02\maine_03.c th02\maine_04.c th02\maine_05.c
	$(CC) $(CFLAGS) -ml -3 -Z -DGAME=2 -nbin\th02\ -eMAINE.EXE @&&|
$**
|

bin\th03\op.exe: bin\th03\op.obj th03\op_02.c
	$(CC) $(CFLAGS) -ml -DGAME=3 -nbin\th03\ -eOP.EXE @&&|
$**
|

bin\th04\op.exe: bin\th04\op.obj th04\op_02.c
	$(CC) $(CFLAGS) -ml -DGAME=4 -nbin\th04\ -eOP.EXE @&&|
$**
|

# ZUN.COM packing

bin\zuncom\gensize.com: zuncom\gensize.c
	mkdir bin\zuncom
	$(CC) $(CFLAGS) -mt -lt -nbin\zuncom\ -eGENSIZE.COM $**

bin\zuncom\copycat.com: zuncom\copycat.c
	mkdir bin\zuncom
	$(CC) $(CFLAGS) -mt -lt -nbin\zuncom\ -eCOPYCAT.COM $**

bin\zuncom\moveup.bin: zuncom\moveup.asm
	mkdir bin\zuncom
	tasm zuncom\moveup.asm,bin\zuncom\moveup
	tlink -t bin\zuncom\moveup.obj,bin\zuncom\moveup.bin

bin\zuncom\comcstm.com: zuncom\comcstm.c
	mkdir bin\zuncom
	$(CC) $(CFLAGS) -mt -lt -nbin\zuncom\ -eCOMCSTM.com $**

bin\zuncom\cstmstub.bin: zuncom\cstmstub.asm
	mkdir bin\zuncom
	tasm zuncom\cstmstub.asm,bin\zuncom\cstmstub
	tlink -t bin\zuncom\cstmstub.obj,bin\zuncom\cstmstub.bin

ZUNCOM_PREREQ = bin\zuncom\gensize.com bin\zuncom\copycat.com zuncom\zun_stub.asm bin\zuncom\moveup.bin

bin\th02\zun.com : $(ZUNCOM_PREREQ) libs\kaja\ongchk.com bin\th02\zuninit.com bin\th02\zun_res.com bin\th01\zunsoft.com
	bin\zuncom\gensize.com > bin\zuncom\gensize.inc
	tasm -DGAME=2 zuncom\zun_stub.asm,bin\th02\zun_stub
	tlink -t bin\th02\zun_stub.obj,bin\th02\zun_stub.bin
	bin\zuncom\copycat &&|
bin\th02\zun_stub.bin
libs\kaja\ongchk.com
bin\th02\zuninit.com
bin\th02\zun_res.com
bin\th01\zunsoft.com
bin\zuncom\moveup.bin
| bin\th02\zun.com

bin\th03\zun.com : $(ZUNCOM_PREREQ) libs\kaja\ongchk.com bin\th02\zuninit.com bin\th01\zunsoft.com bin\th03\zunsp.com bin\th03\res_yume.com
	bin\zuncom\gensize.com > bin\zuncom\gensize.inc
	tasm -DGAME=3 zuncom\zun_stub.asm,bin\th03\zun_stub
	tlink -t bin\th03\zun_stub.obj,bin\th03\zun_stub.bin
	bin\zuncom\copycat &&|
bin\th03\zun_stub.bin
libs\kaja\ongchk.com
bin\th02\zuninit.com
bin\th01\zunsoft.com
bin\th03\zunsp.com
bin\th03\res_yume.com
bin\zuncom\moveup.bin
| bin\th03\zun.com

bin\th04\zuncom.bin : $(ZUNCOM_PREREQ) libs\kaja\ongchk.com bin\th04\zuninit.com bin\th04\res_huma.com bin\th04\memchk.com
	bin\zuncom\gensize.com > bin\zuncom\gensize.inc
	tasm -DGAME=4 zuncom\zun_stub.asm,bin\th04\zun_stub
	tlink -t bin\th04\zun_stub.obj,bin\th04\zun_stub.bin
	bin\zuncom\copycat &&|
bin\th04\zun_stub.bin
libs\kaja\ongchk.com
bin\th04\zuninit.com
bin\th04\res_huma.com
bin\th04\memchk.com
bin\zuncom\moveup.bin
| bin\th04\zuncom.bin

bin\th05\zuncom.bin : $(ZUNCOM_PREREQ) libs\kaja\ongchk.com bin\th05\zuninit.com bin\th05\res_kso.com bin\th05\gjinit.com bin\th05\memchk.com
	bin\zuncom\gensize.com > bin\zuncom\gensize.inc
	tasm -DGAME=5 zuncom\zun_stub.asm,bin\th05\zun_stub
	tlink -t bin\th05\zun_stub.obj,bin\th05\zun_stub.bin
	bin\zuncom\copycat &&|
bin\th05\zun_stub.bin
libs\kaja\ongchk.com
bin\th05\zuninit.com
bin\th05\res_kso.com
bin\th05\gjinit.com
bin\th05\memchk.com
bin\zuncom\moveup.bin
| bin\th05\zuncom.bin

bin\th04\zun.com : bin\zuncom\comcstm.com zuncom\zun4.txt bin\th04\zuncom.bin bin\zuncom\cstmstub.bin
	bin\zuncom\comcstm.com zuncom\zun4.txt bin\th04\zuncom.bin bin\zuncom\cstmstub.bin 621381155 bin\th04\zun.com

bin\th05\zun.com : bin\zuncom\comcstm.com zuncom\zun5.txt bin\th05\zuncom.bin bin\zuncom\cstmstub.bin
	bin\zuncom\comcstm.com zuncom\zun5.txt bin\th05\zuncom.bin bin\zuncom\cstmstub.bin 628731748 bin\th05\zun.com
