# sfdc-useful-components
A set of useful Salesforce components


## DefaultListViews
Lightning Aura component (DefaultListViewSetter) that allows you to set default pinned list views per object. It works by manually setting cookies in window.localStorage. 

### Instructions for use
1. Go to the newly created Default Listview metadata type and add your object defaults: Object is the , whilst Listview is the developer name of the list view (you can get this from the "Rename" page of a list view).
2. Add the DefaultListViewSetter component to the home page layout of all users.


## FollowedAccounts
Re-adds functionality that allows a user to bulk follow a set of accounts from a list view, and adds two Aura components for showing followed accounts and contacts (most useful on a homepage layout). Originally designed for the BED.

