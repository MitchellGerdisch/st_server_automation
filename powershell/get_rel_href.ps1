param($resource_href, $rel, $rsc, $a, $r, $h)

# Look for the deployment 
$resource = (& $rsc -a $a -r $r -h $h cm15 show $resource_href) | ConvertFrom-Json

$found_href = $null
foreach ($link in $resource.links) {
    if ($link.rel -eq  $rel) {
        $found_href = $link.href
    }
}

Return $found_href