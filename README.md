# Avocent DSR console KVM control script

Start Avocent DSR (and other/older Avocent based KVM switches) from the console

Tested on MacOS X 10.14 with Oracle Java ~~1.8.0u151~~ 1.8.0u211 against an Avocent DSR 2030 and its latest firmware from 2016. Should work with older/other models as well, Dell iDRAC support is planned

```
Usage : ./avws.sh <IP> <user> <pass> <kvm-slot>
```

# What we do

Basically we

* log into the WebGUI
* download the JNLP file
* run it with javaws and the required weaker security parameters for newer java versions

# Notes

* once started you will get a untrusted publisher warning which you need to acknowledge.
* if you get a permanent block you will need to add your IP address in the Java Control Panel in the form
```
http://<ip of your KVM switch>
```
