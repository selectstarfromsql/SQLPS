## change the server list 

$servers = gc "C:\Users\ps317387\Desktop\sat 23.txt"

 
    foreach($computer in $servers) 
        { 
 
        $timeZone=Get-WmiObject -Class win32_timezone -ComputerName $computer 
        $localTime = Get-WmiObject -Class win32_localtime -ComputerName $computer 
        $output =@{'ComputerName' = $localTime.__SERVER; 
                    'Time Zone' = $timeZone.Caption; 
                    'Current Time' = (Get-Date -Day $localTime.Day -Month $localTime.Month); 
                   } 
        $object = New-Object -TypeName PSObject -Property $output 
        Write-Output $object 
 
        } 