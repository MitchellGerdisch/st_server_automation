# Wrapper script that uses environment variables instead of having to pass values to the target script.

param($st_yaml)
if (-not $st_yaml) {
    "USAGE: push_st_and_scripts_wrapper.ps1 -st_yaml SERVERTEMPLATE_YAML"
    "WHERE:"
    "  SERVERTEMPLATE_YAML is the path to the ServerTemplate YAML file."
    exit    
}


# Get the API parameters from the environment vars
$ACCOUNT_ID,$TOKEN,$ENDPOINT,$RSC = ./get_api_params

if (!(Test-Path env:RIGHT_ST))
{
    $missing_env_vars = "Set env:RIGHT_ST to the path to the right_st executable."
    exit
}
$RIGHT_ST = $env:RIGHT_ST

& ./push_st_and_scripts.ps1 -st_yaml $st_yaml -account_id $ACCOUNT_ID -refresh_token $TOKEN -api_endpoint $ENDPOINT -rsc $RSC -right_st $RIGHT_ST
	
