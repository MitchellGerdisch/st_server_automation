param($name, $deployment, $cloud, $st)

# Check the env vars are set and set local vars
$missing_env_vars = .\check_common_env_vars.ps1
if ($missing_env_vars) 
{
    $missing_env_vars
    exit
}
$ACCOUNT_ID = $env:RS_LOGIN_ACCOUNT_ID
$TOKEN = $env:RS_ACCOUNT_REFRESH_TOKEN
$RSC = $env:RSC

# Check parameters
if (-not $name)
{
    "Provide -name parameter with the name of the server to create."
    exit
}
if (-not $deployment)
{
    "Provide -deployment parameter with the name of the deployment in which to launch the server."
    exit
}
if (-not $st)
{
    "Provide -st parameter with the name of the servertemplate to use to launch the server."
    exit
}

# Get the shard for the API endpoint
$account_info = (& $RSC -a $ACCOUNT_ID -r $TOKEN cm15 show /api/accounts/$ACCOUNT_ID) | ConvertFrom-Json 
foreach ($rel in $account_info.links) {
	if ($rel.rel -eq  "cluster") {
		$shard_array = $rel.href.split("/")
		$shard = $shard_array[($shard_array.length-1)]
	}
}
$ENDPOINT = "us-$shard.rightscale.com"

# See if the deployment already exists
$found_deployment = ./get_deployment -deployment $deployment -rsc $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT

# Create deployment if it does not already exist
if (-not $found_deployment) {
    # Create deployment since no existing one was found
    $new_deployment = (& $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT cm15 create /api/deployments "deployment[name]=$deployment")
    $found_deployment = ./get_deployment -deployment $deployment -rsc $RSC -a $ACCOUNT_ID -r $TOKEN -h $ENDPOINT
    
} else {
    "Found existing deployment with name, $deployment."
    "Using the existing deployment."
}

$found_deployment
