[CmdletBinding()]
$solutionRoot = $env:TF_BUILD_SOURCESDIRECTORY;
$buildNumber  = $env:TF_BUILD_BUILDNUMBER;

Write "Set-AssemblyVersion...";
Write "Solution Root: $solutionRoot";
Write "Build: $buildNumber";

if ($buildNumber -eq $null)
{
    $buildNumber = "1.0.0.0"
}
else
{
    $parts = $buildNumber.Split('_')
    $buildNumber = $parts[$parts.Length - 1]
}

Write "AssemblyFileVersion resolved as: $buildNumber";

$folderRoot = Join-Path $solutionRoot "AssemblyInfo.cs";
$files = (gci -r $folderRoot).fullname;

if ($files.Length -gt 0)
{
    $fileCount = $files.Length;
    Write "Found $fileCount AssemblyInfo files to process";

    foreach ($file in $files) 
    {
        Write "Processing $file";

        # Backup the file for restore later
        $backFile = $file + "._ORI"
        $tempFile = $file + ".tmp"
        Copy-Item $file $backFile
    
        # Load the original file and update the assembly file version
        Get-Content $file |
        %{$_ -replace 'AssemblyFileVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', "AssemblyFileVersion(""$buildNumber"")" } > $tempFile
        Move-Item $tempFile $file -force
    }
}