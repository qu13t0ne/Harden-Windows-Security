Function Get-KernelModeDriversAudit {
    <#
    .DESCRIPTION
        This function will scan the Code Integrity event logs for kernel mode drivers that have been loaded since the audit mode policy has been deployed
        It will save them in a folder containing symbolic links to the driver files.
    .INPUTS
        System.IO.DirectoryInfo
    .OUTPUTS
        System.Void
    .PARAMETER SavePath
        The directory path to save the folder containing the symbolic links to the driver files
    .NOTES
        Get-SystemDriver only includes .sys files when -UserPEs parameter is not used, but Get-KernelModeDriversAudit function includes .dll files as well just in case

        When Get-SystemDriver -UserPEs is used, Dlls and .exe files are included as well
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param(
        [Parameter(Mandatory = $true)][System.IO.DirectoryInfo]$SavePath
    )
    begin {
        . "$ModuleRootPath\CoreExt\PSDefaultParameterValues.ps1"

        Write-Verbose -Message 'Importing the required sub-modules'
        Import-Module -FullyQualifiedName "$ModuleRootPath\Shared\Receive-CodeIntegrityLogs.psm1" -Force

        [System.IO.FileInfo[]]$KernelModeDriversPaths = @()
    }

    process {

        # Get the Code Integrity event logs for kernel mode drivers that have been loaded since the audit mode policy has been deployed
        [System.Object[]]$RawData = Receive-CodeIntegrityLogs -Date (Get-CommonWDACConfig -StrictKernelModePolicyTimeOfDeployment)

        Write-Verbose -Message "RawData count: $($RawData.count)"

        Write-Verbose -Message 'Saving the file paths to a variable'
        [System.IO.FileInfo[]]$KernelModeDriversPaths = $RawData.'File Name'

        Write-Verbose -Message 'Filtering based on files that exist with .sys and .dll extensions'
        $KernelModeDriversPaths = foreach ($Item in $KernelModeDriversPaths) {
            if (($Item.Extension -in ('.sys', '.dll')) -and $Item.Exists) {
                $Item
            }
        }

        Write-Verbose -Message "KernelModeDriversPaths count after filtering based on files that exist with .sys and .dll extensions: $($KernelModeDriversPaths.count)"

        Write-Verbose -Message 'Removing duplicates based on file path'
        $KernelModeDriversPaths = foreach ($Item in ($KernelModeDriversPaths | Group-Object -Property 'FullName')) {
            $Item.Group[0]
        }

        Write-Verbose -Message "KernelModeDriversPaths count after deduplication based on file path: $($KernelModeDriversPaths.count)"

        Write-Verbose -Message 'Creating symbolic links to the driver files'
        Foreach ($File in $KernelModeDriversPaths) {
            $null = New-Item -ItemType SymbolicLink -Path (Join-Path -Path $SavePath -ChildPath $File.Name) -Target $File.FullName
        }
    }
}
Export-ModuleMember -Function 'Get-KernelModeDriversAudit'

# SIG # Begin signature block
# MIILkgYJKoZIhvcNAQcCoIILgzCCC38CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDT/ss6y0BoGedf
# WT2WU5MzNgs3RPWVsUxHfw/wNDwqzKCCB9AwggfMMIIFtKADAgECAhMeAAAABI80
# LDQz/68TAAAAAAAEMA0GCSqGSIb3DQEBDQUAME8xEzARBgoJkiaJk/IsZAEZFgNj
# b20xIjAgBgoJkiaJk/IsZAEZFhJIT1RDQUtFWC1DQS1Eb21haW4xFDASBgNVBAMT
# C0hPVENBS0VYLUNBMCAXDTIzMTIyNzExMjkyOVoYDzIyMDgxMTEyMTEyOTI5WjB5
# MQswCQYDVQQGEwJVSzEeMBwGA1UEAxMVSG90Q2FrZVggQ29kZSBTaWduaW5nMSMw
# IQYJKoZIhvcNAQkBFhRob3RjYWtleEBvdXRsb29rLmNvbTElMCMGCSqGSIb3DQEJ
# ARYWU3B5bmV0Z2lybEBvdXRsb29rLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBAKb1BJzTrpu1ERiwr7ivp0UuJ1GmNmmZ65eckLpGSF+2r22+7Tgm
# pEifj9NhPw0X60F9HhdSM+2XeuikmaNMvq8XRDUFoenv9P1ZU1wli5WTKHJ5ayDW
# k2NP22G9IPRnIpizkHkQnCwctx0AFJx1qvvd+EFlG6ihM0fKGG+DwMaFqsKCGh+M
# rb1bKKtY7UEnEVAsVi7KYGkkH+ukhyFUAdUbh/3ZjO0xWPYpkf/1ldvGes6pjK6P
# US2PHbe6ukiupqYYG3I5Ad0e20uQfZbz9vMSTiwslLhmsST0XAesEvi+SJYz2xAQ
# x2O4n/PxMRxZ3m5Q0WQxLTGFGjB2Bl+B+QPBzbpwb9JC77zgA8J2ncP2biEguSRJ
# e56Ezx6YpSoRv4d1jS3tpRL+ZFm8yv6We+hodE++0tLsfpUq42Guy3MrGQ2kTIRo
# 7TGLOLpayR8tYmnF0XEHaBiVl7u/Szr7kmOe/CfRG8IZl6UX+/66OqZeyJ12Q3m2
# fe7ZWnpWT5sVp2sJmiuGb3atFXBWKcwNumNuy4JecjQE+7NF8rfIv94NxbBV/WSM
# pKf6Yv9OgzkjY1nRdIS1FBHa88RR55+7Ikh4FIGPBTAibiCEJMc79+b8cdsQGOo4
# ymgbKjGeoRNjtegZ7XE/3TUywBBFMf8NfcjF8REs/HIl7u2RHwRaUTJdAgMBAAGj
# ggJzMIICbzA8BgkrBgEEAYI3FQcELzAtBiUrBgEEAYI3FQiG7sUghM++I4HxhQSF
# hqV1htyhDXuG5sF2wOlDAgFkAgEIMBMGA1UdJQQMMAoGCCsGAQUFBwMDMA4GA1Ud
# DwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBsGCSsGAQQBgjcVCgQOMAwwCgYIKwYB
# BQUHAwMwHQYDVR0OBBYEFOlnnQDHNUpYoPqECFP6JAqGDFM6MB8GA1UdIwQYMBaA
# FICT0Mhz5MfqMIi7Xax90DRKYJLSMIHUBgNVHR8EgcwwgckwgcaggcOggcCGgb1s
# ZGFwOi8vL0NOPUhPVENBS0VYLUNBLENOPUhvdENha2VYLENOPUNEUCxDTj1QdWJs
# aWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9u
# LERDPU5vbkV4aXN0ZW50RG9tYWluLERDPWNvbT9jZXJ0aWZpY2F0ZVJldm9jYXRp
# b25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnQwgccG
# CCsGAQUFBwEBBIG6MIG3MIG0BggrBgEFBQcwAoaBp2xkYXA6Ly8vQ049SE9UQ0FL
# RVgtQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZp
# Y2VzLENOPUNvbmZpZ3VyYXRpb24sREM9Tm9uRXhpc3RlbnREb21haW4sREM9Y29t
# P2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0
# aG9yaXR5MA0GCSqGSIb3DQEBDQUAA4ICAQA7JI76Ixy113wNjiJmJmPKfnn7brVI
# IyA3ZudXCheqWTYPyYnwzhCSzKJLejGNAsMlXwoYgXQBBmMiSI4Zv4UhTNc4Umqx
# pZSpqV+3FRFQHOG/X6NMHuFa2z7T2pdj+QJuH5TgPayKAJc+Kbg4C7edL6YoePRu
# HoEhoRffiabEP/yDtZWMa6WFqBsfgiLMlo7DfuhRJ0eRqvJ6+czOVU2bxvESMQVo
# bvFTNDlEcUzBM7QxbnsDyGpoJZTx6M3cUkEazuliPAw3IW1vJn8SR1jFBukKcjWn
# aau+/BE9w77GFz1RbIfH3hJ/CUA0wCavxWcbAHz1YoPTAz6EKjIc5PcHpDO+n8Fh
# t3ULwVjWPMoZzU589IXi+2Ol0IUWAdoQJr/Llhub3SNKZ3LlMUPNt+tXAs/vcUl0
# 7+Dp5FpUARE2gMYA/XxfU9T6Q3pX3/NRP/ojO9m0JrKv/KMc9sCGmV9sDygCOosU
# 5yGS4Ze/DJw6QR7xT9lMiWsfgL96Qcw4lfu1+5iLr0dnDFsGowGTKPGI0EvzK7H+
# DuFRg+Fyhn40dOUl8fVDqYHuZJRoWJxCsyobVkrX4rA6xUTswl7xYPYWz88WZDoY
# gI8AwuRkzJyUEA07IYtsbFCYrcUzIHME4uf8jsJhCmb0va1G2WrWuyasv3K/G8Nn
# f60MsDbDH1mLtzGCAxgwggMUAgEBMGYwTzETMBEGCgmSJomT8ixkARkWA2NvbTEi
# MCAGCgmSJomT8ixkARkWEkhPVENBS0VYLUNBLURvbWFpbjEUMBIGA1UEAxMLSE9U
# Q0FLRVgtQ0ECEx4AAAAEjzQsNDP/rxMAAAAAAAQwDQYJYIZIAWUDBAIBBQCggYQw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQx
# IgQgSM+0BjWfV/AQCOEEK9Vpmd1UdsdBBJsIaAtmNu0MuMwwDQYJKoZIhvcNAQEB
# BQAEggIAbzsqt3wZp8E+A3IhAUmY9yLn2FuGhYSwIqGHy4vJQwJua1AWuBuJ3fTI
# G6PvTzzatMDw2LxaMhGiszGNejFFF7tAqEExv33b+LgitAkBP+bTljqzE6Iz271A
# w7Pv2PJTtGAyA2kiI2oz0pdA05lugjgxhh99mlyhfNU7ZMKuKDOG8b1KnkFrjVVI
# WpU80mK1SZNCF/f52fy/2e9srxWKTUq0TLAmvyKfsYpZzjIv1Xh3Fdd2rNpAO9F/
# 8Up1YcoqpHTkDyoW77SdYDR/g8bKiSuP+DgvopXpQqAwnDcyGj31a0UnWhrhCRfP
# U2w6Lmd0BRIZXIu/z2IoLapLvpy0+10VRjW2GMuUA1RBlizuiLBO+FqdAdTuW4v9
# tF5xwR/nxTJcyZWDueFZURGEh0keeIJHgC3o3zklW/n2OjFRmclZ3abNH5O81DTa
# BDwlZDoRBV77LxuarOtHh+cITigyGGCNgu5B4wyGWrRqO2XlGGUF9WRdLa20NW1v
# HKTwjImGk30+bH9Rx7kCB7jsJlPaRSJY5d1h/cWz4HED5ibCHk0KAUfXlfM8AJBa
# rHhcJRrE9/UCYWMszf5rq3KGFwcgrRN0kv/SEg0/B1k85v/RbdaNx43cluEXbi+O
# ff8kJgIR0za4FnvQB99FHm6Ln9qGBJbgPN4VjhA1RVYY9vqDgv0=
# SIG # End signature block
