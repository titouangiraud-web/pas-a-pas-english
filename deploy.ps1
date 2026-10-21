# Publie le site sur GitHub Pages. Prérequis : git et GitHub CLI (gh) installés, puis "gh auth login" fait une fois.
$ErrorActionPreference = "Stop"
$repo = "pas-a-pas-english"
Set-Location $PSScriptRoot
if (-not (Test-Path .git)) { git init -b main | Out-Null }
git add -A
git commit -m "Pas a Pas English" 2>$null
$user = gh api user --jq .login
if (-not (gh repo view "$user/$repo" 2>$null)) { gh repo create $repo --public --source=. --remote=origin --push }
else { git remote get-url origin 2>$null | Out-Null; if ($LASTEXITCODE -ne 0) { git remote add origin "https://github.com/$user/$repo.git" }; git push -u origin main }
gh api -X POST "repos/$user/$repo/pages" -f "source[branch]=main" -f "source[path]=/" 2>$null | Out-Null
Write-Host ""
Write-Host "Lien (actif dans 1 à 2 minutes) : https://$user.github.io/$repo/" -ForegroundColor Green
