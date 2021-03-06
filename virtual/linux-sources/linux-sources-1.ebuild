# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3

DESCRIPTION="Virtual for Linux kernel sources"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="firmware"

DEPEND="firmware? ( sys-kernel/linux-firmware )"
RDEPEND="sys-kernel/argent-sources
		app-misc/argent-version:2.0"

src_prepare() {
	:
}

src_compile() {
	:
}

src_install() {
	:
}
