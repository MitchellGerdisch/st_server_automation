# ---
# RightScript Name: Windows - Set Time Zone
# Description: Sets the timezone on a Windows instance. The script checks the current
#   timezone to see if it matches the requested timezone before making a change.
# Inputs:
#   SYS_WINDOWS_TZINFO:
#     Category: System
#     Description: Sets the system timezone to the timezone specified, which must be
#       a valid Windows timezone entry. You can find a list of valid examples using
#       TZUTIL /L from command prompt. You may override the dropdown if you do not see
#       your timezone listed.
#     Input Type: single
#     Required: true
#     Advanced: false
#     Possible Values:
#     - text:(UTC-12:00) Dateline Standard Time
#     - text:(UTC-11:00) UTC-11
#     - text:(UTC-10:00) Hawaiian Standard Time
#     - text:(UTC-09:00) Alaskan Standard Time
#     - text:(UTC-08:00) Pacific Standard Time
#     - text:(UTC-07:00) Mountain Standard Time
#     - text:(UTC-06:00) Central Standard Time
#     - text:(UTC-05:00) Eastern Standard Time
#     - text:(UTC-04:00) Atlantic Standard Time
#     - text:(UTC-03:00) Greenland Standard Time
#     - text:(UTC-02:00) Mid-Atlantic Standard Time
#     - text:(UTC-01:00) Cape Verde Standard Time
#     - text:(UTC) UTC
#     - text:(UTC+01:00) Central European Standard Time
#     - text:(UTC+02:00) E. Europe Standard Time
#     - text:(UTC+03:00) Arab Standard Time
#     - text:(UTC+04:00) Russian Standard Time
#     - text:(UTC+05:00) West Asia Standard Time
#     - text:(UTC+05:30) India Standard Time
#     - text:(UTC+06:00) Central Asia Standard Time
#     - text:(UTC+07:00) SE Asia Standard Time
#     - text:(UTC+08:00) China Standard Time
#     - text:(UTC+09:00) Tokyo Standard Time
#     - text:(UTC+10:00) West Pacific Standard Time
#     - text:(UTC+11:00) Central Pacific Standard Time
#     - text:(UTC+12:00) New Zealand Standard Time
# Attachments: []
# ...
# Powershell 2.0
# Copyright (c) 2008-2013 RightScale, Inc, All Rights Reserved Worldwide.

# Stop and fail script when a command fails.
$ErrorActionPreference = "Stop"

Write-Host "Specified value - `"$env:SYS_WINDOWS_TZINFO`""

$tz = $env:SYS_WINDOWS_TZINFO.Trim()
$current_TZ = (tzutil /g)

$tzList = tzutil /l | Out-String -Stream

if ($tzList -contains $tz + ' ')#list contains white space char at end of each line
{
    # assume that a line from tzutil list used
    # for every TZ output contains two lines, e.g.
    # -----------------
    # (UTC-08:00) Pacific Time (US & Canada)
    # Pacific Standard Time
    # -----------------
    if ($tz -match "^\(")
    {
        # assume that a value in input in form of "(UTC-08:00) Pacific Time (US & Canada)" - 1st line from tzutil /l output
        # to set TZ 2nd line from tzutil /l list used
        # so need to find second line        
        $correct_tz = $tzList[$tzList.IndexOf($tz + ' ')+1]
    }
    else
    {
       # assume that a value in input in form of "Pacific Standard Time" - 2nd line from tzutil /l output
       # to set TZ 2nd line from tzutil /l list used
       # so no additional steps needed        
       $correct_tz = $tz
    }
    tzutil /s $correct_tz
}
else
{
    # assume that a value in input in form of "(UTC-08:00) Pacific Standard Time" - combination of time shift and name of TZ (dropdown contains items in that form)
    $correct_tz = $tz.Substring($tz.LastIndexOf(')')+1).Trim()
}

if (-not $correct_tz)
{
    $tzutilOutput = tzutil /l | Out-String
    throw "Incorrect value specified in input. Please use TZUTIL.EXE /L to get list of possible values.`nExample: `"(UTC-08:00) Pacific Time (US & Canada)`" or `"Pacific Standard Time`" See TZUTIL.EXE /? for details.`nBelow is the list from TZUTIL /L output:`n$tzutilOutput"    
}

if ($correct_tz.Trim() -ne $current_TZ.Trim())
{
    Write-Host "Setting current time zone using value `"$correct_tz`""
    tzutil /s $correct_tz
    if ($LASTEXITCODE -ne 0)
    {
        throw "Error setting time zone."    
    }    
}
else
{
    Write-Host "Current time zone alreade the same as specified."
}
