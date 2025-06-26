# 打印带颜色的 ASCII 表格
Write-Host "+----------------------+-----------------+" -ForegroundColor White
Write-Host "| 状态说明             | 颜色演示        |" -ForegroundColor White
Write-Host "+----------------------+-----------------+" -ForegroundColor White

Write-Host "| 干净分支（无修改）   |" -NoNewline -ForegroundColor White
Write-Host " ⎇ master ✓      " -NoNewline -ForegroundColor Green
Write-Host "|"

Write-Host "| 有未暂存更改         |" -NoNewline -ForegroundColor White
Write-Host " ⎇ master ✓      " -NoNewline -ForegroundColor Yellow
Write-Host "|"

Write-Host "| 有未跟踪或修改的文件 |" -NoNewline -ForegroundColor White
Write-Host " ⎇ master ✓      " -NoNewline -ForegroundColor DarkGray
Write-Host "|"

Write-Host "| 存在冲突或变更       |" -NoNewline -ForegroundColor White
Write-Host " ⎇ master ↕      " -NoNewline -ForegroundColor DarkRed
Write-Host "|"

Write-Host "| 本地分支领先远程     |" -NoNewline -ForegroundColor White
Write-Host " ⎇ master ↑      " -NoNewline -ForegroundColor Cyan
Write-Host "|"

Write-Host "| 本地分支落后远程     |" -NoNewline -ForegroundColor White
Write-Host " ⎇ master ↓      " -NoNewline -ForegroundColor Blue
Write-Host "|"
Write-Host "+----------------------+-----------------+" -ForegroundColor White
