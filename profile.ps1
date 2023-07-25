Import-Module posh-git
Import-Module -Name "mod.ps1"

$vicitude  = "C:\users\kritz\documents\vicitude"
$desktop   = "C:\users\kritz\desktop"
$landing   = "C:\users\kritz\documents\landing"
$docs      = "C:\users\kritz\documents"
$downloads = "C:\users\kritz\downloads"
$projects  = "C:\users\kritz\documents\Code_Projects"
$libfin    = "C:\users\kritz\documents\vicitude\LibfinRepos"
$temp      = "C:\users\kritz\desktop\temp"
$commands  = "C:\terminal-commands"
$notes     = "C:\users\kritz\documents\zing-vault"
$nvim      = "C:\users\kritz\AppData\Local\nvim"

function listRepoBranches{

    $dirs = Get-ChildItem -Directory -Exclude .* ;

    $maxLength = ($dirs | ForEach-Object {Write-Output $_.Name.Length} | Measure-Object -Max).Maximum ;

    $dirs | ForEach-Object { 

        Set-Location $_.FullName;

        if(Test-Path -Path ".git") {
            Write-Output "$($_.Name) $(" " * ($maxLength - $_.Name.Length)) -> [$(git rev-parse --abbrev-ref HEAD)]";
        }

        Set-Location ../ 
    }
}

function rmMerged {
    git branch --merged | Select-String -Pattern '^[^\*].*' | ForEach-Object { git branch -d $_.ToString().Trim() }
}

function copyCommit{
    git log --format="%H" -n 1 | Set-Clipboard
} 

function downRes {
        param (
        [Parameter(Mandatory = $true, Position=1)]$i = "default",
        [Parameter(Mandatory = $true, Position=2)]$o = "default"
    )

    # downres to 720px width. height determined by original aspect ratio
    ffmpeg -i $i -filter:v scale="720:trunc(ow/a/2)*2" $o
}

function muleBuild {
    param (
        [string]$v, 
        [string]$r
    )

    Write-host ---------------------------------------------------
    Write-host Building Mule Project with Maven
    Write-host ---------------------------------------------------
    Write-host

    try {
        mvn clean package -DskipTests=true
    } catch {
        Write-Output "An Error occurred during build"
        Write-Host
    }
}

