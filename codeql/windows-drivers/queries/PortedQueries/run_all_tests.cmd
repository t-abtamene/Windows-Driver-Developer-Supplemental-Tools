@echo off

call :test C28135
call :test C28143

exit /b 0

:test
echo %0 %1 {
rd /s /q out\%1 >NUL 2>&1
robocopy /e KMDFTestTemplate out\%1
robocopy /e queries\%1 out\%1\

cd out\%1
echo building
msbuild /t:rebuild /p:platform=x64
echo creating_database
codeql database create -l=cpp -c "msbuild /p:Platform=x64 /t:rebuild" "..\..\databases\%1"
echo analysing_database
codeql database analyze "..\..\databases\%1" --format=sarifv2.1.0 --output="..\..\AnalysisFiles\%1" "..\..\queries\%1\%1.ql" 

cd ..\..
echo %0 %1 }
echo.
exit /b 0

