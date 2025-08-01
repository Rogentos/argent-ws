# Copyright 2004-2013 Sabayon Linux
# Copyright 2014-2021 Argent, Argent and ArgOS Linux
# Distributed under the terms of the GNU General Public License v2

EAPI=8

K_ROGKERNEL_FORCE_SUBLEVEL="9"
K_ROGKERNEL_FORCE_UPPERLEVEL="6.12"
K_ROGKERNEL_NAME="argent"
K_ROGKERNEL_URI_CONFIG="yes"
K_ROGKERNEL_SELF_TARBALL_NAME="argent"
K_ONLY_SOURCES="1"
K_KERNEL_NEW_VERSIONING="1"

inherit argent-kernel

KEYWORDS="amd64 ~arm x86"
DESCRIPTION="Official Argent Linux Standard kernel sources"
RESTRICT="mirror"
IUSE="grub2 sources_standalone"

DEPEND="${DEPEND}
	sources_standalone? ( !=sys-kernel/linux-argent-${PVR} )
	!sources_standalone? ( =sys-kernel/linux-argent-${PVR} )"
