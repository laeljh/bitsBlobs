This is an email server vulnerability diagnostic tool for powershell 2.0 (work in progress).
I'm writing it as a fun project, as I explore some of powershell scripting capabilities. 
It won't be very intrusive. 

It runs on Windows 7 - 10, needs at least Powershell 2.0 (not tested on any other versions)
Since it relays of dns query to resolve actual email servers and not scan the http host it needs Remote Server Administration Tools.
If your platform is not a Server version of Windows, but a client version e.g Home, Pro, Basic, etc
then you most likely need to download this package. You can get it direclty from microsoft website:
https://www.microsoft.com/en-us/download/confirmation.aspx?id=45520

Acknowledgment: I've rewriten a version of C# code from the website below, to run directly in powershell 
it's included in a separate library in .psm1 format and it's imported into the main script
Link to original script:
https://www.sysadmins.lv/blog-en/test-web-server-ssltls-protocol-support-with-powershell.aspx
