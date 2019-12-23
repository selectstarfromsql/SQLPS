## Setup dataset to hold results
$dataset = New-Object System.Data.DataSet
## populate variable with collection of SQL instances
$serverlist='bbgoodlsnr1','den06sql06','den06sql04'
## Setup connection to SQL server inside loop and run T-SQL against instance 
foreach($Server in $serverlist) {
$connectionString = "Provider=sqloledb;Data Source=$Server;Initial Catalog=Master;Integrated Security=SSPI;"
## place the T-SQL in variable to be executed by OLEDB method
$sqlcommand="
IF SERVERPROPERTY ('IsHadrEnabled') = 1
BEGIN
SELECT
   AGC.name
 , RCS.replica_server_name
 , ARS.role_desc
 , AGL.dns_name
 ,ARS.synchronization_health_desc
FROM
 sys.availability_groups_cluster AS AGC
  INNER JOIN sys.dm_hadr_availability_replica_cluster_states AS RCS
   ON
    RCS.group_id = AGC.group_id
  INNER JOIN sys.dm_hadr_availability_replica_states AS ARS
   ON
    ARS.replica_id = RCS.replica_id
  INNER JOIN sys.availability_group_listeners AS AGL
   ON
    AGL.group_id = ARS.group_id
WHERE
 ARS.role_desc = 'PRIMARY'
END
"
## Connect to the data source and open it
$connection = New-Object System.Data.OleDb.OleDbConnection $connectionString
$command = New-Object System.Data.OleDb.OleDbCommand $sqlCommand,$connection
$connection.Open()
## Execute T-SQL command in variable, fetch the results, and close the connection
$adapter = New-Object System.Data.OleDb.OleDbDataAdapter $command
#$dataset = New-Object System.Data.DataSet
[void] $adapter.Fill($dataSet)
$connection.Close()
}
## Return all of the rows from dataset object
$dataSet.Tables | FT -AutoSize