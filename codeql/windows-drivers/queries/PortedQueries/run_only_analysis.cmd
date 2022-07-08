@echo off

call :test C28135
call :test C28143
call :test C28169

exit /b 0

:test
echo %0 %1 {

echo analysing_database
codeql database analyze "databases\%1" --format=sarifv2.1.0 --output="AnalysisFiles\%1" "queries\%1\%1.ql" 


echo %0 %1 }
echo.
exit /b 0

