# Define the distribution group
$distributionGroup = "stars@xyz.com"

# List of contacts to add
$contacts = @(
    "james.robinson@xyz.com",
    "jack.rabbit@xyz.com"
)

# Loop through each contact and add to the distribution group
foreach ($contact in $contacts) {
    try {
        # Add the contact to the distribution group
        Add-DistributionGroupMember -Identity $distributionGroup -Member $contact
        Write-Host "Successfully added $contact to $distributionGroup"
    } catch {
        Write-Host "Failed to add $contact to $distributionGroup $_"
    }
}