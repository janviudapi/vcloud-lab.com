<powershell>
%{if rdp_enabled}
Start-Sleep -Seconds 30

# Set Network profile to private
$Profile = Get-NetConnectionProfile
$Networkname = $Profile.Name
$Networkcat = $Profile.NetworkCategory
If ($Networkcat -ne "Private") {
    Set-NetConnectionProfile -Name $Networkname -NetworkCategory Private}
Else {""
      "-- Connection profile is Private.--"
      ""}

Start-Sleep -Seconds 30

Set-Itemproperty -path 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0' -Name "RestrictReceivingNTLMTraffic" -value 1
%{endif}
${init_powershell}

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Check if the firewall rule exists, and create it if it doesn't
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

# Set sshd service to start automatically
Set-Service -Name sshd -StartupType 'Automatic'

# Start the sshd service
Start-Service sshd

# Check for OpenSSH capabilities
$openSSHCapabilities = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

if ($openSSHCapabilities.Count -gt 0) {
    Write-Host "OpenSSH capabilities found:"
    foreach ($capability in $openSSHCapabilities) {
        Write-Host "Name: $($capability.Name)"
        Write-Host "State: $($capability.State)"
        Write-Host "Description: $($capability.Description)"
        Write-Host "------------------------"
    }
} else {
    Write-Host "No OpenSSH capabilities found."
}

# Modify sshd_config file to enable PasswordAuthentication
$configFilePath = "$env:ProgramData\ssh\sshd_config"
$passwordAuthLine = "PasswordAuthentication yes"

# Read the current content of the config file
$configContent = Get-Content -Path $configFilePath

# Replace "PasswordAuthentication no" with "PasswordAuthentication yes"
$configContent = $configContent -replace "^(#?\s*PasswordAuthentication\s+).*", "PasswordAuthentication yes"

# Write the updated content back to the config file
Set-Content -Path $configFilePath -Value $configContent

# Restart the sshd service to apply changes
Restart-Service sshd

# Allow inbound TC-TCP ports
New-NetFirewallRule -DisplayName "Allow TC-TCP Inbound" -Direction Inbound -Protocol TCP -LocalPort 7001,8080,30001,443,1999,2001,80,8088,22,15389,445,8083,8082,1433,8983,9090,8086,30066,8090,8089,55566,2888,3888,2181,5000,3000, 8086, 8087 -Action Allow
# Allow outbound TC-TCP ports
New-NetFirewallRule -DisplayName "Allow TC-TCP Outbound" -Direction Outbound -Protocol TCP -LocalPort 7001,8080,30001,443,1999,2001,80,8088,22,15389,445,8083,8082,1433,8983,9090,8086,30066,8090,8089,55566,2888,3888,2181,5000,3000, 8086, 8087 -Action Allow
 
# Allow inbound TC-UDP ports
New-NetFirewallRule -DisplayName "Allow TC-UDP Inbound" -Direction Inbound -Protocol UDP -LocalPort 29000,28001,3000,4544,8087,30002,30077,57093 -Action Allow
# Allow outbound TC-UDP ports
New-NetFirewallRule -DisplayName "Allow TC-UDP Outbound" -Direction Outbound -Protocol UDP -LocalPort 29000,28001,3000,4544,8087,30002,30077,57093 -Action Allow


# Specify the disk number
$diskNumber = 2

# Initialize the disk (use GPT or MBR as needed)
Initialize-Disk -Number $diskNumber -PartitionStyle GPT

# Create a new partition using the maximum size of the disk
$partition = New-Partition -DiskNumber $diskNumber -UseMaximumSize -AssignDriveLetter

# Format the partition with NTFS file system
Format-Volume -DriveLetter $partition.DriveLetter -FileSystem NTFS -NewFileSystemLabel "AdditionalDisk" -Confirm:$false


</powershell>
