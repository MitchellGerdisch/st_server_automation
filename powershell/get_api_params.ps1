$missing_env_vars = $null
if (!(Test-Path env:RS_LOGIN_ACCOUNT_ID))
{
    $missing_env_vars = "$missing_env_vars `n Set env:RS_LOGIN_ACCOUNT_ID to the appropriate RightScale account ID."
}

if (!(Test-Path env:RS_ACCOUNT_REFRESH_TOKEN))
{
    $missing_env_vars = "$missing_env_vars `n Set env:RS_ACCOUNT_REFRESH_TOKEN to the RightScale refresh token for the given account."
} 
if (!(Test-Path env:RSC))
{
    $missing_env_vars = "$missing_env_vars `n Set env:RSC to the path to the rsc executable."
}

if ($missing_env_var) 
{
    $missing_env_vars = "MISSING ENVIRONMENT VARIABLES: `n $missing_env_vars"
    $missing_env_vars
    exit
}

$ACCOUNT_ID = $env:RS_LOGIN_ACCOUNT_ID
$TOKEN = $env:RS_ACCOUNT_REFRESH_TOKEN
$RSC = $env:RSC

# Get shard number and set API endpoint
$account_info = (& $RSC -a $ACCOUNT_ID -r $TOKEN cm15 show /api/accounts/$ACCOUNT_ID) | ConvertFrom-Json 
foreach ($rel in $account_info.links) {
    if ($rel.rel -eq  "cluster") {
        $shard_array = $rel.href.split("/")
        $shard = $shard_array[($shard_array.length-1)]
    }
}
$ENDPOINT = "us-$shard.rightscale.com"

Return $ACCOUNT_ID,$TOKEN,$ENDPOINT,$RSC

