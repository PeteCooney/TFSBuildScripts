# TFSBuildScripts
Powershell scripts for TFS Build

##Set-AssemblyVersion
###Purpose:
Automatically set the AssemblyFileVersion during a TFS build operation

###Usage:
* Upload to a known folder on the TFS build server
* Configure a **Pre-build script path** to consume the script
* Ensure that the **Build number format** is correctly defined, eg; $(BuildDefinitionName)_1.0.0$(Rev:.r)

##Make-NuGetPackages
###Purpose:
Automatically build NuGet packages during a TFS build operation

###Usage:
* Edit the poweshell script setting the OutputDirectory and NuGet file locations as required
* Add NuSpec files to each Project that will procude a package ensuring that you include the "$Binaries$" token in source file locations eg:

```xml
<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2011/08/nuspec.xsd">
    <metadata>
        <id>Test Assembly</id>
        <version>$version$</version>
        <title>Test Assembly</title>
        <authors>Test Company</authors>
        <requireLicenseAcceptance>false</requireLicenseAcceptance>
        <description>Common helper classes and methods</description>
        <copyright>© $year$ Test Company</copyright>
    </metadata>
    <files>
        <file src="$Binaries$\Test.dll" target="lib\net45" />
        <file src="$Binaries$\Test.pdb" target="lib\net45" />
    </files>
</package>
```

* Upload to a known folder on the TFS build server
* Configure a **Post-build script path** to consume the script
* Ensure that the **Build number format** is correctly defined, eg; $(BuildDefinitionName)_1.0.0$(Rev:.r)