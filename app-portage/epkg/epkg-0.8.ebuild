# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="7"

inherit  git-r3

DESCRIPTION="A simple portage wrapper which works like other package managers"
HOMEPAGE="http://rogentos.ro"

EGIT_BRANCH=master
EGIT_REPO_URI="https://gitlab.com/argent/epkg.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="app-portage/gentoolkit
		app-portage/portage-utils
		sys-apps/coreutils
		sys-apps/portage"

src_install() {
	dobin epkg
	dodir /usr/$(get_libdir)/${PN}
	insinto /usr/$(get_libdir)/${PN}
	doins ${S}/libepkg
}
