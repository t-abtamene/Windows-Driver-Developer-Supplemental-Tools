@REM echo analysing onecore drivers
@REM codeql database analyze "D:\onecore_drv" --format=sarifv2.1.0 --output="AnalysisFiles\Inbox\inbox_result" "suites\ported_driver_ca_checks.qls" 
@REM echo analysis for onecore drivers finished


@REM echo analysing WDS
@REM codeql database analyze "D:\windowsdriversample" --format=sarifv2.1.0 --output="AnalysisFiles\WDS\wds_result" "suites\ported_driver_ca_checks.qls" 
@REM echo analysis for WDS finished


