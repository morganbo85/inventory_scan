# Script to Pull Computer information For Updating Inventory
# 2023/08/22
# bmorgan
# Recomend you run as admin

# Sets the hostname for WS it is running on.
$hostname=hostname
Function Get-MonitorInfo
{
    [CmdletBinding()]
    Param
    (
        [Parameter(
        Position=0,
        ValueFromPipeLine=$true,
        ValueFromPipeLineByPropertyName=$true)]
        [alias("CN","MachineName","Name","Computer")]
        [string[]]$ComputerName = $ENV:ComputerName
    )

    Begin {
        $pipelineInput = -not $PSBoundParameters.ContainsKey('ComputerName')
    }

    Process
    {
        Function DoWork([string]$ComputerName) {
            $ActiveMonitors = Get-WmiObject -Namespace root\wmi -Class wmiMonitorID -ComputerName $ComputerName
            $monitorInfo = @()

            foreach ($monitor in $ActiveMonitors)
            {
                $mon = $null

                $mon = New-Object PSObject -Property @{
                ManufacturerName=($monitor.ManufacturerName | % {[char]$_}) -join ''
                ProductCodeID=($monitor.ProductCodeID | % {[char]$_}) -join ''
                SerialNumberID=($monitor.SerialNumberID | % {[char]$_}) -join ''
                UserFriendlyName=($monitor.UserFriendlyName | % {[char]$_}) -join ''
                ComputerName=$ComputerName
                WeekOfManufacture=$monitor.WeekOfManufacture
                YearOfManufacture=$monitor.YearOfManufacture}

                $monitorInfo += $mon
            }
            Write-Output $monitorInfo
        }

        if ($pipelineInput) {
            DoWork($ComputerName)
        } else {
            foreach ($item in $ComputerName) {
                DoWork($item)
            }
        }
    }
}


# Creates Direcory to story log file
# Edite for your environment 
mkdir "<path\to\>$hostname"
Start-Transcript -Path <path\to\>\$hostname\$hostname.txt 
query user # List users logged in, Hopeully the primary user


echo .
echo .
wmic bios get serialnumber # Pulls the SN for WS

echo .

Get-PSDrive C

echo RAM 
(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb

Get-MonitorInfo
# Pulls Info on attached Monitors
# Older monitors somtimes give an null arrary error
#$monitors = Get-CimInstance WmiMonitorID -Namespace root\wmi
#foreach ($monitor in $monitors) {
#    [System.Text.Encoding]::ASCII.GetString($monitor.ManufacturerName)
#	[System.Text.Encoding]::ASCII.GetString($monitor.ProductCodeID)
#    [System.Text.Encoding]::ASCII.GetString($monitor.SerialNumberID)
#    [System.Text.Encoding]::ASCII.GetString($monitor.UserFriendlyName)
#}

Stop-Transcript

# Moves the log file to my computer
# Only works when connected to RDP
# Leave commented out so rest of script will run.

echo A | xcopy <path\to\$hostname.txt> C:\Users\<example>\Desktop\ # Copy to Desktop for quick viewing

move <path\to\$hostname.txt> \\tsclient\C\<example user>\Inventory -Force # moves copy to a local folder when connected by RDP

# Removes the log directory after copying to my machine
rm -r <path\to>\$hostname
