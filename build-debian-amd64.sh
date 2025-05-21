#!/bin/bash
#
# Virtuosoft build script for Debian 12, AMD64 CPU, QEMU base image for use general in projects.
#

# Check if the CPU architecture indicates an Intel-based Mac
cpu_arch=$(sysctl -n machdep.cpu.brand_string)
if [[ $cpu_arch == *"Intel"* ]]; then
    echo "This is an Intel-based Mac."
else
    echo "This script is only compatible with Intel-based Macs. Exiting..."
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcode-select &> /dev/null; then
    echo "Xcode is not installed. Installing..."
    xcode-select --install
else
    echo "Xcode is already installed."
fi
echo "********************"
echo "Please enter your macOS login password to continue."
echo "********************"

# macOS goof; just need to invoke sudo once prior, yet NOT for brew install
sudo whoami

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# Check if QEMU is installed
if ! brew list --formula | grep -q '^qemu$'; then
    echo "QEMU is not installed. Installing..."
    brew install --force qemu
else
    echo "QEMU is already installed."
fi

# Check if build folder exists
if [ ! -d "build" ]; then
    echo "Creating the build folder..."
    mkdir "build"
    echo "Build folder created!"
else
    echo "Build folder already exists."
fi

# Check if BIOS file already exists
if [ ! -f "build/bios.img" ]; then
    echo "Copying BIOS file..."
    cp /usr/local/share/qemu/bios-256k.bin build/bios.img
else
    echo "BIOS file already copied."
fi

# Check if ISO file already exists
DEBIAN_VERSION="12.11.0"
ISO_FILENAME="debian-$DEBIAN_VERSION-amd64-netinst.iso"
ISO_URL="https://mirrors.ocf.berkeley.edu/debian-cd/$DEBIAN_VERSION/amd64/iso-cd/$ISO_FILENAME"
if [ ! -f "build/$ISO_FILENAME" ]; then
    echo "Downloading Debian ISO..."
    curl -L -o "build/$ISO_FILENAME" "$ISO_URL"

    # Check if file is larger than 100MB
    FILE_SIZE=$(stat -f%z "build/$ISO_FILENAME") # Use macOS compatible stat option
    if [ $FILE_SIZE -gt 100000000 ]; then
        echo "Download complete. File size: $(($FILE_SIZE / 1024 / 1024)) MB"
    else
        echo "Download failed or file size is less ~than expected."
        exit 1
    fi
else
    echo "Debian ISO already downloaded."
fi

## Create the virtual disk images with the max abilitiy of 2TB
if [ -f "build/debian-amd64.img" ]; then
    rm build/debian-amd64.img
fi
qemu-img create -f qcow2 build/debian-amd64.img 2000G
echo "Virtual disk image created!"

# Run QEMU with the following options to start the debian installation process
echo "Booting Debian Linux installer..."
cd build || exit
qemu-system-x86_64 \
        -machine q35,vmport=off -accel hvf \
        -cpu qemu64-v1 \
        -vga virtio \
        -smp cpus=4,sockets=1,cores=4,threads=1 \
        -m 4G \
        -bios bios.img \
        -cdrom $ISO_FILENAME \
        -display default,show-cursor=on \
        -net nic -net user,hostfwd=tcp::8022-:22,hostfwd=tcp::80-:80,hostfwd=tcp::443-:443,hostfwd=tcp::8083-:8083 \
        -drive if=virtio,format=qcow2,file=debian-amd64.img \
        -device virtio-balloon-pci

# Write the version.txt file
echo $DEBIAN_VERSION > version.txt

# Remove prior zip file if it exists
if [ -f "debian-amd64.zip" ]; then
    echo "Removing old zip file..."
    rm debian-amd64.zip
fi

# Compress the image, and bios.img into a zip file
echo "Compressing the image and bios.img into a zip file..."
zip -r debian-amd64.zip debian-amd64.img bios.img version.txt
echo "Compression complete. The zip file is named"
echo "debian-amd64.zip in the build subfolder."

# Remove prior tar.xz file if it exists
if [ -f "debian-amd64.tar.xz" ]; then
    echo "Removing old tar.xz file..."
    rm debian-amd64.tar.xz
fi

# Compress the image and bios.img into a tar.xz file
echo "Compressing the image and bios.img into a tar.xz file..."
tar -cJf debian-amd64.tar.xz debian-amd64.img bios.img version.txt
echo "Compression complete. The tar.gz file is named"
echo "debian-amd64.tar.xz in the build subfolder."
cd ..
