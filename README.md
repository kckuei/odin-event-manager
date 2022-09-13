# odin-event-manager
Simulated event manager scripting tutorial implemented in `ruby` and utilizing the [GoogleCivic API](https://developers.google.com/civic-information?hl=en).

### Learning Objectives
The learning objectives of this tutorial were to: 
* manipulate file input and output (I/O)
* read content from a CSV (Comma Separated Value) file
* transform it into a standardized format
* utilize the data to contact a remote service
* populate a template with user data
* manipulate strings
* access Google’s Civic Information API through the Google API Client Gem
* use ERB (Embedded Ruby) for templating

### Program Output
The project entailed implementing code to:
1. clean registrant phone numbers
2. identify most active registration time 
3. identify most active registration day
```
Assigmment: Clean Phone Numbers
(615) 438-5000
(414) 520-5000
(941) 979-2000
(650) 799-0000
(613) 565-4000
(778) 232-7000
(202) 328-1000
(530) 919-3000
(808) 497-4000
(858) 405-3000
(---) --------
(315) 450-6000
(510) 282-4000
(787) 295-0000
(---) --------
(603) 305-3000
(530) 355-7000
(206) 226-3000
(607) 280-2000

Assignment: Time Targeting
The most active registration hour is 13:00 hours.

Assignment: Days of the Week Targeting
The most active registration day is Monday.
```