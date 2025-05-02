# qemu-debian
This repo is used to build cross architecture (AMD64/ARM64) Debian 12 QEMU base images for download and general use in other projects. Within this repo you will find instructions and helper scripts to produced the archive images (debian-arm64.img and debian-amd64.img) that are made available as assets in the releases section. Also within each archive file are bundled bios or efi image files required for launching on AMD/Intel/ARM64/AppleSilicon CPU architectures. These files are produced for compatibility and near-native performance on Windows/macOS host systems. Release version numbers correspond with the Debian release numbers (i.e. v12.10.0 for Debian 12.10.0, etc). Archive files are in offered in both .zip and .tar.xz formats for speed or high compression applications.

Each image is designed with the following:

* English/United States
* Hostname `debian` and domain name `local`
* Default to Pacific timezone (our corporate headquarters)
* Generous default hard drive allocation (2TB)
* Default username (`debian`) and /password (`debian`) with sudo privileges
* Only SSH Server and standard system utilities software

That's it!

Build instructions and shell scripts are designed to run on Intel and Apple Silicon based macOS; resulting images can be run anywhere (Windows, Linux, macOS). 

## Build Instructions
1) Start by cloning this repo [via git](https://git-scm.com) to a local folder, followed by changing directories to that folder:
```
git clone https://github.com/virtuosoft-dev/qemu-debian
cd qemu-debian
```

2) Next, execute the given shell script from Terminal.app based on your native CPU architecture:

* macOS x64
```
source ./build-debian-amd64.sh
```
* macOS M1
```
source ./build-debian-arm64.sh
```

3) Follow the instructions for **[Install Debian Linux](install-debian-linux.md)**
