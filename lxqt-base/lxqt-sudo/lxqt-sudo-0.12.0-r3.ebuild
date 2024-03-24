# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit cmake-utils-compat

DESCRIPTION="LXQt GUI frontend for sudo"
HOMEPAGE="http://lxqt.org/"

SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
KEYWORDS="amd64"

LICENSE="LGPL-2.1+"
SLOT="0"

DEPEND="app-admin/sudo
	>=dev-libs/libqtxdg-3.1.0
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	~lxqt-base/liblxqt-${PV}
	"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=( -DPULL_TRANSLATIONS=OFF )
	cmake-utils_src_configure
}
