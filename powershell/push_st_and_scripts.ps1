param($st_yaml)

$missing_env_vars = .\check_env_vars.ps1
if ($missing_env_vars) 
{
    $missing_env_vars
    exit
}

if (-not $st_yaml)
{
	"Provide -st_yaml parameter pointing to the yaml file describing the ServerTemplate to upload to the account.."
	exit
}

$ACCOUNT_ID = $env:RS_LOGIN_ACCOUNT_ID
$TOKEN = $env:RS_ACCOUNT_REFRESH_TOKEN
$RSC = $env:RSC
$RIGHT_ST = $env:RIGHT_ST

$account_info = (& $env:RSC -a $ACCOUNT_ID -r $TOKEN cm15 show /api/accounts/$env:RS_LOGIN_ACCOUNT_ID) | ConvertFrom-Json 

foreach ($rel in $account_info.links) {
	if ($rel.rel -eq  "cluster") {
		$shard_array = $rel.href.split("/")
		$shard = $shard_array[($shard_array.length-1)]
	}
}

$ENDPOINT = "us-$shard.rightscale.com"

$env:RIGHT_ST_LOGIN_ACCOUNT_ID = $ACCOUNT_ID
$env:RIGHT_ST_LOGIN_ACCOUNT_HOST = $ENDPOINT
$env:RIGHT_ST_LOGIN_ACCOUNT_REFRESH_TOKEN = $TOKEN
& $RIGHT_ST st upload $st_yaml
