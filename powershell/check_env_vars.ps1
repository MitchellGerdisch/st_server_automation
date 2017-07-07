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
