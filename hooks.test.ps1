$ps = (Get-Process -Id $PID).Path   # 実行中の PowerShell 自身でフックを起動する
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

function Test-Hook([string]$script, [string]$json, [int]$expect, [string]$label) {
    $null = $json | & $ps -NoProfile -File (Join-Path $here $script) 2>$null
    $code = $LASTEXITCODE
    if ($code -eq $expect) { "OK   $label (終了コード $code)" }
    else { "NG   $label (期待 $expect、実際 $code)" }
}

function Bash([string]$cmd) { (@{ tool_name = "Bash"; tool_input = @{ command = $cmd } } | ConvertTo-Json -Compress) }

Test-Hook "prevent_destructive_commands.ps1" (Bash "git push origin main") 2 "git push を止める"
Test-Hook "prevent_destructive_commands.ps1" (Bash "git status")           0 "git status は通す"
