: Dumb, full batch build script, provided as a fallback for systems that can't
: run Tup. Auto-generated via `tup generate`; make sure to re-run that command
: if the Tupfile changes.
@echo on
bcc32 -w-8004 -w-8012 -O2 -v- -x- -nbin/Pipeline/ Pipeline/bmp2arr.c Pipeline/bmp2arrl.c
bin\\Pipeline\\bmp2arr.exe -q -i th01/sprites/ileave_m.bmp -o th01/sprites/ileave_m.asp -sym _sINTERLEAVE_MASKS -of asm -sw 8 -sh 8
bin\\Pipeline\\bmp2arr.exe -q -i th01/sprites/pellet.bmp -o th01/sprites/pellet.csp -sym sPELLET -of c -sw 8 -sh 8 -pshf inner
bin\\Pipeline\\bmp2arr.exe -q -i th01/sprites/pellet_c.bmp -o th01/sprites/pellet_c.asp -sym _sPELLET_CLOUD -of asm -sw 16 -sh 16
bin\\Pipeline\\bmp2arr.exe -q -i th01/sprites/shape8x8.bmp -o th01/sprites/shape8x8.asp -sym _sSHAPE8X8 -of asm -sw 8 -sh 8
bin\\Pipeline\\bmp2arr.exe -q -i th01/sprites/shape_in.bmp -o th01/sprites/shape_in.asp -sym _sSHAPE_INVINCIBILITY -of asm -sw 8 -sh 8
bin\\Pipeline\\bmp2arr.exe -q -i th02/sprites/pellet.bmp -o th02/sprites/pellet.asp -sym _sPELLET -of asm -sw 8 -sh 8 -pshf outer
bin\\Pipeline\\bmp2arr.exe -q -i th02/sprites/sparks.bmp -o th02/sprites/sparks.asp -sym _sSPARKS -of asm -sw 8 -sh 8 -pshf outer
bin\\Pipeline\\bmp2arr.exe -q -i th02/sprites/pointnum.bmp -o th02/sprites/pointnum.asp -sym _sPOINTNUMS -of asm -sw 8 -sh 8
bin\\Pipeline\\bmp2arr.exe -q -i th03/sprites/score.bmp -o th03/sprites/score.asp -sym _sSCORE_FONT -of asm -sw 8 -sh 8 -u
bin\\Pipeline\\bmp2arr.exe -q -i th04/sprites/pelletbt.bmp -o th04/sprites/pelletbt.asp -sym _sPELLET_BOTTOM -of asm -sw 8 -sh 4 -pshf outer
bin\\Pipeline\\bmp2arr.exe -q -i th04/sprites/pointnum.bmp -o th04/sprites/pointnum.asp -sym _sPOINTNUMS -of asm -sw 8 -sh 8 -pshf inner
bin\\Pipeline\\bmp2arr.exe -q -i th05/sprites/gaiji.bmp -o th05/sprites/gaiji.asp -sym _sGAIJI -of asm -sw 16 -sh 16
bin\\Pipeline\\bmp2arr.exe -q -i th05/sprites/piano_l.bmp -o th05/sprites/piano_l.asp -sym _sPIANO_LABEL_FONT -of asm -sw 8 -sh 8
tasm32 /m /mx /kh32768 /t /ml libs\piloadc\piloadc.asm bin\piloadc.obj
tasm32 /m /mx /kh32768 /t zuncom\zun_stub.asm bin\zuncom\zun_stub.obj
tasm32 /m /mx /kh32768 /t zuncom\cstmstub.asm bin\zuncom\cstmstub.obj
tasm32 /m /mx /kh32768 /t th01_op.asm bin\th01\op.obj
tasm32 /m /mx /kh32768 /t th01_reiiden.asm bin\th01\reiiden.obj
tasm32 /m /mx /kh32768 /t th01_fuuin.asm bin\th01\fuuin.obj
tasm32 /m /mx /kh32768 /t th02_zuninit.asm bin\th02\zuninit.obj
tasm32 /m /mx /kh32768 /t th02_op.asm bin\th02\op.obj
tasm32 /m /mx /kh32768 /t th02_main.asm bin\th02\main.obj
tasm32 /m /mx /kh32768 /t th02_maine.asm bin\th02\maine.obj
tasm32 /m /mx /kh32768 /t /DTHIEF libs\sprite16\sprite16.asm bin\th03\zunsp.obj
tasm32 /m /mx /kh32768 /t /dGAME=3 th03\cdg_p_na.asm bin\th03\cdg_p_na.obj
tasm32 /m /mx /kh32768 /t th03_op.asm bin\th03\op.obj
tasm32 /m /mx /kh32768 /t th03_main.asm bin\th03\main.obj
tasm32 /m /mx /kh32768 /t th03_mainl.asm bin\th03\mainl.obj
tasm32 /m /mx /kh32768 /t th04_zuninit.asm bin\th04\zuninit.obj
tasm32 /m /mx /kh32768 /t th04_memchk.asm bin\th04\memchk.obj
tasm32 /m /mx /kh32768 /t /dGAME=4 th04\scoreupd.asm bin\th04\scoreupd.obj
tasm32 /m /mx /kh32768 /t th04_op.asm bin\th04\op.obj
tasm32 /m /mx /kh32768 /t th04_main.asm bin\th04\main.obj
tasm32 /m /mx /kh32768 /t th04_maine.asm bin\th04\maine.obj
tasm32 /m /mx /kh32768 /t th05_zuninit.asm bin\th05\zuninit.obj
tasm32 /m /mx /kh32768 /t th05_gjinit.asm bin\th05\gjinit.obj
tasm32 /m /mx /kh32768 /t th05_memchk.asm bin\th05\memchk.obj
tasm32 /m /mx /kh32768 /t /dGAME=5 th04\scoreupd.asm bin\th05\scoreupd.obj
tasm32 /m /mx /kh32768 /t /dGAME=5 th05\player.asm bin\th05\player.obj
tasm32 /m /mx /kh32768 /t /dGAME=5 th05\hud_bar.asm bin\th05\hud_bar.obj
tasm32 /m /mx /kh32768 /t /dGAME=5 th05\bullet.asm bin\th05\bullet.obj
tasm32 /m /mx /kh32768 /t th05_op.asm bin\th05\op.obj
tasm32 /m /mx /kh32768 /t th05_main.asm bin\th05\main.obj
tasm32 /m /mx /kh32768 /t th05_maine.asm bin\th05\maine.obj
@echo off
