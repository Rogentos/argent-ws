# Copyright 2004-2013 Sabayon Linux
# Copyright 2013-2024 Argent
# Distributed under the terms of the GNU General Public License v2

EAPI=8

K_ROGKERNEL_SELF_TARBALL_NAME="argent"
K_REQUIRED_LINUX_FIRMWARE_VER="20250109"
K_ROGKERNEL_FORCE_SUBLEVEL="9"
K_ROGKERNEL_FORCE_UPPERLEVEL="6.12"
K_ROGKERNEL_PATCH_UPSTREAM_TARBALL="0"

_ver="${K_ROGKERNEL_FORCE_UPPERLEVEL}"
K_KERNEL_NEW_VERSIONING="1"

K_MKIMAGE_RAMDISK_ADDRESS="0x81000000"
K_MKIMAGE_RAMDISK_ENTRYPOINT="0x00000000"
K_MKIMAGE_KERNEL_ADDRESS="0x80008000"

inherit argent-kernel

KEYWORDS="amd64 x86"
DESCRIPTION="Official Argent Linux Standard kernel image"
RESTRICT="mirror"
