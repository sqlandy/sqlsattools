param (
    [string] $EventFolder,
    [string] $EventBriteEventID,   
    [string] $Token
)


$API = "https://www.eventbriteapi.com/v3/events/$EventBriteEventID/attendees/"
$ContinuationToken = ""

# check that event folder is valid
if (-not(test-path -LiteralPath $EventFolder -PathType Container))
{
    throw "Event folder doesnt exist - check the name or create it"
}

# make sure data folder exists, will have all the downloads for attendee data
$DataFolder = join-path $EventFolder "Data" 
New-Item -Path $DataFolder -ItemType Directory -Force | Out-Null

# new filename every time
$FileName =  join-path $DataFolder ("EventID_$($EventBriteEventID)_AttendeeData_" + (Get-Date -Format "yyyymmdd_hhmmss") + ".csv")
Write-Output "Writing results to $fileName"

do
{
    
    if ($ContinuationToken -ne "")
    {
        $URL = $API + "?continuation=$continuationtoken&token=$Token"
    }
    else {
        $URL = $API + "?token=$Token"

    }

    $Results = Invoke-RestMethod -uri $url
    if ($results.pagination.has_more_items -eq $true)
    {
        $ContinuationToken = $results.pagination.continuation
    }

    $Attendees = $Results.attendees
    foreach ($Attendee in $Attendees)
    {

        $LinkedInURL = ""
        foreach ($answer in $Attendee.answers)
        {
            if ($answer.question -like "*linkedin*")
            {
                $LinkedInURL = $Answer.answer
                break
            }
        }

        $NewRow = [PSCustomObject]@{
            PSTypeName = "Attendee"
            Status = $attendee.status
            ID = $Attendee.ID
            OrderID = $Attendee.order_id
            Cancelled = $Attendee.cancelled
            Refunded = $attendee.refunded
            Quantity = $attendee.quantity
            TicketClassName = $attendee.ticket_class_name
            FirstName = $attendee.profile.first_name
            LastName = $attendee.profile.last_name
            Email = $Attendee.profile.email
            JobTitle = $attendee.profile.job_title
            Cost = $attendee.costs.base_price.value
            LinkedInURL = $LinkedInURL
        }
        $NewRow | Export-csv -Path $FileName -Append -UseQuotes Always

        Write-Output "Retrieving data for $($NewRow.FirstName) $($NewRow.LastName)"
    }
    
    
}
while ($Results.pagination.has_more_items -eq $true)

Write-Output "Finished writing to $fileName"
write-output "Downloaded $((Get-Content $FileName).Length) rows of attendee/ticket data"