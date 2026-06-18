# 路径设置
$pwshPath = Split-Path -Path $PROFILE
$content = '. "' + $pwshPath + '\posh-git-viys.ps1"'
$targetScript = Join-Path -Path $pwshPath -ChildPath 'posh-git-viys.ps1'
$profileExists = Test-Path $PROFILE
$profileConfigured = $false

try {
    # 确保 pwshPath 目录存在
    if (-not (Test-Path $pwshPath)) {
        New-Item -ItemType Directory -Path $pwshPath -Force -ErrorAction Stop | Out-Null
    }

    # 检查 profile 是否为目录
    if ((Test-Path $PROFILE) -and (Get-Item $PROFILE).PSIsContainer) {
        throw "❌ 错误：'$PROFILE' 是目录，应为 .ps1 文件，请手动删除该目录。"
    }

    if ($profileExists) {
        $profileContent = Get-Content -Path $PROFILE -Raw -ErrorAction Stop
        if ($profileContent -match [regex]::Escape($content)) {
            $profileConfigured = $true
        }
    }

    # 仅在需要修改 profile 时备份或创建
    if ($profileExists -and -not $profileConfigured) {
        $timestamp = [int][double]((Get-Date).ToUniversalTime() - [datetime]'1970-01-01T00:00:00Z').TotalSeconds
        $backupPath = "$PROFILE.$timestamp.back"
        Copy-Item -Path $PROFILE -Destination $backupPath -Force -ErrorAction Stop
        Write-Host "📦 已备份原始配置到: $backupPath"
    } elseif (-not $profileExists) {
        # 不存在则创建空文件
        New-Item -ItemType File -Path $PROFILE -Force -ErrorAction Stop | Out-Null
        $profileContent = ''
        Write-Host "📄 创建配置文件: $PROFILE"
    }

    # 清理旧脚本
    if (Test-Path $targetScript) {
        Remove-Item -Path $targetScript -Force -ErrorAction Stop
    }

    # 拷贝脚本
    Copy-Item -Path (Join-Path -Path $PSScriptRoot -ChildPath 'posh-git-viys.ps1') -Destination $targetScript -Force -ErrorAction Stop
    Write-Host "✅ 已复制脚本到: $targetScript"

    # 保留原有 profile 内容，仅在缺失时追加加载语句
    if (-not $profileConfigured) {
        if (-not $profileExists) {
            $profileContent = ''
        }
        if ($profileContent.Length -gt 0 -and -not $profileContent.EndsWith([Environment]::NewLine)) {
            Add-Content -Path $PROFILE -Value [Environment]::NewLine -Encoding UTF8 -ErrorAction Stop
        }
        Add-Content -Path $PROFILE -Value $content -Encoding UTF8 -ErrorAction Stop
        Write-Host "✅ 已追加配置到: $PROFILE"
    } else {
        Write-Host "ℹ️ 检测到已存在加载配置，跳过修改: $PROFILE"
    }

    # 加载配置
    . $PROFILE
    Write-Host "🚀 加载成功"

} catch {
    Write-Error "❌ 安装失败：$($_.Exception.Message)"
    exit 1
}
