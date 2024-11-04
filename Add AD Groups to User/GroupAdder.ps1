# Set credential
$credential = Get-Credential -Credential "domain\admin.jack"

# Specify the groups
$groups = @(
    "group1",
    "group2",
    "group3"
)

# Function to add user to groups
function Add-UserToGroups {
    param (
        [string]$UserName,
        [array]$Groups
    )

    # Loop through each group and add user
    foreach ($group in $Groups) {
        try {
            Add-ADGroupMember -Identity $group -Members $UserName -Credential $credential -ErrorAction Stop 
            Write-Host "User $UserName added to group $group"
        } catch {
            Write-Host "Failed to add user $UserName to group $group $_" -ForegroundColor Red
            # Log the error to a file
            Add-Content -Path "Path to ErrorLog.txt" -Value "Failed to add user $UserName to group $group $_"
        }
    }
}

# Read usernames from CSV
$csvPath = "path to removeusers.csv"
$usernames = Import-Csv -Path $csvPath | Select-Object -ExpandProperty username

# Add users to groups
foreach ($user in $usernames) {
    Add-UserToGroups -UserName $user -Groups $groups 
}