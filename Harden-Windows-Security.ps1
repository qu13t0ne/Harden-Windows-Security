<#PSScriptInfo

.VERSION 2023.2.4

.GUID d435a293-c9ee-4217-8dc1-4ad2318a5770

.AUTHOR HotCakeX

.COMPANYNAME SpyNetGirl

.COPYRIGHT 2023

.TAGS Windows Hardening Security Bitlocker Defender Firewall Edge Protection

.LICENSEURI 

.PROJECTURI https://github.com/HotCakeX/Harden-Windows-Security

.ICONURI https://raw.githubusercontent.com/HotCakeX/Harden-Windows-Security/main/ICONURI.png

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
## 
Version 2022.12.8: Improved the script
## 
Version 2022.12.9: Configured LSASS process to run as a protected process with UEFI Lock
## 
Version 2022.12.9.1: Added new icon for the script
## 
Version 2022.12.10: Enabled ECH (Encrypted Client Hello of TLS) feature for Edge browser
## 
Version 2022.12.25: Entirely changed and organized the script's style to be easier to read and find commands
## 
Version 2022.12.26: Further improved the script with explanatory comments and improved the Optional Windows Features section
## 
Version 2022.12.26.1: Significantly improved Bitlocker script block, logic and style
## 
Version 2022.12.26.2: Optimized the script by performing registry modifications using a function and saved 600 lines of code
## 
Version 2023.1: The script now allows you to run each hardening category separately and added 2 more categories, 1) certificates and 2) Country IP Blocking
## 
Version 2023.1.1: added a checking process to the country IP blocking category so that if the list is empty, no rule will be created.
## 
Version 2023.1.1.1: Changed description of the PowerShell Gallery's page
## 
Version 2023.1.10: Removed old unnecessary outdated commands, removed most of the links and all descriptions from the script file, USE GITHUB PAGE FOR THE REFERENCE AND PROPER EXPLANATION.
## 
Version 2023.1.12: changed Firewall LOLBin blocking section to be faster with Parallel operations and added Secured-core PC compliancy
## 
Version 2023.1.12.1: Fixed description text in PowerShell Gallery
## 
Version 2023.1.13: Fixed the Country IP blocking list and made it fully compliant with https://www.state.gov/state-sponsors-of-terrorism/
## 
Version 2023.1.13.1: Removed the ECH related commands, they weren't official methods, removed Russia in country IP blocking since it wasn't mentioned in https://www.state.gov/state-sponsors-of-terrorism/ . changed Windows time sync interval from every 7 days to every 4 days (previous script value was 2).
## 
Version 2023.1.13.2: made Firewall processing section faster by defining a ThrottleLimit based on CPU's logical cores
## 
Version 2023.1.16: Bitlocker category now encrypts all drives instead of just OS drive. Certificate checking category now handles situations when WebDav can't be used.
## 
Version 2023.1.17: fixed text spacing and colors to improve readability, removed LOLBins blocking as it's no longer necessary to do so. the security features in place make LOLBins blocking unnecessary and redundant and blocking those programs in Firewall can have unknown/unwated behavior.
## 
Version 2023.1.22: Added a notice at the beginning of the script to remind the user to read GitHub readme page. added Smart App Control to the Windows Security (Defender) section. script asks for confirmation before turning on Smart App Control.
## 
Version 2023.1.23: Changed the registry modification function with a more advanced one. changed code style to reduce function call and use hash tables. Improved the overall design and style of the script. Changed 'ConsentPromptBehaviorAdmin' from UAC category to a #TopSecurity tagged command. see this GitHub issue for more info. https://github.com/HotCakeX/Harden-Windows-Security/issues/2#issuecomment-1400115303 . removed PowerShell Core requirement.
## 
Version 2023.1.24: enforce encryption type on removable and fixed drive types to full disk encryption instead of only used disk encryption
## 
Version 2023.1.25: The script now applies the official Microsoft Security Baselines and on top of that applies as many of the script settings as possible using Group Policy, the rest of the settings that aren't possible to be applied using Group Policy continue to be applied using registry and PowerShell Cmdlets.
## 
Version 2023.1.26: completely optimized the script, changed it to be multilingual-friendly and people with non-English language packs installed or with non-English keyboards, will have an easy time using the script. Thanks to the community feedback on GitHub!
## 
Version 2023.1.28: Bitlocker DMA protection enables only when Kernel DMA protection is unavailable, as suggested by Microsoft, and this happens using Group Policies instead of registry. Improved verbosity when importing and installing policies.
## 
Version 2023.1.29: Improved Security Baselines categories. added error handling when no Internet connection is available to download them.
## 
Version 2023.2.4: Added more Windows Security Policies, the script now lets you run each category individually even if they involve Group Policy.
#>

<# 

.SYNOPSIS
    Harden Windows 11 safely, securely using Official Supported methods with proper explanation

.DESCRIPTION


  ⭕ You need to read the GitHub's readme page before running this script: https://github.com/HotCakeX/Harden-Windows-Security

💠 Features of this Hardening script:

  ✅ Always up-to-date and works with latest build of Windows (Currently Windows 11 - compatible and rigorously tested on stable and Insider Dev builds)
  ✅ Doesn't break anything
  ✅ Doesn't remove or disable Windows functionalities against Microsoft's recommendation
  ✅ The Readme page on GitHub is used as the reference for all of the security measures applied by this script and Group Policies. the order in which they appear there is the same as the one in the script file.
  ✅ When a hardening command is no longer necessary because it's applied by default by Microsoft on new builds of Windows, it will also be removed from this script in order to prevent any problems and because it won't be necessary anymore.
  ✅ The script can be run infinite number of times, it's made in a way that it won't make any duplicate changes at all.
  ✅ The script asks for confirmation, in the PowerShell console, before running each hardening category, so you can selectively run (or don't run) each of them.
  ✅ Running this script makes your PC compliant with Secured-core PC specifications (providing that you use a modern hardware that supports the latest Windows security features). 
  ✅ Running this script makes your system compliant with the official Microsoft Security Baselines


🛑 Warning: Windows by default is secure and safe, this script does not imply nor claim otherwise. just like anything, you have to use it wisely and don't compromise yourself with reckless behavior and bad user configuration; Nothing is foolproof. this script only uses the tools and features that have already been implemented by Microsoft in Windows OS to fine-tune it towards the highest security and locked-down state, using well-documented, supported, recommended and official methods. continue reading on GitHub for comprehensive info.

💠 Hardening Categories from top to bottom: (🔺Detailed info about each of them at my Github🔻)

⏹ Commands that require Administrator Privileges
  ✅Microsoft Security Baselines
  ✅Security Baselines X
  ✅ Windows Security aka Defender
  ✅ Attack surface reduction rules
  ✅ Bitlocker Settings
  ✅ TLS Security
  ✅ Lock Screen
  ✅ UAC (User Account Control)
  ✅ Device Guard
  ✅ Windows Firewall
  ✅ Optional Windows Features
  ✅ Windows Networking
  ✅ Miscellaneous Configurations
  ✅ Certificate Checking Commands
  ✅ Country IP Blocking
⏹ Commands that don't require Administrator Privileges
  ✅ Non-Admin Commands that only affect the current user and do not make machine-wide changes.


💎 Note: if there are multiple Windows user accounts in your computer, it's recommended to run this script in each of them, without administrator privileges, because Non-admin commands only apply to the current user and are not machine wide.

💎 Note: The script asks for confirmation, in the PowerShell console, before running each hardening category, so you can selectively run (or don't run) each of them.

💎 Note: There are 4 items tagged with #TopSecurity that can cause difficulties. When you run this script, you will have an option to enable them if you want to. You can find all the information about them on GitHub.

🏴 if you have any questions, requests, suggestions etc. about this script, please open a new discussion in GitHub:

🟡 https://github.com/HotCakeX/Harden-Windows-Security/discussions

.EXAMPLE

  
   type: "Set-ExecutionPolicy Bypass -Scope Process" without quotes, in an Elevated PowerShell, to allow running this script for the current session.
   
.NOTES
    
    Check out GitHub page for security recommendations: https://github.com/HotCakeX/Harden-Windows-Security

#>

 


$infomsg = "`r`n" +
"#############################################################################################################`r`n" +
"###  Make Sure you've completely read what's written in the GitHub repository, before running this script ###`r`n" +
"#############################################################################################################`r`n"
Write-Host $infomsg -ForegroundColor Cyan

$infomsg = "`r`n" +
"###########################################################################################`r`n" +
"###  Link to the GitHub Repository: https://github.com/HotCakeX/Harden-Windows-Security ###`r`n" +
"###########################################################################################`r`n"
Write-Host $infomsg -ForegroundColor Green




# check if user's OS is Windows Home edition
if (((Get-WmiObject Win32_OperatingSystem).OperatingSystemSKU) -eq "101") {

    Write-host "Windows Home edition detected, exiting..." -ForegroundColor Red
    break
}


#region Functions
# Questions function
function Select-Option {
    param(
        [parameter(Mandatory = $true, Position = 0)][string]$Message,
        [parameter(Mandatory = $true, Position = 1)][string[]]$Options
    )
    $Selected = $null
    while ($null -eq $Selected) {
        Write-Host $Message -ForegroundColor Magenta
        for ($i = 0; $i -lt $Options.Length; $i++) { Write-Host "$($i+1): $($Options[$i])" }
        $SelectedIndex = Read-Host "Select an option"
        if ($SelectedIndex -gt 0 -and $SelectedIndex -le $Options.Length) { $Selected = $Options[$SelectedIndex - 1] }
        else { Write-Host "Invalid Option." -ForegroundColor Yellow }
    }
    return $Selected
}




# Registry modification function
function ModifyRegistry {
    param (
        [Parameter(Mandatory = $false)][HashTable]$HashTable,
        [Parameter(Mandatory = $false)][String]$RegPath,
        [Parameter(Mandatory = $false)][String]$RegName,
        [Parameter(Mandatory = $false)][String]$RegValue
    )
    function processit {
        param([hashtable]$hash)

        If (-NOT (Test-Path $hash.RegPath)) { 
            New-Item -Path $hash.RegPath -Force | Out-Null
        }
        New-ItemProperty -Path $hash.RegPath -Name $hash.RegName -Value $hash.RegValue -PropertyType DWORD -Force

        [pscustomobject]@{
            Path  = $hash.RegPath
            Name  = $hash.RegName
            Value = $hash.RegValue
        }
    }
    if ($HashTable) {
        if ($HashTable.ContainsKey('RegPath')) {
            processit -hash $HashTable
        }
        else {
            foreach ($item in $HashTable.GetEnumerator()) {
                if ($item.Value -is [hashtable]) {
                    if ($item.Value.ContainsKey('RegPath') -and $item.Value.ContainsKey('RegValue')) {
                        $hash = $item.Value
                        if (-not $hash.ContainsKey('RegName')) {
                            $hash.RegName = $item.Key
                        }
                        processit -hash $hash
                    }
                    else {
                        Write-Warning "Invalid hashtable format - missing RegPath and/or RegValue key"
                    }
                }
                else {
                    Write-Warning "Item does not contain a hashtable"
                }
            }
        }
    }
    else {
        processit @{RegPath = $RegPath; RegName = $RegName; RegValue = $RegValue }
    }
}







# https://devblogs.microsoft.com/scripting/use-function-to-determine-elevation-of-powershell-console/
# Function to test if current session has administrator privileges
Function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()

    $principal = New-Object Security.Principal.WindowsPrincipal $identity

    $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}




# Hiding invoke-webrequest progress because it creates lingering visual effect on PowerShell console for some reason
# https://github.com/PowerShell/PowerShell/issues/14348

# https://stackoverflow.com/questions/18770723/hide-progress-of-invoke-webrequest
# Create an in-memory module so $ScriptBlock doesn't run in new scope
$null = New-Module {
    function Invoke-WithoutProgress {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory)] [scriptblock] $ScriptBlock
        )

        # Save current progress preference and hide the progress
        $prevProgressPreference = $global:ProgressPreference
        $global:ProgressPreference = 'SilentlyContinue'

        try {
            # Run the script block in the scope of the caller of this module function
            . $ScriptBlock
        }
        finally {
            # Restore the original behavior
            $global:ProgressPreference = $prevProgressPreference
        }
    }
}









#endregion functions


if (-NOT (Test-IsAdmin))

{ write-host "Skipping commands that require Administrator privileges" -ForegroundColor Magenta }

else {



    # create our working directory                           
    New-Item -ItemType Directory -Path "$env:TEMP\HardeningXStuff\" -Force 1> $null

    # working directory assignment
    $workingDir = "$env:TEMP\HardeningXStuff\"

    # change location to the new directory
    Set-Location $workingDir

    # Clean up script block
    $cleanUp = { Set-Location $env:user; remove-item -Recurse "$env:TEMP\HardeningXStuff\" -Force; exit }



    Write-Host "Downloading the required files, Please wait..." -ForegroundColor Yellow
    Invoke-WithoutProgress { 

        try {
                
            # download Microsoft Security Baselines directly from their servers
            Invoke-WebRequest -Uri "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/Windows%2011%20version%2022H2%20Security%20Baseline.zip" -OutFile ".\Windows1122H2SecurityBaseline.zip" -ErrorAction Stop

            # Download LGPO program from Microsoft servers
            Invoke-WebRequest -Uri "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip" -OutFile ".\LGPO.zip" -ErrorAction Stop

            # Download the Group Policies of Windows Hardening script from GitHub
            Invoke-WebRequest -Uri "https://github.com/HotCakeX/Harden-Windows-Security/raw/61f4f9fd8c0813230435ba22534e5897ad36eff1/GroupPolicy/Security-Baselines-X.zip" -OutFile ".\Security-Baselines-X.zip" -ErrorAction Stop
               
        }
        catch {
            Write-Host "The required files couldn't be downloaded, Make sure you have Internet connection." -ForegroundColor Red
            &$cleanUp   
        }

    }


    # unzip Microsoft Security Baselines file
    Expand-Archive -Path .\Windows1122H2SecurityBaseline.zip -DestinationPath .\ -Force

    # unzip the LGPO file
    Expand-Archive -Path .\LGPO.zip -DestinationPath .\ -Force

    # unzip the Security-Baselines-X file which contains Windows Hardening script Group Policy Objects
    expand-Archive -Path .\Security-Baselines-X.zip -DestinationPath .\Security-Baselines-X\ -Force



    #region Microsoft-Security-Baseline   
    # =========================================================================================================================
    # ================================================Microsoft Security Baseline==============================================
    # =========================================================================================================================

    switch (Select-Option -Options "Yes", "No", "Exit" -Message "`nApply Microsoft Security Baseline ?") {
        "Yes" {
       

            # Copy LGPO.exe from its folder to Microsoft Security Baseline folder in order to get it ready to be used by PowerShell script
            Copy-Item -Path ".\LGPO_30\LGPO.exe" -Destination ".\Windows-11-v22H2-Security-Baseline\Scripts\Tools"

            # Change directory to the Security Baselines folder
            Set-Location ".\Windows-11-v22H2-Security-Baseline\Scripts\"

            Write-Host "`nApplying Microsoft Security Baseline" -ForegroundColor Cyan
            # Run the official PowerShell script included in the Microsoft Security Baseline file we downloaded from Microsoft servers
            .\Baseline-LocalInstall.ps1 -Win11NonDomainJoined
           

 
        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ============================================End of Microsoft Security Baselines====================================================
    # =========================================================================================================================
    #endregion Microsoft-Security-Baseline





 
    #region Windows-Security-Defender
    # =========================================================================================================================
    # ==========================================Windows Security aka Defender==================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Windows Security (Defender) category ?") {
        "Yes" {
 

            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying Windows Security (Defender) policies" -ForegroundColor Cyan
            .\LGPO.exe /m "..\Security-Baselines-X\Windows Security (Defender) Policies\registry.pol"
        

            # Optimizing Network Protection Performance of Windows Defender - this was off by default on Windows 11 insider build 25247
            Set-MpPreference -AllowSwitchToAsyncInspection $True


            
            switch (Select-Option -Options "Yes", "No", "Exit" -Message "Turn on Smart App Control ?") {
                "Yes" {

                    # Turn on Smart App Control
                    ModifyRegistry -RegPath 'HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy' -RegName 'VerifiedAndReputablePolicyState' -RegValue '1'

                } "No" { break }
                "Exit" { exit }
            }

            # Enable Mandatory ASLR
            set-processmitigation -System -Enable ForceRelocateImages


        } "No" { break }
        "Exit" { &$cleanUp }
    }

    # =========================================================================================================================
    # =========================================End of Windows Security aka Defender============================================
    # =========================================================================================================================
    #endregion Windows-Security-Defender





    #region Attack-Surface-Reduction-Rules
    # =========================================================================================================================
    # =========================================Attack Surface Reduction Rules==================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Attack Surface Reduction Rules category ?") {
        "Yes" {


            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying Attack Surface Reduction rules policies" -ForegroundColor Cyan
            .\LGPO.exe /m "..\Security-Baselines-X\Attack Surface Reduction Rules Policies\registry.pol"



        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # =========================================End of Attack Surface Reduction Rules===========================================
    # =========================================================================================================================
    #endregion Attack-Surface-Reduction-Rules








    #region Bitlocker-Settings
    # =========================================================================================================================
    # ==========================================Bitlocker Settings=============================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Bitlocker category ?") {
        "Yes" {
     

            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying Bitlocker policies" -ForegroundColor Cyan
            .\LGPO.exe /m "..\Security-Baselines-X\Bitlocker Policies\registry.pol"


            # This PowerShell script can be used to find out if the DMA Protection is ON \ OFF.
            # The Script will show this by emitting True \ False for On \ Off respectively.

            # bootDMAProtection check - checks for Kernel DMA Protection status in System information or msinfo32
            $bootDMAProtectionCheck =
            @"
  namespace SystemInfo
    {
      using System;
      using System.Runtime.InteropServices;

      public static class NativeMethods
      {
        internal enum SYSTEM_DMA_GUARD_POLICY_INFORMATION : int
        {
            /// </summary>
            SystemDmaGuardPolicyInformation = 202
        }

        [DllImport("ntdll.dll")]
        internal static extern Int32 NtQuerySystemInformation(
          SYSTEM_DMA_GUARD_POLICY_INFORMATION SystemDmaGuardPolicyInformation,
          IntPtr SystemInformation,
          Int32 SystemInformationLength,
          out Int32 ReturnLength);

        public static byte BootDmaCheck() {
          Int32 result;
          Int32 SystemInformationLength = 1;
          IntPtr SystemInformation = Marshal.AllocHGlobal(SystemInformationLength);
          Int32 ReturnLength;

          result = NativeMethods.NtQuerySystemInformation(
                    NativeMethods.SYSTEM_DMA_GUARD_POLICY_INFORMATION.SystemDmaGuardPolicyInformation,
                    SystemInformation,
                    SystemInformationLength,
                    out ReturnLength);

          if (result == 0) {
            byte info = Marshal.ReadByte(SystemInformation, 0);
            return info;
          }

          return 0;
        }
      }
    }
"@

            Add-Type -TypeDefinition $bootDMAProtectionCheck

            # returns true or false depending on whether Kernel DMA Protection is on or off
            $bootDMAProtection = ([SystemInfo.NativeMethods]::BootDmaCheck()) -ne 0


            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"
            
            # Enables or disables DMA protection from Bitlocker Countermeasures based on the status of Kernel DMA protection.
            if ($bootDMAProtection) { 
                
                Write-Host "Kernel DMA protection is enabled on the system, disabling Bitlocker DMA protection." -ForegroundColor Blue
                .\LGPO.exe /m "..\Security-Baselines-X\Overrides for Microsoft Security Baseline\Bitlocker DMA\Bitlocker DMA Countermeasure OFF\Registry.pol"
                           
            }
            else {

                Write-Host "Kernel DMA protection is unavailable on the system, enabling Bitlocker DMA protection." -ForegroundColor Blue
                .\LGPO.exe /m "..\Security-Baselines-X\Overrides for Microsoft Security Baseline\Bitlocker DMA\Bitlocker DMA Countermeasure ON\Registry.pol"
                                                          
            }

            









            # set-up Bitlocker encryption for OS Drive with TPMandPIN and recovery password keyprotectors and Verify its implementation
            # https://learn.microsoft.com/en-us/powershell/module/bitlocker/remove-bitlockerkeyprotector?view=windowsserver2022-ps
            # Once it's done, it saves the recovery password in a text file in the encrypted drive
            # Make sure to keep it in a safe place, e.g. in OneDrive's Personal Vault which requires authentication to access.




            <#
https://stackoverflow.com/questions/48809012/compare-two-credentials-in-powershell


 Safely compares two SecureString objects without decrypting them.
 Outputs $true if they are equal, or $false otherwise.
#>



            function Compare-SecureString {
                param(
                    [Security.SecureString] $secureString1,
                    [Security.SecureString] $secureString2
                )
                try {
                    $bstr1 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString1)
                    $bstr2 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString2)
                    $length1 = [Runtime.InteropServices.Marshal]::ReadInt32($bstr1, -4)
                    $length2 = [Runtime.InteropServices.Marshal]::ReadInt32($bstr2, -4)
                    if ( $length1 -ne $length2 ) {
                        return $false
                    }
                    for ( $i = 0; $i -lt $length1; ++$i ) {
                        $b1 = [Runtime.InteropServices.Marshal]::ReadByte($bstr1, $i)
                        $b2 = [Runtime.InteropServices.Marshal]::ReadByte($bstr2, $i)
                        if ( $b1 -ne $b2 ) {
                            return $false
                        }
                    }
                    return $true
                }
                finally {
                    if ( $bstr1 -ne [IntPtr]::Zero ) {
                        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr1)
                    }
                    if ( $bstr2 -ne [IntPtr]::Zero ) {
                        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr2)
                    }
                }
            }



  
            # check, make sure there is no CD/DVD drives in the system, because Bitlocker throws an error when there is
            $CDDVDCheck = (Get-WMIObject -Class Win32_CDROMDrive -Property *).MediaLoaded
            if ($CDDVDCheck) {
                Write-Warning "Remove any CD/DVD drives from the system and run the Bitlocker category after that"
                break
            }


            # check, make sure Bitlocker isn't in the middle of decryption/encryption operation (on System Drive)
            if ((Get-BitLockerVolume -MountPoint $env:SystemDrive).EncryptionPercentage -ne "100" -and (Get-BitLockerVolume -MountPoint $env:SystemDrive).EncryptionPercentage -ne "0") {

                $kawai = (Get-BitLockerVolume -MountPoint $env:SystemDrive).EncryptionPercentage
                Write-Host "Please wait for Bitlocker operation to finish encrypting or decrypting the disk" -ForegroundColor Magenta
                Write-Host "drive $env:SystemDrive encryption is currently at $kawai" -ForegroundColor Magenta

            }

            else {




                # check if Bitlocker is enabled for the system drive
                if ((Get-BitLockerVolume -MountPoint $env:SystemDrive).ProtectionStatus -eq "on") { 
                 
               
                    $KeyProtectors = (Get-BitLockerVolume -MountPoint $env:SystemDrive).KeyProtector.keyprotectortype
                    # check if TPM, PIN and recovery password are being used with Bitlocker which are the safest settings
                    if ($KeyProtectors -contains 'Tpmpin' -and $KeyProtectors -contains 'recoveryPassword') {
        
                        Write-Host "Bitlocker is fully and securely enabled for OS drive" -ForegroundColor Green
    
                    }
                    else {       
                        # check if Bitlocker is using TPM and PIN but not recovery password as key protector
                        if ($KeyProtectors -contains 'Tpmpin' -and $KeyProtectors -notcontains 'recoveryPassword') {

                            Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -RecoveryPasswordProtector *> "$env:SystemDrive\Drive $($env:SystemDrive.remove(1)) recovery password.txt"
                            Write-Host "TPM and Startup Pin are available but the recovery password is missing, adding it now... `nthe recovery password will be saved in a Text file in $env:SystemDrive\Drive $($env:SystemDrive.remove(1)) recovery password.txt" -ForegroundColor yellow
                            Write-Host "Make sure to keep it in a safe place, e.g. in OneDrive's Personal Vault which requires authentication to access." -ForegroundColor Blue
                
                
                
                        }
                
                        # check if Bitlocker is using recovery password but not TPM and PIN
                        if ($KeyProtectors -notcontains 'Tpmpin' -and $KeyProtectors -contains 'recoveryPassword') {
            
                            Write-Host "TPM and Start up PIN key protectors are missing but recovery password key protector is in place, `nadding TPM and Start up PIN key protectors now..." -ForegroundColor Magenta
                


                            do {

                                $pin1 = $(write-host "Enter a Pin for Bitlocker startup (at least 6 digits)" -ForegroundColor Magenta; Read-Host -AsSecureString)
                                $pin2 = $(write-host "Confirm your Bitlocker Startup Pin (at least 6 digits)" -ForegroundColor Magenta; Read-Host -AsSecureString)
                    
                  
                                $theyMatch = Compare-SecureString $pin1 $pin2
                     
                  
                                if ( $theyMatch -and $pin1.Length -gt 5 -and $pin2.Length -gt 5  ) {
                  
                                    $pin = $pin1
                  
                                }
                  
                                else { Write-Host "the PINs you entered didn't match, try again" -ForegroundColor red }
                  
                            }
                  
                            until (
                                $theyMatch -and $pin1.Length -gt 5 -and $pin2.Length -gt 5
                            )



                 
                            try {

                                Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -TpmAndPinProtector -Pin $pin -ErrorAction Stop
                                Write-Host "PINs matched, enabling TPM and startup PIN now" -ForegroundColor DarkMagenta
                            }
    
                            catch {
         
                                Write-Host "These errors occured, run Bitlocker category again after meeting the requirements" -ForegroundColor Red
                                $Error
                                break
                            }

                        }
     
                    }
    
     
                }

   
                else {
                    Write-Host "Bitlocker is Not enabled for the System Drive Drive, activating now..." -ForegroundColor yellow
    
                    do {

                        $pin1 = $(write-host "Enter a Pin for Bitlocker startup (at least 6 digits)" -ForegroundColor Magenta; Read-Host -AsSecureString)
                        $pin2 = $(write-host "Confirm your Bitlocker Startup Pin (at least 6 digits)" -ForegroundColor Magenta; Read-Host -AsSecureString)

      
                        $theyMatch = Compare-SecureString $pin1 $pin2
      
      
                        if ( $theyMatch -and $pin1.Length -gt 5 -and $pin2.Length -gt 5  ) {
      
                            $pin = $pin1
      
                        }
      
                        else { Write-Host "the Pins you entered didn't match, try again" -ForegroundColor red }
      
                    }
      
                    until (
                        $theyMatch -and $pin1.Length -gt 5 -and $pin2.Length -gt 5
                    )

                    try {

                        enable-bitlocker -MountPoint $env:SystemDrive -EncryptionMethod XtsAes256 -pin $pin -TpmAndPinProtector -SkipHardwareTest -ErrorAction Stop
             
                    }

                    catch {

                        Write-Host "These errors occured, run Bitlocker category again after meeting the requirements" -ForegroundColor Red
                        $Error
                        break
                    }


     
                    Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -RecoveryPasswordProtector *> "$env:SystemDrive\Drive $($env:SystemDrive.remove(1)) recovery password.txt" 
                    Resume-BitLocker -MountPoint $env:SystemDrive
                    Write-Host "the recovery password will be saved in a Text file in $env:SystemDrive\Drive $($env:SystemDrive.remove(1)) recovery password.txt `nMake sure to keep it in a safe place, e.g. in OneDrive's Personal Vault which requires authentication to access." -ForegroundColor Blue
                    Write-Host "Bitlocker is now fully and securely enabled for OS drive" -ForegroundColor Green
            
             
     

                }


            }




            # Enable Bitlocker for all the other drives

            # check if there is any other drive besides OS drive
            $nonOSVolumes = Get-BitLockerVolume | Where-Object { $_.volumeType -ne "OperatingSystem" }

            if ($nonOSVolumes) {

                $nonOSVolumes | ForEach-Object {

                    $MountPoint = $_.MountPoint




                    if ((Get-BitLockerVolume -MountPoint $MountPoint).EncryptionPercentage -ne "100" -and (Get-BitLockerVolume -MountPoint $MountPoint).EncryptionPercentage -ne "0") {

                        $kawai = (Get-BitLockerVolume -MountPoint $MountPoint).EncryptionPercentage
                        Write-Host "Please wait for Bitlocker operation to finish encrypting or decrypting drive $MountPoint" -ForegroundColor Magenta
                        Write-Host "drive $MountPoint encryption is currently at $kawai" -ForegroundColor Magenta

                    }   

                    else {





                        if ((Get-BitLockerVolume -MountPoint $MountPoint).ProtectionStatus -eq "on") {          
    
                            $KeyProtectors = (Get-BitLockerVolume -MountPoint $MountPoint).KeyProtector.keyprotectortype
    
                            if ($KeyProtectors -contains 'RecoveryPassword') {
        
                                Write-Host "Bitlocker is fully and securely enabled for drive $MountPoint" -ForegroundColor Green
    
                            }

                            else {

                                Add-BitLockerKeyProtector -MountPoint $MountPoint -RecoveryPasswordProtector *> "$MountPoint\Drive $($MountPoint.Remove(1)) recovery password.txt";
                                Enable-BitLockerAutoUnlock -MountPoint $MountPoint
                                Write-Host "Bitlocker Recovery Password has been added for drive $MountPoint . it will be saved in a Text file in $($MountPoint)\Drive $($MountPoint.Remove(1)) recovery password.txt `nMake sure to keep it in a safe place, e.g. in OneDrive's Personal Vault which requires authentication to access." -ForegroundColor Blue
   
                            }


                        }

                        else {

                            Enable-BitLocker -MountPoint $MountPoint -RecoveryPasswordProtector *> "$MountPoint\Drive $($MountPoint.Remove(1)) recovery password.txt";
                            Enable-BitLockerAutoUnlock -MountPoint $MountPoint
                            Write-Host "Bitlocker has started encrypting drive $MountPoint . recovery password will be saved in a Text file in $($MountPoint)\Drive $($MountPoint.Remove(1)) recovery password.txt `nMake sure to keep it in a safe place, e.g. in OneDrive's Personal Vault which requires authentication to access." -ForegroundColor Blue
           

                        }


                    }

                }

            } # end of if statement for detecting whether there is any non-OS drives



            # Set Hibnernate mode to full
            powercfg /h /type full



        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ==========================================End of Bitlocker Settings======================================================
    # =========================================================================================================================
    #endregion Bitlocker-Settings




    #region TLS-Security
    # =========================================================================================================================
    # ==============================================TLS Security===============================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run TLS Security category ?") {
        "Yes" {




            $TLS = [ordered]@{
                # Disable TLS v1
                Key1 = @{
                    RegName  = 'DisabledByDefault'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client'
                    RegValue = '1'
                }
                Key2 = @{
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client'
                    RegValue = '0'
                }
                key3 = @{
                    RegName  = 'DisabledByDefault'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server'
                    RegValue = '1'
                }
                Key4 = @{
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server'
                    RegValue = '0'
                }
                # Disable TLS v1.1
                Key5 = @{
                    RegName  = 'DisabledByDefault'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client'
                    RegValue = '1'
                }
                Key6 = @{
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client'
                    RegValue = '0'
                }
                Key7 = @{
                    RegName  = 'DisabledByDefault'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server'
                    RegValue = '1'
                }
                Key8 = @{
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server'
                    RegValue = '0'
                }
            }
            # Disable TLS v1 and v1.1
            ModifyRegistry -HashTable $TLS





            # Enable TLS_CHACHA20_POLY1305_SHA256 Cipher Suite which is available but not enabled by default in Windows 11
            Enable-TlsCipherSuite -Name "TLS_CHACHA20_POLY1305_SHA256" -Position 0




            # disabling weak cipher suites


            try {
                # Disable NULL Cipher Suites - 1 
                Disable-TlsCipherSuite TLS_RSA_WITH_NULL_SHA256
                # Disable NULL Cipher Suites - 2
                Disable-TlsCipherSuite TLS_RSA_WITH_NULL_SHA
                # Disable NULL Cipher Suites - 3
                Disable-TlsCipherSuite TLS_PSK_WITH_NULL_SHA384
                # Disable NULL Cipher Suites - 4
                Disable-TlsCipherSuite TLS_PSK_WITH_NULL_SHA256
    
  
                Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_256_GCM_SHA384"
                Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_128_GCM_SHA256"
                Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_256_CBC_SHA256" 
                Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_128_CBC_SHA256"
                Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_256_CBC_SHA"
                Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_128_CBC_SHA"
                Disable-TlsCipherSuite -Name "TLS_PSK_WITH_AES_256_GCM_SHA384" 
                Disable-TlsCipherSuite -Name "TLS_PSK_WITH_AES_128_GCM_SHA256"
                Disable-TlsCipherSuite -Name "TLS_PSK_WITH_AES_256_CBC_SHA384"
                Disable-TlsCipherSuite -Name "TLS_PSK_WITH_AES_128_CBC_SHA256" 
            }
            catch {
                Write-Host "All weak TLS Cipher Suites have been disabled" -ForegroundColor Magenta
            }



            # Enabling Diffie–Hellman based key exchange algorithms

            # TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
            # must be already available by default according to Microsoft Docs but it isn't, on Windows 11 insider dev build 25272
            # https://learn.microsoft.com/en-us/windows/win32/secauthn/tls-cipher-suites-in-windows-11
            Enable-TlsCipherSuite -Name "TLS_DHE_RSA_WITH_AES_128_GCM_SHA256"



            # TLS_DHE_RSA_WITH_AES_128_CBC_SHA
            # Not enabled by default on Windows 11 according to the Microsoft Docs above
            Enable-TlsCipherSuite -Name "TLS_DHE_RSA_WITH_AES_128_CBC_SHA"


            # TLS_DHE_RSA_WITH_AES_256_CBC_SHA
            # Not enabled by default on Windows 11 according to the Microsoft Docs above
            Enable-TlsCipherSuite -Name "TLS_DHE_RSA_WITH_AES_256_CBC_SHA"





            # Disabling weak and unsecure ciphers


            @( # creating these registry keys that have forward slashes in them
                'SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56/56', # DES 56-bit 
                'SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128', # RC2 40-bit
                'SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128', # RC2 56-bit
                'SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128', # RC2 128-bit
                'SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128', # RC4 40-bit
                'SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128', # RC4 56-bit
                'SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128', # RC4 64-bit
                'SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128', # RC4 128-bit
                'SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168' # 3DES 168-bit (Triple DES 168)
            ) | ForEach-Object {
([Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $env:COMPUTERNAME)).CreateSubKey($_)
            }


            $WeakCiphers = [ordered]@{
                key1  = @{ #NULL
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL\'
                    RegValue = '0'
                }
                key2  = @{ # DES 56-bit 
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56/56'
                    RegValue = '0'
                }
                key3  = @{ # RC2 40-bit
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128'
                    RegValue = '0'
                }
                key4  = @{ # RC2 56-bit
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128'
                    RegValue = '0'
                }
                key5  = @{ # RC2 128-bit
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128'
                    RegValue = '0'
                }
                key6  = @{ # RC4 40-bit
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128'
                    RegValue = '0'
                }
                key7  = @{ # RC4 56-bit
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128'
                    RegValue = '0'
                }
                key8  = @{ # RC4 64-bit
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128'
                    RegValue = '0'
                }
                key9  = @{ # RC4 128-bit
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128'
                    RegValue = '0'
                }
                key10 = @{ # 3DES 168-bit (Triple DES 168)
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168'
                    RegValue = '0'
                }
                key11 = @{ # Disable MD5 Hashing Algorithm
                    RegName  = 'Enabled'
                    RegPath  = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5'
                    RegValue = '0'
                }
    
            }

            # Disabling Weak Ciphers and MD5 Hashing Algorithm
            ModifyRegistry -HashTable $WeakCiphers


        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ==========================================End of TLS Security============================================================
    # =========================================================================================================================
    #endregion TLS-Security


    #region Lock-Screen
    # =========================================================================================================================
    # ==========================================Lock Screen====================================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Lock Screen category ?") {
        "Yes" {


            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying Lock Screen policies" -ForegroundColor Cyan
            .\LGPO.exe /m "..\Security-Baselines-X\Lock Screen Policies\registry.pol"

            Write-Host "`nApplying Lock Screen Security policies" -ForegroundColor Cyan
            .\LGPO.exe /s "..\Security-Baselines-X\Lock Screen Policies\GptTmpl.inf"
        


        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ==========================================End of Lock Screen=============================================================
    # =========================================================================================================================
    #endregion Lock-Screen




    #region User-Account-Control
    # =========================================================================================================================
    # ==========================================User Account Control===========================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run User Account Control category ?") {
        "Yes" {

            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying User Account Control (UAC) Security policies" -ForegroundColor Cyan
            .\LGPO.exe /s "..\Security-Baselines-X\User Account Control UAC Policies\GptTmpl.inf"
        

        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ==========================================End of User Account Control====================================================
    # =========================================================================================================================
    #endregion User-Account-Control





    #region Device-Guard
    # =========================================================================================================================
    # ==========================================Device Guard===================================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Device Guard category ?") {
        "Yes" {

            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying Device Guard policies" -ForegroundColor Cyan
            .\LGPO.exe /m "..\Security-Baselines-X\Device Guard Policies\registry.pol"


        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ==========================================End of Device Guard============================================================
    # =========================================================================================================================
    #endregion Device-Guard






    #region Windows-Firewall
    # =========================================================================================================================
    # ====================================================Windows Firewall=====================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Windows Firewall category ?") {
        "Yes" {


            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying Windows Firewall policies" -ForegroundColor Cyan
            .\LGPO.exe /m "..\Security-Baselines-X\Windows Firewall Policies\registry.pol"

            # Disables Multicast DNS (mDNS) UDP-in Firewall Rules for all 3 Firewall profiles - disables only 3 rules
            get-NetFirewallRule |
            Where-Object { $_.RuleGroup -eq "@%SystemRoot%\system32\firewallapi.dll,-37302" -and $_.Direction -eq "inbound" } |
            ForEach-Object { Disable-NetFirewallRule -DisplayName $_.DisplayName }



        } "No" { break }
        "Exit" { exit }
    }
    # =========================================================================================================================
    # =================================================End of Windows Firewall=================================================
    # =========================================================================================================================
    #endregion Windows-Firewall




    #region Optional-Windows-Features
    # =========================================================================================================================
    # =================================================Optional Windows Features===============================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Optional Windows Features category ?") {
        "Yes" {


            # since PowerShell Core (only if installed from Microsoft Store) has problem with these commands, making sure the built-in PowerShell handles them
            # There are Github issues for it already: https://github.com/PowerShell/PowerShell/issues/13866


            # Disable PowerShell v2 (needs 2 commands)
            PowerShell.exe "if((get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2).state -eq 'enabled'){disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2 -norestart}else{Write-Host 'MicrosoftWindowsPowerShellV2 is already disabled' -ForegroundColor Darkgreen}"
            PowerShell.exe "if((get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root).state -eq 'enabled'){disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -norestart}else{Write-Host 'MicrosoftWindowsPowerShellV2Root is already disabled' -ForegroundColor Darkgreen}"

            # Disable Work Folders client
            PowerShell.exe "if((get-WindowsOptionalFeature -Online -FeatureName WorkFolders-Client).state -eq 'enabled'){disable-WindowsOptionalFeature -Online -FeatureName WorkFolders-Client -norestart}else{Write-Host 'WorkFolders-Client is already disabled' -ForegroundColor Darkgreen}"

            # Disable Internet Printing Client
            PowerShell.exe "if((get-WindowsOptionalFeature -Online -FeatureName Printing-Foundation-Features).state -eq 'enabled'){disable-WindowsOptionalFeature -Online -FeatureName Printing-Foundation-Features -norestart}else{Write-Host 'Printing-Foundation-Features is already disabled' -ForegroundColor Darkgreen}"

            # Disable Windows Media Player (legacy)
            PowerShell.exe "if((get-WindowsOptionalFeature -Online -FeatureName WindowsMediaPlayer).state -eq 'enabled'){disable-WindowsOptionalFeature -Online -FeatureName WindowsMediaPlayer -norestart}else{Write-Host 'WindowsMediaPlayer is already disabled' -ForegroundColor Darkgreen}"

            # Enable Windows Defender Application Guard
            PowerShell.exe "if((get-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard).state -eq 'disabled'){enable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard -norestart}else{Write-Host 'Windows-Defender-ApplicationGuard is already enabled' -ForegroundColor Darkgreen}"

            # Enable Windows Sandbox
            PowerShell.exe "if((get-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM).state -eq 'disabled'){enable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM -All -norestart}else{Write-Host 'Containers-DisposableClientVM (Windows Sandbox) is already enabled' -ForegroundColor Darkgreen}"

            # Enable Hyper-V
            PowerShell.exe "if((get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V).state -eq 'disabled'){enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -norestart}else{Write-Host 'Microsoft-Hyper-V is already enabled' -ForegroundColor Darkgreen}"

            # Enable Virtual Machine Platform
            PowerShell.exe "if((get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).state -eq 'disabled'){enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -norestart}else{Write-Host 'VirtualMachinePlatform is already enabled' -ForegroundColor Darkgreen}"



        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ==============================================End of Optional Windows Features===========================================
    # =========================================================================================================================
    #endregion Optional-Windows-Features





    #region Windows-Networking
    # =========================================================================================================================
    # ====================================================Windows Networking===================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Windows Networking category ?") {
        "Yes" {

            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying Windows Networking policies" -ForegroundColor Cyan
            .\LGPO.exe /m "..\Security-Baselines-X\Windows Networking Policies\registry.pol"

            # disable LMHOSTS lookup protocol on all network adapters
            ModifyRegistry -RegPath 'HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters' -RegName 'EnableLMHOSTS' -RegValue '0'

            # Set the Network Location of all connections to Public
            Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Public


        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # =================================================End of Windows Networking===============================================
    # =========================================================================================================================
    #endregion Windows-Networking




    #region Miscellaneous-Configurations
    # =========================================================================================================================
    # ==============================================Miscellaneous Configurations===============================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Miscellaneous Configurations category ?") {
        "Yes" {


            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying Miscellaneous Configurations policies" -ForegroundColor Cyan
            .\LGPO.exe /m "..\Security-Baselines-X\Miscellaneous Policies\registry.pol"

            Write-Host "`nApplying Miscellaneous Configurations Security policies" -ForegroundColor Cyan
            .\LGPO.exe /s "..\Security-Baselines-X\Miscellaneous Policies\GptTmpl.inf"

            # Turn on Enhanced mode search for Windows indexer
            ModifyRegistry -RegPath 'HKLM:\SOFTWARE\Microsoft\Windows Search' -RegName 'EnableFindMyFiles' -RegValue '1'

            # Enable SMB Encryption - using force to confirm the action
            Set-SmbServerConfiguration -EncryptData $true -force

            # Set Microsoft Edge to update over Metered connections
            ModifyRegistry -RegPath 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\ClientStateMedium\{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}' -RegName 'allowautoupdatesmetered' -RegValue '1'

            # Enable notify me when a restart is required to finish updating
            ModifyRegistry -RegPath 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -RegName 'RestartNotificationsAllowed2' -RegValue '1'

            # Allow all Windows users to use Hyper-V and Windows Sandbox by adding all Windows users to the "Hyper-V Administrators" security group
            Get-LocalUser | Where-Object { $_.enabled -EQ "True" } | Select-Object "Name" |
            ForEach-Object { Add-LocalGroupMember -Group "Hyper-V Administrators" -Member $_.Name -ErrorAction SilentlyContinue }

            # Change Windows time sync interval from every 7 days to every 4 days (= every 345600 seconds)
            ModifyRegistry -RegPath 'HKLM:\SYSTEM\ControlSet001\Services\W32Time\TimeProviders\NtpClient' -RegName 'SpecialPollInterval' -RegValue '345600'


        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ============================================End of Miscellaneous Configurations==========================================
    # =========================================================================================================================
    #endregion Miscellaneous-Configurations




    #region Overrides-for-Microsoft-Security-Baseline
    # =========================================================================================================================
    # ============================================Overrides for Microsoft Security Baseline====================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Apply Overrides for Microsoft Security Baseline ?") {
        "Yes" {

            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying policy Overrides for Microsoft Security Baseline" -ForegroundColor Cyan
            .\LGPO.exe /v /m "..\Security-Baselines-X\Overrides for Microsoft Security Baseline\registry.pol"
            Write-Host "`nApplying Security policy Overrides for Microsoft Security Baseline" -ForegroundColor Cyan
            .\LGPO.exe /v /s "..\Security-Baselines-X\Overrides for Microsoft Security Baseline\GptTmpl.inf"

        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ============================================End of Overrides for Microsoft Security Baseline=============================
    # =========================================================================================================================
    #endregion Overrides-for-Microsoft-Security-Baseline



    #region Top-Security-Measures
    # =========================================================================================================================
    # ============================================Top Security Measures========================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Apply Top Security Measures ?") {
        "Yes" { 

            
            # Change current working directory to the LGPO's folder
            Set-Location "$workingDir\LGPO_30"

            Write-Host "`nApplying Top Security Measures" -ForegroundColor Cyan
            .\LGPO.exe /s "..\Security-Baselines-X\Top Security Measures\GptTmpl.inf"


        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ============================================End of Top Security Measures=================================================
    # =========================================================================================================================
    #endregion Top-Security-Measures





    #region Certificate-Checking-Commands
    # =========================================================================================================================
    # ====================================================Certificate Checking Commands========================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Certificate Checking category ?") {
        "Yes" {


            # List valid certificates not rooted to the Microsoft Certificate Trust List in the User store
            switch (Select-Option -Options "Yes", "No" -Message "List valid certificates not rooted to the Microsoft Certificate Trust List in the User store ?") {
                "Yes" {

                    try {      
                        \\live.sysinternals.com\tools\sigcheck64.exe -tuv -accepteula -nobanner
                    }
                    catch {

                        Invoke-WebRequest -Uri "https://live.sysinternals.com/sigcheck64.exe" -OutFile "sigcheck64.exe"
                        .\sigcheck64.exe -tuv -accepteula -nobanner
                        Remove-Item .\sigcheck64.exe
                    }

                } "No" { break }
              
            }

      

            # List valid certificates not rooted to the Microsoft Certificate Trust List in the Machine store
            switch (Select-Option -Options "Yes", "No" -Message "List valid certificates not rooted to the Microsoft Certificate Trust List in the Machine store ?") {
                "Yes" {


                    try {
        
                        \\live.sysinternals.com\tools\sigcheck64.exe -tv -accepteula -nobanner
                    }

                    catch {
                        Invoke-WebRequest -Uri "https://live.sysinternals.com/sigcheck64.exe" -OutFile "sigcheck64.exe"
                        .\sigcheck64.exe -tv -accepteula -nobanner
                        Remove-Item .\sigcheck64.exe
                    }


                } "No" { break }
               
            }



        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ====================================================End of Certificate Checking Commands=================================
    # =========================================================================================================================
    #endregion Certificate-Checking-Commands




    #region Country-IP-Blocking
    # =========================================================================================================================
    # ====================================================Country IP Blocking==================================================
    # =========================================================================================================================
    switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Country IP Blocking category ?") {
        "Yes" {


            # -RemoteAddress in New-NetFirewallRule accepts array according to Microsoft Docs, 
            # so we use "[string[]]$IPList = $IPList -split '\r?\n' -ne ''" to convert the IP lists, which is a single multiline string, into an array

            function BlockCountryIP {
                param ($IPList , $CountryName)

                # checks if the rule is present and if it is, deletes them to get new up-to-date IP ranges from the sources
                if (Get-NetFirewallRule -DisplayName "$CountryName IP range blocking" -PolicyStore localhost 2> $null) 
                { Remove-NetFirewallRule -DisplayName "$CountryName IP range blocking" -PolicyStore localhost }

                # converts the list which is in string into array
                [string[]]$IPList = $IPList -split '\r?\n' -ne ''

                # makes sure the list isn't empty
                if ($IPList.count -eq 0) { Write-Host "The IP list was empty, skipping $CountryName" -ForegroundColor Yellow ; break }

      
                New-NetFirewallRule -DisplayName "$CountryName IP range blocking" -Direction Inbound -Action Block -LocalAddress Any -RemoteAddress $IPList -Description "$CountryName IP range blocking" -Profile Any -InterfaceType Any -Group "Hardening-Script-CountryIP-Blocking" -EdgeTraversalPolicy Block -PolicyStore localhost
                New-NetFirewallRule -DisplayName "$CountryName IP range blocking" -Direction Outbound -Action Block -LocalAddress Any -RemoteAddress $IPList -Description "$CountryName IP range blocking" -Profile Any -InterfaceType Any -Group "Hardening-Script-CountryIP-Blocking" -EdgeTraversalPolicy Block -PolicyStore localhost
        
            }



            # Iran
            switch (Select-Option -Options "Yes", "No" -Message "Block the entire range of IPv4 and IPv6 belonging to Iran?") {
                "Yes" {
    
                    $IranIPv4 = Invoke-RestMethod -Uri "https://www.ipdeny.com/ipblocks/data/aggregated/ir-aggregated.zone"
                    $IranIPv6 = Invoke-RestMethod -Uri "https://www.ipdeny.com/ipv6/ipaddresses/blocks/ir.zone"
                    $IranIPRange = $IranIPv4 + $IranIPv6
                    BlockCountryIP -IPList $IranIPRange -CountryName "Iran"

                } "No" { break }

            }



            # Cuba
            switch (Select-Option -Options "Yes", "No" -Message "Block the entire range of IPv4 and IPv6 belonging to Cuba?") {
                "Yes" {

                    $CubaIPv4 = Invoke-RestMethod -Uri "https://www.ipdeny.com/ipblocks/data/aggregated/cu-aggregated.zone"
                    $CubaIPv6 = Invoke-RestMethod -Uri "https://www.ipdeny.com/ipv6/ipaddresses/blocks/cu.zone"
                    $CubaIPRange = $CubaIPv4 + $CubaIPv6
                    BlockCountryIP -IPList $CubaIPRange -CountryName "Cuba"

                } "No" { break }

            }



            # North Korea
            switch (Select-Option -Options "Yes", "No" -Message "Block the entire range of IPv4 and IPv6 belonging to North Korea?") {
                "Yes" {
    
                    $NorthKoreaIPv4 = Invoke-RestMethod -Uri "https://www.ipdeny.com/ipblocks/data/aggregated/kp-aggregated.zone"
                    $NorthKoreaIPv6 = Invoke-RestMethod -Uri "https://www.ipdeny.com/ipv6/ipaddresses/blocks/kn.zone"
                    $NorthKoreaIPRange = $NorthKoreaIPv4 + $NorthKoreaIPv6
                    BlockCountryIP -IPList $NorthKoreaIPRange -CountryName "North Korea"

                } "No" { break }

            }


            # Syria
            switch (Select-Option -Options "Yes", "No" -Message "Block the entire range of IPv4 and IPv6 belonging to Syria?") {
                "Yes" {
    
                    $SyriaIPv4 = Invoke-RestMethod -Uri "https://www.ipdeny.com/ipblocks/data/aggregated/sy-aggregated.zone"
                    $SyriaIPv6 = Invoke-RestMethod -Uri "https://www.ipdeny.com/ipv6/ipaddresses/blocks/sy.zone"
                    $SyriaIPRange = $SyriaIPv4 + $SyriaIPv6
                    BlockCountryIP -IPList $SyriaIPRange -CountryName "Syria"

                } "No" { break }

            }


            # how to query the number of IPs in each rule
            # (Get-NetFirewallRule -DisplayName "Cuba IP range blocking" | Get-NetFirewallAddressFilter).RemoteAddress.count

        

        } "No" { break }
        "Exit" { &$cleanUp }
    }
    # =========================================================================================================================
    # ====================================================End of Country IP Blocking===========================================
    # =========================================================================================================================
    #endregion Country-IP-Blocking

    # make sure there is no leftover
    Set-Location $env:user; remove-item -Recurse "$env:TEMP\HardeningXStuff\" -Force
    
} # End of Admin test function


#region Non-Admin-Commands
# =========================================================================================================================
# ====================================================Non-Admin Commands===================================================
# =========================================================================================================================
switch (Select-Option -Options "Yes", "No", "Exit" -Message "Run Non-Admin category ?") {
    "Yes" {


        # Show known file extensions in File explorer
        ModifyRegistry -RegPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -RegName 'HideFileExt' -RegValue '0'

        # Show hidden files, folders and drives (toggles the control panel folder options item)
        ModifyRegistry -RegPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -RegName 'Hidden' -RegValue '1'

        # Disable websites accessing local language list
        ModifyRegistry -RegPath 'HKCU:\Control Panel\International\User Profile' -RegName 'HttpAcceptLanguageOptOut' -RegValue '1'

        # turn off safe search in Windows search. from Windows settings > privacy and security > search permissions > safe search
        ModifyRegistry -RegPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -RegName 'SafeSearchMode' -RegValue '0'

        # prevent showing notifications in Lock screen - this is the same as toggling the button in Windows settings > system > notifications > show notifications in the lock screen
        ModifyRegistry -RegPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -RegName 'NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK' -RegValue '0'

        # prevent showing notifications in Lock screen, 2nd reg key - this is the same as toggling the button in Windows settings > system > notifications > show notifications in the lock screen
        ModifyRegistry -RegPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications' -RegName 'LockScreenToastEnabled' -RegValue '0'

        # Enable Clipboard History for the current user
        ModifyRegistry -RegPath 'HKCU:\Software\Microsoft\Clipboard' -RegName 'EnableClipboardHistory' -RegValue '1'

        # 2 commands to enable sync of Clipboard history in Windows between devices
        ModifyRegistry -RegPath 'HKCU:\Software\Microsoft\Clipboard' -RegName 'CloudClipboardAutomaticUpload' -RegValue '1'

        # last one, to enable Clipboard sync
        ModifyRegistry -RegPath 'HKCU:\Software\Microsoft\Clipboard' -RegName 'EnableCloudClipboard' -RegValue '1'




        # creates Custom Views for Event Viewer in "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\"
        # Event Viewer custom views are saved in "C:\ProgramData\Microsoft\Event Viewer\Views". files in there can be backed up and restored on new Windows installations.

        # attack surface reduction rules events
        $path_0 = "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_0.xml"
        if (-NOT (Test-Path $path_0)) {
            New-Item -Path $path_0 -ItemType File -Force

            $View_0 =
            @"
<ViewerConfig><QueryConfig><QueryParams><UserQuery /></QueryParams><QueryNode><Name LanguageNeutralValue="attack surface reduction rule events">attack surface reduction rule events</Name><QueryList><Query Id="0" Path="Microsoft-Windows-Windows Defender/Operational"><Select Path="Microsoft-Windows-Windows Defender/Operational">*[System[(EventID=1121 or EventID=1122 or EventID=5007)]]</Select><Select Path="Microsoft-Windows-Windows Defender/WHC">*[System[(EventID=1121 or EventID=1122 or EventID=5007)]]</Select></Query></QueryList></QueryNode></QueryConfig><ResultsConfig><Columns><Column Name="Level" Type="System.String" Path="Event/System/Level" Visible="">111</Column><Column Name="Keywords" Type="System.String" Path="Event/System/Keywords">70</Column><Column Name="Date and Time" Type="System.DateTime" Path="Event/System/TimeCreated/@SystemTime" Visible="">190</Column><Column Name="Source" Type="System.String" Path="Event/System/Provider/@Name" Visible="">215</Column><Column Name="Event ID" Type="System.UInt32" Path="Event/System/EventID" Visible="">124</Column><Column Name="Task Category" Type="System.String" Path="Event/System/Task" Visible="">74</Column><Column Name="User" Type="System.String" Path="Event/System/Security/@UserID">50</Column><Column Name="Operational Code" Type="System.String" Path="Event/System/Opcode">110</Column><Column Name="Log" Type="System.String" Path="Event/System/Channel">80</Column><Column Name="Computer" Type="System.String" Path="Event/System/Computer">170</Column><Column Name="Process ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessID">70</Column><Column Name="Thread ID" Type="System.UInt32" Path="Event/System/Execution/@ThreadID">70</Column><Column Name="Processor ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessorID">90</Column><Column Name="Session ID" Type="System.UInt32" Path="Event/System/Execution/@SessionID">70</Column><Column Name="Kernel Time" Type="System.UInt32" Path="Event/System/Execution/@KernelTime">80</Column><Column Name="User Time" Type="System.UInt32" Path="Event/System/Execution/@UserTime">70</Column><Column Name="Processor Time" Type="System.UInt32" Path="Event/System/Execution/@ProcessorTime">100</Column><Column Name="Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@ActivityID">85</Column><Column Name="Relative Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@RelatedActivityID">140</Column><Column Name="Event Source Name" Type="System.String" Path="Event/System/Provider/@EventSourceName">140</Column></Columns></ResultsConfig></ViewerConfig>
"@
            Add-Content -Path "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_0.xml" -Value $View_0
        }

        # controlled folder access events
        $path_1 = "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_1.xml"
        if (-NOT (Test-Path $path_1)) {
            New-Item -Path $path_1 -ItemType File

            $View_1 =
            @"
<ViewerConfig><QueryConfig><QueryParams><UserQuery /></QueryParams><QueryNode><Name LanguageNeutralValue="controlled folder access events">controlled folder access events</Name><QueryList><Query Id="0" Path="Microsoft-Windows-Windows Defender/Operational"><Select Path="Microsoft-Windows-Windows Defender/Operational">*[System[(EventID=1123 or EventID=1124 or EventID=5007)]]</Select><Select Path="Microsoft-Windows-Windows Defender/WHC">*[System[(EventID=1123 or EventID=1124 or EventID=5007)]]</Select></Query></QueryList></QueryNode></QueryConfig></ViewerConfig>
"@
            Add-Content -Path "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_1.xml" -Value $View_1
        }
        # exploit protection events
        $path_2 = "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_2.xml"
        if (-NOT (Test-Path $path_2)) {
            New-Item -Path $path_2 -ItemType File

            $View_2 =
            @"
<ViewerConfig><QueryConfig><QueryParams><UserQuery /></QueryParams><QueryNode><Name LanguageNeutralValue="exploit protection events">exploit protection events</Name><SortConfig Asc="0"><Column Name="Date and Time" Type="System.DateTime" Path="Event/System/TimeCreated/@SystemTime" Visible="">275</Column></SortConfig><QueryList><Query Id="0" Path="Microsoft-Windows-Security-Mitigations/KernelMode"><Select Path="Microsoft-Windows-Security-Mitigations/KernelMode">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select><Select Path="Microsoft-Windows-Win32k/Concurrency">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select><Select Path="Microsoft-Windows-Win32k/Contention">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select><Select Path="Microsoft-Windows-Win32k/Messages">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select><Select Path="Microsoft-Windows-Win32k/Operational">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select><Select Path="Microsoft-Windows-Win32k/Power">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select><Select Path="Microsoft-Windows-Win32k/Render">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select><Select Path="Microsoft-Windows-Win32k/Tracing">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select><Select Path="Microsoft-Windows-Win32k/UIPI">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select><Select Path="System">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select><Select Path="Microsoft-Windows-Security-Mitigations/UserMode">*[System[Provider[@Name='Microsoft-Windows-Security-Mitigations' or @Name='Microsoft-Windows-WER-Diag' or @Name='Microsoft-Windows-Win32k' or @Name='Win32k'] and ( (EventID &gt;= 1 and EventID &lt;= 24)  or EventID=5 or EventID=260)]]</Select></Query></QueryList></QueryNode></QueryConfig><ResultsConfig><Columns><Column Name="Level" Type="System.String" Path="Event/System/Level" Visible="">225</Column><Column Name="Keywords" Type="System.String" Path="Event/System/Keywords">70</Column><Column Name="Date and Time" Type="System.DateTime" Path="Event/System/TimeCreated/@SystemTime" Visible="">275</Column><Column Name="Source" Type="System.String" Path="Event/System/Provider/@Name" Visible="">242</Column><Column Name="Event ID" Type="System.UInt32" Path="Event/System/EventID" Visible="">185</Column><Column Name="Task Category" Type="System.String" Path="Event/System/Task" Visible="">188</Column><Column Name="User" Type="System.String" Path="Event/System/Security/@UserID">50</Column><Column Name="Operational Code" Type="System.String" Path="Event/System/Opcode">110</Column><Column Name="Log" Type="System.String" Path="Event/System/Channel">80</Column><Column Name="Computer" Type="System.String" Path="Event/System/Computer">170</Column><Column Name="Process ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessID">70</Column><Column Name="Thread ID" Type="System.UInt32" Path="Event/System/Execution/@ThreadID">70</Column><Column Name="Processor ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessorID">90</Column><Column Name="Session ID" Type="System.UInt32" Path="Event/System/Execution/@SessionID">70</Column><Column Name="Kernel Time" Type="System.UInt32" Path="Event/System/Execution/@KernelTime">80</Column><Column Name="User Time" Type="System.UInt32" Path="Event/System/Execution/@UserTime">70</Column><Column Name="Processor Time" Type="System.UInt32" Path="Event/System/Execution/@ProcessorTime">100</Column><Column Name="Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@ActivityID">85</Column><Column Name="Relative Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@RelatedActivityID">140</Column><Column Name="Event Source Name" Type="System.String" Path="Event/System/Provider/@EventSourceName">140</Column></Columns></ResultsConfig></ViewerConfig>
"@
            Add-Content -Path "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_2.xml" -Value $View_2
        }
        # network protection events
        $path_3 = "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_3.xml"
        if (-NOT (Test-Path $path_3)) {
            New-Item -Path $path_3 -ItemType File

            $View_3 =
            @"
<ViewerConfig><QueryConfig><QueryParams><UserQuery /></QueryParams><QueryNode><Name LanguageNeutralValue="network protection events">network protection events</Name><QueryList><Query Id="0" Path="Microsoft-Windows-Windows Defender/Operational"><Select Path="Microsoft-Windows-Windows Defender/Operational">*[System[(EventID=1125 or EventID=1126 or EventID=5007)]]</Select><Select Path="Microsoft-Windows-Windows Defender/WHC">*[System[(EventID=1125 or EventID=1126 or EventID=5007)]]</Select></Query></QueryList></QueryNode></QueryConfig><ResultsConfig><Columns><Column Name="Level" Type="System.String" Path="Event/System/Level" Visible="">225</Column><Column Name="Keywords" Type="System.String" Path="Event/System/Keywords">70</Column><Column Name="Date and Time" Type="System.DateTime" Path="Event/System/TimeCreated/@SystemTime" Visible="">275</Column><Column Name="Source" Type="System.String" Path="Event/System/Provider/@Name" Visible="">242</Column><Column Name="Event ID" Type="System.UInt32" Path="Event/System/EventID" Visible="">185</Column><Column Name="Task Category" Type="System.String" Path="Event/System/Task" Visible="">188</Column><Column Name="User" Type="System.String" Path="Event/System/Security/@UserID">50</Column><Column Name="Operational Code" Type="System.String" Path="Event/System/Opcode">110</Column><Column Name="Log" Type="System.String" Path="Event/System/Channel">80</Column><Column Name="Computer" Type="System.String" Path="Event/System/Computer">170</Column><Column Name="Process ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessID">70</Column><Column Name="Thread ID" Type="System.UInt32" Path="Event/System/Execution/@ThreadID">70</Column><Column Name="Processor ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessorID">90</Column><Column Name="Session ID" Type="System.UInt32" Path="Event/System/Execution/@SessionID">70</Column><Column Name="Kernel Time" Type="System.UInt32" Path="Event/System/Execution/@KernelTime">80</Column><Column Name="User Time" Type="System.UInt32" Path="Event/System/Execution/@UserTime">70</Column><Column Name="Processor Time" Type="System.UInt32" Path="Event/System/Execution/@ProcessorTime">100</Column><Column Name="Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@ActivityID">85</Column><Column Name="Relative Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@RelatedActivityID">140</Column><Column Name="Event Source Name" Type="System.String" Path="Event/System/Provider/@EventSourceName">140</Column></Columns></ResultsConfig></ViewerConfig>
"@
            Add-Content -Path "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_3.xml" -Value $View_3
        }
        # MSI and Scripts for WDAC Auditing events
        $path_4 = "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_4.xml"
        if (-NOT (Test-Path $path_4)) {
            New-Item -Path $path_4 -ItemType File

            $View_4 =
            @"
<ViewerConfig><QueryConfig><QueryParams><Simple><Channel>Microsoft-Windows-AppLocker/MSI and Script</Channel><RelativeTimeInfo>0</RelativeTimeInfo><BySource>False</BySource></Simple></QueryParams><QueryNode><Name LanguageNeutralValue="MSI and Scripts for WDAC Auditing">MSI and Scripts for WDAC Auditing</Name><QueryList><Query Id="0" Path="Microsoft-Windows-AppLocker/MSI and Script"><Select Path="Microsoft-Windows-AppLocker/MSI and Script">*</Select></Query></QueryList></QueryNode></QueryConfig><ResultsConfig><Columns><Column Name="Level" Type="System.String" Path="Event/System/Level" Visible="">225</Column><Column Name="Keywords" Type="System.String" Path="Event/System/Keywords">70</Column><Column Name="Date and Time" Type="System.DateTime" Path="Event/System/TimeCreated/@SystemTime" Visible="">275</Column><Column Name="Source" Type="System.String" Path="Event/System/Provider/@Name" Visible="">185</Column><Column Name="Event ID" Type="System.UInt32" Path="Event/System/EventID" Visible="">185</Column><Column Name="Task Category" Type="System.String" Path="Event/System/Task" Visible="">188</Column><Column Name="User" Type="System.String" Path="Event/System/Security/@UserID">50</Column><Column Name="Operational Code" Type="System.String" Path="Event/System/Opcode">110</Column><Column Name="Log" Type="System.String" Path="Event/System/Channel">80</Column><Column Name="Computer" Type="System.String" Path="Event/System/Computer">170</Column><Column Name="Process ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessID">70</Column><Column Name="Thread ID" Type="System.UInt32" Path="Event/System/Execution/@ThreadID">70</Column><Column Name="Processor ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessorID">90</Column><Column Name="Session ID" Type="System.UInt32" Path="Event/System/Execution/@SessionID">70</Column><Column Name="Kernel Time" Type="System.UInt32" Path="Event/System/Execution/@KernelTime">80</Column><Column Name="User Time" Type="System.UInt32" Path="Event/System/Execution/@UserTime">70</Column><Column Name="Processor Time" Type="System.UInt32" Path="Event/System/Execution/@ProcessorTime">100</Column><Column Name="Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@ActivityID">85</Column><Column Name="Relative Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@RelatedActivityID">140</Column><Column Name="Event Source Name" Type="System.String" Path="Event/System/Provider/@EventSourceName">140</Column></Columns></ResultsConfig></ViewerConfig>
"@
            Add-Content -Path "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_4.xml" -Value $View_4
        }
        # Sudden Shut down events
        $path_5 = "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_5.xml"
        if (-NOT (Test-Path $path_5)) {
            New-Item -Path $path_5 -ItemType File

            $View_5 =
            @"
<ViewerConfig><QueryConfig><QueryParams><Simple><Channel>System</Channel><EventId>41,6008</EventId><RelativeTimeInfo>0</RelativeTimeInfo><BySource>False</BySource></Simple></QueryParams><QueryNode><Name LanguageNeutralValue="Sudden Shut down events">Sudden Shut down events</Name><Description>41= Unexpected Power loss or crash | 6008 = dirty shut down</Description><QueryList><Query Id="0" Path="System"><Select Path="System">*[System[(EventID=41 or EventID=6008)]]</Select></Query></QueryList></QueryNode></QueryConfig><ResultsConfig><Columns><Column Name="Level" Type="System.String" Path="Event/System/Level" Visible="">227</Column><Column Name="Keywords" Type="System.String" Path="Event/System/Keywords">70</Column><Column Name="Date and Time" Type="System.DateTime" Path="Event/System/TimeCreated/@SystemTime" Visible="">277</Column><Column Name="Source" Type="System.String" Path="Event/System/Provider/@Name" Visible="">187</Column><Column Name="Event ID" Type="System.UInt32" Path="Event/System/EventID" Visible="">187</Column><Column Name="Task Category" Type="System.String" Path="Event/System/Task" Visible="">188</Column><Column Name="User" Type="System.String" Path="Event/System/Security/@UserID">50</Column><Column Name="Operational Code" Type="System.String" Path="Event/System/Opcode">110</Column><Column Name="Log" Type="System.String" Path="Event/System/Channel">80</Column><Column Name="Computer" Type="System.String" Path="Event/System/Computer">170</Column><Column Name="Process ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessID">70</Column><Column Name="Thread ID" Type="System.UInt32" Path="Event/System/Execution/@ThreadID">70</Column><Column Name="Processor ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessorID">90</Column><Column Name="Session ID" Type="System.UInt32" Path="Event/System/Execution/@SessionID">70</Column><Column Name="Kernel Time" Type="System.UInt32" Path="Event/System/Execution/@KernelTime">80</Column><Column Name="User Time" Type="System.UInt32" Path="Event/System/Execution/@UserTime">70</Column><Column Name="Processor Time" Type="System.UInt32" Path="Event/System/Execution/@ProcessorTime">100</Column><Column Name="Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@ActivityID">85</Column><Column Name="Relative Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@RelatedActivityID">140</Column><Column Name="Event Source Name" Type="System.String" Path="Event/System/Provider/@EventSourceName">140</Column></Columns></ResultsConfig></ViewerConfig>
"@
            Add-Content -Path "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_5.xml" -Value $View_5
        }
        # Code Integrity Operational events
        $path_6 = "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_6.xml"
        if (-NOT (Test-Path $path_6)) {
            New-Item -Path $path_6 -ItemType File

            $View_6 =
            @"
<ViewerConfig><QueryConfig><QueryParams><Simple><Channel>Microsoft-Windows-CodeIntegrity/Operational</Channel><RelativeTimeInfo>0</RelativeTimeInfo><BySource>False</BySource></Simple></QueryParams><QueryNode><Name LanguageNeutralValue="Code Integrity Operational">Code Integrity Operational</Name><QueryList><Query Id="0" Path="Microsoft-Windows-CodeIntegrity/Operational"><Select Path="Microsoft-Windows-CodeIntegrity/Operational">*</Select></Query></QueryList></QueryNode></QueryConfig><ResultsConfig><Columns><Column Name="Level" Type="System.String" Path="Event/System/Level" Visible="">227</Column><Column Name="Keywords" Type="System.String" Path="Event/System/Keywords">70</Column><Column Name="Date and Time" Type="System.DateTime" Path="Event/System/TimeCreated/@SystemTime" Visible="">277</Column><Column Name="Source" Type="System.String" Path="Event/System/Provider/@Name" Visible="">187</Column><Column Name="Event ID" Type="System.UInt32" Path="Event/System/EventID" Visible="">187</Column><Column Name="Task Category" Type="System.String" Path="Event/System/Task" Visible="">188</Column><Column Name="User" Type="System.String" Path="Event/System/Security/@UserID">50</Column><Column Name="Operational Code" Type="System.String" Path="Event/System/Opcode">110</Column><Column Name="Log" Type="System.String" Path="Event/System/Channel">80</Column><Column Name="Computer" Type="System.String" Path="Event/System/Computer">170</Column><Column Name="Process ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessID">70</Column><Column Name="Thread ID" Type="System.UInt32" Path="Event/System/Execution/@ThreadID">70</Column><Column Name="Processor ID" Type="System.UInt32" Path="Event/System/Execution/@ProcessorID">90</Column><Column Name="Session ID" Type="System.UInt32" Path="Event/System/Execution/@SessionID">70</Column><Column Name="Kernel Time" Type="System.UInt32" Path="Event/System/Execution/@KernelTime">80</Column><Column Name="User Time" Type="System.UInt32" Path="Event/System/Execution/@UserTime">70</Column><Column Name="Processor Time" Type="System.UInt32" Path="Event/System/Execution/@ProcessorTime">100</Column><Column Name="Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@ActivityID">85</Column><Column Name="Relative Correlation Id" Type="System.Guid" Path="Event/System/Correlation/@RelatedActivityID">140</Column><Column Name="Event Source Name" Type="System.String" Path="Event/System/Provider/@EventSourceName">140</Column></Columns></ResultsConfig></ViewerConfig>
"@
            Add-Content -Path "C:\ProgramData\Microsoft\Event Viewer\Views\Hardening Script\View_6.xml" -Value $View_6
        }




        # turn on "Show text suggestions when typing on the physical keyboard" for the current user, toggles the option in Windows settings
        ModifyRegistry -RegPath 'HKCU:\Software\Microsoft\Input\Settings' -RegName 'EnableHwkbTextPrediction' -RegValue '1'

        # turn on "Multilingual text suggestions" for the current user, toggles the option in Windows settings
        ModifyRegistry -RegPath 'HKCU:\Software\Microsoft\Input\Settings' -RegName 'MultilingualEnabled' -RegValue '1'

        # turn off sticky key shortcut of pressing shift key 5 time fast - value is type string, can't use ModifyRegistry Function
        $RegistryPath = 'HKCU:\Control Panel\Accessibility\StickyKeys'  
        $Name = 'Flags'  
        $Value = '506' 
        If (-NOT (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null } 
        New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType string -Force



        $infomsg = "`r`n" +
        "################################################################################################`r`n" +
        "###  Please Restart your device to completely apply the security measures and Group Policies ###`r`n" +
        "################################################################################################`r`n"
        Write-Host $infomsg -ForegroundColor Cyan

   
      
    } "No" { break }
    "Exit" { break }
}
# =========================================================================================================================
# ====================================================End of Non-Admin Commands============================================
# =========================================================================================================================
#endregion Non-Admin-Commands
