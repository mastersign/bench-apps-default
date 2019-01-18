$pythonDir = App-Dir "Bench.Python3"
$pip = "$pythonDir\Scripts\pip3.exe"

if (!(Test-Path $pythonDir))
{
    return
}
if (!(Test-Path $pip))
{
    Write-Error "PIP for 3 not found."
    return
}

& $pip uninstall -y numpy
