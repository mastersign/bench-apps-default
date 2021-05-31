$sublimeTextDataDir = Get-AppConfigValue "Bench.SublimeText" "DataDir"
$userPackagesDir = "$sublimeTextDataDir\Packages\User"

$packageControlSettings = "$userPackagesDir\Package Control.sublime-settings"

function writeUtf8File ($fileName)
{
    begin
    {
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        $w = New-Object System.IO.StreamWriter($fileName, $false, $utf8)
    }
    process
    {
        $w.WriteLine($_)
    }
    end
    {
        $w.Close()
    }
}

if (!(Test-Path $packageControlSettings))
{
    if (!(Test-Path $userPackagesDir))
    {
        $_ = mkdir $userPackagesDir
    }

    $lines = @(
        "{",
        "    `"installed_packages`":",
        "    ["
    )

    $packages = Get-AppConfigListValue "Bench.SublimeText.PackageControl" "Packages"
    foreach ($p in $packages)
    {
        $lines += "        `"$p`","
    }
    # remove trailing comma from last package line
    $lastLine = $lines[$lines.Count - 1]
    $lines[$lines.Count - 1] = $lastLine.Substring(0, $lastLine.Length - 1)

    $lines += @(
        "    ]",
        "}"
    )
    $lines | writeUtf8File $packageControlSettings
}

$resDir = App-SetupResource "Bench.SublimeText.PackageControl" "."
gci "$resDir\*.sublime-*" `
    | ? { !(Test-Path "$userPackageDir\$([IO.Path]::GetFileName($_))") } `
    | % { Write-Host "- install customization $([IO.Path]::GetFileName($_))"; $_ } `
    | % { copy $_ $userPackagesDir }
