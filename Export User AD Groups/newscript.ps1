Import-Module ActiveDirectory

# Path to the file containing usernames
$userFile = "C:\Scripts\Export User AD Groups\user.txt"
$results = "C:\Scripts\Export User AD Groups\results.txt"

# Check if user.txt exists
if (Test-Path $userFile) {
	# Clear the content of results.txt
	Clear-Content $results
	
    # Read the usernames from the file
    $usernames = Get-Content $userFile
	
    
    foreach ($Username in $usernames) {
        # Get the AD user object
        $User = Get-ADUser -Identity $Username -ErrorAction SilentlyContinue

        if ($User) {
            # Retrieve the group memberships of the user
            $GroupMemberships = Get-ADPrincipalGroupMembership $User | Select-Object -ExpandProperty Name

            if ($GroupMemberships) {
                Write-Host "Group Memberships for $Username":""
                $GroupMemberships | ForEach-Object {
                    Write-Host $_
                    $_ | Out-File -FilePath $results -Append
                }
            } else {
                Write-Host "User $Username is not a member of any groups."
            }
        } else {
            Write-Host "User $Username not found in Active Directory."
        }
    }
} else {
    Write-Host "File user.txt not found."
}