::========================================================================================
call clean.bat
::========================================================================================
call build.bat
::========================================================================================
cd ../sim
call run_test.bat 7777 7
call run_test.bat 8888 15
call run_test.bat 4097 4
call run_test.bat 4578 10
call run_test.bat 45923 6
call run_test.bat 45763 3
call run_test.bat 34789 2
call run_test.bat 2376 5
call run_test.bat 2654 8
call run_test.bat 2367 9



