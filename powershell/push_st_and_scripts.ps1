param($st_yaml, $account_id, $refresh_token, $api_endpoint, $rsc, $right_st)

# Check parameters
if ((-not $st_yaml) -or (-not $account_id) -or (-not $refresh_token) -or (-not $api_endpoint) -or (-not $rsc) -or (-not $right_st))
{
    "USAGE: push_st_and_scripts.ps1 -st_yaml SERVERTEMPLATE_YAML -account_id ACCOUNT_ID -refresh_token REFRESH_TOKEN -api_endpoint API_ENDPOINT -rsc RSC -right_st RIGHT_ST"
	"WHERE:"
	"  SERVERTEMPLATE_YAML is the path to the ServerTemplate YAML file."
	"  ACCOUNT_ID is the RightScale account ID."
	"  REFRESH_TOKEN is the RightScale Refresh Token to use."
	"  API_ENDPOINT is the RightScale API endpoint (e.g. us-3.rightscale.com or us-4.rightscale.com)."
	"  RSC is the path to the rsc command line tool installed on this computer."
    "  RIGHT_ST is the path to the right_st command line tool installed on this computer."
	exit
}

# Set env variables expected by right_st script and run right_st to upload the ServerTemplate
$env:RIGHT_ST_LOGIN_ACCOUNT_ID = $account_id
$env:RIGHT_ST_LOGIN_ACCOUNT_HOST = $api_endpoint
$env:RIGHT_ST_LOGIN_ACCOUNT_REFRESH_TOKEN = $refresh_token
& $RIGHT_ST st upload $st_yaml
