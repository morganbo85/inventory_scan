# PS script to pull inventory information 
Super Simple ps script to pull inventory information off of a remote user's workstation.

* First it gets the hostname of the machine.
* Then it finds what users are logged in.
* Then it pulls serial numbers from attached monitors
* Then it pulls how much RAM in GB the machine has
* Then it pulls how much free space is on the C drive in GB. # Can edit this to include/exclude other drives
* Saves this into a .txt file under the hostname of the computer on the desktop
* And if you are connected by RDP it will also copy it to your local machine.
    * I use this for a quick scan of their system.

<p>To view the code click here:</p>
 
https://github.com/morganbo85/inventory_scan/blob/main/inventory.ps1

Typically I use this script over an RDP connection.
You will need to edit the file paths to fit your environment.
