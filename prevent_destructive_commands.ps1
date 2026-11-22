$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

$rawInput = [Console]::In.ReadToEnd()
if (-not $rawInput) { exit 0 }

try {
    $json = $rawInput | ConvertFrom-Json
} catch {
    exit 0
}

$cmd = ""
if ($json.tool_input -and $json.tool_input.command) {
    $cmd = $json.tool_input.command
}
if (-not $cmd) { exit 0 }

$forbiddenPatterns = @(
    "git push",
    "rm -rf",
    "--no-verify",
    "git reset --hard",
    "git clean -fd",
    "drop database",
    "truncate table"
)

foreach ($pattern in $forbiddenPatterns) {
    if ($cmd -like "*$pattern*") {
        [Console]::Error.WriteLine("[HOOK_BLOCKED] 危険なコマンドが検知されたため、フックにより実行を阻止しました: $pattern")
        [Console]::Error.WriteLine("対象コマンド: $cmd")
        [Console]::Error.WriteLine("この操作を実行したい場合は、手動でターミナルから実行してください。")
        exit 2
    }
}

exit 0
