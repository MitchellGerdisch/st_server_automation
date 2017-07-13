param($server_href, $script_href, $inputs_string, $account_id, $refresh_token, $api_endpoint, $rsc)

# Check parameters
if ((-not $server_href) -or (-not $script_href)  -or (-not $account_id) -or (-not $refresh_token) -or (-not $api_endpoint) -or (-not $rsc))
{
    "USAGE: run_script.ps1 -server_href SERVER_HREF -script_href SCRIPT_HREF -inputs_string INPUTS_STRING -account_id ACCOUNT_ID -refresh_token REFRESH_TOKEN -api_endpoint API_ENDPOINT -rsc RSC -right_st RIGHT_ST"
    "WHERE:"
    "  SERVER_HREF is the HREF for the given the server."
    "  SCRIPT_HREF is the HREF for the script to run."
    "  INPUTS_STRING is a string of sets of input parameters of the form: inputs[][name]=NAME inputs[][value]=VALUE"
    "  ACCOUNT_ID is the RightScale account ID."
    "  REFRESH_TOKEN is the RightScale Refresh Token to use."
    "  API_ENDPOINT is the RightScale API endpoint (e.g. us-3.rightscale.com or us-4.rightscale.com)."
    "  RSC is the path to the rsc command line tool installed on this computer."
    exit
}

# find the instance to run the script on
$instance_href = (& ./get_rel_href.ps1 -resource_href $server_href -rel "current_instance" -rsc $RSC -a $account_id -r $refresh_token -h $api_endpoint)

# Run the script
& $RSC -v --dump=debug -a $account_id -r $refresh_token -h $api_endpoint cm15 run_executable $instance_href "right_script_href=$script_href" "$inputs_string"

Write-Host "Ran script: $script_href, with inputs: $inputs_string, on server: $server_href"

