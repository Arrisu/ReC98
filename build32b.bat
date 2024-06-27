@echo off
echo Running the first, 32-bit part of the ReC98 build process.

: Windows 9x doesn't support stderr redirection, and always sets ERRORLEVEL to
: 2 if you attempt to do that, regardless of `tasm32`'s existence. NT properly
: returns 9009 if not found, or 0 otherwise.
set STDERR_IGNORE=
tasm32 >NUL 2>NUL
if errorlevel 9009 goto no_tasm32
if errorlevel    2 goto check_tasm32_win9x

: NT + TASM32 existing confirmed at this point
setlocal
set STDERR_IGNORE=2^>NUL
goto check_bcc32

: Re-run the actual TASM check for Windows 9x. Calling a nonexistent command
: leaves ERRORLEVEL untouched, so we have to override it ourselves first.
:check_tasm32_win9x
call set_errorlevel_to_1.bat
tasm32 >NUL %STDERR_IGNORE%
if errorlevel 1 goto no_tasm32

:check_bcc32
call set_errorlevel_to_1.bat
bcc32 >NUL %STDERR_IGNORE%
if errorlevel 1 goto no_bcc32

: Neither BCC32 nor TASM32 automatically create nonexisting output
: directories. Tup would, but not everybody can use it.
mkdir obj %STDERR_IGNORE%
mkdir obj\Pipeline %STDERR_IGNORE%
mkdir bin\Pipeline %STDERR_IGNORE%
for %%i in (1 2 3 4 5) do mkdir obj\th0%%i %STDERR_IGNORE%
for %%i in (1 2 3 4 5) do mkdir bin\th0%%i %STDERR_IGNORE%

: Regular Tup would return 1 when hitting Ctrl-C, so let's use the immediately
: returning `version` subcommand to figure out whether we should fall back.
bin\tup version >NUL
if     errorlevel 1 goto fallback
: NT returns negative values for things like DLL import failures
if not errorlevel 0 goto fallback

: If we can run Tup, we're also on a decently modern Windows. Update the dumb
: full batch build script by parsing out commands from `tup parse`'s stdout.

: Using three files is the easiest way to preserve the error level of `tup
: parse`, unfortunately.
set unparsed=.tup\unparsed.bat
set parsed=.tup\parsed.bat
set final=build_dumb.bat

: The separate `tup parse` call might take some time.
xcopy /-I /L /D /Y        Tupfile.lua %final% | findstr /B /C:"1 " >NUL || ^
xcopy /-I /L /D /Y Pipeline\rules.lua %final% | findstr /B /C:"1 " >NUL
if errorlevel 1 goto tup

: Tup insists on reparsing the Tupfile if we add or remove any file between
: `tup parse` and `tup`… unless we place it in `.tup/`, which might not exist
: yet.
if not exist .tup\ bin\tup init

bin\tup parse >%unparsed%
if errorlevel 1 del %unparsed% && goto eof

: Wine doesn't support sub-shell output redirection.
call :build_dumb_parse %unparsed% >%parsed%
del %unparsed%

for /f "usebackq" %%f in ('%parsed%') do (
	if 0 neq %%~zf ( move /y %parsed% %final% >NUL ) else ( del %parsed% )
)
goto tup

:build_dumb_parse
setlocal EnableDelayedExpansion
for /f "delims=" %%l in (%~1) do (
	set line=%%l
	if "!line:~0,2!" == "$ " echo !line:~2!
)
endlocal
exit /b

:tup
bin\tup
goto eof

:fallback
echo [..] Running on a 32-bit OS, falling back on a dumb full rebuild...

: Windows 9x wouldn't support %final% in this position.
call build_dumb.bat

goto eof

:no_tasm32
echo Could not find TASM32.
echo Please make sure that the BIN directory of Turbo Assembler 5.0 is in your PATH.
goto eof

:no_bcc32
echo Could not find BCC32.
echo Please make sure that the BIN directory of Borland C++ 5.5 is in your PATH.
goto eof

:eof
echo -------------------------------------------------------------------------------
