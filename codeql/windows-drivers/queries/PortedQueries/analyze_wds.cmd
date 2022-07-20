@echo off

@REM call :test KeWaitLocal 
@REM call :test PendingStatusError 
@REM call :test DispatchMismatch 
@REM call :test DispatchAnnotationMissing 
call :test NoPagedCode 
@REM call :test MultiplePagedCode 
@REM call :test NoPagingSegment 



exit /b 0

:test
echo %0 %1 {

echo analysing_database
codeql database analyze "D:\windowsdriversample" --format=sarifv2.1.0 --output="AnalysisFiles\WDS\%1" "queries\%1\%1.ql" 


echo %0 %1 }
echo.
exit /b 0
