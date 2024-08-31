# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"
PYTHON_COMPAT=( python3_5 )

inherit  cmake-utils python-r1

SRC_URI="https://github.com/calamares/calamares/releases/download/v${PV}/${P}.tar.gz"

DESCRIPTION="Distribution-independent installer framework"
HOMEPAGE="http://calamares.io"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="+python"

S="${WORKDIR}/${P}"

DEPEND="
	python? (
		>=dev-libs/boost-1.55.0-r2[python_targets_python3_5]
	)
	>=dev-qt/designer-5.6.0:5
	>=dev-qt/linguist-tools-5.6.0:5
	>=dev-qt/qtconcurrent-5.6.0:5
	>=dev-qt/qtcore-5.6.0:5
	>=dev-qt/qtdbus-5.6.0:5
	>=dev-qt/qtdeclarative-5.6.0:5
	>=dev-qt/qtgui-5.6.0:5
	>=dev-qt/qtnetwork-5.6.0:5
	>=dev-qt/qtopengl-5.6.0:5
	>=dev-qt/qtprintsupport-5.6.0:5
	>=dev-qt/qtscript-5.6.0:5
	>=dev-qt/qtsvg-5.6.0:5
	>=dev-qt/qttest-5.6.0:5
	>=dev-qt/qtwebengine-5.6.0:5
	>=dev-qt/qtwebchannel-5.6.0:5
	>=dev-qt/qtwidgets-5.6.0:5
	>=dev-qt/qtxml-5.6.0:5
	>=dev-qt/qtxmlpatterns-5.6.0:5
	>=dev-cpp/yaml-cpp-0.5.1
	>=kde-frameworks/extra-cmake-modules-5.18.0
	>=sys-libs/kpmcore-3.0.2"

RDEPEND=">=app-misc/calamares-runtime-1.0[branding]"

src_prepare() {
	# build against kpmcore-3.2
	epatch "${FILESDIR}"/${PN}-kpmcore-3.2.patch
	# don't run locale-gen during system installation, we run it ourselves during stage4 bootstrap...this patch should speed up installation significantly
	epatch "${FILESDIR}"/${PN}-dont-run-locale-gen.patch
	# support auto-unlocking encrypted partitions via OpenRC's dmcrypt service
	epatch -p1 "${FILESDIR}"/${PN}-openrc-dmcrypt-cfg-r1.patch
	# replace calamares installer desktop icon
	sed -i "s/Icon=calamares/Icon=start-here/g" "${S}/calamares.desktop"
	# fix installer doesn't start from desktop launcher (IMPROVE THIS UGLY THINGY)
	sed -i "s/pkexec //g" "${S}/calamares.desktop"
	sed -i "s/calamares/calamares-pkexec/g" "${S}/calamares.desktop"
	# If qtchooser is installed, it may break the build, because moc,rcc and uic binaries for wrong qt version may be used.
	# Setting QT_SELECT environment variable will enforce correct binaries (fix taken from vlc ebuild)
	export QT_SELECT=qt5
}

src_configure() {
	local mycmakeargs=(
		-DWITH_PARTITIONMANAGER=1
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	insinto /usr/bin
	insopts -m 755
	doins ${FILESDIR}/calamares-pkexec
}
