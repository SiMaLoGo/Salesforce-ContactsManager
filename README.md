# Salesforce-ContactsManager
## Scenario
It is necessary to develop a system for collecting and viewing contacts in CRM. The main features of the system
are a quick search, add and remove contacts from one common page.
## Requirements
1. The task will use the standard Contact, Account, Case objects. Create new objects not
need to.
2. For the Contact object, you need to add a new Contact Level (picklist) field with Primary, Secondary,
Tertiary.
## Visual part (Front End)
The visual part of the task is a VF page, which can be accessed via
‘Contacts Manager’ tab, you’ll need to create one. This page should display all existing contacts.
You must display the following fields: Name (link), Email, Contact Level (picklist), Account (lookup), Owner
(lookup), Created By (lookup), Created Date.
The table must support pagination (10 contacts per page) and sorting by any column.
(by clicking on the title).
Next to each contact you need to show the Del button, which will delete the contact from the database.
Also on this page there should be a field for searching contacts by name (partial match by
first / last name). And the Search button. Search results should be displayed in the same table and should show those
same columns.
In addition, you need to make the button ‘New Contact’, which will open a new page or show a popup
on the same page where you can enter First Name, Last Name *, Email *, Contact Level, Account and click Save
or Cancel.
## Server part (Back End)
When creating a new contact, Case should be created automatically using a trigger. Case must
attach to a new contact. If the contact refers to an account, then the new Case should also refer to
this account.
The Status field of the new Case should be ‘Working’, and the Case Origin field should be
value ‘New Contact’.
The Case Owner field must be the same as the Owner account’s account. Also field
Priority for a new Case should depend on what value was selected in the Contact Level field of the contact. If a
it was Primary then Priority = ‘High’, if it was ‘Secondary’ then Priority = ‘Medium’, if it was ‘Tertiary’
then Priority = ‘Low’.
All code for classes and triggers should be covered by unit tests. Tests should not only cover the code, but
also test the correctness of the logic of your methods.
