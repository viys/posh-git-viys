# pwsh 路径
$pwshPath = "$HOME\Documents\PowerShell"
# 要写入的内容
$content = '. "$HOME\Documents\PowerShell\posh-git-viys.ps1"'

# 判断文件是否存在
if (Test-Path $PROFILE) {
    # 获取当前时间的 Unix 时间戳（秒）
    $timestamp = [int][double]((Get-Date).ToUniversalTime() - [datetime]'1970-01-01T00:00:00Z').TotalSeconds

    # 构造备份文件名，放在同一目录下
    $backupPath = "$PROFILE.$timestamp.back"

    # 复制文件进行备份
    Copy-Item -Path $PROFILE -Destination $backupPath -Force

    Write-Host "备份成功，备份文件路径： $backupPath"
} else {
    Write-Host "文件不存在, 创建文件： $PROFILE"
    New-Item -ItemType Directory -Path $PROFILE -Force | Out-Null
}

Copy-Item -Path "./posh-git-viys.ps1" -Destination "$pwshPath/posh-git-viys.ps1" -Force

# 创建或覆盖文件并写入内容
Set-Content -Path $PROFILE -Value $content -Encoding UTF8

Write-Host "文件已创建并写入内容： $PROFILE"

. $PROFILE
