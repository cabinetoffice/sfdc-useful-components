# sfdc-useful-components
A set of useful Salesforce components


## DefaultListViews
Lightning Aura component (DefaultListViewSetter) that allows you to set default pinned list views per object. It works by manually setting cookies in window.localStorage. 

### Instructions for use
1. Go to the newly created Default Listview metadata type and add your object defaults: Object is the , whilst Listview is the developer name of the list view (you can get this from the "Rename" page of a list view).
2. Add the DefaultListViewSetter component to the home page layout of all users.

## FollowedAccounts
Re-adds functionality that allows a user to bulk follow a set of accounts from a list view, and adds two Aura components for showing followed accounts and contacts (most useful on a homepage layout). Originally designed for the BED.

## GovukRadios
Allows you to render a picklist (or alternatively a manual set of comma delimited values) as a gov.uk-compliant set of radio buttons. It works by setting the value of an inputHidden - see below for pattern:

```
<apex:inputHidden id="test" value="{!username}" /> 
<div class="govuk-form-group">
<fieldset class="govuk-fieldset">
	<c:GovukRadio sobject="Account" field="Type" destId="{!$component.test}" />
</fieldset>
</div>
```

* sobject: the object the picklist field resides on (string)
* field: the developer name of the field (string)
* manualValues: if you want to use a pre-defined list of values rather than bind to a picklist, you can put a comma delimited set of values here. (string)
* manualDefault: if you are using manualValues, you can set the default option here (string)
* destId: the Visualforce component ID of the input. In this case, when a radio is selected, <apex:inputHidden id="test" value="{!username}" /> is set to the value, and therefore so is the "username" property in the Apex controller. (string - usually a $component.id_of_component).
* inline: if true, displays radios horizontally/inline, otherwise displays on a new row for each item.
* small: if true, displays small variant of the radio buttons rather than the default large variants.
	

## KnowledgeArticleParser
Simple parser that allows a user to use [video] tags to embed an MP4 that is attached as a File to the custom object. Not useful by itself, but it serves as a good base for anything else in the future that needs parsing.

## PostcodeIO
Simple integration for getting postcode data from postcode.io. Based on another project elsewhere but for the life of me I can't find it! Had to adjust it to add better exception handling.

## ReportData
Helper class/abstraction layer for pulling data from a Salesforce report. 

## XlsxFileUpload
Uses sheets.js to convert .xlsx (or other spreadsheet formats) into a Salesforce readable .csv - I suggest you use this in conjunction with https://github.com/martyychang/sfdc-csv.