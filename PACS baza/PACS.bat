@echo off
cd ..
set dcmtkpath=%cd%\Final_app\FUN_pacs\dcmtk\
set PATH=%PATH%;%dcmtkpath%
cd "PACS baza"
dcmqrscp -v -c dcmqrscp.cfg
