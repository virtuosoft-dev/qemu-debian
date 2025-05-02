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

## Running Debian Linux
Running the build for testing can be accomplished using the following platform specific commands; note that this will writeback and alter the base image file:

* On macOS with Intel processors
```
qemu-system-x86_64 \
        -machine q35,vmport=off -accel hvf \
        -cpu qemu64-v1 \
        -vga virtio \
        -smp cpus=4,sockets=1,cores=4,threads=1 \
        -m 4G \
        -bios bios.img \
        -display default,show-cursor=on \
        -net nic -net user,hostfwd=tcp::8022-:22,hostfwd=tcp::80-:80,hostfwd=tcp::443-:443,hostfwd=tcp::8083-:8083 \
        -drive if=virtio,format=qcow2,file=debian-amd64.img \
        -device virtio-balloon-pci \
        -device virtio-serial-pci \
        -chardev socket,path=/tmp/qga.sock,server=on,wait=off,id=qga0 \
        -device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0 \
        -nographic
```

* On macOS with Apple Silicon processors
```
qemu-system-aarch64 \
        -machine virt -accel hvf \
        -cpu host \
        -vga none \
        -smp cpus=4,sockets=1,cores=4,threads=1 \
        -m 4G \
        -drive if=pflash,format=raw,file=efi.img,file.locking=off,readonly=on \
        -drive if=pflash,format=raw,file=efi_vars.img \
        -device nec-usb-xhci,id=usb-bus \
        -device virtio-blk-pci,drive=drivedebian-arm64,bootindex=0 \
        -drive if=none,media=disk,id=drivedebian-arm64,file=debian-arm64.img,discard=unmap,detect-zeroes=unmap \
        -device virtio-balloon-pci \
        -device virtio-serial-pci \
        -chardev socket,path=/tmp/qga.sock,server=on,wait=off,id=qga0 \
        -device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0 \
        -net nic -net user,hostfwd=tcp::8022-:22,hostfwd=tcp::80-:80,hostfwd=tcp::443-:443,hostfwd=tcp::8083-:8083 \
        -nographic
```

* On Windows with Intel processors
```
qemu-system-x86_64 ^
        -machine q35,vmport=off -accel whpx,kernel-irqchip=off ^
        -cpu qemu64-v1 ^
        -vga virtio ^
        -smp cpus=4,sockets=1,cores=4,threads=1 ^
        -m 4G ^
        -bios bios.img ^
        -display default,show-cursor=on ^
        -net nic -net user,hostfwd=tcp::8022-:22,hostfwd=tcp::80-:80,hostfwd=tcp::443-:443,hostfwd=tcp::8023-:8023 ^
        -drive if=virtio,format=qcow2,file=devstia-amd64.img ^
        -device virtio-balloon-pci ^
        -device virtio-serial-pci ^
        -chardev socket,path=\\.\pipe\qga,server=on,wait=off,id=qga0 ^
        -device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0 ^
        -nographic
```
