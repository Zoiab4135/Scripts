Start-Transcript -Path "C:\Scripts\transcript.txt" -Append
# Define variables
$csvPath = "C:\Scripts\removeusers.csv"
$ouPath = "desired ou path"
$credential = Get-Credential -Credential "domain\admin.james"

# Import usernames from CSV
$usernames = Import-Csv -Path $csvPath | Select-Object -ExpandProperty username

# Function to move users to specified OU
function Move-UserToOU {
    param (
        [string]$username,
        [string]$ouPath,
        [pscredential]$credential
    )
    try {
        Get-ADUser -Identity $username -ErrorAction Stop | Move-ADObject -TargetPath $ouPath -Credential $credential -ErrorAction Stop -Confirm:$false
        Write-Output "User $username moved to $ouPath successfully"
        Remove-UserFromGroups -username $username -Confirm:$false
    }
    catch {
        Write-Error "Failed to move user $username $_"
    }
}

# Function to remove user from specified groups
function Remove-UserFromGroups {
    param (
        [string]$username
    )
    $groupsToRemove = @(
        "group1",
        "group2",
        "group3"
    )
    foreach ($group in $groupsToRemove) {
        try {
            Remove-ADGroupMember -Identity $group -Members $username -Credential $credential -ErrorAction Stop -Confirm:$false
            Write-Output "Removed user $username from group $group"
        }
        catch {
            Write-Error "Failed to remove user $username from group $group $_"
        }
    }
}

# Loop through each username and move to specified OU
foreach ($username in $usernames) {
    Move-UserToOU -username $username -ouPath $ouPath -credential $credential -Confirm:$false
}
Stop-Transcript
