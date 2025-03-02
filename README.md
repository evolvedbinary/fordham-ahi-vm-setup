# Fordham University - AHI (Applied Health Informatics) - Virtual Machine

The following instructions will enable you to setup two things:

1. An [Apache Guacamole](https://guacamole.apache.org/) server that will provide a website for accessing remote machines through a Web Browser.

2. One or More Virtual Machines configured with all of the software required for the purpose of teaching the AHI MSc.

## Obtaining Servers

This can be setup either in [AWS EC2](https://aws.amazon.com/ec2/), or another Virtual Environment such as KVM running on a Linux Server.
The environment (which provided 1x Guacamole Server, and 15x AHI Virtual Machines) and that was used for the 2024 Cohort of the AHI MSc at Fordham University was Ubuntu 24.04 running on a bare-metal server leased via [Evolved Binary](https://www.evolvedbinary.com) from [Hetzner](https://www.hetzner.com/) in Germany, with the following configuration:
* Xeon E5-1650 v3 @ 3.50GHz (6 Cores / 12 Threads)
* 128 GB RAM
* 2x 480GB SSD in RAID 1

Below we detail two options for setting up Virtual Machines: 1. Hetzner bare-metal server, and 2. AWS EC2.

### 1. Setting up a new Linux KVM VM (optional)

If you have leased a server from someone like Hetzner with Ubuntu 24.04 installed and wish to set this all up using KVM to host your VMs, then on the server (KVM host) you should run the following commands (assuming an Evolved Binary Server in Hetzner):

```shell
git clone --single-branch --branch hetzner https://github.com/adamretter/soyoustart hetzner
cd ~/hetzner

sudo uvt-simplestreams-libvirt sync --source=http://cloud-images.ubuntu.com/minimal/releases arch=amd64 release=noble
```

As IPv4 addresses are becoming less available and therefore more expensive, you can setup either:

	1. A VM with a Public IPv6 Address and Private IPv4
		This can be directly accessible over IPv6 and on the Internet.
		If you wish to access it via IPv4 over the Internet you will need to setup some sort of NAT and/or Port Forwarding from another machine that has a Public IPv4 address, see: [Optional - IPv4 Port Forwarding](#optional---ipv4-port-forwarding).

	2. A VM with a Public IPv6 Address and Public IPv4
		This can be directly accessible over IPv6 and IPv4 on the Internet.

#### Option 1 - VM with Public IPv6 and Private IPv4

```shell
./create-uvt-kvm.sh --hostname fordham-ahi-01 --release noble --memory 8192 --disk 30 --cpu-model host-passthrough --cpu 4 --bridge virbr1 --ip6 2a01:4f8:140:91f0::201 --gateway6 2a01:4f8:140:91f0::2 --dns 2a01:4ff:ff00::add:1 --dns 2a01:4ff:ff00::add:2 --dns-search evolvedbinary.com --private-1-bridge virbr0 --private-1-ip 192.168.122.201 --private-1-next-network 0.0.0.0/0 --private-1-gateway 192.168.122.1 --private-1-dns 185.12.64.1 --private-1-dns 185.12.64.2 --private-1-dns-search evolvedbinary.com --private-2-bridge virbr2 --private-2-ip 10.0.55.201 --private-2-next-network 10.0.1.254/32 --private-2-gateway 10.0.55.254 --auto-start
```

**NOTE**: There is an issue at the moment with the 2nd private interface not being activated until the VM is shutdown and re-launched. So before you login to the VM fo rthe first time, please wait a few minutes so the VM finishes starting up, and then run:

```shell
virsh shutdown fordham-ahi-01
```

You should then check the status of the VM until it is shutdown. You can do that by running: `virsh domstate cityehr-work-01`. When the state is `shut off`, you can then restart the VM by running:

```shell
virsh fordham-ahi-01
```

**NOTE**: The VM specific settings are:
* `--hostname` `fordham-ahi-01`
* `--ip6` `2a01:4f8:140:91f0::201`
* `--private-1-ip` `192.168.122.201` (IANA Private)

**NOTE**: The network settings specific to the host are:
* `--bridge` `virbr1`
* `--gateway6` `2a01:4f8:140:91f0::2`
* `--private-1-bridge` `virbr0`
* `--gateway` `192.168.122.1` (IANA Private)

**NOTE**: The network settings specific to the hosting provider are:
* `--dns 2a01:4ff:ff00::add:1`, `--dns 2a01:4ff:ff00::add:2`
* `--dns 185.12.64.1`, `--dns 185.12.64.2`

See also: [Optional - IPv4 Port Forwarding](#optional---ipv4-port-forwarding).

#### Option 2 - VM with Public IPv6 and Public IPv4

```shell
./create-uvt-kvm.sh --hostname fordham-ahi --release noble --memory 8192 --disk 30 --cpu-model host-passthrough --cpu 4 --bridge virbr1 --ip 188.40.179.160 --ip6 2a01:4f8:140:91f0::160 --gateway 46.4.100.114 --gateway6 2a01:4f8:140:91f0::2 --dns 2a01:4ff:ff00::add:1 --dns 2a01:4ff:ff00::add:2 --dns 185.12.64.1 --dns 185.12.64.2 --dns-search evolvedbinary.com  --private-1-bridge virbr0 --private-1-ip 192.168.122.160 --private-2-bridge virbr2 --private-2-ip 10.0.55.201 --private-2-next-network 10.0.1.254/32 --private-2-gateway 10.0.55.254 --auto-start
```

**NOTE**: There is an issue at the moment with the 2nd private interface not being activated until the VM is shutdown and re-launched. So before you login to the VM fo rthe first time, please wait a few minutes so the VM finishes starting up, and then run:

```shell
virsh shutdown fordham-ahi
```

You should then check the status of the VM until it is shutdown. You can do that by running: `virsh domstate cityehr-work-01`. When the state is `shut off`, you can then restart the VM by running:

```shell
virsh fordham-ahi
```

**NOTE**: The VM specific settings are:
* `--hostname` `fordham-ahi`
* `--ip6` `2a01:4f8:140:91f0::160`
* `--ip` `188.40.179.160`
* `--private-1-ip` `192.168.122.160` (IANA Private)

**NOTE**: The network settings specific to the host are:
* `--bridge` `virbr1`
* `--gateway6` `2a01:4f8:140:91f0::2`
* `--gateway` `46.4.100.114`

**NOTE**: The network settings specific to the hosting provider are:
* `--dns 2a01:4ff:ff00::add:1`, `--dns 2a01:4ff:ff00::add:2`
* `--dns 185.12.64.1`, `--dns 185.12.64.2`


### 2. Setting up a new AWS EC2 Instance (optional)

If you wish to set this up in AWS EC2, then for each Virtual Machine you need should setup a new EC2 instance with the following properties:

1. Name the instance 'fordham-ahi-01'. (change the `01` as needed for more machines).

2. Select the `Ubuntu Server 24.04 LTS (HVM), SSD Volume Type` AMI image, and the Architecture `amd64`.

3. Select `m6a.large` instance type. (i.e.: 2vCPU, 8GB Memory, 1x237 NVMe SSD, $0.0999 / hour).

4. Select the `fordham-ahi` keypair.

5. Select the `fordham-ahi vm` Security Group.

6. Set the default Root Volume as an `EBS` `30 GiB` volume on `GP3` at `3000 IOPS` and `125 MiB throughput`.


## Installing Guacamole Server

Apache Guacamole provides a web interface for accessing any virtual machine remotely. This is used so that students only need a web-browser. The student accesses Guacamole, and then Guacamole connects them to the remote virtual machine.

Guacamole should be run in its own virtual machine. To install Guacamole and configure it for AHI run the following commands on a new VM:

```shell
git clone https://github.com/evolvedbinary/fordham-ahi-vm-setup.git
cd fordham-ahi-vm-setup
sudo ./install-puppet-agent.sh

cd guacamole

sudo FACTER_default_user_password=mypassword2 \
     /opt/puppetlabs/bin/puppet apply 01-base.pp
```

**NOTE:** you should set your own passwords appropriately above! The `default_user_password` is used for the Linux user that can access the machine, the username is `ubuntu`.

We have to restart the system after the above as it may install a new Kernel and make changes to settings that require a system reboot. So run:

```shell
sudo shutdown -r now
```

After the system restarts and you have logged in, you need to resume from the `fordham-ahi-vm-setup/guacamole` repo checkout:

```shell
cd fordham-ahi-vm-setup/guacamole

sudo FACTER_default_user_password=mypassword2 \
     FACTER_override_custom_user=adam.retter \
	 FACTER_override_custom_user_password=fordham \
     /opt/puppetlabs/bin/puppet apply .
```

**NOTE:** you should set your own passwords appropriately above!

* `default_user_password` this is the password to set for the default linux user on this machine (typically the user is named `ubuntu` on Ubuntu Cloud images).
* `override_custom_user` should be set to the username of the custom user on the remote (AHI workstation) virtual machines that you are trying to access. If not specified, defaults to: `student`.
* `override_custom_user_password` should be set to the password of the custom user on the remote (AHI workstation) virtual machines that you are trying to access. If not specified, defaults to: `student`.

After installation Guacamole's Web Server should be accessible from: [http://localhost:8080](http://localhost:8080), but should be accessible (via an nginx reverse proxy) from: [https://localhost](https://localhost)


## Installing an AHI Workstation

You can install one or more AHI workstations, each should be configured within its own virtual (or physical) machine. We expect to start from a clean Ubuntu Server, or Ubuntu Cloud Image install. This has been tested with Ubuntu version 24.04 LTS (x86_64).

### AHI Software Environment

The following software will be configured:

* Desktop Environment
	* X.org
	* LXQt
	* Chromium
	* Firefox
	* Okular

* Java Development Environment
	* JDK 11
	* JDK 17
	* Apache Maven 3
	* IntelliJ IDEA CE
	* Apache Tomcat 9
	* Quercus

* Python Development Environment
	* Python 3
	* pip3
	* miniconda 3

* Database Environment
	* MariaDB Server and Client
	* MySQL Workbench
	* DBeaver

* cityEHR

* cityEHR Workshop Tools
	* Mirth Connect and Mirth Administrator
	* Oxygen XML Editor
	* LibreOffice
	* Protégé
	* Inkscape
	* GanttProject
	* FreeMind
	* BOUML
	* Modelio

* Visual Studio Code

* Miscellaneous Tools
	* Nullmailer
	* Zsh and OhMyZsh
	* Git
	* cURL
	* wget
	* Screen
	* tar, gzip, bzip2, zstd, zip (and unzip)


### Installing an AHI Workstation

Each AHI Workstation should be run in its own virtual machine. To install an AHI workstation run the following commands on a new VM:

```shell
git clone https://github.com/evolvedbinary/fordham-ahi-vm-setup.git
cd fordham-ahi-vm-setup
sudo ./install-puppet-agent.sh

cd workstation

sudo /opt/puppetlabs/bin/puppet apply 00-locale.pp

sudo FACTER_default_user_password=mypassword \
     /opt/puppetlabs/bin/puppet apply 01-base.pp
```

**NOTE:** you should set your own passwords appropriately above!

* `default_user_password` this is the password to set for the default linux user on this machine (typically the user is named `ubuntu` on Ubuntu Cloud images).

We have to restart the system after the above as it may install a new Kernel and make changes to settings that require a system reboot. So:

```shell
sudo shutdown -r now
```

After the system restarts and you have logged in, you need to resume from the `fordham-ahi-vm-setup/workstation` repo checkout:

```shell
cd fordham-ahi-vm-setup/workstation
sudo FACTER_default_user_password=mypassword \
  FACTER_override_custom_user=adam.retter \
  FACTER_override_custom_user_password=fordham \
  FACTER_mariadb_db_root_password=fordhamahi \
  /opt/puppetlabs/bin/puppet apply .
```

**NOTE:** you should set your own passwords appropriately above!

* `default_user_password` this is the password to set for the default linux user on this machine (typically the user is named `ubuntu` on Ubuntu Cloud images).
* `override_custom_user` this is the username for the linux user account to add to this machine (e.g. for the Student). This should be the part of their Fordham University email address that appears before the `@` sign, e.g. If their email address is `adam.retter@fordham.edu`, then just use `adam.retter`. If not specified, defaults to: `student`.
* `override_custom_user_password` this is a password for the custom user account. If not specified, defaults to: `student`.
* `mariadb_db_root_password` - This is the password to set for the `root` user in MariaDB.

We have to restart the system after the above as it installs a new desktop login manager.

```shell
sudo shutdown -r now
```

After installation you should be able to access this instance using either one of two mechanisms:

1. Directly, by using an RDP (Remote Desktop Protocol) client, e.g. Microsoft Remote Desktop. This approach usually gives the most responsive performance for the user.
	* Clients:
		* **Windows** - run `mstsc.exe`
		* **Mac** - Install and run (Microsoft Remote Desktop](https://apps.apple.com/us/app/microsoft-remote-desktop/id1295203466?mt=12) from the Apple Store.
		* **Linux** - run `rdesktop` (Ubuntu install: `apt-get install -y rdesktop && rdesktop`)
	* Connection Settings:
		* **Host**: The IP address or FQDN of the remote machine (e.g. `fordham-ahi-01.evolvedbinary.com`)
		* **Username**: The part of your Fordham University email address that appears before the `@` sign, e.g. If you email address is `adam.retter@fordham.edu`, then just use `adam.retter`. This is the username you set above for `override_custom_user`.
		* **Password**: *the password you set above for `override_custom_user_password`*


2. Indirectly via the Guacamole website by visiting the website (e.g. [https://fordham-ahi.evolvedbinary.com](https://fordham-ahi.evolvedbinary.com)) in your web browser.
	* Login details:
		* **Username**: Your Fordham University email address, e.g. `adam.retter@fordham.edu`)
		* **Password**: *the password you set above for `override_custom_user_password`*


### Optional - IPv4 Port Forwarding

If you are using Private IPv4 addresses for the Virtual Machines, and you want to connect to them using RDP over IPv4, you will need to port-forward from a Public IPv4 address (perhaps that used on the Guacamole Server) to each VM.

On the host with the Public IPv4 address, edit the the file `/etc/sysctl.conf`, and enable the following:
```
net/ipv4/ip_forward=1
net/ipv6/conf/default/forwarding=1
net/ipv6/conf/all/forwarding=1
```
then run `sudo sysctl -p && sudo sysctl --system`.

On the host with the Public IPv4 address, add the following to the endo fo the file `/etc/ufw/before.rules`:

```
# NAT
*nat :PREROUTING ACCEPT [0:0]
# Port Forward RDP to Fordham AHI VMs
-A PREROUTING -p tcp -i enp1s0 --dport 3390 -j DNAT --to-destination 192.168.122.201:3389
COMMIT
```

Add the following to the end of the file `/etc/ufw/before6.rules`:
```
# NAT
*nat :PREROUTING ACCEPT [0:0]
# Port Forward RDP to Fordham AHI VMs
-A PREROUTING -p tcp -i enp1s0 --dport 3390 -j DNAT --to-destination 2a01:4f8:140:91f0::201:3389
COMMIT
```

The above two changes:
1. Forward TCP port `3390` on the host with the Public IPv4 address to TCP Port `3389` (i.e. RDP) on the host `192.168.122.201`.
2. Forward TCP port `3390` on the host with the Public IPv6 address to TCP Port `3389` (i.e. RDP) on the host `2a01:4f8:140:91f0::201`.
You can add as many rules as you have Virtual Machines.

Then run: 

sudo ufw route allow in on enp1s0 out on enp7s0
sudo ufw route allow in on enp7s0 out on enp1s0

1. `sudo ufw allow in on enp1s0 proto tcp to any port 3390 comment "For Port Forward to 3389 on fordham-ahi-01"`
2. `sudo systemctl restart ufw`
