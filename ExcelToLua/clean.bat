rd bin  /s /q
rd obj  /s /q
del *.suo /s /a H
rd _UpgradeReport_Files /s /q
rd Backup /s /q
rd .vs /s /q
del UpgradeLog.XML /s /a H

rd src\packages /s/q
rd publish\x64  /s /q
rd publish\x86  /s /q
rd publish\opt  /s /q
del publish\config.xml  /s /q
del publish\Excel*  /s /q
del publish\liblua53.dylib  /s /q
del publish\liblua53.so  /s /q
del publish\lua53.dll  /s /q
del publish\Newtonsoft*  /s /q



for /f "delims=" %%a in ('dir /b/s/ad obj bin .vs') do (
@echo rd /s /q "%%a"
rd /s /q "%%a"
)








