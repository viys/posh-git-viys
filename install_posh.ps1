# 路径设置
$pwshPath = "$HOME\Documents\PowerShell"
$content = '. "$HOME\Documents\PowerShell\posh-git-viys.ps1"'

try {
    # 确保 pwshPath 目录存在
    if (-not (Test-Path $pwshPath)) {
        New-Item -ItemType Directory -Path $pwshPath -Force -ErrorAction Stop | Out-Null
    }

    # 检查 profile 是否为目录
    if ((Test-Path $PROFILE) -and (Get-Item $PROFILE).PSIsContainer) {
        throw "❌ 错误：'$PROFILE' 是目录，应为 .ps1 文件，请手动删除该目录。"
    }

    # 如果文件存在则备份
    if (Test-Path $PROFILE) {
        $timestamp = [int][double]((Get-Date).ToUniversalTime() - [datetime]'1970-01-01T00:00:00Z').TotalSeconds
        $backupPath = "$PROFILE.$timestamp.back"
        Copy-Item -Path $PROFILE -Destination $backupPath -Force -ErrorAction Stop
        Write-Host "📦 已备份原始配置到: $backupPath"
    } else {
        # 不存在则创建空文件
        New-Item -ItemType File -Path $PROFILE -Force -ErrorAction Stop | Out-Null
        Write-Host "📄 创建配置文件: $PROFILE"
    }

    # 清理旧脚本
    $targetScript = "$pwshPath\posh-git-viys.ps1"
    if (Test-Path $targetScript) {
        Remove-Item -Path $targetScript -Force -ErrorAction Stop
    }

    # 拷贝脚本
    Copy-Item -Path "./posh-git-viys.ps1" -Destination $targetScript -Force -ErrorAction Stop
    Write-Host "✅ 已复制脚本到: $targetScript"

    # 写入 profile 内容
    Set-Content -Path $PROFILE -Value $content -Encoding UTF8 -ErrorAction Stop
    Write-Host "✅ 已写入配置到: $PROFILE"

    # 加载配置
    . $PROFILE
    Write-Host "🚀 加载成功"

} catch {
    Write-Error "❌ 安装失败：$($_.Exception.Message)"
    exit 1
}