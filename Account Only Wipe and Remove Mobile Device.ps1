# Get the mobile devices connected to the user's mailbox
Write-Logfile -Message "Getting any mobile device for $($Account.UserPrincipalName)." -Logfile $Logfile
$Devices = Get-MobileDevice -Mailbox $($Account.UserPrincipalName)

if ($Devices) {
    # Initialize a variable for devices successfully removed.
    $RemovedDevices = @()

    # Iterate through each device
    Write-Logfile -Message "Actioning the devices." -Logfile $Logfile
    foreach ($Device in $Devices) {
        try {
            $DeviceId = $($Device.DeviceId)
            Write-Logfile -Message "Wiping and removing device: $DeviceId" -Logfile $Logfile
            
            # Perform a remote wipe on the device
            try {
                Write-Logfile -Message "Performing a remote wipe on $($Device.FriendlyName)." -Logfile $Logfile
                Clear-MobileDevice -Identity $DeviceId -AccountOnly -ErrorAction Stop -Confirm:$false
                Write-Logfile -Message "$($Device.FriendlyName) wiped." -Logfile $Logfile
            }
            catch {
                # Catch and log any errors during the remote wipe.
                Write-Logfile "Error wiping device $($Device.FriendlyName): $($_.Exception.Message)" -Logfile $Logfile
            }

            # Remove the device from the user's mailbox, even if the remote wipe failed
            try {
                Write-Logfile -Message "Removing $($Device.FriendlyName)." -Logfile $Logfile
                Remove-MobileDevice -Identity $DeviceId -ErrorAction Stop -Confirm:$false
                Write-Logfile -Message "$($Device.FriendlyName) removed." -Logfile $Logfile
            }
            catch {
                # Catch and log any errors during device removal
                Write-Logfile "Error removing device $($Device.FriendlyName): $($_.Exception.Message)" -Logfile $Logfile
            }

            $RemovedDevices += $Device
        }
        catch {
            Write-Logfile "Failed to process $($Device.FriendlyName), $DeviceId." -Logfile $Logfile
            Write-Logfile "$($_.Exception.Message)" -Logfile $Logfile
        }
    }

    if ($RemovedDevices.count -gt 0) {
        $Message += "Removed the devices $($RemovedDevices.FriendlyName -join(', ')).<br><br>"
    }
    else {
        $Message += "No devices removed.<br><br>"
    }
}
else {
    Write-Host "The team member has no mobile devices."
}