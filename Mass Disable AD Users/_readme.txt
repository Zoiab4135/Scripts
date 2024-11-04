This powershell script mass disables the accounts in AD that are pulled from the csv. 
It also adds the note + timestamp as to why the account was disabled. 

There are 4 files in this package. 
_readme.txt:
Txt file with the details of this package. 

disable_users_log.txt:
This txt file is is the log + transcript file location of the script output. 

usernames.csv:
This is the csv file that the script refers to when disabling users. 
There is only a username column. Under this Colum you are to input the samaccountname of the AD user.
The user logon name can also be used. 

newdisableuser.ps1:
There are comments on the main lines of code. 
You must edit, save and close your csv file first before running this. 
This is the actual powershell script. 
You will have to modify the $csvPath, $logpath and $credential variables to fit your setup. 
When run, the script will iterate through the usernames in the csv,
it will disable the user and add the custom note with time stamps in the notes field under the telephone tab of the object. 
There is also error catching for the users that failed getting disabled. 
