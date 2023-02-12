# EventBrite Tools

This section is for tools that deal with [EventBrite](https://www.eventbrite.com/) registrations.


## create-event.ps1
Not created yet. 

## get-eventattendeelist.ps1
This will download all the tickets from Eventbrite for the specified eventid. Before you can use this, you need:

- Create an event folder. You might use something like C:\Events\sqlsatorlando2023, but it's up to you!
- Sign up for a free API key from eventbrite (alphanumeric)
- Create your event and get your eventid (all numbers)
- Event registration setup should include a question called "LinkedInURL"

You can call this function by doing this:

. .\get-eventattendeelist.ps1 -eventfolder C:\events\sqlsatorlando2023  -EventBriteEventID YourEventID -Token YourTokenKey

Executing the script will download a CSV containing all the tickets (ex: EventID_123_AttendeeData_20233612_113606.csv).

- File will contain the following: "Status","ID","OrderID","Cancelled","Refunded","Quantity","TicketClassName","FirstName","LastName","Email","JobTitle","Cost","LinkedInURL"
- You may have more than one ticket per person depending on how you set up your event. If you use the "add-on" feature of Eventbrite (recommended) you will get a ticket for the registration, plus a row for each add on (most common is lunch)
- This file will contain names and email addresses (PII), handle it appropriately
- Each time you execute the script it will download the entire list for your event and append a datestamp, just use the latest file each time
- Reminder that users can cancel tickets, may have tickets selected but not paid, etc - this is the entire list,  unfiltered


