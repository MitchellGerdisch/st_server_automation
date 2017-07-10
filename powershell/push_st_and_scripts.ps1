param($st_yaml)

# Check env vars are set and then set local vars accordingly
$missing_env_vars = .\check_common_env_vars.ps1
if (!(Test-Path env:RIGHT_ST))
{
    $missing_env_vars = "$missing_env_vars `n Set env:RIGHT_ST to the path to the right_st executable."
}
if ($missing_env_vars) 
{
    $missing_env_vars
    exit
}
$ACCOUNT_ID = $env:RS_LOGIN_ACCOUNT_ID
$TOKEN = $env:RS_ACCOUNT_REFRESH_TOKEN
$RSC = $env:RSC
$RIGHT_ST = $env:RIGHT_ST

# Check parameters
if (-not $st_yaml)
{
	"Provide -st_yaml parameter pointing to the yaml file describing the ServerTemplate to upload to the account.."
	exit
}

# Get shard number and set API endpoint
$account_info = (& $RSC -a $ACCOUNT_ID -r $TOKEN cm15 show /api/accounts/$ACCOUNT_ID) | ConvertFrom-Json 
foreach ($rel in $account_info.links) {
	if ($rel.rel -eq  "cluster") {
		$shard_array = $rel.href.split("/")
		$shard = $shard_array[($shard_array.length-1)]
	}
}
$ENDPOINT = "us-$shard.rightscale.com"

# Set env variables expected by right_st script and run right_st to upload the ServerTemplate
$env:RIGHT_ST_LOGIN_ACCOUNT_ID = $ACCOUNT_ID
$env:RIGHT_ST_LOGIN_ACCOUNT_HOST = $ENDPOINT
$env:RIGHT_ST_LOGIN_ACCOUNT_REFRESH_TOKEN = $TOKEN
& $RIGHT_ST st upload $st_yaml
