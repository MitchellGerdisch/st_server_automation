param($name, $deployment_name, $cloud_href, $st_href)

# Check parameters
if ((-not $name) -or (-not $deployment_name) -or (-not $cloud_href) -or (-not $st_href))
{
    "USAGE: launch_server_wrapper.ps1 -name NAME -deployment_name DEPLOYMENT_NAME -cloud_href CLOUD_HREF -st_href ST_HREF"
    "WHERE:"
    "  NAME is the name to give the server."
    "  DEPLOYMENT_NAME is the name for the deployment in which to launch the server. Will create deployment if not found."
    "  CLOUD_HREF is the HREF for the cloud in which to launch the server."
    "  ST_HREF is the HREF for the ServerTemplate to use for launching the server."
    exit
}

# Get the API parameters from the environment vars
$ACCOUNT_ID,$TOKEN,$ENDPOINT,$RSC = ./get_api_params

# See if the deployment already exists
$target_deployment = ./get_deployment -deployment $deployment_name -rsc $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT

# Create deployment if it does not already exist
if (-not $target_deployment) {
    # Create deployment
    $new_deployment = (& $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT cm15 create /api/deployments "deployment[name]=$deployment_name")
    $target_deployment = ./get_deployment -deployment $deployment_name -rsc $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT
    
} else {
    "Found existing deployment with name, $deployment_name."
}

# Launch the server
# Get deployment href
foreach ($rel in $target_deployment.links) {
    if ($rel.rel -eq  "self") {
        $deployment_href = $rel.href
    }
}

& ./launch_server.ps1 -name $name -deployment_href $deployment_href -cloud_href $cloud_href -st_href $st_href -account_id $ACCOUNT_ID -refresh_token $TOKEN -api_endpoint $ENDPOINT -rsc $RSC -right_st $RIGHT_ST
