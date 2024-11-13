:again 
   set /p answer=Would you like to ping (Y/N)?
   if /i "%answer:~,1%" EQU "Y" goto execute
   if /i "%answer:~,1%" EQU "N" exit /b
   echo Please type Y for Yes or N for No
   goto again

:execute
    cd ..
    python "D:\Code\MotivPings\ping.py"