function prompt {
    $branch = ''
    $color = 'White'

    if (Test-Path .git) {
        $branchName = git rev-parse --abbrev-ref HEAD 2>$null

        if ($branchName) {
            $status = git status --porcelain 2>$null

            $hasUnstagedChanges = $false
            $hasStagedChanges = $false

            if ($status) {
                foreach ($line in $status) {
                    $indexStatus = $line.Substring(0,1)
                    $workTreeStatus = $line.Substring(1,1)
                    if ($indexStatus -ne ' ' -and $indexStatus -ne '?') {
                        $hasStagedChanges = $true
                    }
                    if ($workTreeStatus -ne ' ' -and $workTreeStatus -ne '?') {
                        $hasUnstagedChanges = $true
                    }
                }
            }

            $syncSymbol = ''
            $aheadBehind = git rev-list --left-right --count '@{upstream}...HEAD' 2>$null
            if ($aheadBehind) {
                $counts = $aheadBehind -split "`t"
                if ($counts.Length -eq 2) {
                    $ahead = [int]$counts[1]
                    $behind = [int]$counts[0]
                    if ($ahead -gt 0 -and $behind -gt 0) {
                        $syncSymbol = '↕'
                        $color = 'Magenta'
                    } elseif ($ahead -gt 0) {
                        $syncSymbol = '↑'
                        $color = 'Cyan'
                    } elseif ($behind -gt 0) {
                        $syncSymbol = '↓'
                        $color = 'Blue'
                    } else {
                        $syncSymbol = '✓'
                        $color = 'Green'
                    }
                }
            } else {
                $color = 'Green'
            }

            if ($hasUnstagedChanges) {
                $color = 'DarkRed'
            } elseif ($hasStagedChanges) {
                $color = 'Yellow'
            }

            $branch = "$branchName $syncSymbol"
        }
    }

    # 显示当前目录
    Write-Host -NoNewline "PS $PWD"

    # 显示路径和带颜色的分支状态
    # if ($branch) {
    #     Write-Host -NoNewline -ForegroundColor $color " ⎇ $branch"
    # }

    # return "`n> "

    if ($branch) {
        Write-Host -NoNewline -ForegroundColor $color " ⎇ $branch "
    }

    return "> "
}
