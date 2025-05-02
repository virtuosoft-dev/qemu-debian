## Install Debian Linux
Install Debian Linux with the following options:

* Select 'Install' (NOT Graphical Install).
* Select 'English'.
* Select 'United States'.
* Select 'American English' for the keyboard.

* Enter the suggested hostname 'debian'
* Enter 'local' for the domain name
* Leave the root user with an empty password
* Confirm by leaving root user password empty
* Enter 'debian' for the full name of the new user
* Leave the username value of 'debian'
* Enter 'debian' for the password
* Re-enter 'debian' to confirm

The installer will then configure the clock; Virtuosoft’s corporate office and support is based in California, USA. To maintain compatibility with optional SaaS services in our projects, be sure to select 'Pacific' for the timezone by continuing with the following:

* Press arrow down 3 times to select the 'Pacific' timezone, then enter to continue.

The installer will then continue loading additional components. It will eventually start up the disk partitioner. We've allowed a generous default filesystem of up to 2 terabytes. The initial allocated space will be less than 2 gigabytes and will only grow as needed. Please be sure to answer the following:

* Select 'Guided - use entire disk'
* Select 'Virtual disk 1 (vda) - 2.1 TB Virtio Block Device'
* Select 'All files in one partition (recommended for new users)'
* Select 'Finish partitioning and write changes to disk'
* Select 'Yes' by pressing tab, then enter, to write changes to disk.

After installing the base system, continue the installer with:

* Select 'No' to the question 'Scan extra installation media?'
* Select 'United States' for the Debian archive mirror country
* Select 'deb.debian.org' for the Debian archive mirror
* Leave the HTTP proxy information blank, just press tab, then press enter to continue.
* Answer 'No' to the 'Configuring popularity-contest'

After the installer finishes configuring apt, it will ask about software selection; do not select any additional options; the default *should only be* **SSH server** and **standard system utilities** are selected and needed at this time. Uncheck 'Debian desktop environment' and 'GNOME' if checked by using the arrow keys and spacebar to select/unselect them.

* Make sure 'Software selection' is only 'SSH server' and 'standard system utilities', then press tab, and press enter to continue.

When the installer completes software installtion, it will continue with asking to install the GRUB boot loader, select Yes to continue and select the listed device, '/dev/vda'.

* At the finish the installation prompt, simply press enter to continue.

The installer will complete and start booting the operating system with the prompt "Booting 'Debian GNU/Linux'".

* At the login prompt login with the credentials login: debian, password: debian.
* Shutdown the machine via the command:
```
sudo poweroff
```

After machine powers off, the build script will continue to compress the image file along with relevant bios/efi image files into a single zip in your build folder (debian-arm64.zip or debian-amd64.zip). These prebuild archives can be found in the releases tab at https://github.com/virtuosoft-dev/qemu-debian/releases.
