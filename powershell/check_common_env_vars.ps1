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
}

$missing_env_var

