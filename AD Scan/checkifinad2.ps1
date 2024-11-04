# Start recording the transcript
Start-Transcript -Path "H:\Scripts\AD Scan\TranscriptADScan.txt" -Append

# Import the Active Directory module if not already loaded
Import-Module ActiveDirectory

# Specify the path to the CSV file containing computer names (replace with your file path)
$csvFilePath = "H:\Scripts\AD Scan\checkifinadList.csv"
# Specify the path for the log text file on your H drive
$logFilePath = "H:\Scripts\AD Scan\adsearchresults.txt"

# Check if the CSV file exists
if (Test-Path $csvFilePath) {
    # Import computer names from the CSV file, specifying the "Name" property
    $computerNames = Import-Csv -Path $csvFilePath | Select-Object -ExpandProperty Name

    # Initialize an empty array to store the results
    $results = @()

    # Loop through the computer names and search for them in Active Directory
    foreach ($computerName in $computerNames) {
        $computer = Get-ADComputer -Filter {Name -eq $computerName}

        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        if ($computer) {
            $result = "$timestamp,$computerName, EXISTS in Active Directory. DistinguishedName: $($computer.DistinguishedName)"
        } else {
            $result = "$timestamp,$computerName, DELETED from Active Directory."
        }

        # Add the result to the results array
        $results += $result
    }

    # Sort the results so that existing computers are listed first
    $sortedResults = $results | Sort-Object { $_ -match "EXISTS in Active Directory" } -Descending

    # Display the sorted results in the terminal
    $sortedResults | ForEach-Object { Write-Host $_ }

    # Export the sorted results with timestamps to the log text file and append the results
    $sortedResults | Out-File -FilePath $logFilePath -Append -Encoding UTF8
} else {
    Write-Host "CSV file not found at $csvFilePath"
}
# End the transcript recording
Stop-Transcript