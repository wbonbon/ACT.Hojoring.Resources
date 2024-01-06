$cd = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $cd

$hashList = Join-Path $cd "resources.txt"

$baseUri = "https://raw.githubusercontent.com/wbonbon/ACT.Hojoring.Resources/master/"

Write-Output "# Hojoring.Resources" > $hashList

$files = Get-ChildItem .\ -Recurse | Sort-Object -Property DirectoryName,Name

$prevDirectory = ""

foreach ($f in $files) {
    if ($f.PSIsContainer) {
        continue
    }

    if ($cd -eq $f.Directory) {
        continue
    }

    $relayPath = Resolve-Path $f -Relative

    $localPath = $relayPath.Replace(".\", "")
    $remoteUri = [uri]::EscapeUriString($baseUri + $localPath.Replace("\", "/"))

    $hash = Get-FileHash $f -Algorithm MD5

    if ($prevDirectory -ne $f.Directory.ToString()) {
        Write-Output "" >> $hashList
        Write-Output ("# " +  (Resolve-Path $f.Directory -Relative).Replace(".\", "")) >> $hashList
    }

    Write-Output ($localPath + " " + $remoteUri + " " + $hash.Hash) >> $hashList

    $prevDirectory = $f.Directory.ToString()
}
