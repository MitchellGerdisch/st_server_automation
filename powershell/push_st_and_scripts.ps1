param($st_yaml)

.\check_env_vars.ps1

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




#if !(Test-Path env:RS_LOGIN_ACCOUNT_HOST)
#{
	#"Set env:RS_LOGIN_ACCOUNT_HOST to us-3.rightscale.com or us-4.rightscale.com as applicable for the given account." 
	#$env:missing_env_var = true
#}

$env:RIGHT_ST_LOGIN_ACCOUNT_ID = $ACCOUNT_ID
$env:RIGHT_ST_LOGIN_ACCOUNT_HOST = $ENDPOINT
$env:RIGHT_ST_LOGIN_ACCOUNT_REFRESH_TOKEN = $TOKEN
& $RIGHT_ST st upload $st_yaml
