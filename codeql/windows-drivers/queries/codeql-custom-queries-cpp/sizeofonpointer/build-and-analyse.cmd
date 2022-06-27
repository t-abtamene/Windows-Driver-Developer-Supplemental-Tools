msbuild /p:Configuration=Release /p:Platform=x64 /t:rebuild C:\CQL\codeql_home\Windows-Driver-Developer-Supplemental-Tools\codeql\windows-drivers\queries\codeql-custom-queries-cpp\sizeofonpointer\USBDriver3\USBDriver3.sln

cd C:\CQL\codeql_home\codeql

codeql database create -l=cpp -s="C:\CQL\codeql_home\Windows-Driver-Developer-Supplemental-Tools\codeql\windows-drivers\queries\codeql-custom-queries-cpp\sizeofonpointer\USBDriver3" -c "msbuild /p:Platform=x64 /t:rebuild" "C:\CQL\codeql_home\Windows-Driver-Developer-Supplemental-Tools\codeql\windows-drivers\queries\codeql-custom-queries-cpp\databases\sizeofonpointer"

codeql database analyze --format=sarifv2.1.0 --output=C:\CQL\codeql_home\Windows-Driver-Developer-Supplemental-Tools\codeql\windows-drivers\queries\codeql-custom-queries-cpp\analysis_files\sizeofonpointer.sarif "C:\CQL\codeql_home\Windows-Driver-Developer-Supplemental-Tools\codeql\windows-drivers\queries\codeql-custom-queries-cpp\databases\sizeofonpointer" "C:\CQL\codeql_home\Windows-Driver-Developer-Supplemental-Tools\codeql\windows-drivers\queries\codeql-custom-queries-cpp\sizeofonpointer\query\sizeofonpointer.ql" 
