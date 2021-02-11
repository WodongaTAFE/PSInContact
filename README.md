# PSInContact
PowerShell Module for [NICE inContact](https://www.niceincontact.com/)

This module contains some helpful cmdlets for managing your inContact tenant.

## Installing

The module can be installed from the [PowerShell Gallery](https://www.powershellgallery.com/packages/inContact/) from an elevated prompt using this command:

    Install-Module inContact

## Connect to an inContact Instance

The first thing you'll need to do is connect to an inContact instance. We do this with Connect-IC, supplying a URL and credentials (your API Access Key and Access Secret).

The URL should be the root URL for your inContact domain. For example, to have PowerShell ask for a username and password and then connect to the Australia domain with those credentials:

    Connect-IC 'https://au1.nice-incontact.com' -Credential (Get-Credential)	

Note that the token retrieved from Connect-IC expires in one hour, and we do not currently support refreshing the token automatically.
