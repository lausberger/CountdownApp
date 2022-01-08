# Event Countdown App (iOS)
Created by Lucas Ausberger

## About This Project

* Created: January 4, 2021
* Last Updated: January 8, 2021
* Current Verison: 1.1.1
* Dependencies: iOS 15.2, tested on iPhone 8 and newer

### Description

A basic countdown app that allows the user to create, edit, and delete events. Each event contains a live countdown timer to a specified date and time. If the user allows notifications, events will notify the user upon completion.

## FAQs

### How do I create an event?

To create an event, click the blue "plus" button in the upper right corner of the main page. You will then be prompted to enter the following pieces of information:

* Name: A (200 character or less) name for the event. Defaults to "Event" if none provided.
* Time: If "All Day" is unticked, allows the user to select a specific time. Otherwise, defaults to 12:00 AM on the given date.
* Date: Allows the user to pick any month and day between the years 1 and 10,000. Defaults to the current date.

Once finished, click the "Save" button in the upper left corner of the editor to save the event, or "Cancel" to cancel.

Note: Dates that have already passed will be considered to have 0 seconds remaining.

### How do I edit an event?

An event can be edited either by performing a rightward swipe gesture within the Events list and selecting the grey "pencil" icon, or by selecting the blue "pencil and paper" icon in the upper right corner of an event's viewing page. Once within the editor, any of the event's fields may be altered, but changes will only be written after the editor's "Save" button is pressed.

### How do I delete an event?

To delete an event, perform a rightward swipe gesture within the Events list. Then, select the red "trash" icon. You will then be prompted to either confirm or cancel this decision. Please note that event deletions cannot be undone.

## Changelog

### Hotfix 1.1.1 (January 8, 2021)

#### Fixes:

* Events edited from within the list view now properly update their countdown previews when starting as an expired event
* Events edited within the detailed view now properly update their countdown when starting as an expired event
* All-day events correctly send a notification at 8 AM instead of 12:08 AM

### Update Version 1.1 (January 5, 2021)

#### Notification Support

If the user has chosen to allow notifications, all newly created or edited events will automatically schedule a local notification for the specified time and date. In the case of an all-day event, a notification is scheduled for 8 AM on the day of the event. Deleted events will have their notifications cancelled.

#### Event Deletion Confirmation

Now, when the delete button for an event is pressed, a popup window will open that asks the user to either "Confirm" or "Cancel".

## Future Changes

* [DONE] Notifications once a timer hits zero
* [DONE] A confirmation popup that appears before an event is deleted
* An "About" and "Preferences" menu
* An archive of past events that can be viewed within a separate screen
* The option to add pictures and/or notes to an event
* Different sorting options within the Events list
* The option to not be notified or to have repeat reminders for an event
* The option to choose when to be notified for all-day events

