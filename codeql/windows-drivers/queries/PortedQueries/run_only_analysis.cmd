@echo off

call :test KeWaitLocal KMDFTestTemplate
call :test PendingStatusError WDMTestingTemplate
call :test DispatchMismatch WDMTestingTemplate
call :test DispatchAnnotationMissing WDMTestingTemplate
call :test NoPagedCode WDMTestingTemplate


exit /b 0

:test
echo %0 %1 {
rd /s /q out\%1 >NUL 2>&1
robocopy /e %2 out\%1\
robocopy /e queries\%1\ out\%1\driver\

cd out\%1

echo analysing_database
codeql database analyze "C:\Users\t-abtamene\Desktop\TestDB\%1" --format=sarifv2.1.0 --output="..\..\AnalysisFiles\%1" "..\..\queries\%1\%1.ql" 

cd ..\..
echo %0 %1 }
echo.
exit /b 0
