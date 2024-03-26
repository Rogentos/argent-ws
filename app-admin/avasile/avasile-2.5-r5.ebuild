# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="7"

inherit git-r3

DESCRIPTION="Versatile Advanced Script for ISO and Latest Enchantments"
HOMEPAGE="http://rogentos.ro"

EGIT_BRANCH="argent"
EGIT_REPO_URI="https://gitlab.com/rogentos/vasile.git"

LICENSE="GPL-2"
SLOT="0/2.4"
KEYWORDS="amd64"
IUSE="server"

DEPEND="
	sys-fs/squashfs-tools
	sys-boot/grub:2
	dev-libs/libisoburn
	sys-fs/mtools"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-server.patch"
)

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe "${S}"/"${PN}"
	dodir /lib64/"${PN}"
	insinto /lib64/"${PN}"
	doins "${S}/libavasile"
}
