#!/bin/bash
set -e # Exit on error

TARGET_BOOTDEVICE="${1}"

disk=/dev/"${TARGET_BOOTDEVICE}"
out=../../../../out/target/product/nicepool

# Wipe disk once
sgdisk -Z "$disk"
sgdisk -o "$disk" # Ensure a fresh GPT table

echo "Creating partitions..."

# Combined sgdisk calls: n=new, t=type, c=name
sgdisk \
  --new=1:4M:+1G    --typecode=1:0700 --change-name=1:boot \
  --new=2:0:+100M   --typecode=2:8300 --change-name=2:metadata \
  --new=3:0:+100M   --typecode=3:8300 --change-name=3:vbmeta \
  --new=4:0:+3G     --typecode=4:a006 --change-name=4:super \
  --new=5:0:0       --typecode=5:8300 --change-name=5:userdata \
  "$disk"

# CRITICAL: Wait for the OS to create the /dev/sdjX nodes
udevadm settle
partprobe "$disk"

# Now format/flash
echo "Formatting and Flashing..."

# boot
umount "${disk}1" 2>/dev/null || true
mkfs.vfat "${disk}1"
mkdir -p /tmp/1
mount "${disk}1" /tmp/1
cp "$out"/boot.img /tmp/1/recovery.img
cp "$out"/dtb.img /tmp/1/
umount /tmp/1

# metadata
umount "${disk}2" 2>/dev/null || true
mkfs.ext4 -F -F -O ^metadata_csum "${disk}2"

# vbmeta
dd if="$out"/vbmeta.img of="${disk}3" status=progress
udevadm settle
partprobe "$disk"
sgdisk --change-name=3:vbmeta "$disk"
udevadm settle
partprobe "$disk"

# super (Ensure simg2img is installed)
simg2img "$out"/super.img "${disk}4"
udevadm settle
partprobe "$disk"
sgdisk --change-name=4:super "$disk"
udevadm settle
partprobe "$disk"

# userdata
mkfs.ext4 -F -F -O ^metadata_csum "${disk}5"

echo "Done!"


