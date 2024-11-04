This script scans computer names (PC's, laptops and tablets) in AD and will tell you if it exists in AD or not. I have not tested if it can scan servers but I would hope it does. This can be used in hand with the detonator script to validate if objects have been deleted. 

Details about the files:

adsearchresults.txt:
The results of the scan. Also has a comma so you can import in excel. It will also show the OU of the ones that exist in AD. 

TranscriptADScan.txt:
Transcript log of your output. 

checkifinadList.csv:
CSV the script pulls from. Literally one collumn headered Name. Enter object name. 

checkifinad2.ps1:
Actual script that scans AD for the object. Results will display existing objects first. 

How to use this script:
-Edit your CSV and add the computer names you want to query, save the csv and exit
-Open the script
-Edit the Transcript, log and CSV path of the script 
-run
-use excel and import data feature for better visualisation