# New Common Windows configuration file.
#
$ErrorActionPreference = "Stop"

. A:\windows-env.ps1

# Enable Bootlog
Write-Output "Enable Bootlog"
cmd /c "bcdedit /set {current} bootlog yes"

# Set the Security Policies
Write-Output "Setting Low Security Password Policies"
secedit /configure /db secedit.sdb /cfg A:\Low-SecurityPasswordPolicy.inf /quiet

# Add Firewall rules - these may be moved to Puppet at a later stage.
Write-Output "Enable permissive firewall rules"
netsh advfirewall firewall add rule name="All Incoming" dir=in action=allow enable=yes interfacetype=any profile=any localip=any remoteip=any
netsh advfirewall firewall add rule name="All Outgoing" dir=out action=allow enable=yes interfacetype=any profile=any localip=any remoteip=any


If ( ($WindowsVersion -like $WindowsServer2008R2) -and ($psversiontable.psversion.major -eq 5) ) {

    # WMF5/Win-2008r2 fails to sysprep without this fix.
    # Should really puppetize this - need to check if we have psversion fact
    
    Write-Host "Syspep fix for WMF5/Windows 2008R2"
    reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows\StreamProvider"    /v "LastFullPayloadTime" /t REG_DWORD /d 0 /f
}

# Re-Enable AutoAdminLogon
autologon -AcceptEula Administrator . PackerAdmin

# End
