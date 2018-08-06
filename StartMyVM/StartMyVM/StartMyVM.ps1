#
# StartMyVM.ps1 - continue retry until the VM get started. Please run Login-AzureRmAccount first.
#
Param(
    [Parameter(Mandatory=$True)][string]$ResourceGroupName,
    [Parameter(Mandatory=$True)][string]$Name
)

$i = 1

while ($status -ne "VM running")
{
    $vm = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $Name -Status
    $status = ($vm.Statuses | ?{$_.Code -like "PowerState*"}).DisplayStatus

    if ($status -ne "VM running")
    {
        $timestamp = ('[' + (Get-Date -Format hh:mm:ss.ff) + '] ')
        Write-Host ($timestamp + "Trying to start the VM " + $Name + ". Number of attempts: " + $i)
        $i++
        $vm | Start-AzureRmVM
        sleep -Seconds 5
    }
}
