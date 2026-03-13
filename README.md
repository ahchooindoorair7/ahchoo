# ahchoo

## Fix: `claude` Not Recognized in PowerShell

If you see this error in PowerShell:

```
claude : The term 'claude' is not recognized as the name of a cmdlet...
```

### Automatic fix (recommended)

Download and run the script in PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File fix-claude-path.ps1
```

The script will:
1. Check that Node.js / npm is installed
2. Install `@anthropic-ai/claude-code` globally if needed
3. Add the npm bin directory to your User PATH permanently
4. Verify the installation

### Manual steps

See [fix-powershell-claude.md](fix-powershell-claude.md) for step-by-step instructions.
