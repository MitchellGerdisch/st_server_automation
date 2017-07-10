param($name, $deployment_href, $cloud_href, $st_href, $account_id, $refresh_token, $api_endpoint, $rsc)

# Check parameters
if ((-not $name) -or (-not $deployment_href) -or (-not $cloud_href) -or (-not $st_href) -or (-not $account_id) -or (-not $refresh_token) -or (-not $api_endpoint) -or (-not $rsc))
{
    "USAGE: launch_server.ps1 -name NAME -deployment_href DEPLOYMENT_HREF -cloud_href CLOUD_HREF -st_href ST_HREF -account_id ACCOUNT_ID -refresh_token REFRESH_TOKEN -api_endpoint API_ENDPOINT -rsc RSC -right_st RIGHT_ST"
    "WHERE:"
    "  NAME is the name to give the server."
    "  DEPLOYMENT_HREF is the HREF for the deployment in which to launch the server."
    "  CLOUD_HREF is the HREF for the cloud in which to launch the server."
    "  ST_HREF is the HREF for the ServerTemplate to use for launching the server."
    "  ACCOUNT_ID is the RightScale account ID."
    "  REFRESH_TOKEN is the RightScale Refresh Token to use."
    "  API_ENDPOINT is the RightScale API endpoint (e.g. us-3.rightscale.com or us-4.rightscale.com)."
    "  RSC is the path to the rsc command line tool installed on this computer."
    exit
}

"CALL RSC WITH PARAMETERS"