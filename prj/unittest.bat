@echo off
echo Running build verification tests:
cd ..\bvt

FOR %%I IN (00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27) DO ( 
	echo Running %%I
	echo =============================================
	..\lib\vs2008\bvt%%ID.exe < bvt%%I.cc > bvt%%I.out	
	..\tools\diff.exe  bvt%%I.std bvt%%I.out	
	echo =============================================
)
cd ..\prj