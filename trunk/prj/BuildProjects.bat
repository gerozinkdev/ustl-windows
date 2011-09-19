@echo off 
Set MAKETOOL="../tools/premake4.exe"

%MAKETOOL% configure

%MAKETOOL% vs2008 %1 %2 %3 %4 %5 %6 %7 %8 %9
rem %MAKETOOL% vs2010 %1 %2 %3 %4 %5 %6 %7 %8 %9
rem %MAKETOOL% xcode4 %1 %2 %3 %4 %5 %6 %7 %8 %9
rem %MAKETOOL% codeblocks %1 %2 %3 %4 %5 %6 %7 %8 %9 

