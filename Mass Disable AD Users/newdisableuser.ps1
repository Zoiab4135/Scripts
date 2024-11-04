Import-Module ActiveDirectory

# Define the path to your CSV file containing usernames
$csvPath = "c:\Scripts\Disable users\usernames.csv"

# Define the log file path
$logPath = "C:\Scripts\Disable users\disable_users_log.txt"

# Start transcript logging with timestamps
Start-Transcript -Path $logPath -Append

# Import the CSV file with usernames
$users = Import-Csv $csvPath

$Credential = Get-Credential -UserName domain\admin.jack

# Iterate through the users and disable their accounts
foreach ($user in $users) {
    $username = $user.Username
    try {
        # Get the current date and time
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Host "[$timestamp] Disabling user: $username" -ForegroundColor Gray

        # Disable the user account
        Disable-ADAccount -Identity $username -ErrorAction Stop -Credential $Credential 

        # Get the current date and time for the log
        $currentDateTime = Get-Date -Format "dd MMMM yyyy"

        # Create the comment with the current date and time
        $comment = "Account disabled due to Cyber Training not completed. Disabled on $currentDateTime | Please see IT"
        
        # Set the "Notes" field in the "Telephone" tab with the updated comment
        Set-ADUser -Identity $username -Replace @{info=$comment} -Credential $Credential 
        
        Write-Host "[$timestamp] Successfully disabled and updated user: $username" -ForegroundColor Green
    } catch {
        $errorTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Host "[$errorTimestamp] Failed to disable or update user: $username" -ForegroundColor Red
        Write-Host "[$errorTimestamp] Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Stop transcript logging
Stop-Transcript