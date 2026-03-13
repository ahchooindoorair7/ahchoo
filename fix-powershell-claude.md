# Fix: `claude` Command Not Recognized in PowerShell

## Error

```
PS C:\Users\nicky> claude remote-control
claude : The term 'claude' is not recognized as the name of a cmdlet, function,
script file, or operable program. Check the spelling of the name, or if a path
was included, verify that the path is correct and try again.
    + CategoryInfo          : ObjectNotFound: (claude:String) [], ParentContainsErrorRecordException
    + FullyQualifiedErrorId : CommandNotFoundException
```

## Cause

The `claude` CLI (Claude Code) is not installed, or its installation directory
is not included in the Windows `PATH` environment variable.

## Fix

### 1. Install Claude Code

If not yet installed, run the following in PowerShell (requires Node.js ≥ 18):

```powershell
npm install -g @anthropic-ai/claude-code
```

### 2. Verify Installation

```powershell
claude --version
```

If this succeeds, you're done.

### 3. Fix PATH (if installed but still not found)

Find where npm installs global packages:

```powershell
npm config get prefix
```

This will output something like `C:\Users\nicky\AppData\Roaming\npm`.

Add that directory to your PATH permanently:

```powershell
$npmPrefix = npm config get prefix
[System.Environment]::SetEnvironmentVariable(
    "PATH",
    "$env:PATH;$npmPrefix",
    [System.EnvironmentVariableTarget]::User
)
```

Then **restart PowerShell** and retry:

```powershell
claude --version
```

### 4. Alternative: Use the full path temporarily

```powershell
& "$env:APPDATA\npm\claude.cmd" remote-control
```

## Notes

- `claude remote-control` requires Claude Code to be installed and authenticated.
- Run `claude auth login` after installation to authenticate.
- Node.js can be downloaded from https://nodejs.org if not installed.
