This script can be used to create management ip addresses and address group along with local in policy.  The local in policy created will use ID 100 for permitting HTTP and HTTPS traffic to the address group created while ID 101 will deny all other traffic.

If using non standard HTTPS port for administrative web access modify the appropriate sections in the vars.tf file.

Modify the vars.tf variable mgmtobj to your required IP's that need access to the FortiGate web interface.

This does require an API admin account and token be created on the FortiGate