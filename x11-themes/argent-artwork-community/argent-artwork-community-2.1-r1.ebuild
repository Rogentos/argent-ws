# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="7"

DESCRIPTION="Argent Artwork Community"
HOMEPAGE="http://rogentos.ro"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S=${FILESDIR}

src_install() {
	dodir "/usr/share/backgrounds/argent-community" || die
	insinto "/usr/share/backgrounds/argent-community" || die
	doins -r "${S}"/* || die
}
