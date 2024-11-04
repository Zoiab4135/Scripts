# Import the Active Directory module
Import-Module ActiveDirectory

# Define the OU and group names
$targetOU = "DN of OU goes here"
$group = "add group"

try {
    # Get all users from the specified OU
    $users = Get-ADUser -Filter * -SearchBase $targetOU -ErrorAction Stop

    # Iterate through each user and check if they are a member of the specified group
    foreach ($user in $users) {
        $memberOf = Get-ADUser $user -Properties MemberOf -ErrorAction Stop | Select-Object -ExpandProperty MemberOf
        if ($memberOf -like "*$group*") {
            Write-Host "$($user.Name) is a member of group $group"
            # If you want to output more details about the user, you can use $user | Select-Object Property1, Property2, ...
        }
    }
} catch {
    Write-Host "Error occurred: $_"
}