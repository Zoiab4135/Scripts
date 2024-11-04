This is the best project ive made. Project Nuketown disables PC's, laptops, servers and moves them to the graveyard, it will also delete these 3 objects from AD entirely. This is useful around end of lease period where all the old pc's have been replaced and returned to lease company. The objects serve no purpose and deleting them will help keep our records clean. 

Details about the files:

Outputlog.log:
Output of the script when run.

Transcript.txt:
Transcript of your activity when script is run. 

NukedPCUpdated.csv:
CSV the script will pull from. 3 columns. If you put TRUE under either Graveyard or Remove, it will execute the respective command. 
Computername = add the object name
Graveyard = TRUE (Will disable the object and move to graveyard OU)
Remove = TRUE (Will delete the object entirely from AD)

Detonator.ps1:
This is the actual script. There is a transcript that begins when script is ran. The log file structure is represented lines 8-23. 
CSV file, graveyard OU, credentials and log file are defined. 
Lines 36-57: If computername is marked TRUE for Graveyard, the object will be disabled, note added and moved to the Graveyard OU. 
Lines 58-75: If computername is marked TRUE for Remove, the object will be deleted from AD. In line 66 you can remove the -Confirm:$false switch if you want to be queried for each deletion. If you dont want to be queried, leave the switch there. 

How to use this Script:
-Edit, save and exit your CSV
-Ensure your transcript and log files exist 
-Open script
-Modify the file path of the transcript and log file, add csv path and credentials
-run the script 
