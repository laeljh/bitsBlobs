
#CHECK SERVER FOR OPEN-RELAY MAIL SERVER
echo('::::::::: OPEN RELAY EMAIL SERVER CHECKER ::::::::: ')
$ports = @(25, 587, 465, 2525, 2526, 110, 995)
#$ports = @(587)
echo('Input the server address:')
#$hostname = 'google.com' - use for debugging
$hostname = Read-Host -Prompt 'Input hostname:'  # Uncomment to allow Input


#initiating an empty dictionary
$open_servers = @{}
#ports list to string conversion
$strports = $ports -join ', ';
#some debuging messages
echo("`nUsing default port list: "+$strports)
echo("Selected hostname: "+$hostname)

try {
	#resolve ip address of a hostname using DNS - stored in list, for cases of more than 1 IP returned
	$host_ip = [System.Net.Dns]::GetHostAddresses($hostname)
	#debug messages
	$host_ips_str = $host_ip -join ', '
	echo("`nResolving IP list from the DNS server...")
	echo("Received "+$host_ip.Length+" IP(s): "+$host_ips_str)
	#cycling through each of the received addresses
	$host_ip | foreach {
			echo("`nUsing IP:"+$_.IPAddressToString)
			#initializing list for open ports
			$open_ports = @()
			#for each address checking each port from the port list
			For ($i=0; $i -lt $ports.Length; $i++){
				echo("`n Testing port: "+$ports[$i])
				$cport=$ports[$i]
				try {
					echo('Trying to connect...')
					$connection = New-Object System.Net.Sockets.TcpClient($_, $cport)
					echo('SUCCESS!!! '+$hostname+" with IP "+$_.IPAddressToString+" has an open mail server port "+$cport)
					#if successful add this port to open_ports list
					$open_ports += $cport
					#echo('added to open ports')

				}
				catch [System.Management.Automation.MethodInvocationException]{
					#echo "Exception caught"
					#echo $_.Exception.GetType().FullName
					#echo "Exception message: "+$_.Exception.Message
					$succes_error = "*A connection attempt failed because the connected party d
				id not properly respond after a period of time, or established connection failed because connected host has failed to r
				espond*"
					if ($_.Exception.Message -ilike "*not properly respond* failed to respond*") {
						echo("Port closed or currently unavailable")
					}
				} 
				catch{
					echo("`nGot other error within expected Exception")
					echo($_.Exception.GetType().FullName)
					echo($_.Exception.Message)
				}
			}
			#add the IP and the complete ports list to the results dictionary if there are any
			if ($open_ports.Length -gt 0){
				$open_servers[$_.IPAddressToString] = $open_ports
				echo("Found the following open ports: "+$($open_ports -join ', ';))
			} else {
				echo("`n ::::::::: NO OPEN EMAIL POSTS FOR CURRENT IP ::::::::: ")
			}
	}
	echo("All IPs and open ports for selected hostname")
	echo($open_servers)
}
catch [System.Management.Automation.MethodInvocationException]{
	echo("Exception caught")
	echo($_.Exception.GetType().FullName)
	#echo "Exception message: "+$_.Exception.Message
	$succes_error = "*A connection attempt failed because the connected party d
	id not properly respond after a period of time, or established connection failed because connected host has failed to r
	espond*"
	if ($_.Exception.Message -ilike "*No such host is known*") {
		echo("Server IP resolution failed, check your connectivity")
	}
} 
catch{
	echo("Got Unexcpected Error:")
	echo($_.Exception.GetType().FullName)
	echo($_.Exception.Message)
}

#TO DO: ADD ABILITIY TO USE HOSTNAME LIST OR FILE
#CREATE A HOSTNAME DICTIONARY THAT FOR EACH HOSTNAME SAVES THE OPEN_SERVERS DICTIONARY
#ALLOW OPTION TO USE CUSTOM PORTS