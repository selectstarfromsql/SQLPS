$wql="select label,blocksize,name from win32_volume where filesystem='NTFS'"
get-wmiobject -Query $wql -ComputerName 'den06sql12' | Select-Object label,blocksize,name
