param($server_href, $tz)

# $tz example: "(UTC-06:00) Central Standard Time"

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


$instance_href = (& ./get_rel_href.ps1 -resource_href $server_href -rel "current_instance" -rsc $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT)
& $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT cm15 run_executable $instance_href "right_script_href=$script_href" "inputs[][name]=SYS_WINDOWS_TZINFO" "inputs[][value]=text:$tz" 

#$inputs_string = "`"inputs[][name]=SYS_WINDOWS_TZINFO`" `"inputs[][value]=text:$tz`"" 
#& ./run_script.ps1 -server_href $server_href -script_href $script_href -inputs_string $inputs_string -account_id $ACCOUNT_ID -refresh_token $TOKEN -api_endpoint $ENDPOINT -rsc $RSC

