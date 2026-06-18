function prompt {
    $branch = ''
    $color = 'White'
    $status = git status --porcelain=2 --branch 2>$null

    if ($LASTEXITCODE -eq 0 -and $status) {
        $branchName = $null
        $syncSymbol = ''
        $hasUnstagedChanges = $false
        $hasStagedChanges = $false
        $hasUntrackedChanges = $false

        foreach ($line in $status) {
            if ($line -match '^# branch\.head (.+)$') {
                $branchName = $Matches[1]
                if ($branchName -like '(*') {
                    $branchName = $null
                }
                continue
            }

            if ($line -match '^# branch\.ab \+(\d+) -(\d+)$') {
                $ahead = [int]$Matches[1]
                $behind = [int]$Matches[2]

                if ($ahead -gt 0 -and $behind -gt 0) {
                    $syncSymbol = ' ↕'
                    $color = 'DarkRed'
                } elseif ($ahead -gt 0) {
                    $syncSymbol = ' ↑'
                    $color = 'Cyan'
                } elseif ($behind -gt 0) {
                    $syncSymbol = ' ↓'
                    $color = 'Blue'
                } else {
                    $syncSymbol = ' ✓'
                    $color = 'Green'
                }
                continue
            }

            if ($line.StartsWith('? ')) {
                $hasUntrackedChanges = $true
                continue
            }

            if ($line.StartsWith('1 ') -or $line.StartsWith('2 ')) {
                $indexStatus = $line.Substring(2, 1)
                $workTreeStatus = $line.Substring(3, 1)

                if ($indexStatus -ne '.') {
                    $hasStagedChanges = $true
                }
                if ($workTreeStatus -ne '.') {
                    $hasUnstagedChanges = $true
                }
                continue
            }

            if ($line.StartsWith('u ')) {
                $hasUnstagedChanges = $true
            }
        }

        if ($branchName) {
            if (-not $syncSymbol) {
                $color = 'Green'
            }

            # 变更优先级：未暂存 或 未追踪 > 暂存
            if ($hasUnstagedChanges -or $hasUntrackedChanges) {
                $color = 'DarkGray'
            } elseif ($hasStagedChanges) {
                $color = 'Yellow'
            }

            $branch = "$branchName$syncSymbol"
        }
    }

    # 显示当前目录
    Write-Host -NoNewline "PS $PWD"

    if ($branch) {
        Write-Host -NoNewline -ForegroundColor $color " ⎇ $branch "
    }

    return "> "
}
