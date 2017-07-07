param($st_yaml)

if (-not $st_yaml)
{
	"Provide -st_yaml parameter pointing to the yaml file describing the ServerTemplate to upload."
	exit
}

$missing_env_var = $false
if (!(Test-Path env:RIGHT_ST))
{
        "Set env:RIGHT_ST to the path to the right_st executable."
        $missing_env_var = $true
}
if (!(Test-Path env:RSC))
{
        "Set env:RSC to the path to the rsc executable"
        $missing_env_var = $true
}
if (!(Test-Path env:RS_LOGIN_ACCOUNT_ID))
{
	"Set env:RS_LOGIN_ACCOUNT_ID to the appropriate RightScale account ID."
	$missing_env_var = $true
}

if (!(Test-Path env:RS_ACCOUNT_REFRESH_TOKEN))
{
	"Set env:RS_ACCOUNT_REFRESH_TOKEN to the RightScale refresh token for the given account."
	$missing_env_var = $true
} 

if ($missing_env_var)
{
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
& $RIGHT_ST
