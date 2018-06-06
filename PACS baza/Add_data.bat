@echo off
cd ..
set dcmtkpath=%cd%\Final_app\FUN_pacs\dcmtk\
set PATH=%PATH%;%dcmtkpath%
storescu -aet KLIENTL -aec ARCHIWUM +sd -v localhost 10110 Serie\*