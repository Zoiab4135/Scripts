$usercredential = get-credential -username admin.jack

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://xxxxxxx -Authentication Kerberos -Credential $UserCredential

Import-PSSession $Session -DisableNameChecking -allowclobber
Set-ADServerSettings -ViewEntireForest $true


# Define the OU where contacts will be created in Exchange
$OU = ""

# Read email addresses from a file
$emails = Get-Content -Path "C:\Scripts\Contacts\emails.txt"

foreach ($email in $emails) {
    # Extract the local part of the email (before the '@')
    $localPart = $email.Split('@')[0]
    
    # Check if the local part contains a period
    if ($localPart.Contains(".")) {
        # Split into first and last names
        $firstName, $lastName = $localPart.Split('.')

        # Capitalize the first letter of first and last names
        $firstName = $firstName.Substring(0,1).ToUpper() + $firstName.Substring(1).ToLower()
        $lastName = $lastName.Substring(0,1).ToUpper() + $lastName.Substring(1).ToLower()

        # Construct Display Name and Name without period
        $displayName = "$firstName $lastName"
    }
    else {
        # Use the entire local part as Display Name and Name for entries without a period
        $displayName = $localPart.Substring(0,1).ToUpper() + $localPart.Substring(1).ToLower()
    }

    # Set the Alias to the local part (keeping any period as-is)
    $alias = $localPart

    # Create the contact object in Exchange
    New-MailContact -Name $displayName -DisplayName $displayName -Alias $alias -ExternalEmailAddress $email -OrganizationalUnit $OU
    Write-Host "Created contact for $displayName ($email) with alias $alias"
}