# Start recording the transcript
Start-Transcript -Path "H:\Scripts\ProjNuketown\transcript.txt" -Append

<#
.Synopsis
   Function to create a logfile entry in a standardized format. 
#>
Function Write-Logfile {
    [CmdletBinding()]
    param( 
        $Message,
        $Logfile
    )
    $Timestamp = $(Get-Date -f 'hh:mm:ss ddd MMMM dd yyyy')

    $Logentry = "$Timestamp - $Message"
    if ($Logfile) 
    {
        $Logentry | Out-File $Logfile -Append
        $Logentry
    }
    else {$Logentry}
}

# Import the CSV file. 
$CSV = Import-Csv -Path 'H:\Scripts\ProjNuketown\NukedPCUpdated.csv'
# Set the GraveyardOU location. 
$GraveyardOU = 'path of ou'

# Set the credentials of an account with the rights to perform the task
$Credential =  Get-Credential -UserName domain\admin.jack

# Set a logfile location. 
$Logfile = "H:\Scripts\ProjNuketown\Outputlog.log"

Foreach ($Item in $CSV)
{
    if ($($Item.Graveyard) -eq 'True'){
        Write-Logfile "$($Item.Computername) will be moved to the Graveyard." -Logfile $LogFile


        try{
            # Disable the PC in Active Directory
            Set-ADComputer -Identity $Item.Computername -Enabled $false -Credential $Credential -ErrorAction Stop
            # Set the description field
            $description = "Inactive 90+ Days | Check Tenable, Cortex & Win Updates" # The text you want to set
            Set-ADComputer -Identity $Item.Computername -Description $description -Credential $Credential -ErrorAction Stop
            # Move PC to Graveyard OU
            Get-ADComputer $($Item.Computername) | Move-ADObject -TargetPath $GraveyardOU -Credential $Credential -ErrorAction Stop
            # Log if succesful move
            Write-Logfile "$($Item.Computername) has been moved successfully." -Logfile $LogFile
        }
        catch{
            # Log if error moving to Graveyard OU
            Write-Logfile "Error moving $($Item.Computername), $($Error[0])." -Logfile $LogFile
        }
    }
    #Delete PC from AD
    if ($($Item.Remove) -eq 'True'){
        #Log attempt to delete the PC
        Write-Logfile "$($Item.Computername) will be deleted." -Logfile $LogFile

        
        try{
            #Actually deleting the PC
            Remove-ADComputer -Identity $Item.Computername -Credential $Credential -ErrorAction Stop -Confirm:$false
            #Log if PC was deleted successfully
            Write-Logfile "$($Item.Computername) has been deleted successfully." -Logfile $LogFile
        }
        catch{
            # Log error if PC was not deleted
            Write-Logfile "Error deleting $($Item.Computername), $($Error[0])." -Logfile $LogFile
        }
    }
}

# End the transcript recording
Stop-Transcript