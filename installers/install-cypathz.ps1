Write-Host
Write-Host "installing CyPathz..." -ForegroundColor Green
Write-Host

$binPath = "$HOME\bin"

if (-not (Test-Path $binPath)){
    New-Item -ItemType Directory -Path $binPath | Out-Null
}

$cyPathFile = "$HOME\.cypathz"

if (-not (Test-Path $cyPathFile)){
    New-Item -ItemType File -Path $cyPathFile | Out-Null
}

$sourceExe = "$PSScriptRoot\..\bin\Release\net10.0\win-x64\publish\CyPathz.exe"
$targetExe = "$binPath\cypathz.exe"

Copy-Item -Path $sourceExe -Destination $targetExe -Force

$wrapper = @'

# >> CyPathz >>

function cy {
    if ($args.Count -eq 1 -and $args[0] -eq "pathz")
    {
        & "$HOME\bin\cypathz.exe" $args[0]
        return
    }

    if($args.Count -eq 1){
        $target = & "$HOME\bin\cypathz.exe" $args[0]

        if (Test-Path -Path $target -PathType Container)
        {Set-Location $target}

        else
        {
            Write-Host $target
        }

    }
    else {
        & "$HOME\bin\cypathz.exe" @args
    }
}
# << CyPathz <<
'@

if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$profileContent = Get-Content $PROFILE -Raw

if ($null -eq $profileContent) {
    $profileContent = ""
}

$startMarker = "# >> CyPathz >>"
$endMarker = "# << CyPathz <<"

if ($profileContent.Contains($startMarker)) {
    $function = "(?s)$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))"
    $profileContent = [regex]::Replace($profileContent, $function, $wrapper)
    Set-Content -Path $PROFILE -Value $profileContent
}
else {
    Add-Content -Path $PROFILE -Value $wrapper
}

. $PROFILE
Write-Host
Write-Host "CyPathz successfully installed" -ForegroundColor Green
Write-Host
Write-Host ">>>>>    cy Commands     <<<<<" -ForegroundColor Cyan
Write-Host
Write-Host " cy add [name] >> add CyPath to current directory" -ForegroundColor Cyan
Write-Host
Write-Host " cy [name]     >> Go to Directory" -ForegroundColor Cyan
Write-Host
Write-Host " cy rm [name]  >> removes CyPath" -ForegroundColor Cyan
Write-Host
Write-Host " cy pathz      >> Lists current CyPathz" -ForegroundColor Cyan
Write-Host
Write-Host " cy add [name] [folderName\folderName\...] >> add CyPath to path from current dirictory" -ForegroundColor DarkCyan
Write-Host
Write-Host " cy add [name] [@C:\pathName\pathName\pathName..>> add CyPath to entered path" -ForegroundColor DarkCyan
Write-Host

