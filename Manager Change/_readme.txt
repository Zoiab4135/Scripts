This script changes user's 'Manager' in AD. 

Here are the details of the files:

template.csv:
This is the CSV that the script will use. Once you have pasted the information under the headers, you will have to supply the samaccountname of the manager and the target office # for the branch that needs to be changed.  

managerchange.ps1:
There are comments in green to guide you through the code. This script will only be actioned to those users who have the correct 'Office' number in their AD profile. 

-This is the actual script, the second version. 
-A transcript is appended to a txt file. 
-The CSV template you filled in will be the CSV imported and used in the script. 
-$credential = Enter your credentials 
-Exemption list, include the BM himself other wise he'll be his own manager, whereas his manager should be the GM of that division. 
-Lines 12-18 goes through each of the users in the branch and filters them through the office number, exemption list and users in disabled accounts OU. 
-Lines 20-26, this is the preparation of the change, it gathers all the eligible users 
-Lines 28-36, this section actually makes the change, run the script with the -whatif switch first to see if it made the right 'Changes'. Once ready, remove the -whatif switch in line 31. 

logfilebranch.txt
This txt file is the where the transcript will be appended to. 

How to Use the Script Example:
-Open the template.csv & supply variables
-Open the script 
-Add csv and transcript file paths
-Add your credentials 
-Add exempted users samaccountnames
-Ensure -whatif switch is present in line 31
-Run the code
-If all looks good, run the code without the switch
-validate in AD if change was made 