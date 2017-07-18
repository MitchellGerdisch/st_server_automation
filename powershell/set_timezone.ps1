param($server_href, $tz)
# $tz example: "(UTC-06:00) Central Standard Time"

if ((-not $server_href) -or (-not $tz))
{
    "USAGE: set_timezone.ps1 -server_href SERVER_HREF -tz TIMEZONE"
    "WHERE:"
    "  SERVER_HREF is the HREF for the given the server."
    "  TZ is a timezone. Example: (UTC-06:00) Central Standard Time"
    exit
}

# Get the API parameters from the environment vars
$ACCOUNT_ID,$TOKEN,$ENDPOINT,$RSC = ./get_api_params

$script_name = "Windows - Set Time Zone"
$scripts = (& $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT cm15 index /api/right_scripts "filter[]=name==$script_name") | ConvertFrom-Json

$found_script = $null
# Need to do a strict check of the name since the name filter is a partial match filter.
if ($scripts) {
    foreach ($script in $scripts) {
        if ($script.name -eq $script_name) {
            $found_script = $script
        }
    }
}

# Get script href
foreach ($rel in $found_script.links) {
    if ($rel.rel -eq  "self") {
        $script_href = $rel.href
    }
}

# Need instance HREF since scripts are run on instances, not on servers.
$instance_href = (& ./get_rel_href.ps1 -resource_href $server_href -rel "current_instance" -rsc $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT)
& $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT cm15 run_executable $instance_href "right_script_href=$script_href" "inputs[][name]=SYS_WINDOWS_TZINFO" "inputs[][value]=text:$tz" 

