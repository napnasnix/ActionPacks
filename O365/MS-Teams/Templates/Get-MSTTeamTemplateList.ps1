﻿#Requires -Version 5.0
#Requires -Modules microsoftteams

<#
    .SYNOPSIS
        Retrieving information of all team templates available to your tenant

    .DESCRIPTION

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module microsoftteams 1.1.1 or greater
        Requires .NET Framework Version 4.7.2.
        Requires Library script MSTLibrary.ps1

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/MS-Teams/Templates
    
    .Parameter MSTCredential
        [sr-en] Provides the user ID and password for organizational ID credentials
        [sr-de] Benutzerkonto für die Ausführung

    .Parameter PublicTemplateLocale
        [sr-en] The language and country code of templates localization for Microsoft team templates
        [sr-de] Die Sprache und der Ländercode der Microsoft-Teamvorlagen

    .Parameter TenantID
        [sr-en] Specifies the ID of a tenant
        [sr-de] Identifier des Mandanten
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]   
    [pscredential]$MSTCredential,
    [string]$PublicTemplateLocale,
    [ValidateSet('*','AppCount','Category','ChannelCount','Description','IconUri','Id','Locale','ModifiedBy','ModifiedOn','Name','OdataId','PublishedBy','Scope','ShortDescription','Visibility')]
    [string[]]$Properties = @('Name','OdataId','ShortDescription','AppCount','ChannelCount','ModifiedBy','ModifiedOn','Scope', 'Visibility'),
    [string]$TenantID
)

Import-Module microsoftteams

try{    
    ConnectMSTeams -MTCredential $MSTCredential -TenantID $TenantID
    if($Properties -contains '*'){
        $Properties = @('*')
    }

    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'}
    if($PSBoundParameters.ContainsKey('PublicTemplateLocale') -eq $true){
        $cmdArgs.Add("PublicTemplateLocale", $PublicTemplateLocale)
    }

    $result = Get-CsTeamTemplateList @cmdArgs

    if($SRXEnv) {
        $SRXEnv.ResultMessage = ($result | Select-Object $Properties)
    }
    else{
        Write-Output ($result | Select-Object $Properties)
    }
}
catch{
    throw
}
finally{
    DisconnectMSTeams
}