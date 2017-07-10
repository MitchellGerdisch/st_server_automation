# ---
# RightScript Name: Windows - Set Local Account Password
# Description: "Used to change the password for a local account on a Windows
#   instance. This allows for a known password to be in place when using a Remote Desktop
#   Protocol (RDP) connection."
# Inputs:
#   LOCAL_ACCOUNT_NAME:
#     Category: System
#     Description: Name of account to update
#     Input Type: single
#     Required: false
#     Advanced: true
#   LOCAL_ACCOUNT_PASSWORD:
#     Category: System
#     Description: Set the password for the local account. This should
#       be at least 7 characters long with at least one upper case letter, one lower
#       case letter and one digit.
#     Input Type: single
#     Required: true
#     Advanced: false
# Attachments: []
# ...
# Powershell 2.0

# Stop and fail script when a command fails.
$ErrorActionPreference = "Stop"

$accountName = $env:LOCAL_ACCOUNT_NAME
$accountPassword = $env:LOCAL_ACCOUNT_PASSWORD

if ([string]::IsNullOrEmpty($accountPassword))
{
    write-error "Required Input LOCAL_ACCOUNT_PASSWORD is empty."
    exit 1
}

try
{
    $strComputer = $env:computername
    $AdminsGroup=Get-WmiObject -Class Win32_UserAccount -computername $strComputer -Filter "LocalAccount='True'" -errorAction "Stop"
    foreach ($object in $AdminsGroup)
    {   
        # Looking for local administrator account by SID (regarding below link this account`s SID starts with "S-1-5" and end`s with "500" )
        #http://blogs.technet.com/b/heyscriptingguy/archive/2005/07/22/how-can-i-determine-if-the-local-administrator-account-has-been-renamed-on-a-computer.aspx
        if ($object.Name -eq $accountName)
        {
            write-host "Account found: $($object.Name)"
            $AdminAccount = $object
        }
    }

    if ($AdminAccount -eq $null)
    {
        Write-HOST "Account was not found."
        exit 0
    }

    if ((($($AdminAccount.Name) -eq $newName) -or ([string]::IsNullOrEmpty($($newName)))) -and (![string]::IsNullorEmpty($newPassword)))
    {
        Write-Host "Setting password for account $($AdminAccount.Name)..."
        net user $($AdminAccount.Name) "$accountPassword"
        exit 0
    }
}
catch [exception]
{
    write-host "Error occured"
    $_ | fl * -Force
    exit 1
}  
