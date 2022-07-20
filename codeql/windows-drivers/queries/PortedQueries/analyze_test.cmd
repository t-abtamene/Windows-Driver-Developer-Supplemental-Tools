@echo off

call :test KeWaitLocal 
call :test PendingStatusError 
call :test DispatchMismatch 
call :test DispatchAnnotationMissing 
call :test NoPagedCode 
call :test MultiplePagedCode 
call :test NoPagingSegment 



exit /b 0

:test
echo %0 %1 {

echo analysing_database
codeql database analyze "C:\Users\t-abtamene\Desktop\TestDB\%1" --format=sarifv2.1.0 --output="AnalysisFiles\Test Samples\%1" "queries\%1\%1.ql" 

echo %0 %1 }
echo.
exit /b 0
