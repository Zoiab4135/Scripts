# Load the Active Directory module
Import-Module ActiveDirectory

# Get the credentials
$credential = Get-Credential -UserName domain\admin.jack

# Define the path to the CSV file
$csvPath = "C:\Scripts\PasswordScan\listofusers.csv"

# Define the path to the output text file
$outputPath = "C:\Scripts\PasswordScan\scanpwdresults.txt"

# Initialize an empty array to store results
$results = @()

# Read usernames from the CSV file
$usernames = Import-Csv -Path $csvPath | Select-Object -ExpandProperty username

# Loop through each username
foreach ($username in $usernames) {
    try {
        # Get the user object from Active Directory
        $user = Get-ADUser -Identity $username -Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" -Credential $credential

        # Get the password expiry date and time
        $expiryDateTime = [datetime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed")

        # Build the result string
        $result = "$($user.DisplayName) ($username) : $($expiryDateTime.ToString('dd/MM/yyyy HH:mm'))"

        # Append the result to the array
        $results += [PSCustomObject]@{
            UserName       = $username
            DisplayName    = $user.DisplayName
            ExpiryDateTime = $expiryDateTime
            Result         = $result
        }
    } catch {
        # Handle errors
        $errorMsg = "Error processing $username $_"
        $results += [PSCustomObject]@{
            UserName       = $username
            Error          = $errorMsg
        }
    }
}

# Sort results based on ExpiryDateTime
$results = $results | Sort-Object ExpiryDateTime

# Write the sorted results to the output text file
$results.Result | Out-File -FilePath $outputPath -Append

# Display a message indicating the completion of the script
Write-Host "Script completed. Results are stored in $outputPath"