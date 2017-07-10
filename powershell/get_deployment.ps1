param($deployment, $rsc, $a, $r, $h)

# Check parameters
if (-not $deployment)
{
    "Provide -deployment parameter with the name of the deployment in which to launch the server."
    exit
}
if (-not $rsc)
{
    "Provide -rsc parameter with the path to the rsc command."
    exit
}
if (-not $a)
{
    "Provide -a parameter with the RightScale account number."
    exit
}
if (-not $r)
{
    "Provide -r parameter with the RightScale refresh token to use."
    exit
}
if (-not $h)
{
    "Provide -h parameter with the RightScale API endpoint hostname to use."
    exit
}

# Look for the deployment 
$deployments = (& $rsc -a $a -r $r -h $h cm15 index /api/deployments "filter[]=name==$deployment") | ConvertFrom-Json

$found_deployment = $null
# Need to do a strict check of the name since the name filter is a partial match filter.
if ($deployments) {
    foreach ($dep in $deployments) {
        if ($dep.name -eq $deployment) {
            $found_deployment = $dep
        }
    }
}

$found_deployment
