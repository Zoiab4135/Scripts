Start-Transcript -Append "transcript path"

# CSV location for branch details
$CSV = Import-Csv -Path "csv path"

$credential = Get-Credential -UserName domain\admin.jack

# Exemption list
# add exempted users
$exemptionList = @('john.doe' , 'jack.schitt')

foreach ($Line in $CSV) {
    $Filter = "Office -eq $($Line.office)"
    
    $Users = Get-ADUser -Filter $Filter -Properties office, Manager | Where-Object {
        $_.DistinguishedName -notlike "*DN of your disabled accounts OU*" -and
        $exemptionList -notcontains $_.SamAccountName
    }

    foreach ($User in $Users) {
        $Params = @{
            Identity   = $User.SamAccountName
            Manager    = Get-ADUser $($Line.ManagerSAM)
            Credential = $credential
            ErrorAction = 'Stop'
        }

        try {
            Write-Output "Updating Manager for account $($User.name)." 
            # remove WhatIf switch when running for real
            Set-Aduser @Params -WhatIf
            Write-Output "$($User.name) Manager updated to $($Line.ManagerSAM)" 
        }
        catch {
            Write-Output "There was an issue updating the account $($User.name)."
            Write-Output "$_"
        }
        
    }
}

Stop-Transcript