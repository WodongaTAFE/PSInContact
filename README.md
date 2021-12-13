# PSInContact
PowerShell Module for [NICE inContact](https://www.niceincontact.com/)

This module contains some helpful cmdlets for managing your inContact tenant.

## Installing

The module can be installed from the [PowerShell Gallery](https://www.powershellgallery.com/packages/inContact/) from an elevated prompt using this command:

    Install-Module inContact

## Connect to an inContact Userhub Instance

The first thing you'll need to do is connect to an inContact instance. We do this with Connect-IC, supplying a URL and credentials (your API Access Key and Access Secret).

The URL should be the root URL for your inContact domain. For example, to have PowerShell ask for a username and password and then connect to the Australia domain with those credentials:

    Connect-IC 'https://au1.nice-incontact.com' -Credential (Get-Credential)	

Note that the token retrieved from Connect-IC expires in one hour, and we do not currently support refreshing the token automatically.


## Connect to an inContact Central Instance

Just like with a Userhub instance, the first thing you need to do is connect (fetch an access key). Central utilizes OAUTH2 instead of access key/secret pairs. 

Things required for access:

* Base64 Encoded Authorization Key (Steps 1 and 2 in https://developer.niceincontact.com/Documentation/GettingStarted) [-Key]
* Admin login to Central [-Credential]


   Connect-IC -Central -Credential (Get-Credential) -Key "Base64EncodedKey"
   
As with userhub, this token expires in one hour and is not automatically refreshed. 


## Disconnecting

To ensure the inContact token is not preserved in your session, you can disconnect from the inContact instance using this command:

    Disconnect-IC

Note that no network connections are maintained that need to be cleaned up with this command. It's only used to clear the locally cached URI and token.
