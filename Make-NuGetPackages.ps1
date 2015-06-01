[CmdletBinding()]
Param
(
    [string]$OutputDirectory = "\\tfs\Packages",
    [string]$NuGet = "C:\NuGet.exe"
)

[string]$solutionRoot = $env:TF_BUILD_SOURCESDIRECTORY;
[string]$buildVersion = $env:TF_BUILD_BUILDNUMBER;
[string]$binariesPath = $env:TF_BUILD_BINARIESDIRECTORY;

Write "Make-NuGetPackages...";
Write "Solution Root: $solutionRoot";
Write "Build Version: $buildVersion";
Write "Binaries Path: $binariesPath";

$folderRoot = Join-Path $solutionRoot "*.nuspec";
$files = (gci -r $folderRoot).fullname;

if ($files.Length -gt 0)
{
    $fileCount = $files.Length;
    Write "Found $fileCount NuSpec files to process";

    # Work out what the version number should be
    if ($buildVersion -eq $null)
    {
        $buildVersion = "1.0.0.0"
    }
    else
    {
        $parts = $buildVersion.Split('_')
        $buildVersion = $parts[$parts.Length - 1]
    }

    $year = Get-Date -Format yyyy;

    # Process each nuspec file in the solution
    foreach($nuspec in $files)
    {
        .$NuGet pack $nuspec -Properties "Binaries=$binariesPath;Year=$year" -OutputDirectory $OutputDirectory -Version $buildVersion
    }
}