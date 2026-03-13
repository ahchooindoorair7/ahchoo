# fix-claude-path.ps1
# Automatically installs Claude Code CLI and ensures it is on your PATH.
# Run with: powershell -ExecutionPolicy Bypass -File fix-claude-path.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step($msg) { Write-Host "`n>> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "   OK: $msg" -ForegroundColor Green }
function Write-Fail($msg) { Write-Host "   ERROR: $msg" -ForegroundColor Red }

# ── 1. Check Node.js / npm ────────────────────────────────────────────────────
Write-Step "Checking for Node.js and npm..."
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Fail "npm not found. Please install Node.js (>= 18) from https://nodejs.org and re-run this script."
    exit 1
}
Write-Ok "npm found: $(npm --version)"

# ── 2. Check if claude is already working ─────────────────────────────────────
Write-Step "Checking if 'claude' is already available..."
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Ok "'claude' is already on your PATH: $(claude --version)"
    Write-Host "`nNothing to do. You can run: claude auth login" -ForegroundColor Yellow
    exit 0
}

# ── 3. Install Claude Code via npm ────────────────────────────────────────────
Write-Step "Installing @anthropic-ai/claude-code globally..."
npm install -g @anthropic-ai/claude-code
if ($LASTEXITCODE -ne 0) {
    Write-Fail "npm install failed (exit code $LASTEXITCODE). Check the output above."
    exit 1
}
Write-Ok "Installation complete."

# ── 4. Detect npm global prefix ───────────────────────────────────────────────
Write-Step "Detecting npm global bin directory..."
$npmPrefix = (npm config get prefix).Trim()
Write-Ok "npm prefix: $npmPrefix"

# ── 5. Add to User PATH if not already present ────────────────────────────────
Write-Step "Checking User PATH..."
$userPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -split ";" | Where-Object { $_ -eq $npmPrefix }) {
    Write-Ok "'$npmPrefix' is already in User PATH."
} else {
    $newPath = ($userPath.TrimEnd(";") + ";" + $npmPrefix).TrimStart(";")
    [System.Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    Write-Ok "Added '$npmPrefix' to User PATH permanently."
}

# ── 6. Refresh PATH for this session ──────────────────────────────────────────
if ($env:PATH -split ";" -notcontains $npmPrefix) {
    $env:PATH = $env:PATH.TrimEnd(";") + ";" + $npmPrefix
}

# ── 7. Verify ─────────────────────────────────────────────────────────────────
Write-Step "Verifying installation..."
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Ok "claude $(claude --version) is ready."
    Write-Host "`nNext step: run 'claude auth login' to authenticate." -ForegroundColor Yellow
} else {
    Write-Fail "'claude' still not found. Try opening a new PowerShell window and running 'claude --version'."
    Write-Host "   If it still fails, manually add '$npmPrefix' to your PATH." -ForegroundColor Yellow
    exit 1
}
