# Copyright 1999-2015 Gentoo Foundation
# Copyright 2015-2025 Argent Linux Developers
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

inherit 

DESCRIPTION="Argent Linux 3.0 branding component for Calamares"
HOMEPAGE="http://rogentos.ro"
SRC_URI="http://pkgwork.argentlinux.io/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="app-admin/calamares"

PATCHES=(
	"${FILESDIR}/adjust-calamares-urls-${PV}.patch"
)

src_install() {
	dodir /etc/calamares/branding/argent_branding || die
	insinto /etc/calamares/branding/argent_branding || die
	doins -r "${S}"/* || die
}