# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit cmake-utils-compat

DESCRIPTION="Various packaging tools and scripts for LXQt applications"
HOMEPAGE="http://lxqt.org/"

SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
KEYWORDS="amd64"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND=""
DEPEND="dev-qt/linguist-tools:5"

src_configure() {
	local mycmakeargs=( -DPULL_TRANSLATIONS=OFF )
	cmake-utils_src_configure
}
