@echo off

call :test KeWaitLocal 
call :test PendingStatusError 
call :test DispatchMismatch 
call :test DispatchAnnotationMissing 
call :test NoPagedCode 
call :test MultiplePagedCode 
call :test NoPagingSegment 
call :test IrqTooHigh 
call :test IrqTooLow 
call :test ExaminedValue 
call :test StrSafe 


exit /b 0

:test
echo %0 %1 {

echo analysing_database
codeql database analyze "C:\Users\t-abtamene\Desktop\TestDB\%1" --format=sarifv2.1.0 --output="AnalysisFiles\Test Samples\%1.sarif" "queries\%1\%1.ql" 

echo %0 %1 }
echo.
exit /b 0
