# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit cmake

DESCRIPTION="LXQt PolKit authentication agent"
HOMEPAGE="http://lxqt.org/"

SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
KEYWORDS="amd64"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	~lxqt-base/liblxqt-${PV}
	>=dev-libs/libqtxdg-3.1.0
	sys-auth/polkit-qt[qt5(+)]"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	!lxqt-base/lxqt-common
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=( -DPULL_TRANSLATIONS=OFF )
	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	doman man/*.1
}
